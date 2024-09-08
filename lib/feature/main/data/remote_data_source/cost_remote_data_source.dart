import 'dart:async';
import 'dart:io';

import 'package:supabase_flutter/supabase_flutter.dart';

import '../../../../core/network/network_state.dart';
import '../../../../core/utils/consants.dart';
import 'model/cost_network.dart';

abstract interface class CostRemoteDataSource {
  Future<State> getCosts(int productId);
  Future<State> createCost(CostNetwork cost);
  Future<State> updateCost(CostNetwork cost);
  Future<State> deleteCost(CostNetwork cost);
}

class CostRemoteDataSourceImpl implements CostRemoteDataSource {
  final SupabaseClient supabaseClient;

  CostRemoteDataSourceImpl(this.supabaseClient);

  @override
  Future<State> createCost(CostNetwork cost) async {
    try {
      AppRes.logger.t(cost.toString());

      final newCost = await supabaseClient
          .from(ExpenseFields.productPriceTable)
          .insert(cost.toJson())
          .select()
          .single();

      return Success(CostNetwork.fromJson(newCost));
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
  Future<State> deleteCost(CostNetwork cost) async {
    try {
      AppRes.logger.t(cost.toString());

      final res = await supabaseClient
          .from(ExpenseFields.productPriceTable)
          .delete()
          .eq('id', cost.id!)
          .select()
          .single();

      return Success(CostNetwork.fromJson(res));
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
  Future<State> getCosts(int productId) async {
    AppRes.logger.t(productId);

    try {
      final response = await supabaseClient
          .from(ExpenseFields.productPriceTable)
          .select()
          .eq('product_id', productId);

      final res = response.map((e) => CostNetwork.fromJson(e)).toList();

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
  Future<State> updateCost(CostNetwork cost) async {
    AppRes.logger.t(cost.toString());
    try {
      final res = await supabaseClient
          .from(ExpenseFields.productPriceTable)
          .update(cost.toJson())
          .eq('id', cost.id!)
          .single();

      return Success(CostNetwork.fromJson(res));
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