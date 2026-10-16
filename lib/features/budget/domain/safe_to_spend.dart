import 'dart:math' as math;

import '../../../core/dates.dart';

int _clamp(int v, int lo, int hi) => v < lo ? lo : (v > hi ? hi : v);

class SafeToSpend {
  const SafeToSpend({
    required this.today,
    required this.week,
    required this.dailyLimit,
    required this.daysLeft,
    required this.overToday,
  });

  /// What's left to spend today without eating into later days.
  final int today;

  /// Today plus the rest of this week (Mon–Sun), capped at what you have.
  final int week;

  /// Even split of the money you had at the start of today.
  final int dailyLimit;

  /// Days the money must cover, including today. Never less than 1.
  final int daysLeft;

  /// How far past today's limit you've gone, or 0.
  final int overToday;

  factory SafeToSpend.compute({
    required int spendableKobo,
    required int spentTodayKobo,
    required DateTime cycleEnd,
    required DateTime now,
  }) {
    final days = cycleDays(cycleEnd, now: now);
    final available = math.max(0, spendableKobo);

    // Today's limit is based on what you had before today's spending,
    // so spending doesn't shrink the limit you're measured against.
    final startOfDay = math.max(0, spendableKobo + spentTodayKobo);
    final limit = startOfDay ~/ days;
    final leftToday = limit - spentTodayKobo;

    final daysLeftInWeek = 8 - now.weekday; // Monday = 7 … Sunday = 1
    final weekDays = math.min(daysLeftInWeek, days);

    return SafeToSpend(
      today: _clamp(leftToday, 0, available),
      week: _clamp(limit * weekDays - spentTodayKobo, 0, available),
      dailyLimit: limit,
      daysLeft: days,
      overToday: math.max(0, -leftToday),
    );
  }
}

enum BudgetHealth { unplanned, good, warn, over }

/// Green under 80%, amber from 80%, red at 100% and above.
BudgetHealth healthOf({required int spent, required int planned}) {
  if (planned <= 0) {
    return spent > 0 ? BudgetHealth.over : BudgetHealth.unplanned;
  }
  if (spent * 100 >= planned * 100) return BudgetHealth.over;
  if (spent * 100 >= planned * 80) return BudgetHealth.warn;
  return BudgetHealth.good;
}
