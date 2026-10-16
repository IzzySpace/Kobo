import 'package:intl/intl.dart';

/// All money in Kobo is stored as integer kobo. ₦1 = 100 kobo.
const int koboPerNaira = 100;

/// ₦10,000,000 — anything above this is almost certainly a typo.
const int maxAmountKobo = 10000000 * koboPerNaira;

final NumberFormat _grouped = NumberFormat('#,##0', 'en_US');
final RegExp _amountPattern = RegExp(r'^\d+(\.\d{1,2})?$');
final RegExp _stripChars = RegExp(r'[₦,\s]');

/// ₦12,500 — kobo shown only when non-zero (₦12,500.50) or forced.
String formatNaira(int kobo, {bool forceKobo = false}) {
  final negative = kobo < 0;
  final abs = kobo.abs();
  final naira = abs ~/ koboPerNaira;
  final rem = abs % koboPerNaira;
  final fraction =
      (rem != 0 || forceKobo) ? '.${rem.toString().padLeft(2, '0')}' : '';
  return '${negative ? '-' : ''}₦${_grouped.format(naira)}$fraction';
}

/// Compact form for chart labels: ₦950, ₦12.5k, ₦1.2m.
String formatNairaCompact(int kobo) {
  final naira = kobo / koboPerNaira;
  final sign = naira < 0 ? '-' : '';
  final abs = naira.abs();
  String trim(double v) =>
      v.toStringAsFixed(1).replaceAll(RegExp(r'\.0$'), '');
  if (abs >= 1000000) return '$sign₦${trim(abs / 1000000)}m';
  if (abs >= 1000) return '$sign₦${trim(abs / 1000)}k';
  return '$sign₦${abs.round()}';
}

/// Parses user input like "12,500", "₦2500.5", "300" into kobo.
/// Returns null for anything invalid, including negatives.
int? parseNairaToKobo(String raw) {
  var cleaned = raw.replaceAll(_stripChars, '');
  if (cleaned.isEmpty) return null;
  if (cleaned.startsWith('.')) cleaned = '0$cleaned';
  if (!_amountPattern.hasMatch(cleaned)) return null;

  final parts = cleaned.split('.');
  // Guard against overflow before int.parse.
  if (parts[0].length > 10) return null;

  final naira = int.parse(parts[0]);
  final kobo = parts.length == 2 ? int.parse(parts[1].padRight(2, '0')) : 0;
  return naira * koboPerNaira + kobo;
}

/// Returns an error message, or null if the amount is valid.
String? validateAmount(String raw, {bool allowZero = false}) {
  final kobo = parseNairaToKobo(raw);
  if (kobo == null) return 'Enter a valid amount';
  if (kobo == 0 && !allowZero) return 'Amount must be more than ₦0';
  if (kobo > maxAmountKobo) {
    return 'That’s above ₦10,000,000. Check the amount.';
  }
  return null;
}