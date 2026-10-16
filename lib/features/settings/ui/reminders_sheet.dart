import 'package:drift/drift.dart' show Value;
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/database/app_database.dart';
import '../../../core/notifications/notification_service.dart';
import '../../../core/providers.dart';

class RemindersButton extends StatelessWidget {
  const RemindersButton({super.key});

  @override
  Widget build(BuildContext context) => IconButton(
        tooltip: 'Reminders',
        icon: const Icon(Icons.notifications_none_rounded),
        onPressed: () => showModalBottomSheet<void>(
          context: context,
          showDragHandle: true,
          useSafeArea: true,
          builder: (_) => const RemindersPanel(),
        ),
      );
}

/// Daily reminder and budget alert settings. Reused in Settings (Phase 6).
class RemindersPanel extends ConsumerStatefulWidget {
  const RemindersPanel({super.key});

  @override
  ConsumerState<RemindersPanel> createState() => _RemindersPanelState();
}

class _RemindersPanelState extends ConsumerState<RemindersPanel> {
  String? _message;

  Future<bool> _ensurePermission() async {
    final ok = await NotificationService.instance.requestPermission();
    if (!ok && mounted) {
      setState(() => _message = 'Notifications are off for Kobo. Turn them on '
          'in your phone’s Settings, then try again.');
    }
    return ok;
  }

  Future<void> _setDaily(SettingsRow s, bool on) async {
    final db = ref.read(databaseProvider);
    final notes = NotificationService.instance;
    if (on) {
      if (!await _ensurePermission()) return;
      await db.updateSettings(
          const AppSettingsCompanion(dailyReminderEnabled: Value(true)));
      await notes.scheduleDailyReminder(s.reminderMinuteOfDay);
    } else {
      await db.updateSettings(
          const AppSettingsCompanion(dailyReminderEnabled: Value(false)));
      await notes.cancelDailyReminder();
    }
    if (mounted) setState(() => _message = null);
  }

  Future<void> _pickTime(SettingsRow s) async {
    final picked = await showTimePicker(
      context: context,
      initialTime: TimeOfDay(
        hour: s.reminderMinuteOfDay ~/ 60,
        minute: s.reminderMinuteOfDay % 60,
      ),
    );
    if (picked == null) return;
    final minute = picked.hour * 60 + picked.minute;
    await ref
        .read(databaseProvider)
        .updateSettings(AppSettingsCompanion(reminderMinuteOfDay: Value(minute)));
    if (s.dailyReminderEnabled) {
      await NotificationService.instance.scheduleDailyReminder(minute);
    }
  }

  Future<void> _setAlerts(bool on) async {
    if (on && !await _ensurePermission()) return;
    await ref
        .read(databaseProvider)
        .updateSettings(AppSettingsCompanion(categoryAlertsEnabled: Value(on)));
  }

  @override
  Widget build(BuildContext context) {
    final s = switch (ref.watch(settingsProvider)) {
      AsyncData(:final value) => value,
      _ => null,
    };
    if (s == null) {
      return const SizedBox(
          height: 160, child: Center(child: CircularProgressIndicator()));
    }
    final theme = Theme.of(context);
    final time = TimeOfDay(
      hour: s.reminderMinuteOfDay ~/ 60,
      minute: s.reminderMinuteOfDay % 60,
    ).format(context);
    const pad = EdgeInsets.symmetric(horizontal: 24);

    return SingleChildScrollView(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(24, 0, 24, 8),
            child: Text('Reminders', style: theme.textTheme.titleLarge),
          ),
          SwitchListTile(
            contentPadding: pad,
            title: const Text('Daily reminder'),
            subtitle: Text('A nudge at $time to log what you spent'),
            value: s.dailyReminderEnabled,
            onChanged: (v) => _setDaily(s, v),
          ),
          ListTile(
            contentPadding: pad,
            enabled: s.dailyReminderEnabled,
            leading: const Icon(Icons.schedule_rounded),
            title: const Text('Reminder time'),
            trailing: Text(time, style: theme.textTheme.titleSmall),
            onTap: () => _pickTime(s),
          ),
          SwitchListTile(
            contentPadding: pad,
            title: const Text('Budget alerts'),
            subtitle:
                const Text('When a category reaches 80% and 100% of its budget'),
            value: s.categoryAlertsEnabled,
            onChanged: _setAlerts,
          ),
          if (_message != null)
            Padding(
              padding: const EdgeInsets.fromLTRB(24, 8, 24, 0),
              child: Text(_message!,
                  style: theme.textTheme.bodySmall
                      ?.copyWith(color: theme.colorScheme.error)),
            ),
          const SizedBox(height: 24),
        ],
      ),
    );
  }
}
