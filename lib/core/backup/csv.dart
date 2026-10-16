import 'package:intl/intl.dart';

/// Quotes a field only when it needs it, doubling any quotes inside.
String csvField(String value) {
  final escaped = value.replaceAll('"', '""');
  return value.contains(RegExp(r'[",\r\n]')) ? '"$escaped"' : escaped;
}

/// 150050 kobo becomes "1500.50": no commas or ₦, so spreadsheets read it.
String koboToPlain(int kobo) {
  final sign = kobo < 0 ? '-' : '';
  final abs = kobo.abs();
  return '$sign${abs ~/ 100}.${(abs % 100).toString().padLeft(2, '0')}';
}

class CsvRow {
  const CsvRow({
    required this.when,
    required this.type,
    required this.category,
    required this.amountKobo,
    this.note,
  });

  final DateTime when;
  final String type;
  final String category;
  final int amountKobo;
  final String? note;
}

String buildTransactionsCsv(List<CsvRow> rows) {
  final day = DateFormat('yyyy-MM-dd');
  final time = DateFormat('HH:mm');
  final b = StringBuffer('Date,Time,Type,Category,Amount (NGN),Note\r\n');
  for (final r in rows) {
    b
      ..write([
        day.format(r.when),
        time.format(r.when),
        r.type,
        csvField(r.category),
        koboToPlain(r.amountKobo),
        csvField(r.note ?? ''),
      ].join(','))
      ..write('\r\n');
  }
  return b.toString();
}
