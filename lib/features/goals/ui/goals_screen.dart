import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';

import '../../../core/database/app_database.dart';
import '../../../core/database/goal_queries.dart';
import '../../../core/dates.dart';
import '../../../core/money/money.dart';
import '../../../core/providers.dart';
import '../../../core/theme/app_theme.dart';
import '../../../core/ui/amount_field.dart';
import '../../../core/ui/motion.dart';
import '../../transactions/ui/tx_tile.dart';

final goalsProvider = StreamProvider<List<(SavingsGoal, int)>>(
  (ref) => ref.watch(databaseProvider).watchGoalsWithSaved(),
);

class GoalsScreen extends ConsumerWidget {
  const GoalsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      body: SafeArea(
        child: switch (ref.watch(goalsProvider)) {
          AsyncData(:final value) => _GoalsView(goals: value),
          AsyncError(:final error) => Center(
              child: Text('Couldn’t load goals.\n$error',
                  textAlign: TextAlign.center),
            ),
          _ => const Center(child: CircularProgressIndicator()),
        },
      ),
    );
  }
}

class _GoalsView extends StatelessWidget {
  const _GoalsView({required this.goals});
  final List<(SavingsGoal, int)> goals;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final text = theme.textTheme;
    final scheme = theme.colorScheme;
    final k = context.koboColors;
    final total = goals.fold(0, (a, g) => a + g.$2);

    return ListView(
      padding: const EdgeInsets.fromLTRB(20, 12, 20, 32),
      children: [
        Row(
          children: [
            Expanded(child: Text('Savings', style: text.headlineMedium)),
            TextButton.icon(
              onPressed: () => showGoalForm(context),
              icon: const Icon(Icons.add_rounded),
              label: const Text('New goal'),
            ),
          ],
        ),
        const SizedBox(height: 4),
        Text(
          'Money here is set aside. It doesn’t count toward safe-to-spend.',
          style: text.bodyMedium?.copyWith(color: scheme.onSurfaceVariant),
        ),
        const SizedBox(height: 16),
        if (goals.isEmpty) ...[
          const EmptyNote(
            title: 'No goals yet',
            body: 'A new phone, next session’s fees, a trip home. Create a '
                'goal and set money aside for it.',
          ),
          const SizedBox(height: 12),
          FilledButton(
            onPressed: () => showGoalForm(context),
            child: const Text('Create a goal'),
          ),
        ] else ...[
          Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: k.brass.withValues(alpha: 0.14),
              borderRadius: BorderRadius.circular(22),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Set aside', style: text.labelLarge),
                const SizedBox(height: 4),
                FittedBox(
                  fit: BoxFit.scaleDown,
                  alignment: Alignment.centerLeft,
                  child: AnimatedNaira(total,
                      countUp: true, style: text.amount(36)),
                ),
              ],
            ),
          ),
          const SizedBox(height: 16),
          for (final (goal, saved) in goals)
            Padding(
              padding: const EdgeInsets.only(bottom: 12),
              child: _GoalCard(goal: goal, saved: saved),
            ),
        ],
      ],
    );
  }
}

String _goalHint(SavingsGoal goal, int saved) {
  final remaining = goal.targetKobo - saved;
  if (remaining <= 0) {
    return 'Goal reached. Take the money out when you’re ready to use it.';
  }
  final deadline = goal.deadline;
  if (deadline == null) return '${formatNaira(remaining)} to go';
  final daysLeft = daysBetween(DateTime.now(), deadline);
  if (daysLeft <= 0) return 'Deadline passed. ${formatNaira(remaining)} to go.';
  final weeks = math.max(1, (daysLeft / 7).ceil());
  final perWeek = (remaining ~/ weeks + 99) ~/ 100 * 100;
  return 'Save about ${formatNaira(perWeek)} a week to reach it by '
      '${DateFormat('d MMM').format(deadline)}';
}

class _GoalCard extends StatelessWidget {
  const _GoalCard({required this.goal, required this.saved});
  final SavingsGoal goal;
  final int saved;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final text = theme.textTheme;
    final scheme = theme.colorScheme;
    final k = context.koboColors;
    final reached = saved >= goal.targetKobo;
    final muted = text.bodySmall?.copyWith(color: scheme.onSurfaceVariant);

