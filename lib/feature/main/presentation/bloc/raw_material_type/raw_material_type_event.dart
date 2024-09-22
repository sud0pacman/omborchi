part of 'raw_material_type_bloc.dart';

class RawMaterialTypeEvent {}

class GetTypes extends RawMaterialTypeEvent {}
class RefreshTypes extends RawMaterialTypeEvent {}

class CreateType extends RawMaterialTypeEvent {
  final RawMaterialType rawMaterialType;

  CreateType(this.rawMaterialType);
}

class UpdateType extends RawMaterialTypeEvent {
  final RawMaterialType rawMaterialType;

  UpdateType(this.rawMaterialType);
}

class DeleteType extends RawMaterialTypeEvent {
  final int id;

  DeleteType(this.id);
}
