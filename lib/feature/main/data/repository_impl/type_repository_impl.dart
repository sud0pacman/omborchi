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
      var id = DateTime.now().millisecondsSinceEpoch;
      now = DateTime.now();
      final networkRes = await typeRemoteDataSource
          .createType(type.copyWith(id: id, updatedAt: now).toNetwork());

      if (networkRes is Success) {
        await isarHelper.addType(type.copyWith(id: id).toEntity());
        return Success("Success");
      } else {
        return networkRes;
      }
    } else {
      return NoInternet(Exception(Constants.noNetwork));
    }
  }

  @override
  Future<State> deleteType(RawMaterialType type) async {
    final bool hasNetwork = await networkChecker.hasConnection;

    if (hasNetwork) {
      final networkRes =
      await typeRemoteDataSource.deleteType(type.toNetwork());

      if (networkRes is Success) {
        now = DateTime.now();
        await setUpdateTime();
        await isarHelper.deleteType(type.id!);
        return Success(null);
      } else {
        return networkRes;
      }
    } else {
      return NoInternet(Exception(Constants.noNetwork));
    }
  }

  @override
  Future<TypeEntity?> getTypeByIdLocal(int id) async {
    var isar = await isarHelper.db;
    var res = await isar.typeEntitys.filter().idEqualTo(id).findAll();
    return res.isNotEmpty ? res[0] : null;
  }

  @override
  Future<State> getTypes(
      bool isFullRefresh, Function(double) onProgress) async {
    if (isFullRefresh) {
      final res = await typeRemoteDataSource.getTypes();
      now = DateTime.now();
      if (res is Success) {
        await setUpdateTime();

        final List<TypeEntity> typeEntityList =
        (res.value as List<RawMaterialTypeNetwork>)
            .map((e) => e.toEntity())
            .toList();

        await isarHelper.clearTypes();
        await isarHelper.insertAllTypes(typeEntityList);
      } else if (res is NoInternet) {
        return NoInternet(Constants.noNetwork);
      }
    }

    return Success(await _getTypesFromLocal());
  }

  @override
  Future<State> updateType(RawMaterialType type) async {
    final bool hasNetwork = await networkChecker.hasConnection;

    if (hasNetwork) {
      now = DateTime.now();
      final networkRes = await typeRemoteDataSource
          .updateType(type.copyWith(updatedAt: now).toNetwork());

      if (networkRes is Success) {
        await setUpdateTime();
        await isarHelper.updateType(type.toEntity());
        return Success(type);
      } else {
        return networkRes;
      }
    } else {
      return NoInternet(Exception(Constants.noNetwork));
    }
  }

  Future<List<RawMaterialType>> _getTypesFromLocal() async {
    final isarRes = await isarHelper.getAllTypes();
    final lastUpdate = DateTime.parse(
        await Hive.box(ExpenseFields.myBox).get(LastUpdates.type) ??
            DateTime.now().toLocal().toIso8601String());

    return isarRes.map((e) {
      return e.toModel(lastUpdate);
    }).toList();
  }

  Future<void> setUpdateTime() async {
    final box = Hive.box(ExpenseFields.myBox);
    return await box.put(
      LastUpdates.type,
      now.toUtc().toIso8601String(),
    );
  }
}
