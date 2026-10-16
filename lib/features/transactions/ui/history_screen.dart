import 'package:flutter/material.dart';
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
import '../history_providers.dart';
import 'tx_tile.dart';

class HistoryScreen extends ConsumerStatefulWidget {
  const HistoryScreen({super.key});

  @override
  ConsumerState<HistoryScreen> createState() => _HistoryScreenState();
}

class _HistoryScreenState extends ConsumerState<HistoryScreen> {
  final _search = TextEditingController();

  /// Rows swiped away, hidden until the database stream catches up.
  final Set<int> _hidden = {};

  @override
  void dispose() {
    _search.dispose();
    super.dispose();
  }

  void _clearAll() {
    _search.clear();
    ref.read(historyFilterProvider.notifier).clear();
  }

  Future<void> _delete(Txn t) async {
    final messenger = ScaffoldMessenger.of(context);
    final db = ref.read(databaseProvider);
    setState(() => _hidden.add(t.id));
    await db.deleteTransaction(t.id);
    messenger.hideCurrentSnackBar();
    messenger.showSnackBar(SnackBar(
      content: Text('Deleted ${formatNaira(t.amountKobo)}'),
      action: SnackBarAction(
        label: 'Undo',
        onPressed: () async {
          await db.restoreTransaction(t);
          if (mounted) setState(() => _hidden.remove(t.id));
        },
      ),
    ));
  }

  Future<void> _pickCategory(
      Map<int, BudgetCategory> all, TxType? type) async {
    final kind = type == null
        ? null
        : (type == TxType.expense ? CategoryKind.expense : CategoryKind.income);
    final options = all.values
        .where((c) => !c.archived && (kind == null || c.kind == kind))
        .toList()
      ..sort((a, b) {
        final byKind = a.kind.index.compareTo(b.kind.index);
        return byKind != 0 ? byKind : a.sortOrder.compareTo(b.sortOrder);
      });

    final picked = await showModalBottomSheet<int>(
      context: context,
      showDragHandle: true,
      isScrollControlled: true,
      useSafeArea: true,
      builder: (ctx) => ListView(
        shrinkWrap: true,
        padding: const EdgeInsets.only(bottom: 24),
        children: [
          ListTile(
            leading: const Icon(Icons.all_inclusive_rounded),
            title: const Text('All categories'),
            onTap: () => Navigator.pop(ctx, -1),
          ),
          for (final c in options)
            ListTile(
              leading: CategoryAvatar(
                  iconKey: c.iconKey, colorValue: c.colorValue, radius: 18),
              title: Text(c.name),
              onTap: () => Navigator.pop(ctx, c.id),
            ),
        ],
      ),
    );
    if (picked == null) return;
    ref
        .read(historyFilterProvider.notifier)
        .setCategory(picked == -1 ? null : picked);
  }

  Future<void> _pickDate(HistoryFilter filter) async {
    final picked = await showModalBottomSheet<DatePreset>(
      context: context,
      showDragHandle: true,
      useSafeArea: true,
      builder: (ctx) => ListView(
        shrinkWrap: true,
        padding: const EdgeInsets.only(bottom: 24),
        children: [
          for (final p in DatePreset.values)
            ListTile(
              title: Text(p.label),
              trailing: filter.preset == p
                  ? const Icon(Icons.check_rounded)
                  : null,
              onTap: () => Navigator.pop(ctx, p),
            ),
        ],
      ),
    );
    if (picked == null || !mounted) return;

    final notifier = ref.read(historyFilterProvider.notifier);
    if (picked != DatePreset.custom) {
      notifier.setPreset(picked);
      return;
    }
    final today = dateOnly(DateTime.now());
    final range = await showDateRangePicker(
      context: context,
      firstDate: DateTime(today.year - 2, today.month, today.day),
      lastDate: today,
      initialDateRange: filter.custom == null
          ? null
          : DateTimeRange(start: filter.custom!.start, end: filter.custom!.end),
    );
    if (range == null) return;
    notifier.setPreset(DatePreset.custom, (start: range.start, end: range.end));
  }

