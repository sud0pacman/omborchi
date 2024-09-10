import 'dart:async';
import 'dart:io';

import 'package:omborchi/core/network/network_state.dart';
import 'package:omborchi/core/utils/consants.dart';
import 'package:omborchi/feature/main/data/model/remote_model/raw_material_type_network.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

abstract interface class TypeRemoteDataSource {
  Future<State> getTypes();
  Future<State> createType(RawMaterialTypeNetwork type);
  Future<State> updateType(RawMaterialTypeNetwork type);
  Future<State> deleteType(RawMaterialTypeNetwork type);
}

class TypeRemoteDataSourceImpl implements TypeRemoteDataSource {
  final SupabaseClient supabaseClient;

  TypeRemoteDataSourceImpl(this.supabaseClient);

  @override
  Future<State> createType(RawMaterialTypeNetwork type) async {
    AppRes.logger.t(type.toString());

    try {
      final newType = await supabaseClient
          .from(ExpenseFields.rawMaterialTypeTable)
          .insert(type.toJson())
          .select()
          .single();

      return Success(RawMaterialTypeNetwork.fromJson(newType));
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
  Future<State> deleteType(RawMaterialTypeNetwork type) async {
    AppRes.logger.t(type.toString());
    try {
      final res = await supabaseClient
          .from(ExpenseFields.rawMaterialTypeTable)
          .delete()
          .eq('id', type.id!)
          .single();

      return Success(RawMaterialTypeNetwork.fromJson(res));
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
  Future<State> getTypes() async {
    try {
      final response = await supabaseClient
          .from(ExpenseFields.rawMaterialTypeTable)
          .select();

      final res = response.map((e) => RawMaterialTypeNetwork.fromJson(e)).toList();

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
  Future<State> updateType(RawMaterialTypeNetwork type) async {
    AppRes.logger.t(type.toString());

    try {
      final res = await supabaseClient
          .from(ExpenseFields.rawMaterialTypeTable)
          .update(type.toJson())
          .eq('id', type.id!)
          .single();

      return Success(RawMaterialTypeNetwork.fromJson(res));
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
