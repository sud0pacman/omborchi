import 'package:omborchi/core/network/network_state.dart';
import 'package:omborchi/feature/main/data/data_sources/remote_data_source/raw_material_remote_data_source.dart';

import 'package:omborchi/feature/main/domain/model/raw_material.dart';
import 'package:omborchi/feature/main/domain/repository/raw_material_repository.dart';
import '../model/remote_model/raw_material_network.dart';


class RawMaterialRepositoryImpl implements RawMaterialRepository {
  final RawMaterialRemoteDataSource rawMaterialRemoteDataSource;

  RawMaterialRepositoryImpl(this.rawMaterialRemoteDataSource);

  @override
  Future<State> createRawMaterial(RawMaterial rawMaterial) {
    return rawMaterialRemoteDataSource
        .createRawMaterial(rawMaterial.toNetwork());
  }

  @override
  Future<State> deleteRawMaterial(RawMaterial rawMaterial) {
    return rawMaterialRemoteDataSource
        .deleteRawMaterial(rawMaterial.toNetwork());
  }

  @override
  Future<State> getRawMaterials(int typeId) async {
    final response = await rawMaterialRemoteDataSource.getRawMaterials(typeId);

    if (response is Success) {
      final List<RawMaterialNetwork> rawMaterials = response.value;
      final List<RawMaterial> rawMaterialsModel =
          rawMaterials.map((e) => e.toModel()).toList();

      return Success(rawMaterialsModel);
    } else {
      return response;
    }
  }

  @override
  Future<State> updateRawMaterial(RawMaterial rawMaterial) {
    return rawMaterialRemoteDataSource
        .updateRawMaterial(rawMaterial.toNetwork());
  }
}
