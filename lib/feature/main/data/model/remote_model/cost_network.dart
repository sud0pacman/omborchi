import 'package:omborchi/feature/main/domain/model/cost_model.dart';

import '../local_model/cost_entity.dart';

class CostNetwork {
  final int? id;
  final int quantity;
  final int productId;
  final int xomashyoId;

  CostNetwork({
    this.id,
    required this.quantity,
    required this.productId,
    required this.xomashyoId,
  });

  CostNetwork copyWith({
    int? id,
    int? quantity,
    int? productId,
    int? xomashyoId,
  }) {
    return CostNetwork(
      id: id ?? this.id,
      quantity: quantity ?? this.quantity,
      productId: productId ?? this.productId,
      xomashyoId: xomashyoId ?? this.xomashyoId,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'quantity': quantity,
      'product_id': productId,
      'xomashyo_id': xomashyoId,
    };
  }

  factory CostNetwork.fromJson(Map<String, dynamic> map) {
    return CostNetwork(
      id: map['id'] != null ? map['id'] as int : null,
      quantity: map['quantity'] != null ? map['quantity'] as int : 0,
      productId: map['product_id'] != null ? map['product_id'] as int : 0,
      xomashyoId: map['xomashyo_id'] != null ? map['xomashyo_id'] as int : 0,
    );
  }
  CostEntity toEntity() {
    return CostEntity(
      quantity: quantity,
      productId: productId,
      xomashyoId: xomashyoId,
    );
  }

  CostModel toModel() {
    return CostModel(
      id: id,
      quantity: quantity,
      productId: productId,
      xomashyoId: xomashyoId,
    );
  }

  @override
  String toString() {
    return 'CostNetwork{id: $id, quantity: $quantity, productId: $productId, xomashyoId: $xomashyoId}';
  }
}
