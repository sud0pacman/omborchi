import 'package:bloc/bloc.dart';
import 'package:internet_connection_checker/internet_connection_checker.dart';
import 'package:omborchi/core/network/network_state.dart';
import 'package:omborchi/core/utils/consants.dart';
import 'package:omborchi/feature/main/domain/model/category_model.dart';
import 'package:omborchi/feature/main/domain/model/product_model.dart';
import 'package:omborchi/feature/main/domain/repository/category_repository.dart';
import 'package:omborchi/feature/main/domain/repository/product_repository.dart';

import '../../../domain/repository/raw_material_repository.dart';
import '../../../domain/repository/type_repository.dart';

part 'main_event.dart';
part 'main_state.dart';

class MainBloc extends Bloc<MainEvent, MainState> {
  final CategoryRepository categoryRepository;
  final RawMaterialRepository rawMaterialRepository;
  final TypeRepository typeRepository;
  final ProductRepository productRepository;
  final InternetConnectionChecker networkChecker = InternetConnectionChecker();

  MainBloc(this.categoryRepository, this.rawMaterialRepository,
      this.typeRepository, this.productRepository)
      : super(MainState(
            categories: [],
            products: [],
            isLoading: false,
            isOpenDialog: false,
            isCloseDialog: false,
            syncProgress: null,
            currentRepository: null,
            error: null,
            currentRepositoryIndex: null,
            isEmpty: false)) {
    // Load categories
    on<GetCategories>((event, emit) async {
      final res = await categoryRepository.getCategories();
      if (res is Success) {
        emit(state.copyWith(categories: res.value, isLoading: false));
      } else {
        emit(state.copyWith(isLoading: false));
      }
    });
    on<SyncAppEvent>((event, emit) async {
      final bool hasNetwork = await networkChecker.hasConnection;
      if (hasNetwork) {
        var repoIndex = 0;
        for (var value in event.values) {
          if (value == "Kategoriya") {
            ++repoIndex;
            emit(state.copyWith(
                isLoading: true,
                syncProgress: 0,
                currentRepository: "Kategoriyalar",
                currentRepositoryIndex: repoIndex));
            final categorySyncRes =
                await categoryRepository.syncCategories((progress) {
              emit(state.copyWith(
                  syncProgress: progress)); // Update UI with progress
            });
            if (categorySyncRes is Success) {
              emit(state.copyWith(syncProgress: 100));
            } else if (categorySyncRes is NoInternet) {
              emit(state.copyWith(error: categorySyncRes.value));
            }
          } else if (value == "Xomashyo turi") {
            ++repoIndex;
            emit(state.copyWith(
                syncProgress: 0,
                isLoading: true,
                currentRepository: "Turlar",
                currentRepositoryIndex: repoIndex));
            final typeSyncRes = await typeRepository.getTypes(true, (progress) {
              emit(state.copyWith(syncProgress: progress));
            });
            if (typeSyncRes is Success) {
              emit(state.copyWith(syncProgress: 100));
            } else if (typeSyncRes is NoInternet) {
              emit(state.copyWith(error: typeSyncRes.value));
            }
          } else if (value == "Xomashyo") {
            repoIndex++;
            emit(state.copyWith(
                syncProgress: 0,
                isLoading: true,
                currentRepository: "Xomashyolar",
                currentRepositoryIndex: repoIndex));
            final rawMaterialSyncRes =
                await rawMaterialRepository.getRawMaterials((progress) {
              emit(state.copyWith(syncProgress: progress));
            });
            if (rawMaterialSyncRes is Success) {
              emit(state.copyWith(syncProgress: 100));
            } else if (rawMaterialSyncRes is NoInternet) {
              emit(state.copyWith(error: rawMaterialSyncRes.value));
            }
          } else if (value == "Tannarx") {
            repoIndex++;
            emit(state.copyWith(
                syncProgress: 0,
                isLoading: true,
                currentRepository: "Tannarxlar",
                currentRepositoryIndex: repoIndex));
            final costSyncRes = await productRepository.syncCosts((progress) {
              emit(state.copyWith(syncProgress: progress));
            });
            if (costSyncRes is Success) {
              emit(state.copyWith(syncProgress: 100));
            } else if (costSyncRes is NoInternet) {
              emit(state.copyWith(error: costSyncRes.value));
            }
          } else if (value == "Mahsulot") {
            repoIndex++;
            emit(state.copyWith(
                syncProgress: 0,
                isLoading: true,
                currentRepository: "Mahsulotlar",
                currentRepositoryIndex: repoIndex));
            final productSyncRes =
                await productRepository.syncProducts((progress) {
              emit(state.copyWith(syncProgress: progress));
            });
            if (productSyncRes is Success) {
              emit(state.copyWith(syncProgress: 100));
            } else if (productSyncRes is NoInternet) {
              emit(state.copyWith(error: productSyncRes.value));
            }
          }
        }
        emit(state.copyWith(isLoading: false));
      } else {
        emit(state.copyWith(error: Constants.noNetwork));
      }
    });

    // Load products for a selected category
    on<GetProductsByCategory>((event, emit) async {
      AppRes.logger.d(event.categoryId);
      final res = event.categoryId == 0
          ? await productRepository.fetchAllProductsFromLocal()
          : await productRepository
              .fetchProductFromLocalByCategoryId(event.categoryId);

      final products = res; // Assume res.value contains the list of products
      AppRes.logger.d(event.categoryId);
      emit(state.copyWith(
        products: products,
        isLoading: false,
        isCloseDialog: false,
        isOpenDialog: false,
        isEmpty: products.isEmpty, // Check if the list is empty
      ));
    });
    on<GetLocalDataEvent>((event, emit) async {
      final res = event.categoryId == 0
          ? await productRepository.fetchAllProductsFromLocal()
          : await productRepository
              .fetchProductFromLocalByCategoryId(event.categoryId);
      final categoryResponse = await categoryRepository.getCategories();

      if (categoryResponse is Success) {
        final products = res;
        emit(state.copyWith(
          products: products,
          categories: categoryResponse.value,
          isLoading: false,
          isOpenDialog: false,
          isCloseDialog: true,
          isEmpty: products.isEmpty,
        ));

        // Trigger the category-based product fetch after syncing
        add(GetProductsByCategory(event.categoryId));
      } else {
        emit(state.copyWith(
            isLoading: false, isOpenDialog: false, isCloseDialog: true));
      }
    });
    on<DeleteProduct>((event, emit) async {
      final res = await productRepository.deleteProduct(event.product);

      if (res is Success) {
        add(GetLocalDataEvent(event.categoryId));
      } else {
        emit(state.copyWith(
            isLoading: false, isOpenDialog: false, isCloseDialog: true));
      }
    });

    on<GetProductById>((event, emit) async {
      AppRes.logger.d(event.nomer);
      // Fetch products from Isar DB based on category ID
      final res = await productRepository.fetchProductFromLocalById(
          event.nomer, event.selectedIndex);

      final products = res; // Assume res.value contains the list of products
      AppRes.logger.d(event.nomer);
      emit(state.copyWith(
        products: products,
        isLoading: false,
        isEmpty: products.isEmpty, // Check if the list is empty
      ));
    });
    on<GetProductsByQuery>((event, emit) async {
      final res = await productRepository.fetchProductFromLocalByQuery(
          event.nomer,
          event.eni,
          event.boyi,
          event.narxi,
          event.marja,
          event.categoryId);

      final products = res; // Assume res.value contains the list of products
      AppRes.logger.d(event.nomer);
      emit(state.copyWith(
        products: products,
        isLoading: false,
        isEmpty: products.isEmpty, // Check if the list is empty
      ));
    });
  }
}
