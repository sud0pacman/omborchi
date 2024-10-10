import 'package:isar/isar.dart';
import 'package:omborchi/feature/main/data/model/remote_model/product_network.dart';

import '../../data/model/local_model/product_entity.dart';

class ProductModel {
  final int? id;
  final int nomer;
  final String? pathOfPicture;
  final int? boyi;
  final int? eni;
  final int? xizmat;
  final int? foyda;
  final int? sotuv;
  final String? description;
  final int? categoryId;
  final DateTime? createdAt;
  final bool isVerified;
  final DateTime? updatedAt;

  ProductModel({
    this.id,
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

  ProductModel copyWith({
    int? id,
    int? nomer,
    String? pathOfPicture,
    int? boyi,
    int? eni,
    int? xizmat,
    int? foyda,
    int? sotuv,
    String? description,
    int? categoryId,
    DateTime? createdAt,
    bool? isVerified,
    DateTime? updatedAt,
  }) {
    return ProductModel(
      id: id ?? this.id,
      nomer: nomer ?? this.nomer,
      pathOfPicture: pathOfPicture ?? this.pathOfPicture,
      boyi: boyi ?? this.boyi,
      eni: eni ?? this.eni,
      xizmat: xizmat ?? this.xizmat,
      foyda: foyda ?? this.foyda,
      sotuv: sotuv ?? this.sotuv,
      description: description ?? this.description,
      categoryId: categoryId ?? this.categoryId,
      createdAt: createdAt ?? this.createdAt,
      isVerified: isVerified ?? this.isVerified,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }
  // Factory constructor to create ProductModel from ProductNetwork
  factory ProductModel.fromNetwork(ProductNetwork network) {
    return ProductModel(
      id: network.id,
      nomer: network.nomer,
      pathOfPicture: network.pathOfPicture,
      boyi: network.boyi,
      eni: network.eni,
      xizmat: network.xizmat,
      foyda: network.foyda,
      sotuv: network.sotuv,
      description: network.description,
      categoryId: network.categoryId,
      createdAt: network.createdAt,
      isVerified: network.isVerified,
      updatedAt: network.updatedAt,
    );
  }
  ProductNetwork toNetwork() {
    return ProductNetwork(
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

  @override
  String toString() {
    return 'ProductModel{id: $id, nomer: $nomer, pathOfPicture: $pathOfPicture, boyi: $boyi, xizmat: $xizmat, foyda: $foyda, sotuv: $sotuv, description: $description, categoryId: $categoryId, createdAt: $createdAt, isVerified: $isVerified, updatedAt: $updatedAt}';
  }

  // Inside ProductMode

// Inside ProductEntity
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
extension ProductModelExtension on ProductModel {
  ProductEntity toEntity() {
    return ProductEntity(
      //Handling null id with auto-increment
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