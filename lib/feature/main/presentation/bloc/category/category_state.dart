part of 'category_bloc.dart';

class CategoryState {
  final List<CategoryModel> categories;
  final CategoryModel? deleteCategory;
  final CategoryModel? updateCategory;
  final CategoryModel? createCategory;
  final bool? isBack;
  final bool? isLoading;
  final String? errorMsg;

  CategoryState({
    required this.categories,
    this.deleteCategory,
    this.updateCategory,
    this.createCategory,
    this.isBack,
    this.isLoading,
    this.errorMsg,
  });

  CategoryState copyWith({
    List<CategoryModel>? categories,
    CategoryModel? deleteCategory,
    CategoryModel? updateCategory,
    CategoryModel? createCategory,
    bool? isBack,
    bool? isLoading,
    String? errorMsg,
  }) {
    return CategoryState(
        categories: categories ?? this.categories,
        deleteCategory: deleteCategory ?? this.deleteCategory,
        updateCategory: updateCategory ?? this.updateCategory,
        createCategory: createCategory ?? this.createCategory,
        isBack: isBack ?? this.isBack,
        isLoading: isLoading ?? this.isLoading,
        errorMsg: errorMsg ?? this.errorMsg);
  }

  @override
  String toString() {
    return "CategoryState(categories: $categories, deleteCategory: $deleteCategory, updateCategory: $updateCategory, createCategory: $createCategory, isBack: $isBack, isLoading: $isLoading, errorMsg: $errorMsg)";
  }
}
