// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'app_database.dart';

// ignore_for_file: type=lint
class $AppSettingsTable extends AppSettings
    with TableInfo<$AppSettingsTable, SettingsRow> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $AppSettingsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
    'id',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultValue: const Constant(1),
  );
  static const VerificationMeta _onboardingDoneMeta = const VerificationMeta(
    'onboardingDone',
  );
  @override
  late final GeneratedColumn<bool> onboardingDone = GeneratedColumn<bool>(
    'onboarding_done',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("onboarding_done" IN (0, 1))',
    ),
    defaultValue: const Constant(false),
  );
  static const VerificationMeta _openingBalanceKoboMeta =
      const VerificationMeta('openingBalanceKobo');
  @override
  late final GeneratedColumn<int> openingBalanceKobo = GeneratedColumn<int>(
    'opening_balance_kobo',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultValue: const Constant(0),
  );
  static const VerificationMeta _usualIncomeKoboMeta = const VerificationMeta(
    'usualIncomeKobo',
  );
  @override
  late final GeneratedColumn<int> usualIncomeKobo = GeneratedColumn<int>(
    'usual_income_kobo',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultValue: const Constant(0),
  );
  @override
  late final GeneratedColumnWithTypeConverter<IncomeFrequency, String>
  incomeFrequency = GeneratedColumn<String>(
    'income_frequency',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultValue: Constant(IncomeFrequency.monthly.name),
  ).withConverter<IncomeFrequency>($AppSettingsTable.$converterincomeFrequency);
  @override
  late final GeneratedColumnWithTypeConverter<AppThemeMode, String> themeMode =
      GeneratedColumn<String>(
        'theme_mode',
        aliasedName,
        false,
        type: DriftSqlType.string,
        requiredDuringInsert: false,
        defaultValue: Constant(AppThemeMode.system.name),
      ).withConverter<AppThemeMode>($AppSettingsTable.$converterthemeMode);
  static const VerificationMeta _appLockEnabledMeta = const VerificationMeta(
    'appLockEnabled',
  );
  @override
  late final GeneratedColumn<bool> appLockEnabled = GeneratedColumn<bool>(
    'app_lock_enabled',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("app_lock_enabled" IN (0, 1))',
    ),
    defaultValue: const Constant(false),
  );
  static const VerificationMeta _dailyReminderEnabledMeta =
      const VerificationMeta('dailyReminderEnabled');
  @override
  late final GeneratedColumn<bool> dailyReminderEnabled = GeneratedColumn<bool>(
    'daily_reminder_enabled',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("daily_reminder_enabled" IN (0, 1))',
    ),
    defaultValue: const Constant(false),
  );
  static const VerificationMeta _reminderMinuteOfDayMeta =
      const VerificationMeta('reminderMinuteOfDay');
  @override
  late final GeneratedColumn<int> reminderMinuteOfDay = GeneratedColumn<int>(
    'reminder_minute_of_day',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultValue: const Constant(1230),
  );
  static const VerificationMeta _categoryAlertsEnabledMeta =
      const VerificationMeta('categoryAlertsEnabled');
  @override
  late final GeneratedColumn<bool> categoryAlertsEnabled =
      GeneratedColumn<bool>(
        'category_alerts_enabled',
        aliasedName,
        false,
        type: DriftSqlType.bool,
        requiredDuringInsert: false,
        defaultConstraints: GeneratedColumn.constraintIsAlways(
          'CHECK ("category_alerts_enabled" IN (0, 1))',
        ),
        defaultValue: const Constant(true),
      );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    onboardingDone,
    openingBalanceKobo,
    usualIncomeKobo,
    incomeFrequency,
    themeMode,
    appLockEnabled,
    dailyReminderEnabled,
    reminderMinuteOfDay,
    categoryAlertsEnabled,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'app_settings';
  @override
  VerificationContext validateIntegrity(
    Insertable<SettingsRow> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('onboarding_done')) {
      context.handle(
        _onboardingDoneMeta,
        onboardingDone.isAcceptableOrUnknown(
          data['onboarding_done']!,
          _onboardingDoneMeta,
        ),
      );
    }
    if (data.containsKey('opening_balance_kobo')) {
      context.handle(
        _openingBalanceKoboMeta,
        openingBalanceKobo.isAcceptableOrUnknown(
          data['opening_balance_kobo']!,
          _openingBalanceKoboMeta,
        ),
      );
    }
    if (data.containsKey('usual_income_kobo')) {
      context.handle(
        _usualIncomeKoboMeta,
        usualIncomeKobo.isAcceptableOrUnknown(
          data['usual_income_kobo']!,
          _usualIncomeKoboMeta,
        ),
      );
    }
    if (data.containsKey('app_lock_enabled')) {
      context.handle(
        _appLockEnabledMeta,
        appLockEnabled.isAcceptableOrUnknown(
          data['app_lock_enabled']!,
          _appLockEnabledMeta,
        ),
      );
    }
    if (data.containsKey('daily_reminder_enabled')) {
      context.handle(
        _dailyReminderEnabledMeta,
        dailyReminderEnabled.isAcceptableOrUnknown(
          data['daily_reminder_enabled']!,
          _dailyReminderEnabledMeta,
        ),
      );
    }
    if (data.containsKey('reminder_minute_of_day')) {
      context.handle(
        _reminderMinuteOfDayMeta,
        reminderMinuteOfDay.isAcceptableOrUnknown(
          data['reminder_minute_of_day']!,
          _reminderMinuteOfDayMeta,
        ),
      );
    }
    if (data.containsKey('category_alerts_enabled')) {
      context.handle(
        _categoryAlertsEnabledMeta,
        categoryAlertsEnabled.isAcceptableOrUnknown(
          data['category_alerts_enabled']!,
          _categoryAlertsEnabledMeta,
        ),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  SettingsRow map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return SettingsRow(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}id'],
      )!,
      onboardingDone: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}onboarding_done'],
      )!,
      openingBalanceKobo: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}opening_balance_kobo'],
      )!,
      usualIncomeKobo: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}usual_income_kobo'],
      )!,
      incomeFrequency: $AppSettingsTable.$converterincomeFrequency.fromSql(
        attachedDatabase.typeMapping.read(
          DriftSqlType.string,
          data['${effectivePrefix}income_frequency'],
        )!,
      ),
      themeMode: $AppSettingsTable.$converterthemeMode.fromSql(
        attachedDatabase.typeMapping.read(
          DriftSqlType.string,
          data['${effectivePrefix}theme_mode'],
        )!,
      ),
      appLockEnabled: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}app_lock_enabled'],
      )!,
      dailyReminderEnabled: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}daily_reminder_enabled'],
      )!,
      reminderMinuteOfDay: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}reminder_minute_of_day'],
      )!,
      categoryAlertsEnabled: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}category_alerts_enabled'],
      )!,
    );
  }

  @override
  $AppSettingsTable createAlias(String alias) {
    return $AppSettingsTable(attachedDatabase, alias);
  }

  static JsonTypeConverter2<IncomeFrequency, String, String>
  $converterincomeFrequency = const EnumNameConverter<IncomeFrequency>(
    IncomeFrequency.values,
  );
  static JsonTypeConverter2<AppThemeMode, String, String> $converterthemeMode =
      const EnumNameConverter<AppThemeMode>(AppThemeMode.values);
}

class SettingsRow extends DataClass implements Insertable<SettingsRow> {
  final int id;
  final bool onboardingDone;
  final int openingBalanceKobo;
  final int usualIncomeKobo;
  final IncomeFrequency incomeFrequency;
  final AppThemeMode themeMode;
  final bool appLockEnabled;
  final bool dailyReminderEnabled;
  final int reminderMinuteOfDay;
  final bool categoryAlertsEnabled;
  const SettingsRow({
    required this.id,
    required this.onboardingDone,
    required this.openingBalanceKobo,
    required this.usualIncomeKobo,
    required this.incomeFrequency,
    required this.themeMode,
    required this.appLockEnabled,
    required this.dailyReminderEnabled,
    required this.reminderMinuteOfDay,
    required this.categoryAlertsEnabled,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['onboarding_done'] = Variable<bool>(onboardingDone);
    map['opening_balance_kobo'] = Variable<int>(openingBalanceKobo);
    map['usual_income_kobo'] = Variable<int>(usualIncomeKobo);
    {
      map['income_frequency'] = Variable<String>(
        $AppSettingsTable.$converterincomeFrequency.toSql(incomeFrequency),
      );
    }
    {
      map['theme_mode'] = Variable<String>(
        $AppSettingsTable.$converterthemeMode.toSql(themeMode),
      );
    }
    map['app_lock_enabled'] = Variable<bool>(appLockEnabled);
    map['daily_reminder_enabled'] = Variable<bool>(dailyReminderEnabled);
    map['reminder_minute_of_day'] = Variable<int>(reminderMinuteOfDay);
    map['category_alerts_enabled'] = Variable<bool>(categoryAlertsEnabled);
    return map;
  }

  AppSettingsCompanion toCompanion(bool nullToAbsent) {
    return AppSettingsCompanion(
      id: Value(id),
      onboardingDone: Value(onboardingDone),
      openingBalanceKobo: Value(openingBalanceKobo),
      usualIncomeKobo: Value(usualIncomeKobo),
      incomeFrequency: Value(incomeFrequency),
      themeMode: Value(themeMode),
      appLockEnabled: Value(appLockEnabled),
      dailyReminderEnabled: Value(dailyReminderEnabled),
      reminderMinuteOfDay: Value(reminderMinuteOfDay),
      categoryAlertsEnabled: Value(categoryAlertsEnabled),
    );
  }

  factory SettingsRow.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return SettingsRow(
      id: serializer.fromJson<int>(json['id']),
      onboardingDone: serializer.fromJson<bool>(json['onboardingDone']),
      openingBalanceKobo: serializer.fromJson<int>(json['openingBalanceKobo']),
      usualIncomeKobo: serializer.fromJson<int>(json['usualIncomeKobo']),
      incomeFrequency: $AppSettingsTable.$converterincomeFrequency.fromJson(
        serializer.fromJson<String>(json['incomeFrequency']),
      ),
      themeMode: $AppSettingsTable.$converterthemeMode.fromJson(
        serializer.fromJson<String>(json['themeMode']),
      ),
      appLockEnabled: serializer.fromJson<bool>(json['appLockEnabled']),
      dailyReminderEnabled: serializer.fromJson<bool>(
        json['dailyReminderEnabled'],
      ),
      reminderMinuteOfDay: serializer.fromJson<int>(
        json['reminderMinuteOfDay'],
      ),
      categoryAlertsEnabled: serializer.fromJson<bool>(
        json['categoryAlertsEnabled'],
      ),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'onboardingDone': serializer.toJson<bool>(onboardingDone),
      'openingBalanceKobo': serializer.toJson<int>(openingBalanceKobo),
      'usualIncomeKobo': serializer.toJson<int>(usualIncomeKobo),
      'incomeFrequency': serializer.toJson<String>(
        $AppSettingsTable.$converterincomeFrequency.toJson(incomeFrequency),
      ),
      'themeMode': serializer.toJson<String>(
        $AppSettingsTable.$converterthemeMode.toJson(themeMode),
      ),
      'appLockEnabled': serializer.toJson<bool>(appLockEnabled),
      'dailyReminderEnabled': serializer.toJson<bool>(dailyReminderEnabled),
      'reminderMinuteOfDay': serializer.toJson<int>(reminderMinuteOfDay),
      'categoryAlertsEnabled': serializer.toJson<bool>(categoryAlertsEnabled),
    };
  }

  SettingsRow copyWith({
    int? id,
    bool? onboardingDone,
    int? openingBalanceKobo,
    int? usualIncomeKobo,
    IncomeFrequency? incomeFrequency,
    AppThemeMode? themeMode,
    bool? appLockEnabled,
    bool? dailyReminderEnabled,
    int? reminderMinuteOfDay,
    bool? categoryAlertsEnabled,
  }) => SettingsRow(
    id: id ?? this.id,
    onboardingDone: onboardingDone ?? this.onboardingDone,
    openingBalanceKobo: openingBalanceKobo ?? this.openingBalanceKobo,
    usualIncomeKobo: usualIncomeKobo ?? this.usualIncomeKobo,
    incomeFrequency: incomeFrequency ?? this.incomeFrequency,
    themeMode: themeMode ?? this.themeMode,
    appLockEnabled: appLockEnabled ?? this.appLockEnabled,
    dailyReminderEnabled: dailyReminderEnabled ?? this.dailyReminderEnabled,
    reminderMinuteOfDay: reminderMinuteOfDay ?? this.reminderMinuteOfDay,
    categoryAlertsEnabled: categoryAlertsEnabled ?? this.categoryAlertsEnabled,
  );
  SettingsRow copyWithCompanion(AppSettingsCompanion data) {
    return SettingsRow(
      id: data.id.present ? data.id.value : this.id,
      onboardingDone: data.onboardingDone.present
          ? data.onboardingDone.value
          : this.onboardingDone,
      openingBalanceKobo: data.openingBalanceKobo.present
          ? data.openingBalanceKobo.value
          : this.openingBalanceKobo,
      usualIncomeKobo: data.usualIncomeKobo.present
          ? data.usualIncomeKobo.value
          : this.usualIncomeKobo,
      incomeFrequency: data.incomeFrequency.present
          ? data.incomeFrequency.value
          : this.incomeFrequency,
      themeMode: data.themeMode.present ? data.themeMode.value : this.themeMode,
      appLockEnabled: data.appLockEnabled.present
          ? data.appLockEnabled.value
          : this.appLockEnabled,
      dailyReminderEnabled: data.dailyReminderEnabled.present
          ? data.dailyReminderEnabled.value
          : this.dailyReminderEnabled,
      reminderMinuteOfDay: data.reminderMinuteOfDay.present
          ? data.reminderMinuteOfDay.value
          : this.reminderMinuteOfDay,
      categoryAlertsEnabled: data.categoryAlertsEnabled.present
          ? data.categoryAlertsEnabled.value
          : this.categoryAlertsEnabled,
    );
  }

  @override
  String toString() {
    return (StringBuffer('SettingsRow(')
          ..write('id: $id, ')
          ..write('onboardingDone: $onboardingDone, ')
          ..write('openingBalanceKobo: $openingBalanceKobo, ')
          ..write('usualIncomeKobo: $usualIncomeKobo, ')
          ..write('incomeFrequency: $incomeFrequency, ')
          ..write('themeMode: $themeMode, ')
          ..write('appLockEnabled: $appLockEnabled, ')
          ..write('dailyReminderEnabled: $dailyReminderEnabled, ')
          ..write('reminderMinuteOfDay: $reminderMinuteOfDay, ')
          ..write('categoryAlertsEnabled: $categoryAlertsEnabled')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    onboardingDone,
    openingBalanceKobo,
    usualIncomeKobo,
    incomeFrequency,
    themeMode,
    appLockEnabled,
    dailyReminderEnabled,
    reminderMinuteOfDay,
    categoryAlertsEnabled,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is SettingsRow &&
          other.id == this.id &&
          other.onboardingDone == this.onboardingDone &&
          other.openingBalanceKobo == this.openingBalanceKobo &&
          other.usualIncomeKobo == this.usualIncomeKobo &&
          other.incomeFrequency == this.incomeFrequency &&
          other.themeMode == this.themeMode &&
          other.appLockEnabled == this.appLockEnabled &&
          other.dailyReminderEnabled == this.dailyReminderEnabled &&
          other.reminderMinuteOfDay == this.reminderMinuteOfDay &&
          other.categoryAlertsEnabled == this.categoryAlertsEnabled);
}

class AppSettingsCompanion extends UpdateCompanion<SettingsRow> {
  final Value<int> id;
  final Value<bool> onboardingDone;
  final Value<int> openingBalanceKobo;
  final Value<int> usualIncomeKobo;
  final Value<IncomeFrequency> incomeFrequency;
  final Value<AppThemeMode> themeMode;
  final Value<bool> appLockEnabled;
  final Value<bool> dailyReminderEnabled;
  final Value<int> reminderMinuteOfDay;
  final Value<bool> categoryAlertsEnabled;
  const AppSettingsCompanion({
    this.id = const Value.absent(),
    this.onboardingDone = const Value.absent(),
    this.openingBalanceKobo = const Value.absent(),
    this.usualIncomeKobo = const Value.absent(),
    this.incomeFrequency = const Value.absent(),
    this.themeMode = const Value.absent(),
    this.appLockEnabled = const Value.absent(),
    this.dailyReminderEnabled = const Value.absent(),
    this.reminderMinuteOfDay = const Value.absent(),
    this.categoryAlertsEnabled = const Value.absent(),
  });
  AppSettingsCompanion.insert({
    this.id = const Value.absent(),
    this.onboardingDone = const Value.absent(),
    this.openingBalanceKobo = const Value.absent(),
    this.usualIncomeKobo = const Value.absent(),
    this.incomeFrequency = const Value.absent(),
    this.themeMode = const Value.absent(),
    this.appLockEnabled = const Value.absent(),
    this.dailyReminderEnabled = const Value.absent(),
    this.reminderMinuteOfDay = const Value.absent(),
    this.categoryAlertsEnabled = const Value.absent(),
  });
  static Insertable<SettingsRow> custom({
    Expression<int>? id,
    Expression<bool>? onboardingDone,
    Expression<int>? openingBalanceKobo,
    Expression<int>? usualIncomeKobo,
    Expression<String>? incomeFrequency,
    Expression<String>? themeMode,
    Expression<bool>? appLockEnabled,
    Expression<bool>? dailyReminderEnabled,
    Expression<int>? reminderMinuteOfDay,
    Expression<bool>? categoryAlertsEnabled,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (onboardingDone != null) 'onboarding_done': onboardingDone,
      if (openingBalanceKobo != null)
        'opening_balance_kobo': openingBalanceKobo,
      if (usualIncomeKobo != null) 'usual_income_kobo': usualIncomeKobo,
      if (incomeFrequency != null) 'income_frequency': incomeFrequency,
      if (themeMode != null) 'theme_mode': themeMode,
      if (appLockEnabled != null) 'app_lock_enabled': appLockEnabled,
      if (dailyReminderEnabled != null)
        'daily_reminder_enabled': dailyReminderEnabled,
      if (reminderMinuteOfDay != null)
        'reminder_minute_of_day': reminderMinuteOfDay,
      if (categoryAlertsEnabled != null)
        'category_alerts_enabled': categoryAlertsEnabled,
    });
  }

