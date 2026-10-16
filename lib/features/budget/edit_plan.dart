import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../core/database/app_database.dart';
import '../../core/database/goal_queries.dart';
import '../../core/database/settings_queries.dart';
import 'plan_controller.dart';

/// Edits the amounts in the current period without starting a new one.
class EditPlanController extends PlanController {
  int? _cycleId;

  @override
  PlanDraft build() => const PlanDraft();

  /// False if there's no active period to edit.
  Future<bool> begin() async {
    final cycle = await db.getActiveCycle();
    if (cycle == null) return false;
    _cycleId = cycle.id;
    final lines = await db.linesForCycle(cycle.id);
    final goals = await db.getGoals();
    final goal = goals.isEmpty ? null : goals.first;
    state = PlanDraft(
      balanceKobo: cycle.startingBalanceKobo,
      cycleEnd: cycle.endDate,
      goal: goal == null
          ? null
          : (
              name: goal.name,
              targetKobo: goal.targetKobo,
              deadline: goal.deadline,
            ),
      planned: {for (final l in lines) l.categoryId: l.plannedKobo},
      savingsKobo: cycle.plannedSavingsKobo,
    );
    return true;
  }

  @override
  Future<void> finish() async {
    final id = _cycleId;
    if (id == null) return;
    final active = {
      for (final c in await db.getCategories(CategoryKind.expense)) c.id,
    };
    await db.savePlanForCycle(
      id,
      {
        for (final e in state.planned.entries)
          if (active.contains(e.key)) e.key: e.value,
      },
      state.goal == null ? 0 : state.savingsKobo,
    );
  }
}

final editPlanProvider = NotifierProvider<EditPlanController, PlanDraft>(
  EditPlanController.new,
);
