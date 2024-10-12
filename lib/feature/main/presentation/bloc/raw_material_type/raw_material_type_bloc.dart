import 'package:bloc/bloc.dart';
import 'package:internet_connection_checker/internet_connection_checker.dart';
import 'package:omborchi/core/network/network_state.dart';
import 'package:omborchi/core/utils/consants.dart';
import 'package:omborchi/feature/main/domain/model/raw_material_type.dart';
import 'package:omborchi/feature/main/domain/repository/type_repository.dart';

part 'raw_material_type_event.dart';
part 'raw_material_type_state.dart';

class RawMaterialTypeBloc
    extends Bloc<RawMaterialTypeEvent, RawMaterialTypeState> {
  final TypeRepository repo;
  final InternetConnectionChecker networkChecker = InternetConnectionChecker();

  RawMaterialTypeBloc(this.repo) : super(RawMaterialTypeInitial()) {
    on<GetTypes>((event, emit) async {
      emit(state.copyWith(isLoading: true));

      final State typesRes = await repo.getTypes(false, (progress) {});

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
      final bool hasNetwork = await networkChecker.hasConnection;
      if (hasNetwork) {
        emit(state.copyWith(isLoading: true));
        final typesRes = await repo.getTypes(true, (progress) {});

        AppRes.logger.i(typesRes.toString());

        if (typesRes is Success) {
          emit(state.copyWith(
              types: typesRes.value, isLoading: false, isCRUD: true));
        } else if (typesRes is NoInternet) {
          emit(state.copyWith(error: 'Internetingiz yaroqsiz'));
        } else if (typesRes is GenericError) {
          emit(state.copyWith(error: 'Qandaydir xatolik'));
        } else {
          emit(state.copyWith(error: 'Qandaydir xatolik'));
        }
      } else {
        emit(state.copyWith(error: Constants.noNetwork));
      }
    });

    on<CreateType>((event, emit) async {
      final bool hasNetwork = await networkChecker.hasConnection;
      if (hasNetwork) {
        emit(state.copyWith(isLoading: true));
        AppRes.logger.t(event.rawMaterialType.name);
        final createRes = await repo.createType(event.rawMaterialType);

        if (createRes is Success) {
          add(GetTypes());
        }
      } else {
        emit(state.copyWith(error: Constants.noNetwork));
      }
    });

    on<UpdateType>((event, emit) async {
      final bool hasNetwork = await networkChecker.hasConnection;
      if (hasNetwork) {
        emit(state.copyWith(isLoading: true));
        final updateRes = await repo.updateType(event.rawMaterialType);
        AppRes.logger.i(updateRes.toString());

        if (updateRes is Success) {
          emit(state.copyWith(isLoading: false, isCRUD: true));
        } else if (updateRes is NoInternet) {
          emit(state.copyWith(error: 'Internetingiz yaroqsiz'));
        } else if (updateRes is GenericError) {
          emit(state.copyWith(error: 'Qandaydir xatolik'));
        } else {
          emit(state.copyWith(error: 'Qandaydir xatolik'));
        }
      } else {
        emit(state.copyWith(error: Constants.noNetwork));
      }
    });

    on<DeleteType>((event, emit) async {
      final bool hasNetwork = await networkChecker.hasConnection;
      if (hasNetwork) {
        emit(state.copyWith(isLoading: true));
        final deleteRes = await repo.deleteType(event.rawMaterialType);

        AppRes.logger.i(deleteRes.toString());

        if (state is Success) {
          add(GetTypes());
          emit(state.copyWith(isLoading: false, isCRUD: true));
        } else if (deleteRes is NoInternet) {
          emit(state.copyWith(error: 'Internetingiz yaroqsiz'));
        } else if (deleteRes is GenericError) {
          emit(state.copyWith(error: 'Qandaydir xatolik'));
        } else {
          emit(state.copyWith(error: 'Qandaydir xatolik'));
        }
      } else {
        emit(state.copyWith(error: Constants.noNetwork));
      }
    });
  }
}
