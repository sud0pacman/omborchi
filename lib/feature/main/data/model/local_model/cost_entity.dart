import 'package:isar/isar.dart';

import '../../../domain/model/cost_model.dart';

part 'cost_entity.g.dart'; // Generated file

@collection
class CostEntity {
  Id id = Isar.autoIncrement; // Nullable Id for auto-increment

  int quantity;
  int productId;
  int xomashyoId;

  CostEntity({
    required this.quantity,
    required this.productId,
    required this.xomashyoId,
  });
  // Convert from CostEntity to CostModel
  CostModel toModel() {
    return CostModel(
      id: id,
      quantity: quantity,
      productId: productId,
      xomashyoId: xomashyoId,
    );
  }
}
