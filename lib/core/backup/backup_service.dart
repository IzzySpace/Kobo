import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:intl/intl.dart';
import 'package:path/path.dart' as p;
import 'package:path_provider/path_provider.dart';
import 'package:share_plus/share_plus.dart';

import '../database/app_database.dart';
import '../database/settings_queries.dart';
import 'csv.dart';

class BackupService {
  BackupService(this.db);
  final AppDatabase db;

  String get _stamp => DateFormat('yyyy-MM-dd').format(DateTime.now());

  Future<String> _tempPath(String name) async {
    final dir = await getTemporaryDirectory();
    final path = p.join(dir.path, name);
    final file = File(path);
    if (await file.exists()) await file.delete();
    return path;
  }

  /// Shares a CSV of every transaction. Returns how many were exported.
  Future<int> shareCsv() async {
    final rows = await db.allTransactionsWithCategory();
    if (rows.isEmpty) return 0;
    final csv = buildTransactionsCsv([
      for (final (t, c) in rows)
        CsvRow(
          when: t.occurredAt,
          type: t.type == TxType.expense ? 'Expense' : 'Income',
          category: c?.name ?? 'Removed category',
          amountKobo: t.amountKobo,
          note: t.note,
        ),
    ]);
    final path = await _tempPath('kobo-transactions-$_stamp.csv');
    // The byte-order mark makes Excel read ₦ and other symbols correctly.
    await File(path).writeAsString('\uFEFF$csv');
    await SharePlus.instance.share(ShareParams(
      files: [XFile(path, mimeType: 'text/csv')],
      subject: 'Kobo transactions',
    ));
    return rows.length;
  }

  Future<String> _makeBackup() async {
    final path = await _tempPath('kobo-backup-$_stamp.db');
    await db.backupTo(path);
    return path;
  }

  /// Lets the person pick where to save. False if they cancelled.
  Future<bool> saveBackupToPhone() async {
    final path = await _makeBackup();
    final bytes = await File(path).readAsBytes();
    final saved = await FilePicker.saveFile(
      dialogTitle: 'Save Kobo backup',
      fileName: p.basename(path),
      bytes: bytes,
    );
    return saved != null;
  }

  Future<void> shareBackup() async {
    final path = await _makeBackup();
    await SharePlus.instance.share(ShareParams(
      files: [XFile(path)],
      subject: 'Kobo backup',
    ));
  }

  /// False if the person cancelled. Throws if the file isn't usable.
  Future<bool> restoreFromPicker() async {
    final result = await FilePicker.pickFiles(type: FileType.any);
    final path = (result == null || result.isEmpty) ? null : result.first.path;
    if (path == null) return false;
    await db.restoreFrom(path);
    return true;
  }
}
