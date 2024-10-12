import 'package:hive/hive.dart';
import 'package:internet_connection_checker/internet_connection_checker.dart';
import 'package:isar/isar.dart';
import 'package:omborchi/core/custom/functions/custom_functions.dart';
import 'package:omborchi/core/modules/isar_helper.dart';
import 'package:omborchi/core/network/network_state.dart';
import 'package:omborchi/core/utils/consants.dart';
import 'package:omborchi/feature/main/data/data_sources/remote_data_source/raw_material_remote_data_source.dart';
import 'package:omborchi/feature/main/data/model/local_model/raw_material_entity.dart';
import 'package:omborchi/feature/main/data/model/remote_model/raw_material_network.dart';
import 'package:omborchi/feature/main/domain/model/raw_material.dart';
import 'package:omborchi/feature/main/domain/model/raw_material_type.dart';
import 'package:omborchi/feature/main/domain/repository/raw_material_repository.dart';

class RawMaterialRepositoryImpl implements RawMaterialRepository {
  final RawMaterialRemoteDataSource rawMaterialRemoteDataSource;
  final InternetConnectionChecker networkChecker = InternetConnectionChecker();
  final isarHelper = IsarHelper();
  late DateTime now;

  RawMaterialRepositoryImpl(this.rawMaterialRemoteDataSource);

  @override
  Future<State> createRawMaterial(RawMaterial rawMaterial) async {
    final bool hasNetwork = await networkChecker.hasConnection;

    if (hasNetwork) {
      final Id localId =
          await isarHelper.addRawMaterial(rawMaterial.toEntity());
      AppRes.logger.t(localId);

      now = DateTime.now();
      final networkRes = await rawMaterialRemoteDataSource.createRawMaterial(
          rawMaterial.copyWith(id: rawMaterial.id, updatedAt: now).toNetwork());

      AppRes.logger.i("Network response: $networkRes");

      if (networkRes is Success) {
        await setUpdateTime(now);

        return Success(rawMaterial.copyWith(id: localId));
      } else if (networkRes is GenericError) {
        AppRes.logger.wtf("Generic error encountered: ${networkRes.exception}");
        await isarHelper.deleteRawMaterial(localId); // cleanup on error
        return networkRes;
      } else {
        AppRes.logger.wtf("Unhandled error: $networkRes");
        await isarHelper.deleteRawMaterial(localId);
        return networkRes;
      }
    } else {
      return NoInternet(Exception("Weak Internet"));
    }
  }

  @override
  Future<State> deleteRawMaterial(RawMaterial rawMaterial) async {
    final bool hasNetwork = await networkChecker.hasConnection;

    if (hasNetwork) {
      final networkRes = await rawMaterialRemoteDataSource
          .deleteRawMaterial(rawMaterial.toNetwork());

      if (networkRes is Success) {
        now = DateTime.now();
        await setUpdateTime(now);
        await isarHelper.deleteRawMaterial(rawMaterial.id!);
        return Success(null);
      } else {
        return networkRes;
      }
    } else {
      return NoInternet(Exception("Weak Internet"));
    }
  }

  @override
  Future<State> updateRawMaterial(RawMaterial rawMaterial) async {
    final bool hasNetwork = await networkChecker.hasConnection;

    if (hasNetwork) {
      now = DateTime.now();
      final networkRes = await rawMaterialRemoteDataSource
          .updateRawMaterial(rawMaterial.copyWith(updatedAt: now).toNetwork());

      if (networkRes is Success) {
        await setUpdateTime(now);
        await isarHelper.updateRawMaterial(rawMaterial.toEntity());
        return Success(
            await _getRawMaterialsFromLocalByTypeId(rawMaterial.typeId));
      } else {
        return networkRes;
      }
    } else {
      return NoInternet(Exception("Weak Internet"));
    }
  }

  @override
  Future<State> getRawMaterials() async {
    final bool hasNetwork = await networkChecker.hasConnection;

    if (hasNetwork) {
      final typeList = await _getTypesFromLocal();
      await isarHelper.deleteAllRawMaterials(
          typeList.map((element) => element.id!).toList());

      for (var type in typeList) {
        final networkRes =
            await rawMaterialRemoteDataSource.getRawMaterials(type.id!);

        if (networkRes is Success) {
          final List<RawMaterialNetwork> networkRawMaterialList =
              networkRes.value;

          final List<RawMaterialEntity> rawMaterialEntity =
              networkRawMaterialList
                  .map((element) => element.toEntity())
                  .toList();

          await isarHelper.insertAllRawMaterials(rawMaterialEntity);
        }
      }

      final Map<RawMaterialType, List<RawMaterial>> rawMaterials = {};

      for (var rawMaterialType in typeList) {
        rawMaterials[rawMaterialType] =
            await _getRawMaterialsFromLocalByTypeId(rawMaterialType.id!);
      }

      return Success(rawMaterials);
    } else {
      return NoInternet(Exception("Weak Internet"));
    }
  }

  @override
  Future<State> getMaterialById(int id) async {
    final material = await isarHelper.getRawMaterial(id);
    return Success(material);
  }

  @override
  Future<State> getRawMaterialsWithTypes() async {
    final List<RawMaterialType> types = await _getTypesFromLocal();
    final Map<RawMaterialType, List<RawMaterial>> rawMaterials = {};

    for (var rawMaterialType in types) {
      rawMaterials[rawMaterialType] =
          await _getRawMaterialsFromLocalByTypeId(rawMaterialType.id!);
    }

    return Success(rawMaterials);
  }

  Future<List<RawMaterial>> _getRawMaterialsFromLocalByTypeId(int id) async {
    final lastUpdate = DateTime.parse(
        await Hive.box(ExpenseFields.myBox).get(LastUpdates.type) ??
            DateTime.now().toLocal().toIso8601String());

    final List<RawMaterial> rawMaterials =
        await isarHelper.getRawMaterialsByTypeId(id).then((onValue) {
      return onValue.map((e) => e.toModel(lastUpdate)).toList();
    });

    return rawMaterials;
  }

  Future<List<RawMaterialType>> _getTypesFromLocal() async {
    final isarRes = await isarHelper.getAllTypes();
    final lastUpdate = DateTime.parse(
        await Hive.box(ExpenseFields.myBox).get(LastUpdates.type) ??
            DateTime.now().toLocal().toIso8601String());

    return isarRes.map((e) => e.toModel(lastUpdate)).toList();
  }

  @override
  Future<State> getMaterialByTypeId(bool isFullRefresh, int typeId) {
    // TODO: implement getMaterialByTypeId
    throw UnimplementedError();
  }
}
