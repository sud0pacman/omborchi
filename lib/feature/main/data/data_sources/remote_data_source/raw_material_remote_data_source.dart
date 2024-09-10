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

      final res = await supabaseClient
          .from(ExpenseFields.rawMaterialTable)
          .insert(rawMaterial.toJson())
          .single();

      return Success(RawMaterialNetwork.fromJson(res));
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
  Future<State> deleteRawMaterial(RawMaterialNetwork rawMaterial) async {
    AppRes.logger.t(rawMaterial.toString());
    try {
      final res = await supabaseClient
          .from(ExpenseFields.rawMaterialTable)
          .delete()
          .eq('id', rawMaterial.id!)
          .select()
          .single();

      return Success(RawMaterialNetwork.fromJson(res));
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
          .eq('type_id', typeId);

      final res = response.map((e) => RawMaterialNetwork.fromJson(e)).toList();

      AppRes.logger.t(res.length);

      return Success(res);
    }
    on SocketException catch (e) {
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
      final newRawMaterial = await supabaseClient.from(ExpenseFields.rawMaterialTable)
        .update(rawMaterial.toJson())
        .eq('id', rawMaterial.id!)
        .single();

      return Success(RawMaterialNetwork.fromJson(newRawMaterial));
    }
    on SocketException catch (e) {
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
