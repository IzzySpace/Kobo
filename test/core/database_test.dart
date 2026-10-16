// test/core/database_test.dart
import 'package:drift/native.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:kobo/core/database/app_database.dart';

void main() {
  late AppDatabase db;

  setUp(() => db = AppDatabase(NativeDatabase.memory()));
  tearDown(() => db.close());

  test('seeds settings row with defaults', () async {
    final s = await db.getSettings();
    expect(s.onboardingDone, isFalse);
    expect(s.themeMode, AppThemeMode.system);
  });

  test('seeds 12 expense and 4 income categories', () async {
    final expense = await db.watchCategories(CategoryKind.expense).first;
    final income = await db.watchCategories(CategoryKind.income).first;
    expect(expense.length, 12);
    expect(income.length, 4);
    expect(expense.map((c) => c.name), contains('Bank & POS Charges'));
  });

  test('rejects zero and negative transaction amounts', () async {
    final cat = (await db.watchCategories(CategoryKind.expense).first).first;
    for (final bad in [0, -100]) {
      await expectLater(
        db.into(db.transactions).insert(TransactionsCompanion.insert(
              type: TxType.expense,
              amountKobo: bad,
              categoryId: cat.id,
              occurredAt: DateTime.now(),
            )),
        throwsA(anything),
      );
    }
  });
}