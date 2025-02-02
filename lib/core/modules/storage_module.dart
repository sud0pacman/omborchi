import 'package:hive/hive.dart';
import 'package:omborchi/core/modules/hive_db_helper.dart';

class StorageModule {
  static Future<void> initBoxes() async {
    await Hive.openBox("preferences");
  }

  static AppPreferences providePreferencesStorage() {
    final box = Hive.box("preferences");
    return AppPreferences(box: box);
  }
}
