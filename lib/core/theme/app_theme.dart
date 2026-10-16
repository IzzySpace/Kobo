import 'dart:ui' show FontFeature, FontVariation;

import 'package:flutter/material.dart';

import '../database/tables.dart';

const String kDisplayFont = 'Bricolage';

/// Taken from the naira note: deep note green, the pale mint of note
/// paper, ink, and a brass accent kept for savings.
abstract final class KoboPalette {
  static const note = Color(0xFF0E5A43);
  static const noteNight = Color(0xFF0F4535);
  static const onNote = Color(0xFFF2FBF6);
  static const paper = Color(0xFFEEF4EF);
  static const ink = Color(0xFF0B2A20);
  static const brass = Color(0xFFC9A13B);
  static const brassNight = Color(0xFFE2C062);
  static const night = Color(0xFF07150F);
  static const mint = Color(0xFF5BD3A0);
}

/// Bricolage Grotesque is a variable font. Weight, width and optical size
/// are set as axes so large numbers get the display cut of the letters.
TextStyle displayStyle(
  double size, {
  double weight = 700,
  double width = 100,
  double? height,
  Color? color,
}) =>
    TextStyle(
      fontFamily: kDisplayFont,
      fontSize: size,
      fontWeight: FontWeight.values[((weight / 100).round() - 1).clamp(0, 8)],
      fontVariations: [
        FontVariation('wght', weight),
        FontVariation('wdth', width),
        FontVariation('opsz', size.clamp(12, 96).toDouble()),
      ],
      letterSpacing: size >= 28 ? -size * 0.025 : -0.1,
      height: height ?? 1.12,
      color: color,
    );

/// One colour per budget priority, used for the allocation bar and dots.
Color tierColor(PriorityTier tier) => switch (tier) {
      PriorityTier.essential => const Color(0xFF6FD6A8),
      PriorityTier.school => const Color(0xFF7DB8F5),
      PriorityTier.buffer => const Color(0xFFF5A06B),
      PriorityTier.savings => const Color(0xFFE7C35A),
      PriorityTier.wants => const Color(0xFFD6A1F0),
    };

@immutable
class KoboColors extends ThemeExtension<KoboColors> {
  const KoboColors({
    required this.good,
    required this.warn,
    required this.danger,
    required this.brass,
    required this.note,
    required this.onNote,
  });

  final Color good;
  final Color warn;
  final Color danger;
  final Color brass;
  final Color note;
  final Color onNote;

  @override
  KoboColors copyWith({
    Color? good,
    Color? warn,
    Color? danger,
    Color? brass,
    Color? note,
    Color? onNote,
  }) =>
      KoboColors(
        good: good ?? this.good,
        warn: warn ?? this.warn,
        danger: danger ?? this.danger,
        brass: brass ?? this.brass,
        note: note ?? this.note,
        onNote: onNote ?? this.onNote,
      );

  @override
  KoboColors lerp(ThemeExtension<KoboColors>? other, double t) {
    if (other is! KoboColors) return this;
    return KoboColors(
      good: Color.lerp(good, other.good, t)!,
      warn: Color.lerp(warn, other.warn, t)!,
      danger: Color.lerp(danger, other.danger, t)!,
      brass: Color.lerp(brass, other.brass, t)!,
      note: Color.lerp(note, other.note, t)!,
      onNote: Color.lerp(onNote, other.onNote, t)!,
    );
  }
}

extension KoboThemeX on BuildContext {
  KoboColors get koboColors => Theme.of(this).extension<KoboColors>()!;
}

extension AmountTextX on TextTheme {
  /// Money style: heavy, slightly narrow, tabular so digits don't jump.
  TextStyle amount(double size, {Color? color}) =>
      displayStyle(size, weight: 760, width: 86, height: 1.0, color: color)
          .copyWith(fontFeatures: const [FontFeature.tabularFigures()]);
}

class AppTheme {
  static ThemeData light() => _build(Brightness.light);
  static ThemeData dark() => _build(Brightness.dark);

