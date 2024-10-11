import 'package:bloc/bloc.dart';
import 'package:omborchi/core/network/network_state.dart';
import 'package:omborchi/core/utils/consants.dart';
import 'package:omborchi/feature/main/data/model/local_model/raw_material_entity.dart';
import 'package:omborchi/feature/main/data/model/local_model/raw_material_ui.dart';
import 'package:omborchi/feature/main/domain/model/product_model.dart';
import 'package:omborchi/feature/main/domain/repository/raw_material_repository.dart';

import '../../../domain/repository/product_repository.dart';

part 'product_view_event.dart';

part 'product_view_state.dart';

class ProductViewBloc extends Bloc<ProductViewEvent, ProductViewState> {
  final ProductRepository productRepository;
  final RawMaterialRepository rawMaterialRepository;

  ProductViewBloc(this.productRepository, this.rawMaterialRepository)
      : super(ProductViewState(materials: [], isLoading: false, isBack: false)) {
    on<GetProductMaterials>((event, emit) async {
      emit(state.copyWith(isLoading: true));
      final costRes = await productRepository.getCostListById(event.productId);
      AppRes.logger.d("Cost length in local ${costRes.length} ID = ${event.productId}");
      final List<RawMaterialUi> materialUiList = [];
      for (var cost in costRes) {
        final materialRes =
            await rawMaterialRepository.getMaterialById(cost.xomashyoId);
        if (materialRes is Success) {
          AppRes.logger.d("Get material Success ${(materialRes.value as RawMaterialEntity).name}");
          final RawMaterialEntity value = materialRes.value;
          materialUiList.add(RawMaterialUi(
              name: value.name, price: value.price, quantity: cost.quantity));
        }
      }
      emit(state.copyWith(isLoading: false, materials: materialUiList));
    });
    on<DeleteProduct>((event, emit) async {
      emit(state.copyWith(isLoading: true));
      final costRes = await productRepository.deleteProduct(event.product);
      if (costRes is Success) {
        emit(state.copyWith(isLoading: false, isBack: true));
      }

    });

  }
}
