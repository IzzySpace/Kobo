import 'dart:math' as math;

import '../../../core/database/app_database.dart';
import '../../../core/dates.dart';

class CategoryWeek {
  const CategoryWeek({
    required this.categoryId,
    required this.spent,
    required this.share,
  });

  final int categoryId;
  final int spent;

  /// This category's period budget spread evenly over the period's weeks.
  final int share;

  int get over => spent - share;
}

class WeeklyReview {
  const WeeklyReview({
    required this.weekStart,
    required this.daily,
    required this.totalSpent,
    required this.totalReceived,
    required this.totalShare,
    required this.categories,
  });

  final DateTime weekStart;

  /// Spending per day, Monday first. Always 7 entries.
  final List<int> daily;
  final int totalSpent;
  final int totalReceived;
  final int totalShare;

  /// Categories with spending or a share, most spent first.
  final List<CategoryWeek> categories;

  int get dailyShare => totalShare ~/ 7;

  /// The category furthest past its weekly share, or null if none went over.
  CategoryWeek? get topOverspend {
    CategoryWeek? top;
    for (final c in categories) {
      if (c.over > 0 && (top == null || c.over > top.over)) top = c;
    }
    return top;
  }

  static WeeklyReview compute({
    required DateTime weekStart,
    required List<Txn> txns,
    required Map<int, int> plannedByCategory,
    required int cycleLengthDays,
  }) {
    final daily = List<int>.filled(7, 0);
    var spent = 0;
    var received = 0;
    final spentBy = <int, int>{};

    for (final t in txns) {
      if (t.type == TxType.income) {
        received += t.amountKobo;
        continue;
      }
      final i = daysBetween(weekStart, t.occurredAt);
      if (i < 0 || i > 6) continue;
      daily[i] += t.amountKobo;
      spent += t.amountKobo;
      spentBy[t.categoryId] = (spentBy[t.categoryId] ?? 0) + t.amountKobo;
    }

    final shareBy = <int, int>{};
    if (cycleLengthDays >= 1) {
      // A period shorter than a week contributes its whole budget.
      final weekDays = math.min(7, cycleLengthDays);
      for (final e in plannedByCategory.entries) {
        shareBy[e.key] = e.value * weekDays ~/ cycleLengthDays;
      }
    }

    final ids = {
      ...spentBy.keys,
      ...shareBy.keys.where((id) => shareBy[id]! > 0),
    };
    final categories = [
      for (final id in ids)
        CategoryWeek(
          categoryId: id,
          spent: spentBy[id] ?? 0,
          share: shareBy[id] ?? 0,
        ),
    ]..sort((a, b) {
        final bySpent = b.spent.compareTo(a.spent);
        return bySpent != 0 ? bySpent : b.share.compareTo(a.share);
      });

    return WeeklyReview(
      weekStart: weekStart,
      daily: daily,
      totalSpent: spent,
      totalReceived: received,
      totalShare: shareBy.values.fold(0, (a, b) => a + b),
      categories: categories,
    );
  }
}