  AppSettingsCompanion copyWith({
    Value<int>? id,
    Value<bool>? onboardingDone,
    Value<int>? openingBalanceKobo,
    Value<int>? usualIncomeKobo,
    Value<IncomeFrequency>? incomeFrequency,
    Value<AppThemeMode>? themeMode,
    Value<bool>? appLockEnabled,
    Value<bool>? dailyReminderEnabled,
    Value<int>? reminderMinuteOfDay,
    Value<bool>? categoryAlertsEnabled,
  }) {
    return AppSettingsCompanion(
      id: id ?? this.id,
      onboardingDone: onboardingDone ?? this.onboardingDone,
      openingBalanceKobo: openingBalanceKobo ?? this.openingBalanceKobo,
      usualIncomeKobo: usualIncomeKobo ?? this.usualIncomeKobo,
      incomeFrequency: incomeFrequency ?? this.incomeFrequency,
      themeMode: themeMode ?? this.themeMode,
      appLockEnabled: appLockEnabled ?? this.appLockEnabled,
      dailyReminderEnabled: dailyReminderEnabled ?? this.dailyReminderEnabled,
      reminderMinuteOfDay: reminderMinuteOfDay ?? this.reminderMinuteOfDay,
      categoryAlertsEnabled:
          categoryAlertsEnabled ?? this.categoryAlertsEnabled,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (onboardingDone.present) {
      map['onboarding_done'] = Variable<bool>(onboardingDone.value);
    }
    if (openingBalanceKobo.present) {
      map['opening_balance_kobo'] = Variable<int>(openingBalanceKobo.value);
    }
    if (usualIncomeKobo.present) {
      map['usual_income_kobo'] = Variable<int>(usualIncomeKobo.value);
    }
    if (incomeFrequency.present) {
      map['income_frequency'] = Variable<String>(
        $AppSettingsTable.$converterincomeFrequency.toSql(
          incomeFrequency.value,
        ),
      );
    }
    if (themeMode.present) {
      map['theme_mode'] = Variable<String>(
        $AppSettingsTable.$converterthemeMode.toSql(themeMode.value),
      );
    }
    if (appLockEnabled.present) {
      map['app_lock_enabled'] = Variable<bool>(appLockEnabled.value);
    }
    if (dailyReminderEnabled.present) {
      map['daily_reminder_enabled'] = Variable<bool>(
        dailyReminderEnabled.value,
      );
    }
    if (reminderMinuteOfDay.present) {
      map['reminder_minute_of_day'] = Variable<int>(reminderMinuteOfDay.value);
    }
    if (categoryAlertsEnabled.present) {
      map['category_alerts_enabled'] = Variable<bool>(
        categoryAlertsEnabled.value,
      );
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('AppSettingsCompanion(')
          ..write('id: $id, ')
          ..write('onboardingDone: $onboardingDone, ')
          ..write('openingBalanceKobo: $openingBalanceKobo, ')
          ..write('usualIncomeKobo: $usualIncomeKobo, ')
          ..write('incomeFrequency: $incomeFrequency, ')
          ..write('themeMode: $themeMode, ')
          ..write('appLockEnabled: $appLockEnabled, ')
          ..write('dailyReminderEnabled: $dailyReminderEnabled, ')
          ..write('reminderMinuteOfDay: $reminderMinuteOfDay, ')
          ..write('categoryAlertsEnabled: $categoryAlertsEnabled')
          ..write(')'))
        .toString();
  }
}

class $CategoriesTable extends Categories
    with TableInfo<$CategoriesTable, BudgetCategory> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $CategoriesTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
    'id',
    aliasedName,
    false,
    hasAutoIncrement: true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'PRIMARY KEY AUTOINCREMENT',
    ),
  );
  static const VerificationMeta _nameMeta = const VerificationMeta('name');
  @override
  late final GeneratedColumn<String> name = GeneratedColumn<String>(
    'name',
    aliasedName,
    false,
    additionalChecks: GeneratedColumn.checkTextLength(
      minTextLength: 1,
      maxTextLength: 40,
    ),
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  @override
  late final GeneratedColumnWithTypeConverter<CategoryKind, String> kind =
      GeneratedColumn<String>(
        'kind',
        aliasedName,
        false,
        type: DriftSqlType.string,
        requiredDuringInsert: true,
      ).withConverter<CategoryKind>($CategoriesTable.$converterkind);
  @override
  late final GeneratedColumnWithTypeConverter<PriorityTier?, String> tier =
      GeneratedColumn<String>(
        'tier',
        aliasedName,
        true,
        type: DriftSqlType.string,
        requiredDuringInsert: false,
      ).withConverter<PriorityTier?>($CategoriesTable.$convertertiern);
  static const VerificationMeta _iconKeyMeta = const VerificationMeta(
    'iconKey',
  );
  @override
  late final GeneratedColumn<String> iconKey = GeneratedColumn<String>(
    'icon_key',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _colorValueMeta = const VerificationMeta(
    'colorValue',
  );
  @override
  late final GeneratedColumn<int> colorValue = GeneratedColumn<int>(
    'color_value',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _sortOrderMeta = const VerificationMeta(
    'sortOrder',
  );
  @override
  late final GeneratedColumn<int> sortOrder = GeneratedColumn<int>(
    'sort_order',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultValue: const Constant(0),
  );
  static const VerificationMeta _archivedMeta = const VerificationMeta(
    'archived',
  );
  @override
  late final GeneratedColumn<bool> archived = GeneratedColumn<bool>(
    'archived',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("archived" IN (0, 1))',
    ),
    defaultValue: const Constant(false),
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    name,
    kind,
    tier,
    iconKey,
    colorValue,
    sortOrder,
    archived,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'categories';
  @override
  VerificationContext validateIntegrity(
    Insertable<BudgetCategory> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('name')) {
      context.handle(
        _nameMeta,
        name.isAcceptableOrUnknown(data['name']!, _nameMeta),
      );
    } else if (isInserting) {
      context.missing(_nameMeta);
    }
    if (data.containsKey('icon_key')) {
      context.handle(
        _iconKeyMeta,
        iconKey.isAcceptableOrUnknown(data['icon_key']!, _iconKeyMeta),
      );
    } else if (isInserting) {
      context.missing(_iconKeyMeta);
    }
    if (data.containsKey('color_value')) {
      context.handle(
        _colorValueMeta,
        colorValue.isAcceptableOrUnknown(data['color_value']!, _colorValueMeta),
      );
    } else if (isInserting) {
      context.missing(_colorValueMeta);
    }
    if (data.containsKey('sort_order')) {
      context.handle(
        _sortOrderMeta,
        sortOrder.isAcceptableOrUnknown(data['sort_order']!, _sortOrderMeta),
      );
    }
    if (data.containsKey('archived')) {
      context.handle(
        _archivedMeta,
        archived.isAcceptableOrUnknown(data['archived']!, _archivedMeta),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  BudgetCategory map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return BudgetCategory(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}id'],
      )!,
      name: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}name'],
      )!,
      kind: $CategoriesTable.$converterkind.fromSql(
        attachedDatabase.typeMapping.read(
          DriftSqlType.string,
          data['${effectivePrefix}kind'],
        )!,
      ),
      tier: $CategoriesTable.$convertertiern.fromSql(
        attachedDatabase.typeMapping.read(
          DriftSqlType.string,
          data['${effectivePrefix}tier'],
        ),
      ),
      iconKey: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}icon_key'],
      )!,
      colorValue: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}color_value'],
      )!,
      sortOrder: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}sort_order'],
      )!,
      archived: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}archived'],
      )!,
    );
  }

  @override
  $CategoriesTable createAlias(String alias) {
    return $CategoriesTable(attachedDatabase, alias);
  }

  static JsonTypeConverter2<CategoryKind, String, String> $converterkind =
      const EnumNameConverter<CategoryKind>(CategoryKind.values);
  static JsonTypeConverter2<PriorityTier, String, String> $convertertier =
      const EnumNameConverter<PriorityTier>(PriorityTier.values);
  static JsonTypeConverter2<PriorityTier?, String?, String?> $convertertiern =
      JsonTypeConverter2.asNullable($convertertier);
}

class BudgetCategory extends DataClass implements Insertable<BudgetCategory> {
  final int id;
  final String name;
  final CategoryKind kind;
  final PriorityTier? tier;
  final String iconKey;
  final int colorValue;
  final int sortOrder;
  final bool archived;
  const BudgetCategory({
    required this.id,
    required this.name,
    required this.kind,
    this.tier,
    required this.iconKey,
    required this.colorValue,
    required this.sortOrder,
    required this.archived,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['name'] = Variable<String>(name);
    {
      map['kind'] = Variable<String>(
        $CategoriesTable.$converterkind.toSql(kind),
      );
    }
    if (!nullToAbsent || tier != null) {
      map['tier'] = Variable<String>(
        $CategoriesTable.$convertertiern.toSql(tier),
      );
    }
    map['icon_key'] = Variable<String>(iconKey);
    map['color_value'] = Variable<int>(colorValue);
    map['sort_order'] = Variable<int>(sortOrder);
    map['archived'] = Variable<bool>(archived);
    return map;
  }

  CategoriesCompanion toCompanion(bool nullToAbsent) {
    return CategoriesCompanion(
      id: Value(id),
      name: Value(name),
      kind: Value(kind),
      tier: tier == null && nullToAbsent ? const Value.absent() : Value(tier),
      iconKey: Value(iconKey),
      colorValue: Value(colorValue),
      sortOrder: Value(sortOrder),
      archived: Value(archived),
    );
  }

  factory BudgetCategory.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return BudgetCategory(
      id: serializer.fromJson<int>(json['id']),
      name: serializer.fromJson<String>(json['name']),
      kind: $CategoriesTable.$converterkind.fromJson(
        serializer.fromJson<String>(json['kind']),
      ),
      tier: $CategoriesTable.$convertertiern.fromJson(
        serializer.fromJson<String?>(json['tier']),
      ),
      iconKey: serializer.fromJson<String>(json['iconKey']),
      colorValue: serializer.fromJson<int>(json['colorValue']),
      sortOrder: serializer.fromJson<int>(json['sortOrder']),
      archived: serializer.fromJson<bool>(json['archived']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'name': serializer.toJson<String>(name),
      'kind': serializer.toJson<String>(
        $CategoriesTable.$converterkind.toJson(kind),
      ),
      'tier': serializer.toJson<String?>(
        $CategoriesTable.$convertertiern.toJson(tier),
      ),
      'iconKey': serializer.toJson<String>(iconKey),
      'colorValue': serializer.toJson<int>(colorValue),
      'sortOrder': serializer.toJson<int>(sortOrder),
      'archived': serializer.toJson<bool>(archived),
    };
  }

  BudgetCategory copyWith({
    int? id,
    String? name,
    CategoryKind? kind,
    Value<PriorityTier?> tier = const Value.absent(),
    String? iconKey,
    int? colorValue,
    int? sortOrder,
    bool? archived,
  }) => BudgetCategory(
    id: id ?? this.id,
    name: name ?? this.name,
    kind: kind ?? this.kind,
    tier: tier.present ? tier.value : this.tier,
    iconKey: iconKey ?? this.iconKey,
    colorValue: colorValue ?? this.colorValue,
    sortOrder: sortOrder ?? this.sortOrder,
    archived: archived ?? this.archived,
  );
  BudgetCategory copyWithCompanion(CategoriesCompanion data) {
    return BudgetCategory(
      id: data.id.present ? data.id.value : this.id,
      name: data.name.present ? data.name.value : this.name,
      kind: data.kind.present ? data.kind.value : this.kind,
      tier: data.tier.present ? data.tier.value : this.tier,
      iconKey: data.iconKey.present ? data.iconKey.value : this.iconKey,
      colorValue: data.colorValue.present
          ? data.colorValue.value
          : this.colorValue,
      sortOrder: data.sortOrder.present ? data.sortOrder.value : this.sortOrder,
      archived: data.archived.present ? data.archived.value : this.archived,
    );
  }

  @override
  String toString() {
    return (StringBuffer('BudgetCategory(')
          ..write('id: $id, ')
          ..write('name: $name, ')
          ..write('kind: $kind, ')
          ..write('tier: $tier, ')
          ..write('iconKey: $iconKey, ')
          ..write('colorValue: $colorValue, ')
          ..write('sortOrder: $sortOrder, ')
          ..write('archived: $archived')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    name,
    kind,
    tier,
    iconKey,
    colorValue,
    sortOrder,
    archived,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is BudgetCategory &&
          other.id == this.id &&
          other.name == this.name &&
          other.kind == this.kind &&
          other.tier == this.tier &&
          other.iconKey == this.iconKey &&
          other.colorValue == this.colorValue &&
          other.sortOrder == this.sortOrder &&
          other.archived == this.archived);
}

class CategoriesCompanion extends UpdateCompanion<BudgetCategory> {
  final Value<int> id;
  final Value<String> name;
  final Value<CategoryKind> kind;
  final Value<PriorityTier?> tier;
  final Value<String> iconKey;
  final Value<int> colorValue;
  final Value<int> sortOrder;
  final Value<bool> archived;
  const CategoriesCompanion({
    this.id = const Value.absent(),
    this.name = const Value.absent(),
    this.kind = const Value.absent(),
    this.tier = const Value.absent(),
    this.iconKey = const Value.absent(),
    this.colorValue = const Value.absent(),
    this.sortOrder = const Value.absent(),
    this.archived = const Value.absent(),
  });
  CategoriesCompanion.insert({
    this.id = const Value.absent(),
    required String name,
    required CategoryKind kind,
    this.tier = const Value.absent(),
    required String iconKey,
    required int colorValue,
    this.sortOrder = const Value.absent(),
    this.archived = const Value.absent(),
  }) : name = Value(name),
       kind = Value(kind),
       iconKey = Value(iconKey),
       colorValue = Value(colorValue);
  static Insertable<BudgetCategory> custom({
    Expression<int>? id,
    Expression<String>? name,
    Expression<String>? kind,
    Expression<String>? tier,
    Expression<String>? iconKey,
    Expression<int>? colorValue,
    Expression<int>? sortOrder,
    Expression<bool>? archived,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (name != null) 'name': name,
      if (kind != null) 'kind': kind,
      if (tier != null) 'tier': tier,
      if (iconKey != null) 'icon_key': iconKey,
      if (colorValue != null) 'color_value': colorValue,
      if (sortOrder != null) 'sort_order': sortOrder,
      if (archived != null) 'archived': archived,
    });
  }

  CategoriesCompanion copyWith({
    Value<int>? id,
    Value<String>? name,
    Value<CategoryKind>? kind,
    Value<PriorityTier?>? tier,
    Value<String>? iconKey,
    Value<int>? colorValue,
    Value<int>? sortOrder,
    Value<bool>? archived,
  }) {
    return CategoriesCompanion(
      id: id ?? this.id,
      name: name ?? this.name,
      kind: kind ?? this.kind,
      tier: tier ?? this.tier,
      iconKey: iconKey ?? this.iconKey,
      colorValue: colorValue ?? this.colorValue,
      sortOrder: sortOrder ?? this.sortOrder,
      archived: archived ?? this.archived,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (name.present) {
      map['name'] = Variable<String>(name.value);
    }
    if (kind.present) {
      map['kind'] = Variable<String>(
        $CategoriesTable.$converterkind.toSql(kind.value),
      );
    }
    if (tier.present) {
      map['tier'] = Variable<String>(
        $CategoriesTable.$convertertiern.toSql(tier.value),
      );
    }
    if (iconKey.present) {
      map['icon_key'] = Variable<String>(iconKey.value);
    }
    if (colorValue.present) {
      map['color_value'] = Variable<int>(colorValue.value);
    }
    if (sortOrder.present) {
      map['sort_order'] = Variable<int>(sortOrder.value);
    }
    if (archived.present) {
      map['archived'] = Variable<bool>(archived.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('CategoriesCompanion(')
          ..write('id: $id, ')
          ..write('name: $name, ')
          ..write('kind: $kind, ')
          ..write('tier: $tier, ')
          ..write('iconKey: $iconKey, ')
          ..write('colorValue: $colorValue, ')
          ..write('sortOrder: $sortOrder, ')
          ..write('archived: $archived')
          ..write(')'))
        .toString();
  }
}

class $BudgetCyclesTable extends BudgetCycles
    with TableInfo<$BudgetCyclesTable, BudgetCycle> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $BudgetCyclesTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
    'id',
    aliasedName,
    false,
    hasAutoIncrement: true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'PRIMARY KEY AUTOINCREMENT',
    ),
  );
  static const VerificationMeta _startDateMeta = const VerificationMeta(
    'startDate',
  );
  @override
  late final GeneratedColumn<DateTime> startDate = GeneratedColumn<DateTime>(
    'start_date',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _endDateMeta = const VerificationMeta(
    'endDate',
  );
  @override
  late final GeneratedColumn<DateTime> endDate = GeneratedColumn<DateTime>(
    'end_date',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _startingBalanceKoboMeta =
      const VerificationMeta('startingBalanceKobo');
  @override
  late final GeneratedColumn<int> startingBalanceKobo = GeneratedColumn<int>(
    'starting_balance_kobo',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _plannedSavingsKoboMeta =
      const VerificationMeta('plannedSavingsKobo');
  @override
  late final GeneratedColumn<int> plannedSavingsKobo = GeneratedColumn<int>(
    'planned_savings_kobo',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultValue: const Constant(0),
  );
  static const VerificationMeta _isActiveMeta = const VerificationMeta(
    'isActive',
  );
  @override
  late final GeneratedColumn<bool> isActive = GeneratedColumn<bool>(
    'is_active',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("is_active" IN (0, 1))',
    ),
    defaultValue: const Constant(true),
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    startDate,
    endDate,
    startingBalanceKobo,
    plannedSavingsKobo,
    isActive,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'budget_cycles';
  @override
  VerificationContext validateIntegrity(
    Insertable<BudgetCycle> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('start_date')) {
      context.handle(
        _startDateMeta,
        startDate.isAcceptableOrUnknown(data['start_date']!, _startDateMeta),
      );
    } else if (isInserting) {
      context.missing(_startDateMeta);
    }
    if (data.containsKey('end_date')) {
      context.handle(
        _endDateMeta,
        endDate.isAcceptableOrUnknown(data['end_date']!, _endDateMeta),
      );
    } else if (isInserting) {
      context.missing(_endDateMeta);
    }
    if (data.containsKey('starting_balance_kobo')) {
      context.handle(
        _startingBalanceKoboMeta,
        startingBalanceKobo.isAcceptableOrUnknown(
          data['starting_balance_kobo']!,
          _startingBalanceKoboMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_startingBalanceKoboMeta);
    }
    if (data.containsKey('planned_savings_kobo')) {
      context.handle(
        _plannedSavingsKoboMeta,
        plannedSavingsKobo.isAcceptableOrUnknown(
          data['planned_savings_kobo']!,
          _plannedSavingsKoboMeta,
        ),
      );
    }
    if (data.containsKey('is_active')) {
      context.handle(
        _isActiveMeta,
        isActive.isAcceptableOrUnknown(data['is_active']!, _isActiveMeta),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  BudgetCycle map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return BudgetCycle(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}id'],
      )!,
      startDate: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}start_date'],
      )!,
      endDate: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}end_date'],
      )!,
      startingBalanceKobo: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}starting_balance_kobo'],
      )!,
      plannedSavingsKobo: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}planned_savings_kobo'],
      )!,
      isActive: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}is_active'],
      )!,
    );
  }

  @override
  $BudgetCyclesTable createAlias(String alias) {
    return $BudgetCyclesTable(attachedDatabase, alias);
  }
}

