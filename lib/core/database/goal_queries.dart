import 'package:drift/drift.dart';

import 'app_database.dart';

extension GoalQueries on AppDatabase {
  /// Active goals with how much is saved in each, oldest first.
  Stream<List<(SavingsGoal, int)>> watchGoalsWithSaved() {
    final saved = goalContributions.amountKobo.sum();
    final query = select(savingsGoals).join([
      leftOuterJoin(
        goalContributions,
        goalContributions.goalId.equalsExp(savingsGoals.id),
        useColumns: false,
      ),
    ])
      ..addColumns([saved])
      ..where(savingsGoals.archived.equals(false))
      ..groupBy([savingsGoals.id])
      ..orderBy([OrderingTerm.asc(savingsGoals.createdAt)]);
    return query.watch().map((rows) => [
          for (final r in rows) (r.readTable(savingsGoals), r.read(saved) ?? 0),
        ]);
  }

  Future<List<SavingsGoal>> getGoals() => (select(savingsGoals)
        ..where((g) => g.archived.equals(false))
        ..orderBy([(g) => OrderingTerm.asc(g.createdAt)]))
      .get();

  Future<int> addGoal({
    required String name,
    required int targetKobo,
    DateTime? deadline,
  }) =>
      into(savingsGoals).insert(SavingsGoalsCompanion.insert(
        name: name,
        targetKobo: targetKobo,
        deadline: Value(deadline),
      ));

  Future<void> updateGoal(
    int id, {
    required String name,
    required int targetKobo,
    DateTime? deadline,
  }) =>
      (update(savingsGoals)..where((g) => g.id.equals(id)))
          .write(SavingsGoalsCompanion(
        name: Value(name),
        targetKobo: Value(targetKobo),
        deadline: Value(deadline),
      ));

  /// Its contributions are deleted with it, so the money returns to balance.
  Future<void> deleteGoal(int id) =>
      (delete(savingsGoals)..where((g) => g.id.equals(id))).go();

  /// Positive sets money aside; negative takes it out.
  Future<void> addContribution(int goalId, int amountKobo, {String? note}) =>
      into(goalContributions).insert(GoalContributionsCompanion.insert(
        goalId: goalId,
        amountKobo: amountKobo,
        note: Value(note),
      ));

  /// Balance minus money set aside in goals, right now.
  Future<int> currentSpendableKobo() async {
    final settings = await getSettings();
    final income = transactions.amountKobo
        .sum(filter: transactions.type.equalsValue(TxType.income));
    final expense = transactions.amountKobo
        .sum(filter: transactions.type.equalsValue(TxType.expense));
    final tx = await (selectOnly(transactions)..addColumns([income, expense]))
        .getSingle();
    final saved = goalContributions.amountKobo.sum();
    final s = await (selectOnly(goalContributions)..addColumns([saved]))
        .getSingle();
    return settings.openingBalanceKobo +
        (tx.read(income) ?? 0).toInt() -
        (tx.read(expense) ?? 0).toInt() -
        (s.read(saved) ?? 0).toInt();
  }

  /// Ends the current period and starts a new one from today.
  Future<void> startNewPeriod({
    required DateTime end,
    required int startingBalanceKobo,
    required Map<int, int> plannedByCategory,
    required int plannedSavingsKobo,
    int? savingsGoalId,
  }) =>
      transaction(() async {
        await update(budgetCycles)
            .write(const BudgetCyclesCompanion(isActive: Value(false)));
        final now = DateTime.now();
        final cycleId = await into(budgetCycles).insert(
          BudgetCyclesCompanion.insert(
            startDate: DateTime(now.year, now.month, now.day),
            endDate: end,
            startingBalanceKobo: startingBalanceKobo,
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
        if (savingsGoalId != null && plannedSavingsKobo > 0) {
          await addContribution(savingsGoalId, plannedSavingsKobo,
              note: 'Planned savings');
        }
      });

  /// Adds [deltaKobo] to a category's budget in a period.
  Future<void> bumpPlannedLine(int cycleId, int categoryId, int deltaKobo) async {
    final line = await (select(budgetLines)
          ..where((l) =>
              l.cycleId.equals(cycleId) & l.categoryId.equals(categoryId)))
        .getSingleOrNull();
    if (line == null) {
      await into(budgetLines).insert(BudgetLinesCompanion.insert(
        cycleId: cycleId,
        categoryId: categoryId,
        plannedKobo: deltaKobo,
      ));
    } else {
      await (update(budgetLines)..where((l) => l.id.equals(line.id))).write(
          BudgetLinesCompanion(plannedKobo: Value(line.plannedKobo + deltaKobo)));
    }
  }

  Future<void> markAlerted(int lineId, {bool at80 = false, bool at100 = false}) =>
      (update(budgetLines)..where((l) => l.id.equals(lineId)))
          .write(BudgetLinesCompanion(
        alerted80: at80 ? const Value(true) : const Value.absent(),
        alerted100: at100 ? const Value(true) : const Value.absent(),
      ));
}
