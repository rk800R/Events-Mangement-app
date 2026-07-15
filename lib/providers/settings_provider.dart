import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../core/constants/app_constants.dart';

class SettingsProvider extends ChangeNotifier {
  ThemeMode _themeMode = ThemeMode.system;
  int _weekStart = AppConstants.weekStartDay;
  int _defaultDuration = AppConstants.defaultEventDurationMinutes;

  ThemeMode get themeMode => _themeMode;
  int get weekStart => _weekStart;
  int get defaultDuration => _defaultDuration;

  Future<void> load() async {
    final prefs = await SharedPreferences.getInstance();
    final themeIndex = prefs.getInt(AppConstants.themeModeKey);
    if (themeIndex != null && themeIndex >= 0 && themeIndex < 3) {
      _themeMode = ThemeMode.values[themeIndex];
    }
    _weekStart = prefs.getInt('week_start') ?? AppConstants.weekStartDay;
    _defaultDuration = prefs.getInt('default_duration') ??
        AppConstants.defaultEventDurationMinutes;
    notifyListeners();
  }

  Future<void> setThemeMode(ThemeMode mode) async {
    _themeMode = mode;
    notifyListeners();
    final prefs = await SharedPreferences.getInstance();
    await prefs.setInt(AppConstants.themeModeKey, mode.index);
  }

  Future<void> setWeekStart(int day) async {
    _weekStart = day;
    notifyListeners();
    final prefs = await SharedPreferences.getInstance();
    await prefs.setInt('week_start', day);
  }

  Future<void> setDefaultDuration(int minutes) async {
    _defaultDuration = minutes;
    notifyListeners();
    final prefs = await SharedPreferences.getInstance();
    await prefs.setInt('default_duration', minutes);
  }
}
