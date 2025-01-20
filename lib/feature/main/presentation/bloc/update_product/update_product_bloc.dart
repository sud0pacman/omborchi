import 'dart:io';

import 'package:bloc/bloc.dart';
import 'package:dio/dio.dart';
import 'package:internet_connection_checker/internet_connection_checker.dart';
import 'package:omborchi/core/network/network_state.dart';
import 'package:omborchi/core/utils/consants.dart';
import 'package:omborchi/feature/main/data/model/local_model/type_entity.dart';
import 'package:omborchi/feature/main/data/model/remote_model/product_network.dart';
import 'package:omborchi/feature/main/domain/model/category_model.dart';
import 'package:omborchi/feature/main/domain/model/product_model.dart';
import 'package:omborchi/feature/main/domain/model/raw_material.dart';
import 'package:omborchi/feature/main/domain/model/raw_material_type.dart';
import 'package:omborchi/feature/main/domain/repository/product_repository.dart';
import 'package:omborchi/feature/main/domain/repository/raw_material_repository.dart';
import 'package:omborchi/feature/main/domain/repository/type_repository.dart';
import 'package:path_provider/path_provider.dart';

import '../../../data/model/local_model/raw_material_entity.dart';
import '../../../data/model/local_model/raw_material_ui.dart';
import '../../../domain/model/cost_model.dart';

part 'update_product_event.dart';
part 'update_product_state.dart';

class UpdateProductBloc extends Bloc<UpdateProductEvent, UpdateProductState> {
  final ProductRepository productRepository;
  final RawMaterialRepository rawMaterialRepository;
  final TypeRepository typeRepository;
  final InternetConnectionChecker networkChecker = InternetConnectionChecker();
  final List<int> costDeleteIds = [];
  int counter = 0;

  UpdateProductBloc(
      this.productRepository, this.rawMaterialRepository, this.typeRepository)
      : super(UpdateProductState(
            categories: [], rawMaterials: {}, uiMaterials: [])) {
    on<GetProductMaterials>((event, emit) async {
      final costRes = await productRepository.getCostListById(event.productId);
      costDeleteIds.clear();
      final List<RawMaterialUpdate> materialUiList = [];
      for (var cost in costRes) {
        costDeleteIds.add(cost.id);
        final materialRes =
            await rawMaterialRepository.getMaterialById(cost.xomashyoId);
        if (materialRes is Success) {
          final RawMaterialEntity rawMaterialEntity = materialRes.value;
          AppRes.logger.w("${rawMaterialEntity.typeId}");
          final TypeEntity? typeEntity =
              await typeRepository.getTypeByIdLocal(rawMaterialEntity.typeId);
          AppRes.logger.w("$rawMaterialEntity $typeEntity");
          materialUiList.add(RawMaterialUpdate(
              rawMaterial: rawMaterialEntity.toModel(DateTime(2024, 8, 19)),
              rawMaterialType: typeEntity?.toModel(DateTime(2024, 8, 19)),
              quantity: cost.quantity));
        }
      }
      emit(state.copyWith(isLoading: false, uiMaterials: materialUiList));
    });
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
    on<UpdateProduct>((event, emit) async {
      final hasConnection = await networkChecker.hasConnection;
      String image = event.productModel.pathOfPicture ?? Constants.noImage;
      final imageName = "${DateTime.now()}.jpg";
      if (hasConnection) {
        emit(state.copyWith(isLoading: true));

        if (event.isImageChanged) {
          final response =
              await productRepository.uploadImage(imageName, image);
          if (response is Success) {
            image = response.value;
          }
        } else {
          final response = await productRepository
              .getProductByIdRemote(event.productModel.id ?? 0);
          if (response is Success) {
            final ProductNetwork value = response.value;
            image = value.pathOfPicture ?? Constants.noImage;
          }
        }
        final updatedTime = DateTime.now();
        final res = await productRepository.updateProduct(event.productModel
            .copyWith(pathOfPicture: image, updatedAt: updatedTime));
        if (res is Success) {
          final deleteCostsRes =
              await productRepository.deleteCosts(event.productModel.id!);
          if (deleteCostsRes is Success) {
            AppRes.logger.t("deleteCostsRes Success");
            final insertCostRes = await productRepository.addProductCost(
              event.costModels.map((e) {
                counter++;
                return e.copyWit(
                  productId: event.productModel.id,
                  id: DateTime.now().millisecondsSinceEpoch +
                      counter, // Ensures uniqueness
                );
              }).toList(),
            );
            if (insertCostRes is Success) {
              AppRes.logger.t("insertCostRes Success");
              String? localImagePath = event.productModel.pathOfPicture;
              if (event.isImageChanged) {
                final Directory appDir =
                    await getApplicationDocumentsDirectory();
                localImagePath = '${appDir.path}/$imageName';

                await Dio().download(image, localImagePath);
                AppRes.logger.t("Rasm lokalga yuklandi: $localImagePath");
              }
              productRepository.updateLocalProduct(event.productModel
                  .copyWith(
                      pathOfPicture: localImagePath, updatedAt: updatedTime)
                  .toEntity());
              emit(state.copyWith(
                  isLoading: false, isSuccess: true, isBack: true));
            }
          }
        } else if (res is NoInternet) {
          emit(state.copyWith(error: 'Internetingiz yaroqsiz'));
        } else if (res is GenericError) {
          emit(state.copyWith(error: 'Qandaydir xatolik'));
        } else {
          emit(state.copyWith(error: 'Qandaydir xatolik'));
        }
      } else {
        state.copyWith(error: Constants.noNetwork);
      }
    });
  }
}
