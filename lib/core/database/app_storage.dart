import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AppStorage {
  static final AppStorage _instance = AppStorage._internal();
  static SharedPreferences? _sharedPreferences;

  AppStorage._internal();

  factory AppStorage() {
    return _instance;
  }

  static Future<void> init() async {
    _sharedPreferences ??= await SharedPreferences.getInstance();
  }

  static Future<void> _ensureInitialized() async {
    if (_sharedPreferences == null) {
      await init();
    }
  }

  Future<void> saveString(String key, String value) async {
    await _ensureInitialized();
    await _sharedPreferences!.setString(key, value);
  }

  String? getString(String key) {
    return _sharedPreferences?.getString(key);
  }

  Future<void> saveInt(String key, int value) async {
    await _ensureInitialized();
    await _sharedPreferences!.setInt(key, value);
  }

  int? getInt(String key) {
    return _sharedPreferences?.getInt(key);
  }

  Future<void> saveDouble(String key, double value) async {
    await _ensureInitialized();
    await _sharedPreferences!.setDouble(key, value);
  }

  double? getDouble(String key) {
    return _sharedPreferences?.getDouble(key);
  }

  Future<void> saveBool(String key, bool value) async {
    await _ensureInitialized();
    await _sharedPreferences!.setBool(key, value);
  }

  bool? getBool(String key) {
    return _sharedPreferences?.getBool(key);
  }

  Future<void> saveTheme(ThemeMode themeMode) async {
    await _ensureInitialized();
    String themeString;
    switch (themeMode) {
      case ThemeMode.light:
        themeString = 'light';
        break;
      case ThemeMode.dark:
        themeString = 'dark';
        break;
      case ThemeMode.system:
        themeString = 'system';
        break;
    }
    await _sharedPreferences!.setString('theme', themeString);
  }

  ThemeMode getTheme() {
    String? themeString = _sharedPreferences?.getString('theme');
    switch (themeString) {
      case 'light':
        return ThemeMode.light;
      case 'dark':
        return ThemeMode.dark;
      case 'system':
      default:
        return ThemeMode.system;
    }
  }

  Future<void> remove(String key) async {
    await _ensureInitialized();
    await _sharedPreferences!.remove(key);
  }

  Future<void> clear() async {
    await _ensureInitialized();
    await _sharedPreferences!.clear();
  }
}
