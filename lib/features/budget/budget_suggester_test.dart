import 'package:flutter_test/flutter_test.dart';
import 'package:kobo/core/database/tables.dart';
import 'package:kobo/core/dates.dart';
import 'package:kobo/features/budget/domain/budget_suggester.dart';

int n(int naira) => naira * 100;

const slots = [
  CategorySlot(id: 1, iconKey: 'food', tier: PriorityTier.essential),
  CategorySlot(id: 2, iconKey: 'transport', tier: PriorityTier.essential),
  CategorySlot(id: 3, iconKey: 'data', tier: PriorityTier.essential),
  CategorySlot(id: 4, iconKey: 'school', tier: PriorityTier.school),
  CategorySlot(id: 5, iconKey: 'toiletries', tier: PriorityTier.essential),
  CategorySlot(id: 6, iconKey: 'laundry', tier: PriorityTier.essential),
  CategorySlot(id: 7, iconKey: 'rent', tier: PriorityTier.essential),
  CategorySlot(id: 8, iconKey: 'outings', tier: PriorityTier.wants),
  CategorySlot(id: 9, iconKey: 'church', tier: PriorityTier.essential),
  CategorySlot(id: 10, iconKey: 'bank', tier: PriorityTier.essential),
  CategorySlot(id: 11, iconKey: 'emergency', tier: PriorityTier.buffer),
  CategorySlot(id: 12, iconKey: 'other', tier: PriorityTier.wants),
];

int total(BudgetSuggestion s) =>
    s.plannedByCategory.values.fold(0, (a, b) => a + b) +
    s.savingsKobo +
    s.unallocatedKobo;

int tierSum(BudgetSuggestion s, PriorityTier tier) => slots
    .where((c) => c.tier == tier)
    .fold(0, (a, c) => a + s.plannedByCategory[c.id]!);

void main() {
  group('BudgetSuggester', () {
    test('comfortable balance funds every tier in full', () {
      final s = BudgetSuggester.suggest(
        availableKobo: n(300000),
        days: 30,
        categories: slots,
        hasSavingsGoal: true,
      );
      expect(s.plannedByCategory[1], n(60000)); // food 2,000 × 30
      expect(s.plannedByCategory[2], n(24000)); // transport
      expect(s.plannedByCategory[4], n(6000)); // school
      expect(s.plannedByCategory[7], 0); // rent left for the user
      expect(s.plannedByCategory[11], n(30000)); // 10% buffer
      expect(s.savingsKobo, n(30000)); // 10% savings
      expect(s.plannedByCategory[8], n(9000)); // outings
      expect(s.unallocatedKobo, n(119100));
      expect(total(s), n(300000));
    });

    test('no savings goal means no savings line', () {
      final s = BudgetSuggester.suggest(
        availableKobo: n(300000),
        days: 30,
        categories: slots,
      );
      expect(s.savingsKobo, 0);
      expect(s.unallocatedKobo, n(149100));
    });

    test('tight balance goes entirely to essentials', () {
      final s = BudgetSuggester.suggest(
        availableKobo: n(50000),
        days: 30,
        categories: slots,
        hasSavingsGoal: true,
      );
      expect(tierSum(s, PriorityTier.essential), n(50000));
      expect(tierSum(s, PriorityTier.school), 0);
      expect(tierSum(s, PriorityTier.buffer), 0);
      expect(tierSum(s, PriorityTier.wants), 0);
      expect(s.savingsKobo, 0);
      expect(s.unallocatedKobo, 0);
      expect(s.plannedByCategory[1]!,
          greaterThan(s.plannedByCategory[2]!)); // food > transport
    });

    test('zero balance plans nothing', () {
      final s = BudgetSuggester.suggest(
        availableKobo: 0,
        days: 30,
        categories: slots,
        hasSavingsGoal: true,
      );
      expect(s.plannedByCategory.values.every((v) => v == 0), isTrue);
      expect(s.savingsKobo, 0);
      expect(s.unallocatedKobo, 0);
    });

    test('negative balance is treated as zero', () {
      final s = BudgetSuggester.suggest(
        availableKobo: -n(5000),
        days: 30,
        categories: slots,
      );
      expect(s.plannedByCategory.values.every((v) => v == 0), isTrue);
      expect(s.unallocatedKobo, 0);
    });

    test('zero or negative days are treated as one day', () {
      for (final days in [0, -3]) {
        final s = BudgetSuggester.suggest(
          availableKobo: n(100000),
          days: days,
          categories: slots,
        );
        expect(s.plannedByCategory[1], n(2000));
      }
    });

    test('custom category with unknown icon starts at zero', () {
      final s = BudgetSuggester.suggest(
        availableKobo: n(300000),
        days: 30,
        categories: const [
          ...slots,
          CategorySlot(id: 99, iconKey: 'gym', tier: PriorityTier.wants),
        ],
      );
      expect(s.plannedByCategory[99], 0);
    });

    test('everything always adds up to the balance, never negative', () {
      for (final available in [
        0, 1, 99, n(1000), n(50000), n(123457) + 37, n(10000000),
      ]) {
        for (final days in [1, 7, 30, 90]) {
          for (final goal in [true, false]) {
            final s = BudgetSuggester.suggest(
              availableKobo: available,
              days: days,
              categories: slots,
              hasSavingsGoal: goal,
            );
            expect(total(s), available,
                reason: 'available=$available days=$days goal=$goal');
            expect(s.plannedByCategory.values.every((v) => v >= 0), isTrue);
            expect(s.savingsKobo, greaterThanOrEqualTo(0));
            expect(s.unallocatedKobo, greaterThanOrEqualTo(0));
          }
        }
      }
    });
  });

  group('cycleDays', () {
    final now = DateTime(2026, 10, 13, 22, 0);

    test('date already passed counts as 1 day', () {
      expect(cycleDays(DateTime(2026, 10, 1), now: now), 1);
    });
    test('today counts as 1 day', () {
      expect(cycleDays(DateTime(2026, 10, 13), now: now), 1);
    });
    test('tomorrow late at night is still 1 day', () {
      expect(cycleDays(DateTime(2026, 10, 14), now: now), 1);
    });
    test('30 days ahead', () {
      expect(cycleDays(DateTime(2026, 11, 12), now: now), 30);
    });
  });
}