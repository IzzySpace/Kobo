import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../core/database/app_database.dart';
import '../../core/dates.dart';
import '../../core/providers.dart';
import 'domain/budget_suggester.dart';

const _unset = Object();

class PlanDraft {
  const PlanDraft({
    this.balanceKobo = 0,
    this.usualIncomeKobo = 0,
    this.frequency = IncomeFrequency.monthly,
    this.cycleEnd,
    this.goal,
    this.planned = const {},
    this.savingsKobo = 0,
  });

  final int balanceKobo;
  final int usualIncomeKobo;
  final IncomeFrequency frequency;
  final DateTime? cycleEnd;
  final GoalDraft? goal;
  final Map<int, int> planned;
  final int savingsKobo;

  int get days => cycleEnd == null ? 1 : cycleDays(cycleEnd!);
  int get plannedTotalKobo =>
      planned.values.fold(0, (a, b) => a + b) + savingsKobo;
  int get unassignedKobo => balanceKobo - plannedTotalKobo;

  PlanDraft copyWith({
    int? balanceKobo,
    int? usualIncomeKobo,
    IncomeFrequency? frequency,
    Object? cycleEnd = _unset,
    Object? goal = _unset,
    Map<int, int>? planned,
    int? savingsKobo,
  }) =>
      PlanDraft(
        balanceKobo: balanceKobo ?? this.balanceKobo,
        usualIncomeKobo: usualIncomeKobo ?? this.usualIncomeKobo,
        frequency: frequency ?? this.frequency,
        cycleEnd:
            identical(cycleEnd, _unset) ? this.cycleEnd : cycleEnd as DateTime?,
        goal: identical(goal, _unset) ? this.goal : goal as GoalDraft?,
        planned: planned ?? this.planned,
        savingsKobo: savingsKobo ?? this.savingsKobo,
      );
}

/// Shared by onboarding and "start a new period".
abstract class PlanController extends Notifier<PlanDraft> {
  AppDatabase get db => ref.read(databaseProvider);

  /// First visit fills a suggestion; later visits keep edits and only
  /// add new categories (at ₦0) or drop removed ones.
  Future<void> preparePlan() async {
    final cats = await db.getCategories(CategoryKind.expense);
    if (state.planned.isEmpty) {
      applySuggestion(cats);
      return;
    }
    state = state.copyWith(
      planned: {for (final c in cats) c.id: state.planned[c.id] ?? 0},
    );
  }

  Future<void> resuggest() async =>
      applySuggestion(await db.getCategories(CategoryKind.expense));

  void applySuggestion(List<BudgetCategory> cats) {
    final s = BudgetSuggester.suggest(
      availableKobo: state.balanceKobo,
      days: state.days,
      hasSavingsGoal: state.goal != null,
      categories: [
        for (final c in cats)
          CategorySlot(
            id: c.id,
            iconKey: c.iconKey,
            tier: c.tier ?? PriorityTier.wants,
          ),
      ],
    );
    state = state.copyWith(
      planned: s.plannedByCategory,
      savingsKobo: s.savingsKobo,
    );
  }

  void setPlanned(int categoryId, int kobo) =>
      state = state.copyWith(planned: {...state.planned, categoryId: kobo});

  void setSavings(int kobo) => state = state.copyWith(savingsKobo: kobo);

  void moveUnassignedToSavings() {
    final extra = state.unassignedKobo;
    if (extra > 0) setSavings(state.savingsKobo + extra);
  }

  Future<void> finish();
}
