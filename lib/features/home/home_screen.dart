import 'package:flutter/foundation.dart' show kDebugMode;
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';

import '../../core/database/app_database.dart';
import '../../core/database/transaction_queries.dart';
import '../../core/dates.dart';
import '../../core/money/money.dart';
import '../../core/providers.dart';
import '../../core/theme/app_theme.dart';
import '../../core/ui/category_icons.dart';
import '../../core/ui/motion.dart';
import '../../core/ui/note_card.dart';
import '../budget/domain/safe_to_spend.dart';
import '../onboarding/onboarding_controller.dart';
import '../transactions/ui/quick_add_sheet.dart';
import 'dashboard.dart';

class HomeScreen extends ConsumerStatefulWidget {
  const HomeScreen({super.key});

  @override
  ConsumerState<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends ConsumerState<HomeScreen> {
  /// Rows swiped away, hidden until the database stream catches up.
  final Set<int> _hidden = {};

  Future<void> _log(TxType type) async {
    final messenger = ScaffoldMessenger.of(context);
    final db = ref.read(databaseProvider);
    final logged = await showQuickAdd(context, initialType: type);
    if (logged == null) return;
    messenger.hideCurrentSnackBar();
    messenger.showSnackBar(SnackBar(
      content: Text(logged.type == TxType.expense
          ? 'Logged ${formatNaira(logged.amountKobo)} for ${logged.categoryName}'
          : 'Added ${formatNaira(logged.amountKobo)} from ${logged.categoryName}'),
      action: SnackBarAction(
        label: 'Undo',
        onPressed: () => db.deleteTransaction(logged.id),
      ),
    ));
  }

  Future<void> _delete(Txn t) async {
    final messenger = ScaffoldMessenger.of(context);
    final db = ref.read(databaseProvider);
    setState(() => _hidden.add(t.id));
    await db.deleteTransaction(t.id);
    messenger.hideCurrentSnackBar();
    messenger.showSnackBar(SnackBar(
      content: Text('Deleted ${formatNaira(t.amountKobo)}'),
      action: SnackBarAction(
        label: 'Undo',
        onPressed: () async {
          await db.restoreTransaction(t);
          if (mounted) setState(() => _hidden.remove(t.id));
        },
      ),
    ));
  }

  @override
  Widget build(BuildContext context) {
    final dash = ref.watch(dashboardProvider);
    return Scaffold(
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      floatingActionButton: _LogButton(
        onTap: () => _log(TxType.expense),
        onLongPress: () => _log(TxType.income),
      ),
      body: SafeArea(
        child: switch (dash) {
          AsyncData(:final value) => _DashboardView(
              data: value,
              hidden: _hidden,
              onDelete: _delete,
            ),
          AsyncError(:final error) => Center(
              child: Padding(
                padding: const EdgeInsets.all(24),
                child: Text(
                  'Kobo couldn’t load your budget.\n$error',
                  textAlign: TextAlign.center,
                ),
              ),
            ),
          _ => const Center(child: CircularProgressIndicator()),
        },
      ),
    );
  }
}

class _LogButton extends StatelessWidget {
  const _LogButton({required this.onTap, required this.onLongPress});
  final VoidCallback onTap;
  final VoidCallback onLongPress;

  @override
  Widget build(BuildContext context) {
    final k = context.koboColors;
    return Semantics(
      label: 'Log spending. Long press to add money received.',
      child: GestureDetector(
        onLongPress: () {
          HapticFeedback.mediumImpact();
          onLongPress();
        },
        child: FloatingActionButton.large(
          heroTag: 'log',
          onPressed: onTap,
          backgroundColor: k.note,
          foregroundColor: k.onNote,
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(28)),
          child: const Icon(Icons.add_rounded, size: 40),
        ),
      ),
    );
  }
}

class _DashboardView extends ConsumerWidget {
  const _DashboardView({
    required this.data,
    required this.hidden,
    required this.onDelete,
  });

  final Dashboard data;
  final Set<int> hidden;
  final void Function(Txn) onDelete;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final text = theme.textTheme;
    final scheme = theme.colorScheme;
    final k = context.koboColors;
    final safe = data.safe;
    final recent = data.recent.where((t) => !hidden.contains(t.id)).toList();

    final periodLabel = data.periodEnded
        ? 'Budget period ended'
        : safe.daysLeft == 1
            ? 'Last day'
            : '${safe.daysLeft} days to go';

