import 'package:flutter/material.dart';

class ThemeProvider with ChangeNotifier {

    ThemeMode _themeMode;

    ThemeProvider({required ThemeMode themeMode}): _themeMode = themeMode;

    ThemeMode get themeMode => _themeMode;

    setThemeMode(ThemeMode mode) {
        _themeMode = mode;
        notifyListeners();
    }
}