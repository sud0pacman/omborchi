part of 'raw_material_bloc.dart';

class RawMaterialEvent {}

class GetRawMaterialsWithTypes extends RawMaterialEvent {}

class RefreshRawMaterials extends RawMaterialEvent {}

class CreateRawMaterial extends RawMaterialEvent {
  final String name;
  final String cost;
  final RawMaterialType type;

  CreateRawMaterial(this.name, this.cost, this.type);
}

class DeleteRawMaterial extends RawMaterialEvent {
  final RawMaterial rawMaterial;
  final RawMaterialType type;

  DeleteRawMaterial(this.rawMaterial, this.type);
}

class UpdateRawMaterial extends RawMaterialEvent {
  final RawMaterial rawMaterial;
  final RawMaterialType type;

  UpdateRawMaterial(this.rawMaterial, this.type);
}
