import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';

import '../../../core/database/app_database.dart';
import '../../../core/database/transaction_queries.dart';
import '../../../core/dates.dart';
import '../../../core/money/money.dart';
import '../../../core/providers.dart';
import '../../../core/theme/app_theme.dart';
import '../../../core/ui/amount_field.dart';
import '../../../core/ui/category_icons.dart';
import '../../../core/ui/motion.dart';

class LoggedTx {
  const LoggedTx({
    required this.id,
    required this.type,
    required this.amountKobo,
    required this.categoryName,
  });

  final int id;
  final TxType type;
  final int amountKobo;
  final String categoryName;
}

Future<LoggedTx?> showQuickAdd(
  BuildContext context, {
  TxType initialType = TxType.expense,
}) =>
    showModalBottomSheet<LoggedTx>(
      context: context,
      isScrollControlled: true,
      useSafeArea: true,
      showDragHandle: true,
      builder: (_) => QuickAddSheet(initialType: initialType),
    );

class QuickAddSheet extends ConsumerStatefulWidget {
  const QuickAddSheet({super.key, required this.initialType});
  final TxType initialType;

  @override
  ConsumerState<QuickAddSheet> createState() => _QuickAddSheetState();
}

class _QuickAddSheetState extends ConsumerState<QuickAddSheet> {
  late TxType _type = widget.initialType;
  String _digits = '';
  int? _categoryId;
  final _note = TextEditingController();
  bool _showNote = false;
  DateTime _day = dateOnly(DateTime.now());
  List<int> _recent = const [];
  bool _saving = false;
  String? _error;

  @override
  void initState() {
    super.initState();
    _loadRecent();
  }

  @override
  void dispose() {
    _note.dispose();
    super.dispose();
  }

  Future<void> _loadRecent() async {
    final ids = await ref.read(databaseProvider).recentCategoryIds(_type);
    if (mounted) setState(() => _recent = ids);
  }

  int get _amountKobo => _digits.isEmpty ? 0 : int.parse(_digits) * 100;

  void _press(String key) {
    final next = key == 'del'
        ? (_digits.isEmpty ? '' : _digits.substring(0, _digits.length - 1))
        : (_digits + key).replaceFirst(RegExp(r'^0+'), '');
    if (next.length > 8 ||
        (next.isNotEmpty && int.parse(next) * 100 > maxAmountKobo)) {
      HapticFeedback.heavyImpact();
      return;
    }
    setState(() => _digits = next);
  }

  void _clear() {
    HapticFeedback.mediumImpact();
    setState(() => _digits = '');
  }

  void _switchType(TxType t) {
    if (t == _type) return;
    setState(() {
      _type = t;
      _categoryId = null;
      _recent = const [];
    });
    _loadRecent();
  }

  Future<void> _pickDay() async {
    final today = dateOnly(DateTime.now());
    final picked = await showDatePicker(
      context: context,
      initialDate: _day,
      firstDate: DateTime(today.year - 1, today.month, today.day),
      lastDate: today,
    );
    if (picked != null) setState(() => _day = picked);
  }

  String _dayLabel() {
    final diff = daysBetween(_day, DateTime.now());
    if (diff == 0) return 'Today';
    if (diff == 1) return 'Yesterday';
    return DateFormat('EEE d MMM').format(_day);
  }

  String _saveLabel(BudgetCategory? cat) {
    if (_amountKobo == 0) return 'Enter an amount';
    if (cat == null) return 'Pick a category';
    return _type == TxType.expense
        ? 'Save ${formatNaira(_amountKobo)} to ${cat.name}'
        : 'Add ${formatNaira(_amountKobo)} from ${cat.name}';
  }

