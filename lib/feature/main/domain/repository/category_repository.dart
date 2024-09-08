import 'package:omborchi/feature/main/domain/model/category_model.dart';

import '../../../../core/network/network_state.dart';

abstract interface class CategoryRepository {
  Future<State> getCategories();
  Future<State> createCategory(CategoryModel category);
  Future<State> updateCategory(CategoryModel category);
  Future<State> deleteCategory(CategoryModel category);
}