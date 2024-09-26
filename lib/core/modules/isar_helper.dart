import 'package:isar/isar.dart';
import 'package:omborchi/feature/main/data/model/local_model/category_entity.dart';
import 'package:omborchi/feature/main/data/model/local_model/raw_material_entity.dart';
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
      [TypeEntitySchema, RawMaterialEntitySchema, CategoryEntitySchema], // List of schemas
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

  // RawMaterial CRUD Operations
  Future<int> addRawMaterial(RawMaterialEntity rawMaterial) async {
    final isar = await db;
    return await isar.writeTxn<int>(() async {
      return await isar.rawMaterialEntitys.put(rawMaterial);
    });
  }

  Future<RawMaterialEntity?> getRawMaterial(int id) async {
    final isar = await db;
    return await isar.rawMaterialEntitys.get(id);
  }

  Future<List<RawMaterialEntity>> getRawMaterialsByTypeId(int id) async {
    final isar = await db;
    return await isar.rawMaterialEntitys.filter().typeIdEqualTo(id).findAll();
  }

  Future<List<RawMaterialEntity>> getAllRawMaterials() async {
    final isar = await db;
    return await isar.rawMaterialEntitys.where().findAll();
  }

  Future<void> updateRawMaterial(RawMaterialEntity rawMaterial) async {
    final isar = await db;
    await isar.writeTxn(() async {
      await isar.rawMaterialEntitys.put(rawMaterial);
    });
  }

  Future<void> insertAllRawMaterials(List<RawMaterialEntity> rawMaterials) async {
    final isar = await db;
    await isar.writeTxn(() async {
      await isar.rawMaterialEntitys.putAll(rawMaterials);
    });
  }

  Future<void> deleteRawMaterial(int id) async {
    final isar = await db;
    await isar.writeTxn(() async {
      await isar.rawMaterialEntitys.delete(id);
    });
  }

  Future<void> deleteAllRawMaterials(List<int> ids) async {
    final isar = await db;
    await isar.writeTxn(() async {
      await isar.rawMaterialEntitys.deleteAll(ids);
    });
  }

  // Category CRUD Operations
  Future<int> addCategory(CategoryEntity category) async {
    final isar = await db;
    return await isar.writeTxn<int>(() async {
      return await isar.categoryEntitys.put(category);
    });
  }

  Future<CategoryEntity?> getCategory(int id) async {
    final isar = await db;
    return await isar.categoryEntitys.get(id);
  }

  Future<List<CategoryEntity>> getAllCategories() async {
    final isar = await db;
    return await isar.categoryEntitys.where().findAll();
  }

  Future<void> updateCategory(CategoryEntity category) async {
    final isar = await db;
    await isar.writeTxn(() async {
      await isar.categoryEntitys.put(category);
    });
  }

  Future<void> insertAllCategories(List<CategoryEntity> categories) async {
    final isar = await db;
    await isar.writeTxn(() async {
      await isar.categoryEntitys.putAll(categories);
    });
  }

  Future<void> deleteCategory(int id) async {
    final isar = await db;
    await isar.writeTxn(() async {
      await isar.categoryEntitys.delete(id);
    });
  }

  Future<void> deleteAllCategories(List<int> ids) async {
    final isar = await db;
    await isar.writeTxn(() async {
      await isar.categoryEntitys.deleteAll(ids);
    });
  }

  // Close the database
  Future<void> closeDb() async {
    final isar = await db;
    await isar.close();
  }
}