class BudgetCycle extends DataClass implements Insertable<BudgetCycle> {
  final int id;
  final DateTime startDate;
  final DateTime endDate;
  final int startingBalanceKobo;
  final int plannedSavingsKobo;
  final bool isActive;
  const BudgetCycle({
    required this.id,
    required this.startDate,
    required this.endDate,
    required this.startingBalanceKobo,
    required this.plannedSavingsKobo,
    required this.isActive,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['start_date'] = Variable<DateTime>(startDate);
    map['end_date'] = Variable<DateTime>(endDate);
    map['starting_balance_kobo'] = Variable<int>(startingBalanceKobo);
    map['planned_savings_kobo'] = Variable<int>(plannedSavingsKobo);
    map['is_active'] = Variable<bool>(isActive);
    return map;
  }

  BudgetCyclesCompanion toCompanion(bool nullToAbsent) {
    return BudgetCyclesCompanion(
      id: Value(id),
      startDate: Value(startDate),
      endDate: Value(endDate),
      startingBalanceKobo: Value(startingBalanceKobo),
      plannedSavingsKobo: Value(plannedSavingsKobo),
      isActive: Value(isActive),
    );
  }

  factory BudgetCycle.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return BudgetCycle(
      id: serializer.fromJson<int>(json['id']),
      startDate: serializer.fromJson<DateTime>(json['startDate']),
      endDate: serializer.fromJson<DateTime>(json['endDate']),
      startingBalanceKobo: serializer.fromJson<int>(
        json['startingBalanceKobo'],
      ),
      plannedSavingsKobo: serializer.fromJson<int>(json['plannedSavingsKobo']),
      isActive: serializer.fromJson<bool>(json['isActive']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'startDate': serializer.toJson<DateTime>(startDate),
      'endDate': serializer.toJson<DateTime>(endDate),
      'startingBalanceKobo': serializer.toJson<int>(startingBalanceKobo),
      'plannedSavingsKobo': serializer.toJson<int>(plannedSavingsKobo),
      'isActive': serializer.toJson<bool>(isActive),
    };
  }

  BudgetCycle copyWith({
    int? id,
    DateTime? startDate,
    DateTime? endDate,
    int? startingBalanceKobo,
    int? plannedSavingsKobo,
    bool? isActive,
  }) => BudgetCycle(
    id: id ?? this.id,
    startDate: startDate ?? this.startDate,
    endDate: endDate ?? this.endDate,
    startingBalanceKobo: startingBalanceKobo ?? this.startingBalanceKobo,
    plannedSavingsKobo: plannedSavingsKobo ?? this.plannedSavingsKobo,
    isActive: isActive ?? this.isActive,
  );
  BudgetCycle copyWithCompanion(BudgetCyclesCompanion data) {
    return BudgetCycle(
      id: data.id.present ? data.id.value : this.id,
      startDate: data.startDate.present ? data.startDate.value : this.startDate,
      endDate: data.endDate.present ? data.endDate.value : this.endDate,
      startingBalanceKobo: data.startingBalanceKobo.present
          ? data.startingBalanceKobo.value
          : this.startingBalanceKobo,
      plannedSavingsKobo: data.plannedSavingsKobo.present
          ? data.plannedSavingsKobo.value
          : this.plannedSavingsKobo,
      isActive: data.isActive.present ? data.isActive.value : this.isActive,
    );
  }

  @override
  String toString() {
    return (StringBuffer('BudgetCycle(')
          ..write('id: $id, ')
          ..write('startDate: $startDate, ')
          ..write('endDate: $endDate, ')
          ..write('startingBalanceKobo: $startingBalanceKobo, ')
          ..write('plannedSavingsKobo: $plannedSavingsKobo, ')
          ..write('isActive: $isActive')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    startDate,
    endDate,
    startingBalanceKobo,
    plannedSavingsKobo,
    isActive,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is BudgetCycle &&
          other.id == this.id &&
          other.startDate == this.startDate &&
          other.endDate == this.endDate &&
          other.startingBalanceKobo == this.startingBalanceKobo &&
          other.plannedSavingsKobo == this.plannedSavingsKobo &&
          other.isActive == this.isActive);
}

class BudgetCyclesCompanion extends UpdateCompanion<BudgetCycle> {
  final Value<int> id;
  final Value<DateTime> startDate;
  final Value<DateTime> endDate;
  final Value<int> startingBalanceKobo;
  final Value<int> plannedSavingsKobo;
  final Value<bool> isActive;
  const BudgetCyclesCompanion({
    this.id = const Value.absent(),
    this.startDate = const Value.absent(),
    this.endDate = const Value.absent(),
    this.startingBalanceKobo = const Value.absent(),
    this.plannedSavingsKobo = const Value.absent(),
    this.isActive = const Value.absent(),
  });
  BudgetCyclesCompanion.insert({
    this.id = const Value.absent(),
    required DateTime startDate,
    required DateTime endDate,
    required int startingBalanceKobo,
    this.plannedSavingsKobo = const Value.absent(),
    this.isActive = const Value.absent(),
  }) : startDate = Value(startDate),
       endDate = Value(endDate),
       startingBalanceKobo = Value(startingBalanceKobo);
  static Insertable<BudgetCycle> custom({
    Expression<int>? id,
    Expression<DateTime>? startDate,
    Expression<DateTime>? endDate,
    Expression<int>? startingBalanceKobo,
    Expression<int>? plannedSavingsKobo,
    Expression<bool>? isActive,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (startDate != null) 'start_date': startDate,
      if (endDate != null) 'end_date': endDate,
      if (startingBalanceKobo != null)
        'starting_balance_kobo': startingBalanceKobo,
      if (plannedSavingsKobo != null)
        'planned_savings_kobo': plannedSavingsKobo,
      if (isActive != null) 'is_active': isActive,
    });
  }

  BudgetCyclesCompanion copyWith({
    Value<int>? id,
    Value<DateTime>? startDate,
    Value<DateTime>? endDate,
    Value<int>? startingBalanceKobo,
    Value<int>? plannedSavingsKobo,
    Value<bool>? isActive,
  }) {
    return BudgetCyclesCompanion(
      id: id ?? this.id,
      startDate: startDate ?? this.startDate,
      endDate: endDate ?? this.endDate,
      startingBalanceKobo: startingBalanceKobo ?? this.startingBalanceKobo,
      plannedSavingsKobo: plannedSavingsKobo ?? this.plannedSavingsKobo,
      isActive: isActive ?? this.isActive,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (startDate.present) {
      map['start_date'] = Variable<DateTime>(startDate.value);
    }
    if (endDate.present) {
      map['end_date'] = Variable<DateTime>(endDate.value);
    }
    if (startingBalanceKobo.present) {
      map['starting_balance_kobo'] = Variable<int>(startingBalanceKobo.value);
    }
    if (plannedSavingsKobo.present) {
      map['planned_savings_kobo'] = Variable<int>(plannedSavingsKobo.value);
    }
    if (isActive.present) {
      map['is_active'] = Variable<bool>(isActive.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('BudgetCyclesCompanion(')
          ..write('id: $id, ')
          ..write('startDate: $startDate, ')
          ..write('endDate: $endDate, ')
          ..write('startingBalanceKobo: $startingBalanceKobo, ')
          ..write('plannedSavingsKobo: $plannedSavingsKobo, ')
          ..write('isActive: $isActive')
          ..write(')'))
        .toString();
  }
}

class $BudgetLinesTable extends BudgetLines
    with TableInfo<$BudgetLinesTable, BudgetLine> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $BudgetLinesTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
    'id',
    aliasedName,
    false,
    hasAutoIncrement: true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'PRIMARY KEY AUTOINCREMENT',
    ),
  );
  static const VerificationMeta _cycleIdMeta = const VerificationMeta(
    'cycleId',
  );
  @override
  late final GeneratedColumn<int> cycleId = GeneratedColumn<int>(
    'cycle_id',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'REFERENCES budget_cycles (id) ON DELETE CASCADE',
    ),
  );
  static const VerificationMeta _categoryIdMeta = const VerificationMeta(
    'categoryId',
  );
  @override
  late final GeneratedColumn<int> categoryId = GeneratedColumn<int>(
    'category_id',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'REFERENCES categories (id) ON DELETE CASCADE',
    ),
  );
  static const VerificationMeta _plannedKoboMeta = const VerificationMeta(
    'plannedKobo',
  );
  @override
  late final GeneratedColumn<int> plannedKobo = GeneratedColumn<int>(
    'planned_kobo',
    aliasedName,
    false,
    check: () => ComparableExpr(plannedKobo).isBiggerOrEqualValue(0),
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _alerted80Meta = const VerificationMeta(
    'alerted80',
  );
  @override
  late final GeneratedColumn<bool> alerted80 = GeneratedColumn<bool>(
    'alerted80',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("alerted80" IN (0, 1))',
    ),
    defaultValue: const Constant(false),
  );
  static const VerificationMeta _alerted100Meta = const VerificationMeta(
    'alerted100',
  );
  @override
  late final GeneratedColumn<bool> alerted100 = GeneratedColumn<bool>(
    'alerted100',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("alerted100" IN (0, 1))',
    ),
    defaultValue: const Constant(false),
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    cycleId,
    categoryId,
    plannedKobo,
    alerted80,
    alerted100,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'budget_lines';
  @override
  VerificationContext validateIntegrity(
    Insertable<BudgetLine> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('cycle_id')) {
      context.handle(
        _cycleIdMeta,
        cycleId.isAcceptableOrUnknown(data['cycle_id']!, _cycleIdMeta),
      );
    } else if (isInserting) {
      context.missing(_cycleIdMeta);
    }
    if (data.containsKey('category_id')) {
      context.handle(
        _categoryIdMeta,
        categoryId.isAcceptableOrUnknown(data['category_id']!, _categoryIdMeta),
      );
    } else if (isInserting) {
      context.missing(_categoryIdMeta);
    }
    if (data.containsKey('planned_kobo')) {
      context.handle(
        _plannedKoboMeta,
        plannedKobo.isAcceptableOrUnknown(
          data['planned_kobo']!,
          _plannedKoboMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_plannedKoboMeta);
    }
    if (data.containsKey('alerted80')) {
      context.handle(
        _alerted80Meta,
        alerted80.isAcceptableOrUnknown(data['alerted80']!, _alerted80Meta),
      );
    }
    if (data.containsKey('alerted100')) {
      context.handle(
        _alerted100Meta,
        alerted100.isAcceptableOrUnknown(data['alerted100']!, _alerted100Meta),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  List<Set<GeneratedColumn>> get uniqueKeys => [
    {cycleId, categoryId},
  ];
  @override
  BudgetLine map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return BudgetLine(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}id'],
      )!,
      cycleId: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}cycle_id'],
      )!,
      categoryId: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}category_id'],
      )!,
      plannedKobo: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}planned_kobo'],
      )!,
      alerted80: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}alerted80'],
      )!,
      alerted100: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}alerted100'],
      )!,
    );
  }

  @override
  $BudgetLinesTable createAlias(String alias) {
    return $BudgetLinesTable(attachedDatabase, alias);
  }
}

