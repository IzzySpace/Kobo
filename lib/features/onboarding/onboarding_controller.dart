import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../core/database/app_database.dart';
import '../../core/dates.dart';
import '../../core/providers.dart';
import '../budget/domain/budget_suggester.dart';

const _unset = Object();

class OnboardingDraft {
  const OnboardingDraft({
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

  OnboardingDraft copyWith({
    int? balanceKobo,
    int? usualIncomeKobo,
    IncomeFrequency? frequency,
    Object? cycleEnd = _unset,
    Object? goal = _unset,
    Map<int, int>? planned,
    int? savingsKobo,
  }) =>
      OnboardingDraft(
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

class OnboardingController extends Notifier<OnboardingDraft> {
  @override
  OnboardingDraft build() => const OnboardingDraft();

  AppDatabase get _db => ref.read(databaseProvider);

  void setBalance(int kobo) => state = state.copyWith(balanceKobo: kobo);

  void setIncome({
    required int usualKobo,
    required IncomeFrequency frequency,
    required DateTime cycleEnd,
  }) =>
      state = state.copyWith(
        usualIncomeKobo: usualKobo,
        frequency: frequency,
        cycleEnd: cycleEnd,
      );

  void setGoal(GoalDraft? goal) => state = state.copyWith(
        goal: goal,
        savingsKobo: goal == null ? 0 : null,
      );

  /// First visit: fills in a suggestion. Later visits keep your edits and
  /// only add new categories (at ₦0) or drop removed ones.
  Future<void> preparePlan() async {
    final cats = await _db.getCategories(CategoryKind.expense);
    if (state.planned.isEmpty) {
      _suggest(cats);
      return;
    }
    state = state.copyWith(
      planned: {for (final c in cats) c.id: state.planned[c.id] ?? 0},
    );
  }

  Future<void> resuggest() async =>
      _suggest(await _db.getCategories(CategoryKind.expense));

  void _suggest(List<BudgetCategory> cats) {
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

  Future<void> finish() async {
    final active = {
      for (final c in await _db.getCategories(CategoryKind.expense)) c.id,
    };
    await _db.completeOnboarding(
      balanceKobo: state.balanceKobo,
      usualIncomeKobo: state.usualIncomeKobo,
      frequency: state.frequency,
      cycleEnd: dateOnly(state.cycleEnd!),
      plannedByCategory: {
        for (final e in state.planned.entries)
          if (active.contains(e.key)) e.key: e.value,
      },
      plannedSavingsKobo: state.goal == null ? 0 : state.savingsKobo,
      goal: state.goal,
    );
  }
}

final onboardingProvider =
    NotifierProvider<OnboardingController, OnboardingDraft>(
  OnboardingController.new,
);