part of 'product_view_bloc.dart';

abstract class ProductViewEvent {}

class GetProductMaterials extends ProductViewEvent {
  final int productId;

  GetProductMaterials({required this.productId});
}

class DeleteProduct extends ProductViewEvent {
  final ProductModel product;

  DeleteProduct({required this.product});
}
