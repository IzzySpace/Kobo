import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:timezone/data/latest.dart' as tzdata;
import 'package:timezone/timezone.dart' as tz;

/// Local notifications only. Nothing leaves the phone.
class NotificationService {
  NotificationService._();
  static final instance = NotificationService._();

  final _plugin = FlutterLocalNotificationsPlugin();
  bool _ready = false;

  static const _dailyId = 1;

  static const _reminderChannel = AndroidNotificationDetails(
    'daily_reminder',
    'Daily reminder',
    channelDescription: 'An evening nudge to log what you spent',
    importance: Importance.defaultImportance,
    priority: Priority.defaultPriority,
  );

  static const _alertChannel = AndroidNotificationDetails(
    'budget_alerts',
    'Budget alerts',
    channelDescription: 'When a category reaches 80% and 100% of its budget',
    importance: Importance.high,
    priority: Priority.high,
  );

  Future<void> init() async {
    if (_ready) return;
    tzdata.initializeTimeZones();
    await _plugin.initialize(
      const InitializationSettings(
        android: AndroidInitializationSettings('@mipmap/ic_launcher'),
      ),
    );
    _ready = true;
  }

  /// Shows the Android 13+ permission prompt if needed. True if allowed.
  Future<bool> requestPermission() async {
    await init();
    final android = _plugin.resolvePlatformSpecificImplementation<
        AndroidFlutterLocalNotificationsPlugin>();
    return await android?.requestNotificationsPermission() ?? true;
  }

  /// Repeats every day at [minuteOfDay] (minutes after midnight).
  Future<void> scheduleDailyReminder(int minuteOfDay) async {
    await init();
    final now = DateTime.now();
    final h = minuteOfDay ~/ 60;
    final m = minuteOfDay % 60;
    var next = DateTime(now.year, now.month, now.day, h, m);
    if (!next.isAfter(now)) next = DateTime(now.year, now.month, now.day + 1, h, m);

    await _plugin.zonedSchedule(
      _dailyId,
      'Anything spent today?',
      'Log it now. It takes a few seconds.',
      tz.TZDateTime.from(next, tz.UTC),
      const NotificationDetails(android: _reminderChannel),
      androidScheduleMode: AndroidScheduleMode.inexactAllowWhileIdle,
      matchDateTimeComponents: DateTimeComponents.time,
    );
  }

  Future<void> cancelDailyReminder() async {
    await init();
    await _plugin.cancel(_dailyId);
  }

  Future<void> showBudgetAlert({
    required int categoryId,
    required String title,
    required String body,
  }) async {
    await init();
    await _plugin.show(
      1000 + categoryId,
      title,
      body,
      const NotificationDetails(android: _alertChannel),
    );
  }
}
