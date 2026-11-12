import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'app_colors.dart';

class AppTheme {
  static const poppinsRegular = 'Roboto-regular';
  static const poppinsMedium = 'Roboto-medium';
  static const poppinsBold = 'Roboto-bold';
  static TextStyle primaryFont(TextStyle? style) =>
      GoogleFonts.poppins(textStyle: style);
  static ThemeData run() => lightTheme;
  static final ThemeData lightTheme = _create(Brightness.light);
  static final ThemeData darkTheme = _create(Brightness.dark);

  static ThemeData _create(Brightness brightness) {
    final dark = brightness == Brightness.dark;
    final scheme = ColorScheme.fromSeed(
      seedColor: AppColors.primary,
      brightness: brightness,
      surface: dark ? const Color(0xFF1B2230) : Colors.white,
    );
    return ThemeData(
      brightness: brightness,
      colorScheme: scheme,
      scaffoldBackgroundColor:
          dark ? const Color(0xFF111722) : const Color(0xFFF6F7FB),
      cardColor: scheme.surface,
      dividerColor: scheme.outlineVariant,
      appBarTheme: AppBarTheme(
        backgroundColor: dark ? scheme.surface : AppColors.primary,
        foregroundColor: dark ? scheme.onSurface : Colors.white,
        elevation: 0,
      ),
      bottomSheetTheme: BottomSheetThemeData(backgroundColor: scheme.surface),
      dialogTheme: DialogThemeData(backgroundColor: scheme.surface),
      bottomNavigationBarTheme: BottomNavigationBarThemeData(
        backgroundColor: scheme.surface,
        selectedItemColor: scheme.primary,
        unselectedItemColor: scheme.onSurfaceVariant,
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: scheme.surfaceContainer,
        hintStyle: TextStyle(color: scheme.onSurfaceVariant),
      ),
      switchTheme: SwitchThemeData(
        thumbColor: WidgetStateProperty.resolveWith((states) =>
            states.contains(WidgetState.selected)
                ? scheme.onPrimary
                : scheme.outline),
        trackColor: WidgetStateProperty.resolveWith((states) =>
            states.contains(WidgetState.selected)
                ? scheme.primary
                : scheme.surfaceContainerHighest),
      ),
    );
  }

  static List<Color> gradient(BuildContext context, List<Color> lightColors) {
    final theme = Theme.of(context);
    if (theme.brightness == Brightness.light) return lightColors;
    return List.generate(
        lightColors.length,
        (index) => Color.lerp(
              theme.colorScheme.surfaceContainerLow,
              theme.colorScheme.surfaceContainerHighest,
              lightColors.length > 1 ? index / (lightColors.length - 1) : 0,
            )!);
  }

  /// Retain existing colors in light mode and provide readable dark equivalents.
  static Color foreground(BuildContext context, Color lightColor) =>
      Theme.of(context).brightness == Brightness.dark
          ? Theme.of(context).colorScheme.onSurface
          : lightColor;
  static Color muted(BuildContext context, Color lightColor) =>
      Theme.of(context).brightness == Brightness.dark
          ? Theme.of(context).colorScheme.onSurfaceVariant
          : lightColor;
  static Color surface(BuildContext context, Color lightColor) =>
      Theme.of(context).brightness == Brightness.dark
          ? Theme.of(context).colorScheme.surface
          : lightColor;
  static Color outline(BuildContext context, Color lightColor) =>
      Theme.of(context).brightness == Brightness.dark
          ? Theme.of(context).colorScheme.outline
          : lightColor;
  static Color raisedSurface(BuildContext context, Color lightColor) =>
      Theme.of(context).brightness == Brightness.dark
          ? Theme.of(context).colorScheme.surfaceContainerHighest
          : lightColor;
  static Color accent(BuildContext context, Color lightColor) =>
      Theme.of(context).brightness == Brightness.dark
          ? Theme.of(context).colorScheme.primary
          : lightColor;
}
