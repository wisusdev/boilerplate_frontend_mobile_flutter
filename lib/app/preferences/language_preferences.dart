import 'package:flutter/material.dart';
import 'package:boilerplate_frontend_mobile_flutter/app/helpers/local_storage.dart';
import 'package:boilerplate_frontend_mobile_flutter/config/app.dart';

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