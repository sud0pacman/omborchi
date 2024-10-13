part of 'update_product_bloc.dart';


class UpdateProductEvent {}

class UpdateProduct extends UpdateProductEvent {
  final ProductModel productModel;
  final List<CostModel> costModels;  // Add the costModels field

  UpdateProduct({
    required this.productModel,
    required this.costModels,  // Initialize it in the constructor
  });
}

class GetCategories extends UpdateProductEvent {}
class GetProductMaterials extends UpdateProductEvent {
  final int productId;

  GetProductMaterials({required this.productId});

}
class GetTypes extends UpdateProductEvent {}

class GetRawMaterialsWithTypes extends UpdateProductEvent {}
