import 'package:sqflite/sqflite.dart';
import '../../feature/main/data/model/local_model/category_entity.dart';
import 'package:path/path.dart';

class MyDatabaseHelper {
  static int version = 1;
  static String dbName = 'omborchi.db';

   Future<Database> _getDb() async {
    return await openDatabase(join(await getDatabasesPath(), dbName),
        version: version,
        onCreate: (db, version) async {
          // CategoryEntity jadvalini yaratish
          await db.execute(
              'CREATE TABLE CategoryEntity (id INTEGER PRIMARY KEY AUTOINCREMENT, name TEXT NOT NULL, updated_at TEXT NOT NULL, status TEXT NOT NULL)');
        });
  }

  // Kategoriyalar uchun CRUD operatsiyalari
  Future<int> addCategory(CategoryEntity category) async {
    final db = await _getDb();
    return await db.insert('CategoryEntity', category.toJson());
  }

  Future<CategoryEntity?> getCategory(int id) async {
    final db = await _getDb();
    final List<Map<String, dynamic>> map =
    await db.query('CategoryEntity', where: 'id = ?', whereArgs: [id]);
    if (map.isNotEmpty) {
      return CategoryEntity.fromJson(map.first);
    }
    return null;
  }

  Future<int> updateCategory(CategoryEntity category) async {
    final db = await _getDb();
    return await db.update('CategoryEntity', category.toJson(),
        where: 'id =?', whereArgs: [category.id]);
  }

  Future<void> deleteCategory(int id) async {
    final db = await _getDb();
    db.delete('CategoryEntity', where: 'id =?', whereArgs: [id]);
  }

  Future<List<CategoryEntity>> getAllCategories() async {
    final db = await _getDb();
    final map = await db.query('CategoryEntity');
    return List.generate(map.length, (index) => CategoryEntity.fromJson(map[index]));
  }
}