class AppConstants {
  AppConstants._();

  // App Info
  static const String appName = 'HarmoniCal';
  static const String appVersion = '1.0.0';

  // Database
  static const String databaseName = 'harmonical.db';
  static const int databaseVersion = 1;

  // Calendar View Types
  static const String viewMonth = 'month';
  static const String viewWeek = 'week';
  static const String viewDay = 'day';
  static const String viewTimelineDay = 'timeline_day';
  static const String viewTimelineWeek = 'timeline_week';
  static const String viewAgenda = 'agenda';

  static const List<String> calendarViews = [
    viewMonth,
    viewWeek,
    viewDay,
    viewTimelineDay,
    viewTimelineWeek,
    viewAgenda,
  ];

  // Defaults
  static const int defaultEventDurationMinutes = 60;
  static const int weekStartDay = 1; // Monday

  // Time Constants
  static const int hoursInDay = 24;
  static const int minutesInHour = 60;
  static const int daysInWeek = 7;

  // Notification
  static const String notificationChannelId = 'harmonical_events';
  static const String notificationChannelName = 'Event Reminders';
  static const String notificationChannelDescription =
      'Reminders for upcoming events';

  // Reminder Options (in minutes before event)
  static const List<int> reminderOptions = [0, 5, 10, 15, 30, 60, 120, 1440];
  static const List<String> reminderLabels = [
    'At time of event',
    '5 minutes before',
    '10 minutes before',
    '15 minutes before',
    '30 minutes before',
    '1 hour before',
    '2 hours before',
    '1 day before',
  ];

  // Recurrence Options
  static const List<String> recurrenceOptions = [
    'None',
    'Daily',
    'Weekly',
    'Monthly',
    'Yearly',
  ];

  // Storage Keys
  static const String themeModeKey = 'theme_mode';
  static const String firstLaunchKey = 'first_launch';
}
