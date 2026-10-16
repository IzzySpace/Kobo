import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';

import '../../../core/database/app_database.dart';
import '../../../core/database/transaction_queries.dart';
import '../../../core/dates.dart';
import '../../../core/money/money.dart';
import '../../../core/providers.dart';
import '../../../core/theme/app_theme.dart';
import '../../../core/ui/category_icons.dart';
import '../../../core/ui/motion.dart';
import 'quick_add_sheet.dart';

/// One transaction row. [timeOnly] shows just the time (for day groups).
class TxTile extends StatelessWidget {
  const TxTile({
    super.key,
    required this.txn,
    required this.category,
    required this.now,
    this.onTap,
    this.timeOnly = false,
  });

  final Txn txn;
  final BudgetCategory? category;
  final DateTime now;
  final VoidCallback? onTap;
  final bool timeOnly;

  String _when() {
    if (timeOnly) return DateFormat.jm().format(txn.occurredAt);
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

    return Material(
      type: MaterialType.transparency,
      child: InkWell(
        onTap: onTap,
        child: Padding(
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
                        style: text.titleSmall
                            ?.copyWith(fontWeight: FontWeight.w600)),
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
        ),
      ),
    );
  }
}

/// Rounded group of rows separated by hairlines.
class TileGroup extends StatelessWidget {
  const TileGroup({super.key, required this.children});
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

class EmptyNote extends StatelessWidget {
  const EmptyNote({super.key, required this.title, required this.body});
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

/// Thin progress bar that animates its length and colour.
class ProgressLine extends StatelessWidget {
  const ProgressLine({
    super.key,
    required this.fraction,
    required this.color,
  });

  final double fraction;
  final Color color;

  @override
  Widget build(BuildContext context) {
    final track = Theme.of(context).colorScheme.surfaceContainerHigh;
    final d = Motion.of(context, Motion.medium);
    return TweenAnimationBuilder<Color?>(
      tween: ColorTween(end: color),
      duration: d,
      builder: (context, c, _) => TweenAnimationBuilder<double>(
        tween: Tween(end: fraction.clamp(0.0, 1.0)),
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

/// Opens [t] for editing and shows a snackbar with Undo afterwards.
Future<void> editTransaction(
    BuildContext context, WidgetRef ref, Txn t) async {
  final messenger = ScaffoldMessenger.of(context);
  final db = ref.read(databaseProvider);
  final result = await showQuickAdd(context, existing: t);
  if (result == null) return;
  messenger.hideCurrentSnackBar();
  if (result.outcome == TxOutcome.deleted) {
    messenger.showSnackBar(SnackBar(
      content: Text('Deleted ${formatNaira(t.amountKobo)}'),
      action: SnackBarAction(
        label: 'Undo',
        onPressed: () => db.restoreTransaction(t),
      ),
    ));
  } else {
    messenger.showSnackBar(SnackBar(
      content: const Text('Changes saved'),
      action: SnackBarAction(
        label: 'Undo',
        onPressed: () => db.replaceTransaction(t),
      ),
    ));
  }
}
