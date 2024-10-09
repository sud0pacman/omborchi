import 'package:bloc/bloc.dart';
import 'package:omborchi/core/network/network_state.dart';
import 'package:omborchi/core/utils/consants.dart';
import 'package:omborchi/feature/main/domain/model/category_model.dart';
import 'package:omborchi/feature/main/domain/model/product_model.dart';
import 'package:omborchi/feature/main/domain/repository/category_repository.dart';
import 'package:omborchi/feature/main/domain/repository/product_repository.dart';

part 'main_event.dart';
part 'main_state.dart';

class MainBloc extends Bloc<MainEvent, MainState> {
  final CategoryRepository categoryRepository;
  final ProductRepository productRepository;

  MainBloc(this.categoryRepository, this.productRepository)
      : super(MainState(
            categories: [], products: [], isLoading: false, isEmpty: false)) {
    // Load categories
    on<GetCategories>((event, emit) async {
      emit(state.copyWith(isLoading: true)); // Show shimmer
      final res = await categoryRepository.getCategories();
      if (res is Success) {
        emit(state.copyWith(categories: res.value, isLoading: false));
      } else {
        emit(state.copyWith(isLoading: false));
      }
    });

    // Load products for a selected category
    on<GetProductsByCategory>((event, emit) async {
      emit(state.copyWith(isLoading: true)); // Show shimmer while loading
      AppRes.logger.d(event.categoryId);
      // Fetch products from Isar DB based on category ID
      final res = event.categoryId == 0
          ? await productRepository.fetchAllProductsFromLocal()
          : await productRepository
              .fetchProductFromLocalByCategoryId(event.categoryId);

      final products = res; // Assume res.value contains the list of products
      AppRes.logger.d(event.categoryId);
      emit(state.copyWith(
        products: products,
        isLoading: false,
        isEmpty: products.isEmpty, // Check if the list is empty
      ));
    });
    on<GetProductById>((event, emit) async {
      emit(state.copyWith(isLoading: true)); // Show shimmer while loading
      AppRes.logger.d(event.nomer);
      // Fetch products from Isar DB based on category ID
      final res =
          await productRepository.fetchProductFromLocalById(event.nomer);

      final products = res; // Assume res.value contains the list of products
      AppRes.logger.d(event.nomer);
      emit(state.copyWith(
        products: products,
        isLoading: false,
        isEmpty: products.isEmpty, // Check if the list is empty
      ));
    });
    on<GetProductsByQuery>((event, emit) async {
      emit(state.copyWith(isLoading: true)); // Show shimmer while loading
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