class BudgetLine extends DataClass implements Insertable<BudgetLine> {
  final int id;
  final int cycleId;
  final int categoryId;
  final int plannedKobo;
  final bool alerted80;
  final bool alerted100;
  const BudgetLine({
    required this.id,
    required this.cycleId,
    required this.categoryId,
    required this.plannedKobo,
    required this.alerted80,
    required this.alerted100,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['cycle_id'] = Variable<int>(cycleId);
    map['category_id'] = Variable<int>(categoryId);
    map['planned_kobo'] = Variable<int>(plannedKobo);
    map['alerted80'] = Variable<bool>(alerted80);
    map['alerted100'] = Variable<bool>(alerted100);
    return map;
  }

  BudgetLinesCompanion toCompanion(bool nullToAbsent) {
    return BudgetLinesCompanion(
      id: Value(id),
      cycleId: Value(cycleId),
      categoryId: Value(categoryId),
      plannedKobo: Value(plannedKobo),
      alerted80: Value(alerted80),
      alerted100: Value(alerted100),
    );
  }

  factory BudgetLine.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return BudgetLine(
      id: serializer.fromJson<int>(json['id']),
      cycleId: serializer.fromJson<int>(json['cycleId']),
      categoryId: serializer.fromJson<int>(json['categoryId']),
      plannedKobo: serializer.fromJson<int>(json['plannedKobo']),
      alerted80: serializer.fromJson<bool>(json['alerted80']),
      alerted100: serializer.fromJson<bool>(json['alerted100']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'cycleId': serializer.toJson<int>(cycleId),
      'categoryId': serializer.toJson<int>(categoryId),
      'plannedKobo': serializer.toJson<int>(plannedKobo),
      'alerted80': serializer.toJson<bool>(alerted80),
      'alerted100': serializer.toJson<bool>(alerted100),
    };
  }

  BudgetLine copyWith({
    int? id,
    int? cycleId,
    int? categoryId,
    int? plannedKobo,
    bool? alerted80,
    bool? alerted100,
  }) => BudgetLine(
    id: id ?? this.id,
    cycleId: cycleId ?? this.cycleId,
    categoryId: categoryId ?? this.categoryId,
    plannedKobo: plannedKobo ?? this.plannedKobo,
    alerted80: alerted80 ?? this.alerted80,
    alerted100: alerted100 ?? this.alerted100,
  );
  BudgetLine copyWithCompanion(BudgetLinesCompanion data) {
    return BudgetLine(
      id: data.id.present ? data.id.value : this.id,
      cycleId: data.cycleId.present ? data.cycleId.value : this.cycleId,
      categoryId: data.categoryId.present
          ? data.categoryId.value
          : this.categoryId,
      plannedKobo: data.plannedKobo.present
          ? data.plannedKobo.value
          : this.plannedKobo,
      alerted80: data.alerted80.present ? data.alerted80.value : this.alerted80,
      alerted100: data.alerted100.present
          ? data.alerted100.value
          : this.alerted100,
    );
  }

  @override
  String toString() {
    return (StringBuffer('BudgetLine(')
          ..write('id: $id, ')
          ..write('cycleId: $cycleId, ')
          ..write('categoryId: $categoryId, ')
          ..write('plannedKobo: $plannedKobo, ')
          ..write('alerted80: $alerted80, ')
          ..write('alerted100: $alerted100')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode =>
      Object.hash(id, cycleId, categoryId, plannedKobo, alerted80, alerted100);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is BudgetLine &&
          other.id == this.id &&
          other.cycleId == this.cycleId &&
          other.categoryId == this.categoryId &&
          other.plannedKobo == this.plannedKobo &&
          other.alerted80 == this.alerted80 &&
          other.alerted100 == this.alerted100);
}

class BudgetLinesCompanion extends UpdateCompanion<BudgetLine> {
  final Value<int> id;
  final Value<int> cycleId;
  final Value<int> categoryId;
  final Value<int> plannedKobo;
  final Value<bool> alerted80;
  final Value<bool> alerted100;
  const BudgetLinesCompanion({
    this.id = const Value.absent(),
    this.cycleId = const Value.absent(),
    this.categoryId = const Value.absent(),
    this.plannedKobo = const Value.absent(),
    this.alerted80 = const Value.absent(),
    this.alerted100 = const Value.absent(),
  });
  BudgetLinesCompanion.insert({
    this.id = const Value.absent(),
    required int cycleId,
    required int categoryId,
    required int plannedKobo,
    this.alerted80 = const Value.absent(),
    this.alerted100 = const Value.absent(),
  }) : cycleId = Value(cycleId),
       categoryId = Value(categoryId),
       plannedKobo = Value(plannedKobo);
  static Insertable<BudgetLine> custom({
    Expression<int>? id,
    Expression<int>? cycleId,
    Expression<int>? categoryId,
    Expression<int>? plannedKobo,
    Expression<bool>? alerted80,
    Expression<bool>? alerted100,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (cycleId != null) 'cycle_id': cycleId,
      if (categoryId != null) 'category_id': categoryId,
      if (plannedKobo != null) 'planned_kobo': plannedKobo,
      if (alerted80 != null) 'alerted80': alerted80,
      if (alerted100 != null) 'alerted100': alerted100,
    });
  }

  BudgetLinesCompanion copyWith({
    Value<int>? id,
    Value<int>? cycleId,
    Value<int>? categoryId,
    Value<int>? plannedKobo,
    Value<bool>? alerted80,
    Value<bool>? alerted100,
  }) {
    return BudgetLinesCompanion(
      id: id ?? this.id,
      cycleId: cycleId ?? this.cycleId,
      categoryId: categoryId ?? this.categoryId,
      plannedKobo: plannedKobo ?? this.plannedKobo,
      alerted80: alerted80 ?? this.alerted80,
      alerted100: alerted100 ?? this.alerted100,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (cycleId.present) {
      map['cycle_id'] = Variable<int>(cycleId.value);
    }
    if (categoryId.present) {
      map['category_id'] = Variable<int>(categoryId.value);
    }
    if (plannedKobo.present) {
      map['planned_kobo'] = Variable<int>(plannedKobo.value);
    }
    if (alerted80.present) {
      map['alerted80'] = Variable<bool>(alerted80.value);
    }
    if (alerted100.present) {
      map['alerted100'] = Variable<bool>(alerted100.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('BudgetLinesCompanion(')
          ..write('id: $id, ')
          ..write('cycleId: $cycleId, ')
          ..write('categoryId: $categoryId, ')
          ..write('plannedKobo: $plannedKobo, ')
          ..write('alerted80: $alerted80, ')
          ..write('alerted100: $alerted100')
          ..write(')'))
        .toString();
  }
}

class $TransactionsTable extends Transactions
    with TableInfo<$TransactionsTable, Txn> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $TransactionsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
    'id',
    aliasedName,
    false,
    hasAutoIncrement: true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'PRIMARY KEY AUTOINCREMENT',
    ),
  );
  @override
  late final GeneratedColumnWithTypeConverter<TxType, String> type =
      GeneratedColumn<String>(
        'type',
        aliasedName,
        false,
        type: DriftSqlType.string,
        requiredDuringInsert: true,
      ).withConverter<TxType>($TransactionsTable.$convertertype);
  static const VerificationMeta _amountKoboMeta = const VerificationMeta(
    'amountKobo',
  );
  @override
  late final GeneratedColumn<int> amountKobo = GeneratedColumn<int>(
    'amount_kobo',
    aliasedName,
    false,
    check: () => ComparableExpr(amountKobo).isBiggerThanValue(0),
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _categoryIdMeta = const VerificationMeta(
    'categoryId',
  );
  @override
  late final GeneratedColumn<int> categoryId = GeneratedColumn<int>(
    'category_id',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'REFERENCES categories (id)',
    ),
  );
  static const VerificationMeta _noteMeta = const VerificationMeta('note');
  @override
  late final GeneratedColumn<String> note = GeneratedColumn<String>(
    'note',
    aliasedName,
    true,
    additionalChecks: GeneratedColumn.checkTextLength(maxTextLength: 200),
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _occurredAtMeta = const VerificationMeta(
    'occurredAt',
  );
  @override
  late final GeneratedColumn<DateTime> occurredAt = GeneratedColumn<DateTime>(
    'occurred_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _createdAtMeta = const VerificationMeta(
    'createdAt',
  );
  @override
  late final GeneratedColumn<DateTime> createdAt = GeneratedColumn<DateTime>(
    'created_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: false,
    defaultValue: currentDateAndTime,
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    type,
    amountKobo,
    categoryId,
    note,
    occurredAt,
    createdAt,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'transactions';
  @override
  VerificationContext validateIntegrity(
    Insertable<Txn> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('amount_kobo')) {
      context.handle(
        _amountKoboMeta,
        amountKobo.isAcceptableOrUnknown(data['amount_kobo']!, _amountKoboMeta),
      );
    } else if (isInserting) {
      context.missing(_amountKoboMeta);
    }
    if (data.containsKey('category_id')) {
      context.handle(
        _categoryIdMeta,
        categoryId.isAcceptableOrUnknown(data['category_id']!, _categoryIdMeta),
      );
    } else if (isInserting) {
      context.missing(_categoryIdMeta);
    }
    if (data.containsKey('note')) {
      context.handle(
        _noteMeta,
        note.isAcceptableOrUnknown(data['note']!, _noteMeta),
      );
    }
    if (data.containsKey('occurred_at')) {
      context.handle(
        _occurredAtMeta,
        occurredAt.isAcceptableOrUnknown(data['occurred_at']!, _occurredAtMeta),
      );
    } else if (isInserting) {
      context.missing(_occurredAtMeta);
    }
    if (data.containsKey('created_at')) {
      context.handle(
        _createdAtMeta,
        createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  Txn map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return Txn(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}id'],
      )!,
      type: $TransactionsTable.$convertertype.fromSql(
        attachedDatabase.typeMapping.read(
          DriftSqlType.string,
          data['${effectivePrefix}type'],
        )!,
      ),
      amountKobo: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}amount_kobo'],
      )!,
      categoryId: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}category_id'],
      )!,
      note: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}note'],
      ),
      occurredAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}occurred_at'],
      )!,
      createdAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}created_at'],
      )!,
    );
  }

  @override
  $TransactionsTable createAlias(String alias) {
    return $TransactionsTable(attachedDatabase, alias);
  }

  static JsonTypeConverter2<TxType, String, String> $convertertype =
      const EnumNameConverter<TxType>(TxType.values);
}

class Txn extends DataClass implements Insertable<Txn> {
  final int id;
  final TxType type;
  final int amountKobo;
  final int categoryId;
  final String? note;
  final DateTime occurredAt;
  final DateTime createdAt;
  const Txn({
    required this.id,
    required this.type,
    required this.amountKobo,
    required this.categoryId,
    this.note,
    required this.occurredAt,
    required this.createdAt,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    {
      map['type'] = Variable<String>(
        $TransactionsTable.$convertertype.toSql(type),
      );
    }
    map['amount_kobo'] = Variable<int>(amountKobo);
    map['category_id'] = Variable<int>(categoryId);
    if (!nullToAbsent || note != null) {
      map['note'] = Variable<String>(note);
    }
    map['occurred_at'] = Variable<DateTime>(occurredAt);
    map['created_at'] = Variable<DateTime>(createdAt);
    return map;
  }

  TransactionsCompanion toCompanion(bool nullToAbsent) {
    return TransactionsCompanion(
      id: Value(id),
      type: Value(type),
      amountKobo: Value(amountKobo),
      categoryId: Value(categoryId),
      note: note == null && nullToAbsent ? const Value.absent() : Value(note),
      occurredAt: Value(occurredAt),
      createdAt: Value(createdAt),
    );
  }

  factory Txn.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return Txn(
      id: serializer.fromJson<int>(json['id']),
      type: $TransactionsTable.$convertertype.fromJson(
        serializer.fromJson<String>(json['type']),
      ),
      amountKobo: serializer.fromJson<int>(json['amountKobo']),
      categoryId: serializer.fromJson<int>(json['categoryId']),
      note: serializer.fromJson<String?>(json['note']),
      occurredAt: serializer.fromJson<DateTime>(json['occurredAt']),
      createdAt: serializer.fromJson<DateTime>(json['createdAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'type': serializer.toJson<String>(
        $TransactionsTable.$convertertype.toJson(type),
      ),
      'amountKobo': serializer.toJson<int>(amountKobo),
      'categoryId': serializer.toJson<int>(categoryId),
      'note': serializer.toJson<String?>(note),
      'occurredAt': serializer.toJson<DateTime>(occurredAt),
      'createdAt': serializer.toJson<DateTime>(createdAt),
    };
  }

  Txn copyWith({
    int? id,
    TxType? type,
    int? amountKobo,
    int? categoryId,
    Value<String?> note = const Value.absent(),
    DateTime? occurredAt,
    DateTime? createdAt,
  }) => Txn(
    id: id ?? this.id,
    type: type ?? this.type,
    amountKobo: amountKobo ?? this.amountKobo,
    categoryId: categoryId ?? this.categoryId,
    note: note.present ? note.value : this.note,
    occurredAt: occurredAt ?? this.occurredAt,
    createdAt: createdAt ?? this.createdAt,
  );
  Txn copyWithCompanion(TransactionsCompanion data) {
    return Txn(
      id: data.id.present ? data.id.value : this.id,
      type: data.type.present ? data.type.value : this.type,
      amountKobo: data.amountKobo.present
          ? data.amountKobo.value
          : this.amountKobo,
      categoryId: data.categoryId.present
          ? data.categoryId.value
          : this.categoryId,
      note: data.note.present ? data.note.value : this.note,
      occurredAt: data.occurredAt.present
          ? data.occurredAt.value
          : this.occurredAt,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('Txn(')
          ..write('id: $id, ')
          ..write('type: $type, ')
          ..write('amountKobo: $amountKobo, ')
          ..write('categoryId: $categoryId, ')
          ..write('note: $note, ')
          ..write('occurredAt: $occurredAt, ')
          ..write('createdAt: $createdAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    type,
    amountKobo,
    categoryId,
    note,
    occurredAt,
    createdAt,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is Txn &&
          other.id == this.id &&
          other.type == this.type &&
          other.amountKobo == this.amountKobo &&
          other.categoryId == this.categoryId &&
          other.note == this.note &&
          other.occurredAt == this.occurredAt &&
          other.createdAt == this.createdAt);
}

class TransactionsCompanion extends UpdateCompanion<Txn> {
  final Value<int> id;
  final Value<TxType> type;
  final Value<int> amountKobo;
  final Value<int> categoryId;
  final Value<String?> note;
  final Value<DateTime> occurredAt;
  final Value<DateTime> createdAt;
  const TransactionsCompanion({
    this.id = const Value.absent(),
    this.type = const Value.absent(),
    this.amountKobo = const Value.absent(),
    this.categoryId = const Value.absent(),
    this.note = const Value.absent(),
    this.occurredAt = const Value.absent(),
    this.createdAt = const Value.absent(),
  });
  TransactionsCompanion.insert({
    this.id = const Value.absent(),
    required TxType type,
    required int amountKobo,
    required int categoryId,
    this.note = const Value.absent(),
    required DateTime occurredAt,
    this.createdAt = const Value.absent(),
  }) : type = Value(type),
       amountKobo = Value(amountKobo),
       categoryId = Value(categoryId),
       occurredAt = Value(occurredAt);
  static Insertable<Txn> custom({
    Expression<int>? id,
    Expression<String>? type,
    Expression<int>? amountKobo,
    Expression<int>? categoryId,
    Expression<String>? note,
    Expression<DateTime>? occurredAt,
    Expression<DateTime>? createdAt,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (type != null) 'type': type,
      if (amountKobo != null) 'amount_kobo': amountKobo,
      if (categoryId != null) 'category_id': categoryId,
      if (note != null) 'note': note,
      if (occurredAt != null) 'occurred_at': occurredAt,
      if (createdAt != null) 'created_at': createdAt,
    });
  }

  TransactionsCompanion copyWith({
    Value<int>? id,
    Value<TxType>? type,
    Value<int>? amountKobo,
    Value<int>? categoryId,
    Value<String?>? note,
    Value<DateTime>? occurredAt,
    Value<DateTime>? createdAt,
  }) {
    return TransactionsCompanion(
      id: id ?? this.id,
      type: type ?? this.type,
      amountKobo: amountKobo ?? this.amountKobo,
      categoryId: categoryId ?? this.categoryId,
      note: note ?? this.note,
      occurredAt: occurredAt ?? this.occurredAt,
      createdAt: createdAt ?? this.createdAt,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (type.present) {
      map['type'] = Variable<String>(
        $TransactionsTable.$convertertype.toSql(type.value),
      );
    }
    if (amountKobo.present) {
      map['amount_kobo'] = Variable<int>(amountKobo.value);
    }
    if (categoryId.present) {
      map['category_id'] = Variable<int>(categoryId.value);
    }
    if (note.present) {
      map['note'] = Variable<String>(note.value);
    }
    if (occurredAt.present) {
      map['occurred_at'] = Variable<DateTime>(occurredAt.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<DateTime>(createdAt.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('TransactionsCompanion(')
          ..write('id: $id, ')
          ..write('type: $type, ')
          ..write('amountKobo: $amountKobo, ')
          ..write('categoryId: $categoryId, ')
          ..write('note: $note, ')
          ..write('occurredAt: $occurredAt, ')
          ..write('createdAt: $createdAt')
          ..write(')'))
        .toString();
  }
}

class $SavingsGoalsTable extends SavingsGoals
    with TableInfo<$SavingsGoalsTable, SavingsGoal> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $SavingsGoalsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
    'id',
    aliasedName,
    false,
    hasAutoIncrement: true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'PRIMARY KEY AUTOINCREMENT',
    ),
  );
  static const VerificationMeta _nameMeta = const VerificationMeta('name');
  @override
  late final GeneratedColumn<String> name = GeneratedColumn<String>(
    'name',
    aliasedName,
    false,
    additionalChecks: GeneratedColumn.checkTextLength(
      minTextLength: 1,
      maxTextLength: 40,
    ),
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _targetKoboMeta = const VerificationMeta(
    'targetKobo',
  );
  @override
  late final GeneratedColumn<int> targetKobo = GeneratedColumn<int>(
    'target_kobo',
    aliasedName,
    false,
    check: () => ComparableExpr(targetKobo).isBiggerThanValue(0),
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _deadlineMeta = const VerificationMeta(
    'deadline',
  );
  @override
  late final GeneratedColumn<DateTime> deadline = GeneratedColumn<DateTime>(
    'deadline',
    aliasedName,
    true,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _createdAtMeta = const VerificationMeta(
    'createdAt',
  );
  @override
  late final GeneratedColumn<DateTime> createdAt = GeneratedColumn<DateTime>(
    'created_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: false,
    defaultValue: currentDateAndTime,
  );
  static const VerificationMeta _archivedMeta = const VerificationMeta(
    'archived',
  );
  @override
  late final GeneratedColumn<bool> archived = GeneratedColumn<bool>(
    'archived',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("archived" IN (0, 1))',
    ),
    defaultValue: const Constant(false),
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    name,
    targetKobo,
    deadline,
    createdAt,
    archived,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'savings_goals';
  @override
  VerificationContext validateIntegrity(
    Insertable<SavingsGoal> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('name')) {
      context.handle(
        _nameMeta,
        name.isAcceptableOrUnknown(data['name']!, _nameMeta),
      );
    } else if (isInserting) {
      context.missing(_nameMeta);
    }
    if (data.containsKey('target_kobo')) {
      context.handle(
        _targetKoboMeta,
        targetKobo.isAcceptableOrUnknown(data['target_kobo']!, _targetKoboMeta),
      );
    } else if (isInserting) {
      context.missing(_targetKoboMeta);
    }
    if (data.containsKey('deadline')) {
      context.handle(
        _deadlineMeta,
        deadline.isAcceptableOrUnknown(data['deadline']!, _deadlineMeta),
      );
    }
    if (data.containsKey('created_at')) {
      context.handle(
        _createdAtMeta,
        createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta),
      );
    }
    if (data.containsKey('archived')) {
      context.handle(
        _archivedMeta,
        archived.isAcceptableOrUnknown(data['archived']!, _archivedMeta),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  SavingsGoal map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return SavingsGoal(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}id'],
      )!,
      name: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}name'],
      )!,
      targetKobo: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}target_kobo'],
      )!,
      deadline: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}deadline'],
      ),
      createdAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}created_at'],
      )!,
      archived: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}archived'],
      )!,
    );
  }

  @override
  $SavingsGoalsTable createAlias(String alias) {
    return $SavingsGoalsTable(attachedDatabase, alias);
  }
}

