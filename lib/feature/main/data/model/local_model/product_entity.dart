import 'package:isar/isar.dart';

import '../../../domain/model/product_model.dart';

part 'product_entity.g.dart'; // Isar model adapter will be generated in this file

@collection // Isar collection annotation
class ProductEntity {
  Id id = Isar.autoIncrement; // Use auto-incrementing IDs in Isar

  @Index()
  late int nomer;

  String? pathOfPicture;

  int? boyi;
  int? eni;

  int? xizmat;

  int? foyda;

  int? sotuv;

  String? description;

  @Index()
  int? categoryId;

  DateTime? createdAt;

  late bool isVerified;

  DateTime? updatedAt;

  ProductEntity({
    required this.nomer,
    this.pathOfPicture,
    this.boyi,
    this.eni,
    this.xizmat,
    this.foyda,
    this.sotuv,
    this.description,
    this.categoryId,
    this.createdAt,
    required this.isVerified,
    this.updatedAt,
  });
}

extension ProductEntityExtension on ProductEntity {
  ProductModel toModel() {
    return ProductModel(
      id: this.id,
      nomer: this.nomer,
      pathOfPicture: this.pathOfPicture,
      boyi: this.boyi,
      eni: this.eni,
      xizmat: this.xizmat,
      foyda: this.foyda,
      sotuv: this.sotuv,
      description: this.description,
      categoryId: this.categoryId,
      createdAt: this.createdAt,
      isVerified: this.isVerified,
      updatedAt: this.updatedAt,
    );
  }
}
