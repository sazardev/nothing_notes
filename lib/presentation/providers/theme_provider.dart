import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../core/theme/app_theme.dart';

final sharedPreferencesProvider = Provider<SharedPreferences>((ref) {
  throw UnimplementedError('SharedPreferences not initialized');
});

final themeModeProvider = StateNotifierProvider<ThemeModeNotifier, ThemeMode>((ref) {
  final prefs = ref.watch(sharedPreferencesProvider);
  return ThemeModeNotifier(prefs);
});

class ThemeModeNotifier extends StateNotifier<ThemeMode> {
  final SharedPreferences _prefs;
  static const _key = 'theme_mode';

  ThemeModeNotifier(this._prefs) : super(_loadTheme(_prefs));

  static ThemeMode _loadTheme(SharedPreferences prefs) {
    final value = prefs.getString(_key);
    if (value == 'light') return ThemeMode.light;
    return ThemeMode.dark;
  }

  void toggleTheme() {
    final newMode = state == ThemeMode.dark ? ThemeMode.light : ThemeMode.dark;
    state = newMode;
    _prefs.setString(_key, newMode == ThemeMode.light ? 'light' : 'dark');
  }

  void setTheme(ThemeMode mode) {
    state = mode;
    _prefs.setString(_key, mode == ThemeMode.light ? 'light' : 'dark');
  }
}

final appThemeProvider = Provider<AppTheme>((ref) {
  final mode = ref.watch(themeModeProvider);
  return mode == ThemeMode.dark ? AppTheme.dark() : AppTheme.light();
});
