import 'package:flutter/material.dart';
import 'package:todolist_flutter/app/helpers/local_storage.dart';
import 'package:todolist_flutter/config/app.dart';

class LanguagePreferences {
    static const _keyLanguageMode = 'language_mode';

    static getLanguageMode() {
        final String? languageModeIndex = LocalStorage.prefs.getString(_keyLanguageMode);
        return languageModeIndex ?? appLang;
    }

    static Future<bool> setLanguageMode(Locale languageMode) {
        return LocalStorage.prefs.setString(_keyLanguageMode, languageMode.toString());
    }
}