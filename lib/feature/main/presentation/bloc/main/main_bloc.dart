import 'package:bloc/bloc.dart';
import 'package:omborchi/core/network/network_state.dart';
import 'package:omborchi/core/utils/consants.dart';
import 'package:omborchi/feature/main/domain/model/category_model.dart';
import 'package:omborchi/feature/main/domain/repository/category_repository.dart';

part 'main_event.dart';
part 'main_state.dart';

class MainBloc extends Bloc<MainEvent, MainState> {
  final CategoryRepository categoryRepository;

  MainBloc(this.categoryRepository) : super(MainState(categories: [])) {
    on<GetCategories>((event, emit) async {
      final res = await categoryRepository.getCategories();

      AppRes.logger.i(res);

      if (res is Success) {
        emit(state.copyWith(categories: res.value));
      }
    });
  }
}
