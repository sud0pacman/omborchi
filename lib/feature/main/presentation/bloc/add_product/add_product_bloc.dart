import 'dart:io';

import 'package:bloc/bloc.dart';
import 'package:dio/dio.dart';
import 'package:internet_connection_checker/internet_connection_checker.dart';
import 'package:omborchi/core/custom/extensions/string_extensions.dart';
import 'package:omborchi/core/network/network_state.dart';
import 'package:omborchi/core/utils/consants.dart';
import 'package:omborchi/feature/main/domain/model/category_model.dart';
import 'package:omborchi/feature/main/domain/model/product_model.dart';
import 'package:omborchi/feature/main/domain/model/raw_material.dart';
import 'package:omborchi/feature/main/domain/model/raw_material_type.dart';
import 'package:omborchi/feature/main/domain/repository/product_repository.dart';
import 'package:path_provider/path_provider.dart';

import '../../../domain/model/cost_model.dart';

part 'add_product_event.dart';
part 'add_product_state.dart';

class AddProductBloc extends Bloc<AddProductEvent, AddProductState> {
  final ProductRepository productRepository;
  final InternetConnectionChecker networkChecker = InternetConnectionChecker();
  int counter = 0;

  AddProductBloc(this.productRepository)
      : super(AddProductState(categories: [], rawMaterials: {})) {
    on<GetCategories>((event, emit) async {
      final categoryRes = await productRepository.getCategories();

      AppRes.logger.i(categoryRes.toString());

      if (categoryRes is Success) {
        emit(state.copyWith(
            categories: categoryRes.value as List<CategoryModel>));
      } else {
        AppRes.logger.e(categoryRes.exception);
      }
    });

    on<GetRawMaterialsWithTypes>((event, emit) async {
      final res = await productRepository.getRawMaterialsWithTypes();

      AppRes.logger.i(res.toString());

      if (res is Success) {
        final Map<RawMaterialType, List<RawMaterial>> rawMaterials = res.value;

        emit(state.copyWith(rawMaterials: rawMaterials));
      } else if (res is NoInternet) {
        emit(state.copyWith(error: 'Internetingiz yaroqsiz'));
      } else if (res is GenericError) {
        emit(state.copyWith(error: 'Qandaydir xatolik'));
      } else {
        emit(state.copyWith(error: 'Qandaydir xatolik'));
      }
    });
    on<AddProduct>((event, emit) async {
      final hasConnection = await networkChecker.hasConnection;
      if (hasConnection) {
        emit(state.copyWith(isLoading: true));
        final imageName = "${DateTime.now()}.jpg";
        var image = event.productModel.pathOfPicture ?? "";
        if (image.isFilePath()) {
          final response =
              await productRepository.uploadImage(imageName, image);
          if (response is Success) {
            final id = DateTime.now().millisecondsSinceEpoch;
            final updatedTime = DateTime.now();
            image = response.value;
            AppRes.logger.w(image);
            final res = await productRepository.createProduct(event.productModel
                .copyWith(
                    id: id, pathOfPicture: image, updatedAt: updatedTime));
            if (res is Success) {
              final insertCostRes = await productRepository.addProductCost(
                event.costModels.map((e) {
                  counter++;
                  return e.copyWit(
                    productId: id,
                    id: DateTime.now().millisecondsSinceEpoch +
                        counter, // Ensures uniqueness
                  );
                }).toList(),
              );
              if (insertCostRes is Success) {
                final Directory appDir =
                    await getApplicationDocumentsDirectory();
                final String localImagePath = '${appDir.path}/$imageName';

                await Dio().download(image, localImagePath);

                AppRes.logger.t("Rasm lokalga yuklandi: $localImagePath");
                productRepository.saveProductToLocal(event.productModel
                    .copyWith(
                        pathOfPicture: localImagePath,
                        id: id,
                        updatedAt: updatedTime)
                    .toEntity());
                emit(state.copyWith(
                    isLoading: false, isSuccess: true, isBack: true));
              }
            } else if (res is NoInternet) {
              emit(state.copyWith(error: 'Internetingiz yaroqsiz'));
            } else if (res is GenericError) {
              emit(state.copyWith(error: 'Qandaydir xatolik'));
            } else {
              emit(state.copyWith(error: 'Qandaydir xatolik'));
            }
          } else if (response is GenericError) {}
        }
      } else {
        state.copyWith(error: Constants.noNetwork);
      }
    });
  }
}
