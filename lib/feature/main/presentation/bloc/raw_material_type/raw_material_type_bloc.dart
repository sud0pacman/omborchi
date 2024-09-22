import 'package:bloc/bloc.dart';
import 'package:omborchi/core/network/network_state.dart';
import 'package:omborchi/core/utils/consants.dart';
import 'package:omborchi/feature/main/domain/model/raw_material_type.dart';
import 'package:omborchi/feature/main/domain/repository/type_repository.dart';

part 'raw_material_type_event.dart';
part 'raw_material_type_state.dart';

class RawMaterialTypeBloc
    extends Bloc<RawMaterialTypeEvent, RawMaterialTypeState> {
  final TypeRepository repo;

  RawMaterialTypeBloc(this.repo) : super(RawMaterialTypeInitial()) {
    on<GetTypes>((event, emit) async {
      emit(state.copyWith(isLoading: true));
      final typesRes = await repo.getTypes(false);

      AppRes.logger.i(typesRes.toString());

      if (typesRes is Success) {
        emit(state.copyWith(types: typesRes.value, isLoading: false));
      } else if (typesRes is NoInternet) {
        emit(state.copyWith(error: 'Internetingiz yaroqsiz'));
      } else if (typesRes is GenericError) {
        emit(state.copyWith(error: 'Qandaydir xatolik'));
      } else {
        emit(state.copyWith(error: 'Qandaydir xatolik'));
      }
    });

    on<RefreshTypes>((event, emit) async {
      emit(state.copyWith(isLoading: true));
      final typesRes = await repo.getTypes(true);

      AppRes.logger.i(typesRes.toString());

      if (typesRes is Success) {
        emit(state.copyWith(types: typesRes.value, isLoading: false));
      } else if (typesRes is NoInternet) {
        emit(state.copyWith(error: 'Internetingiz yaroqsiz'));
      } else if (typesRes is GenericError) {
        emit(state.copyWith(error: 'Qandaydir xatolik'));
      } else {
        emit(state.copyWith(error: 'Qandaydir xatolik'));
      }
    });

    on<CreateType>((event, emit) async {
      emit(state.copyWith(isLoading: true));
      final createRes = await repo.createType(event.rawMaterialType);

      if (createRes is Success) {
        emit(state.copyWith(isLoading: false));
      }
    });
  }
}
