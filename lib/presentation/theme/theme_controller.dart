import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';

const themePreferenceKey = 'app_theme_mode';
final themePreferencesProvider = Provider<SharedPreferences>(
  (ref) => throw StateError('Theme preferences must be initialized at startup'),
);
final themeModeProvider = StateNotifierProvider<ThemeModeController, ThemeMode>(
  (ref) => ThemeModeController(ref.watch(themePreferencesProvider)),
);

class ThemeModeController extends StateNotifier<ThemeMode> {
  ThemeModeController(this.preferences)
      : super(preferences.getString(themePreferenceKey) == 'dark'
            ? ThemeMode.dark
            : ThemeMode.light);

  final SharedPreferences preferences;

  Future<void> setDarkMode(bool enabled) async {
    final previous = state;
    state = enabled ? ThemeMode.dark : ThemeMode.light;
    try {
      if (!await preferences.setString(
          themePreferenceKey, enabled ? 'dark' : 'light')) {
        throw StateError('Unable to save theme preference');
      }
    } catch (_) {
      if (mounted) state = previous;
      rethrow;
    }
  }
}
