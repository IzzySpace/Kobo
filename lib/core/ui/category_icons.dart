import 'package:flutter/material.dart';

const Map<String, IconData> categoryIcons = {
  'food': Icons.restaurant_rounded,
  'transport': Icons.directions_bus_rounded,
  'data': Icons.wifi_rounded,
  'school': Icons.school_rounded,
  'toiletries': Icons.soap,
  'laundry': Icons.local_laundry_service_rounded,
  'rent': Icons.home_rounded,
  'outings': Icons.celebration_rounded,
  'church': Icons.church,
  'bank': Icons.account_balance_rounded,
  'emergency': Icons.health_and_safety_rounded,
  'other': Icons.more_horiz_rounded,
  'health': Icons.medical_services_rounded,
  'shopping': Icons.shopping_bag_rounded,
  'family': Icons.family_restroom_rounded,
  'gym': Icons.fitness_center_rounded,
  'books': Icons.menu_book_rounded,
  'subscriptions': Icons.subscriptions_rounded,
  'allowance': Icons.account_balance_wallet_rounded,
  'gig': Icons.work_rounded,
  'gift': Icons.card_giftcard_rounded,
  'income_other': Icons.add_card,
};

/// Icons offered when creating or editing an expense category.
const List<String> expenseIconKeys = [
  'food', 'transport', 'data', 'school', 'toiletries', 'laundry',
  'rent', 'outings', 'church', 'bank', 'emergency', 'health',
  'shopping', 'family', 'gym', 'books', 'subscriptions', 'other',
];

const List<int> categoryPalette = [
  0xFFE07A2E, 0xFF3B82F6, 0xFF8B5CF6, 0xFF0EA5E9, 0xFF14B8A6,
  0xFFEC4899, 0xFFA16207, 0xFF16A34A, 0xFFDC2626, 0xFF6366F1,
];

IconData iconFor(String key) => categoryIcons[key] ?? Icons.label_rounded;

class CategoryAvatar extends StatelessWidget {
  const CategoryAvatar({
    super.key,
    required this.iconKey,
    required this.colorValue,
    this.radius = 20,
  });

  final String iconKey;
  final int colorValue;
  final double radius;

  @override
  Widget build(BuildContext context) {
    final color = Color(colorValue);
    return CircleAvatar(
      radius: radius,
      backgroundColor: color.withValues(alpha: 0.15),
      child: Icon(iconFor(iconKey), color: color, size: radius),
    );
  }
}