import 'package:bloc/bloc.dart';
import 'package:omborchi/core/network/network_state.dart';
import 'package:omborchi/feature/main/domain/repository/category_repository.dart';
import 'package:omborchi/feature/main/domain/repository/product_repository.dart';
import 'package:omborchi/feature/main/domain/repository/raw_material_repository.dart';
import 'package:omborchi/feature/main/domain/repository/type_repository.dart';

part 'sync_event.dart';
part 'sync_state.dart';

class SyncBloc extends Bloc<SyncEvent, SyncState> {
  final CategoryRepository categoryRepository;
  final RawMaterialRepository rawMaterialRepository;
  final TypeRepository typeRepository;
  final ProductRepository productRepository;

  SyncBloc(this.categoryRepository, this.rawMaterialRepository,
      this.typeRepository, this.productRepository)
      : super(SyncState(isLoading: false, isSuccess: false)) {
    on<SyncGetDataEvent>((event, emit) async {
      emit(state.copyWith(isLoading: true));
      final syncCategories = await categoryRepository.syncCategories();
      final syncTypes = await typeRepository.getTypes(true);
      final syncMaterials = await rawMaterialRepository.getRawMaterials();
      if (syncCategories is Success &&
          syncTypes is Success &&
          syncMaterials is Success) {
        emit(state.copyWith(isLoading: false, isSuccess: true));
      }
    });
  }
}
