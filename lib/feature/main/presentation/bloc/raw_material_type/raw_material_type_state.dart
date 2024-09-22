part of 'raw_material_type_bloc.dart';

class RawMaterialTypeState {
  final List<RawMaterialType> types;
  final String? error;
  final bool? isLoading;
  final bool? isBack;

  RawMaterialTypeState({
    this.types = const [],
    this.error,
    this.isLoading,
    this.isBack,
  });

  RawMaterialTypeState copyWith({
    List<RawMaterialType>? types,
    String? error,
    bool? isLoading,
    bool? isBack,
  }) {
    return RawMaterialTypeState(
      types: types ?? this.types,
      error: error ?? this.error,
      isLoading: isLoading ?? this.isLoading,
      isBack: isBack ?? this.isBack,
    );
  }

  @override
  String toString() {
    return 'RawMaterialTypeState{types: $types, error: $error, isLoading: $isLoading, isBack: $isBack}';
  }
}

class RawMaterialTypeInitial extends RawMaterialTypeState {
  RawMaterialTypeInitial() : super();
}
