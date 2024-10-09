part of 'add_product_bloc.dart';


class AddProductEvent {}

class AddProduct extends AddProductEvent {
  final ProductModel productModel;

  AddProduct({required this.productModel});
}
class GetCategories extends AddProductEvent {}
class GetTypes extends AddProductEvent {}

class GetRawMaterialsWithTypes extends AddProductEvent {}
