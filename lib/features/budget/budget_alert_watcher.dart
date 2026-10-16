import 'package:flutter/widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../core/database/app_database.dart';
import '../../core/database/goal_queries.dart';
import '../../core/money/money.dart';
import '../../core/notifications/notification_service.dart';
import '../../core/providers.dart';
import '../home/dashboard.dart';

/// Sends the 80% and 100% category alerts, once each per period,
/// whenever spending changes anywhere in the app.
class BudgetAlertWatcher extends ConsumerStatefulWidget {
  const BudgetAlertWatcher({super.key, required this.child});
  final Widget child;

  @override
  ConsumerState<BudgetAlertWatcher> createState() => _BudgetAlertWatcherState();
}

class _BudgetAlertWatcherState extends ConsumerState<BudgetAlertWatcher> {
  /// Guards against double alerts before the database flag is saved.
  final Set<String> _sent = {};

  Future<void> _check(Dashboard data) async {
    final settings = switch (ref.read(settingsProvider)) {
      AsyncData(:final value) => value,
      _ => null,
    };
    if (settings == null || !settings.categoryAlertsEnabled) return;

    final plan = switch (ref.read(activePlanProvider)) {
      AsyncData(:final value) => value,
      _ => const <(BudgetCategory, BudgetLine)>[],
    };
    final lines = {for (final (c, l) in plan) c.id: l};
    final db = ref.read(databaseProvider);
    final notes = NotificationService.instance;

    for (final p in data.categories) {
      final line = lines[p.category.id];
      if (line == null || line.plannedKobo <= 0) continue;
      final name = p.category.name;

      if (p.spent >= line.plannedKobo &&
          !line.alerted100 &&
          _sent.add('${line.id}:100')) {
        await notes.requestPermission();
        await notes.showBudgetAlert(
          categoryId: line.categoryId,
          title: '$name budget used up',
          body: 'You’ve spent ${formatNaira(p.spent)} of '
              '${formatNaira(line.plannedKobo)} this period.',
        );
        await db.markAlerted(line.id, at80: true, at100: true);
      } else if (p.spent * 100 >= line.plannedKobo * 80 &&
          !line.alerted80 &&
          !line.alerted100 &&
          _sent.add('${line.id}:80')) {
        await notes.requestPermission();
        await notes.showBudgetAlert(
          categoryId: line.categoryId,
          title: '$name is at ${p.spent * 100 ~/ line.plannedKobo}%',
          body: '${formatNaira(line.plannedKobo - p.spent)} left for this '
              'period.',
        );
        await db.markAlerted(line.id, at80: true);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    ref.listen<AsyncValue<Dashboard>>(dashboardProvider, (_, next) {
      if (next case AsyncData(:final value)) _check(value);
    });
    return widget.child;
  }
}
