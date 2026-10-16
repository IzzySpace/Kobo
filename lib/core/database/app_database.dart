import 'package:drift/drift.dart';
import 'package:drift_flutter/drift_flutter.dart';

import 'seed.dart';
import 'tables.dart';

export 'tables.dart';

part 'app_database.g.dart';

typedef GoalDraft = ({String name, int targetKobo, DateTime? deadline});

@DriftDatabase(tables: [
  AppSettings,
  Categories,
  BudgetCycles,
  BudgetLines,
  Transactions,
  SavingsGoals,
  GoalContributions,
])
class AppDatabase extends _$AppDatabase {
  /// Pass an executor in tests (e.g. NativeDatabase.memory()).
  AppDatabase([QueryExecutor? executor])
      : super(executor ?? driftDatabase(name: 'kobo'));

  @override
  int get schemaVersion => 2;

  @override
  MigrationStrategy get migration => MigrationStrategy(
        onCreate: (m) async {
          await m.createAll();
          await seedDefaults(this);
        },
        onUpgrade: (m, from, to) async {
          if (from < 2) {
            await m.addColumn(budgetCycles, budgetCycles.plannedSavingsKobo);
          }
        },
        beforeOpen: (details) async {
          await customStatement('PRAGMA foreign_keys = ON');
        },
      );

  // ---- Settings ----
  SimpleSelectStatement<$AppSettingsTable, SettingsRow> _settingsQuery() =>
      select(appSettings)..where((s) => s.id.equals(1));

  Future<SettingsRow> getSettings() => _settingsQuery().getSingle();
  Stream<SettingsRow> watchSettings() => _settingsQuery().watchSingle();

  Future<void> updateSettings(AppSettingsCompanion changes) =>
      (update(appSettings)..where((s) => s.id.equals(1))).write(changes);

  // ---- Categories ----
  SimpleSelectStatement<$CategoriesTable, BudgetCategory> _categoriesQuery(
          CategoryKind kind) =>
      select(categories)
        ..where((c) => c.kind.equalsValue(kind) & c.archived.equals(false))
        ..orderBy([
          (c) => OrderingTerm.asc(c.sortOrder),
          (c) => OrderingTerm.asc(c.id),
        ]);

  Stream<List<BudgetCategory>> watchCategories(CategoryKind kind) =>
      _categoriesQuery(kind).watch();

  Future<List<BudgetCategory>> getCategories(CategoryKind kind) =>
      _categoriesQuery(kind).get();

  Future<int> addCategory({
    required String name,
    required CategoryKind kind,
    PriorityTier? tier,
    required String iconKey,
    required int colorValue,
  }) async {
    final maxOrder = categories.sortOrder.max();
    final row = await (selectOnly(categories)
          ..addColumns([maxOrder])
          ..where(categories.kind.equalsValue(kind)))
        .getSingle();
    return into(categories).insert(CategoriesCompanion.insert(
      name: name,
      kind: kind,
      iconKey: iconKey,
      colorValue: colorValue,
      tier: Value(tier),
      sortOrder: Value((row.read(maxOrder) ?? -1) + 1),
    ));
  }

  Future<void> updateCategory(int id, CategoriesCompanion changes) =>
      (update(categories)..where((c) => c.id.equals(id))).write(changes);

  Future<void> archiveCategory(int id) =>
      updateCategory(id, const CategoriesCompanion(archived: Value(true)));

  // ---- Cycles & plan ----
  SimpleSelectStatement<$BudgetCyclesTable, BudgetCycle> _activeCycleQuery() =>
      select(budgetCycles)
        ..where((c) => c.isActive.equals(true))
        ..orderBy([(c) => OrderingTerm.desc(c.startDate)])
        ..limit(1);

  Future<BudgetCycle?> getActiveCycle() =>
      _activeCycleQuery().getSingleOrNull();

  Stream<BudgetCycle?> watchActiveCycle() =>
      _activeCycleQuery().watchSingleOrNull();

  Stream<List<(BudgetCategory, BudgetLine)>> watchPlan(int cycleId) {
    final query = select(budgetLines).join([
      innerJoin(categories, categories.id.equalsExp(budgetLines.categoryId)),
    ])
      ..where(budgetLines.cycleId.equals(cycleId) &
          categories.archived.equals(false))
      ..orderBy([
        OrderingTerm.asc(categories.sortOrder),
        OrderingTerm.asc(categories.id),
      ]);
    return query.watch().map((rows) => [
          for (final row in rows)
            (row.readTable(categories), row.readTable(budgetLines)),
        ]);
  }

  /// Saves everything from onboarding in one transaction.
  Future<void> completeOnboarding({
    required int balanceKobo,
    required int usualIncomeKobo,
    required IncomeFrequency frequency,
    required DateTime cycleEnd,
    required Map<int, int> plannedByCategory,
    required int plannedSavingsKobo,
    GoalDraft? goal,
  }) =>
      transaction(() async {
        await updateSettings(AppSettingsCompanion(
          onboardingDone: const Value(true),
          openingBalanceKobo: Value(balanceKobo),
          usualIncomeKobo: Value(usualIncomeKobo),
          incomeFrequency: Value(frequency),
        ));

        await update(budgetCycles)
            .write(const BudgetCyclesCompanion(isActive: Value(false)));

        final now = DateTime.now();
        final cycleId = await into(budgetCycles).insert(
          BudgetCyclesCompanion.insert(
            startDate: DateTime(now.year, now.month, now.day),
            endDate: cycleEnd,
            startingBalanceKobo: balanceKobo,
            plannedSavingsKobo: Value(plannedSavingsKobo),
          ),
        );

        await batch((b) => b.insertAll(budgetLines, [
              for (final e in plannedByCategory.entries)
                BudgetLinesCompanion.insert(
                  cycleId: cycleId,
                  categoryId: e.key,
                  plannedKobo: e.value,
                ),
            ]));

        if (goal != null) {
          await into(savingsGoals).insert(SavingsGoalsCompanion.insert(
            name: goal.name,
            targetKobo: goal.targetKobo,
            deadline: Value(goal.deadline),
          ));
        }
      });

  /// Wipes everything and re-seeds. Used by the debug reset button
  /// now, and by "restore" / "start over" in Phase 6.
  Future<void> resetAllData() => transaction(() async {
        await delete(goalContributions).go();
        await delete(savingsGoals).go();
        await delete(transactions).go();
        await delete(budgetLines).go();
        await delete(budgetCycles).go();
        await delete(categories).go();
        await delete(appSettings).go();
        await seedDefaults(this);
      });
}