import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'core/providers.dart';
import 'core/theme/app_theme.dart';
import 'features/settings/lock_gate.dart';
import 'features/shell/app_shell.dart';
import 'features/onboarding/onboarding_screen.dart';

class KoboApp extends ConsumerWidget {
  const KoboApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final settings = ref.watch(settingsProvider);
    final themeMode = switch (settings) {
      AsyncData(:final value) => AppTheme.modeFrom(value.themeMode),
      _ => ThemeMode.system,
    };

    return MaterialApp(
      title: 'Kobo',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.light(),
      darkTheme: AppTheme.dark(),
      themeMode: themeMode,
      home: switch (settings) {
        AsyncData(:final value) => value.onboardingDone
            ? const LockGate(child: AppShell())
            : const OnboardingScreen(),
        AsyncError(:final error) => Scaffold(
            body: Center(
              child: Padding(
                padding: const EdgeInsets.all(24),
                child: Text(
                  'Kobo couldn’t open its data.\n$error',
                  textAlign: TextAlign.center,
                ),
              ),
            ),
          ),
        _ => const Scaffold(body: Center(child: CircularProgressIndicator())),
      },
    );
  }
}