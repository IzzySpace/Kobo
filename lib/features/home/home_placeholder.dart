import 'package:flutter/foundation.dart' show kDebugMode;
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';

import '../../core/dates.dart';
import '../../core/money/money.dart';
import '../../core/providers.dart';
import '../../core/theme/app_theme.dart';
import '../../core/ui/category_icons.dart';
import '../../core/ui/motion.dart';
import '../../core/ui/note_card.dart';
import '../onboarding/onboarding_controller.dart';

/// Temporary. The real dashboard replaces this in Phase 3.
class HomePlaceholder extends ConsumerWidget {
  const HomePlaceholder({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final text = Theme.of(context).textTheme;
    final k = context.koboColors;
    final cycle = switch (ref.watch(activeCycleProvider)) {
      AsyncData(:final value) => value,
      _ => null,
    };
    final plan = switch (ref.watch(activePlanProvider)) {
      AsyncData(:final value) => value,
      _ => const [],
    };

    return Scaffold(
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.fromLTRB(20, 16, 20, 24),
          children: [
            Text('kobo', style: displayStyle(26, weight: 800)),
            const SizedBox(height: 16),
            if (cycle != null)
              NoteCard(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Starting balance',
                        style: text.labelLarge?.copyWith(
                            color: k.onNote.withValues(alpha: 0.75))),
                    const SizedBox(height: 6),
                    FittedBox(
                      fit: BoxFit.scaleDown,
                      alignment: Alignment.centerLeft,
                      child: AnimatedNaira(
                        cycle.startingBalanceKobo,
                        countUp: true,
                        style: text.amount(46, color: k.onNote),
                      ),
                    ),
                    const SizedBox(height: 6),
                    Text(
                      'to last until '
                      '${DateFormat('EEEE d MMM').format(cycle.endDate)}, '
                      '${cycleDays(cycle.endDate)} days',
                      style: text.bodyMedium?.copyWith(
                          color: k.onNote.withValues(alpha: 0.82)),
                    ),
                  ],
                ),
              ),
            const SizedBox(height: 24),
            Text('Your plan', style: text.titleLarge),
            const SizedBox(height: 4),
            Text('The full dashboard arrives in Phase 3.',
                style: text.bodySmall),
            const SizedBox(height: 8),
            for (final (cat, line) in plan)
              ListTile(
                contentPadding: EdgeInsets.zero,
                leading: CategoryAvatar(
                    iconKey: cat.iconKey, colorValue: cat.colorValue),
                title: Text(cat.name),
                trailing:
                    Text(formatNaira(line.plannedKobo), style: text.amount(17)),
              ),
            if (kDebugMode) ...[
              const SizedBox(height: 24),
              OutlinedButton.icon(
                onPressed: () async {
                  await ref.read(databaseProvider).resetAllData();
                  ref.invalidate(onboardingProvider);
                },
                icon: const Icon(Icons.restart_alt_rounded),
                label: const Text('Reset all data (debug only)'),
              ),
            ],
          ],
        ),
      ),
    );
  }
}
