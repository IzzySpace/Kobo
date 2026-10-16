import 'package:drift/drift.dart' show Value;
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:local_auth/local_auth.dart';

import '../../../core/backup/backup_service.dart';
import '../../../core/database/app_database.dart';
import '../../../core/database/settings_queries.dart';
import '../../../core/dates.dart';
import '../../../core/money/money.dart';
import '../../../core/notifications/notification_service.dart';
import '../../../core/providers.dart';
import '../../../core/ui/amount_field.dart';
import '../../../core/ui/labels.dart';
import '../../budget/ui/categories_editor.dart';
import '../../budget/ui/edit_plan_screen.dart';
import '../../onboarding/onboarding_controller.dart';
import 'reminders_sheet.dart';

class SettingsButton extends StatelessWidget {
  const SettingsButton({super.key});

  @override
  Widget build(BuildContext context) => IconButton(
        tooltip: 'Settings',
        icon: const Icon(Icons.settings_outlined),
        onPressed: () => Navigator.of(context).push(
          MaterialPageRoute<void>(builder: (_) => const SettingsScreen()),
        ),
      );
}

class SettingsScreen extends ConsumerStatefulWidget {
  const SettingsScreen({super.key});

  @override
  ConsumerState<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends ConsumerState<SettingsScreen> {
  bool _busy = false;

  AppDatabase get _db => ref.read(databaseProvider);
  BackupService get _backup => BackupService(_db);

  void _toast(String message) {
    ScaffoldMessenger.of(context)
      ..hideCurrentSnackBar()
      ..showSnackBar(SnackBar(content: Text(message)));
  }

  Future<void> _run(Future<void> Function() task) async {
    if (_busy) return;
    setState(() => _busy = true);
    try {
      await task();
    } finally {
      if (mounted) setState(() => _busy = false);
    }
  }

  Future<bool> _confirm({
    required String title,
    required String body,
    required String action,
  }) async {
    final ok = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text(title),
        content: Text(body),
        actions: [
          TextButton(
              onPressed: () => Navigator.pop(ctx, false),
              child: const Text('Cancel')),
          TextButton(
            onPressed: () => Navigator.pop(ctx, true),
            style: TextButton.styleFrom(
                foregroundColor: Theme.of(ctx).colorScheme.error),
            child: Text(action),
          ),
        ],
      ),
    );
    return ok == true;
  }

  Future<void> _setLock(bool on) async {
    if (on) {
      final auth = LocalAuthentication();
      if (!await auth.isDeviceSupported()) {
        _toast('Set a screen lock (PIN, pattern or fingerprint) on your '
            'phone first.');
        return;
      }
      bool ok;
      try {
        ok = await auth.authenticate(
          localizedReason: 'Confirm it’s you to turn on app lock',
          options: const AuthenticationOptions(stickyAuth: true),
        );
      } on PlatformException {
        ok = false;
      }
      if (!ok) return;
    }
    await _db.updateSettings(AppSettingsCompanion(appLockEnabled: Value(on)));
  }

  Future<void> _syncReminder() async {
    final s = await _db.getSettings();
    final notes = NotificationService.instance;
    if (s.dailyReminderEnabled) {
      await notes.scheduleDailyReminder(s.reminderMinuteOfDay);
    } else {
      await notes.cancelDailyReminder();
    }
  }

  Future<void> _exportCsv() async {
    try {
      final count = await _backup.shareCsv();
      if (count == 0) _toast('Nothing to export yet.');
    } catch (_) {
      _toast('Couldn’t export. Please try again.');
    }
  }

  Future<void> _saveBackup() async {
    try {
      final saved = await _backup.saveBackupToPhone();
      _toast(saved ? 'Backup saved' : 'Backup not saved');
    } catch (_) {
      _toast('Couldn’t make a backup. Please try again.');
    }
  }

  Future<void> _shareBackup() async {
    try {
      await _backup.shareBackup();
    } catch (_) {
      _toast('Couldn’t make a backup. Please try again.');
    }
  }

  Future<void> _restore() async {
    final ok = await _confirm(
      title: 'Restore from a backup?',
      body: 'Everything in Kobo now will be replaced by the backup. Save a '
          'backup first if you might need today’s data.',
      action: 'Choose backup',
    );
    if (!ok) return;
    await _run(() async {
      try {
        final done = await _backup.restoreFromPicker();
        if (!done) return;
        await _syncReminder();
        _toast('Backup restored');
      } on FormatException catch (e) {
        _toast(e.message);
      } catch (_) {
        _toast('That file isn’t a Kobo backup.');
      }
    });
  }

  Future<void> _startOver() async {
    final ok = await _confirm(
      title: 'Erase everything?',
      body: 'All transactions, budgets and goals will be deleted from this '
          'phone. This can’t be undone.',
      action: 'Erase',
    );
    if (!ok || !mounted) return;
    final db = _db;
    final container = ProviderScope.containerOf(context, listen: false);
    Navigator.of(context).popUntil((r) => r.isFirst);
    await db.resetAllData();
    await NotificationService.instance.cancelDailyReminder();
    container.invalidate(onboardingProvider);
  }

  @override
  Widget build(BuildContext context) {
    final s = switch (ref.watch(settingsProvider)) {
      AsyncData(:final value) => value,
      _ => null,
    };
    final theme = Theme.of(context);
    final scheme = theme.colorScheme;

    Widget section(String title) => Padding(
          padding: const EdgeInsets.fromLTRB(20, 24, 20, 4),
          child: Text(title,
              style: theme.textTheme.titleSmall
                  ?.copyWith(color: scheme.primary, fontWeight: FontWeight.w700)),
        );

    return Scaffold(
      appBar: AppBar(
        backgroundColor: scheme.surface,
        surfaceTintColor: Colors.transparent,
        title: const Text('Settings'),
      ),
      body: s == null
          ? const Center(child: CircularProgressIndicator())
          : ListView(
              padding: const EdgeInsets.only(bottom: 32),
              children: [
                if (_busy) const LinearProgressIndicator(),
                section('Appearance'),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: SegmentedButton<AppThemeMode>(
                    showSelectedIcon: false,
                    segments: const [
                      ButtonSegment(
                          value: AppThemeMode.system,
                          icon: Icon(Icons.brightness_auto_rounded),
                          label: Text('System')),
                      ButtonSegment(
                          value: AppThemeMode.light,
                          icon: Icon(Icons.light_mode_rounded),
                          label: Text('Light')),
                      ButtonSegment(
                          value: AppThemeMode.dark,
                          icon: Icon(Icons.dark_mode_rounded),
                          label: Text('Dark')),
                    ],
                    selected: {s.themeMode},
                    onSelectionChanged: (v) => _db.updateSettings(
                        AppSettingsCompanion(themeMode: Value(v.first))),
                  ),
                ),
                section('Budget'),
                ListTile(
                  leading: const Icon(Icons.tune_rounded),
                  title: const Text('Edit this period’s budget'),
                  subtitle: const Text('Change how much each category gets'),
                  onTap: () => openEditPlan(context),
                ),
                ListTile(
                  leading: const Icon(Icons.category_outlined),
                  title: const Text('Categories'),
                  subtitle: const Text('Rename, add or remove'),
                  onTap: () => Navigator.of(context).push(MaterialPageRoute<void>(
                      builder: (_) => const CategoriesScreen())),
                ),
                ListTile(
                  leading: const Icon(Icons.payments_outlined),
                  title: const Text('Income schedule'),
                  subtitle: Text(s.usualIncomeKobo > 0
                      ? '${s.incomeFrequency.label}, usually '
                          '${formatNaira(s.usualIncomeKobo)}'
                      : s.incomeFrequency.label),
                  onTap: () => showModalBottomSheet<void>(
                    context: context,
                    isScrollControlled: true,
                    useSafeArea: true,
                    showDragHandle: true,
                    builder: (_) => const _IncomeScheduleSheet(),
                  ),
                ),
                section('Reminders and security'),
                ListTile(
                  leading: const Icon(Icons.notifications_none_rounded),
                  title: const Text('Reminders and alerts'),
                  subtitle: Text(s.dailyReminderEnabled
                      ? 'Daily reminder on'
                      : 'Daily reminder off'),
                  onTap: () => showModalBottomSheet<void>(
                    context: context,
                    showDragHandle: true,
                    useSafeArea: true,
                    builder: (_) => const RemindersPanel(),
                  ),
                ),
                SwitchListTile(
                  secondary: const Icon(Icons.lock_outline_rounded),
                  title: const Text('App lock'),
                  subtitle: const Text(
                      'Use your fingerprint or phone PIN to open Kobo'),
                  value: s.appLockEnabled,
                  onChanged: _setLock,
                ),
                section('Your data'),
                ListTile(
                  leading: const Icon(Icons.table_view_outlined),
                  title: const Text('Export transactions (CSV)'),
                  subtitle: const Text('Open in Excel or Google Sheets'),
                  onTap: _busy ? null : () => _run(_exportCsv),
                ),
                ListTile(
                  leading: const Icon(Icons.save_alt_rounded),
                  title: const Text('Save a backup'),
                  subtitle: const Text('Keep a copy of everything on your phone'),
                  onTap: _busy ? null : () => _run(_saveBackup),
                ),
                ListTile(
                  leading: const Icon(Icons.share_outlined),
                  title: const Text('Share a backup'),
                  subtitle:
                      const Text('Send it to Google Drive, email or WhatsApp'),
                  onTap: _busy ? null : () => _run(_shareBackup),
                ),
                ListTile(
                  leading: const Icon(Icons.settings_backup_restore_rounded),
                  title: const Text('Restore from backup'),
                  subtitle: const Text('Replaces everything in Kobo'),
                  onTap: _busy ? null : _restore,
                ),
                ListTile(
                  leading:
                      Icon(Icons.delete_forever_outlined, color: scheme.error),
                  title: Text('Start over',
                      style: TextStyle(color: scheme.error)),
                  subtitle: const Text('Erase everything and set up again'),
                  onTap: _busy ? null : _startOver,
                ),
                section('About'),
                const ListTile(
                  leading: Icon(Icons.info_outline_rounded),
                  title: Text('Kobo 1.0 by G3Labs'),
                  subtitle: Text('Works offline. Everything stays on this phone.'),
                ),
              ],
            ),
    );
  }
}