  String _dateLabel(HistoryFilter f) {
    if (f.preset == DatePreset.custom && f.custom != null) {
      final fmt = DateFormat('d MMM');
      return '${fmt.format(f.custom!.start)} – ${fmt.format(f.custom!.end)}';
    }
    return f.preset.label;
  }

  String _dayLabel(DateTime day, DateTime now) {
    final diff = daysBetween(day, now);
    if (diff == 0) return 'Today';
    if (diff == 1) return 'Yesterday';
    return day.year == now.year
        ? DateFormat('EEEE d MMMM').format(day)
        : DateFormat('d MMMM yyyy').format(day);
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final text = theme.textTheme;
    final filter = ref.watch(historyFilterProvider);
    final notifier = ref.read(historyFilterProvider.notifier);
    final cats = switch (ref.watch(allCategoriesProvider)) {
      AsyncData(:final value) => value,
      _ => const <int, BudgetCategory>{},
    };
    final now = switch (ref.watch(nowProvider)) {
      AsyncData(:final value) => value,
      _ => DateTime.now(),
    };
    final selectedCat =
        filter.categoryId == null ? null : cats[filter.categoryId];

    Widget typeChip(String label, TxType? value) => ChoiceChip(
          label: Text(label),
          selected: filter.type == value,
          onSelected: (_) => notifier.setType(value),
        );

    return Scaffold(
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(20, 12, 20, 12),
              child: Text('History', style: text.headlineMedium),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: TextField(
                controller: _search,
                onChanged: notifier.setQuery,
                textInputAction: TextInputAction.search,
                decoration: koboInputDecoration(
                  context,
                  hint: 'Search notes or categories',
                ).copyWith(
                  prefixIcon: const Icon(Icons.search_rounded),
                  suffixIcon: filter.query.isEmpty
                      ? null
                      : IconButton(
                          tooltip: 'Clear search',
                          icon: const Icon(Icons.close_rounded),
                          onPressed: () {
                            _search.clear();
                            notifier.setQuery('');
                          },
                        ),
                ),
              ),
            ),
            const SizedBox(height: 12),
            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Row(
                children: [
                  typeChip('All', null),
                  const SizedBox(width: 8),
                  typeChip('Spent', TxType.expense),
                  const SizedBox(width: 8),
                  typeChip('Received', TxType.income),
                  const SizedBox(width: 12),
                  if (selectedCat == null)
                    ActionChip(
                      avatar: const Icon(Icons.category_outlined, size: 18),
                      label: const Text('Category'),
                      onPressed: () => _pickCategory(cats, filter.type),
                    )
                  else
                    InputChip(
                      avatar: Icon(iconFor(selectedCat.iconKey),
                          size: 18, color: Color(selectedCat.colorValue)),
                      label: Text(selectedCat.name),
                      selected: true,
                      showCheckmark: false,
                      onPressed: () => _pickCategory(cats, filter.type),
                      onDeleted: () => notifier.setCategory(null),
                    ),
                  const SizedBox(width: 8),
                  if (filter.preset == DatePreset.all)
                    ActionChip(
                      avatar: const Icon(Icons.date_range_rounded, size: 18),
                      label: const Text('Any date'),
                      onPressed: () => _pickDate(filter),
                    )
                  else
                    InputChip(
                      avatar: const Icon(Icons.date_range_rounded, size: 18),
                      label: Text(_dateLabel(filter)),
                      selected: true,
                      showCheckmark: false,
                      onPressed: () => _pickDate(filter),
                      onDeleted: () => notifier.setPreset(DatePreset.all),
                    ),
                  if (filter.isActive) ...[
                    const SizedBox(width: 8),
                    TextButton(onPressed: _clearAll, child: const Text('Clear')),
                  ],
                ],
              ),
            ),
            const SizedBox(height: 8),
            Expanded(
              child: switch (ref.watch(historyTxnsProvider)) {
                AsyncData(:final value) => _list(value, filter, cats, now),
                AsyncError(:final error) => Center(
                    child: Text('Couldn’t load history.\n$error',
                        textAlign: TextAlign.center),
                  ),
                _ => const Center(child: CircularProgressIndicator()),
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget _list(List<Txn> all, HistoryFilter filter,
      Map<int, BudgetCategory> cats, DateTime now) {
    final theme = Theme.of(context);
    final text = theme.textTheme;
    final scheme = theme.colorScheme;
    final k = context.koboColors;
    final muted = text.bodySmall?.copyWith(color: scheme.onSurfaceVariant);

    final q = filter.query.trim().toLowerCase();
    final rows = all.where((t) {
      if (_hidden.contains(t.id)) return false;
      if (q.isEmpty) return true;
      final note = t.note?.toLowerCase() ?? '';
      final name = cats[t.categoryId]?.name.toLowerCase() ?? '';
      return note.contains(q) || name.contains(q);
    }).toList();

    if (rows.isEmpty) {
      return Center(
        child: Padding(
          padding: const EdgeInsets.all(32),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                filter.isActive ? 'No matches' : 'No transactions yet',
                style: text.titleMedium?.copyWith(fontWeight: FontWeight.w700),
              ),
              const SizedBox(height: 6),
              Text(
                filter.isActive
                    ? 'Nothing fits these filters.'
                    : 'Everything you log shows up here.',
                style: muted,
                textAlign: TextAlign.center,
              ),
              if (filter.isActive) ...[
                const SizedBox(height: 16),
                FilledButton.tonal(
                  onPressed: _clearAll,
                  child: const Text('Clear filters'),
                ),
              ],
            ],
          ),
        ),
      );
    }

