import 'package:shared_preferences/shared_preferences.dart';

/// Manager class for handling shared preferences operations
class SharedPrefsManager {
  static const String _firstLaunchKey = 'is_first_launch';
  
  /// Checks if this is the first launch of the application
  static Future<bool> isFirstLaunch() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getBool(_firstLaunchKey) ?? true;
  }
  
  /// Updates the first launch status to false
  static Future<void> setFirstLaunchComplete() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(_firstLaunchKey, false);
  }
} 