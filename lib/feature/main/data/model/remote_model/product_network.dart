import 'package:omborchi/feature/main/domain/model/product_model.dart';

import '../local_model/product_entity.dart';

class ProductNetwork {
  final int? id;
  final int nomer;
  final String? pathOfPicture;
  final int? boyi;
  final int? eni; // Yangi field qo'shildi
  final int? xizmat;
  final int? foyda;
  final int? sotuv;
  final String? description;
  final int? categoryId;
  final DateTime? createdAt;
  final bool isVerified;
  final DateTime? updatedAt;

  ProductNetwork({
    this.id,
    required this.nomer,
    this.pathOfPicture,
    this.boyi,
    this.eni, // Constructorga qo'shildi
    this.xizmat,
    this.foyda,
    this.sotuv,
    this.description,
    this.categoryId,
    this.createdAt,
    required this.isVerified,
    this.updatedAt,
  });

  ProductNetwork copyWith({
    int? id,
    int? nomer,
    String? pathOfPicture,
    int? boyi,
    int? eni, // CopyWith metodiga qo'shildi
    int? xizmat,
    int? foyda,
    int? sotuv,
    String? description,
    int? categoryId,
    DateTime? createdAt,
    bool? isVerified,
    DateTime? updatedAt,
  }) {
    return ProductNetwork(
      id: id ?? this.id,
      nomer: nomer ?? this.nomer,
      pathOfPicture: pathOfPicture ?? this.pathOfPicture,
      boyi: boyi ?? this.boyi,
      eni: eni ?? this.eni,
      // Yangi fieldda ham nusxa olinadi
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

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'nomer': nomer,
      'path_of_picture': pathOfPicture,
      'boyi': boyi,
      'eni': eni, // toJson ga qo'shildi
      'xizmat': xizmat,
      'foyda': foyda,
      'sotuv': sotuv,
      'description': description,
      'updated_at': updatedAt?.toIso8601String(),
      'category_id': categoryId,
      'is_verified': isVerified,
    };
  }

  factory ProductNetwork.fromJson(Map<String, dynamic> map) {
    return ProductNetwork(
      id: map['id'] != null ? map['id'] as int : null,
      nomer: map['nomer'] != null ? map['nomer'] as int : 0,
      pathOfPicture: map['path_of_picture'] != null
          ? map['path_of_picture'] as String
          : null,
      boyi: map['boyi'] != null ? map['boyi'] as int : null,
      eni: map['eni'] != null ? map['eni'] as int : null,
      // fromJson uchun qo'shildi
      xizmat: map['xizmat'] != null ? map['xizmat'] as int : null,
      foyda: map['foyda'] != null ? map['foyda'] as int : null,
      sotuv: map['sotuv'] != null ? map['sotuv'] as int : null,
      description:
          map['description'] != null ? map['description'] as String : null,
      categoryId: map['category_id'] != null ? map['category_id'] as int : null,
      createdAt:
          map['created_at'] != null ? DateTime.parse(map['created_at']) : null,
      isVerified:
          map['is_verified'] != null ? map['is_verified'] as bool : false,
      updatedAt:
          map['updated_at'] != null ? DateTime.parse(map['updated_at']) : null,
    );
  }

  ProductModel toModel() {
    return ProductModel(
      id: id,
      nomer: nomer,
      pathOfPicture: pathOfPicture,
      boyi: boyi,
      eni: eni,
      // Modelga ham qo'shildi
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
    return 'ProductNetwork{id: $id, nomer: $nomer, pathOfPicture: $pathOfPicture, boyi: $boyi, eni: $eni, xizmat: $xizmat, foyda: $foyda, sotuv: $sotuv, description: $description, categoryId: $categoryId, createdAt: $createdAt, isVerified: $isVerified, updatedAt: $updatedAt}';
  }
}

extension ProductNetworkExtension on ProductNetwork {
  ProductEntity toEntity() {
    return ProductEntity(
      id: id ?? 0,
      nomer: nomer,
      pathOfPicture: pathOfPicture,
      boyi: boyi,
      eni: eni,
      // Entityga qo'shildi
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
