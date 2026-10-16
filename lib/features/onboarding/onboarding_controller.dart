import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../core/database/app_database.dart';
import '../../core/database/goal_queries.dart';
import '../../core/dates.dart';
import '../budget/plan_controller.dart';

export '../budget/plan_controller.dart' show PlanDraft;

typedef OnboardingDraft = PlanDraft;

class OnboardingController extends PlanController {
  @override
  PlanDraft build() => const PlanDraft();

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

  @override
  Future<void> finish() async {
    final active = {
      for (final c in await db.getCategories(CategoryKind.expense)) c.id,
    };
    final savings = state.goal == null ? 0 : state.savingsKobo;
    await db.completeOnboarding(
      balanceKobo: state.balanceKobo,
      usualIncomeKobo: state.usualIncomeKobo,
      frequency: state.frequency,
      cycleEnd: dateOnly(state.cycleEnd!),
      plannedByCategory: {
        for (final e in state.planned.entries)
          if (active.contains(e.key)) e.key: e.value,
      },
      plannedSavingsKobo: savings,
      goal: state.goal,
    );
    // Planned savings are set aside straight away.
    if (savings > 0) {
      final goals = await db.getGoals();
      if (goals.isNotEmpty) {
        await db.addContribution(goals.last.id, savings,
            note: 'Planned savings');
      }
    }
  }
}

final onboardingProvider = NotifierProvider<OnboardingController, PlanDraft>(
  OnboardingController.new,
);
