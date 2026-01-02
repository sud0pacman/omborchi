import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:crypto/crypto.dart';
import 'package:dio/dio.dart';
import 'package:dio/io.dart';
import 'package:http/http.dart' as http;
import 'package:http/io_client.dart';
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
      final file = File(image);
      final fileBytes = await file.readAsBytes();

      const String accountId = '04455701552c024s7485876e73f6cbfe1';
      const String accessKeyId = '248522beb13a04b75cf5a97c54d14456';
      const String secretAccessKey = '146bd52bd48a305fae851b27fdefec7e3520fc45359de70c419ac81a8e3aeead';
      const String bucketName = 'omborchi';
      const String region = 'auto';
      const String endpoint = 'https://$accountId.r2.cloudflarestorage.com';
      const String publicUrl = 'https://pub-ac2058e7c6384a688264ad7c4669cc88.r2.dev';

      final cleanImageName = imageName.replaceAll(RegExp(r'[^\w\.-]'), '_');
      String path = 'images/$cleanImageName';

      final now = DateTime.now().toUtc();
      final dateStamp = _formatDate(now);
      final amzDate = _formatDateTime(now);

      String contentType = 'image/jpeg';
      if (cleanImageName.toLowerCase().endsWith('.png')) {
        contentType = 'image/png';
      } else if (cleanImageName.toLowerCase().endsWith('.jpg') ||
          cleanImageName.toLowerCase().endsWith('.jpeg')) {
        contentType = 'image/jpeg';
      } else if (cleanImageName.toLowerCase().endsWith('.gif')) {
        contentType = 'image/gif';
      } else if (cleanImageName.toLowerCase().endsWith('.webp')) {
        contentType = 'image/webp';
      }

      final payloadHash = sha256.convert(fileBytes).toString();
      final canonicalUri = '/$bucketName/$path';
      final canonicalQueryString = '';
      final canonicalHeaders = 'host:$accountId.r2.cloudflarestorage.com\n'
          'x-amz-content-sha256:$payloadHash\n'
          'x-amz-date:$amzDate\n';

      final signedHeaders = 'host;x-amz-content-sha256;x-amz-date';

      final canonicalRequest = 'PUT\n'
          '$canonicalUri\n'
          '$canonicalQueryString\n'
          '$canonicalHeaders\n'
          '$signedHeaders\n'
          '$payloadHash';

      final algorithm = 'AWS4-HMAC-SHA256';
      final credentialScope = '$dateStamp/$region/s3/aws4_request';
      final canonicalRequestHash = sha256.convert(utf8.encode(canonicalRequest)).toString();

      final stringToSign = '$algorithm\n'
          '$amzDate\n'
          '$credentialScope\n'
          '$canonicalRequestHash';

      final signature = _calculateSignature(secretAccessKey, dateStamp, region, stringToSign);

      final authorization = '$algorithm Credential=$accessKeyId/$credentialScope, '
          'SignedHeaders=$signedHeaders, Signature=$signature';

      // MAXSUS HTTP CLIENT - SSL muammosini hal qiladi
      final httpClient = HttpClient()
        ..connectionTimeout = const Duration(seconds: 30)
        ..badCertificateCallback = (cert, host, port) => true;  // Barcha sertifikatlarni qabul qiladi

      final ioClient = IOClient(httpClient);

      final uploadUrl = '$endpoint/$bucketName/$path';

      final response = await ioClient.put(
        Uri.parse(uploadUrl),
        headers: {
          'Host': '$accountId.r2.cloudflarestorage.com',
          'x-amz-content-sha256': payloadHash,
          'x-amz-date': amzDate,
          'Authorization': authorization,
          'Content-Type': contentType,
          'Content-Length': fileBytes.length.toString(),
        },
        body: fileBytes,
      );

      ioClient.close();  // Client'ni yoping

      if (response.statusCode == 200 || response.statusCode == 204) {
        final String downloadUrl = '$publicUrl/$path';
        AppRes.logger.i('Upload successful: $downloadUrl');
        return Success(downloadUrl);
      } else {
        AppRes.logger.e('Upload failed: ${response.statusCode} - ${response.body}');
        return GenericError(Exception('Upload failed: ${response.statusCode}'));
      }

    } on HandshakeException catch (e) {
      AppRes.logger.e('HandshakeException: ${e.message}');
      return GenericError(Exception("SSL xatosi: ${e.message}"));
    } on SocketException catch (e) {
      AppRes.logger.e('SocketException: ${e.message}');
      return NoInternet(Exception("Internet yo'q"));
    } on TimeoutException catch (e) {
      AppRes.logger.e('TimeoutException: ${e.message}');
      return NoInternet(Exception("Vaqt tugadi"));
    } catch (e, stackTrace) {
      AppRes.logger.e('Error: $e');
      AppRes.logger.e('Stack: $stackTrace');
      return GenericError(Exception('Xatolik: $e'));
    }
  }

  String _formatDate(DateTime date) {
    return '${date.year}${date.month.toString().padLeft(2, '0')}${date.day.toString().padLeft(2, '0')}';
  }

  String _formatDateTime(DateTime date) {
    return '${_formatDate(date)}T'
        '${date.hour.toString().padLeft(2, '0')}'
        '${date.minute.toString().padLeft(2, '0')}'
        '${date.second.toString().padLeft(2, '0')}Z';
  }

  String _calculateSignature(String secretKey, String dateStamp, String region, String stringToSign) {
    final kDate = _hmacSha256(utf8.encode('AWS4$secretKey'), utf8.encode(dateStamp));
    final kRegion = _hmacSha256(kDate, utf8.encode(region));
    final kService = _hmacSha256(kRegion, utf8.encode('s3'));
    final kSigning = _hmacSha256(kService, utf8.encode('aws4_request'));
    final signature = _hmacSha256(kSigning, utf8.encode(stringToSign));

    return signature.map((byte) => byte.toRadixString(16).padLeft(2, '0')).join();
  }

  List<int> _hmacSha256(List<int> key, List<int> data) {
    final hmac = Hmac(sha256, key);
    return hmac.convert(data).bytes;
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
