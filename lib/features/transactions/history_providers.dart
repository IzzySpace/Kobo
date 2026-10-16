import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../core/database/app_database.dart';
import '../../core/database/transaction_queries.dart';
import '../../core/dates.dart';
import '../../core/providers.dart';

enum DatePreset { all, today, week, month, last30, custom }

extension DatePresetLabel on DatePreset {
  String get label => switch (this) {
        DatePreset.all => 'All time',
        DatePreset.today => 'Today',
        DatePreset.week => 'This week',
        DatePreset.month => 'This month',
        DatePreset.last30 => 'Last 30 days',
        DatePreset.custom => 'Pick dates…',
      };
}

typedef DayRange = ({DateTime start, DateTime end});

const _unset = Object();

class HistoryFilter {
  const HistoryFilter({
    this.query = '',
    this.type,
    this.categoryId,
    this.preset = DatePreset.all,
    this.custom,
  });

  final String query;
  final TxType? type;
  final int? categoryId;
  final DatePreset preset;
  final DayRange? custom;

  bool get isActive =>
      query.trim().isNotEmpty ||
      type != null ||
      categoryId != null ||
      preset != DatePreset.all;

  HistoryFilter copyWith({
    String? query,
    Object? type = _unset,
    Object? categoryId = _unset,
    DatePreset? preset,
    Object? custom = _unset,
  }) =>
      HistoryFilter(
        query: query ?? this.query,
        type: identical(type, _unset) ? this.type : type as TxType?,
        categoryId: identical(categoryId, _unset)
            ? this.categoryId
            : categoryId as int?,
        preset: preset ?? this.preset,
        custom: identical(custom, _unset) ? this.custom : custom as DayRange?,
      );

  /// Start (inclusive) and end (exclusive) for the date filter.
  static (DateTime?, DateTime?) rangeFor(
      DatePreset preset, DayRange? custom, DateTime now) {
    final t = dateOnly(now);
    final ws = weekStartOf(t);
    return switch (preset) {
      DatePreset.all => (null, null),
      DatePreset.today => (t, DateTime(t.year, t.month, t.day + 1)),
      DatePreset.week => (ws, DateTime(ws.year, ws.month, ws.day + 7)),
      DatePreset.month => (
          DateTime(t.year, t.month, 1),
          DateTime(t.year, t.month + 1, 1),
        ),
      DatePreset.last30 => (
          DateTime(t.year, t.month, t.day - 29),
          DateTime(t.year, t.month, t.day + 1),
        ),
      DatePreset.custom => custom == null
          ? (null, null)
          : (
              dateOnly(custom.start),
              DateTime(custom.end.year, custom.end.month, custom.end.day + 1),
            ),
    };
  }
}

class HistoryFilterNotifier extends Notifier<HistoryFilter> {
  @override
  HistoryFilter build() => const HistoryFilter();

  void setQuery(String q) => state = state.copyWith(query: q);

  /// Changing type clears the category, which may belong to the other type.
  void setType(TxType? t) =>
      state = state.copyWith(type: t, categoryId: null);

  void setCategory(int? id) => state = state.copyWith(categoryId: id);

  void setPreset(DatePreset p, [DayRange? custom]) =>
      state = state.copyWith(preset: p, custom: custom);

  void clear() => state = const HistoryFilter();
}

final historyFilterProvider =
    NotifierProvider<HistoryFilterNotifier, HistoryFilter>(
  HistoryFilterNotifier.new,
);

/// Database-side filters only. Search runs on top of this in the UI,
/// so typing doesn't restart the query.
final historyTxnsProvider = StreamProvider<List<Txn>>((ref) {
  final (type, categoryId, preset, custom) = ref.watch(historyFilterProvider
      .select((f) => (f.type, f.categoryId, f.preset, f.custom)));
  final (from, to) = HistoryFilter.rangeFor(preset, custom, DateTime.now());
  return ref.watch(databaseProvider).watchTransactionsFiltered(
        from: from,
        to: to,
        type: type,
        categoryId: categoryId,
      );
});
