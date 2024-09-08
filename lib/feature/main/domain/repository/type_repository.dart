import '../../../../core/network/network_state.dart';
import '../model/raw_material_type.dart';

abstract interface class TypeRepository {
  Future<State> getTypes();
  Future<State> createType(RawMaterialType type);
  Future<State> updateType(RawMaterialType type);
  Future<State> deleteType(RawMaterialType type);
}