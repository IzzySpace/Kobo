import 'package:drift/drift.dart' show Value;
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/database/app_database.dart';
import '../../../core/providers.dart';
import '../../../core/ui/category_icons.dart';
import '../../../core/ui/labels.dart';

class CategoriesEditor extends ConsumerWidget {
  const CategoriesEditor({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return switch (ref.watch(expenseCategoriesProvider)) {
      AsyncData(:final value) => Column(
          children: [
            for (final c in value)
              ListTile(
                contentPadding: EdgeInsets.zero,
                leading: CategoryAvatar(
                    iconKey: c.iconKey, colorValue: c.colorValue),
                title: Text(c.name),
                subtitle: Text(c.tier?.shortLabel ?? ''),
                trailing: const Icon(Icons.edit_outlined, size: 20),
                onTap: () => showCategorySheet(context, existing: c),
              ),
            ListTile(
              contentPadding: EdgeInsets.zero,
              leading: const CircleAvatar(child: Icon(Icons.add_rounded)),
              title: const Text('Add category'),
              onTap: () => showCategorySheet(context),
            ),
          ],
        ),
      AsyncError() => const Text('Couldn’t load categories.'),
      _ => const Center(child: CircularProgressIndicator()),
    };
  }
}

Future<void> showCategorySheet(BuildContext context,
        {BudgetCategory? existing}) =>
    showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      useSafeArea: true,
      showDragHandle: true,
      builder: (_) => _CategorySheet(existing: existing),
    );

class _CategorySheet extends ConsumerStatefulWidget {
  const _CategorySheet({this.existing});
  final BudgetCategory? existing;

  @override
  ConsumerState<_CategorySheet> createState() => _CategorySheetState();
}

class _CategorySheetState extends ConsumerState<_CategorySheet> {
  late final TextEditingController _name =
      TextEditingController(text: widget.existing?.name ?? '');
  late PriorityTier _tier = widget.existing?.tier ?? PriorityTier.wants;
  late String _icon = widget.existing?.iconKey ?? 'other';
  String? _error;
  bool _busy = false;

  static const _tiers = [
    PriorityTier.essential,
    PriorityTier.school,
    PriorityTier.buffer,
    PriorityTier.wants,
  ];

  @override
  void dispose() {
    _name.dispose();
    super.dispose();
  }

  Future<void> _save() async {
    final db = ref.read(databaseProvider);
    final name = _name.text.trim();
    final all = await db.getCategories(CategoryKind.expense);

    String? error;
    if (name.isEmpty) {
      error = 'Give it a name';
    } else if (all.any((c) =>
        c.id != widget.existing?.id &&
        c.name.toLowerCase() == name.toLowerCase())) {
      error = 'You already have a category called $name';
    }
    if (error != null) {
      setState(() => _error = error);
      return;
    }

    setState(() => _busy = true);
    try {
      final existing = widget.existing;
      if (existing == null) {
        await db.addCategory(
          name: name,
          kind: CategoryKind.expense,
          tier: _tier,
          iconKey: _icon,
          colorValue: categoryPalette[all.length % categoryPalette.length],
        );
      } else {
        await db.updateCategory(
          existing.id,
          CategoriesCompanion(
            name: Value(name),
            tier: Value(_tier),
            iconKey: Value(_icon),
          ),
        );
      }
      if (!mounted) return;
      Navigator.pop(context);
    } catch (_) {
      setState(() {
        _busy = false;
        _error = 'Couldn’t save. Please try again.';
      });
    }
  }

  Future<void> _remove() async {
    final db = ref.read(databaseProvider);
    final existing = widget.existing!;
    final all = await db.getCategories(CategoryKind.expense);
    if (all.length <= 1) {
      setState(() => _error = 'You need at least one category');
      return;
    }
    if (!mounted) return;
    final ok = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text('Remove ${existing.name}?'),
        content: const Text(
          'Past spending keeps this category. It just won’t show up '
          'for new spending or in your budget.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx, false),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () => Navigator.pop(ctx, true),
            child: const Text('Remove'),
          ),
        ],
      ),
    );
    if (ok != true) return;
    await db.archiveCategory(existing.id);
    if (!mounted) return;
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final scheme = theme.colorScheme;

    return Padding(
      padding: EdgeInsets.fromLTRB(
          24, 0, 24, 24 + MediaQuery.viewInsetsOf(context).bottom),
      child: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text(
              widget.existing == null ? 'New category' : 'Edit category',
              style: theme.textTheme.titleLarge,
            ),
            const SizedBox(height: 16),
            TextField(
              controller: _name,
              maxLength: 40,
              textCapitalization: TextCapitalization.sentences,
              decoration: InputDecoration(
                labelText: 'Name',
                errorText: _error,
                border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(16)),
              ),
            ),
            const SizedBox(height: 8),
            Text('Priority', style: theme.textTheme.labelLarge),
            const SizedBox(height: 8),
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: [
                for (final t in _tiers)
                  ChoiceChip(
                    label: Text(t.shortLabel),
                    selected: _tier == t,
                    onSelected: (_) => setState(() => _tier = t),
                  ),
              ],
            ),
            const SizedBox(height: 16),
            Text('Icon', style: theme.textTheme.labelLarge),
            const SizedBox(height: 8),
            Wrap(
              spacing: 4,
              runSpacing: 4,
              children: [
                for (final k in expenseIconKeys)
                  IconButton(
                    onPressed: () => setState(() => _icon = k),
                    icon: Icon(iconFor(k)),
                    style: IconButton.styleFrom(
                      backgroundColor:
                          _icon == k ? scheme.primaryContainer : null,
                      foregroundColor:
                          _icon == k ? scheme.onPrimaryContainer : null,
                    ),
                  ),
              ],
            ),
            const SizedBox(height: 24),
            FilledButton(
              onPressed: _busy ? null : _save,
              child: const Text('Save'),
            ),
            if (widget.existing != null)
              TextButton(
                onPressed: _busy ? null : _remove,
                style: TextButton.styleFrom(foregroundColor: scheme.error),
                child: const Text('Remove category'),
              ),
          ],
        ),
      ),
    );
  }
}