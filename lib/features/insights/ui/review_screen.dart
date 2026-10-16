import 'dart:math' as math;

import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';

import '../../../core/database/app_database.dart';
import '../../../core/dates.dart';
import '../../../core/money/money.dart';
import '../../../core/providers.dart';
import '../../../core/theme/app_theme.dart';
import '../../../core/ui/category_icons.dart';
import '../../../core/ui/motion.dart';
import '../../../core/ui/note_card.dart';
import '../../budget/domain/safe_to_spend.dart';
import '../../transactions/ui/tx_tile.dart';
import '../domain/weekly_review.dart';
import '../review_providers.dart';

class ReviewScreen extends ConsumerWidget {
  const ReviewScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final review = ref.watch(weeklyReviewProvider);
    final cats = switch (ref.watch(allCategoriesProvider)) {
      AsyncData(:final value) => value,
      _ => const <int, BudgetCategory>{},
    };
    return Scaffold(
      body: SafeArea(
        child: switch (review) {
          AsyncData(:final value) =>
            _ReviewView(review: value, categories: cats),
          AsyncError(:final error) => Center(
              child: Padding(
                padding: const EdgeInsets.all(24),
                child: Text('Couldn’t load this week.\n$error',
                    textAlign: TextAlign.center),
              ),
            ),
          _ => const Center(child: CircularProgressIndicator()),
        },
      ),
    );
  }
}

String _weekLabel(DateTime start) {
  final diff = daysBetween(start, weekStartOf(DateTime.now()));
  if (diff == 0) return 'This week';
  if (diff == 7) return 'Last week';
  final end = DateTime(start.year, start.month, start.day + 6);
  final fmt = DateFormat('d MMM');
  return start.month == end.month
      ? '${start.day}–${fmt.format(end)}'
      : '${fmt.format(start)} – ${fmt.format(end)}';
}

class _ReviewView extends ConsumerWidget {
  const _ReviewView({required this.review, required this.categories});

  final WeeklyReview review;
  final Map<int, BudgetCategory> categories;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final text = theme.textTheme;
    final scheme = theme.colorScheme;
    final k = context.koboColors;
    final notifier = ref.read(reviewWeekProvider.notifier);
    final isCurrent =
        daysBetween(review.weekStart, weekStartOf(DateTime.now())) <= 0;
    final top = review.topOverspend;
    String nameOf(int id) => categories[id]?.name ?? 'Removed category';

    final spent = review.totalSpent;
    final share = review.totalShare;
    final compare = share == 0
        ? 'No plan to compare against yet'
        : spent <= share
            ? '${formatNaira(share - spent)} under your weekly share'
            : '${formatNaira(spent - share)} over your weekly share';

    return ListView(
      padding: const EdgeInsets.fromLTRB(20, 12, 20, 32),
      children: [
        Text('Weekly review', style: text.headlineMedium),
        const SizedBox(height: 8),
        Row(
          children: [
            IconButton(
              tooltip: 'Previous week',
              onPressed: notifier.previous,
              icon: const Icon(Icons.chevron_left_rounded),
            ),
            Expanded(
              child: Text(
                _weekLabel(review.weekStart),
                textAlign: TextAlign.center,
                style: text.titleMedium?.copyWith(fontWeight: FontWeight.w700),
              ),
            ),
            IconButton(
              tooltip: 'Next week',
              onPressed: isCurrent ? null : notifier.next,
              icon: const Icon(Icons.chevron_right_rounded),
            ),
          ],
        ),
        const SizedBox(height: 12),
        NoteCard(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('Spent',
                  style: text.labelLarge
                      ?.copyWith(color: k.onNote.withValues(alpha: 0.75))),
              const SizedBox(height: 6),
              FittedBox(
                fit: BoxFit.scaleDown,
                alignment: Alignment.centerLeft,
                child: AnimatedNaira(spent,
                    style: text.amount(46, color: k.onNote)),
              ),
              const SizedBox(height: 6),
              Text(compare,
                  style: text.bodyMedium
                      ?.copyWith(color: k.onNote.withValues(alpha: 0.82))),
              if (review.totalReceived > 0) ...[
                const SizedBox(height: 4),
                Text('Received ${formatNaira(review.totalReceived)}',
                    style: text.bodySmall
                        ?.copyWith(color: k.onNote.withValues(alpha: 0.7))),
              ],
            ],
          ),
        ),
        if (spent == 0) ...[
          const SizedBox(height: 16),
          EmptyNote(
            title: 'Nothing spent this week',
            body: isCurrent
                ? 'Log your spending and this page fills in.'
                : 'No spending was logged that week.',
          ),
        ] else ...[
          const SizedBox(height: 16),
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: (top != null ? k.warn : k.good).withValues(alpha: 0.14),
              borderRadius: BorderRadius.circular(20),
            ),
            child: Row(
              children: [
                Icon(
                  top != null
                      ? Icons.trending_up_rounded
                      : Icons.check_circle_rounded,
                  color: top != null ? k.warn : k.good,
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Text(
                    top == null
                        ? 'Every category stayed within its weekly share.'
                        : top.share == 0
                            ? '${nameOf(top.categoryId)} has no budget but '
                                'took ${formatNaira(top.spent)}.'
                            : '${nameOf(top.categoryId)} went '
                                '${formatNaira(top.over)} over its weekly share.',
                    style: text.bodyMedium
                        ?.copyWith(fontWeight: FontWeight.w600),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 28),
          Text('Day by day', style: text.titleLarge),
          const SizedBox(height: 12),
          _Panel(child: _DailyBars(review: review)),
          const SizedBox(height: 28),
          Text('Where it went', style: text.titleLarge),
          const SizedBox(height: 12),
          _Panel(child: _Donut(review: review, categories: categories)),
          const SizedBox(height: 28),
          Text('Against your plan', style: text.titleLarge),
          const SizedBox(height: 2),
          Text('Your period budget spread evenly over its weeks.',
              style:
                  text.bodySmall?.copyWith(color: scheme.onSurfaceVariant)),
          const SizedBox(height: 12),
          TileGroup(children: [
            for (final c in review.categories)
              _PlanRow(category: categories[c.categoryId], week: c),
          ]),
        ],
      ],
    );
  }
}