class SavingsGoal extends DataClass implements Insertable<SavingsGoal> {
  final int id;
  final String name;
  final int targetKobo;
  final DateTime? deadline;
  final DateTime createdAt;
  final bool archived;
  const SavingsGoal({
    required this.id,
    required this.name,
    required this.targetKobo,
    this.deadline,
    required this.createdAt,
    required this.archived,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['name'] = Variable<String>(name);
    map['target_kobo'] = Variable<int>(targetKobo);
    if (!nullToAbsent || deadline != null) {
      map['deadline'] = Variable<DateTime>(deadline);
    }
    map['created_at'] = Variable<DateTime>(createdAt);
    map['archived'] = Variable<bool>(archived);
    return map;
  }

  SavingsGoalsCompanion toCompanion(bool nullToAbsent) {
    return SavingsGoalsCompanion(
      id: Value(id),
      name: Value(name),
      targetKobo: Value(targetKobo),
      deadline: deadline == null && nullToAbsent
          ? const Value.absent()
          : Value(deadline),
      createdAt: Value(createdAt),
      archived: Value(archived),
    );
  }

  factory SavingsGoal.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return SavingsGoal(
      id: serializer.fromJson<int>(json['id']),
      name: serializer.fromJson<String>(json['name']),
      targetKobo: serializer.fromJson<int>(json['targetKobo']),
      deadline: serializer.fromJson<DateTime?>(json['deadline']),
      createdAt: serializer.fromJson<DateTime>(json['createdAt']),
      archived: serializer.fromJson<bool>(json['archived']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'name': serializer.toJson<String>(name),
      'targetKobo': serializer.toJson<int>(targetKobo),
      'deadline': serializer.toJson<DateTime?>(deadline),
      'createdAt': serializer.toJson<DateTime>(createdAt),
      'archived': serializer.toJson<bool>(archived),
    };
  }

  SavingsGoal copyWith({
    int? id,
    String? name,
    int? targetKobo,
    Value<DateTime?> deadline = const Value.absent(),
    DateTime? createdAt,
    bool? archived,
  }) => SavingsGoal(
    id: id ?? this.id,
    name: name ?? this.name,
    targetKobo: targetKobo ?? this.targetKobo,
    deadline: deadline.present ? deadline.value : this.deadline,
    createdAt: createdAt ?? this.createdAt,
    archived: archived ?? this.archived,
  );
  SavingsGoal copyWithCompanion(SavingsGoalsCompanion data) {
    return SavingsGoal(
      id: data.id.present ? data.id.value : this.id,
      name: data.name.present ? data.name.value : this.name,
      targetKobo: data.targetKobo.present
          ? data.targetKobo.value
          : this.targetKobo,
      deadline: data.deadline.present ? data.deadline.value : this.deadline,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
      archived: data.archived.present ? data.archived.value : this.archived,
    );
  }

  @override
  String toString() {
    return (StringBuffer('SavingsGoal(')
          ..write('id: $id, ')
          ..write('name: $name, ')
          ..write('targetKobo: $targetKobo, ')
          ..write('deadline: $deadline, ')
          ..write('createdAt: $createdAt, ')
          ..write('archived: $archived')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode =>
      Object.hash(id, name, targetKobo, deadline, createdAt, archived);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is SavingsGoal &&
          other.id == this.id &&
          other.name == this.name &&
          other.targetKobo == this.targetKobo &&
          other.deadline == this.deadline &&
          other.createdAt == this.createdAt &&
          other.archived == this.archived);
}

class SavingsGoalsCompanion extends UpdateCompanion<SavingsGoal> {
  final Value<int> id;
  final Value<String> name;
  final Value<int> targetKobo;
  final Value<DateTime?> deadline;
  final Value<DateTime> createdAt;
  final Value<bool> archived;
  const SavingsGoalsCompanion({
    this.id = const Value.absent(),
    this.name = const Value.absent(),
    this.targetKobo = const Value.absent(),
    this.deadline = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.archived = const Value.absent(),
  });
  SavingsGoalsCompanion.insert({
    this.id = const Value.absent(),
    required String name,
    required int targetKobo,
    this.deadline = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.archived = const Value.absent(),
  }) : name = Value(name),
       targetKobo = Value(targetKobo);
  static Insertable<SavingsGoal> custom({
    Expression<int>? id,
    Expression<String>? name,
    Expression<int>? targetKobo,
    Expression<DateTime>? deadline,
    Expression<DateTime>? createdAt,
    Expression<bool>? archived,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (name != null) 'name': name,
      if (targetKobo != null) 'target_kobo': targetKobo,
      if (deadline != null) 'deadline': deadline,
      if (createdAt != null) 'created_at': createdAt,
      if (archived != null) 'archived': archived,
    });
  }

  SavingsGoalsCompanion copyWith({
    Value<int>? id,
    Value<String>? name,
    Value<int>? targetKobo,
    Value<DateTime?>? deadline,
    Value<DateTime>? createdAt,
    Value<bool>? archived,
  }) {
    return SavingsGoalsCompanion(
      id: id ?? this.id,
      name: name ?? this.name,
      targetKobo: targetKobo ?? this.targetKobo,
      deadline: deadline ?? this.deadline,
      createdAt: createdAt ?? this.createdAt,
      archived: archived ?? this.archived,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (name.present) {
      map['name'] = Variable<String>(name.value);
    }
    if (targetKobo.present) {
      map['target_kobo'] = Variable<int>(targetKobo.value);
    }
    if (deadline.present) {
      map['deadline'] = Variable<DateTime>(deadline.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<DateTime>(createdAt.value);
    }
    if (archived.present) {
      map['archived'] = Variable<bool>(archived.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('SavingsGoalsCompanion(')
          ..write('id: $id, ')
          ..write('name: $name, ')
          ..write('targetKobo: $targetKobo, ')
          ..write('deadline: $deadline, ')
          ..write('createdAt: $createdAt, ')
          ..write('archived: $archived')
          ..write(')'))
        .toString();
  }
}

class $GoalContributionsTable extends GoalContributions
    with TableInfo<$GoalContributionsTable, GoalContribution> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $GoalContributionsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
    'id',
    aliasedName,
    false,
    hasAutoIncrement: true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'PRIMARY KEY AUTOINCREMENT',
    ),
  );
  static const VerificationMeta _goalIdMeta = const VerificationMeta('goalId');
  @override
  late final GeneratedColumn<int> goalId = GeneratedColumn<int>(
    'goal_id',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'REFERENCES savings_goals (id) ON DELETE CASCADE',
    ),
  );
  static const VerificationMeta _amountKoboMeta = const VerificationMeta(
    'amountKobo',
  );
  @override
  late final GeneratedColumn<int> amountKobo = GeneratedColumn<int>(
    'amount_kobo',
    aliasedName,
    false,
    check: () => BooleanExpressionOperators(amountKobo.equals(0)).not(),
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _noteMeta = const VerificationMeta('note');
  @override
  late final GeneratedColumn<String> note = GeneratedColumn<String>(
    'note',
    aliasedName,
    true,
    additionalChecks: GeneratedColumn.checkTextLength(maxTextLength: 200),
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _createdAtMeta = const VerificationMeta(
    'createdAt',
  );
  @override
  late final GeneratedColumn<DateTime> createdAt = GeneratedColumn<DateTime>(
    'created_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: false,
    defaultValue: currentDateAndTime,
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    goalId,
    amountKobo,
    note,
    createdAt,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'goal_contributions';
  @override
  VerificationContext validateIntegrity(
    Insertable<GoalContribution> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('goal_id')) {
      context.handle(
        _goalIdMeta,
        goalId.isAcceptableOrUnknown(data['goal_id']!, _goalIdMeta),
      );
    } else if (isInserting) {
      context.missing(_goalIdMeta);
    }
    if (data.containsKey('amount_kobo')) {
      context.handle(
        _amountKoboMeta,
        amountKobo.isAcceptableOrUnknown(data['amount_kobo']!, _amountKoboMeta),
      );
    } else if (isInserting) {
      context.missing(_amountKoboMeta);
    }
    if (data.containsKey('note')) {
      context.handle(
        _noteMeta,
        note.isAcceptableOrUnknown(data['note']!, _noteMeta),
      );
    }
    if (data.containsKey('created_at')) {
      context.handle(
        _createdAtMeta,
        createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  GoalContribution map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return GoalContribution(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}id'],
      )!,
      goalId: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}goal_id'],
      )!,
      amountKobo: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}amount_kobo'],
      )!,
      note: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}note'],
      ),
      createdAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}created_at'],
      )!,
    );
  }

  @override
  $GoalContributionsTable createAlias(String alias) {
    return $GoalContributionsTable(attachedDatabase, alias);
  }
}

