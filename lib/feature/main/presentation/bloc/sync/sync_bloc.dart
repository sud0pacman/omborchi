import 'package:bloc/bloc.dart';
import 'package:omborchi/core/network/network_state.dart';
import 'package:omborchi/core/utils/consants.dart';
import 'package:omborchi/feature/main/domain/repository/category_repository.dart';
import 'package:omborchi/feature/main/domain/repository/product_repository.dart';
import 'package:omborchi/feature/main/domain/repository/raw_material_repository.dart';
import 'package:omborchi/feature/main/domain/repository/type_repository.dart';
import 'package:shared_preferences/shared_preferences.dart';

part 'sync_event.dart';
part 'sync_state.dart';

class SyncBloc extends Bloc<SyncEvent, SyncState> {
  final CategoryRepository categoryRepository;
  final RawMaterialRepository rawMaterialRepository;
  final TypeRepository typeRepository;
  final ProductRepository productRepository;

  Future<void> setSyncStatus(bool isSynced) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setBool('isSynced', isSynced);
  }

  SyncBloc(this.categoryRepository, this.rawMaterialRepository,
      this.typeRepository, this.productRepository)
      : super(SyncState(isLoading: false, isSuccess: false)) {
    on<SyncGetDataEvent>((event, emit) async {
      emit(state.copyWith(isLoading: true));
      final syncCategories = await categoryRepository.syncCategories();
      final syncTypes = await typeRepository.getTypes(true);
      final syncMaterials = await rawMaterialRepository.getRawMaterials();
      final syncProducts = await productRepository.syncProducts();
      if (syncCategories is Success &&
          syncTypes is Success &&
          syncProducts is Success &&
          syncMaterials is Success) {
        await setSyncStatus(true);
        emit(state.copyWith(isLoading: false, isSuccess: true));
      }
    });
  }
}
