import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/database/app_database.dart';
import '../../../core/database/goal_queries.dart';
import '../../../core/money/money.dart';
import '../../../core/providers.dart';
import '../../../core/theme/app_theme.dart';
import '../domain/income_split.dart';
import 'new_period_screen.dart';

class _Choice {
  const _Choice({required this.newPeriod, required this.useSplit});
  final bool newPeriod;
  final bool useSplit;
}

/// After income is logged: offer a new period, and a split for extra money.
/// Small amounts on a weekly or monthly schedule are left alone.
Future<void> maybeShowIncomeArrived(BuildContext context, int amountKobo) async {
  final container = ProviderScope.containerOf(context, listen: false);
  final db = container.read(databaseProvider);
  final settings = await db.getSettings();
  final usual = settings.usualIncomeKobo;
  final irregular = settings.incomeFrequency == IncomeFrequency.irregular;
  final big = usual <= 0 || amountKobo * 2 >= usual;
  if (!irregular && !big) return;

  final extra = usual > 0 && amountKobo > usual ? amountKobo - usual : 0;
  final split = extra > 0 ? IncomeSplit.of(extra) : null;
  final goals = await db.getGoals();
  final goal = goals.isEmpty ? null : goals.first;
  if (!context.mounted) return;

  final choice = await showModalBottomSheet<_Choice>(
    context: context,
    isScrollControlled: true,
    useSafeArea: true,
    showDragHandle: true,
    builder: (_) => _IncomeArrivedSheet(
      amountKobo: amountKobo,
      extraKobo: extra,
      split: split,
      goalName: goal?.name,
    ),
  );
  if (choice == null || !context.mounted) return;

  final useSplit = choice.useSplit ? split : null;
  if (choice.newPeriod) {
    await openNewPeriod(context, split: useSplit);
  } else if (useSplit != null) {
    await applySplitToCurrent(db, useSplit, goal?.id);
    if (context.mounted) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
        content: Text('Split added to your current plan'),
      ));
    }
  }
}

/// Adds the split to the current period: buffer and treat to their
/// categories, savings to the first goal (or the buffer if there's none).
Future<void> applySplitToCurrent(
    AppDatabase db, IncomeSplit split, int? goalId) async {
  var buffer = split.buffer;
  if (goalId != null && split.savings > 0) {
    await db.addContribution(goalId, split.savings, note: 'From extra income');
  } else {
    buffer += split.savings;
  }

  final cycle = await db.getActiveCycle();
  if (cycle == null) return;
  final cats = await db.getCategories(CategoryKind.expense);
  int? first(PriorityTier tier) {
    for (final c in cats) {
      if (c.tier == tier) return c.id;
    }
    return null;
  }

  final bufferId = first(PriorityTier.buffer);
  final treatId = first(PriorityTier.wants);
  if (bufferId != null && buffer > 0) {
    await db.bumpPlannedLine(cycle.id, bufferId, buffer);
  }
  if (treatId != null && split.treat > 0) {
    await db.bumpPlannedLine(cycle.id, treatId, split.treat);
  }
}

class _IncomeArrivedSheet extends StatefulWidget {
  const _IncomeArrivedSheet({
    required this.amountKobo,
    required this.extraKobo,
    required this.split,
    required this.goalName,
  });

  final int amountKobo;
  final int extraKobo;
  final IncomeSplit? split;
  final String? goalName;

  @override
  State<_IncomeArrivedSheet> createState() => _IncomeArrivedSheetState();
}

class _IncomeArrivedSheetState extends State<_IncomeArrivedSheet> {
  bool _useSplit = true;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final text = theme.textTheme;
    final scheme = theme.colorScheme;
    final k = context.koboColors;
    final split = widget.split;

    Widget row(Color dot, String label, int amount) => Padding(
          padding: const EdgeInsets.symmetric(vertical: 6),
          child: Row(
            children: [
              Container(
                width: 10,
                height: 10,
                decoration: BoxDecoration(color: dot, shape: BoxShape.circle),
              ),
              const SizedBox(width: 10),
              Expanded(child: Text(label, style: text.bodyMedium)),
              Text(formatNaira(amount),
                  style: text.titleSmall?.copyWith(fontWeight: FontWeight.w600)),
            ],
          ),
        );

    return SingleChildScrollView(
      padding: const EdgeInsets.fromLTRB(24, 0, 24, 24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Text('${formatNaira(widget.amountKobo)} received',
              style: text.headlineSmall),
          const SizedBox(height: 8),
          Text(
            'Start a new budget period from today? Kobo will plan around '
            'everything you have now.',
            style: text.bodyLarge?.copyWith(
              color: scheme.onSurfaceVariant,
              height: 1.4,
            ),
          ),
          if (split != null) ...[
            const SizedBox(height: 20),
            Container(
              padding: const EdgeInsets.fromLTRB(16, 8, 8, 12),
              decoration: BoxDecoration(
                color: scheme.surfaceContainerLowest,
                borderRadius: BorderRadius.circular(20),
              ),
              child: Column(
                children: [
                  Row(
                    children: [
                      Expanded(
                        child: Text(
                          'That’s ${formatNaira(widget.extraKobo)} more than '
                          'usual. Split the extra?',
                          style: text.titleSmall
                              ?.copyWith(fontWeight: FontWeight.w700),
                        ),
                      ),
                      Switch(
                        value: _useSplit,
                        onChanged: (v) => setState(() => _useSplit = v),
                      ),
                    ],
                  ),
                  AnimatedOpacity(
                    opacity: _useSplit ? 1 : 0.4,
                    duration: const Duration(milliseconds: 200),
                    child: Padding(
                      padding: const EdgeInsets.only(right: 8),
                      child: Column(
                        children: [
                          if (widget.goalName != null) ...[
                            row(tierColor(PriorityTier.buffer),
                                'Emergency buffer', split.buffer),
                            row(k.brass, 'Savings: ${widget.goalName}',
                                split.savings),
                          ] else
                            row(tierColor(PriorityTier.buffer),
                                'Emergency buffer',
                                split.buffer + split.savings),
                          row(tierColor(PriorityTier.wants), 'A small treat',
                              split.treat),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
          const SizedBox(height: 24),
          FilledButton(
            onPressed: () => Navigator.pop(
                context, _Choice(newPeriod: true, useSplit: _useSplit)),
            child: const Text('Start a new period'),
          ),
          const SizedBox(height: 8),
          OutlinedButton(
            onPressed: () => Navigator.pop(
                context, _Choice(newPeriod: false, useSplit: _useSplit)),
            child: const Text('Keep my current plan'),
          ),
        ],
      ),
    );
  }
}
