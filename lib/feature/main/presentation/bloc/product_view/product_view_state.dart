part of 'product_view_bloc.dart';

class ProductViewState {
  final List<RawMaterialUi> materials;
  final bool isLoading;
  final bool isBack;

  ProductViewState({
    required this.materials,
    required this.isLoading,
    required this.isBack,
  });

  ProductViewState copyWith({
    List<RawMaterialUi>? materials,
    bool? isLoading,
    bool? isBack,
  }) {
    return ProductViewState(
      materials: materials ?? this.materials,
      isLoading: isLoading ?? this.isLoading,
      isBack: isBack ?? this.isBack,
    );
  }
}

