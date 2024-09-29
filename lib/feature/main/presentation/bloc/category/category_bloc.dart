import 'package:bloc/bloc.dart';
import 'package:omborchi/core/network/network_state.dart';
import 'package:omborchi/feature/main/domain/model/category_model.dart';
import 'package:omborchi/feature/main/domain/repository/category_repository.dart';

part 'category_event.dart';
part 'category_state.dart';

class CategoryBloc extends Bloc<CategoryEvent, CategoryState> {
  final CategoryRepository categoryRepository;

  CategoryBloc(this.categoryRepository) : super(CategoryState(categories: [])) {
    on<GetCategories>((event, emit) async {
      emit(state.copyWith(isLoading: true));

      final getResponse = await categoryRepository.getCategories();

      if (getResponse is Success) {
        emit(state.copyWith(categories: getResponse.value));
      } else if (getResponse is NoInternet) {
        emit(state.copyWith(errorMsg: 'Internetingiz yaroqsiz'));
      } else if (getResponse is GenericError) {
        emit(state.copyWith(errorMsg: 'Qandaydir xatolik'));
      } else {
        emit(state.copyWith(errorMsg: 'Qandaydir xatolik'));
      }

      emit(state.copyWith(isLoading: false));
    });

    on<RefreshCategories>((event, emit) async {
      emit(state.copyWith(isLoading: true));

      final synchResponse = await categoryRepository.syncCategories();

      if (synchResponse is Success) {
        emit(state.copyWith(categories: synchResponse.value));
      } else if (synchResponse is NoInternet) {
        emit(state.copyWith(errorMsg: 'Internetingiz yaroqsiz'));
      } else if (synchResponse is GenericError) {
        emit(state.copyWith(errorMsg: 'Qandaydir xatolik'));
      } else {
        emit(state.copyWith(errorMsg: 'Qandaydir xatolik'));
      }

      emit(state.copyWith(isLoading: false));
    });

    on<CreateCategory>((event, emit) async {
      emit(state.copyWith(isLoading: true));

      final createResponse =
          await categoryRepository.createCategory(event.category);

      if (createResponse is Success) {
        state.categories.add(createResponse.value);
        emit(state.copyWith(categories: state.categories));
      } else if (createResponse is NoInternet) {
        emit(state.copyWith(errorMsg: 'Internetingiz yaroqsiz'));
      } else if (createResponse is GenericError) {
        emit(state.copyWith(errorMsg: 'Qandaydir xatolik'));
      } else {
        emit(state.copyWith(errorMsg: 'Qandaydir xatolik'));
      }

      emit(state.copyWith(isLoading: false));
    });

    on<UpdateCategory>((event, emit) async {
      emit(state.copyWith(isLoading: true));

      final updateResponse =
          await categoryRepository.updateCategory(event.category);

      if (updateResponse is Success) {
        emit(state.copyWith(categories: updateResponse.value));
      } else if (updateResponse is NoInternet) {
        emit(state.copyWith(errorMsg: 'Internetingiz yaroqsiz'));
      } else if (updateResponse is GenericError) {
        emit(state.copyWith(errorMsg: 'Qandaydir xatolik'));
      } else {
        emit(state.copyWith(errorMsg: 'Qandaydir xatolik'));
      }

      emit(state.copyWith(isLoading: false));
    });

    on<DeleteCategory>((event, emit) async {
      emit(state.copyWith(isLoading: true));

      final deleteResponse =
          await categoryRepository.deleteCategory(event.category);

      if (deleteResponse is Success) {
        state.categories.remove(event.category);
        emit(state.copyWith(categories: state.categories));
      } else if (deleteResponse is NoInternet) {
        emit(state.copyWith(errorMsg: 'Internetingiz yaroqsiz'));
      } else if (deleteResponse is GenericError) {
        emit(state.copyWith(errorMsg: 'Qandaydir xatolik'));
      } else {
        emit(state.copyWith(errorMsg: 'Qandaydir xatolik'));
      }

      emit(state.copyWith(isLoading: false));
    });
  }
}