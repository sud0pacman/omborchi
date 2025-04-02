import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hive_flutter/adapters.dart';

class AppPreferences {
  final Box _box;

  AppPreferences({required Box box}) : _box = box;

  Map<String, String> languageMap = {
    "Русский": "ru",
    "O'zbek": "uz",
    "English": "en",
  };

  String get userName => _box.get("user_name", defaultValue: "");

  set userName(String name) => _box.put("user_name", name);

  String get userIcon => _box.get("user_icon", defaultValue: "");

  set userIcon(String iconPath) => _box.put("user_icon", iconPath);

  String? get lang => _box.get("lang");

  set lang(String? newLang) {
    String localeCode = languageMap[newLang ?? "O'zbek"] ?? "uz";
    _box.put("lang", localeCode);
  }

  ThemeMode get theme {
    final val = _box.get("theme_mode", defaultValue: "Tizim".tr);
    return _parseTheme(val);
  }

  set theme(ThemeMode value) =>
      _box.put("theme_mode", value.toString().split('.')[1]);

  ThemeMode _parseTheme(String theme) {
    if (theme == "Yorqin".tr) {
      return ThemeMode.light;
    } else if (theme == "Qorong'i".tr) {
      return ThemeMode.dark;
    } else {
      return ThemeMode.system;
    }
  }

  void handleThemeSelection(String value) {
    ThemeMode selectedTheme = _parseTheme(value);
    Get.changeThemeMode(selectedTheme);
    theme = selectedTheme;
  }

  void changeTheme(ThemeMode theme) {
    Get.changeThemeMode(theme);
    this.theme = theme;
  }

  Future<void> savePinCode(String? pin) async {
    if (pin == null) {
      await _box.delete('pin_code');
    } else {
      await _box.put('pin_code', pin);
    }
  }

  String? getPinCode() {
    return _box.get('pin_code');
  }

  Future<void> removePinCode() async {
    await _box.delete('pin_code');
  }

  Future<void> savePinEnabled(bool? isEnabled) async {
    if (isEnabled == null) {
      await _box.delete('is_pin_enabled');
    } else {
      await _box.put('is_pin_enabled', isEnabled);
    }
  }

  bool isPinEnabled() {
    return _box.get('is_pin_enabled', defaultValue: false);
  }

  Future<void> saveUserId(String? userId) async {
    if (userId == null) {
      await _box.delete('user_id');
    } else {
      await _box.put('user_id', userId);
    }
  }

  String? getUserId() {
    return _box.get('user_id');
  }

  Future<void> clearAll() async {
    await _box.clear();
  }

  Future<void> init() async {
    await Hive.openBox('app_preferences');
  }
}

extension PreferencesExtension on AppPreferences {
  ValueListenable<Box> themeListenable() =>
      _box.listenable(keys: ['theme_mode']);
}
