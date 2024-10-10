part of 'main_bloc.dart';

class MainState {
  final List<CategoryModel> categories;
  final List<ProductModel?> products;
  final bool isLoading;  // for shimmer effect
  final bool isOpenDialog;  // for shimmer effect
  final bool isCloseDialog;  // for shimmer effect
  final bool isEmpty;    // for empty state

  MainState({
    required this.categories,
    required this.products,
    required this.isLoading,
    required this.isOpenDialog,
    required this.isCloseDialog,
    required this.isEmpty,
  });

  MainState copyWith({
    List<CategoryModel>? categories,
    List<ProductModel?>? products,
    bool? isLoading,
    bool? isOpenDialog,
    bool? isCloseDialog,
    bool? isEmpty,
  }) {
    return MainState(
      categories: categories ?? this.categories,
      products: products ?? this.products,
      isLoading: isLoading ?? this.isLoading,
      isOpenDialog: isOpenDialog ?? this.isOpenDialog,
      isCloseDialog: isCloseDialog ?? this.isCloseDialog,
      isEmpty: isEmpty ?? this.isEmpty,
    );
  }
}
