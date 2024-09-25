part of 'raw_material_bloc.dart';

class RawMaterialEvent {}

class GetRawMaterials extends RawMaterialEvent {}

class RefreshRawMaterials extends RawMaterialEvent {}

class CreateRawMaterial extends RawMaterialEvent {
  final RawMaterial rawMaterial;

  CreateRawMaterial(this.rawMaterial);
}

class DeleteRawMaterial extends RawMaterialEvent {
  final RawMaterial rawMaterial;

  DeleteRawMaterial(this.rawMaterial);
}

class UpdateRawMaterial extends RawMaterialEvent {
  final RawMaterial rawMaterial;

  UpdateRawMaterial(this.rawMaterial);
}
