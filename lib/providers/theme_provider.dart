import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';

final themeProvider = StateNotifierProvider<ThemeNotifier, bool>((ref) {
  return ThemeNotifier();
});

class ThemeNotifier extends StateNotifier<bool> {
  ThemeNotifier() : super(false) {
    _loadThemePreference();
  }

  // Load theme preference from SharedPreferences
  Future<void> _loadThemePreference() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    bool? savedTheme = prefs.getBool('isDarkMode');
    if (savedTheme != null) {
      state = savedTheme;
    }
  }

  // Save theme preference to SharedPreferences
  Future<void> toggleTheme() async {
    state = !state;
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setBool('isDarkMode', state);
  }
}
