part of 'update_product_bloc.dart';


class UpdateProductEvent {}

class UpdateProduct extends UpdateProductEvent {
  final ProductModel productModel;
  final bool isImageChanged;
  final List<CostModel> costModels;


  UpdateProduct({
    required this.productModel,
    required this.isImageChanged,
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
