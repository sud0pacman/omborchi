import 'package:omborchi/feature/main/data/model/local_model/type_entity.dart';

import '../../../../core/network/network_state.dart';
import '../model/raw_material_type.dart';

abstract interface class TypeRepository {
  Future<State> getTypes(bool isFullRefresh, Function(double) onProgress);
  Future<TypeEntity?> getTypeByIdLocal(int id);
  Future<State> createType(RawMaterialType type);
  Future<State> updateType(RawMaterialType type);
  Future<State> deleteType(RawMaterialType type);
}