class GoalContribution extends DataClass
    implements Insertable<GoalContribution> {
  final int id;
  final int goalId;
  final int amountKobo;
  final String? note;
  final DateTime createdAt;
  const GoalContribution({
    required this.id,
    required this.goalId,
    required this.amountKobo,
    this.note,
    required this.createdAt,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['goal_id'] = Variable<int>(goalId);
    map['amount_kobo'] = Variable<int>(amountKobo);
    if (!nullToAbsent || note != null) {
      map['note'] = Variable<String>(note);
    }
    map['created_at'] = Variable<DateTime>(createdAt);
    return map;
  }

  GoalContributionsCompanion toCompanion(bool nullToAbsent) {
    return GoalContributionsCompanion(
      id: Value(id),
      goalId: Value(goalId),
      amountKobo: Value(amountKobo),
      note: note == null && nullToAbsent ? const Value.absent() : Value(note),
      createdAt: Value(createdAt),
    );
  }

  factory GoalContribution.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return GoalContribution(
      id: serializer.fromJson<int>(json['id']),
      goalId: serializer.fromJson<int>(json['goalId']),
      amountKobo: serializer.fromJson<int>(json['amountKobo']),
      note: serializer.fromJson<String?>(json['note']),
      createdAt: serializer.fromJson<DateTime>(json['createdAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'goalId': serializer.toJson<int>(goalId),
      'amountKobo': serializer.toJson<int>(amountKobo),
      'note': serializer.toJson<String?>(note),
      'createdAt': serializer.toJson<DateTime>(createdAt),
    };
  }

  GoalContribution copyWith({
    int? id,
    int? goalId,
    int? amountKobo,
    Value<String?> note = const Value.absent(),
    DateTime? createdAt,
  }) => GoalContribution(
    id: id ?? this.id,
    goalId: goalId ?? this.goalId,
    amountKobo: amountKobo ?? this.amountKobo,
    note: note.present ? note.value : this.note,
    createdAt: createdAt ?? this.createdAt,
  );
  GoalContribution copyWithCompanion(GoalContributionsCompanion data) {
    return GoalContribution(
      id: data.id.present ? data.id.value : this.id,
      goalId: data.goalId.present ? data.goalId.value : this.goalId,
      amountKobo: data.amountKobo.present
          ? data.amountKobo.value
          : this.amountKobo,
      note: data.note.present ? data.note.value : this.note,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('GoalContribution(')
          ..write('id: $id, ')
          ..write('goalId: $goalId, ')
          ..write('amountKobo: $amountKobo, ')
          ..write('note: $note, ')
          ..write('createdAt: $createdAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(id, goalId, amountKobo, note, createdAt);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is GoalContribution &&
          other.id == this.id &&
          other.goalId == this.goalId &&
          other.amountKobo == this.amountKobo &&
          other.note == this.note &&
          other.createdAt == this.createdAt);
}

class GoalContributionsCompanion extends UpdateCompanion<GoalContribution> {
  final Value<int> id;
  final Value<int> goalId;
  final Value<int> amountKobo;
  final Value<String?> note;
  final Value<DateTime> createdAt;
  const GoalContributionsCompanion({
    this.id = const Value.absent(),
    this.goalId = const Value.absent(),
    this.amountKobo = const Value.absent(),
    this.note = const Value.absent(),
    this.createdAt = const Value.absent(),
  });
  GoalContributionsCompanion.insert({
    this.id = const Value.absent(),
    required int goalId,
    required int amountKobo,
    this.note = const Value.absent(),
    this.createdAt = const Value.absent(),
  }) : goalId = Value(goalId),
       amountKobo = Value(amountKobo);
  static Insertable<GoalContribution> custom({
    Expression<int>? id,
    Expression<int>? goalId,
    Expression<int>? amountKobo,
    Expression<String>? note,
    Expression<DateTime>? createdAt,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (goalId != null) 'goal_id': goalId,
      if (amountKobo != null) 'amount_kobo': amountKobo,
      if (note != null) 'note': note,
      if (createdAt != null) 'created_at': createdAt,
    });
  }

  GoalContributionsCompanion copyWith({
    Value<int>? id,
    Value<int>? goalId,
    Value<int>? amountKobo,
    Value<String?>? note,
    Value<DateTime>? createdAt,
  }) {
    return GoalContributionsCompanion(
      id: id ?? this.id,
      goalId: goalId ?? this.goalId,
      amountKobo: amountKobo ?? this.amountKobo,
      note: note ?? this.note,
      createdAt: createdAt ?? this.createdAt,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (goalId.present) {
      map['goal_id'] = Variable<int>(goalId.value);
    }
    if (amountKobo.present) {
      map['amount_kobo'] = Variable<int>(amountKobo.value);
    }
    if (note.present) {
      map['note'] = Variable<String>(note.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<DateTime>(createdAt.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('GoalContributionsCompanion(')
          ..write('id: $id, ')
          ..write('goalId: $goalId, ')
          ..write('amountKobo: $amountKobo, ')
          ..write('note: $note, ')
          ..write('createdAt: $createdAt')
          ..write(')'))
        .toString();
  }
}

abstract class _$AppDatabase extends GeneratedDatabase {
  _$AppDatabase(QueryExecutor e) : super(e);
  $AppDatabaseManager get managers => $AppDatabaseManager(this);
  late final $AppSettingsTable appSettings = $AppSettingsTable(this);
  late final $CategoriesTable categories = $CategoriesTable(this);
  late final $BudgetCyclesTable budgetCycles = $BudgetCyclesTable(this);
  late final $BudgetLinesTable budgetLines = $BudgetLinesTable(this);
  late final $TransactionsTable transactions = $TransactionsTable(this);
  late final $SavingsGoalsTable savingsGoals = $SavingsGoalsTable(this);
  late final $GoalContributionsTable goalContributions =
      $GoalContributionsTable(this);
  late final Index idxTxnOccurredAt = Index(
    'idx_txn_occurred_at',
    'CREATE INDEX idx_txn_occurred_at ON transactions (occurred_at)',
  );
  @override
  Iterable<TableInfo<Table, Object?>> get allTables =>
      allSchemaEntities.whereType<TableInfo<Table, Object?>>();
  @override
  List<DatabaseSchemaEntity> get allSchemaEntities => [
    appSettings,
    categories,
    budgetCycles,
    budgetLines,
    transactions,
    savingsGoals,
    goalContributions,
    idxTxnOccurredAt,
  ];
  @override
  StreamQueryUpdateRules get streamUpdateRules => const StreamQueryUpdateRules([
    WritePropagation(
      on: TableUpdateQuery.onTableName(
        'budget_cycles',
        limitUpdateKind: UpdateKind.delete,
      ),
      result: [TableUpdate('budget_lines', kind: UpdateKind.delete)],
    ),
    WritePropagation(
      on: TableUpdateQuery.onTableName(
        'categories',
        limitUpdateKind: UpdateKind.delete,
      ),
      result: [TableUpdate('budget_lines', kind: UpdateKind.delete)],
    ),
    WritePropagation(
      on: TableUpdateQuery.onTableName(
        'savings_goals',
        limitUpdateKind: UpdateKind.delete,
      ),
      result: [TableUpdate('goal_contributions', kind: UpdateKind.delete)],
    ),
  ]);
}

typedef $$AppSettingsTableCreateCompanionBuilder =
    AppSettingsCompanion Function({
      Value<int> id,
      Value<bool> onboardingDone,
      Value<int> openingBalanceKobo,
      Value<int> usualIncomeKobo,
      Value<IncomeFrequency> incomeFrequency,
      Value<AppThemeMode> themeMode,
      Value<bool> appLockEnabled,
      Value<bool> dailyReminderEnabled,
      Value<int> reminderMinuteOfDay,
      Value<bool> categoryAlertsEnabled,
    });
typedef $$AppSettingsTableUpdateCompanionBuilder =
    AppSettingsCompanion Function({
      Value<int> id,
      Value<bool> onboardingDone,
      Value<int> openingBalanceKobo,
      Value<int> usualIncomeKobo,
      Value<IncomeFrequency> incomeFrequency,
      Value<AppThemeMode> themeMode,
      Value<bool> appLockEnabled,
      Value<bool> dailyReminderEnabled,
      Value<int> reminderMinuteOfDay,
      Value<bool> categoryAlertsEnabled,
    });

class $$AppSettingsTableFilterComposer
    extends Composer<_$AppDatabase, $AppSettingsTable> {
  $$AppSettingsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<bool> get onboardingDone => $composableBuilder(
    column: $table.onboardingDone,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get openingBalanceKobo => $composableBuilder(
    column: $table.openingBalanceKobo,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get usualIncomeKobo => $composableBuilder(
    column: $table.usualIncomeKobo,
    builder: (column) => ColumnFilters(column),
  );

  ColumnWithTypeConverterFilters<IncomeFrequency, IncomeFrequency, String>
  get incomeFrequency => $composableBuilder(
    column: $table.incomeFrequency,
    builder: (column) => ColumnWithTypeConverterFilters(column),
  );

  ColumnWithTypeConverterFilters<AppThemeMode, AppThemeMode, String>
  get themeMode => $composableBuilder(
    column: $table.themeMode,
    builder: (column) => ColumnWithTypeConverterFilters(column),
  );

  ColumnFilters<bool> get appLockEnabled => $composableBuilder(
    column: $table.appLockEnabled,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<bool> get dailyReminderEnabled => $composableBuilder(
    column: $table.dailyReminderEnabled,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get reminderMinuteOfDay => $composableBuilder(
    column: $table.reminderMinuteOfDay,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<bool> get categoryAlertsEnabled => $composableBuilder(
    column: $table.categoryAlertsEnabled,
    builder: (column) => ColumnFilters(column),
  );
}

class $$AppSettingsTableOrderingComposer
    extends Composer<_$AppDatabase, $AppSettingsTable> {
  $$AppSettingsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get onboardingDone => $composableBuilder(
    column: $table.onboardingDone,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get openingBalanceKobo => $composableBuilder(
    column: $table.openingBalanceKobo,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get usualIncomeKobo => $composableBuilder(
    column: $table.usualIncomeKobo,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get incomeFrequency => $composableBuilder(
    column: $table.incomeFrequency,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get themeMode => $composableBuilder(
    column: $table.themeMode,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get appLockEnabled => $composableBuilder(
    column: $table.appLockEnabled,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get dailyReminderEnabled => $composableBuilder(
    column: $table.dailyReminderEnabled,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get reminderMinuteOfDay => $composableBuilder(
    column: $table.reminderMinuteOfDay,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get categoryAlertsEnabled => $composableBuilder(
    column: $table.categoryAlertsEnabled,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$AppSettingsTableAnnotationComposer
    extends Composer<_$AppDatabase, $AppSettingsTable> {
  $$AppSettingsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<bool> get onboardingDone => $composableBuilder(
    column: $table.onboardingDone,
    builder: (column) => column,
  );

  GeneratedColumn<int> get openingBalanceKobo => $composableBuilder(
    column: $table.openingBalanceKobo,
    builder: (column) => column,
  );

  GeneratedColumn<int> get usualIncomeKobo => $composableBuilder(
    column: $table.usualIncomeKobo,
    builder: (column) => column,
  );

  GeneratedColumnWithTypeConverter<IncomeFrequency, String>
  get incomeFrequency => $composableBuilder(
    column: $table.incomeFrequency,
    builder: (column) => column,
  );

  GeneratedColumnWithTypeConverter<AppThemeMode, String> get themeMode =>
      $composableBuilder(column: $table.themeMode, builder: (column) => column);

  GeneratedColumn<bool> get appLockEnabled => $composableBuilder(
    column: $table.appLockEnabled,
    builder: (column) => column,
  );

  GeneratedColumn<bool> get dailyReminderEnabled => $composableBuilder(
    column: $table.dailyReminderEnabled,
    builder: (column) => column,
  );

  GeneratedColumn<int> get reminderMinuteOfDay => $composableBuilder(
    column: $table.reminderMinuteOfDay,
    builder: (column) => column,
  );

  GeneratedColumn<bool> get categoryAlertsEnabled => $composableBuilder(
    column: $table.categoryAlertsEnabled,
    builder: (column) => column,
  );
}

class $$AppSettingsTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $AppSettingsTable,
          SettingsRow,
          $$AppSettingsTableFilterComposer,
          $$AppSettingsTableOrderingComposer,
          $$AppSettingsTableAnnotationComposer,
          $$AppSettingsTableCreateCompanionBuilder,
          $$AppSettingsTableUpdateCompanionBuilder,
          (
            SettingsRow,
            BaseReferences<_$AppDatabase, $AppSettingsTable, SettingsRow>,
          ),
          SettingsRow,
          PrefetchHooks Function()
        > {
  $$AppSettingsTableTableManager(_$AppDatabase db, $AppSettingsTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$AppSettingsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$AppSettingsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$AppSettingsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<bool> onboardingDone = const Value.absent(),
                Value<int> openingBalanceKobo = const Value.absent(),
                Value<int> usualIncomeKobo = const Value.absent(),
                Value<IncomeFrequency> incomeFrequency = const Value.absent(),
                Value<AppThemeMode> themeMode = const Value.absent(),
                Value<bool> appLockEnabled = const Value.absent(),
                Value<bool> dailyReminderEnabled = const Value.absent(),
                Value<int> reminderMinuteOfDay = const Value.absent(),
                Value<bool> categoryAlertsEnabled = const Value.absent(),
              }) => AppSettingsCompanion(
                id: id,
                onboardingDone: onboardingDone,
                openingBalanceKobo: openingBalanceKobo,
                usualIncomeKobo: usualIncomeKobo,
                incomeFrequency: incomeFrequency,
                themeMode: themeMode,
                appLockEnabled: appLockEnabled,
                dailyReminderEnabled: dailyReminderEnabled,
                reminderMinuteOfDay: reminderMinuteOfDay,
                categoryAlertsEnabled: categoryAlertsEnabled,
              ),
          createCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<bool> onboardingDone = const Value.absent(),
                Value<int> openingBalanceKobo = const Value.absent(),
                Value<int> usualIncomeKobo = const Value.absent(),
                Value<IncomeFrequency> incomeFrequency = const Value.absent(),
                Value<AppThemeMode> themeMode = const Value.absent(),
                Value<bool> appLockEnabled = const Value.absent(),
                Value<bool> dailyReminderEnabled = const Value.absent(),
                Value<int> reminderMinuteOfDay = const Value.absent(),
                Value<bool> categoryAlertsEnabled = const Value.absent(),
              }) => AppSettingsCompanion.insert(
                id: id,
                onboardingDone: onboardingDone,
                openingBalanceKobo: openingBalanceKobo,
                usualIncomeKobo: usualIncomeKobo,
                incomeFrequency: incomeFrequency,
                themeMode: themeMode,
                appLockEnabled: appLockEnabled,
                dailyReminderEnabled: dailyReminderEnabled,
                reminderMinuteOfDay: reminderMinuteOfDay,
                categoryAlertsEnabled: categoryAlertsEnabled,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable<$AppSettingsTable, SettingsRow>(table),
                  BaseReferences<_$AppDatabase, $AppSettingsTable, SettingsRow>(
                    db,
                    table,
                    e,
                  ),
                ),
              )
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$AppSettingsTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $AppSettingsTable,
      SettingsRow,
      $$AppSettingsTableFilterComposer,
      $$AppSettingsTableOrderingComposer,
      $$AppSettingsTableAnnotationComposer,
      $$AppSettingsTableCreateCompanionBuilder,
      $$AppSettingsTableUpdateCompanionBuilder,
      (
        SettingsRow,
        BaseReferences<_$AppDatabase, $AppSettingsTable, SettingsRow>,
      ),
      SettingsRow,
      PrefetchHooks Function()
    >;
typedef $$CategoriesTableCreateCompanionBuilder = CategoriesCompanion Function({
  Value<int> id,
  required String name,
  required CategoryKind kind,
  Value<PriorityTier?> tier,
  required String iconKey,
  required int colorValue,
  Value<int> sortOrder,
  Value<bool> archived,
});
typedef $$CategoriesTableUpdateCompanionBuilder = CategoriesCompanion Function({
  Value<int> id,
  Value<String> name,
  Value<CategoryKind> kind,
  Value<PriorityTier?> tier,
  Value<String> iconKey,
  Value<int> colorValue,
  Value<int> sortOrder,
  Value<bool> archived,
});

final class $$CategoriesTableReferences
    extends BaseReferences<_$AppDatabase, $CategoriesTable, BudgetCategory> {
  $$CategoriesTableReferences(super.$_db, super.$_table, super.$_typedResult);

  static MultiTypedResultKey<$BudgetLinesTable, List<BudgetLine>>
  _budgetLinesRefsTable(_$AppDatabase db) => MultiTypedResultKey.fromTable(
    db.budgetLines,
    aliasName: 'categories__id__budget_lines__category_id',
  );

  $$BudgetLinesTableProcessedTableManager get budgetLinesRefs {
    final manager = $$BudgetLinesTableTableManager(
      $_db,
      $_db.budgetLines,
    ).filter((f) => f.categoryId.id.sqlEquals($_itemColumn<int>('id')!));

    final cache = $_typedResult.readTableOrNull(_budgetLinesRefsTable($_db));
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }

  static MultiTypedResultKey<$TransactionsTable, List<Txn>>
  _transactionsRefsTable(_$AppDatabase db) => MultiTypedResultKey.fromTable(
    db.transactions,
    aliasName: 'categories__id__transactions__category_id',
  );

  $$TransactionsTableProcessedTableManager get transactionsRefs {
    final manager = $$TransactionsTableTableManager(
      $_db,
      $_db.transactions,
    ).filter((f) => f.categoryId.id.sqlEquals($_itemColumn<int>('id')!));

    final cache = $_typedResult.readTableOrNull(_transactionsRefsTable($_db));
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }
}

class $$CategoriesTableFilterComposer
    extends Composer<_$AppDatabase, $CategoriesTable> {
  $$CategoriesTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get name => $composableBuilder(
    column: $table.name,
    builder: (column) => ColumnFilters(column),
  );

  ColumnWithTypeConverterFilters<CategoryKind, CategoryKind, String> get kind =>
      $composableBuilder(
        column: $table.kind,
        builder: (column) => ColumnWithTypeConverterFilters(column),
      );

  ColumnWithTypeConverterFilters<PriorityTier?, PriorityTier, String>
  get tier => $composableBuilder(
    column: $table.tier,
    builder: (column) => ColumnWithTypeConverterFilters(column),
  );

  ColumnFilters<String> get iconKey => $composableBuilder(
    column: $table.iconKey,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get colorValue => $composableBuilder(
    column: $table.colorValue,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get sortOrder => $composableBuilder(
    column: $table.sortOrder,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<bool> get archived => $composableBuilder(
    column: $table.archived,
    builder: (column) => ColumnFilters(column),
  );

  Expression<bool> budgetLinesRefs(
    Expression<bool> Function($$BudgetLinesTableFilterComposer f) f,
  ) {
    final $$BudgetLinesTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.budgetLines,
      getReferencedColumn: (t) => t.categoryId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$BudgetLinesTableFilterComposer(
            $db: $db,
            $table: $db.budgetLines,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }

  Expression<bool> transactionsRefs(
    Expression<bool> Function($$TransactionsTableFilterComposer f) f,
  ) {
    final $$TransactionsTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.transactions,
      getReferencedColumn: (t) => t.categoryId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$TransactionsTableFilterComposer(
            $db: $db,
            $table: $db.transactions,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }
}

class $$CategoriesTableOrderingComposer
    extends Composer<_$AppDatabase, $CategoriesTable> {
  $$CategoriesTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get name => $composableBuilder(
    column: $table.name,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get kind => $composableBuilder(
    column: $table.kind,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get tier => $composableBuilder(
    column: $table.tier,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get iconKey => $composableBuilder(
    column: $table.iconKey,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get colorValue => $composableBuilder(
    column: $table.colorValue,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get sortOrder => $composableBuilder(
    column: $table.sortOrder,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get archived => $composableBuilder(
    column: $table.archived,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$CategoriesTableAnnotationComposer
    extends Composer<_$AppDatabase, $CategoriesTable> {
  $$CategoriesTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get name =>
      $composableBuilder(column: $table.name, builder: (column) => column);

  GeneratedColumnWithTypeConverter<CategoryKind, String> get kind =>
      $composableBuilder(column: $table.kind, builder: (column) => column);

  GeneratedColumnWithTypeConverter<PriorityTier?, String> get tier =>
      $composableBuilder(column: $table.tier, builder: (column) => column);

  GeneratedColumn<String> get iconKey =>
      $composableBuilder(column: $table.iconKey, builder: (column) => column);

  GeneratedColumn<int> get colorValue => $composableBuilder(
    column: $table.colorValue,
    builder: (column) => column,
  );

  GeneratedColumn<int> get sortOrder =>
      $composableBuilder(column: $table.sortOrder, builder: (column) => column);

  GeneratedColumn<bool> get archived =>
      $composableBuilder(column: $table.archived, builder: (column) => column);

  Expression<T> budgetLinesRefs<T extends Object>(
    Expression<T> Function($$BudgetLinesTableAnnotationComposer a) f,
  ) {
    final $$BudgetLinesTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.budgetLines,
      getReferencedColumn: (t) => t.categoryId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$BudgetLinesTableAnnotationComposer(
            $db: $db,
            $table: $db.budgetLines,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }

  Expression<T> transactionsRefs<T extends Object>(
    Expression<T> Function($$TransactionsTableAnnotationComposer a) f,
  ) {
    final $$TransactionsTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.transactions,
      getReferencedColumn: (t) => t.categoryId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$TransactionsTableAnnotationComposer(
            $db: $db,
            $table: $db.transactions,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }
}

class $$CategoriesTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $CategoriesTable,
          BudgetCategory,
          $$CategoriesTableFilterComposer,
          $$CategoriesTableOrderingComposer,
          $$CategoriesTableAnnotationComposer,
          $$CategoriesTableCreateCompanionBuilder,
          $$CategoriesTableUpdateCompanionBuilder,
          (BudgetCategory, $$CategoriesTableReferences),
          BudgetCategory,
          PrefetchHooks Function({bool budgetLinesRefs, bool transactionsRefs})
        > {
  $$CategoriesTableTableManager(_$AppDatabase db, $CategoriesTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$CategoriesTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$CategoriesTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$CategoriesTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<String> name = const Value.absent(),
                Value<CategoryKind> kind = const Value.absent(),
                Value<PriorityTier?> tier = const Value.absent(),
                Value<String> iconKey = const Value.absent(),
                Value<int> colorValue = const Value.absent(),
                Value<int> sortOrder = const Value.absent(),
                Value<bool> archived = const Value.absent(),
              }) => CategoriesCompanion(
                id: id,
                name: name,
                kind: kind,
                tier: tier,
                iconKey: iconKey,
                colorValue: colorValue,
                sortOrder: sortOrder,
                archived: archived,
              ),
          createCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                required String name,
                required CategoryKind kind,
                Value<PriorityTier?> tier = const Value.absent(),
                required String iconKey,
                required int colorValue,
                Value<int> sortOrder = const Value.absent(),
                Value<bool> archived = const Value.absent(),
              }) => CategoriesCompanion.insert(
                id: id,
                name: name,
                kind: kind,
                tier: tier,
                iconKey: iconKey,
                colorValue: colorValue,
                sortOrder: sortOrder,
                archived: archived,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable<$CategoriesTable, BudgetCategory>(table),
                  $$CategoriesTableReferences(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback:
              ({budgetLinesRefs = false, transactionsRefs = false}) {
                return PrefetchHooks(
                  db: db,
                  explicitlyWatchedTables: [
                    if (budgetLinesRefs) db.budgetLines,
                    if (transactionsRefs) db.transactions,
                  ],
                  addJoins: null,
                  getPrefetchedDataCallback: (items) async {
                    return [
                      if (budgetLinesRefs)
                        await $_getPrefetchedData<
                          BudgetCategory,
                          $CategoriesTable,
                          BudgetLine
                        >(
                          currentTable: table,
                          referencedTable: $$CategoriesTableReferences
                              ._budgetLinesRefsTable(db),
                          managerFromTypedResult: (p0) =>
                              $$CategoriesTableReferences(
                                db,
                                table,
                                p0,
                              ).budgetLinesRefs,
                          referencedItemsForCurrentItem:
                              (item, referencedItems) => referencedItems.where(
                                (e) => e.categoryId == item.id,
                              ),
                          typedResults: items,
                        ),
                      if (transactionsRefs)
                        await $_getPrefetchedData<
                          BudgetCategory,
                          $CategoriesTable,
                          Txn
                        >(
                          currentTable: table,
                          referencedTable: $$CategoriesTableReferences
                              ._transactionsRefsTable(db),
                          managerFromTypedResult: (p0) =>
                              $$CategoriesTableReferences(
                                db,
                                table,
                                p0,
                              ).transactionsRefs,
                          referencedItemsForCurrentItem:
                              (item, referencedItems) => referencedItems.where(
                                (e) => e.categoryId == item.id,
                              ),
                          typedResults: items,
                        ),
                    ];
                  },
                );
              },
        ),
      );
}

typedef $$CategoriesTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $CategoriesTable,
      BudgetCategory,
      $$CategoriesTableFilterComposer,
      $$CategoriesTableOrderingComposer,
      $$CategoriesTableAnnotationComposer,
      $$CategoriesTableCreateCompanionBuilder,
      $$CategoriesTableUpdateCompanionBuilder,
      (BudgetCategory, $$CategoriesTableReferences),
      BudgetCategory,
      PrefetchHooks Function({bool budgetLinesRefs, bool transactionsRefs})
    >;
typedef $$BudgetCyclesTableCreateCompanionBuilder =
    BudgetCyclesCompanion Function({
      Value<int> id,
      required DateTime startDate,
      required DateTime endDate,
      required int startingBalanceKobo,
      Value<int> plannedSavingsKobo,
      Value<bool> isActive,
    });
typedef $$BudgetCyclesTableUpdateCompanionBuilder =
    BudgetCyclesCompanion Function({
      Value<int> id,
      Value<DateTime> startDate,
      Value<DateTime> endDate,
      Value<int> startingBalanceKobo,
      Value<int> plannedSavingsKobo,
      Value<bool> isActive,
    });

final class $$BudgetCyclesTableReferences
    extends BaseReferences<_$AppDatabase, $BudgetCyclesTable, BudgetCycle> {
  $$BudgetCyclesTableReferences(super.$_db, super.$_table, super.$_typedResult);

  static MultiTypedResultKey<$BudgetLinesTable, List<BudgetLine>>
  _budgetLinesRefsTable(_$AppDatabase db) => MultiTypedResultKey.fromTable(
    db.budgetLines,
    aliasName: 'budget_cycles__id__budget_lines__cycle_id',
  );

  $$BudgetLinesTableProcessedTableManager get budgetLinesRefs {
    final manager = $$BudgetLinesTableTableManager(
      $_db,
      $_db.budgetLines,
    ).filter((f) => f.cycleId.id.sqlEquals($_itemColumn<int>('id')!));

    final cache = $_typedResult.readTableOrNull(_budgetLinesRefsTable($_db));
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }
}

class $$BudgetCyclesTableFilterComposer
    extends Composer<_$AppDatabase, $BudgetCyclesTable> {
  $$BudgetCyclesTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get startDate => $composableBuilder(
    column: $table.startDate,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get endDate => $composableBuilder(
    column: $table.endDate,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get startingBalanceKobo => $composableBuilder(
    column: $table.startingBalanceKobo,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get plannedSavingsKobo => $composableBuilder(
    column: $table.plannedSavingsKobo,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<bool> get isActive => $composableBuilder(
    column: $table.isActive,
    builder: (column) => ColumnFilters(column),
  );

  Expression<bool> budgetLinesRefs(
    Expression<bool> Function($$BudgetLinesTableFilterComposer f) f,
  ) {
    final $$BudgetLinesTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.budgetLines,
      getReferencedColumn: (t) => t.cycleId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$BudgetLinesTableFilterComposer(
            $db: $db,
            $table: $db.budgetLines,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }
}

class $$BudgetCyclesTableOrderingComposer
    extends Composer<_$AppDatabase, $BudgetCyclesTable> {
  $$BudgetCyclesTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get startDate => $composableBuilder(
    column: $table.startDate,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get endDate => $composableBuilder(
    column: $table.endDate,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get startingBalanceKobo => $composableBuilder(
    column: $table.startingBalanceKobo,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get plannedSavingsKobo => $composableBuilder(
    column: $table.plannedSavingsKobo,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get isActive => $composableBuilder(
    column: $table.isActive,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$BudgetCyclesTableAnnotationComposer
    extends Composer<_$AppDatabase, $BudgetCyclesTable> {
  $$BudgetCyclesTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<DateTime> get startDate =>
      $composableBuilder(column: $table.startDate, builder: (column) => column);

  GeneratedColumn<DateTime> get endDate =>
      $composableBuilder(column: $table.endDate, builder: (column) => column);

  GeneratedColumn<int> get startingBalanceKobo => $composableBuilder(
    column: $table.startingBalanceKobo,
    builder: (column) => column,
  );

  GeneratedColumn<int> get plannedSavingsKobo => $composableBuilder(
    column: $table.plannedSavingsKobo,
    builder: (column) => column,
  );

  GeneratedColumn<bool> get isActive =>
      $composableBuilder(column: $table.isActive, builder: (column) => column);

  Expression<T> budgetLinesRefs<T extends Object>(
    Expression<T> Function($$BudgetLinesTableAnnotationComposer a) f,
  ) {
    final $$BudgetLinesTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.budgetLines,
      getReferencedColumn: (t) => t.cycleId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$BudgetLinesTableAnnotationComposer(
            $db: $db,
            $table: $db.budgetLines,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }
}

class $$BudgetCyclesTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $BudgetCyclesTable,
          BudgetCycle,
          $$BudgetCyclesTableFilterComposer,
          $$BudgetCyclesTableOrderingComposer,
          $$BudgetCyclesTableAnnotationComposer,
          $$BudgetCyclesTableCreateCompanionBuilder,
          $$BudgetCyclesTableUpdateCompanionBuilder,
          (BudgetCycle, $$BudgetCyclesTableReferences),
          BudgetCycle,
          PrefetchHooks Function({bool budgetLinesRefs})
        > {
  $$BudgetCyclesTableTableManager(_$AppDatabase db, $BudgetCyclesTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$BudgetCyclesTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$BudgetCyclesTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$BudgetCyclesTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<DateTime> startDate = const Value.absent(),
                Value<DateTime> endDate = const Value.absent(),
                Value<int> startingBalanceKobo = const Value.absent(),
                Value<int> plannedSavingsKobo = const Value.absent(),
                Value<bool> isActive = const Value.absent(),
              }) => BudgetCyclesCompanion(
                id: id,
                startDate: startDate,
                endDate: endDate,
                startingBalanceKobo: startingBalanceKobo,
                plannedSavingsKobo: plannedSavingsKobo,
                isActive: isActive,
              ),
          createCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                required DateTime startDate,
                required DateTime endDate,
                required int startingBalanceKobo,
                Value<int> plannedSavingsKobo = const Value.absent(),
                Value<bool> isActive = const Value.absent(),
              }) => BudgetCyclesCompanion.insert(
                id: id,
                startDate: startDate,
                endDate: endDate,
                startingBalanceKobo: startingBalanceKobo,
                plannedSavingsKobo: plannedSavingsKobo,
                isActive: isActive,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable<$BudgetCyclesTable, BudgetCycle>(table),
                  $$BudgetCyclesTableReferences(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback: ({budgetLinesRefs = false}) {
            return PrefetchHooks(
              db: db,
              explicitlyWatchedTables: [if (budgetLinesRefs) db.budgetLines],
              addJoins: null,
              getPrefetchedDataCallback: (items) async {
                return [
                  if (budgetLinesRefs)
                    await $_getPrefetchedData<
                      BudgetCycle,
                      $BudgetCyclesTable,
                      BudgetLine
                    >(
                      currentTable: table,
                      referencedTable: $$BudgetCyclesTableReferences
                          ._budgetLinesRefsTable(db),
                      managerFromTypedResult: (p0) =>
                          $$BudgetCyclesTableReferences(
                            db,
                            table,
                            p0,
                          ).budgetLinesRefs,
                      referencedItemsForCurrentItem: (item, referencedItems) =>
                          referencedItems.where((e) => e.cycleId == item.id),
                      typedResults: items,
                    ),
                ];
              },
            );
          },
        ),
      );
}

typedef $$BudgetCyclesTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $BudgetCyclesTable,
      BudgetCycle,
      $$BudgetCyclesTableFilterComposer,
      $$BudgetCyclesTableOrderingComposer,
      $$BudgetCyclesTableAnnotationComposer,
      $$BudgetCyclesTableCreateCompanionBuilder,
      $$BudgetCyclesTableUpdateCompanionBuilder,
      (BudgetCycle, $$BudgetCyclesTableReferences),
      BudgetCycle,
      PrefetchHooks Function({bool budgetLinesRefs})
    >;
typedef $$BudgetLinesTableCreateCompanionBuilder =
    BudgetLinesCompanion Function({
      Value<int> id,
      required int cycleId,
      required int categoryId,
      required int plannedKobo,
      Value<bool> alerted80,
      Value<bool> alerted100,
    });
typedef $$BudgetLinesTableUpdateCompanionBuilder =
    BudgetLinesCompanion Function({
      Value<int> id,
      Value<int> cycleId,
      Value<int> categoryId,
      Value<int> plannedKobo,
      Value<bool> alerted80,
      Value<bool> alerted100,
    });

final class $$BudgetLinesTableReferences
    extends BaseReferences<_$AppDatabase, $BudgetLinesTable, BudgetLine> {
  $$BudgetLinesTableReferences(super.$_db, super.$_table, super.$_typedResult);

  static $BudgetCyclesTable _cycleIdTable(_$AppDatabase db) =>
      db.budgetCycles.createAlias('budget_lines__cycle_id__budget_cycles__id');

  $$BudgetCyclesTableProcessedTableManager get cycleId {
    final $_column = $_itemColumn<int>('cycle_id')!;

    final manager = $$BudgetCyclesTableTableManager(
      $_db,
      $_db.budgetCycles,
    ).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_cycleIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }

  static $CategoriesTable _categoryIdTable(_$AppDatabase db) =>
      db.categories.createAlias('budget_lines__category_id__categories__id');

  $$CategoriesTableProcessedTableManager get categoryId {
    final $_column = $_itemColumn<int>('category_id')!;

    final manager = $$CategoriesTableTableManager(
      $_db,
      $_db.categories,
    ).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_categoryIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }
}

class $$BudgetLinesTableFilterComposer
    extends Composer<_$AppDatabase, $BudgetLinesTable> {
  $$BudgetLinesTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get plannedKobo => $composableBuilder(
    column: $table.plannedKobo,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<bool> get alerted80 => $composableBuilder(
    column: $table.alerted80,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<bool> get alerted100 => $composableBuilder(
    column: $table.alerted100,
    builder: (column) => ColumnFilters(column),
  );

  $$BudgetCyclesTableFilterComposer get cycleId {
    final $$BudgetCyclesTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.cycleId,
      referencedTable: $db.budgetCycles,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$BudgetCyclesTableFilterComposer(
            $db: $db,
            $table: $db.budgetCycles,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  $$CategoriesTableFilterComposer get categoryId {
    final $$CategoriesTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.categoryId,
      referencedTable: $db.categories,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$CategoriesTableFilterComposer(
            $db: $db,
            $table: $db.categories,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$BudgetLinesTableOrderingComposer
    extends Composer<_$AppDatabase, $BudgetLinesTable> {
  $$BudgetLinesTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get plannedKobo => $composableBuilder(
    column: $table.plannedKobo,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get alerted80 => $composableBuilder(
    column: $table.alerted80,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get alerted100 => $composableBuilder(
    column: $table.alerted100,
    builder: (column) => ColumnOrderings(column),
  );

  $$BudgetCyclesTableOrderingComposer get cycleId {
    final $$BudgetCyclesTableOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.cycleId,
      referencedTable: $db.budgetCycles,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$BudgetCyclesTableOrderingComposer(
            $db: $db,
            $table: $db.budgetCycles,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  $$CategoriesTableOrderingComposer get categoryId {
    final $$CategoriesTableOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.categoryId,
      referencedTable: $db.categories,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$CategoriesTableOrderingComposer(
            $db: $db,
            $table: $db.categories,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$BudgetLinesTableAnnotationComposer
    extends Composer<_$AppDatabase, $BudgetLinesTable> {
  $$BudgetLinesTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<int> get plannedKobo => $composableBuilder(
    column: $table.plannedKobo,
    builder: (column) => column,
  );

  GeneratedColumn<bool> get alerted80 =>
      $composableBuilder(column: $table.alerted80, builder: (column) => column);

  GeneratedColumn<bool> get alerted100 => $composableBuilder(
    column: $table.alerted100,
    builder: (column) => column,
  );

  $$BudgetCyclesTableAnnotationComposer get cycleId {
    final $$BudgetCyclesTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.cycleId,
      referencedTable: $db.budgetCycles,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$BudgetCyclesTableAnnotationComposer(
            $db: $db,
            $table: $db.budgetCycles,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  $$CategoriesTableAnnotationComposer get categoryId {
    final $$CategoriesTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.categoryId,
      referencedTable: $db.categories,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$CategoriesTableAnnotationComposer(
            $db: $db,
            $table: $db.categories,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$BudgetLinesTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $BudgetLinesTable,
          BudgetLine,
          $$BudgetLinesTableFilterComposer,
          $$BudgetLinesTableOrderingComposer,
          $$BudgetLinesTableAnnotationComposer,
          $$BudgetLinesTableCreateCompanionBuilder,
          $$BudgetLinesTableUpdateCompanionBuilder,
          (BudgetLine, $$BudgetLinesTableReferences),
          BudgetLine,
          PrefetchHooks Function({bool cycleId, bool categoryId})
        > {
  $$BudgetLinesTableTableManager(_$AppDatabase db, $BudgetLinesTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$BudgetLinesTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$BudgetLinesTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$BudgetLinesTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<int> cycleId = const Value.absent(),
                Value<int> categoryId = const Value.absent(),
                Value<int> plannedKobo = const Value.absent(),
                Value<bool> alerted80 = const Value.absent(),
                Value<bool> alerted100 = const Value.absent(),
              }) => BudgetLinesCompanion(
                id: id,
                cycleId: cycleId,
                categoryId: categoryId,
                plannedKobo: plannedKobo,
                alerted80: alerted80,
                alerted100: alerted100,
              ),
          createCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                required int cycleId,
                required int categoryId,
                required int plannedKobo,
                Value<bool> alerted80 = const Value.absent(),
                Value<bool> alerted100 = const Value.absent(),
              }) => BudgetLinesCompanion.insert(
                id: id,
                cycleId: cycleId,
                categoryId: categoryId,
                plannedKobo: plannedKobo,
                alerted80: alerted80,
                alerted100: alerted100,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable<$BudgetLinesTable, BudgetLine>(table),
                  $$BudgetLinesTableReferences(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback: ({cycleId = false, categoryId = false}) {
            return PrefetchHooks(
              db: db,
              explicitlyWatchedTables: [],
              addJoins:
                  <
                    T extends TableManagerState<
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic
                    >
                  >(state) {
                    if (cycleId) {
                      state = state.withJoin(
                        currentTable: table,
                        currentColumn: table.cycleId,
                        referencedTable: $$BudgetLinesTableReferences
                            ._cycleIdTable(db),
                        referencedColumn: $$BudgetLinesTableReferences
                            ._cycleIdTable(db)
                            .id,
                      ) as T;
                    }
                    if (categoryId) {
                      state = state.withJoin(
                        currentTable: table,
                        currentColumn: table.categoryId,
                        referencedTable: $$BudgetLinesTableReferences
                            ._categoryIdTable(db),
                        referencedColumn: $$BudgetLinesTableReferences
                            ._categoryIdTable(db)
                            .id,
                      ) as T;
                    }

                    return state;
                  },
              getPrefetchedDataCallback: (items) async {
                return [];
              },
            );
          },
        ),
      );
}

typedef $$BudgetLinesTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $BudgetLinesTable,
      BudgetLine,
      $$BudgetLinesTableFilterComposer,
      $$BudgetLinesTableOrderingComposer,
      $$BudgetLinesTableAnnotationComposer,
      $$BudgetLinesTableCreateCompanionBuilder,
      $$BudgetLinesTableUpdateCompanionBuilder,
      (BudgetLine, $$BudgetLinesTableReferences),
      BudgetLine,
      PrefetchHooks Function({bool cycleId, bool categoryId})
    >;
typedef $$TransactionsTableCreateCompanionBuilder =
    TransactionsCompanion Function({
      Value<int> id,
      required TxType type,
      required int amountKobo,
      required int categoryId,
      Value<String?> note,
      required DateTime occurredAt,
      Value<DateTime> createdAt,
    });
typedef $$TransactionsTableUpdateCompanionBuilder =
    TransactionsCompanion Function({
      Value<int> id,
      Value<TxType> type,
      Value<int> amountKobo,
      Value<int> categoryId,
      Value<String?> note,
      Value<DateTime> occurredAt,
      Value<DateTime> createdAt,
    });

final class $$TransactionsTableReferences
    extends BaseReferences<_$AppDatabase, $TransactionsTable, Txn> {
  $$TransactionsTableReferences(super.$_db, super.$_table, super.$_typedResult);

  static $CategoriesTable _categoryIdTable(_$AppDatabase db) =>
      db.categories.createAlias('transactions__category_id__categories__id');

  $$CategoriesTableProcessedTableManager get categoryId {
    final $_column = $_itemColumn<int>('category_id')!;

    final manager = $$CategoriesTableTableManager(
      $_db,
      $_db.categories,
    ).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_categoryIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }
}

class $$TransactionsTableFilterComposer
    extends Composer<_$AppDatabase, $TransactionsTable> {
  $$TransactionsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnWithTypeConverterFilters<TxType, TxType, String> get type =>
      $composableBuilder(
        column: $table.type,
        builder: (column) => ColumnWithTypeConverterFilters(column),
      );

  ColumnFilters<int> get amountKobo => $composableBuilder(
    column: $table.amountKobo,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get note => $composableBuilder(
    column: $table.note,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get occurredAt => $composableBuilder(
    column: $table.occurredAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnFilters(column),
  );

  $$CategoriesTableFilterComposer get categoryId {
    final $$CategoriesTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.categoryId,
      referencedTable: $db.categories,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$CategoriesTableFilterComposer(
            $db: $db,
            $table: $db.categories,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$TransactionsTableOrderingComposer
    extends Composer<_$AppDatabase, $TransactionsTable> {
  $$TransactionsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get type => $composableBuilder(
    column: $table.type,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get amountKobo => $composableBuilder(
    column: $table.amountKobo,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get note => $composableBuilder(
    column: $table.note,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get occurredAt => $composableBuilder(
    column: $table.occurredAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnOrderings(column),
  );

  $$CategoriesTableOrderingComposer get categoryId {
    final $$CategoriesTableOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.categoryId,
      referencedTable: $db.categories,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$CategoriesTableOrderingComposer(
            $db: $db,
            $table: $db.categories,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$TransactionsTableAnnotationComposer
    extends Composer<_$AppDatabase, $TransactionsTable> {
  $$TransactionsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumnWithTypeConverter<TxType, String> get type =>
      $composableBuilder(column: $table.type, builder: (column) => column);

  GeneratedColumn<int> get amountKobo => $composableBuilder(
    column: $table.amountKobo,
    builder: (column) => column,
  );

  GeneratedColumn<String> get note =>
      $composableBuilder(column: $table.note, builder: (column) => column);

  GeneratedColumn<DateTime> get occurredAt => $composableBuilder(
    column: $table.occurredAt,
    builder: (column) => column,
  );

  GeneratedColumn<DateTime> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);

  $$CategoriesTableAnnotationComposer get categoryId {
    final $$CategoriesTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.categoryId,
      referencedTable: $db.categories,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$CategoriesTableAnnotationComposer(
            $db: $db,
            $table: $db.categories,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$TransactionsTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $TransactionsTable,
          Txn,
          $$TransactionsTableFilterComposer,
          $$TransactionsTableOrderingComposer,
          $$TransactionsTableAnnotationComposer,
          $$TransactionsTableCreateCompanionBuilder,
          $$TransactionsTableUpdateCompanionBuilder,
          (Txn, $$TransactionsTableReferences),
          Txn,
          PrefetchHooks Function({bool categoryId})
        > {
  $$TransactionsTableTableManager(_$AppDatabase db, $TransactionsTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$TransactionsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$TransactionsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$TransactionsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<TxType> type = const Value.absent(),
                Value<int> amountKobo = const Value.absent(),
                Value<int> categoryId = const Value.absent(),
                Value<String?> note = const Value.absent(),
                Value<DateTime> occurredAt = const Value.absent(),
                Value<DateTime> createdAt = const Value.absent(),
              }) => TransactionsCompanion(
                id: id,
                type: type,
                amountKobo: amountKobo,
                categoryId: categoryId,
                note: note,
                occurredAt: occurredAt,
                createdAt: createdAt,
              ),
          createCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                required TxType type,
                required int amountKobo,
                required int categoryId,
                Value<String?> note = const Value.absent(),
                required DateTime occurredAt,
                Value<DateTime> createdAt = const Value.absent(),
              }) => TransactionsCompanion.insert(
                id: id,
                type: type,
                amountKobo: amountKobo,
                categoryId: categoryId,
                note: note,
                occurredAt: occurredAt,
                createdAt: createdAt,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable<$TransactionsTable, Txn>(table),
                  $$TransactionsTableReferences(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback: ({categoryId = false}) {
            return PrefetchHooks(
              db: db,
              explicitlyWatchedTables: [],
              addJoins:
                  <
                    T extends TableManagerState<
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic
                    >
                  >(state) {
                    if (categoryId) {
                      state = state.withJoin(
                        currentTable: table,
                        currentColumn: table.categoryId,
                        referencedTable: $$TransactionsTableReferences
                            ._categoryIdTable(db),
                        referencedColumn: $$TransactionsTableReferences
                            ._categoryIdTable(db)
                            .id,
                      ) as T;
                    }

                    return state;
                  },
              getPrefetchedDataCallback: (items) async {
                return [];
              },
            );
          },
        ),
      );
}

typedef $$TransactionsTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $TransactionsTable,
      Txn,
      $$TransactionsTableFilterComposer,
      $$TransactionsTableOrderingComposer,
      $$TransactionsTableAnnotationComposer,
      $$TransactionsTableCreateCompanionBuilder,
      $$TransactionsTableUpdateCompanionBuilder,
      (Txn, $$TransactionsTableReferences),
      Txn,
      PrefetchHooks Function({bool categoryId})
    >;
typedef $$SavingsGoalsTableCreateCompanionBuilder =
    SavingsGoalsCompanion Function({
      Value<int> id,
      required String name,
      required int targetKobo,
      Value<DateTime?> deadline,
      Value<DateTime> createdAt,
      Value<bool> archived,
    });
typedef $$SavingsGoalsTableUpdateCompanionBuilder =
    SavingsGoalsCompanion Function({
      Value<int> id,
      Value<String> name,
      Value<int> targetKobo,
      Value<DateTime?> deadline,
      Value<DateTime> createdAt,
      Value<bool> archived,
    });

final class $$SavingsGoalsTableReferences
    extends BaseReferences<_$AppDatabase, $SavingsGoalsTable, SavingsGoal> {
  $$SavingsGoalsTableReferences(super.$_db, super.$_table, super.$_typedResult);

  static MultiTypedResultKey<$GoalContributionsTable, List<GoalContribution>>
  _goalContributionsRefsTable(_$AppDatabase db) =>
      MultiTypedResultKey.fromTable(
        db.goalContributions,
        aliasName: 'savings_goals__id__goal_contributions__goal_id',
      );

  $$GoalContributionsTableProcessedTableManager get goalContributionsRefs {
    final manager = $$GoalContributionsTableTableManager(
      $_db,
      $_db.goalContributions,
    ).filter((f) => f.goalId.id.sqlEquals($_itemColumn<int>('id')!));

    final cache = $_typedResult.readTableOrNull(
      _goalContributionsRefsTable($_db),
    );
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }
}

class $$SavingsGoalsTableFilterComposer
    extends Composer<_$AppDatabase, $SavingsGoalsTable> {
  $$SavingsGoalsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get name => $composableBuilder(
    column: $table.name,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get targetKobo => $composableBuilder(
    column: $table.targetKobo,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get deadline => $composableBuilder(
    column: $table.deadline,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<bool> get archived => $composableBuilder(
    column: $table.archived,
    builder: (column) => ColumnFilters(column),
  );

  Expression<bool> goalContributionsRefs(
    Expression<bool> Function($$GoalContributionsTableFilterComposer f) f,
  ) {
    final $$GoalContributionsTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.goalContributions,
      getReferencedColumn: (t) => t.goalId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$GoalContributionsTableFilterComposer(
            $db: $db,
            $table: $db.goalContributions,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }
}

class $$SavingsGoalsTableOrderingComposer
    extends Composer<_$AppDatabase, $SavingsGoalsTable> {
  $$SavingsGoalsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get name => $composableBuilder(
    column: $table.name,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get targetKobo => $composableBuilder(
    column: $table.targetKobo,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get deadline => $composableBuilder(
    column: $table.deadline,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get archived => $composableBuilder(
    column: $table.archived,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$SavingsGoalsTableAnnotationComposer
    extends Composer<_$AppDatabase, $SavingsGoalsTable> {
  $$SavingsGoalsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get name =>
      $composableBuilder(column: $table.name, builder: (column) => column);

  GeneratedColumn<int> get targetKobo => $composableBuilder(
    column: $table.targetKobo,
    builder: (column) => column,
  );

  GeneratedColumn<DateTime> get deadline =>
      $composableBuilder(column: $table.deadline, builder: (column) => column);

  GeneratedColumn<DateTime> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);

  GeneratedColumn<bool> get archived =>
      $composableBuilder(column: $table.archived, builder: (column) => column);

  Expression<T> goalContributionsRefs<T extends Object>(
    Expression<T> Function($$GoalContributionsTableAnnotationComposer a) f,
  ) {
    final $$GoalContributionsTableAnnotationComposer composer =
        $composerBuilder(
          composer: this,
          getCurrentColumn: (t) => t.id,
          referencedTable: $db.goalContributions,
          getReferencedColumn: (t) => t.goalId,
          builder:
              (
                joinBuilder, {
                $addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer,
              }) => $$GoalContributionsTableAnnotationComposer(
                $db: $db,
                $table: $db.goalContributions,
                $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
                joinBuilder: joinBuilder,
                $removeJoinBuilderFromRootComposer:
                    $removeJoinBuilderFromRootComposer,
              ),
        );
    return f(composer);
  }
}

class $$SavingsGoalsTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $SavingsGoalsTable,
          SavingsGoal,
          $$SavingsGoalsTableFilterComposer,
          $$SavingsGoalsTableOrderingComposer,
          $$SavingsGoalsTableAnnotationComposer,
          $$SavingsGoalsTableCreateCompanionBuilder,
          $$SavingsGoalsTableUpdateCompanionBuilder,
          (SavingsGoal, $$SavingsGoalsTableReferences),
          SavingsGoal,
          PrefetchHooks Function({bool goalContributionsRefs})
        > {
  $$SavingsGoalsTableTableManager(_$AppDatabase db, $SavingsGoalsTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$SavingsGoalsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$SavingsGoalsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$SavingsGoalsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<String> name = const Value.absent(),
                Value<int> targetKobo = const Value.absent(),
                Value<DateTime?> deadline = const Value.absent(),
                Value<DateTime> createdAt = const Value.absent(),
                Value<bool> archived = const Value.absent(),
              }) => SavingsGoalsCompanion(
                id: id,
                name: name,
                targetKobo: targetKobo,
                deadline: deadline,
                createdAt: createdAt,
                archived: archived,
              ),
          createCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                required String name,
                required int targetKobo,
                Value<DateTime?> deadline = const Value.absent(),
                Value<DateTime> createdAt = const Value.absent(),
                Value<bool> archived = const Value.absent(),
              }) => SavingsGoalsCompanion.insert(
                id: id,
                name: name,
                targetKobo: targetKobo,
                deadline: deadline,
                createdAt: createdAt,
                archived: archived,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable<$SavingsGoalsTable, SavingsGoal>(table),
                  $$SavingsGoalsTableReferences(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback: ({goalContributionsRefs = false}) {
            return PrefetchHooks(
              db: db,
              explicitlyWatchedTables: [
                if (goalContributionsRefs) db.goalContributions,
              ],
              addJoins: null,
              getPrefetchedDataCallback: (items) async {
                return [
                  if (goalContributionsRefs)
                    await $_getPrefetchedData<
                      SavingsGoal,
                      $SavingsGoalsTable,
                      GoalContribution
                    >(
                      currentTable: table,
                      referencedTable: $$SavingsGoalsTableReferences
                          ._goalContributionsRefsTable(db),
                      managerFromTypedResult: (p0) =>
                          $$SavingsGoalsTableReferences(
                            db,
                            table,
                            p0,
                          ).goalContributionsRefs,
                      referencedItemsForCurrentItem: (item, referencedItems) =>
                          referencedItems.where((e) => e.goalId == item.id),
                      typedResults: items,
                    ),
                ];
              },
            );
          },
        ),
      );
}

typedef $$SavingsGoalsTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $SavingsGoalsTable,
      SavingsGoal,
      $$SavingsGoalsTableFilterComposer,
      $$SavingsGoalsTableOrderingComposer,
      $$SavingsGoalsTableAnnotationComposer,
      $$SavingsGoalsTableCreateCompanionBuilder,
      $$SavingsGoalsTableUpdateCompanionBuilder,
      (SavingsGoal, $$SavingsGoalsTableReferences),
      SavingsGoal,
      PrefetchHooks Function({bool goalContributionsRefs})
    >;
typedef $$GoalContributionsTableCreateCompanionBuilder =
    GoalContributionsCompanion Function({
      Value<int> id,
      required int goalId,
      required int amountKobo,
      Value<String?> note,
      Value<DateTime> createdAt,
    });
typedef $$GoalContributionsTableUpdateCompanionBuilder =
    GoalContributionsCompanion Function({
      Value<int> id,
      Value<int> goalId,
      Value<int> amountKobo,
      Value<String?> note,
      Value<DateTime> createdAt,
    });

final class $$GoalContributionsTableReferences
    extends
        BaseReferences<
          _$AppDatabase,
          $GoalContributionsTable,
          GoalContribution
        > {
  $$GoalContributionsTableReferences(
    super.$_db,
    super.$_table,
    super.$_typedResult,
  );

  static $SavingsGoalsTable _goalIdTable(_$AppDatabase db) => db.savingsGoals
      .createAlias('goal_contributions__goal_id__savings_goals__id');

  $$SavingsGoalsTableProcessedTableManager get goalId {
    final $_column = $_itemColumn<int>('goal_id')!;

    final manager = $$SavingsGoalsTableTableManager(
      $_db,
      $_db.savingsGoals,
    ).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_goalIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }
}

class $$GoalContributionsTableFilterComposer
    extends Composer<_$AppDatabase, $GoalContributionsTable> {
  $$GoalContributionsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get amountKobo => $composableBuilder(
    column: $table.amountKobo,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get note => $composableBuilder(
    column: $table.note,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnFilters(column),
  );

  $$SavingsGoalsTableFilterComposer get goalId {
    final $$SavingsGoalsTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.goalId,
      referencedTable: $db.savingsGoals,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$SavingsGoalsTableFilterComposer(
            $db: $db,
            $table: $db.savingsGoals,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$GoalContributionsTableOrderingComposer
    extends Composer<_$AppDatabase, $GoalContributionsTable> {
  $$GoalContributionsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get amountKobo => $composableBuilder(
    column: $table.amountKobo,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get note => $composableBuilder(
    column: $table.note,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnOrderings(column),
  );

  $$SavingsGoalsTableOrderingComposer get goalId {
    final $$SavingsGoalsTableOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.goalId,
      referencedTable: $db.savingsGoals,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$SavingsGoalsTableOrderingComposer(
            $db: $db,
            $table: $db.savingsGoals,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$GoalContributionsTableAnnotationComposer
    extends Composer<_$AppDatabase, $GoalContributionsTable> {
  $$GoalContributionsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<int> get amountKobo => $composableBuilder(
    column: $table.amountKobo,
    builder: (column) => column,
  );

  GeneratedColumn<String> get note =>
      $composableBuilder(column: $table.note, builder: (column) => column);

  GeneratedColumn<DateTime> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);

  $$SavingsGoalsTableAnnotationComposer get goalId {
    final $$SavingsGoalsTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.goalId,
      referencedTable: $db.savingsGoals,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$SavingsGoalsTableAnnotationComposer(
            $db: $db,
            $table: $db.savingsGoals,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$GoalContributionsTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $GoalContributionsTable,
          GoalContribution,
          $$GoalContributionsTableFilterComposer,
          $$GoalContributionsTableOrderingComposer,
          $$GoalContributionsTableAnnotationComposer,
          $$GoalContributionsTableCreateCompanionBuilder,
          $$GoalContributionsTableUpdateCompanionBuilder,
          (GoalContribution, $$GoalContributionsTableReferences),
          GoalContribution,
          PrefetchHooks Function({bool goalId})
        > {
  $$GoalContributionsTableTableManager(
    _$AppDatabase db,
    $GoalContributionsTable table,
  ) : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$GoalContributionsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$GoalContributionsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$GoalContributionsTableAnnotationComposer(
                $db: db,
                $table: table,
              ),
          updateCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<int> goalId = const Value.absent(),
                Value<int> amountKobo = const Value.absent(),
                Value<String?> note = const Value.absent(),
                Value<DateTime> createdAt = const Value.absent(),
              }) => GoalContributionsCompanion(
                id: id,
                goalId: goalId,
                amountKobo: amountKobo,
                note: note,
                createdAt: createdAt,
              ),
          createCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                required int goalId,
                required int amountKobo,
                Value<String?> note = const Value.absent(),
                Value<DateTime> createdAt = const Value.absent(),
              }) => GoalContributionsCompanion.insert(
                id: id,
                goalId: goalId,
                amountKobo: amountKobo,
                note: note,
                createdAt: createdAt,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable<$GoalContributionsTable, GoalContribution>(table),
                  $$GoalContributionsTableReferences(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback: ({goalId = false}) {
            return PrefetchHooks(
              db: db,
              explicitlyWatchedTables: [],
              addJoins:
                  <
                    T extends TableManagerState<
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic
                    >
                  >(state) {
                    if (goalId) {
                      state = state.withJoin(
                        currentTable: table,
                        currentColumn: table.goalId,
                        referencedTable: $$GoalContributionsTableReferences
                            ._goalIdTable(db),
                        referencedColumn: $$GoalContributionsTableReferences
                            ._goalIdTable(db)
                            .id,
                      ) as T;
                    }

                    return state;
                  },
              getPrefetchedDataCallback: (items) async {
                return [];
              },
            );
          },
        ),
      );
}

typedef $$GoalContributionsTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $GoalContributionsTable,
      GoalContribution,
      $$GoalContributionsTableFilterComposer,
      $$GoalContributionsTableOrderingComposer,
      $$GoalContributionsTableAnnotationComposer,
      $$GoalContributionsTableCreateCompanionBuilder,
      $$GoalContributionsTableUpdateCompanionBuilder,
      (GoalContribution, $$GoalContributionsTableReferences),
      GoalContribution,
      PrefetchHooks Function({bool goalId})
    >;

class $AppDatabaseManager {
  final _$AppDatabase _db;
  $AppDatabaseManager(this._db);
  $$AppSettingsTableTableManager get appSettings =>
      $$AppSettingsTableTableManager(_db, _db.appSettings);
  $$CategoriesTableTableManager get categories =>
      $$CategoriesTableTableManager(_db, _db.categories);
  $$BudgetCyclesTableTableManager get budgetCycles =>
      $$BudgetCyclesTableTableManager(_db, _db.budgetCycles);
  $$BudgetLinesTableTableManager get budgetLines =>
      $$BudgetLinesTableTableManager(_db, _db.budgetLines);
  $$TransactionsTableTableManager get transactions =>
      $$TransactionsTableTableManager(_db, _db.transactions);
  $$SavingsGoalsTableTableManager get savingsGoals =>
      $$SavingsGoalsTableTableManager(_db, _db.savingsGoals);
  $$GoalContributionsTableTableManager get goalContributions =>
      $$GoalContributionsTableTableManager(_db, _db.goalContributions);
}
