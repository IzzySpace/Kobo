import 'package:flutter_test/flutter_test.dart';
import 'package:kobo/features/budget/domain/safe_to_spend.dart';

void main() {
  test('daily limit rounds down to whole naira', () {
    // ₦150,000 over 31 days is ₦4,838.70 a day; Kobo shows ₦4,838.
    final s = SafeToSpend.compute(
      spendableKobo: 15000000,
      spentTodayKobo: 0,
      cycleEnd: DateTime(2026, 11, 12),
      now: DateTime(2026, 10, 12, 9),
    );
    expect(s.daysLeft, 31);
    expect(s.dailyLimit, 483800);
    expect(s.today, 483800);
    expect(s.today % 100, 0);
    expect(s.week % 100, 0);
  });
}
