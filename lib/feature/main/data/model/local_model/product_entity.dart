import 'package:isar/isar.dart';

import '../../../domain/model/product_model.dart';

part 'product_entity.g.dart'; // Isar model adapter will be generated in this file

@collection // Isar collection annotation
class ProductEntity {
  late Id id; // Use a manually provided ID instead of auto-increment
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
    required this.id, // Now `id` is a required field
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
      id: id,
      nomer: nomer,
      pathOfPicture: pathOfPicture,
      boyi: boyi,
      eni: eni,
      xizmat: xizmat,
      foyda: foyda,
      sotuv: sotuv,
      description: description,
      categoryId: categoryId,
      createdAt: createdAt,
      isVerified: isVerified,
      updatedAt: updatedAt,
    );
  }
}

extension ProductEntityToString on ProductEntity {
  String toLog() {
    return 'ProductEntity('
        'id: $id, '
        'nomer: $nomer, '
        'pathOfPicture: $pathOfPicture, '
        'boyi: $boyi, '
        'eni: $eni, '
        'xizmat: $xizmat, '
        'foyda: $foyda, '
        'sotuv: $sotuv, '
        'description: $description, '
        'categoryId: $categoryId, '
        'createdAt: $createdAt, '
        'isVerified: $isVerified, '
        'updatedAt: $updatedAt'
        ')';
  }
}
