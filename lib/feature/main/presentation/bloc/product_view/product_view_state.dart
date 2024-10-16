part of 'product_view_bloc.dart';

class ProductViewState {
  final List<RawMaterialUi> materials;
  final String? error;
  final ProductModel? product;
  final bool isLoading;
  final bool isBack;

  ProductViewState({
    required this.materials,
    required this.error,
    this.product,
    required this.isLoading,
    required this.isBack,
  });

  ProductViewState copyWith({
    List<RawMaterialUi>? materials,
    String? error,
    ProductModel? product,
    bool? isLoading,
    bool? isBack,
  }) {
    return ProductViewState(
      materials: materials ?? this.materials,
      error: error ?? this.error,
      product: product ?? this.product,
      isLoading: isLoading ?? this.isLoading,
      isBack: isBack ?? this.isBack,
    );
  }
}

