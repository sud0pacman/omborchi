part of 'raw_material_bloc.dart';

class RawMaterialState {
  final Map<RawMaterialType, List<RawMaterial>> rawMaterials;
  final String? errorMsg;
  final bool? isLoading;
  final bool? isCRUD;
  final bool? isBack;

  RawMaterialState({
    required this.rawMaterials,
    this.errorMsg,
    this.isLoading,
    this.isCRUD,
    this.isBack,
  });

  RawMaterialState copyWith({
    Map<RawMaterialType, List<RawMaterial>>? rawMaterials,
    String? errorMsg,
    bool? isLoading,
    bool? isCRUD,
    bool? isBack,
  }) {
    return RawMaterialState(
      rawMaterials: rawMaterials ?? this.rawMaterials,
      errorMsg: errorMsg,
      isLoading: isLoading,
      isCRUD: isCRUD,
      isBack: isBack,
    );
  }
}