    var spent = 0;
    var received = 0;
    final days = <DateTime, List<Txn>>{};
    for (final t in rows) {
      if (t.type == TxType.expense) {
        spent += t.amountKobo;
      } else {
        received += t.amountKobo;
      }
      days.putIfAbsent(dateOnly(t.occurredAt), () => []).add(t);
    }
    final keys = days.keys.toList();
    final count = rows.length;

    return ListView.builder(
      padding: const EdgeInsets.fromLTRB(20, 4, 20, 32),
      itemCount: keys.length + 1,
      itemBuilder: (context, i) {
        if (i == 0) {
          return Text(
            '$count ${count == 1 ? 'transaction' : 'transactions'}, '
            '${formatNaira(spent)} spent'
            '${received > 0 ? ', ${formatNaira(received)} received' : ''}',
            style: muted,
          );
        }
        final day = keys[i - 1];
        final items = days[day]!;
        final daySpent = items
            .where((t) => t.type == TxType.expense)
            .fold(0, (a, t) => a + t.amountKobo);

        return Padding(
          padding: const EdgeInsets.only(top: 20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Row(
                children: [
                  Text(_dayLabel(day, now),
                      style: text.titleSmall
                          ?.copyWith(fontWeight: FontWeight.w700)),
                  const Spacer(),
                  if (daySpent > 0)
                    Text('−${formatNaira(daySpent)}',
                        style: text.labelLarge
                            ?.copyWith(color: scheme.onSurfaceVariant)),
                ],
              ),
              const SizedBox(height: 8),
              TileGroup(children: [
                for (final t in items)
                  Dismissible(
                    key: ValueKey(t.id),
                    direction: DismissDirection.endToStart,
                    background: Container(
                      alignment: Alignment.centerRight,
                      padding: const EdgeInsets.only(right: 20),
                      color: k.danger.withValues(alpha: 0.15),
                      child:
                          Icon(Icons.delete_outline_rounded, color: k.danger),
                    ),
                    onDismissed: (_) => _delete(t),
                    child: TxTile(
                      txn: t,
                      category: cats[t.categoryId],
                      now: now,
                      timeOnly: true,
                      onTap: () => editTransaction(context, ref, t),
                    ),
                  ),
              ]),
            ],
          ),
        );
      },
    );
  }
}
