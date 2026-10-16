import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/database/app_database.dart';
import '../../../core/money/money.dart';
import '../../../core/providers.dart';
import '../../../core/theme/app_theme.dart';
import '../../../core/ui/amount_field.dart';
import '../../../core/ui/category_icons.dart';
import '../../../core/ui/labels.dart';
import '../../../core/ui/motion.dart';
import '../../../core/ui/note_card.dart';
import '../../../core/ui/step_layout.dart';
import '../../onboarding/onboarding_controller.dart';

class BudgetPlanStep extends ConsumerStatefulWidget {
  const BudgetPlanStep({super.key});

  @override
  ConsumerState<BudgetPlanStep> createState() => _BudgetPlanStepState();
}

class _BudgetPlanStepState extends ConsumerState<BudgetPlanStep> {
  bool _ready = false;
  bool _saving = false;

  @override
  void initState() {
    super.initState();
    ref.read(onboardingProvider.notifier).preparePlan().then((_) {
      if (mounted) setState(() => _ready = true);
    });
  }

  int _perDay(int kobo, int days) => (kobo ~/ days) ~/ 100 * 100;

  Future<void> _edit(String title, int current, void Function(int) apply) async {
    final v = await showAmountDialog(context, title: title, initialKobo: current);
    if (v != null) apply(v);
  }

  Future<void> _finish() async {
    final draft = ref.read(onboardingProvider);
    final messenger = ScaffoldMessenger.of(context);
    if (draft.unassignedKobo < 0) {
      messenger.showSnackBar(SnackBar(
        content: Text(
          'Your plan is ${formatNaira(-draft.unassignedKobo)} more than you '
          'have. Lower some amounts.',
        ),
      ));
      return;
    }
    setState(() => _saving = true);
    try {
      await ref.read(onboardingProvider.notifier).finish();
    } catch (_) {
      if (!mounted) return;
      setState(() => _saving = false);
      messenger.showSnackBar(const SnackBar(
        content: Text('Couldn’t save your budget. Please try again.'),
      ));
    }
  }

