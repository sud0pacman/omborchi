part of 'main_bloc.dart';

class MainState {
  final List<CategoryModel> categories;

  MainState copyWith({
    List<CategoryModel>? categories,
  }) {
    return MainState(
      categories: categories ?? this.categories,
    );
  }


  MainState({required this.categories});
}
