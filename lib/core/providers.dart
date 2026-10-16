import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'database/app_database.dart';

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