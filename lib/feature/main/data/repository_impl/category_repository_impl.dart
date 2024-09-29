import 'package:internet_connection_checker/internet_connection_checker.dart';
import 'package:isar/isar.dart';
import 'package:omborchi/core/custom/functions/custom_functions.dart';
import 'package:omborchi/core/modules/isar_helper.dart';
import 'package:omborchi/core/network/network_state.dart';
import 'package:omborchi/feature/main/data/data_sources/remote_data_source/category_remote_data_source.dart';
import 'package:omborchi/feature/main/data/model/local_model/category_entity.dart';
import 'package:omborchi/feature/main/data/model/remote_model/category_network.dart';

import 'package:omborchi/feature/main/domain/model/category_model.dart';
import 'package:omborchi/feature/main/domain/repository/category_repository.dart';

class CategoryRepositoryImpl implements CategoryRepository {
  final CategoryRemoteDataSource categoryRemoteDataSource;
  final InternetConnectionChecker networkChecker = InternetConnectionChecker();
  final isarHelper = IsarHelper();
  late DateTime now;

  CategoryRepositoryImpl(
    this.categoryRemoteDataSource,
  );

  @override
  Future<State> createCategory(CategoryModel category) async {
    final bool hasNetwork = await networkChecker.hasConnection;

    if (hasNetwork) {
      now = DateTime.now();

      final Id localId = await isarHelper.addCategory(category.copyWith(id: null, updatedAt: now).toLocal());

      final networkRes = await categoryRemoteDataSource.createCategory(
          category.copyWith(id: localId, updatedAt: now).toNetwork());

      if (networkRes is Success) {
        await setUpdateTime(now);
        return Success((networkRes.value as CategoryNetwork).toModel());
      } else {
        await isarHelper.deleteCategory(localId);
        return networkRes;
      }
    } else {
      return NoInternet(Exception("Weak Internet"));
    }
  }

  @override
  Future<State> deleteCategory(CategoryModel category) async {
    final bool hasNetwork = await networkChecker.hasConnection;

    if (hasNetwork) {
      final res =
          await categoryRemoteDataSource.deleteCategory(category.toNetwork());

      if (res is Success) {
        now = DateTime.now();
        await setUpdateTime(now);
        await isarHelper.deleteCategory(category.id!);

        return Success(res.value);
      } else {
        return res;
      }
    } else {
      return NoInternet('Weak network');
    }
  }

  @override
  Future<State> updateCategory(CategoryModel category) async {
    final bool hasNetwork = await networkChecker.hasConnection;

    if (hasNetwork) {
      now = DateTime.now();

      final res =
          await categoryRemoteDataSource.updateCategory(category.toNetwork());

      if (res is Success) {
        await setUpdateTime(now);
        await isarHelper.updateCategory(category.toLocal());
        return Success(await _getCategoriesFromLocal());
      } else {
        return res;
      }
    } else {
      return NoInternet('Weak network');
    }
  }

  @override
  Future<State> getCategories() async {
    return Success(await _getCategoriesFromLocal());
  }

  @override
  Future<State> syncCategories() async {
    final bool hasNetwork = await networkChecker.hasConnection;

    if (hasNetwork) {
      final networkRes = await categoryRemoteDataSource.getCategories();

      if (networkRes is Success) {
        now = DateTime.now();
        await setUpdateTime(now);

        final List<int> categoryIdList =
            await _getCategoriesFromLocal().then((value) {
          return value.map((e) => e.id!).toList();
        });

        final List<CategoryNetwork> categories = networkRes.value;
        final List<CategoryEntity> categoriesEntity =
            categories.map((e) => e.toLocal()).toList();

        await isarHelper.deleteAllCategories(categoryIdList);
        await isarHelper.insertAllCategories(categoriesEntity);

        return Success(await _getCategoriesFromLocal());
      } else {
        return networkRes;
      }
    } else {
      return NoInternet('Weak network');
    }
  }

  Future<List<CategoryModel>> _getCategoriesFromLocal() async {
    final isarRes = await isarHelper.getAllCategories();

    return isarRes.map((e) {
      return e.toModel(DateTime.now());
    }).toList();
  }
}
