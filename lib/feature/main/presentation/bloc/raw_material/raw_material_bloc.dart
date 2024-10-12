import 'package:bloc/bloc.dart';
import 'package:internet_connection_checker/internet_connection_checker.dart';
import 'package:omborchi/core/network/network_state.dart';
import 'package:omborchi/core/utils/consants.dart';
import 'package:omborchi/feature/main/domain/model/raw_material.dart';
import 'package:omborchi/feature/main/domain/model/raw_material_type.dart';
import 'package:omborchi/feature/main/domain/repository/raw_material_repository.dart';

part 'raw_material_event.dart';
part 'raw_material_state.dart';

class RawMaterialBloc extends Bloc<RawMaterialEvent, RawMaterialState> {
  final RawMaterialRepository repo;
  final InternetConnectionChecker networkChecker = InternetConnectionChecker();

  RawMaterialBloc(this.repo) : super(RawMaterialState(rawMaterials: {})) {
    on<GetRawMaterialsWithTypes>((event, emit) async {
      emit(state.copyWith(isLoading: true));

      final res = await repo.getRawMaterialsWithTypes();

      AppRes.logger.i(res.toString());

      if (res is Success) {
        final Map<RawMaterialType, List<RawMaterial>> rawMaterials = res.value;

        emit(state.copyWith(rawMaterials: rawMaterials, isLoading: false));
      } else if (res is NoInternet) {
        emit(state.copyWith(errorMsg: 'Internetingiz yaroqsiz'));
      } else if (res is GenericError) {
        emit(state.copyWith(errorMsg: 'Qandaydir xatolik'));
      } else {
        emit(state.copyWith(errorMsg: 'Qandaydir xatolik'));
      }
    });

    on<CreateRawMaterial>((event, emit) async {
      final bool hasNetwork = await networkChecker.hasConnection;
      if (hasNetwork) {
        emit(state.copyWith(isLoading: true));

        final RawMaterial rawMaterial = RawMaterial(
          name: event.name,
          price: double.parse(event.cost.replaceAll(',', '')),
          typeId: event.type.id!,
        );

        final createRes = await repo.createRawMaterial(rawMaterial);

        AppRes.logger.i(createRes.toString());

        if (createRes is Success) {
          state.rawMaterials[event.type]!.add(createRes.value);
          emit(state.copyWith(
              isLoading: false,
              isCRUD: true,
              rawMaterials: state.rawMaterials));
        } else if (createRes is NoInternet) {
          emit(state.copyWith(errorMsg: 'Internetingiz yaroqsiz'));
        } else if (createRes is GenericError) {
          emit(state.copyWith(errorMsg: 'Qandaydir xatolik'));
        } else {
          emit(state.copyWith(errorMsg: 'Qandaydir xatolik'));
        }
      } else {
        emit(state.copyWith(errorMsg: Constants.noNetwork));
      }
    });

    on<DeleteRawMaterial>((event, emit) async {
      final bool hasNetwork = await networkChecker.hasConnection;
      if (hasNetwork) {
        emit(state.copyWith(isLoading: true));

        final deleteRes = await repo.deleteRawMaterial(event.rawMaterial);

        AppRes.logger.i(deleteRes.toString());

        if (deleteRes is Success) {
          state.rawMaterials[event.type]!.remove(event.rawMaterial);
          emit(state.copyWith(
              isLoading: false,
              isCRUD: true,
              rawMaterials: state.rawMaterials));
        } else if (deleteRes is NoInternet) {
          emit(state.copyWith(errorMsg: 'Internetingiz yaroqsiz'));
        } else if (deleteRes is GenericError) {
          emit(state.copyWith(errorMsg: 'Qandaydir xatolik'));
        } else {
          emit(state.copyWith(errorMsg: 'Qandaydir xatolik'));
        }
      } else {
        emit(state.copyWith(errorMsg: Constants.noNetwork));
      }
    });

    on<UpdateRawMaterial>((event, emit) async {
      final bool hasNetwork = await networkChecker.hasConnection;
      if (hasNetwork) {
        emit(state.copyWith(isLoading: true));

        final updateRes = await repo.updateRawMaterial(event.rawMaterial);

        AppRes.logger.i(updateRes.toString());

        if (updateRes is Success) {
          state.rawMaterials[event.type] = updateRes.value;
          emit(state.copyWith(
              isLoading: false,
              isCRUD: true,
              rawMaterials: state.rawMaterials));
        } else if (updateRes is NoInternet) {
          emit(state.copyWith(errorMsg: 'Internetingiz yaroqsiz'));
        } else if (updateRes is GenericError) {
          emit(state.copyWith(errorMsg: 'Qandaydir xatolik'));
        } else {
          emit(state.copyWith(errorMsg: 'Qandaydir xatolik'));
        }
      } else {
        emit(state.copyWith(errorMsg: Constants.noNetwork));
      }
    });

    on<RefreshRawMaterials>((evnt, emit) async {
      final bool hasNetwork = await networkChecker.hasConnection;
      if (hasNetwork) {
        emit(state.copyWith(isLoading: true));

        final refreshRes = await repo.getRawMaterials((progress) {});

        AppRes.logger.i(refreshRes.value);

        if (refreshRes is Success) {
          final Map<RawMaterialType, List<RawMaterial>> rawMaterials =
              refreshRes.value;

          emit(state.copyWith(rawMaterials: rawMaterials, isLoading: false));
        } else if (refreshRes is NoInternet) {
          emit(state.copyWith(errorMsg: 'Internetingiz yaroqsiz'));
        } else if (refreshRes is GenericError) {
          emit(state.copyWith(errorMsg: 'Qandaydir xatolik'));
        } else {
          emit(state.copyWith(errorMsg: 'Qandaydir xatolik'));
        }
      } else {
        emit(state.copyWith(errorMsg: Constants.noNetwork));
      }
    });
  }
}
