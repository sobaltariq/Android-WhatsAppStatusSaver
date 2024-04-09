import 'package:flutter/material.dart';

class ThemeManager extends ChangeNotifier {
  // ThemeMode _themeMode = ThemeMode.dark;
  //
  // ThemeMode get getThemeMode => _themeMode;
  //
  // toggleTheme(themeMode) {
  //   _themeMode = themeMode;
  //   notifyListeners();
  //   // log(_themeMode.toString());
  // }
  bool _isDarkMode = false;

  bool get isDarkMode => _isDarkMode;

  void toggleTheme() {
    _isDarkMode = !_isDarkMode;
    notifyListeners();
  }
}
