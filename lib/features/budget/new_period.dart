import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../core/database/app_database.dart';
import '../../core/database/goal_queries.dart';
import '../../core/dates.dart';
import 'domain/income_split.dart';
import 'plan_controller.dart';

DateTime defaultPeriodEnd(IncomeFrequency f) {
  final t = DateTime.now();
  return switch (f) {
    IncomeFrequency.weekly => DateTime(t.year, t.month, t.day + 7),
    IncomeFrequency.monthly => DateTime(t.year, t.month + 1, t.day),
    IncomeFrequency.irregular => DateTime(t.year, t.month, t.day + 30),
  };
}

class NewPeriodController extends PlanController {
  int _extraBuffer = 0;
  int _extraSavings = 0;
  int _extraTreat = 0;
  int? _goalId;

  @override
  PlanDraft build() => const PlanDraft();

  /// Loads today's money and defaults. Call before opening the screen.
  Future<void> begin({IncomeSplit? split}) async {
    final settings = await db.getSettings();
    final spendable = await db.currentSpendableKobo();
    final goals = await db.getGoals();
    final goal = goals.isEmpty ? null : goals.first;
    _goalId = goal?.id;

    _extraBuffer = split?.buffer ?? 0;
    _extraTreat = split?.treat ?? 0;
    _extraSavings = split?.savings ?? 0;
    if (goal == null) {
      // No goal to save towards: that share protects the buffer instead.
      _extraBuffer += _extraSavings;
      _extraSavings = 0;
    }

    state = PlanDraft(
      balanceKobo: spendable < 0 ? 0 : spendable,
      usualIncomeKobo: settings.usualIncomeKobo,
      frequency: settings.incomeFrequency,
      cycleEnd: dateOnly(defaultPeriodEnd(settings.incomeFrequency)),
      goal: goal == null
          ? null
          : (
              name: goal.name,
              targetKobo: goal.targetKobo,
              deadline: goal.deadline,
            ),
    );
  }

  /// Changing the end date throws away the plan so it's re-suggested.
  void setEnd(DateTime end) => state = state.copyWith(
        cycleEnd: dateOnly(end),
        planned: const {},
        savingsKobo: 0,
      );

  /// Survival-first suggestion, then the income split from what's left.
  @override
  void applySuggestion(List<BudgetCategory> cats) {
    super.applySuggestion(cats);
    var free = state.unassignedKobo;
    if (free <= 0) return;

    int take(int want) {
      final t = want < free ? want : free;
      free -= t;
      return t;
    }

    int? first(PriorityTier tier) {
      for (final c in cats) {
        if (c.tier == tier) return c.id;
      }
      return null;
    }

    final planned = {...state.planned};
    var savings = state.savingsKobo;
    final bufferId = first(PriorityTier.buffer);
    final treatId = first(PriorityTier.wants);
    if (bufferId != null) {
      planned[bufferId] = (planned[bufferId] ?? 0) + take(_extraBuffer);
    }
    if (state.goal != null) savings += take(_extraSavings);
    if (treatId != null) {
      planned[treatId] = (planned[treatId] ?? 0) + take(_extraTreat);
    }
    state = state.copyWith(planned: planned, savingsKobo: savings);
  }

  @override
  Future<void> finish() async {
    final active = {
      for (final c in await db.getCategories(CategoryKind.expense)) c.id,
    };
    await db.startNewPeriod(
      end: dateOnly(state.cycleEnd!),
      startingBalanceKobo: state.balanceKobo,
      plannedByCategory: {
        for (final e in state.planned.entries)
          if (active.contains(e.key)) e.key: e.value,
      },
      plannedSavingsKobo: state.goal == null ? 0 : state.savingsKobo,
      savingsGoalId: _goalId,
    );
  }
}

final newPeriodProvider = NotifierProvider<NewPeriodController, PlanDraft>(
  NewPeriodController.new,
);
