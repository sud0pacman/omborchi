import 'package:internet_connection_checker/internet_connection_checker.dart';
import 'package:isar/isar.dart';
import 'package:omborchi/core/custom/functions/custom_functions.dart';
import 'package:omborchi/core/modules/isar_helper.dart';
import 'package:omborchi/core/network/network_state.dart';
import 'package:omborchi/core/utils/consants.dart';
import 'package:omborchi/feature/main/data/data_sources/remote_data_source/raw_material_remote_data_source.dart';

import 'package:omborchi/feature/main/domain/model/raw_material.dart';
import 'package:omborchi/feature/main/domain/repository/raw_material_repository.dart';
import '../model/remote_model/raw_material_network.dart';

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

      AppRes.logger.t(Id);

      final networkRes = await rawMaterialRemoteDataSource
          .createRawMaterial(rawMaterial.toNetwork().copyWith(id: localId));

      if (networkRes is Success) {
        now = DateTime.now();
        await setUpdateTime(now);
        return Success((networkRes.value as RawMaterialNetwork).toModel());
      } else {
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
      await setUpdateTime(now);
      final networkRes = await rawMaterialRemoteDataSource
          .updateRawMaterial(rawMaterial.copyWith(updatedAt: now).toNetwork());

      if (networkRes is Success) {
        await isarHelper.updateRawMaterial(rawMaterial.toEntity());
        return Success(rawMaterial);
      } else {
        return networkRes;
      }
    } else {
      return NoInternet(Exception("Weak Internet"));
    }
  }

  @override
  Future<State> getRawMaterials(int typeId, bool isFullRefresh) async {
    final bool hasNetwork = await networkChecker.hasConnection;

    if (hasNetwork && isFullRefresh) {
      final response =
          await rawMaterialRemoteDataSource.getRawMaterials(typeId);

      if (response is Success) {
        now = DateTime.now();
        await setUpdateTime(now);
        final List<RawMaterialNetwork> rawMaterials = response.value;
        final List<RawMaterial> rawMaterialsModel =
            rawMaterials.map((e) => e.toModel()).toList();

        await isarHelper.deleteAllRawMaterials(
            await _getRawMaterialsFromLocal().then((List<RawMaterial> value) {
          return value.map((e) => e.id!).toList();
        }));

        return Success(rawMaterialsModel);
      } else {
        return response;
      }
    } else {
      return Success(await _getRawMaterialsFromLocal());
    }
  }

  Future<List<RawMaterial>> _getRawMaterialsFromLocal() async {
    final isarRes = await isarHelper.getAllRawMaterials();

    return isarRes.map((e) {
      return e.toModel(DateTime.now());
    }).toList();
  }
}