    return Pressable(
      onTap: () => showGoalSheet(context, goal),
      scale: 0.98,
      child: Container(
        padding: const EdgeInsets.all(18),
        decoration: BoxDecoration(
          color: scheme.surfaceContainerLowest,
          borderRadius: BorderRadius.circular(22),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                CircleAvatar(
                  radius: 20,
                  backgroundColor: k.brass.withValues(alpha: 0.18),
                  child: Icon(Icons.savings_rounded, color: k.brass, size: 20),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(goal.name,
                          style: text.titleMedium
                              ?.copyWith(fontWeight: FontWeight.w700)),
                      Text(
                        goal.deadline == null
                            ? 'No deadline'
                            : 'By ${DateFormat('d MMM yyyy').format(goal.deadline!)}',
                        style: muted,
                      ),
                    ],
                  ),
                ),
                if (reached) Icon(Icons.check_circle_rounded, color: k.good),
              ],
            ),
            const SizedBox(height: 14),
            Row(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                AnimatedNaira(saved, style: text.amount(24)),
                const SizedBox(width: 6),
                Padding(
                  padding: const EdgeInsets.only(bottom: 2),
                  child: Text('of ${formatNaira(goal.targetKobo)}',
                      style: text.bodyMedium
                          ?.copyWith(color: scheme.onSurfaceVariant)),
                ),
              ],
            ),
            const SizedBox(height: 10),
            ProgressLine(
              fraction: goal.targetKobo == 0 ? 0 : saved / goal.targetKobo,
              color: reached ? k.good : k.brass,
            ),
            const SizedBox(height: 8),
            Text(_goalHint(goal, saved), style: muted),
          ],
        ),
      ),
    );
  }
}

// ---------------- Goal actions ----------------

Future<void> showGoalSheet(BuildContext context, SavingsGoal goal) async {
  final result = await showModalBottomSheet<String>(
    context: context,
    showDragHandle: true,
    useSafeArea: true,
    isScrollControlled: true,
    builder: (_) => _GoalSheet(goalId: goal.id),
  );
  if (result == 'edit' && context.mounted) {
    await showGoalForm(context, existing: goal);
  }
}

class _GoalSheet extends ConsumerStatefulWidget {
  const _GoalSheet({required this.goalId});
  final int goalId;

  @override
  ConsumerState<_GoalSheet> createState() => _GoalSheetState();
}

class _GoalSheetState extends ConsumerState<_GoalSheet> {
  String? _message;

  Future<void> _add(SavingsGoal goal) async {
    final v = await showAmountDialog(context,
        title: 'Add to ${goal.name}', allowZero: false);
    if (v == null) return;
    final db = ref.read(databaseProvider);
    final free = await db.currentSpendableKobo();
    if (v > free) {
      setState(() => _message =
          'You have ${formatNaira(math.max(0, free))} free to set aside.');
      return;
    }
    await db.addContribution(goal.id, v);
    HapticFeedback.mediumImpact();
    if (mounted) setState(() => _message = null);
  }

  Future<void> _takeOut(SavingsGoal goal, int saved) async {
    final v = await showAmountDialog(context,
        title: 'Take out of ${goal.name}', allowZero: false);
    if (v == null) return;
    if (v > saved) {
      setState(() =>
          _message = 'Only ${formatNaira(saved)} is saved in this goal.');
      return;
    }
    await ref
        .read(databaseProvider)
        .addContribution(goal.id, -v, note: 'Taken out');
    HapticFeedback.mediumImpact();
    if (mounted) setState(() => _message = null);
  }

  Future<void> _delete(SavingsGoal goal, int saved) async {
    final ok = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text('Delete ${goal.name}?'),
        content: Text(saved > 0
            ? 'The ${formatNaira(saved)} set aside goes back to your balance.'
            : 'This goal will be removed.'),
        actions: [
          TextButton(
              onPressed: () => Navigator.pop(ctx, false),
              child: const Text('Cancel')),
          TextButton(
              onPressed: () => Navigator.pop(ctx, true),
              child: const Text('Delete')),
        ],
      ),
    );
    if (ok != true) return;
    await ref.read(databaseProvider).deleteGoal(goal.id);
    if (mounted) Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    final goals = switch (ref.watch(goalsProvider)) {
      AsyncData(:final value) => value,
      _ => const <(SavingsGoal, int)>[],
    };
    (SavingsGoal, int)? entry;
    for (final g in goals) {
      if (g.$1.id == widget.goalId) entry = g;
    }
    if (entry == null) return const SizedBox(height: 120);
    final (goal, saved) = entry;

    final theme = Theme.of(context);
    final text = theme.textTheme;
    final scheme = theme.colorScheme;
    final k = context.koboColors;

    return SingleChildScrollView(
      padding: const EdgeInsets.fromLTRB(24, 0, 24, 24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Text(goal.name, style: text.titleLarge),
          const SizedBox(height: 8),
          Row(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              AnimatedNaira(saved, style: text.amount(32)),
              const SizedBox(width: 6),
              Padding(
                padding: const EdgeInsets.only(bottom: 3),
                child: Text('of ${formatNaira(goal.targetKobo)}',
                    style: text.bodyMedium
                        ?.copyWith(color: scheme.onSurfaceVariant)),
              ),
            ],
          ),
          const SizedBox(height: 12),
          ProgressLine(
            fraction: goal.targetKobo == 0 ? 0 : saved / goal.targetKobo,
            color: saved >= goal.targetKobo ? k.good : k.brass,
          ),
          const SizedBox(height: 8),
          Text(_goalHint(goal, saved),
              style: text.bodySmall?.copyWith(color: scheme.onSurfaceVariant)),
          const SizedBox(height: 20),
          Row(
            children: [
              Expanded(
                child: FilledButton.icon(
                  onPressed: () => _add(goal),
                  icon: const Icon(Icons.add_rounded),
                  label: const Text('Add money'),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: OutlinedButton.icon(
                  onPressed: saved > 0 ? () => _takeOut(goal, saved) : null,
                  icon: const Icon(Icons.remove_rounded),
                  label: const Text('Take out'),
                ),
              ),
            ],
          ),
          if (_message != null) ...[
            const SizedBox(height: 10),
            Text(_message!,
                style: text.bodySmall?.copyWith(color: scheme.error)),
          ],
          const SizedBox(height: 12),
          TextButton.icon(
            onPressed: () => Navigator.pop(context, 'edit'),
            icon: const Icon(Icons.edit_outlined),
            label: const Text('Edit goal'),
          ),
          TextButton.icon(
            onPressed: () => _delete(goal, saved),
            style: TextButton.styleFrom(foregroundColor: scheme.error),
            icon: const Icon(Icons.delete_outline_rounded),
            label: const Text('Delete goal'),
          ),
        ],
      ),
    );
  }
}

