import 'package:shared_preferences/shared_preferences.dart';

class SharedServices {
  static SharedPreferences? _preferences;

  static Future<void> _getPreferences() async {
    _preferences ??= await SharedPreferences.getInstance();
  }

  static Future<void> saveBool(String key, bool value) async {
    await _getPreferences();
    await _preferences!.setBool(key, value);
  }

  static Future<bool?> getBool(String key) async {
    await _getPreferences();
    return _preferences!.getBool(key);
  }

  static Future<void> saveInt(String key, int value) async {
    await _getPreferences();
    await _preferences!.setInt(key, value);
  }

  static Future<int?> getInt(String key) async {
    await _getPreferences();
    return _preferences!.getInt(key);
  }
}