class _Panel extends StatelessWidget {
  const _Panel({required this.child});
  final Widget child;

  @override
  Widget build(BuildContext context) => Container(
        padding: const EdgeInsets.fromLTRB(16, 20, 16, 16),
        decoration: BoxDecoration(
          color: Theme.of(context).colorScheme.surfaceContainerLowest,
          borderRadius: BorderRadius.circular(22),
        ),
        child: child,
      );
}

class _DailyBars extends StatelessWidget {
  const _DailyBars({required this.review});
  final WeeklyReview review;

  static const _days = ['M', 'T', 'W', 'T', 'F', 'S', 'S'];

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final text = theme.textTheme;
    final scheme = theme.colorScheme;
    final k = context.koboColors;

    final todayIndex = daysBetween(review.weekStart, DateTime.now());
    final share = review.dailyShare / 100;
    final values = [for (final v in review.daily) v / 100];
    final maxY = math.max(1.0, math.max(values.reduce(math.max), share) * 1.25);

    Color barColor(int i) {
      if (share > 0 && values[i] > share) return k.warn;
      return i == todayIndex
          ? scheme.primary
          : scheme.primary.withValues(alpha: 0.5);
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(
          height: 200,
          child: BarChart(
            BarChartData(
              maxY: maxY,
              alignment: BarChartAlignment.spaceAround,
              gridData: FlGridData(show: false),
              borderData: FlBorderData(show: false),
              titlesData: FlTitlesData(
                leftTitles:
                    AxisTitles(sideTitles: SideTitles(showTitles: false)),
                rightTitles:
                    AxisTitles(sideTitles: SideTitles(showTitles: false)),
                topTitles:
                    AxisTitles(sideTitles: SideTitles(showTitles: false)),
                bottomTitles: AxisTitles(
                  sideTitles: SideTitles(
                    showTitles: true,
                    reservedSize: 28,
                    getTitlesWidget: (value, meta) {
                      final i = value.toInt();
                      return Padding(
                        padding: const EdgeInsets.only(top: 8),
                        child: Text(
                          _days[i],
                          style: text.labelMedium?.copyWith(
                            fontWeight: i == todayIndex
                                ? FontWeight.w800
                                : FontWeight.w500,
                            color: i == todayIndex
                                ? scheme.primary
                                : scheme.onSurfaceVariant,
                          ),
                        ),
                      );
                    },
                  ),
                ),
              ),
              extraLinesData: ExtraLinesData(horizontalLines: [
                if (share > 0)
                  HorizontalLine(
                    y: share,
                    color: k.brass,
                    strokeWidth: 1.5,
                    dashArray: [6, 4],
                  ),
              ]),
              barTouchData: BarTouchData(
                touchTooltipData: BarTouchTooltipData(
                  getTooltipColor: (_) => scheme.inverseSurface,
                  getTooltipItem: (group, groupIndex, rod, rodIndex) =>
                      BarTooltipItem(
                    formatNaira(review.daily[group.x]),
                    TextStyle(
                      color: scheme.onInverseSurface,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ),
              ),
              barGroups: [
                for (var i = 0; i < 7; i++)
                  BarChartGroupData(
                    x: i,
                    barRods: [
                      BarChartRodData(
                        toY: values[i],
                        width: 18,
                        color: barColor(i),
                        borderRadius: const BorderRadius.vertical(
                            top: Radius.circular(6)),
                      ),
                    ],
                  ),
              ],
            ),
          ),
        ),
        if (review.dailyShare > 0) ...[
          const SizedBox(height: 12),
          Row(
            children: [
              Container(width: 18, height: 2, color: k.brass),
              const SizedBox(width: 8),
              Expanded(
                child: Text(
                  'Daily share ${formatNaira(review.dailyShare)}. Days above '
                  'it are amber.',
                  style: text.bodySmall
                      ?.copyWith(color: scheme.onSurfaceVariant),
                ),
              ),
            ],
          ),
        ],
      ],
    );
  }
}

