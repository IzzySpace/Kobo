import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../edit_plan.dart';
import 'budget_plan_step.dart';

Future<void> openEditPlan(BuildContext context) async {
  final container = ProviderScope.containerOf(context, listen: false);
  final ok = await container.read(editPlanProvider.notifier).begin();
  if (!ok || !context.mounted) return;
  await Navigator.of(context).push(
    MaterialPageRoute<void>(builder: (_) => const EditPlanScreen()),
  );
}

class EditPlanScreen extends StatelessWidget {
  const EditPlanScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    return Scaffold(
      appBar: AppBar(
        backgroundColor: scheme.surface,
        surfaceTintColor: Colors.transparent,
        title: const Text('This period’s budget'),
      ),
      body: BudgetPlanStep(
        provider: editPlanProvider,
        saveLabel: 'Save budget',
        onDone: () {
          final messenger = ScaffoldMessenger.of(context);
          Navigator.of(context).pop();
          messenger.showSnackBar(const SnackBar(content: Text('Budget saved')));
        },
      ),
    );
  }
}
