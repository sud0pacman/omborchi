part of 'main_bloc.dart';

class MainState {
  final List<CategoryModel> categories;
  final List<ProductModel?> products;
  final bool isLoading;
  final bool isOpenDialog;
  final bool isCloseDialog;
  final bool isEmpty;
  final double? syncProgress;  // Sync progress percentage
  final String? currentRepository;  // Name of the repository being synced
  final String? error;  // Name of the repository being synced
  final int? currentRepositoryIndex;  // Order of the repository being synced

  MainState({
    required this.categories,
    required this.products,
    required this.isLoading,
    required this.isOpenDialog,
    required this.isCloseDialog,
    required this.isEmpty,
    required this.syncProgress,
    required this.currentRepository,
    required this.error,
    required this.currentRepositoryIndex,
  });

  MainState copyWith({
    List<CategoryModel>? categories,
    List<ProductModel?>? products,
    bool? isLoading,
    bool? isOpenDialog,
    bool? isCloseDialog,
    bool? isEmpty,
    double? syncProgress,
    String? currentRepository,
    String? error,
    int? currentRepositoryIndex,
  }) {
    return MainState(
      categories: categories ?? this.categories,
      products: products ?? this.products,
      isLoading: isLoading ?? this.isLoading,
      isOpenDialog: isOpenDialog ?? this.isOpenDialog,
      isCloseDialog: isCloseDialog ?? this.isCloseDialog,
      isEmpty: isEmpty ?? this.isEmpty,
      syncProgress: syncProgress ?? this.syncProgress,
      currentRepository: currentRepository ?? this.currentRepository,
      error: error ?? this.error,
      currentRepositoryIndex: currentRepositoryIndex ?? this.currentRepositoryIndex,
    );
  }
}

