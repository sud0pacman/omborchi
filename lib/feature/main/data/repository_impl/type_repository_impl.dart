import 'package:omborchi/core/network/network_state.dart';
import 'package:omborchi/feature/main/data/data_sources/remote_data_source/type_remote_data_source.dart';

import 'package:omborchi/feature/main/domain/model/raw_material_type.dart';
import 'package:omborchi/feature/main/domain/repository/type_repository.dart';

import '../model/remote_model/raw_material_type_network.dart';

class TypeRepositoryImpl implements TypeRepository {
  final TypeRemoteDataSource typeRemoteDataSource;

  TypeRepositoryImpl(this.typeRemoteDataSource);

  @override
  Future<State> createType(RawMaterialType type) {
    return typeRemoteDataSource.createType(type.toNetwork());
  }

  @override
  Future<State> deleteType(RawMaterialType type) {
    return typeRemoteDataSource.deleteType(type.toNetwork());
  }

  @override
  Future<State> getTypes() async {
    final res = await typeRemoteDataSource.getTypes();

    if (res is Success) {
      final List<RawMaterialTypeNetwork> types = res.value;
      final List<RawMaterialType> typesModel =
          types.map((e) => e.toModel()).toList();

      return Success(typesModel);
    } else {
      return res;
    }
  }

  @override
  Future<State> updateType(RawMaterialType type) {
    return typeRemoteDataSource.updateType(type.toNetwork());
  }
}