class _Donut extends StatelessWidget {
  const _Donut({required this.review, required this.categories});
  final WeeklyReview review;
  final Map<int, BudgetCategory> categories;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final text = theme.textTheme;
    final scheme = theme.colorScheme;

    final spentCats = review.categories.where((c) => c.spent > 0).toList()
      ..sort((a, b) => b.spent.compareTo(a.spent));
    final slices = <(String, Color, int)>[
      for (final c in spentCats.take(5))
        (
          categories[c.categoryId]?.name ?? 'Removed category',
          Color(categories[c.categoryId]?.colorValue ?? 0xFF78716C),
          c.spent,
        ),
    ];
    final rest = spentCats.skip(5).fold(0, (a, c) => a + c.spent);
    if (rest > 0) slices.add(('Everything else', scheme.outline, rest));
    final total = review.totalSpent;

    return Column(
      children: [
        SizedBox(
          height: 190,
          child: Stack(
            alignment: Alignment.center,
            children: [
              PieChart(
                PieChartData(
                  sectionsSpace: 2,
                  centerSpaceRadius: 58,
                  startDegreeOffset: -90,
                  sections: [
                    for (final s in slices)
                      PieChartSectionData(
                        value: s.$3.toDouble(),
                        color: s.$2,
                        radius: 28,
                        showTitle: false,
                      ),
                  ],
                ),
              ),
              Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text('Total',
                      style: text.labelMedium
                          ?.copyWith(color: scheme.onSurfaceVariant)),
                  Text(formatNaira(total), style: text.amount(20)),
                ],
              ),
            ],
          ),
        ),
        const SizedBox(height: 16),
        for (final s in slices)
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 6),
            child: Row(
              children: [
                Container(
                  width: 10,
                  height: 10,
                  decoration:
                      BoxDecoration(color: s.$2, shape: BoxShape.circle),
                ),
                const SizedBox(width: 10),
                Expanded(child: Text(s.$1, style: text.bodyMedium)),
                Text(formatNaira(s.$3),
                    style:
                        text.titleSmall?.copyWith(fontWeight: FontWeight.w600)),
                SizedBox(
                  width: 48,
                  child: Text(
                    '${(s.$3 * 100 / total).round()}%',
                    textAlign: TextAlign.right,
                    style: text.bodySmall
                        ?.copyWith(color: scheme.onSurfaceVariant),
                  ),
                ),
              ],
            ),
          ),
      ],
    );
  }
}

class _PlanRow extends StatelessWidget {
  const _PlanRow({required this.category, required this.week});
  final BudgetCategory? category;
  final CategoryWeek week;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final text = theme.textTheme;
    final scheme = theme.colorScheme;
    final k = context.koboColors;

    final color = switch (healthOf(spent: week.spent, planned: week.share)) {
      BudgetHealth.good => k.good,
      BudgetHealth.warn => k.warn,
      BudgetHealth.over => k.danger,
      BudgetHealth.unplanned => scheme.onSurfaceVariant,
    };
    final fraction = week.share <= 0
        ? (week.spent > 0 ? 1.0 : 0.0)
        : math.min(1.0, week.spent / week.share);

    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 14, 16, 14),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Row(
            children: [
              CategoryAvatar(
                iconKey: category?.iconKey ?? 'other',
                colorValue: category?.colorValue ?? 0xFF78716C,
                radius: 16,
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Text(category?.name ?? 'Removed category',
                    style:
                        text.titleSmall?.copyWith(fontWeight: FontWeight.w600)),
              ),
              Text(
                week.share > 0
                    ? '${formatNaira(week.spent)} of ${formatNaira(week.share)}'
                    : '${formatNaira(week.spent)}, no budget',
                style: text.labelLarge
                    ?.copyWith(color: color, fontWeight: FontWeight.w700),
              ),
            ],
          ),
          const SizedBox(height: 10),
          ProgressLine(fraction: fraction, color: color),
        ],
      ),
    );
  }
}
