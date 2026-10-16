import '../../../core/dates.dart';

/// Warning shown when the current spending pace won't last the period.
class PaceWarning {
  const PaceWarning({
    required this.runsOutInDays,
    required this.shortByDays,
    required this.cutPerDay,
  });

  final int runsOutInDays;
  final int shortByDays;

  /// How much less to spend each day to make it, rounded up to whole naira.
  final int cutPerDay;

  /// Null when on track or when there isn't a full day of history yet.
  static PaceWarning? compute({
    required int spentThisCycleKobo,
    required DateTime cycleStart,
    required DateTime now,
    required int spendableKobo,
    required int daysLeft,
  }) {
    final elapsed = daysBetween(cycleStart, now) + 1; // includes today
    if (elapsed < 2 || spentThisCycleKobo <= 0 || daysLeft < 1) return null;

    final pace = spentThisCycleKobo ~/ elapsed;
    if (pace <= 0) return null;

    if (spendableKobo <= 0) {
      return PaceWarning(
        runsOutInDays: 0,
        shortByDays: daysLeft,
        cutPerDay: _roundUpToNaira(pace),
      );
    }
    if (pace * daysLeft <= spendableKobo) return null;

    final runsOut = spendableKobo ~/ pace;
    final affordable = spendableKobo ~/ daysLeft;
    return PaceWarning(
      runsOutInDays: runsOut,
      shortByDays: daysLeft - runsOut,
      cutPerDay: _roundUpToNaira(pace - affordable),
    );
  }

  static int _roundUpToNaira(int kobo) => (kobo + 99) ~/ 100 * 100;
}
