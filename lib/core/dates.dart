DateTime dateOnly(DateTime d) => DateTime(d.year, d.month, d.day);

/// Whole calendar days from [from] to [to], ignoring time of day.
int daysBetween(DateTime from, DateTime to) =>
    DateTime.utc(to.year, to.month, to.day)
        .difference(DateTime.utc(from.year, from.month, from.day))
        .inDays;

/// Days the money must cover. Never less than 1, even if the date passed.
int cycleDays(DateTime end, {DateTime? now}) {
  final d = daysBetween(now ?? DateTime.now(), end);
  return d < 1 ? 1 : d;
}

/// Monday of the week containing [d].
DateTime weekStartOf(DateTime d) =>
    DateTime(d.year, d.month, d.day - (d.weekday - 1));