  Future<void> _save(BudgetCategory cat) async {
    if (_saving || _amountKobo <= 0) return;
    setState(() {
      _saving = true;
      _error = null;
    });
    final now = DateTime.now();
    final when = daysBetween(_day, now) == 0
        ? now
        : DateTime(_day.year, _day.month, _day.day, 12);
    final note = _note.text.trim();
    try {
      final id = await ref.read(databaseProvider).addTransaction(
            type: _type,
            amountKobo: _amountKobo,
            categoryId: cat.id,
            note: note.isEmpty ? null : note,
            occurredAt: when,
          );
      HapticFeedback.mediumImpact();
      if (!mounted) return;
      Navigator.pop(
        context,
        LoggedTx(
          id: id,
          type: _type,
          amountKobo: _amountKobo,
          categoryName: cat.name,
        ),
      );
    } catch (_) {
      if (!mounted) return;
      setState(() {
        _saving = false;
        _error = 'Couldn’t save. Please try again.';
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final text = theme.textTheme;
    final scheme = theme.colorScheme;
    final k = context.koboColors;
    final isIncome = _type == TxType.income;

    final cats = switch (ref.watch(
        isIncome ? incomeCategoriesProvider : expenseCategoriesProvider)) {
      AsyncData(:final value) => value,
      _ => const <BudgetCategory>[],
    };
    final byId = {for (final c in cats) c.id: c};
    final recent = [
      for (final id in _recent)
        if (byId[id] != null) byId[id]!,
    ];
    final selected = byId[_categoryId];
    final canSave = _amountKobo > 0 && selected != null && !_saving;

    Widget chip(BudgetCategory c) => ChoiceChip(
          avatar: Icon(iconFor(c.iconKey), size: 18, color: Color(c.colorValue)),
          label: Text(c.name),
          selected: _categoryId == c.id,
          showCheckmark: false,
          onSelected: (_) {
            HapticFeedback.selectionClick();
            setState(() => _categoryId = c.id);
          },
        );

    final muted = text.labelMedium?.copyWith(color: scheme.onSurfaceVariant);

    return Padding(
      padding: EdgeInsets.only(bottom: MediaQuery.viewInsetsOf(context).bottom),
      child: SingleChildScrollView(
        padding: const EdgeInsets.fromLTRB(20, 0, 20, 16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            SegmentedButton<TxType>(
              showSelectedIcon: false,
              segments: const [
                ButtonSegment(
                  value: TxType.expense,
                  label: Text('Spent'),
                  icon: Icon(Icons.north_east_rounded),
                ),
                ButtonSegment(
                  value: TxType.income,
                  label: Text('Received'),
                  icon: Icon(Icons.south_west_rounded),
                ),
              ],
              selected: {_type},
              onSelectionChanged: (s) => _switchType(s.first),
            ),
            const SizedBox(height: 18),
            Center(
              child: FittedBox(
                fit: BoxFit.scaleDown,
                child: Text(
                  formatNaira(_amountKobo),
                  style: text.amount(
                    60,
                    color: _digits.isEmpty
                        ? scheme.onSurface.withValues(alpha: 0.22)
                        : (isIncome ? k.good : scheme.onSurface),
                  ),
                ),
              ),
            ),
            const SizedBox(height: 18),
            if (recent.isNotEmpty) ...[
              Text('Recent', style: muted),
              const SizedBox(height: 8),
              _ChipRow(children: [for (final c in recent) chip(c)]),
              const SizedBox(height: 14),
            ],
            Text(isIncome ? 'Where it came from' : 'What it was for',
                style: muted),
            const SizedBox(height: 8),
            _TwoRowScroller(children: [for (final c in cats) chip(c)]),
            const SizedBox(height: 12),
            Row(
              children: [
                ActionChip(
                  avatar: const Icon(Icons.event_rounded, size: 18),
                  label: Text(_dayLabel()),
                  onPressed: _pickDay,
                ),
                const SizedBox(width: 8),
                if (!_showNote)
                  ActionChip(
                    avatar: const Icon(Icons.notes_rounded, size: 18),
                    label: const Text('Add note'),
                    onPressed: () => setState(() => _showNote = true),
                  ),
              ],
            ),
            if (_showNote) ...[
              const SizedBox(height: 8),
              TextField(
                controller: _note,
                autofocus: true,
                maxLength: 200,
                textCapitalization: TextCapitalization.sentences,
                decoration: koboInputDecoration(
                  context,
                  hint: isIncome
                      ? 'e.g. from Mum'
                      : 'e.g. jollof at the cafeteria',
                ).copyWith(counterText: ''),
              ),
            ],
            const SizedBox(height: 12),
            _Keypad(onKey: _press, onClear: _clear),
            if (_error != null) ...[
              const SizedBox(height: 8),
              Text(_error!, style: text.bodySmall?.copyWith(color: scheme.error)),
            ],
            const SizedBox(height: 12),
            FilledButton(
              style: isIncome
                  ? FilledButton.styleFrom(
                      backgroundColor: k.good,
                      foregroundColor: Colors.white,
                    )
                  : null,
              onPressed: canSave ? () => _save(selected) : null,
              child: Text(_saveLabel(selected)),
            ),
          ],
        ),
      ),
    );
  }
}

class _ChipRow extends StatelessWidget {
  const _ChipRow({required this.children});
  final List<Widget> children;

  @override
  Widget build(BuildContext context) => SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: Row(
          children: [
            for (var i = 0; i < children.length; i++) ...[
              if (i > 0) const SizedBox(width: 8),
              children[i],
            ],
          ],
        ),
      );
}

/// Categories in two rows that scroll sideways, so they take little height.
class _TwoRowScroller extends StatelessWidget {
  const _TwoRowScroller({required this.children});
  final List<Widget> children;

  @override
  Widget build(BuildContext context) {
    final half = (children.length + 1) ~/ 2;
    Widget row(List<Widget> items) => Row(
          children: [
            for (var i = 0; i < items.length; i++) ...[
              if (i > 0) const SizedBox(width: 8),
              items[i],
            ],
          ],
        );
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          row(children.sublist(0, half)),
          const SizedBox(height: 8),
          row(children.sublist(half)),
        ],
      ),
    );
  }
}

class _Keypad extends StatelessWidget {
  const _Keypad({required this.onKey, required this.onClear});

  final ValueChanged<String> onKey;
  final VoidCallback onClear;

  static const _rows = [
    ['1', '2', '3'],
    ['4', '5', '6'],
    ['7', '8', '9'],
    ['00', '0', 'del'],
  ];

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;

    Widget key(String k) {
      final face = Pressable(
        onTap: () => onKey(k),
        scale: 0.94,
        child: Container(
          height: 56,
          margin: const EdgeInsets.all(4),
          alignment: Alignment.center,
          decoration: BoxDecoration(
            color: scheme.surfaceContainer,
            borderRadius: BorderRadius.circular(16),
          ),
          child: k == 'del'
              ? const Icon(Icons.backspace_outlined, semanticLabel: 'Delete')
              : Text(k, style: displayStyle(24, weight: 650)),
        ),
      );
      return Expanded(
        child: k == 'del'
            ? GestureDetector(onLongPress: onClear, child: face)
            : face,
      );
    }

    return Column(
      children: [
        for (final row in _rows) Row(children: [for (final k in row) key(k)]),
      ],
    );
  }
}
