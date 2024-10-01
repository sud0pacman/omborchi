import 'package:bloc/bloc.dart';
import 'package:flutter/foundation.dart';
import 'package:meta/meta.dart';
import 'package:omborchi/core/network/network_state.dart';
import 'package:omborchi/core/utils/consants.dart';
import 'package:omborchi/feature/main/domain/model/category_model.dart';
import 'package:omborchi/feature/main/domain/model/raw_material.dart';
import 'package:omborchi/feature/main/domain/model/raw_material_type.dart';
import 'package:omborchi/feature/main/domain/repository/product_repository.dart';

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
      final rawMaterialsRes =
          await productRepository.getRawMaterialsWithTypes();

      AppRes.logger.i(rawMaterialsRes.toString());

      if (rawMaterialsRes is Success) {
        emit(state.copyWith(rawMaterials: rawMaterialsRes.value));
      } else {
        AppRes.logger.e(rawMaterialsRes.exception);
      }
    });
  }
}
