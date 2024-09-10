import 'dart:async';
import 'dart:io';

import 'package:omborchi/core/network/network_state.dart';
import 'package:omborchi/core/utils/consants.dart';
import 'package:omborchi/feature/main/data/model/remote_model/product_network.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import 'package:image_picker/image_picker.dart';

abstract interface class ProductRemoteDataSource {
  Future<State> getProducts(int categoryId);
  Future<State> createProduct(ProductNetwork product);
  Future<State> updateProduct(ProductNetwork product);
  Future<State> deleteProduct(ProductNetwork product);
  Future<State> uploadImage(String imageName, XFile file);
  Future<State> downloadImage({required String path, required String name});
}

class ProductRemoteDataSourceImpl implements ProductRemoteDataSource {
  final SupabaseClient supabaseClient;

  ProductRemoteDataSourceImpl(this.supabaseClient);

  @override
  Future<State> createProduct(ProductNetwork product) async {
    AppRes.logger.t(product.toString());

    try {
      final newProduct = await supabaseClient
          .from(ExpenseFields.productTable)
          .insert(product.toJson())
          .select()
          .single();

      return Success(ProductNetwork.fromJson(newProduct));
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
  Future<State> deleteProduct(ProductNetwork product) async {
    AppRes.logger.t(product.toString());
    try {
      final res = await supabaseClient
          .from(ExpenseFields.productTable)
          .delete()
          .eq('id', product.id!)
          .single();

      return Success(ProductNetwork.fromJson(res));
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
  Future<State> getProducts(int categoryId) async {
    AppRes.logger.t(categoryId);
    try {
      final response = await supabaseClient
          .from(ExpenseFields.productTable)
          .select()
          .eq('category_id', categoryId);

      final List<ProductNetwork> result =
          response.map((e) => ProductNetwork.fromJson(e)).toList();

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
  Future<State> updateProduct(ProductNetwork product) async {
    AppRes.logger.t(product.toString());
    try {
      final newProduct = await supabaseClient
          .from(ExpenseFields.productTable)
          .update(product.toJson())
          .eq('id', product.id!)
          .single();

      return Success(ProductNetwork.fromJson(newProduct));
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
  Future<State> uploadImage(String imageName, XFile image) async {
    try {
      final bytes = await image.readAsBytes();
      String path = 'images/$imageName'; // Supabase'da rasm saqlanadigan yo'l
      final response = await Supabase.instance.client.storage
          .from(ExpenseFields.productImageBucket)
          .uploadBinary(path, bytes);

      AppRes.logger.t(response);

      return Success(response);
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
  Future<State> downloadImage(
      {required String path, required String name}) async {
    try {
      final res = await supabaseClient.storage
          .from(ExpenseFields.productImageBucket)
          .download('$path/$name');

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
}
