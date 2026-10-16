import 'package:drift/drift.dart';

import 'app_database.dart';

typedef _SeedCat = (String name, String icon, int color, PriorityTier? tier);

const List<_SeedCat> _expenseSeeds = [
  ('Food', 'food', 0xFFE07A2E, PriorityTier.essential),
  ('Transport', 'transport', 0xFF3B82F6, PriorityTier.essential),
  ('Data & Airtime', 'data', 0xFF8B5CF6, PriorityTier.essential),
  ('School', 'school', 0xFF0EA5E9, PriorityTier.school),
  ('Toiletries', 'toiletries', 0xFF14B8A6, PriorityTier.essential),
  ('Laundry', 'laundry', 0xFF06B6D4, PriorityTier.essential),
  ('Rent/Hostel', 'rent', 0xFF64748B, PriorityTier.essential),
  ('Outings', 'outings', 0xFFEC4899, PriorityTier.wants),
  ('Church/Fellowship', 'church', 0xFFA16207, PriorityTier.essential),
  ('Bank & POS Charges', 'bank', 0xFF475569, PriorityTier.essential),
  ('Emergencies', 'emergency', 0xFFDC2626, PriorityTier.buffer),
  ('Other', 'other', 0xFF78716C, PriorityTier.wants),
];

const List<_SeedCat> _incomeSeeds = [
  ('Allowance', 'allowance', 0xFF16A34A, null),
  ('Gigs', 'gig', 0xFF0D9488, null),
  ('Gifts', 'gift', 0xFFD946EF, null),
  ('Other income', 'income_other', 0xFF65A30D, null),
];

Future<void> seedDefaults(AppDatabase db) async {
  await db.into(db.appSettings).insert(AppSettingsCompanion.insert());

  CategoriesCompanion row(_SeedCat c, CategoryKind kind, int order) =>
      CategoriesCompanion.insert(
        name: c.$1,
        kind: kind,
        iconKey: c.$2,
        colorValue: c.$3,
        tier: Value(c.$4),
        sortOrder: Value(order),
      );

  await db.batch((b) {
    b.insertAll(db.categories, [
      for (var i = 0; i < _expenseSeeds.length; i++)
        row(_expenseSeeds[i], CategoryKind.expense, i),
      for (var i = 0; i < _incomeSeeds.length; i++)
        row(_incomeSeeds[i], CategoryKind.income, i),
    ]);
  });
}