import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';

class SharedPreferencesHelper {
  ///---------------------------------------------------------------------------
  ///#region Reference

  //Initialize session wrapper

//luu key value
  final Map _session = {};

  // SharedPreferences object to store persistent data
  // khai bao ( thu vien  shared)
  SharedPreferences? prefs;

  // Access and initialize the SharedPrferences instance
  // truy cap &  khoi tao 
  Future _accessSharedPrefs() async {
    prefs = await SharedPreferences.getInstance();
  }

  /// Item getter
  ///
  /// @param key String that specifies JSON key to access the corresponding value
  /// @returns Future
  // get key 
  Future get(key) async {
    await _accessSharedPrefs();
    try {
      return json.decode(prefs!.get(key) as String);
    } catch (e) {
      return prefs!.get(key);
    }
  }

  /// Session destroyer
  ///
  /// @returns Future
  Future destroy() async {
    await _accessSharedPrefs();
    try {
      await prefs!.clear();
    } catch (e) {
      throw Exception(
          "It wasn't possible to destroy the session. This can be triggered if the session no longer exists or if the session is inaccessible. ");
    }
  }

  /// Session value remover by key
  ///
  /// @param key String that specifies JSON key to access the corresponding value
  /// @returns Future
  Future remove(String key) async {
    await _accessSharedPrefs();
    try {
      await prefs!.remove(key);
    } catch (e) {
      throw Exception(
          "It wasn't possible to remove this item from the session. This can be triggered if the session no longer exists or if the key is not correct. ");
    }
  }

  /// Key existence verifier
  ///
  /// @param key String that specifies JSON key to search for
  /// @returns Future<bool> false if that key wasn't found or true if it was
  Future<bool> containsKey(String key) async {
    await _accessSharedPrefs();
    try {
      return prefs!.containsKey(key);
    } catch (e) {
      throw Exception(
          "It wasn't possible to look for this key in the session. This can be triggered if the session no longer exists or if the key is not correct. ");
    }
  }

  /// Session updater(reloads session fetching the latest data)
  ///
  /// @returns Future
  Future update() async {
    await _accessSharedPrefs();
    try {
      await prefs!.reload();
    } catch (e) {
      throw Exception("It wasn't possible to reload and update the session.");
    }
  }

  /// Item setter
  ///
  /// @param key String
  /// @param value any
  /// @returns Future
  Future set(key, value) async {
    await _accessSharedPrefs();
    try {
      // Detect item type
      switch (value.runtimeType) {
        // neu la dang String
        case String:
          {
            prefs!.setString(key, value);
          }
          break;

        // Int
        case int:
          {
            prefs!.setInt(key, value);
          }
          break;

        // Bool
        case bool:
          {
            prefs!.setBool(key, value);
          }
          break;

        // Double
        case double:
          {
            prefs!.setDouble(key, value);
          }
          break;

        // List<String>
        case List:
          {
            prefs!.setStringList(key, value);
          }
          break;

        // Object ()
        default:
          {
            prefs!.setString(key, jsonEncode(value.toJson()));
          }
      }
    } catch (e) {
      throw Exception("Key or value are not the correct type.");
    }

    // Add data to session wrapper
    _session.putIfAbsent(key, () => value);
  }

  ///#endregion
}
