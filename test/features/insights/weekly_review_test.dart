import 'package:flutter_test/flutter_test.dart';
import 'package:kobo/core/database/app_database.dart';
import 'package:kobo/features/insights/domain/weekly_review.dart';

int n(int naira) => naira * 100;

var _id = 0;
Txn tx(TxType type, int kobo, int categoryId, DateTime when) => Txn(
      id: ++_id,
      type: type,
      amountKobo: kobo,
      categoryId: categoryId,
      occurredAt: when,
      createdAt: when,
    );

void main() {
  // 12 Oct 2026 is a Monday.
  final monday = DateTime(2026, 10, 12);

  test('buckets spending by day and keeps income separate', () {
    final r = WeeklyReview.compute(
      weekStart: monday,
      txns: [
        tx(TxType.expense, n(1000), 1, DateTime(2026, 10, 12, 9)),
        tx(TxType.expense, n(500), 2, DateTime(2026, 10, 12, 20)),
        tx(TxType.income, n(50000), 9, DateTime(2026, 10, 13, 10)),
        tx(TxType.expense, n(2000), 1, DateTime(2026, 10, 14, 12)),
        tx(TxType.expense, n(300), 1, DateTime(2026, 10, 18, 23, 59)),
      ],
      plannedByCategory: const {},
      cycleLengthDays: 30,
    );
    expect(r.daily, [n(1500), 0, n(2000), 0, 0, 0, n(300)]);
    expect(r.totalSpent, n(3800));
    expect(r.totalReceived, n(50000));
    expect(r.categories.first.categoryId, 1);
  });

  test('weekly share spreads the period plan evenly', () {
    final r = WeeklyReview.compute(
      weekStart: monday,
      txns: const [],
      plannedByCategory: {1: n(31000)},
      cycleLengthDays: 31,
    );
    expect(r.categories.single.share, n(7000));
    expect(r.totalShare, n(7000));
    expect(r.dailyShare, n(1000));
  });

  test('a period shorter than a week uses its whole plan', () {
    final r = WeeklyReview.compute(
      weekStart: monday,
      txns: const [],
      plannedByCategory: {1: n(3000)},
      cycleLengthDays: 3,
    );
    expect(r.categories.single.share, n(3000));
  });

  test('top overspend is the largest overrun, not the largest spend', () {
    final r = WeeklyReview.compute(
      weekStart: monday,
      txns: [
        tx(TxType.expense, n(1500), 1, DateTime(2026, 10, 13)),
        tx(TxType.expense, n(7500), 2, DateTime(2026, 10, 14)),
      ],
      plannedByCategory: {1: n(3100), 2: n(31000)},
      cycleLengthDays: 31,
    );
    expect(r.topOverspend!.categoryId, 1);
    expect(r.topOverspend!.over, n(800));
  });

  test('spending in an unbudgeted category counts as overspend', () {
    final r = WeeklyReview.compute(
      weekStart: monday,
      txns: [tx(TxType.expense, n(400), 3, DateTime(2026, 10, 15))],
      plannedByCategory: const {},
      cycleLengthDays: 30,
    );
    expect(r.topOverspend!.categoryId, 3);
    expect(r.topOverspend!.share, 0);
  });

  test('a quiet week has no overspend', () {
    final r = WeeklyReview.compute(
      weekStart: monday,
      txns: const [],
      plannedByCategory: {1: n(31000)},
      cycleLengthDays: 31,
    );
    expect(r.totalSpent, 0);
    expect(r.topOverspend, isNull);
  });
}
