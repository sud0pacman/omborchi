import 'package:omborchi/feature/main/domain/model/raw_material.dart';

import '../../../../core/network/network_state.dart';

abstract interface class RawMaterialRepository {
  Future<State> getRawMaterials();
  Future<State> createRawMaterial(RawMaterial rawMaterial);
  Future<State> updateRawMaterial(RawMaterial rawMaterial);
  Future<State> deleteRawMaterial(RawMaterial rawMaterial);
  Future<State> getRawMaterialsWithTypes();
  Future<State> getMaterialByTypeId(bool isFullRefresh, int typeId);
}
