import 'package:hive/hive.dart';
import 'package:internet_connection_checker/internet_connection_checker.dart';
import 'package:isar/isar.dart';
import 'package:omborchi/core/modules/isar_helper.dart';
import 'package:omborchi/core/network/network_state.dart';
import 'package:omborchi/core/utils/consants.dart';
import 'package:omborchi/feature/main/data/data_sources/remote_data_source/type_remote_data_source.dart';
import 'package:omborchi/feature/main/data/model/local_model/type_entity.dart';
import 'package:omborchi/feature/main/data/model/remote_model/raw_material_type_network.dart';

import 'package:omborchi/feature/main/domain/model/raw_material_type.dart';
import 'package:omborchi/feature/main/domain/repository/type_repository.dart';

class TypeRepositoryImpl implements TypeRepository {
  final TypeRemoteDataSource typeRemoteDataSource;
  final InternetConnectionChecker networkChecker = InternetConnectionChecker();
  final isarHelper = IsarHelper();
  late DateTime now;

  TypeRepositoryImpl(this.typeRemoteDataSource);

  @override
  Future<State> createType(RawMaterialType type) async {
    final bool hasNetwork = await networkChecker.hasConnection;

    if (hasNetwork) {
      final Id id = await isarHelper.addType(type.toEntity());

      AppRes.logger.t(id);
      now = DateTime.now();
      final networkRes = await typeRemoteDataSource
          .createType(type.copyWith(id: id, updatedAt: now).toNetwork());

      if (networkRes is Success) {
        await setUpdateTime();
        return Success((networkRes.value as RawMaterialTypeNetwork).toModel());
      } else {
        return networkRes;
      }
    } else {
      return NoInternet(Exception("Weak Internet"));
    }
  }

  @override
  Future<State> deleteType(RawMaterialType type) {
    return typeRemoteDataSource.deleteType(type.toNetwork());
  }

  @override
  Future<State> getTypes(bool isFullRefresh) async {
    final bool hasNetwork = await networkChecker.hasConnection;

    if (isFullRefresh && hasNetwork) {
      final res = await typeRemoteDataSource.getTypes();

      if (res is Success) {
        final List<TypeEntity> typeEntityList =
            (res.value as List<RawMaterialTypeNetwork>)
                .map((e) => e.toEntity())
                .toList();

        await isarHelper.insertAllTypes(typeEntityList);
      }

      now = DateTime.now();
      await setUpdateTime();
    }

    return Success(await _getTypesFromLocal());
  }

  @override
  Future<State> updateType(RawMaterialType type) {
    return typeRemoteDataSource.updateType(type.toNetwork());
  }

  Future<List<RawMaterialType>> _getTypesFromLocal() async {
    final isarRes = await isarHelper.getAllTypes();
    final lastUpdate = DateTime.parse(
        await Hive.box(ExpenseFields.myBox).get(LastUpdates.type));

    return isarRes.map((e) {
      return e.toModel(lastUpdate);
    }).toList();
  }

  Future<void> setUpdateTime() async {
    final box = Hive.box(ExpenseFields.myBox);
    return await box.put(
      LastUpdates.type,
      DateTime.now().toUtc().toIso8601String(),
    );
  }
}
