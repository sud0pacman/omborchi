import 'package:bloc/bloc.dart';
import 'package:omborchi/feature/main/domain/model/raw_material.dart';
import 'package:omborchi/feature/main/domain/model/raw_material_type.dart';

part 'raw_material_event.dart';
part 'raw_material_state.dart';

class RawMaterialBloc extends Bloc<RawMaterialEvent, RawMaterialState> {
  RawMaterialBloc() : super(RawMaterialState(rawMaterials: {})) {
    on<RawMaterialEvent>((event, emit) {
      
    });
  }
}