  @override
  Widget build(BuildContext context) {
    if (!_ready) return const Center(child: CircularProgressIndicator());

    final draft = ref.watch(onboardingProvider);
    final notifier = ref.read(onboardingProvider.notifier);
    final cats = switch (ref.watch(expenseCategoriesProvider)) {
      AsyncData(:final value) => value,
      _ => const <BudgetCategory>[],
    };
    final theme = Theme.of(context);
    final text = theme.textTheme;
    final scheme = theme.colorScheme;
    final k = context.koboColors;
    final days = draft.days;
    final over = draft.unassignedKobo < 0;

    int tierTotal(PriorityTier t) => cats
        .where((c) => c.tier == t)
        .fold(0, (a, c) => a + (draft.planned[c.id] ?? 0));

    final segments = <(Color, int)>[
      (tierColor(PriorityTier.essential), tierTotal(PriorityTier.essential)),
      (tierColor(PriorityTier.school), tierTotal(PriorityTier.school)),
      (tierColor(PriorityTier.buffer), tierTotal(PriorityTier.buffer)),
      (tierColor(PriorityTier.savings), draft.savingsKobo),
      (tierColor(PriorityTier.wants), tierTotal(PriorityTier.wants)),
      (Colors.transparent, over ? 0 : draft.unassignedKobo),
    ];

    final (String statusKey, String statusText, Color pill, Color pillText) =
        over
            ? (
                'over',
                'Over by ${formatNaira(-draft.unassignedKobo)}',
                k.danger,
                Colors.white,
              )
            : draft.unassignedKobo > 0
                ? (
                    'left',
                    '${formatNaira(draft.unassignedKobo)} not yet assigned',
                    k.onNote.withValues(alpha: 0.16),
                    k.onNote,
                  )
                : (
                    'done',
                    'Every naira has a job',
                    tierColor(PriorityTier.essential),
                    k.note,
                  );

    Widget tile({
      required Widget leading,
      required String title,
      required int amount,
      required VoidCallback onTap,
    }) =>
        Pressable(
          onTap: onTap,
          scale: 0.98,
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            child: Row(
              children: [
                leading,
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(title,
                          style: text.titleSmall
                              ?.copyWith(fontWeight: FontWeight.w600)),
                      const SizedBox(height: 2),
                      Text(
                        amount > 0
                            ? '≈ ${formatNaira(_perDay(amount, days))} a day'
                            : 'Tap to set an amount',
                        style: text.bodySmall
                            ?.copyWith(color: scheme.onSurfaceVariant),
                      ),
                    ],
                  ),
                ),
                AnimatedNaira(amount, style: text.amount(19)),
              ],
            ),
          ),
        );

    Widget section({
      required Color dot,
      required String title,
      required int total,
      required List<Widget> rows,
    }) =>
        Padding(
          padding: const EdgeInsets.only(top: 24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Row(
                children: [
                  Container(
                    width: 10,
                    height: 10,
                    decoration: BoxDecoration(
                      color: dot,
                      shape: BoxShape.circle,
                      border: Border.all(
                        color: scheme.onSurface.withValues(alpha: 0.15),
                      ),
                    ),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: Text(title,
                        style: text.titleMedium
                            ?.copyWith(fontWeight: FontWeight.w700)),
                  ),
                  AnimatedNaira(total,
                      style: text.titleSmall
                          ?.copyWith(color: scheme.onSurfaceVariant)),
                ],
              ),
              const SizedBox(height: 10),
              DecoratedBox(
                decoration: BoxDecoration(
                  color: scheme.surfaceContainerLowest,
                  borderRadius: BorderRadius.circular(22),
                ),
                child: Column(
                  children: [
                    for (var i = 0; i < rows.length; i++) ...[
                      if (i > 0)
                        Divider(
                          height: 1,
                          indent: 68,
                          color: scheme.outlineVariant.withValues(alpha: 0.5),
                        ),
                      rows[i],
                    ],
                  ],
                ),
              ),
            ],
          ),
        );

    final tierSections = [
      for (final tier in const [
        PriorityTier.essential,
        PriorityTier.school,
        PriorityTier.buffer,
      ])
        if (cats.any((c) => c.tier == tier))
          section(
            dot: tierColor(tier),
            title: tier.label,
            total: tierTotal(tier),
            rows: [
              for (final c in cats.where((c) => c.tier == tier))
                tile(
                  leading: CategoryAvatar(
                      iconKey: c.iconKey, colorValue: c.colorValue),
                  title: c.name,
                  amount: draft.planned[c.id] ?? 0,
                  onTap: () => _edit(c.name, draft.planned[c.id] ?? 0,
                      (v) => notifier.setPlanned(c.id, v)),
                ),
            ],
          ),
    ];

    return StepLayout(
      title: 'Here’s your plan',
      subtitle: 'Essentials get money first, wants last. Tap any amount to '
          'change it.',
      primaryLabel: _saving ? 'Saving…' : 'Start budgeting',
      onPrimary: _saving ? null : _finish,
      children: [
        NoteCard(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('Your money',
                  style: text.labelLarge
                      ?.copyWith(color: k.onNote.withValues(alpha: 0.75))),
              const SizedBox(height: 6),
              FittedBox(
                fit: BoxFit.scaleDown,
                alignment: Alignment.centerLeft,
                child: AnimatedNaira(
                  draft.balanceKobo,
                  countUp: true,
                  style: text.amount(46, color: k.onNote),
                ),
              ),
              const SizedBox(height: 6),
              Text(
                'for $days ${days == 1 ? 'day' : 'days'}, about '
                '${formatNaira(_perDay(draft.balanceKobo, days))} a day',
                style: text.bodyMedium
                    ?.copyWith(color: k.onNote.withValues(alpha: 0.82)),
              ),
              const SizedBox(height: 20),
              _AllocationBar(segments: segments, track: k.onNote),
              const SizedBox(height: 14),
              AnimatedSwitcher(
                duration: Motion.of(context, Motion.fast),
                child: Container(
                  key: ValueKey(statusKey),
                  padding:
                      const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                  decoration: BoxDecoration(
                    color: pill,
                    borderRadius: BorderRadius.circular(99),
                  ),
                  child: Text(
                    statusText,
                    style: text.labelLarge?.copyWith(
                      color: pillText,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
        if (draft.goal != null && draft.unassignedKobo > 0)
          Padding(
            padding: const EdgeInsets.only(top: 8),
            child: Align(
              alignment: Alignment.centerLeft,
              child: TextButton.icon(
                onPressed: notifier.moveUnassignedToSavings,
                icon: Icon(Icons.savings_rounded, color: k.brass),
                label: Text(
                    'Move ${formatNaira(draft.unassignedKobo)} to savings'),
              ),
            ),
          ),
        ...tierSections,
        if (draft.goal != null)
          section(
            dot: tierColor(PriorityTier.savings),
            title: 'Savings',
            total: draft.savingsKobo,
            rows: [
              tile(
                leading: CircleAvatar(
                  radius: 20,
                  backgroundColor: k.brass.withValues(alpha: 0.18),
                  child: Icon(Icons.savings_rounded, color: k.brass, size: 20),
                ),
                title: 'Towards ${draft.goal!.name}',
                amount: draft.savingsKobo,
                onTap: () =>
                    _edit('Savings', draft.savingsKobo, notifier.setSavings),
              ),
            ],
          ),
        if (cats.any((c) => c.tier == PriorityTier.wants))
          section(
            dot: tierColor(PriorityTier.wants),
            title: PriorityTier.wants.label,
            total: tierTotal(PriorityTier.wants),
            rows: [
              for (final c in cats.where((c) => c.tier == PriorityTier.wants))
                tile(
                  leading: CategoryAvatar(
                      iconKey: c.iconKey, colorValue: c.colorValue),
                  title: c.name,
                  amount: draft.planned[c.id] ?? 0,
                  onTap: () => _edit(c.name, draft.planned[c.id] ?? 0,
                      (v) => notifier.setPlanned(c.id, v)),
                ),
            ],
          ),
        const SizedBox(height: 12),
        Align(
          alignment: Alignment.centerLeft,
          child: TextButton.icon(
            onPressed: notifier.resuggest,
            icon: const Icon(Icons.auto_awesome_rounded),
            label: const Text('Suggest again'),
          ),
        ),
      ],
    );
  }
}

/// One bar showing where the money goes, in funding order.
/// Segments resize smoothly when an amount is edited.
class _AllocationBar extends StatelessWidget {
  const _AllocationBar({required this.segments, required this.track});

  final List<(Color, int)> segments;
  final Color track;

  @override
  Widget build(BuildContext context) => LayoutBuilder(
        builder: (context, c) {
          final total = segments.fold(0, (a, s) => a + s.$2);
          return ClipRRect(
            borderRadius: BorderRadius.circular(6),
            child: Container(
              height: 12,
              color: track.withValues(alpha: 0.12),
              child: Row(
                children: [
                  for (final (color, value) in segments)
                    AnimatedContainer(
                      duration: Motion.of(context, Motion.medium),
                      curve: Motion.curve,
                      width: total == 0
                          ? 0
                          : (c.maxWidth * value / total).floorToDouble(),
                      color: color,
                    ),
                ],
              ),
            ),
          );
        },
      );
}
