// test/core/money_test.dart
import 'package:flutter_test/flutter_test.dart';
import 'package:kobo/core/money/money.dart';

void main() {
  group('formatNaira', () {
    test('formats with commas and no kobo', () {
      expect(formatNaira(1250000), '₦12,500');
      expect(formatNaira(0), '₦0');
    });
    test('shows kobo when non-zero', () {
      expect(formatNaira(1250050), '₦12,500.50');
    });
    test('handles negatives', () {
      expect(formatNaira(-50000), '-₦500');
    });
  });

  group('parseNairaToKobo', () {
    test('parses plain, comma and symbol input', () {
      expect(parseNairaToKobo('300'), 30000);
      expect(parseNairaToKobo('12,500'), 1250000);
      expect(parseNairaToKobo('₦ 2,500.5'), 250050);
      expect(parseNairaToKobo('.75'), 75);
    });
    test('rejects bad input', () {
      expect(parseNairaToKobo(''), isNull);
      expect(parseNairaToKobo('-500'), isNull);
      expect(parseNairaToKobo('12.345'), isNull);
      expect(parseNairaToKobo('abc'), isNull);
      expect(parseNairaToKobo('99999999999'), isNull);
    });
  });

  group('validateAmount', () {
    test('zero and over-max are errors', () {
      expect(validateAmount('0'), isNotNull);
      expect(validateAmount('0', allowZero: true), isNull);
      expect(validateAmount('10,000,001'), isNotNull);
      expect(validateAmount('10,000,000'), isNull);
    });
  });
}