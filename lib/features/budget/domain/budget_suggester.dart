import 'dart:math' show min;

import '../../../core/database/tables.dart';

/// Starting daily estimates per category icon, in kobo.
/// These only seed the first suggestion; users adjust every amount.
/// Categories with icons not listed here start at ₦0.
const Map<String, int> dailyBaselineKobo = {
  'food': 200000, // ₦2,000
  'transport': 80000, // ₦800
  'data': 30000, // ₦300
  'school': 20000, // ₦200
  'toiletries': 10000, // ₦100
  'laundry': 10000, // ₦100
  'rent': 0, // usually paid per session, so set it yourself
  'church': 10000, // ₦100
  'bank': 3000, // ₦30
  'outings': 30000, // ₦300
  'other': 10000, // ₦100
  'emergency': 0, // funded by the buffer rule instead
};

class CategorySlot {
  const CategorySlot({
    required this.id,
    required this.iconKey,
    required this.tier,
  });

  final int id;
  final String iconKey;
  final PriorityTier tier;
}

class BudgetSuggestion {
  const BudgetSuggestion({
    required this.plannedByCategory,
    required this.savingsKobo,
    required this.unallocatedKobo,
  });

  /// Every category is present, possibly with 0.
  final Map<int, int> plannedByCategory;
  final int savingsKobo;
  final int unallocatedKobo;
}

class BudgetSuggester {
  BudgetSuggester._();

  static const int bufferPercent = 10;
  static const int savingsPercent = 10;
  static const int _roundTo = 1000; // ₦10

  /// Survival-first: essentials → school → buffer → savings → wants.
  /// Planned + savings + unallocated always equals the available balance.
  static BudgetSuggestion suggest({
    required int availableKobo,
    required int days,
    required List<CategorySlot> categories,
    bool hasSavingsGoal = false,
  }) {
    final available = availableKobo < 0 ? 0 : availableKobo;
    final d = days < 1 ? 1 : days;
    final planned = {for (final c in categories) c.id: 0};
    var remaining = available;

    Map<int, int> needsFor(PriorityTier tier) => {
          for (final c in categories.where((c) => c.tier == tier))
            c.id: (dailyBaselineKobo[c.iconKey] ?? 0) * d,
        };

    // 1–2. Essentials, then school: funded in full, or scaled to fit.
    remaining -= _fund(planned, needsFor(PriorityTier.essential), remaining);
    remaining -= _fund(planned, needsFor(PriorityTier.school), remaining);

    // 3. Emergency buffer: a share of the whole balance.
    final bufferIds = [
      for (final c in categories)
        if (c.tier == PriorityTier.buffer) c.id,
    ];
    if (bufferIds.isNotEmpty) {
      final each =
          _roundDown(available * bufferPercent ~/ 100 ~/ bufferIds.length);
      remaining -=
          _fund(planned, {for (final id in bufferIds) id: each}, remaining);
    }

    // 4. Savings, only when there's a goal to save towards.
    var savings = 0;
    if (hasSavingsGoal) {
      savings = _roundDown(min(available * savingsPercent ~/ 100, remaining));
      remaining -= savings;
    }

    // 5. Wants get what's left, up to their estimate.
    remaining -= _fund(planned, needsFor(PriorityTier.wants), remaining);

    return BudgetSuggestion(
      plannedByCategory: planned,
      savingsKobo: savings,
      unallocatedKobo: remaining,
    );
  }

  /// Funds [needs] fully if [budget] allows, otherwise scales them down
  /// proportionally and gives any rounding leftover to the biggest need,
  /// so nothing goes to lower tiers. Returns the amount used.
  static int _fund(Map<int, int> planned, Map<int, int> needs, int budget) {
    final total = needs.values.fold(0, (a, b) => a + b);
    if (total <= 0 || budget <= 0) return 0;

    if (total <= budget) {
      for (final e in needs.entries) {
        planned[e.key] = planned[e.key]! + e.value;
      }
      return total;
    }

    var used = 0;
    var largestId = needs.keys.first;
    var largest = -1;
    for (final e in needs.entries) {
      final share = _roundDown(e.value * budget ~/ total);
      planned[e.key] = planned[e.key]! + share;
      used += share;
      if (e.value > largest) {
        largest = e.value;
        largestId = e.key;
      }
    }
    planned[largestId] = planned[largestId]! + (budget - used);
    return budget;
  }

  static int _roundDown(int kobo) => kobo - kobo % _roundTo;
}