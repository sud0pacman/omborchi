import 'dart:async';
import 'dart:io';

import 'package:omborchi/core/network/network_state.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../../../../core/utils/consants.dart';
import 'model/category_network.dart';

abstract interface class CategoryRemoteDataSource {
  Future<State> getCategories();
  Future<State> createCategory(CategoryNetwork category);
  Future<State> updateCategory(CategoryNetwork category);
  Future<State> deleteCategory(CategoryNetwork category);
}

class CategoryRemoteDataSourceImpl implements CategoryRemoteDataSource {
  final SupabaseClient supabaseClient;

  CategoryRemoteDataSourceImpl(this.supabaseClient);

  @override
  Future<State> getCategories() async {
    try {
      final response =
          await supabaseClient.from(ExpenseFields.categoryTable).select();

      final result = response.map((e) => CategoryNetwork.fromJson(e)).toList();

      AppRes.logger.t(result.length);

      return Success(result);
    } on SocketException catch (e) {
      AppRes.logger.e(e);
      return NoInternet(Exception("No Internet"));
    } on TimeoutException catch (e) {
      AppRes.logger.e(e);
      return NoInternet(Exception("No Internet"));
    } catch (e) {
      AppRes.logger.e(e);
      return GenericError(e);
    }
  }

  @override
  Future<State> createCategory(CategoryNetwork category) async {
    AppRes.logger.t(category.toString());

    try {
      final newCategory = await supabaseClient
          .from(ExpenseFields.categoryTable)
          .insert(category.toJson())
          .select();

      return Success(newCategory);
    } on SocketException catch (e) {
      AppRes.logger.e(e);
      return NoInternet(Exception("No Internet"));
    } on TimeoutException catch (e) {
      AppRes.logger.e(e);
      return NoInternet(Exception("No Internet"));
    } catch (e) {
      AppRes.logger.e(e);
      return GenericError(e);
    }
  }

  @override
  Future<State> deleteCategory(CategoryNetwork category) async {
    AppRes.logger.t(category.toString());

    try {
      final res = await supabaseClient
          .from(ExpenseFields.categoryTable)
          .delete()
          .eq('id', category.id!)
          .single();

      return Success(CategoryNetwork.fromJson(res));
    } on SocketException catch (e) {
      AppRes.logger.e(e);
      return NoInternet(Exception("No Internet"));
    } on TimeoutException catch (e) {
      AppRes.logger.e(e);
      return NoInternet(Exception("No Internet"));
    } catch (e) {
      AppRes.logger.e(e);
      return GenericError(e);
    }
  }

  @override
  Future<State> updateCategory(CategoryNetwork category) async {
    try {
      AppRes.logger.t(category.toString());

      final res = await supabaseClient
          .from(ExpenseFields.categoryTable)
          .update(category.toJson())
          .eq('id', category.id!)
          .single();

      return Success(CategoryNetwork.fromJson(res));
    } on SocketException catch (e) {
      AppRes.logger.e(e);
      return NoInternet(Exception("No Internet"));
    } on TimeoutException catch (e) {
      AppRes.logger.e(e);
      return NoInternet(Exception("No Internet"));
    } catch (e) {
      AppRes.logger.e(e);
      return GenericError(e);
    }
  }
}
