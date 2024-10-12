import '../../../../../core/database/db_helper.dart';
import '../../model/remote_model/category_network.dart';
import '../../model/remote_model/cost_network.dart';
import '../../model/remote_model/product_network.dart';
import '../../model/remote_model/raw_material_network.dart';
import '../../model/remote_model/raw_material_type_network.dart';

class Category {
  final int id;
  final String name;

  Category({required this.id, required this.name});

  factory Category.fromMap(Map<String, dynamic> json) => Category(
        id: json['_id'],
        name: json['NAME'],
      );
}

class TempCategoryRepository {
  final DatabaseHelper _databaseHelper = DatabaseHelper();

  Future<List<Category>> getAllCategories() async {
    final db = await _databaseHelper.database;
    final result = await db.query('CATEGORY');
    return result.map((json) => Category.fromMap(json)).toList();
  }
}

class Product {
  int? id;
  int? nomer;
  String? pathOfPicture;
  String? razmer;
  int? xizmat;
  int? foyda;
  int? sotuv;
  String? description;
  int? categoryId;

  Product({
    this.id,
    this.nomer,
    this.pathOfPicture,
    this.razmer,
    this.xizmat,
    this.foyda,
    this.sotuv,
    this.description,
    this.categoryId,
  });

  factory Product.fromMap(Map<String, dynamic> map) {
    return Product(
      id: map['_id'] as int?,
      nomer: map['NOMER'] as int?,
      pathOfPicture: map['PATHOFPICTURE'] as String? ?? '',
      // Fallback to empty string
      razmer: map['RAZMER'] as String? ?? '',
      // Fallback to empty string
      xizmat: map['XIZMAT'] as int?,
      foyda: map['FOYDA'] as int?,
      sotuv: map['SOTUV'] as int?,
      description: map['DESCRIPTION'] as String? ?? '',
      // Fallback to empty string
      categoryId: map['CATEGORY_ID'] as int?,
    );
  }
}

extension ProductExtension on Product {
  ProductNetwork toProductNetwork() {
    return ProductNetwork(
      id: id,
      nomer: nomer ?? 0,
      pathOfPicture: pathOfPicture ?? '',
      boyi: int.tryParse(razmer?.split('x')[0] ?? '0'),
      eni: int.tryParse(razmer?.split('x')[1] ?? '0'),
      xizmat: xizmat,
      foyda: foyda,
      sotuv: sotuv,
      description: description,
      categoryId: categoryId,
      isVerified: true,
      // This field might depend on your app logic
      createdAt: DateTime.now(),
    );
  }
}

extension CategoryExtension on Category {
  CategoryNetwork toCategoryNetwork() {
    return CategoryNetwork(
      id: id,
      name: name,
      updatedAt: DateTime.now(),
    );
  }
}

extension RawMaterialExtension on Xomashyo {
  RawMaterialNetwork toRawMaterialNetwork() {
    return RawMaterialNetwork(
      id: id,
      name: name,
      price: price,
      typeId: typeId,
      updatedAt: DateTime.now(),
    );
  }
}

extension RawMaterialTypeExtension on Types {
  RawMaterialTypeNetwork toRawMaterialTypeNetwork() {
    return RawMaterialTypeNetwork(
      id: id,
      name: name,
      updatedAt: DateTime.now(),
    );
  }
}

extension TannarxExtensions on Tannarx {
  CostNetwork toCostNetwork() {
    return CostNetwork(
      id: id,
      quantity: quantity,
      productId: productId,
      xomashyoId: xomashyoId,
    );
  }
}

class TempProductRepository {
  final DatabaseHelper _databaseHelper = DatabaseHelper();

  Future<List<Product>> getAllProducts() async {
    final db = await _databaseHelper.database;
    final result = await db.query('PRODUCT');
    return result.map((json) => Product.fromMap(json)).toList();
  }
}

class Tannarx {
  final int id;
  final int quantity;
  final int productId;
  final int xomashyoId;

  Tannarx({
    required this.id,
    required this.quantity,
    required this.productId,
    required this.xomashyoId,
  });

  factory Tannarx.fromMap(Map<String, dynamic> json) => Tannarx(
        id: json['_id'],
        quantity: json['QUANTITY'],
        productId: json['PRODUCT_ID'],
        xomashyoId: json['XOMASHYO_ID'],
      );
}

class TempTannarxRepository {
  final DatabaseHelper _databaseHelper = DatabaseHelper();

  Future<List<Tannarx>> getAllTannarx() async {
    final db = await _databaseHelper.database;
    final result = await db.query('TANNARX');
    return result.map((json) => Tannarx.fromMap(json)).toList();
  }
}

class Types {
  final int id;
  final String name;

  Types({required this.id, required this.name});

  factory Types.fromMap(Map<String, dynamic> json) => Types(
        id: json['_id'],
        name: json['NAME'],
      );
}

class TempTypesRepository {
  final DatabaseHelper _databaseHelper = DatabaseHelper();

  Future<List<Types>> getAllTypes() async {
    final db = await _databaseHelper.database;
    final result = await db.query('TYPES');
    return result.map((json) => Types.fromMap(json)).toList();
  }
}

class Xomashyo {
  final int id;
  final String name;
  final double price;
  final int typeId;

  Xomashyo({
    required this.id,
    required this.name,
    required this.price,
    required this.typeId,
  });

  factory Xomashyo.fromMap(Map<String, dynamic> json) => Xomashyo(
        id: json['_id'],
        name: json['NAME'],
        price: json['PRICE'],
        typeId: json['TYPE_ID'],
      );
}

class TempXomashyoRepository {
  final DatabaseHelper _databaseHelper = DatabaseHelper();

  Future<List<Xomashyo>> getAllXomashyo() async {
    final db = await _databaseHelper.database;
    final result = await db.query('XOMASHYO');
    return result.map((json) => Xomashyo.fromMap(json)).toList();
  }
}