    return ListView(
      padding: const EdgeInsets.fromLTRB(20, 12, 20, 140),
      children: [
        Row(
          children: [
            Text('kobo', style: displayStyle(26, weight: 800)),
            const Spacer(),
            _Pill(
              text: periodLabel,
              color: scheme.surfaceContainer,
              textColor: scheme.onSurface,
            ),
          ],
        ),
        const SizedBox(height: 16),
        NoteCard(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('Safe to spend today',
                  style: text.labelLarge
                      ?.copyWith(color: k.onNote.withValues(alpha: 0.75))),
              const SizedBox(height: 6),
              FittedBox(
                fit: BoxFit.scaleDown,
                alignment: Alignment.centerLeft,
                child: AnimatedNaira(
                  safe.today,
                  countUp: true,
                  style: text.amount(58, color: k.onNote),
                ),
              ),
              const SizedBox(height: 8),
              if (safe.overToday > 0)
                _Pill(
                  text: '${formatNaira(safe.overToday)} over today’s limit',
                  color: k.danger,
                  textColor: Colors.white,
                )
              else
                Text(
                  data.periodEnded
                      ? 'Your budget period has ended.'
                      : 'Daily limit ${formatNaira(safe.dailyLimit)}',
                  style: text.bodyMedium
                      ?.copyWith(color: k.onNote.withValues(alpha: 0.82)),
                ),
              const SizedBox(height: 18),
              Container(height: 1, color: k.onNote.withValues(alpha: 0.15)),
              const SizedBox(height: 14),
              Row(
                children: [
                  Expanded(
                      child: _Stat(label: 'Safe this week', kobo: safe.week)),
                  Expanded(
                      child:
                          _Stat(label: 'Balance', kobo: data.spendableKobo)),
                ],
              ),
              if (data.savedKobo > 0) ...[
                const SizedBox(height: 8),
                Text(
                  '${formatNaira(data.savedKobo)} set aside in savings',
                  style: text.bodySmall
                      ?.copyWith(color: k.onNote.withValues(alpha: 0.7)),
                ),
              ],
            ],
          ),
        ),
        const SizedBox(height: 28),
        Text('This period', style: text.titleLarge),
        const SizedBox(height: 2),
        Text(
          '${formatNaira(data.spentThisCycleKobo)} spent of '
          '${formatNaira(data.plannedTotalKobo)} planned',
          style: text.bodySmall?.copyWith(color: scheme.onSurfaceVariant),
        ),
        const SizedBox(height: 12),
        if (data.categories.isEmpty)
          const _EmptyCard(
            title: 'No budget yet',
            body: 'Your category budgets will show here.',
          )
        else
          _Group(children: [
            for (final p in data.categories) _CategoryRow(progress: p),
          ]),
        const SizedBox(height: 28),
        Text('Recent', style: text.titleLarge),
        const SizedBox(height: 12),
        if (recent.isEmpty)
          const _EmptyCard(
            title: 'Nothing logged yet',
            body: 'Tap + every time you spend, even ₦50 pure water. Hold + '
                'to add money you receive.',
          )
        else
          _Group(children: [
            for (final t in recent)
              Dismissible(
                key: ValueKey(t.id),
                direction: DismissDirection.endToStart,
                background: Container(
                  alignment: Alignment.centerRight,
                  padding: const EdgeInsets.only(right: 20),
                  color: k.danger.withValues(alpha: 0.15),
                  child: Icon(Icons.delete_outline_rounded, color: k.danger),
                ),
                onDismissed: (_) => onDelete(t),
                child: _TxRow(
                  txn: t,
                  category: data.categoriesById[t.categoryId],
                  now: data.now,
                ),
              ),
          ]),
        if (kDebugMode) ...[
          const SizedBox(height: 32),
          Center(
            child: TextButton.icon(
              onPressed: () async {
                await ref.read(databaseProvider).resetAllData();
                ref.invalidate(onboardingProvider);
              },
              icon: const Icon(Icons.restart_alt_rounded),
              label: const Text('Reset all data (debug only)'),
            ),
          ),
        ],
      ],
    );
  }
}

class _Stat extends StatelessWidget {
  const _Stat({required this.label, required this.kobo});
  final String label;
  final int kobo;

  @override
  Widget build(BuildContext context) {
    final text = Theme.of(context).textTheme;
    final k = context.koboColors;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label,
            style: text.labelMedium
                ?.copyWith(color: k.onNote.withValues(alpha: 0.7))),
        const SizedBox(height: 2),
        FittedBox(
          fit: BoxFit.scaleDown,
          alignment: Alignment.centerLeft,
          child: AnimatedNaira(kobo, style: text.amount(22, color: k.onNote)),
        ),
      ],
    );
  }
}

class _Pill extends StatelessWidget {
  const _Pill({
    required this.text,
    required this.color,
    required this.textColor,
  });

  final String text;
  final Color color;
  final Color textColor;

  @override
  Widget build(BuildContext context) => Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
        decoration: BoxDecoration(
          color: color,
          borderRadius: BorderRadius.circular(99),
        ),
        child: Text(
          text,
          style: Theme.of(context).textTheme.labelLarge?.copyWith(
                color: textColor,
                fontWeight: FontWeight.w700,
              ),
        ),
      );
}

