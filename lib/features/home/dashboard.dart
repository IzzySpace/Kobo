import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../core/database/app_database.dart';
import '../../core/database/transaction_queries.dart';
import '../../core/dates.dart';
import '../../core/providers.dart';
import '../budget/domain/safe_to_spend.dart';

class CategoryProgress {
  const CategoryProgress({
    required this.category,
    required this.planned,
    required this.spent,
  });

  final BudgetCategory category;
  final int planned;
  final int spent;

  BudgetHealth get health => healthOf(spent: spent, planned: planned);

  double get fraction {
    if (planned <= 0) return spent > 0 ? 1 : 0;
    final f = spent / planned;
    return f > 1 ? 1 : f;
  }
}

class Dashboard {
  const Dashboard({
    required this.now,
    required this.cycle,
    required this.balanceKobo,
    required this.savedKobo,
    required this.safe,
    required this.categories,
    required this.recent,
    required this.categoriesById,
    required this.spentThisCycleKobo,
    required this.plannedTotalKobo,
  });

  final DateTime now;
  final BudgetCycle? cycle;
  final int balanceKobo;
  final int savedKobo;
  final SafeToSpend safe;
  final List<CategoryProgress> categories;
  final List<Txn> recent;
  final Map<int, BudgetCategory> categoriesById;
  final int spentThisCycleKobo;
  final int plannedTotalKobo;

  /// Balance minus money set aside in savings goals.
  int get spendableKobo => balanceKobo - savedKobo;

  bool get periodEnded =>
      cycle != null && daysBetween(now, cycle!.endDate) <= 0;
}

Dashboard buildDashboard({
  required SettingsRow settings,
  required BudgetCycle? cycle,
  required List<(BudgetCategory, BudgetLine)> plan,
  required List<Txn> txns,
  required TxTotals totals,
  required int saved,
  required List<BudgetCategory> expenseCats,
  required Map<int, BudgetCategory> allCats,
  required DateTime now,
}) {
  final balance = settings.openingBalanceKobo + totals.income - totals.expense;
  final today = dateOnly(now);

  var spentToday = 0;
  var spentCycle = 0;
  final spentBy = <int, int>{};
  for (final t in txns) {
    if (t.type != TxType.expense) continue;
    spentCycle += t.amountKobo;
    spentBy[t.categoryId] = (spentBy[t.categoryId] ?? 0) + t.amountKobo;
    if (!t.occurredAt.isBefore(today)) spentToday += t.amountKobo;
  }

  final plannedBy = {for (final (c, l) in plan) c.id: l.plannedKobo};

  return Dashboard(
    now: now,
    cycle: cycle,
    balanceKobo: balance,
    savedKobo: saved,
    safe: SafeToSpend.compute(
      spendableKobo: balance - saved,
      spentTodayKobo: spentToday,
      cycleEnd: cycle?.endDate ?? DateTime(today.year, today.month, today.day + 1),
      now: now,
    ),
    categories: [
      for (final c in expenseCats)
        if ((plannedBy[c.id] ?? 0) > 0 || (spentBy[c.id] ?? 0) > 0)
          CategoryProgress(
            category: c,
            planned: plannedBy[c.id] ?? 0,
            spent: spentBy[c.id] ?? 0,
          ),
    ],
    recent: txns.take(8).toList(),
    categoriesById: allCats,
    spentThisCycleKobo: spentCycle,
    plannedTotalKobo: plannedBy.values.fold(0, (a, b) => a + b),
  );
}

final dashboardProvider = Provider<AsyncValue<Dashboard>>((ref) {
  final settings = ref.watch(settingsProvider);
  final cycle = ref.watch(activeCycleProvider);
  final plan = ref.watch(activePlanProvider);
  final txns = ref.watch(cycleTransactionsProvider);
  final totals = ref.watch(txTotalsProvider);
  final saved = ref.watch(savedTotalProvider);
  final expenseCats = ref.watch(expenseCategoriesProvider);
  final allCats = ref.watch(allCategoriesProvider);
  final now = ref.watch(nowProvider);

  for (final v in <AsyncValue<Object?>>[
    settings, cycle, plan, txns, totals, saved, expenseCats, allCats, now,
  ]) {
    if (v is AsyncError) return AsyncError<Dashboard>(v.error, v.stackTrace);
  }

  return switch ((
    settings, cycle, plan, txns, totals, saved, expenseCats, allCats, now,
  )) {
    (
      AsyncData(value: final s),
      AsyncData(value: final c),
      AsyncData(value: final p),
      AsyncData(value: final t),
      AsyncData(value: final tot),
      AsyncData(value: final sv),
      AsyncData(value: final ec),
      AsyncData(value: final ac),
      AsyncData(value: final n),
    ) =>
      AsyncData(buildDashboard(
        settings: s,
        cycle: c,
        plan: p,
        txns: t,
        totals: tot,
        saved: sv,
        expenseCats: ec,
        allCats: ac,
        now: n,
      )),
    _ => const AsyncLoading<Dashboard>(),
  };
});
