import 'package:bloc/bloc.dart';
import 'package:internet_connection_checker/internet_connection_checker.dart';
import 'package:omborchi/core/network/network_state.dart';
import 'package:omborchi/feature/main/domain/repository/category_repository.dart';
import 'package:omborchi/feature/main/domain/repository/product_repository.dart';
import 'package:omborchi/feature/main/domain/repository/raw_material_repository.dart';
import 'package:omborchi/feature/main/domain/repository/type_repository.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../../../core/utils/consants.dart';

part 'sync_event.dart';
part 'sync_state.dart';

class SyncBloc extends Bloc<SyncEvent, SyncState> {
  final CategoryRepository categoryRepository;
  final RawMaterialRepository rawMaterialRepository;
  final TypeRepository typeRepository;
  final ProductRepository productRepository;
  final InternetConnectionChecker networkChecker = InternetConnectionChecker();

  Future<void> setSyncStatus(bool isSynced) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setBool('isSynced', isSynced);
  }

  SyncBloc(this.categoryRepository, this.rawMaterialRepository,
      this.typeRepository, this.productRepository)
      : super(SyncState(
          isLoading: false,
          isSuccess: false,
          syncProgress: null,
          currentRepository: null,
          error: null,
          currentRepositoryIndex: null,
        )) {
    on<SyncGetDataEvent>((event, emit) async {
      final bool hasNetwork = await networkChecker.hasConnection;
      if (hasNetwork) {
        emit(state.copyWith(
            isLoading: true,
            syncProgress: 0,
            currentRepository: "Kategoriyalar",
            currentRepositoryIndex: 1));

        // Sync Categories
        final categorySyncRes =
            await categoryRepository.syncCategories((progress) {
          emit(state.copyWith(
              syncProgress: progress)); // Update UI with progress
        });
        if (categorySyncRes is Success) {
          emit(state.copyWith(
              syncProgress: 100)); // Complete progress for category sync
        } else if (categorySyncRes is NoInternet) {
          emit(state.copyWith(error: categorySyncRes.value));
        }

        // Sync Types (Reset Progress)
        emit(state.copyWith(
            syncProgress: 0,
            currentRepository: "Turlar",
            currentRepositoryIndex: 2));
        final typeSyncRes = await typeRepository.getTypes(true, (progress) {
          emit(state.copyWith(syncProgress: progress));
        });
        if (typeSyncRes is Success) {
          emit(state.copyWith(syncProgress: 100));
        } else if (typeSyncRes is NoInternet) {
          emit(state.copyWith(error: typeSyncRes.value));
        }

        // Sync Raw Materials
        emit(state.copyWith(
            syncProgress: 0,
            currentRepository: "Xomashyolar",
            currentRepositoryIndex: 3));
        final rawMaterialSyncRes =
            await rawMaterialRepository.getRawMaterials((progress) {
          emit(state.copyWith(syncProgress: progress));
        });
        if (rawMaterialSyncRes is Success) {
          emit(state.copyWith(syncProgress: 100));
        } else if (rawMaterialSyncRes is NoInternet) {
          emit(state.copyWith(error: rawMaterialSyncRes.value));
        }
// Sync Costs
        emit(state.copyWith(
            syncProgress: 0,
            currentRepository: "Tannarxlar",
            currentRepositoryIndex: 4));
        final costSyncRes = await productRepository.syncCosts((progress) {
          emit(state.copyWith(syncProgress: progress));
        });
        if (costSyncRes is Success) {
          emit(state.copyWith(syncProgress: 100));
        } else if (costSyncRes is NoInternet) {
          emit(state.copyWith(error: costSyncRes.value));
        }
        emit(state.copyWith(
            syncProgress: 0,
            currentRepository: "Mahsulotlar",
            currentRepositoryIndex: 5));
        final productSyncRes = await productRepository.syncProducts((progress) {
          emit(state.copyWith(syncProgress: progress));
        });
        if (productSyncRes is Success) {
          emit(state.copyWith(syncProgress: 100));
        } else if (productSyncRes is NoInternet) {
          emit(state.copyWith(error: productSyncRes.value));
        }

        // End Sync
        emit(state.copyWith(isLoading: false, isSuccess: true));
      } else {
        emit(state.copyWith(error: Constants.noNetwork));
      }
    });
  }
}
