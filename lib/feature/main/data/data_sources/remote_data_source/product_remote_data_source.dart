import 'dart:async';
import 'dart:io';

import 'package:omborchi/core/network/network_state.dart';
import 'package:omborchi/core/utils/consants.dart';
import 'package:omborchi/feature/main/data/model/remote_model/cost_network.dart';
import 'package:omborchi/feature/main/data/model/remote_model/product_network.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

abstract interface class ProductRemoteDataSource {
  Future<State> getProductsByCategoryId(int categoryId);

  Future<State> getProducts();

  Future<State> getAllDeletedProductIds();

  Future<State> getProductById(int id);

  Future<State> getCosts();

  Future<State> createProduct(ProductNetwork product);

  Future<State> addProductCost(CostNetwork product);

  Future<State> updateProduct(ProductNetwork product);

  Future<State> deleteProduct(ProductNetwork product);

  Future<State> addDeletedProduct(int productId);

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
          .insert(product.toJson());

      return Success(newProduct);
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
  Future<State> addDeletedProduct(int productId) async {
    try {
      await supabaseClient
          .from(ExpenseFields.deletedProductTable)
          .insert({'product_id': productId});

      return Success("Muvaffaqiyatli");
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
  Future<State> getAllDeletedProductIds() async {
    try {
      // Supabasedan barcha product_id larni olish
      final response = await supabaseClient
          .from(ExpenseFields.deletedProductTable)
          .select('product_id');

      // Mapdan List<int>ga aylantirish
      final List<int> productIds =
          (response as List).map((item) => item['product_id'] as int).toList();

      return Success(productIds);
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
      await supabaseClient
          .from(ExpenseFields.productPriceTable)
          .insert(product.toJson());

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
  Future<State> getProductById(int id) async {
    try {
      final response = await supabaseClient
          .from(ExpenseFields.productTable)
          .select()
          .eq('id', id);

      final List<ProductNetwork> result =
          response.map((e) => ProductNetwork.fromJson(e)).toList();

      return Success(result.isNotEmpty ? result[0] : null);
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
  Future<State> deleteCost(int id) async {
    try {
      await supabaseClient
          .from(ExpenseFields.productPriceTable)
          .delete()
          .eq('product_id', id);

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
          .eq('category_id', categoryId)
          .order('nomer', ascending: true); // Ascending: ko'tarilgan tartibda

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
