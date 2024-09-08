import '../../../../core/network/network_state.dart';
import '../model/cost_model.dart';

abstract interface class CostRepository {
  Future<State> getCosts(int productId);
  Future<State> createCost(CostModel cost);
  Future<State> updateCost(CostModel cost);
  Future<State> deleteCost(CostModel cost);
}