import 'package:flutter_test/flutter_test.dart';
import 'package:kobo/core/backup/csv.dart';

void main() {
  group('csvField', () {
    test('plain text is left alone', () {
      expect(csvField('Food'), 'Food');
    });
    test('commas, quotes and newlines are quoted', () {
      expect(csvField('Rice, beans'), '"Rice, beans"');
      expect(csvField('Said "hi"'), '"Said ""hi"""');
      expect(csvField('Line\nbreak'), '"Line\nbreak"');
    });
  });

  group('koboToPlain', () {
    test('two decimal places, no commas', () {
      expect(koboToPlain(150050), '1500.50');
      expect(koboToPlain(5), '0.05');
      expect(koboToPlain(100000000), '1000000.00');
      expect(koboToPlain(-2500), '-25.00');
    });
  });

  test('builds header and rows', () {
    final csv = buildTransactionsCsv([
      CsvRow(
        when: DateTime(2026, 10, 16, 13, 5),
        type: 'Expense',
        category: 'Food',
        amountKobo: 150000,
        note: 'Jollof, plantain',
      ),
      CsvRow(
        when: DateTime(2026, 10, 17, 9, 0),
        type: 'Income',
        category: 'Allowance',
        amountKobo: 5000000,
      ),
    ]);
    final lines = csv.split('\r\n');
    expect(lines[0], 'Date,Time,Type,Category,Amount (NGN),Note');
    expect(lines[1], '2026-10-16,13:05,Expense,Food,1500.00,"Jollof, plantain"');
    expect(lines[2], '2026-10-17,09:00,Income,Allowance,50000.00,');
  });
}
