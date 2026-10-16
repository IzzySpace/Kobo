import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../core/database/app_database.dart';
import '../../core/database/transaction_queries.dart';
import '../../core/dates.dart';
import '../../core/providers.dart';
import 'domain/weekly_review.dart';

/// Monday of the week being reviewed.
class ReviewWeek extends Notifier<DateTime> {
  @override
  DateTime build() => weekStartOf(DateTime.now());

  void previous() =>
      state = DateTime(state.year, state.month, state.day - 7);

  void next() {
    final n = DateTime(state.year, state.month, state.day + 7);
    if (!n.isAfter(weekStartOf(DateTime.now()))) state = n;
  }
}

final reviewWeekProvider =
    NotifierProvider<ReviewWeek, DateTime>(ReviewWeek.new);

final reviewTxnsProvider = StreamProvider<List<Txn>>((ref) {
  final start = ref.watch(reviewWeekProvider);
  return ref.watch(databaseProvider).watchTransactionsBetween(
        start,
        DateTime(start.year, start.month, start.day + 7),
      );
});

final weeklyReviewProvider = Provider<AsyncValue<WeeklyReview>>((ref) {
  final start = ref.watch(reviewWeekProvider);
  final txns = ref.watch(reviewTxnsProvider);
  final cycle = ref.watch(activeCycleProvider);
  final plan = ref.watch(activePlanProvider);

  for (final v in <AsyncValue<Object?>>[txns, cycle, plan]) {
    if (v is AsyncError) return AsyncError<WeeklyReview>(v.error, v.stackTrace);
  }

  return switch ((txns, cycle, plan)) {
    (
      AsyncData(value: final t),
      AsyncData(value: final c),
      AsyncData(value: final p),
    ) =>
      AsyncData(WeeklyReview.compute(
        weekStart: start,
        txns: t,
        plannedByCategory: {for (final (cat, line) in p) cat.id: line.plannedKobo},
        cycleLengthDays: c == null ? 0 : daysBetween(c.startDate, c.endDate),
      )),
    _ => const AsyncLoading<WeeklyReview>(),
  };
});
