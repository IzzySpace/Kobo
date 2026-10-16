import 'package:flutter_test/flutter_test.dart';
import 'package:kobo/features/budget/domain/safe_to_spend.dart';

int n(int naira) => naira * 100;

void main() {
  // 12 Oct 2026 is a Monday.
  final monday = DateTime(2026, 10, 12, 9);
  final sunday = DateTime(2026, 10, 18, 9);

  group('SafeToSpend', () {
    test('even split with nothing spent yet', () {
      final s = SafeToSpend.compute(
        spendableKobo: n(30000),
        spentTodayKobo: 0,
        cycleEnd: DateTime(2026, 11, 11),
        now: monday,
      );
      expect(s.daysLeft, 30);
      expect(s.dailyLimit, n(1000));
      expect(s.today, n(1000));
      expect(s.week, n(7000));
      expect(s.overToday, 0);
    });

    test('spending today reduces today, not the daily limit', () {
      final s = SafeToSpend.compute(
        spendableKobo: n(29600),
        spentTodayKobo: n(400),
        cycleEnd: DateTime(2026, 11, 11),
        now: monday,
      );
      expect(s.dailyLimit, n(1000));
      expect(s.today, n(600));
      expect(s.week, n(6600));
    });

    test('overspending shows how far over', () {
      final s = SafeToSpend.compute(
        spendableKobo: n(27000),
        spentTodayKobo: n(3000),
        cycleEnd: DateTime(2026, 11, 11),
        now: monday,
      );
      expect(s.today, 0);
      expect(s.overToday, n(2000));
      expect(s.week, n(4000));
    });

    test('on Sunday, this week equals today', () {
      final s = SafeToSpend.compute(
        spendableKobo: n(24000),
        spentTodayKobo: 0,
        cycleEnd: DateTime(2026, 11, 11),
        now: sunday,
      );
      expect(s.daysLeft, 24);
      expect(s.week, s.today);
    });

    test('cycle ending mid-week caps the week', () {
      final s = SafeToSpend.compute(
        spendableKobo: n(3000),
        spentTodayKobo: 0,
        cycleEnd: DateTime(2026, 10, 15),
        now: monday,
      );
      expect(s.daysLeft, 3);
      expect(s.week, n(3000));
    });

    test('income date already passed: everything is for today', () {
      final s = SafeToSpend.compute(
        spendableKobo: n(5000),
        spentTodayKobo: 0,
        cycleEnd: DateTime(2026, 10, 1),
        now: monday,
      );
      expect(s.daysLeft, 1);
      expect(s.today, n(5000));
      expect(s.week, n(5000));
    });

    test('zero balance', () {
      final s = SafeToSpend.compute(
        spendableKobo: 0,
        spentTodayKobo: 0,
        cycleEnd: DateTime(2026, 11, 11),
        now: monday,
      );
      expect(s.today, 0);
      expect(s.week, 0);
      expect(s.dailyLimit, 0);
    });

    test('negative balance never shows money to spend', () {
      final s = SafeToSpend.compute(
        spendableKobo: -n(500),
        spentTodayKobo: 0,
        cycleEnd: DateTime(2026, 11, 11),
        now: monday,
      );
      expect(s.today, 0);
      expect(s.week, 0);
    });

    test('week never exceeds what you have', () {
      for (final spendable in [0, n(1), n(999), n(7000), n(123456)]) {
        for (final spent in [0, n(100), n(5000)]) {
          final s = SafeToSpend.compute(
            spendableKobo: spendable,
            spentTodayKobo: spent,
            cycleEnd: DateTime(2026, 10, 20),
            now: monday,
          );
          expect(s.week, lessThanOrEqualTo(spendable));
          expect(s.today, lessThanOrEqualTo(s.week));
        }
      }
    });
  });

  group('healthOf', () {
    test('green, amber, red thresholds', () {
      expect(healthOf(spent: 0, planned: n(1000)), BudgetHealth.good);
      expect(healthOf(spent: n(799), planned: n(1000)), BudgetHealth.good);
      expect(healthOf(spent: n(800), planned: n(1000)), BudgetHealth.warn);
      expect(healthOf(spent: n(999), planned: n(1000)), BudgetHealth.warn);
      expect(healthOf(spent: n(1000), planned: n(1000)), BudgetHealth.over);
    });

    test('no budget', () {
      expect(healthOf(spent: 0, planned: 0), BudgetHealth.unplanned);
      expect(healthOf(spent: n(50), planned: 0), BudgetHealth.over);
    });
  });
}