class _Group extends StatelessWidget {
  const _Group({required this.children});
  final List<Widget> children;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    return ClipRRect(
      borderRadius: BorderRadius.circular(22),
      child: ColoredBox(
        color: scheme.surfaceContainerLowest,
        child: Column(
          children: [
            for (var i = 0; i < children.length; i++) ...[
              if (i > 0)
                Divider(
                  height: 1,
                  indent: 66,
                  color: scheme.outlineVariant.withValues(alpha: 0.5),
                ),
              children[i],
            ],
          ],
        ),
      ),
    );
  }
}

class _EmptyCard extends StatelessWidget {
  const _EmptyCard({required this.title, required this.body});
  final String title;
  final String body;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: theme.colorScheme.surfaceContainerLowest,
        borderRadius: BorderRadius.circular(22),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(title,
              style: theme.textTheme.titleSmall
                  ?.copyWith(fontWeight: FontWeight.w700)),
          const SizedBox(height: 4),
          Text(body,
              style: theme.textTheme.bodyMedium?.copyWith(
                color: theme.colorScheme.onSurfaceVariant,
                height: 1.4,
              )),
        ],
      ),
    );
  }
}

class _CategoryRow extends StatelessWidget {
  const _CategoryRow({required this.progress});
  final CategoryProgress progress;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final text = theme.textTheme;
    final scheme = theme.colorScheme;
    final k = context.koboColors;
    final p = progress;

    final color = switch (p.health) {
      BudgetHealth.good => k.good,
      BudgetHealth.warn => k.warn,
      BudgetHealth.over => k.danger,
      BudgetHealth.unplanned => scheme.onSurfaceVariant,
    };
    final trailing = p.planned == 0
        ? 'No budget'
        : p.spent <= p.planned
            ? '${formatNaira(p.planned - p.spent)} left'
            : '${formatNaira(p.spent - p.planned)} over';

    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 14, 16, 14),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              CategoryAvatar(
                iconKey: p.category.iconKey,
                colorValue: p.category.colorValue,
                radius: 18,
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(p.category.name,
                        style: text.titleSmall
                            ?.copyWith(fontWeight: FontWeight.w600)),
                    Text(
                      p.planned > 0
                          ? '${formatNaira(p.spent)} of ${formatNaira(p.planned)}'
                          : '${formatNaira(p.spent)} spent',
                      style: text.bodySmall
                          ?.copyWith(color: scheme.onSurfaceVariant),
                    ),
                  ],
                ),
              ),
              Text(
                trailing,
                style: text.labelLarge?.copyWith(
                  color: color,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ],
          ),
          const SizedBox(height: 10),
          _ProgressBar(
            fraction: p.fraction,
            color: color,
            track: scheme.surfaceContainerHigh,
          ),
        ],
      ),
    );
  }
}

class _ProgressBar extends StatelessWidget {
  const _ProgressBar({
    required this.fraction,
    required this.color,
    required this.track,
  });

  final double fraction;
  final Color color;
  final Color track;

  @override
  Widget build(BuildContext context) {
    final d = Motion.of(context, Motion.medium);
    return TweenAnimationBuilder<Color?>(
      tween: ColorTween(end: color),
      duration: d,
      builder: (context, c, _) => TweenAnimationBuilder<double>(
        tween: Tween(end: fraction),
        duration: d,
        curve: Motion.curve,
        builder: (context, f, _) => ClipRRect(
          borderRadius: BorderRadius.circular(4),
          child: SizedBox(
            height: 8,
            child: Stack(
              fit: StackFit.expand,
              children: [
                ColoredBox(color: track),
                Align(
                  alignment: Alignment.centerLeft,
                  child: FractionallySizedBox(
                    widthFactor: f,
                    heightFactor: 1,
                    child: ColoredBox(color: c ?? color),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _TxRow extends StatelessWidget {
  const _TxRow({required this.txn, required this.category, required this.now});
  final Txn txn;
  final BudgetCategory? category;
  final DateTime now;

  String _when() {
    final diff = daysBetween(txn.occurredAt, now);
    if (diff == 0) return DateFormat.jm().format(txn.occurredAt);
    if (diff == 1) return 'Yesterday';
    return DateFormat('d MMM').format(txn.occurredAt);
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final text = theme.textTheme;
    final scheme = theme.colorScheme;
    final k = context.koboColors;
    final income = txn.type == TxType.income;
    final muted = text.bodySmall?.copyWith(color: scheme.onSurfaceVariant);

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      child: Row(
        children: [
          CategoryAvatar(
            iconKey: category?.iconKey ?? 'other',
            colorValue: category?.colorValue ?? 0xFF78716C,
            radius: 18,
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(category?.name ?? 'Removed category',
                    style:
                        text.titleSmall?.copyWith(fontWeight: FontWeight.w600)),
                if (txn.note != null)
                  Text(txn.note!,
                      style: muted,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis),
              ],
            ),
          ),
          const SizedBox(width: 8),
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(
                '${income ? '+' : '−'}${formatNaira(txn.amountKobo)}',
                style: text.amount(17, color: income ? k.good : null),
              ),
              const SizedBox(height: 2),
              Text(_when(), style: muted),
            ],
          ),
        ],
      ),
    );
  }
}
