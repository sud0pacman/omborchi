part of 'add_product_bloc.dart';

class AddProductState {
  final List<CategoryModel> categories;
  final Map<RawMaterialType, List<RawMaterial>>? rawMaterials;
  final bool? isBack;
  final bool? isSuccess;
  final String? error;

  AddProductState({
    required this.categories,
    required this.rawMaterials,
    this.isBack,
    this.isSuccess,
    this.error,
  });

  AddProductState copyWith({
    List<CategoryModel>? categories,
    Map<RawMaterialType, List<RawMaterial>>? rawMaterials,
    bool? isBack,
    bool? isSuccess,
    String? error,
  }) {
    return AddProductState(
      categories: categories ?? this.categories,
      rawMaterials: rawMaterials ?? this.rawMaterials,
      isBack: isBack,
      isSuccess: isSuccess,
      error: error,
    );
  }
}