class CategoriesScreen extends StatelessWidget {
  const CategoriesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Scaffold(
      appBar: AppBar(
        backgroundColor: theme.colorScheme.surface,
        surfaceTintColor: Colors.transparent,
        title: const Text('Categories'),
      ),
      body: ListView(
        padding: const EdgeInsets.fromLTRB(20, 8, 20, 32),
        children: [
          Text(
            'Priority decides what gets money first when Kobo suggests a '
            'budget. New categories start with no budget; give them one in '
            'Edit this period’s budget.',
            style: theme.textTheme.bodyMedium
                ?.copyWith(color: theme.colorScheme.onSurfaceVariant),
          ),
          const SizedBox(height: 16),
          const CategoriesEditor(),
        ],
      ),
    );
  }
}

class _IncomeScheduleSheet extends ConsumerStatefulWidget {
  const _IncomeScheduleSheet();

  @override
  ConsumerState<_IncomeScheduleSheet> createState() =>
      _IncomeScheduleSheetState();
}

class _IncomeScheduleSheetState extends ConsumerState<_IncomeScheduleSheet> {
  final _form = GlobalKey<FormState>();
  late final TextEditingController _amount;
  late IncomeFrequency _freq;
  DateTime? _end;
  bool _busy = false;

  bool get _irregular => _freq == IncomeFrequency.irregular;

