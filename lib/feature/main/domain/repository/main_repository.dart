import 'package:omborchi/core/network/network_state.dart';

abstract interface class MainRepository {
  Future<State> getCategories();
}