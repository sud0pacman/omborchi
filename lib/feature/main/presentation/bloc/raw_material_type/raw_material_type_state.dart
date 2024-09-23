part of 'raw_material_type_bloc.dart';

class RawMaterialTypeState {
  final List<RawMaterialType> types;
  final String? error;
  final bool? isLoading;
  final bool? isBack;
  final bool? isCRUD;


  RawMaterialTypeState({
    this.types = const [],
    this.error,
    this.isLoading,
    this.isBack,
    this.isCRUD,
  });

  RawMaterialTypeState copyWith({
    List<RawMaterialType>? types,
    String? error,
    bool? isLoading,
    bool? isBack,
    bool? isCRUD,
  }) {
    return RawMaterialTypeState(
      types: types ?? this.types,
      error: error,
      isLoading: isLoading,
      isBack: isBack,
      isCRUD: isCRUD,
    );
  }

  @override
  String toString() {
    return 'RawMaterialTypeState{types: ${types.length}, error: $error, isLoading: $isLoading, isBack: $isBack}, isCRUD: $isCRUD}';
  }
}

class RawMaterialTypeInitial extends RawMaterialTypeState {
  RawMaterialTypeInitial() : super();
}