  static ThemeMode modeFrom(AppThemeMode m) => switch (m) {
        AppThemeMode.light => ThemeMode.light,
        AppThemeMode.dark => ThemeMode.dark,
        AppThemeMode.system => ThemeMode.system,
      };

  static ThemeData _build(Brightness brightness) {
    final dark = brightness == Brightness.dark;

    final scheme = ColorScheme.fromSeed(
      seedColor: KoboPalette.note,
      brightness: brightness,
      dynamicSchemeVariant: DynamicSchemeVariant.fidelity,
    ).copyWith(
      primary: dark ? KoboPalette.mint : KoboPalette.note,
      onPrimary: dark ? KoboPalette.night : Colors.white,
      surface: dark ? KoboPalette.night : KoboPalette.paper,
      onSurface: dark ? const Color(0xFFE4F1EA) : KoboPalette.ink,
      surfaceContainerLowest: dark ? const Color(0xFF0D1F17) : Colors.white,
      surfaceContainerLow:
          dark ? const Color(0xFF11251C) : const Color(0xFFF6FAF7),
      surfaceContainer: dark ? const Color(0xFF152C22) : const Color(0xFFE6EEE8),
      surfaceContainerHigh:
          dark ? const Color(0xFF1A3428) : const Color(0xFFDDE8E0),
    );

    final base = ThemeData(brightness: brightness, useMaterial3: true).textTheme;
    final textTheme = base
        .copyWith(
          displayLarge: displayStyle(56, weight: 800),
          displayMedium: displayStyle(44, weight: 780),
          displaySmall: displayStyle(36, weight: 760),
          headlineLarge: displayStyle(32, weight: 740),
          headlineMedium: displayStyle(28, weight: 720),
          headlineSmall: displayStyle(24, weight: 700),
          titleLarge: displayStyle(21, weight: 680),
        )
        .apply(bodyColor: scheme.onSurface, displayColor: scheme.onSurface);

    final radius = BorderRadius.circular(18);

    return ThemeData(
      useMaterial3: true,
      colorScheme: scheme,
      scaffoldBackgroundColor: scheme.surface,
      textTheme: textTheme,
      cardTheme: CardThemeData(
        elevation: 0,
        margin: EdgeInsets.zero,
        color: scheme.surfaceContainerLowest,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(22)),
      ),
      filledButtonTheme: FilledButtonThemeData(
        style: FilledButton.styleFrom(
          minimumSize: const Size(64, 56),
          shape: RoundedRectangleBorder(borderRadius: radius),
          textStyle: displayStyle(17, weight: 650),
        ),
      ),
      outlinedButtonTheme: OutlinedButtonThemeData(
        style: OutlinedButton.styleFrom(
          minimumSize: const Size(64, 52),
          shape: RoundedRectangleBorder(borderRadius: radius),
          side: BorderSide(color: scheme.outlineVariant),
        ),
      ),
      textButtonTheme: TextButtonThemeData(
        style: TextButton.styleFrom(
          textStyle: const TextStyle(fontWeight: FontWeight.w600),
        ),
      ),
      chipTheme: const ChipThemeData(shape: StadiumBorder()),
      bottomSheetTheme: BottomSheetThemeData(
        backgroundColor: scheme.surfaceContainerLowest,
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(top: Radius.circular(28)),
        ),
      ),
      dialogTheme: DialogThemeData(
        backgroundColor: scheme.surfaceContainerLowest,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(28)),
      ),
      snackBarTheme: SnackBarThemeData(
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
      ),
      extensions: [
        KoboColors(
          good: dark ? const Color(0xFF4ADE80) : const Color(0xFF16A34A),
          warn: dark ? const Color(0xFFFBBF24) : const Color(0xFFD97706),
          danger: dark ? const Color(0xFFF87171) : const Color(0xFFD64545),
          brass: dark ? KoboPalette.brassNight : KoboPalette.brass,
          note: dark ? KoboPalette.noteNight : KoboPalette.note,
          onNote: KoboPalette.onNote,
        ),
      ],
    );
  }
}
