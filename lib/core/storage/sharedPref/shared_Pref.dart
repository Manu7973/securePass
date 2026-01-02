import 'package:shared_preferences/shared_preferences.dart';

class SharedPref {
  static SharedPreferences? _prefs;

  static Future<void> init() async {
    _prefs = await SharedPreferences.getInstance();
  }

  static Future<bool> setString(String key, String value) async {
    return await _prefs!.setString(key, value);
  }

  static Future<bool> setBool(String key, bool value) async {
    return await _prefs!.setBool(key, value);
  }

  static String? getString(String key) {
    return _prefs!.getString(key);
  }

  static bool? getBool(String key) {
    return _prefs!.getBool(key);
  }

  static Future<bool> clear() async {
    return await _prefs!.clear();
  }
}