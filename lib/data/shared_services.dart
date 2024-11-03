import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';
import 'package:zip_search/core/model/favorite_model.dart';

class SharedServices {
  static SharedPreferences? _preferences;

  static Future<void> _getPreferences() async {
    _preferences ??= await SharedPreferences.getInstance();
  }

  Future<void> saveBool(String key, bool value) async {
    await _getPreferences();
    await _preferences!.setBool(key, value);
  }

  Future<bool?> getBool(String key) async {
    await _getPreferences();
    return _preferences!.getBool(key);
  }

  Future<void> saveInt(String key, int value) async {
    await _getPreferences();
    await _preferences!.setInt(key, value);
  }

  Future<int?> getInt(String key) async {
    await _getPreferences();
    return _preferences!.getInt(key);
  }

  Future<void> saveListString(
    String key,
    List<FavoriteModel> favoriteAddressList,
  ) async {
    await _getPreferences();

    List<String> encodedList = favoriteAddressList
        .map((address) => jsonEncode(address.toJson()))
        .toList();

    await _preferences!.setStringList(key, encodedList);
  }

  Future<List<FavoriteModel>> getListString(String key) async {
    await _getPreferences();

    final jsonList = _preferences!.getStringList(key) ?? [];

    return jsonList.map((e) => FavoriteModel.fromJson(jsonDecode(e))).toList();
  }
}
