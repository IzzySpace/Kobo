import 'package:flutter_test/flutter_test.dart';
import 'package:kobo/features/budget/domain/income_split.dart';
import 'package:kobo/features/budget/domain/pace.dart';

int n(int naira) => naira * 100;

void main() {
  final now = DateTime(2026, 10, 16, 18);

  group('PaceWarning', () {
    test('warns with runs-out day and cut per day', () {
      // ₦20,000 over 5 days = ₦4,000/day. ₦30,000 left for 10 days.
      final w = PaceWarning.compute(
        spentThisCycleKobo: n(20000),
        cycleStart: DateTime(2026, 10, 12),
        now: now,
        spendableKobo: n(30000),
        daysLeft: 10,
      )!;
      expect(w.runsOutInDays, 7);
      expect(w.shortByDays, 3);
      expect(w.cutPerDay, n(1000));
    });

    test('no warning when on track', () {
      expect(
        PaceWarning.compute(
          spentThisCycleKobo: n(5000),
          cycleStart: DateTime(2026, 10, 12),
          now: now,
          spendableKobo: n(30000),
          daysLeft: 10,
        ),
        isNull,
      );
    });

    test('no warning on the first day', () {
      expect(
        PaceWarning.compute(
          spentThisCycleKobo: n(50000),
          cycleStart: DateTime(2026, 10, 16),
          now: now,
          spendableKobo: n(1000),
          daysLeft: 20,
        ),
        isNull,
      );
    });

    test('money used up runs out today', () {
      final w = PaceWarning.compute(
        spentThisCycleKobo: n(10000),
        cycleStart: DateTime(2026, 10, 12),
        now: now,
        spendableKobo: 0,
        daysLeft: 6,
      )!;
      expect(w.runsOutInDays, 0);
      expect(w.shortByDays, 6);
    });

    test('cut per day rounds up to whole naira', () {
      final w = PaceWarning.compute(
        spentThisCycleKobo: n(10001),
        cycleStart: DateTime(2026, 10, 12),
        now: now,
        spendableKobo: n(3000),
        daysLeft: 7,
      )!;
      expect(w.cutPerDay % 100, 0);
    });
  });

  group('IncomeSplit', () {
    test('40/40/20 on a round amount', () {
      final s = IncomeSplit.of(n(10000));
      expect(s.buffer, n(4000));
      expect(s.savings, n(4000));
      expect(s.treat, n(2000));
    });

    test('rounds savings and treat down to ₦100, buffer takes the rest', () {
      final s = IncomeSplit.of(n(1050));
      expect(s.savings, n(400));
      expect(s.treat, n(200));
      expect(s.buffer, n(450));
      expect(s.total, n(1050));
    });

    test('a tiny extra all goes to the buffer', () {
      final s = IncomeSplit.of(n(150));
      expect(s.savings, 0);
      expect(s.treat, 0);
      expect(s.buffer, n(150));
    });

    test('nothing extra, nothing split', () {
      expect(IncomeSplit.of(0).total, 0);
    });
  });
}
