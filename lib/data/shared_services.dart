import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';
import 'package:zip_search/core/model/address_model.dart';
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
    List<AddressModel> addressList,
  ) async {
    await _getPreferences();

    List<String> encodedList =
        addressList.map((address) => jsonEncode(address.toJson())).toList();

    await _preferences!.setStringList(key, encodedList);
  }

  Future<List<AddressModel>> getListString(String key) async {
    await _getPreferences();

    final jsonList = _preferences!.getStringList(key) ?? [];

    return jsonList.map((e) => AddressModel.fromJson(json.decode(e))).toList();
  }

  //! WIP funções
  Future<void> saveListString2(
    String key,
    List<FavoriteModel> favoriteAddressList,
  ) async {
    await _getPreferences();

    List<String> encodedList = favoriteAddressList
        .map((address) => jsonEncode(address.toJson()))
        .toList();

    await _preferences!.setStringList(key, encodedList);
  }

  Future<List<FavoriteModel>> getListString2(String key) async {
    await _getPreferences();

    final jsonList = _preferences!.getStringList(key) ?? [];

    return jsonList.map((e) => FavoriteModel.fromJson(e)).toList();
  }
}
