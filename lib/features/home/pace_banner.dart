import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../core/money/money.dart';
import '../../core/theme/app_theme.dart';
import '../budget/domain/pace.dart';
import '../budget/ui/new_period_screen.dart';
import 'dashboard.dart';

/// Period ended, money used up, or spending too fast. Otherwise nothing.
class PaceBanner extends ConsumerWidget {
  const PaceBanner({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final data = switch (ref.watch(dashboardProvider)) {
      AsyncData(:final value) => value,
      _ => null,
    };
    final cycle = data?.cycle;
    if (data == null || cycle == null) return const SizedBox.shrink();

    final k = context.koboColors;
    final scheme = Theme.of(context).colorScheme;
    String days(int n) => n == 1 ? '1 day' : '$n days';

    if (data.periodEnded) {
      return _Banner(
        icon: Icons.event_repeat_rounded,
        color: scheme.primary,
        title: 'This budget period has ended',
        body: 'Start a new one to plan around what you have now.',
        action: 'Start new period',
        onAction: () => openNewPeriod(context),
      );
    }

    if (data.spendableKobo <= 0) {
      return _Banner(
        icon: Icons.error_outline_rounded,
        color: k.danger,
        title: 'You’ve used this period’s money',
        body: data.safe.daysLeft > 1
            ? '${days(data.safe.daysLeft)} until your next income. Hold + '
                'to add any money you receive.'
            : 'Your next income is due.',
      );
    }

    final pace = PaceWarning.compute(
      spentThisCycleKobo: data.spentThisCycleKobo,
      cycleStart: cycle.startDate,
      now: data.now,
      spendableKobo: data.spendableKobo,
      daysLeft: data.safe.daysLeft,
    );
    if (pace == null) return const SizedBox.shrink();

    return _Banner(
      icon: Icons.speed_rounded,
      color: k.warn,
      title: pace.runsOutInDays == 0
          ? 'At this pace, money runs out today'
          : 'At this pace, money runs out in ${days(pace.runsOutInDays)}',
      body: '${days(pace.shortByDays)} before your next income. Spend about '
          '${formatNaira(pace.cutPerDay)} less a day to make it.',
    );
  }
}

class _Banner extends StatelessWidget {
  const _Banner({
    required this.icon,
    required this.color,
    required this.title,
    required this.body,
    this.action,
    this.onAction,
  });

  final IconData icon;
  final Color color;
  final String title;
  final String body;
  final String? action;
  final VoidCallback? onAction;

  @override
  Widget build(BuildContext context) {
    final text = Theme.of(context).textTheme;
    return Padding(
      padding: const EdgeInsets.only(top: 16),
      child: Container(
        padding: const EdgeInsets.fromLTRB(16, 16, 16, 12),
        decoration: BoxDecoration(
          color: color.withValues(alpha: 0.14),
          borderRadius: BorderRadius.circular(20),
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Icon(icon, color: color),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(title,
                      style: text.titleSmall
                          ?.copyWith(fontWeight: FontWeight.w700)),
                  const SizedBox(height: 4),
                  Text(body, style: text.bodyMedium?.copyWith(height: 1.4)),
                  if (action != null)
                    Align(
                      alignment: Alignment.centerLeft,
                      child: TextButton(onPressed: onAction, child: Text(action!)),
                    )
                  else
                    const SizedBox(height: 4),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
