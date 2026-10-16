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

extension TransactionEdits on AppDatabase {
  Future<void> updateTransaction(
    int id, {
    required TxType type,
    required int amountKobo,
    required int categoryId,
    String? note,
    required DateTime occurredAt,
  }) =>
      (update(transactions)..where((t) => t.id.equals(id)))
          .write(TransactionsCompanion(
        type: Value(type),
        amountKobo: Value(amountKobo),
        categoryId: Value(categoryId),
        note: Value(note),
        occurredAt: Value(occurredAt),
      ));

  /// Writes an old version back, for undoing an edit.
  Future<void> replaceTransaction(Txn txn) =>
      update(transactions).replace(txn);

  /// Newest first. Any filter left null is ignored. [to] is exclusive.
  Stream<List<Txn>> watchTransactionsFiltered({
    DateTime? from,
    DateTime? to,
    TxType? type,
    int? categoryId,
  }) {
    final query = select(transactions)
      ..where((t) {
        Expression<bool> e = const Constant(true);
        if (from != null) e = e & t.occurredAt.isBiggerOrEqualValue(from!);
        if (to != null) e = e & t.occurredAt.isSmallerThanValue(to!);
        if (type != null) e = e & t.type.equalsValue(type!);
        if (categoryId != null) e = e & t.categoryId.equals(categoryId!);
        return e;
      })
      ..orderBy([
        (t) => OrderingTerm.desc(t.occurredAt),
        (t) => OrderingTerm.desc(t.id),
      ]);
    return query.watch();
  }

  Stream<List<Txn>> watchTransactionsBetween(DateTime from, DateTime to) =>
      watchTransactionsFiltered(from: from, to: to);
}
