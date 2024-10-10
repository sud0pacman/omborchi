import 'package:omborchi/feature/main/data/model/remote_model/cost_network.dart';

import '../../data/model/local_model/cost_entity.dart';

class CostModel {
  final int? id;
  final int quantity;
  final int productId;
  final int xomashyoId;

  CostModel({
    this.id,
    required this.quantity,
    required this.productId,
    required this.xomashyoId,
  });

  CostModel copyWit({
    int? id,
    int? quantity,
    int? productId,
    int? xomashyoId,
  }) {
    return CostModel(
      id: id ?? this.id,
      quantity: quantity ?? this.quantity,
      productId: productId ?? this.productId,
      xomashyoId: xomashyoId ?? this.xomashyoId,
    );
  }
  CostEntity toEntity() {
    return CostEntity(
      quantity: quantity,
      productId: productId,
      xomashyoId: xomashyoId,
    );
  }

  CostNetwork toNetwork() {
    return CostNetwork(
      id: id,
      quantity: quantity,
      productId: productId,
      xomashyoId: xomashyoId,
    );
  }

  @override
  String toString() {
    return 'Cost{id: $id, quantity: $quantity, productId: $productId, xomashyoId: $xomashyoId}';
  }
}
