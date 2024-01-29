import 'package:flutter/material.dart';

class ThemeProvider extends ChangeNotifier {
  bool _isDarkMode = false;
  MaterialColor _primarySwatch = Colors.deepPurple;

  bool get isDarkMode => _isDarkMode;
  MaterialColor get primarySwatch => _primarySwatch;

  void toggleDarkMode() {
    _isDarkMode = !_isDarkMode;
    _primarySwatch = _isDarkMode ? Colors.blue : Colors.deepPurple;
    notifyListeners();
  }
}
