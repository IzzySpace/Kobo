import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'database/app_database.dart';
import 'database/transaction_queries.dart';
import 'dates.dart';

final databaseProvider = Provider<AppDatabase>((ref) {
  final db = AppDatabase();
  ref.onDispose(db.close);
  return db;
});

final settingsProvider = StreamProvider<SettingsRow>(
  (ref) => ref.watch(databaseProvider).watchSettings(),
);

final expenseCategoriesProvider = StreamProvider<List<BudgetCategory>>(
  (ref) => ref.watch(databaseProvider).watchCategories(CategoryKind.expense),
);

final incomeCategoriesProvider = StreamProvider<List<BudgetCategory>>(
  (ref) => ref.watch(databaseProvider).watchCategories(CategoryKind.income),
);

final allCategoriesProvider = StreamProvider<Map<int, BudgetCategory>>(
  (ref) => ref
      .watch(databaseProvider)
      .watchAllCategories()
      .map((list) => {for (final c in list) c.id: c}),
);

final activeCycleProvider = StreamProvider<BudgetCycle?>(
  (ref) => ref.watch(databaseProvider).watchActiveCycle(),
);

final activePlanProvider =
    StreamProvider<List<(BudgetCategory, BudgetLine)>>((ref) {
  final cycleId = switch (ref.watch(activeCycleProvider)) {
    AsyncData(:final value?) => value.id,
    _ => null,
  };
  if (cycleId == null) return Stream.value(const []);
  return ref.watch(databaseProvider).watchPlan(cycleId);
});

/// Transactions in the current budget period, newest first.
final cycleTransactionsProvider = StreamProvider<List<Txn>>((ref) {
  final start = switch (ref.watch(activeCycleProvider)) {
    AsyncData(:final value?) => value.startDate,
    _ => null,
  };
  return ref
      .watch(databaseProvider)
      .watchTransactionsSince(start ?? dateOnly(DateTime.now()));
});

final txTotalsProvider = StreamProvider<TxTotals>(
  (ref) => ref.watch(databaseProvider).watchTxTotals(),
);

final savedTotalProvider = StreamProvider<int>(
  (ref) => ref.watch(databaseProvider).watchSavedTotal(),
);

/// Ticks every minute so "today" and "this week" stay right past midnight.
final nowProvider = StreamProvider<DateTime>((ref) async* {
  yield DateTime.now();
  yield* Stream.periodic(const Duration(minutes: 1), (_) => DateTime.now());
});
