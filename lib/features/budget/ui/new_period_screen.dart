import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';

import '../../../core/database/app_database.dart';
import '../../../core/dates.dart';
import '../../../core/money/money.dart';
import '../../../core/providers.dart';
import '../../../core/theme/app_theme.dart';
import '../../../core/ui/motion.dart';
import '../../../core/ui/step_layout.dart';
import '../domain/income_split.dart';
import '../new_period.dart';
import 'budget_plan_step.dart';

/// Loads the numbers, then opens the new-period flow.
Future<void> openNewPeriod(BuildContext context, {IncomeSplit? split}) async {
  final container = ProviderScope.containerOf(context, listen: false);
  await container.read(newPeriodProvider.notifier).begin(split: split);
  if (!context.mounted) return;
  await Navigator.of(context).push(
    MaterialPageRoute<void>(builder: (_) => const NewPeriodScreen()),
  );
}

class NewPeriodScreen extends ConsumerStatefulWidget {
  const NewPeriodScreen({super.key});

  @override
  ConsumerState<NewPeriodScreen> createState() => _NewPeriodScreenState();
}

class _NewPeriodScreenState extends ConsumerState<NewPeriodScreen> {
  int _step = 0;
  int? _startCycleId;

  @override
  void initState() {
    super.initState();
    _startCycleId = switch (ref.read(activeCycleProvider)) {
      AsyncData(:final value) => value?.id,
      _ => null,
    };
  }

  @override
  Widget build(BuildContext context) {
    // Close once the new period has been saved.
    ref.listen<AsyncValue<BudgetCycle?>>(activeCycleProvider, (_, next) {
      final id = switch (next) {
        AsyncData(:final value) => value?.id,
        _ => null,
      };
      if (id != null && id != _startCycleId && mounted) {
        final messenger = ScaffoldMessenger.of(context);
        Navigator.of(context).pop();
        messenger.showSnackBar(
            const SnackBar(content: Text('New budget period started')));
      }
    });

    final scheme = Theme.of(context).colorScheme;
    return PopScope(
      canPop: _step == 0,
      onPopInvokedWithResult: (didPop, _) {
        if (!didPop) setState(() => _step = 0);
      },
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: scheme.surface,
          surfaceTintColor: Colors.transparent,
          title: const Text('New budget period'),
        ),
        body: _step == 0
            ? _DateStep(onNext: () => setState(() => _step = 1))
            : BudgetPlanStep(provider: newPeriodProvider),
      ),
    );
  }
}

class _DateStep extends ConsumerStatefulWidget {
  const _DateStep({required this.onNext});
  final VoidCallback onNext;

  @override
  ConsumerState<_DateStep> createState() => _DateStepState();
}

class _DateStepState extends ConsumerState<_DateStep> {
  late DateTime _end = ref.read(newPeriodProvider).cycleEnd ??
      defaultPeriodEnd(IncomeFrequency.monthly);

  Future<void> _pick() async {
    final t = DateTime.now();
    final tomorrow = DateTime(t.year, t.month, t.day + 1);
    final picked = await showDatePicker(
      context: context,
      initialDate: _end.isBefore(tomorrow) ? tomorrow : _end,
      firstDate: tomorrow,
      lastDate: DateTime(t.year + 1, t.month, t.day),
    );
    if (picked != null) setState(() => _end = picked);
  }

  @override
  Widget build(BuildContext context) {
    final draft = ref.watch(newPeriodProvider);
    final theme = Theme.of(context);
    final text = theme.textTheme;
    final scheme = theme.colorScheme;
    final irregular = draft.frequency == IncomeFrequency.irregular;
    final days = cycleDays(_end);

    return StepLayout(
      title: irregular
          ? 'Make this money last until'
          : 'When is your next income?',
      subtitle: 'You have ${formatNaira(draft.balanceKobo)} to plan with, '
          'not counting savings.',
      primaryLabel: 'Plan this period',
      onPrimary: () {
        final notifier = ref.read(newPeriodProvider.notifier);
        if (draft.cycleEnd == null ||
            daysBetween(draft.cycleEnd!, _end) != 0 ||
            draft.planned.isEmpty) {
          notifier.setEnd(_end);
        }
        widget.onNext();
      },
      children: [
        Pressable(
          onTap: _pick,
          child: Container(
            padding: const EdgeInsets.all(18),
            decoration: BoxDecoration(
              color: scheme.surfaceContainerLowest,
              borderRadius: BorderRadius.circular(20),
              border: Border.all(color: scheme.outlineVariant),
            ),
            child: Row(
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(DateFormat('EEEE, d MMMM').format(_end),
                          style: text.titleMedium
                              ?.copyWith(fontWeight: FontWeight.w600)),
                      const SizedBox(height: 4),
                      Text('Tap to change',
                          style:
                              text.bodySmall?.copyWith(color: scheme.primary)),
                    ],
                  ),
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    AnimatedCount(days,
                        style: text.amount(40, color: scheme.primary)),
                    Text(days == 1 ? 'day' : 'days', style: text.labelMedium),
                  ],
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