Future<void> showGoalForm(BuildContext context, {SavingsGoal? existing}) =>
    showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      useSafeArea: true,
      showDragHandle: true,
      builder: (_) => _GoalForm(existing: existing),
    );

class _GoalForm extends ConsumerStatefulWidget {
  const _GoalForm({this.existing});
  final SavingsGoal? existing;

  @override
  ConsumerState<_GoalForm> createState() => _GoalFormState();
}

class _GoalFormState extends ConsumerState<_GoalForm> {
  final _form = GlobalKey<FormState>();
  late final _name = TextEditingController(text: widget.existing?.name ?? '');
  late final _target = TextEditingController(
    text: widget.existing == null
        ? ''
        : koboToInputText(widget.existing!.targetKobo),
  );
  late DateTime? _deadline = widget.existing?.deadline;
  bool _busy = false;

  @override
  void dispose() {
    _name.dispose();
    _target.dispose();
    super.dispose();
  }

  Future<void> _pickDeadline() async {
    final t = DateTime.now();
    final picked = await showDatePicker(
      context: context,
      initialDate: _deadline ?? DateTime(t.year, t.month + 3, t.day),
      firstDate: DateTime(t.year, t.month, t.day + 1),
      lastDate: DateTime(t.year + 5, t.month, t.day),
    );
    if (picked != null) setState(() => _deadline = picked);
  }

  Future<void> _save() async {
    if (!_form.currentState!.validate()) return;
    setState(() => _busy = true);
    final db = ref.read(databaseProvider);
    final name = _name.text.trim();
    final target = parseNairaToKobo(_target.text)!;
    final existing = widget.existing;
    if (existing == null) {
      await db.addGoal(name: name, targetKobo: target, deadline: _deadline);
    } else {
      await db.updateGoal(existing.id,
          name: name, targetKobo: target, deadline: _deadline);
    }
    if (mounted) Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    final text = Theme.of(context).textTheme;
    return Padding(
      padding: EdgeInsets.fromLTRB(
          24, 0, 24, 24 + MediaQuery.viewInsetsOf(context).bottom),
      child: SingleChildScrollView(
        child: Form(
          key: _form,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Text(widget.existing == null ? 'New goal' : 'Edit goal',
                  style: text.titleLarge),
              const SizedBox(height: 16),
              TextFormField(
                controller: _name,
                maxLength: 40,
                textCapitalization: TextCapitalization.sentences,
                decoration: koboInputDecoration(context,
                    label: 'What are you saving for?'),
                validator: (v) => (v == null || v.trim().isEmpty)
                    ? 'Give your goal a name'
                    : null,
              ),
              const SizedBox(height: 8),
              AmountField(controller: _target, label: 'Target amount'),
              const SizedBox(height: 12),
              Align(
                alignment: Alignment.centerLeft,
                child: _deadline == null
                    ? OutlinedButton.icon(
                        onPressed: _pickDeadline,
                        icon: const Icon(Icons.event_rounded),
                        label: const Text('Add a deadline (optional)'),
                      )
                    : InputChip(
                        avatar: const Icon(Icons.event_rounded),
                        label: Text(
                            'By ${DateFormat('d MMM yyyy').format(_deadline!)}'),
                        onPressed: _pickDeadline,
                        onDeleted: () => setState(() => _deadline = null),
                      ),
              ),
              const SizedBox(height: 20),
              FilledButton(
                onPressed: _busy ? null : _save,
                child: Text(
                    widget.existing == null ? 'Create goal' : 'Save changes'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
