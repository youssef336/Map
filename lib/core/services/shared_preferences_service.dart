import 'package:shared_preferences/shared_preferences.dart';

class Prefs {
  static late SharedPreferences _preferences;
  static Future<void> init() async {
    _preferences = await SharedPreferences.getInstance();
  }

  static setBool(String key, bool value) async {
    await _preferences.setBool(key, value);
  }

  static bool getBool(String key) {
    return _preferences.getBool(key) ?? false;
  }
}
