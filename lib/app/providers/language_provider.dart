import 'package:flutter/material.dart';

class LanguageProvider with ChangeNotifier {

    Locale _language;

    LanguageProvider({required Locale languageLocale}): _language = languageLocale;

    Locale get language => _language;

    void setLanguage(Locale language) {
        _language = language;
        notifyListeners();
    }
}