  @override
  void initState() {
    super.initState();
    final s = switch (ref.read(settingsProvider)) {
      AsyncData(:final value) => value,
      _ => null,
    };
    _freq = s?.incomeFrequency ?? IncomeFrequency.monthly;
    final usual = s?.usualIncomeKobo ?? 0;
    _amount = TextEditingController(text: usual == 0 ? '' : koboToInputText(usual));
    _end = switch (ref.read(activeCycleProvider)) {
      AsyncData(:final value) => value?.endDate,
      _ => null,
    };
  }

  @override
  void dispose() {
    _amount.dispose();
    super.dispose();
  }

  Future<void> _pickEnd() async {
    final t = DateTime.now();
    final tomorrow = DateTime(t.year, t.month, t.day + 1);
    final current = _end ?? tomorrow;
    final picked = await showDatePicker(
      context: context,
      initialDate: current.isBefore(tomorrow) ? tomorrow : current,
      firstDate: tomorrow,
      lastDate: DateTime(t.year + 1, t.month, t.day),
    );
    if (picked != null) setState(() => _end = picked);
  }

  Future<void> _save() async {
    if (!_form.currentState!.validate()) return;
    setState(() => _busy = true);
    final db = ref.read(databaseProvider);
    await db.updateSettings(AppSettingsCompanion(
      incomeFrequency: Value(_freq),
      usualIncomeKobo: Value(parseNairaToKobo(_amount.text) ?? 0),
    ));
    if (_end != null) await db.updateActiveCycleEnd(dateOnly(_end!));
    if (mounted) Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final text = theme.textTheme;
    return Padding(
      padding: EdgeInsets.fromLTRB(
          24, 0, 24, 24 + MediaQuery.viewInsetsOf(context).bottom),
      child: SingleChildScrollView(
        child: Form(
          key: _form,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Text('Income schedule', style: text.titleLarge),
              const SizedBox(height: 16),
              SegmentedButton<IncomeFrequency>(
                showSelectedIcon: false,
                segments: [
                  for (final f in IncomeFrequency.values)
                    ButtonSegment(value: f, label: Text(f.label)),
                ],
                selected: {_freq},
                onSelectionChanged: (v) => setState(() => _freq = v.first),
              ),
              const SizedBox(height: 16),
              AmountField(
                controller: _amount,
                label: _irregular ? 'Typical amount (optional)' : 'Usual amount',
                allowZero: _irregular,
                optional: _irregular,
              ),
              if (_end != null) ...[
                const SizedBox(height: 8),
                ListTile(
                  contentPadding: EdgeInsets.zero,
                  leading: const Icon(Icons.event_rounded),
                  title: const Text('This period ends'),
                  subtitle: const Text(
                      'Moving this changes your daily limit straight away.'),
                  trailing: Text(DateFormat('d MMM').format(_end!),
                      style: text.titleSmall),
                  onTap: _pickEnd,
                ),
              ],
              const SizedBox(height: 16),
              FilledButton(
                onPressed: _busy ? null : _save,
                child: const Text('Save'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
