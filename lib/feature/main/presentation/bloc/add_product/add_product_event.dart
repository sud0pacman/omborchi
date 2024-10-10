part of 'add_product_bloc.dart';


class AddProductEvent {}

class AddProduct extends AddProductEvent {
  final ProductModel productModel;
  final List<CostModel> costModels;  // Add the costModels field

  AddProduct({
    required this.productModel,
    required this.costModels,  // Initialize it in the constructor
  });
}

class GetCategories extends AddProductEvent {}
class GetTypes extends AddProductEvent {}

class GetRawMaterialsWithTypes extends AddProductEvent {}
