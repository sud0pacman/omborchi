import 'dart:async';
import 'dart:io';

import 'package:omborchi/core/network/network_state.dart';
import 'package:omborchi/core/utils/consants.dart';
import 'package:omborchi/feature/main/data/model/remote_model/raw_material_network.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

abstract interface class RawMaterialRemoteDataSource {
  Future<State> getRawMaterials(int typeId);

  Future<State> createRawMaterial(RawMaterialNetwork rawMaterial);

  Future<State> updateRawMaterial(RawMaterialNetwork rawMaterial);

  Future<State> deleteRawMaterial(RawMaterialNetwork rawMaterial);
}

class RawMaterialRemoteDataSourceImpl implements RawMaterialRemoteDataSource {
  final SupabaseClient supabaseClient;

  RawMaterialRemoteDataSourceImpl(this.supabaseClient);

  @override
  Future<State> createRawMaterial(RawMaterialNetwork rawMaterial) async {
    AppRes.logger.t(rawMaterial.toString());
    try {
      var res =  await supabaseClient
          .from(ExpenseFields.rawMaterialTable)
          .insert(rawMaterial.toJson());

      return Success(res);
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
  Future<State> deleteRawMaterial(RawMaterialNetwork rawMaterial) async {
    AppRes.logger.t(rawMaterial.toString());
    try {
      await supabaseClient
          .from(ExpenseFields.rawMaterialTable)
          .delete()
          .eq('id', rawMaterial.id!);

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
  Future<State> getRawMaterials(int typeId) async {
    AppRes.logger.t(typeId);
    try {
      final response = await supabaseClient
          .from(ExpenseFields.rawMaterialTable)
          .select()
          .eq('type_id', typeId)
          .select();

      AppRes.logger.t(response.toString());

      final res = response.map((e) => RawMaterialNetwork.fromJson(e)).toList();

      AppRes.logger.t(res.length);

      return Success(res);
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
  Future<State> updateRawMaterial(RawMaterialNetwork rawMaterial) async {
    AppRes.logger.t(rawMaterial.toString());
    try {
      final res = await supabaseClient
          .from(ExpenseFields.rawMaterialTable)
          .update(rawMaterial.toJson())
          .eq('id', rawMaterial.id!)
          .select();

      AppRes.logger.i(res.toString());

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
