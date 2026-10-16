import '../database/tables.dart';

extension PriorityTierLabel on PriorityTier {
  String get label => switch (this) {
        PriorityTier.essential => 'Essentials',
        PriorityTier.school => 'School',
        PriorityTier.buffer => 'Emergency buffer',
        PriorityTier.savings => 'Savings',
        PriorityTier.wants => 'Wants',
      };

  String get shortLabel => switch (this) {
        PriorityTier.essential => 'Essential',
        PriorityTier.school => 'School',
        PriorityTier.buffer => 'Buffer',
        PriorityTier.savings => 'Savings',
        PriorityTier.wants => 'Want',
      };
}

extension IncomeFrequencyLabel on IncomeFrequency {
  String get label => switch (this) {
        IncomeFrequency.weekly => 'Weekly',
        IncomeFrequency.monthly => 'Monthly',
        IncomeFrequency.irregular => 'Irregular',
      };
}