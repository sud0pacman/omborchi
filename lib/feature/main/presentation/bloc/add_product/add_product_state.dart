part of 'add_product_bloc.dart';

class AddProductState {
  final List<CategoryModel> categories;
  final Map<RawMaterialType, List<RawMaterial>>? rawMaterials;
  final bool? isBack;
  final bool? isSuccess;
  final bool? isLoading;
  final String? error;

  AddProductState({
    required this.categories,
    required this.rawMaterials,
    this.isBack,
    this.isSuccess,
    this.isLoading,
    this.error,
  });

  AddProductState copyWith({
    List<CategoryModel>? categories,
    Map<RawMaterialType, List<RawMaterial>>? rawMaterials,
    bool? isBack,
    bool? isSuccess,
    bool? isLoading,
    String? error,
  }) {
    return AddProductState(
      categories: categories ?? this.categories,
      rawMaterials: rawMaterials ?? this.rawMaterials,
      isBack: isBack,
      isSuccess: isSuccess,
      isLoading: isLoading,
      error: error,
    );
  }
}
