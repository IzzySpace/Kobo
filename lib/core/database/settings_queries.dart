import 'package:drift/drift.dart';

import 'app_database.dart';

extension SettingsQueries on AppDatabase {
  static const _restoreOrder = [
    'app_settings',
    'categories',
    'budget_cycles',
    'budget_lines',
    'transactions',
    'savings_goals',
    'goal_contributions',
  ];

  Future<void> updateActiveCycleEnd(DateTime end) async {
    final cycle = await getActiveCycle();
    if (cycle == null) return;
    await (update(budgetCycles)..where((c) => c.id.equals(cycle.id)))
        .write(BudgetCyclesCompanion(endDate: Value(end)));
  }

  Future<List<BudgetLine>> linesForCycle(int cycleId) =>
      (select(budgetLines)..where((l) => l.cycleId.equals(cycleId))).get();

  /// Sets each category's budget. Changed lines get their alerts re-armed.
  Future<void> savePlanForCycle(
    int cycleId,
    Map<int, int> plannedByCategory,
    int plannedSavingsKobo,
  ) =>
      transaction(() async {
        for (final e in plannedByCategory.entries) {
          final line = await (select(budgetLines)
                ..where((l) =>
                    l.cycleId.equals(cycleId) & l.categoryId.equals(e.key)))
              .getSingleOrNull();
          if (line == null) {
            await into(budgetLines).insert(BudgetLinesCompanion.insert(
              cycleId: cycleId,
              categoryId: e.key,
              plannedKobo: e.value,
            ));
          } else if (line.plannedKobo != e.value) {
            await (update(budgetLines)..where((l) => l.id.equals(line.id)))
                .write(BudgetLinesCompanion(
              plannedKobo: Value(e.value),
              alerted80: const Value(false),
              alerted100: const Value(false),
            ));
          }
        }
        await (update(budgetCycles)..where((c) => c.id.equals(cycleId))).write(
            BudgetCyclesCompanion(plannedSavingsKobo: Value(plannedSavingsKobo)));
      });

  /// Every transaction, oldest first, with its category (if it still exists).
  Future<List<(Txn, BudgetCategory?)>> allTransactionsWithCategory() async {
    final query = select(transactions).join([
      leftOuterJoin(
          categories, categories.id.equalsExp(transactions.categoryId)),
    ])
      ..orderBy([OrderingTerm.asc(transactions.occurredAt)]);
    final rows = await query.get();
    return [
      for (final r in rows)
        (r.readTable(transactions), r.readTableOrNull(categories)),
    ];
  }

  /// A consistent copy of the whole database at [path] (must not exist).
  Future<void> backupTo(String path) =>
      customStatement('VACUUM INTO ?', [path]);

  /// Replaces all data with a backup file. Checks it first; throws
  /// [FormatException] with a readable message if it isn't usable.
  Future<void> restoreFrom(String path) async {
    await customStatement('ATTACH DATABASE ? AS backup', [path]);
    try {
      final version =
          await customSelect('PRAGMA backup.user_version').getSingle();
      if (version.data.values.first != schemaVersion) {
        throw const FormatException(
            'This backup is from a different version of Kobo.');
      }

      // Copy by column name, not position: databases upgraded from an
      // older version can have columns in a different order.
      final columns = <String, String>{};
      for (final t in _restoreOrder) {
        final found = await customSelect(
          "SELECT count(*) AS c FROM backup.sqlite_master "
          "WHERE type = 'table' AND name = ?",
          variables: [Variable.withString(t)],
        ).getSingle();
        if (found.read<int>('c') == 0) {
          throw const FormatException('That file isn’t a Kobo backup.');
        }
        final info = await customSelect('PRAGMA main.table_info($t)').get();
        columns[t] = info.map((r) => '"${r.read<String>('name')}"').join(', ');
      }

      await transaction(() async {
        for (final t in _restoreOrder.reversed) {
          await customStatement('DELETE FROM main.$t');
        }
        for (final t in _restoreOrder) {
          final c = columns[t]!;
          await customStatement(
              'INSERT INTO main.$t ($c) SELECT $c FROM backup.$t');
        }
      });
    } finally {
      await customStatement('DETACH DATABASE backup');
    }
    markTablesUpdated(allTables);
  }
}
