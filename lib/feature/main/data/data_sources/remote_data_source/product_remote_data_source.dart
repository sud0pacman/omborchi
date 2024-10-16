import 'dart:async';
import 'dart:io';

import 'package:omborchi/core/network/network_state.dart';
import 'package:omborchi/core/utils/consants.dart';
import 'package:omborchi/feature/main/data/model/remote_model/cost_network.dart';
import 'package:omborchi/feature/main/data/model/remote_model/product_network.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../../../domain/model/product_model.dart';

abstract interface class ProductRemoteDataSource {
  Future<State> getProductsByCategoryId(int categoryId);

  Future<State> getProducts();

  Future<State> getCosts();

  Future<State> createProduct(ProductNetwork product);

  Future<State> addProductCost(CostNetwork product);

  Future<State> updateProduct(ProductNetwork product);

  Future<State> deleteProduct(ProductNetwork product);

  Future<State> deleteCost(int costId);

  Future<State> uploadImage(String imageName, String image);

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

      // Convert ProductNetwork to ProductModel here
      final productModel =
          ProductModel.fromNetwork(ProductNetwork.fromJson(newProduct));

      return Success(productModel);
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
  Future<State> addProductCost(CostNetwork product) async {
    AppRes.logger.t(product.toString());

    try {
      final newProduct = await supabaseClient
          .from(ExpenseFields.productPriceTable)
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
      await supabaseClient
          .from(ExpenseFields.productTable)
          .delete()
          .eq('id', product.id!);

      return Success("");
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
  Future<State> deleteCost(int costId) async {
    try {
      await supabaseClient
          .from(ExpenseFields.productPriceTable)
          .delete()
          .eq('id', costId);

      return Success("");
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
  Future<State> getProductsByCategoryId(int categoryId) async {
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
  Future<State> getProducts() async {
    try {
      final response =
          await supabaseClient.from(ExpenseFields.productTable).select('*');

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
  Future<State> getCosts() async {
    try {
      final response = await supabaseClient
          .from(ExpenseFields.productPriceTable)
          .select('*');

      final List<CostNetwork> result =
          response.map((e) => CostNetwork.fromJson(e)).toList();

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
      await supabaseClient
          .from(ExpenseFields.productTable)
          .update(product.toJson())
          .eq("id", product.id ?? 0);

      return Success("");
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
  Future<State> uploadImage(String imageName, String image) async {
    try {
      final bytes = await File(image).readAsBytes();
      String path = 'images/$imageName';
      await Supabase.instance.client.storage
          .from(ExpenseFields.productImageBucket)
          .uploadBinary(
            path,
            bytes,
            fileOptions: const FileOptions(cacheControl: '3600', upsert: false),
          );

      final String downloadUrl = Supabase.instance.client.storage
          .from(ExpenseFields.productImageBucket)
          .getPublicUrl(path);

      return Success(downloadUrl);
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
