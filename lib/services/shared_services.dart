import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';
import 'package:zip_search/model/address_model.dart';

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

  static Future<void> saveListString(
      String key, List<AddressModel> addressList) async {
    await _getPreferences();

    List<String> encodedList =
        addressList.map((address) => jsonEncode(address.toJson())).toList();

    await _preferences!.setStringList(key, encodedList);
  }

  static Future<List<AddressModel>> getListString(String key) async {
    await _getPreferences();

    final jsonList = _preferences!.getStringList(key) ?? [];

    return jsonList.map((e) => AddressModel.fromJson(json.decode(e))).toList();
  }
}
