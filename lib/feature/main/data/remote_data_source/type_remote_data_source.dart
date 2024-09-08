import 'dart:async';
import 'dart:io';

import 'package:omborchi/feature/main/data/remote_data_source/model/raw_material_network.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../../../../core/network/network_state.dart';
import '../../../../core/utils/consants.dart';

abstract interface class TypeRemoteDataSource {
  Future<State> getTypes();
  Future<State> createType(RawMaterialNetwork type);
  Future<State> updateType(RawMaterialNetwork type);
  Future<State> deleteType(RawMaterialNetwork type);
}

class TypeRemoteDataSourceImpl implements TypeRemoteDataSource {
  final SupabaseClient supabaseClient;

  TypeRemoteDataSourceImpl(this.supabaseClient);

  @override
  Future<State> createType(RawMaterialNetwork type) async {
    AppRes.logger.t(type.toString());

    try {
      final newType = await supabaseClient
          .from(ExpenseFields.rawMaterialTypeTable)
          .insert(type.toJson())
          .select()
          .single();

      return Success(RawMaterialNetwork.fromJson(newType));
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
  Future<State> deleteType(RawMaterialNetwork type) async {
    AppRes.logger.t(type.toString());
    try {
      final res = await supabaseClient
          .from(ExpenseFields.rawMaterialTypeTable)
          .delete()
          .eq('id', type.id!)
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
  Future<State> getTypes() async {
    try {
      final response = await supabaseClient
          .from(ExpenseFields.rawMaterialTypeTable)
          .select();

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
  Future<State> updateType(RawMaterialNetwork type) async {
    AppRes.logger.t(type.toString());
    
    try {
      final res = await supabaseClient
          .from(ExpenseFields.rawMaterialTypeTable)
          .update(type.toJson())
          .eq('id', type.id!)
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
}
