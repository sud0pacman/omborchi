import 'dart:async';
import 'dart:io';

import 'package:omborchi/core/network/network_state.dart';
import 'package:omborchi/core/utils/consants.dart';
import 'package:omborchi/feature/main/data/model/remote_model/category_network.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

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
    try {
      final newCategory = await supabaseClient
          .from(ExpenseFields.categoryTable)
          .insert(category.toJson())
          .select()
          .single();

      AppRes.logger.t(newCategory);

      return Success(CategoryNetwork.fromJson(newCategory));
    } on SocketException catch (e) {
      AppRes.logger.e(e);
      return NoInternet(Exception("No Internet"));
    } on TimeoutException catch (e) {
      AppRes.logger.e(e);
      return NoInternet(Exception("No Internet"));
    } catch (e) {
      // Wrap the caught error in GenericError
      if (e is Exception) {
        // Standard exception wrapping
        AppRes.logger.e(e);
        return GenericError(e);
      } else {
        // Non-Exception errors (like _TypeError)
        AppRes.logger.e("Unknown Error: $e");
        return GenericError(Exception("Unexpected error occurred: $e"));
      }
    }
  }

  @override
  Future<State> deleteCategory(CategoryNetwork category) async {
    AppRes.logger.t(category.toString());

    try {
      await supabaseClient
          .from(ExpenseFields.categoryTable)
          .delete()
          .eq('id', category.id!);

      return Success(null);
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
          .eq('id', category.id!);

      AppRes.logger.t(res);

      return Success(null);
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
