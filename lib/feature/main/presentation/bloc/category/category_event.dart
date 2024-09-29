part of 'category_bloc.dart';

class CategoryEvent {}

class GetCategories extends CategoryEvent {}

class RefreshCategories extends CategoryEvent {}

class CreateCategory extends CategoryEvent {
  final CategoryModel category;

  CreateCategory(this.category);
}

class UpdateCategory extends CategoryEvent {
  final CategoryModel category;

  UpdateCategory(this.category);
}

class DeleteCategory extends CategoryEvent {
  final CategoryModel category;

  DeleteCategory(this.category);
}
