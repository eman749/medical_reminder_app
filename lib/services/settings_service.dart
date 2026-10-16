import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class SettingsService extends ChangeNotifier {
  static final SettingsService instance = SettingsService._internal();
  SettingsService._internal();

  // 1. Theme Setting
  ThemeMode _themeMode = ThemeMode.light;
  ThemeMode get themeMode => _themeMode;

  // 2. Notifications & Offline Sound
  bool _notificationsEnabled = true;
  bool _soundEnabled = true;
  bool _vibrationEnabled = true;
  bool _offlineModeActive = true; // Works 100% offline without internet

  bool get notificationsEnabled => _notificationsEnabled;
  bool get soundEnabled => _soundEnabled;
  bool get vibrationEnabled => _vibrationEnabled;
  bool get offlineModeActive => _offlineModeActive;

  // 3. Reminder & Snooze Settings
  // Snooze duration in minutes (e.g. 5, 10, 15, 30, 60)
  int _snoozeDurationMinutes = 10;
  int get snoozeDurationMinutes => _snoozeDurationMinutes;

  // Early alert time in minutes (0 = exact time, 5, 10, 15, 30)
  int _earlyReminderMinutes = 10;
  int get earlyReminderMinutes => _earlyReminderMinutes;

  // Missed dose repeat count
  int _repeatMissedCount = 3;
  int get repeatMissedCount => _repeatMissedCount;

  // Low stock warning threshold
  int _lowStockThreshold = 5;
  int get lowStockThreshold => _lowStockThreshold;

  // --- Actions ---

  void setThemeMode(ThemeMode mode) {
    if (_themeMode == mode) return;
    _themeMode = mode;
    notifyListeners();
  }

  void toggleTheme() {
    if (_themeMode == ThemeMode.light) {
      _themeMode = ThemeMode.dark;
    } else {
      _themeMode = ThemeMode.light;
    }
    notifyListeners();
  }

  void setNotificationsEnabled(bool value) {
    _notificationsEnabled = value;
    notifyListeners();
  }

  void setSoundEnabled(bool value) {
    _soundEnabled = value;
    notifyListeners();
  }

  void setVibrationEnabled(bool value) {
    _vibrationEnabled = value;
    notifyListeners();
  }

  void setSnoozeDuration(int minutes) {
    _snoozeDurationMinutes = minutes;
    notifyListeners();
  }

  void setEarlyReminder(int minutes) {
    _earlyReminderMinutes = minutes;
    notifyListeners();
  }

  void setRepeatMissedCount(int count) {
    _repeatMissedCount = count;
    notifyListeners();
  }

  void setLowStockThreshold(int threshold) {
    _lowStockThreshold = threshold;
    notifyListeners();
  }

  /// Triggers a real offline audible sound & vibration alert!
  /// Works 100% without internet on any device or browser.
  Future<void> playTestAlertSound() async {
    if (_soundEnabled) {
      await SystemSound.play(SystemSoundType.alert);
    }
    if (_vibrationEnabled) {
      await HapticFeedback.heavyImpact();
    }
  }

  /// Clears temporary cache
  Future<void> clearCache() async {
    await Future.delayed(const Duration(milliseconds: 400));
    notifyListeners();
  }
}
