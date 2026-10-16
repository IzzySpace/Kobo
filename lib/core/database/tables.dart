import 'package:drift/drift.dart';

enum TxType { expense, income }

enum CategoryKind { expense, income }

/// Order matters: the budget suggester funds tiers top to bottom.
enum PriorityTier { essential, school, buffer, savings, wants }

enum IncomeFrequency { weekly, monthly, irregular }

enum AppThemeMode { system, light, dark }

/// Single-row table (id is always 1).
@DataClassName('SettingsRow')
class AppSettings extends Table {
  IntColumn get id => integer().withDefault(const Constant(1))();
  BoolColumn get onboardingDone =>
      boolean().withDefault(const Constant(false))();
  IntColumn get openingBalanceKobo =>
      integer().withDefault(const Constant(0))();
  IntColumn get usualIncomeKobo => integer().withDefault(const Constant(0))();
  TextColumn get incomeFrequency => textEnum<IncomeFrequency>()
      .withDefault(Constant(IncomeFrequency.monthly.name))();
  TextColumn get themeMode => textEnum<AppThemeMode>()
      .withDefault(Constant(AppThemeMode.system.name))();
  BoolColumn get appLockEnabled =>
      boolean().withDefault(const Constant(false))();
  BoolColumn get dailyReminderEnabled =>
      boolean().withDefault(const Constant(false))();
  // Minutes after midnight. 1230 = 8:30 PM.
  IntColumn get reminderMinuteOfDay =>
      integer().withDefault(const Constant(1230))();
  BoolColumn get categoryAlertsEnabled =>
      boolean().withDefault(const Constant(true))();

  @override
  Set<Column> get primaryKey => {id};
}

@DataClassName('BudgetCategory')
class Categories extends Table {
  IntColumn get id => integer().autoIncrement()();
  TextColumn get name => text().withLength(min: 1, max: 40)();
  TextColumn get kind => textEnum<CategoryKind>()();
  // Null for income categories.
  TextColumn get tier => textEnum<PriorityTier>().nullable()();
  TextColumn get iconKey => text()();
  IntColumn get colorValue => integer()();
  IntColumn get sortOrder => integer().withDefault(const Constant(0))();
  // Categories are archived, never deleted, so history stays intact.
  BoolColumn get archived => boolean().withDefault(const Constant(false))();
}

/// One cycle per income. endDate = next payday (weekly/monthly)
/// or the "make it last until" date picked for irregular income.
@DataClassName('BudgetCycle')
class BudgetCycles extends Table {
  IntColumn get id => integer().autoIncrement()();
  DateTimeColumn get startDate => dateTime()();
  DateTimeColumn get endDate => dateTime()();
  IntColumn get startingBalanceKobo => integer()();
  IntColumn get plannedSavingsKobo =>
      integer().withDefault(const Constant(0))();
  BoolColumn get isActive => boolean().withDefault(const Constant(true))();
}

@DataClassName('BudgetLine')
class BudgetLines extends Table {
  IntColumn get id => integer().autoIncrement()();
  IntColumn get cycleId => integer()
      .references(BudgetCycles, #id, onDelete: KeyAction.cascade)();
  IntColumn get categoryId =>
      integer().references(Categories, #id, onDelete: KeyAction.cascade)();
  IntColumn get plannedKobo =>
      integer().check(plannedKobo.isBiggerOrEqualValue(0))();
  // So the 80% / 100% alerts fire once per cycle, not on every log.
  BoolColumn get alerted80 => boolean().withDefault(const Constant(false))();
  BoolColumn get alerted100 => boolean().withDefault(const Constant(false))();

  @override
  List<Set<Column>> get uniqueKeys => [
        {cycleId, categoryId},
      ];
}

@DataClassName('Txn')
@TableIndex(name: 'idx_txn_occurred_at', columns: {#occurredAt})
class Transactions extends Table {
  IntColumn get id => integer().autoIncrement()();
  TextColumn get type => textEnum<TxType>()();
  IntColumn get amountKobo =>
      integer().check(amountKobo.isBiggerThanValue(0))();
  IntColumn get categoryId => integer().references(Categories, #id)();
  TextColumn get note => text().withLength(max: 200).nullable()();
  DateTimeColumn get occurredAt => dateTime()();
  DateTimeColumn get createdAt =>
      dateTime().withDefault(currentDateAndTime)();
}

@DataClassName('SavingsGoal')
class SavingsGoals extends Table {
  IntColumn get id => integer().autoIncrement()();
  TextColumn get name => text().withLength(min: 1, max: 40)();
  IntColumn get targetKobo =>
      integer().check(targetKobo.isBiggerThanValue(0))();
  DateTimeColumn get deadline => dateTime().nullable()();
  DateTimeColumn get createdAt =>
      dateTime().withDefault(currentDateAndTime)();
  BoolColumn get archived => boolean().withDefault(const Constant(false))();
}

/// Positive = money set aside. Negative = withdrawal back to spendable.
@DataClassName('GoalContribution')
class GoalContributions extends Table {
  IntColumn get id => integer().autoIncrement()();
  IntColumn get goalId =>
      integer().references(SavingsGoals, #id, onDelete: KeyAction.cascade)();
  IntColumn get amountKobo =>
      integer().check(amountKobo.equals(0).not())();
  TextColumn get note => text().withLength(max: 200).nullable()();
  DateTimeColumn get createdAt =>
      dateTime().withDefault(currentDateAndTime)();
}
