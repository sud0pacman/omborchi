import 'package:omborchi/feature/main/data/model/local_model/type_entity.dart';

abstract interface class TypeLocalDataSource {
  Future<List<TypeEntity>> getTypes();
}