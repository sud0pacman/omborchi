part of 'update_product_bloc.dart';

class UpdateProductState {
  final List<CategoryModel> categories;
  final Map<RawMaterialType, List<RawMaterial>>? rawMaterials;
  final List<RawMaterialUpdate> uiMaterials;
  final bool? isBack;
  final bool? isSuccess;
  final bool? isLoading;
  final String? error;

  UpdateProductState({
    required this.categories,
    required this.rawMaterials,
    required this.uiMaterials,
    this.isBack,
    this.isSuccess,
    this.isLoading,
    this.error,
  });

  UpdateProductState copyWith({
    List<CategoryModel>? categories,
    Map<RawMaterialType, List<RawMaterial>>? rawMaterials,
    List<RawMaterialUpdate>? uiMaterials,
    bool? isBack,
    bool? isSuccess,
    bool? isLoading,
    String? error,
  }) {
    return UpdateProductState(
      categories: categories ?? this.categories,
      rawMaterials: rawMaterials ?? this.rawMaterials,
      uiMaterials: uiMaterials ?? this.uiMaterials,
      isBack: isBack,
      isSuccess: isSuccess,
      isLoading: isLoading,
      error: error,
    );
  }
}
