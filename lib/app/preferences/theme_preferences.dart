import 'package:flutter/material.dart';
import 'package:todolist_flutter/app/helpers/local_storage.dart';

class ThemePreferences {
    static const _keyThemeMode = 'theme_mode';

    static getThemeMode() {
        final int? themeModeIndex = LocalStorage.prefs.getInt(_keyThemeMode);
        return themeModeIndex != null ? ThemeMode.values[themeModeIndex] : ThemeMode.system;
    }

    static Future<bool> setThemeMode(ThemeMode themeMode) {
        return LocalStorage.prefs.setInt(_keyThemeMode, themeMode.index);
    }
}