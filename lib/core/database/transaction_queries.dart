import 'package:drift/drift.dart';

import 'app_database.dart';

typedef TxTotals = ({int income, int expense});

extension TransactionQueries on AppDatabase {
  /// Every category, archived included, so history can always show names.
  Stream<List<BudgetCategory>> watchAllCategories() =>
      select(categories).watch();

  Future<int> addTransaction({
    required TxType type,
    required int amountKobo,
    required int categoryId,
    String? note,
    required DateTime occurredAt,
  }) =>
      into(transactions).insert(TransactionsCompanion.insert(
        type: type,
        amountKobo: amountKobo,
        categoryId: categoryId,
        note: Value(note),
        occurredAt: occurredAt,
      ));

  Future<void> deleteTransaction(int id) =>
      (delete(transactions)..where((t) => t.id.equals(id))).go();

  /// Puts a deleted transaction back with its original id (for Undo).
  Future<void> restoreTransaction(Txn txn) => into(transactions).insert(txn);

  Stream<List<Txn>> watchTransactionsSince(DateTime since) =>
      (select(transactions)
            ..where((t) => t.occurredAt.isBiggerOrEqualValue(since))
            ..orderBy([
              (t) => OrderingTerm.desc(t.occurredAt),
              (t) => OrderingTerm.desc(t.id),
            ]))
          .watch();

  /// All-time income and expense totals, for the balance.
  Stream<TxTotals> watchTxTotals() {
    final income = transactions.amountKobo
        .sum(filter: transactions.type.equalsValue(TxType.income));
    final expense = transactions.amountKobo
        .sum(filter: transactions.type.equalsValue(TxType.expense));
    return (selectOnly(transactions)..addColumns([income, expense]))
        .watchSingle()
        .map((r) => (
              income: r.read(income) ?? 0,
              expense: r.read(expense) ?? 0,
            ));
  }

  /// Money currently set aside in savings goals.
  Stream<int> watchSavedTotal() {
    final total = goalContributions.amountKobo.sum();
    return (selectOnly(goalContributions)..addColumns([total]))
        .watchSingle()
        .map((r) => r.read(total) ?? 0);
  }

  /// Most recently used categories for a type, newest first.
  Future<List<int>> recentCategoryIds(TxType type, {int limit = 4}) async {
    final rows = await (select(transactions)
          ..where((t) => t.type.equalsValue(type))
          ..orderBy([(t) => OrderingTerm.desc(t.occurredAt)])
          ..limit(40))
        .get();
    final ids = <int>[];
    for (final r in rows) {
      if (!ids.contains(r.categoryId)) ids.add(r.categoryId);
      if (ids.length == limit) break;
    }
    return ids;
  }
}
