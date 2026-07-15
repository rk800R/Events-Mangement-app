class DateUtilsX {
  DateUtilsX._();

  static DateTime firstOfMonth(DateTime date) =>
      DateTime(date.year, date.month, 1);

  static DateTime lastOfMonth(DateTime date) =>
      DateTime(date.year, date.month + 1, 0);

  /// Returns first day shown in the month grid (start-of-week aligned).
  static DateTime firstDayVisibleInMonth(DateTime date, int weekStart) {
    final first = firstOfMonth(date);
    final offset = (first.weekday - weekStart + 7) % 7;
    return first.subtract(Duration(days: offset));
  }

  static DateTime startOfWeek(DateTime date, int weekStart) {
    final offset = (date.weekday - weekStart + 7) % 7;
    return DateTime(date.year, date.month, date.day - offset);
  }

  static DateTime endOfWeek(DateTime date, int weekStart) =>
      startOfWeek(date, weekStart).add(const Duration(days: 6));

  static DateTime startOfDay(DateTime date) =>
      DateTime(date.year, date.month, date.day);

  static bool isSameDay(DateTime a, DateTime b) =>
      a.year == b.year && a.month == b.month && a.day == b.day;

  static bool isToday(DateTime date) => isSameDay(date, DateTime.now());

  static int daysInMonth(DateTime date) => lastOfMonth(date).day;

  static List<DateTime> daysInRange(DateTime start, int count) =>
      List.generate(count, (i) => start.add(Duration(days: i)));

  static String weekdayName(int weekday, {bool short = false}) {
    const full = [
      'Monday',
      'Tuesday',
      'Wednesday',
      'Thursday',
      'Friday',
      'Saturday',
      'Sunday'
    ];
    const abbr = ['Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat', 'Sun'];
    final idx = weekday - 1; // 1..7 -> 0..6
    if (idx < 0 || idx > 6) throw ArgumentError('weekday must be 1..7');
    return short ? abbr[idx] : full[idx];
  }
}

extension DateTimeX on DateTime {
  DateTime get dateOnly => DateTime(year, month, day);
  bool get isToday => DateUtilsX.isToday(this);
}
