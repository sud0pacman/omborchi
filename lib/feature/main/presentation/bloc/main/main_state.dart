part of 'main_bloc.dart';

class MainState {
  final List<CategoryModel> categories;
  final List<ProductModel?> products;
  final bool isLoading;  // for shimmer effect
  final bool isEmpty;    // for empty state

  MainState({
    required this.categories,
    required this.products,
    required this.isLoading,
    required this.isEmpty,
  });

  MainState copyWith({
    List<CategoryModel>? categories,
    List<ProductModel?>? products,
    bool? isLoading,
    bool? isEmpty,
  }) {
    return MainState(
      categories: categories ?? this.categories,
      products: products ?? this.products,
      isLoading: isLoading ?? this.isLoading,
      isEmpty: isEmpty ?? this.isEmpty,
    );
  }
}
