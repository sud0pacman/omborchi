import 'dart:io';

import 'package:bloc/bloc.dart';
import 'package:dio/dio.dart';
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
      emit(state.copyWith(isLoading: true));
      final imageName = "${DateTime.now()}.jpg";
      var image = event.productModel.pathOfPicture ?? "";
      AppRes.logger.w(event.costModels.first.toString());
      if (image.isFilePath()) {
        final response = await productRepository.uploadImage(imageName, image);
        if (response is Success) {
          image = response.value;
          AppRes.logger.w(image);
          final res = await productRepository
              .createProduct(event.productModel.copyWith(pathOfPicture: image));
          if (res is Success) {
            final newProduct = await res.value as ProductModel;
            final secondRes = await productRepository.addProductCost(event
                .costModels
                .map((e) => e.copyWit(productId: newProduct.id))
                .toList());
            AppRes.logger.d(event.costModels
                .map((e) => e.copyWit(productId: newProduct.id))
                .toList()
                .length);
            if (secondRes is Success) {
              AppRes.logger.d("Success secondRes");
              await productRepository.saveCostListToLocal(event.costModels
                  .map((e) => e.copyWit(productId: newProduct.id))
                  .toList());
              final Directory appDir = await getApplicationDocumentsDirectory();
              final String localImagePath = '${appDir.path}/$imageName';

              await Dio().download(image, localImagePath);

              AppRes.logger.t("Rasm lokalga yuklandi: $localImagePath");
              productRepository.saveProductToLocal(event.productModel
                  .copyWith(pathOfPicture: localImagePath, id: newProduct.id)
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
    });
  }
}
