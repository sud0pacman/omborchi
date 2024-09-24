import 'package:isar/isar.dart';
import 'package:omborchi/feature/main/data/model/local_model/type_entity.dart';
import 'package:path_provider/path_provider.dart'; // For getting the directory path

class IsarHelper {
  late Future<Isar> db;

  IsarHelper() {
    db = _initDb();
  }

  Future<Isar> _initDb() async {
    final dir = await getApplicationDocumentsDirectory();
    return await Isar.open(
      [TypeEntitySchema], // List of schemas
      directory: dir.path,
    );
  }

  // Type CRUD Operations
  Future<int> addType(TypeEntity type) async {
    final isar = await db;
    return await isar.writeTxn<int>(() async {
      return await isar.typeEntitys.put(type); // Insert type and return id
    });
  }

  Future<TypeEntity?> getType(int id) async {
    final isar = await db;
    return await isar.typeEntitys.get(id);
  }

  Future<List<TypeEntity>> getAllTypes() async {
    final isar = await db;
    return await isar.typeEntitys.where().findAll();
  }

  Future<void> updateType(TypeEntity type) async {
    final isar = await db;
    await isar.writeTxn(() async {
      await isar.typeEntitys.put(type); // Update type
    });
  }

  Future<void> insertAllTypes(List<TypeEntity> types) async {
    final isar = await db;
    await isar.writeTxn(() async {
      await isar.typeEntitys.putAll(types); // Bulk insert
    });
  }

  Future<void> deleteType(int id) async {
    final isar = await db;
    await isar.writeTxn(() async {
      await isar.typeEntitys.delete(id);
    });
  }

  Future<void> deleteAllTypes(List<int> ids) async {
    final isar = await db;

    await isar.writeTxn(() async {
      isar.typeEntitys.deleteAll(ids);
    });
  }

  // Close the database
  Future<void> closeDb() async {
    final isar = await db;
    await isar.close();
  }
}
