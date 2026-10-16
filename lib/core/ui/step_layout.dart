import 'package:flutter/material.dart';

/// Scrollable content with the main button pinned to the bottom.
class StepLayout extends StatelessWidget {
  const StepLayout({
    super.key,
    required this.title,
    this.subtitle,
    required this.children,
    required this.primaryLabel,
    required this.onPrimary,
    this.secondaryLabel,
    this.onSecondary,
  });

  final String title;
  final String? subtitle;
  final List<Widget> children;
  final String primaryLabel;
  final VoidCallback? onPrimary;
  final String? secondaryLabel;
  final VoidCallback? onSecondary;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return SafeArea(
      top: false,
      child: Column(
        children: [
          Expanded(
            child: ListView(
              padding: const EdgeInsets.fromLTRB(24, 12, 24, 24),
              children: [
                Text(title, style: theme.textTheme.headlineMedium),
                if (subtitle != null) ...[
                  const SizedBox(height: 10),
                  Text(
                    subtitle!,
                    style: theme.textTheme.bodyLarge?.copyWith(
                      color: theme.colorScheme.onSurfaceVariant,
                      height: 1.4,
                    ),
                  ),
                ],
                const SizedBox(height: 28),
                ...children,
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(24, 8, 24, 16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                FilledButton(onPressed: onPrimary, child: Text(primaryLabel)),
                if (secondaryLabel != null) ...[
                  const SizedBox(height: 4),
                  TextButton(
                    onPressed: onSecondary,
                    child: Text(secondaryLabel!),
                  ),
                ],
              ],
            ),
          ),
        ],
      ),
    );
  }
}
