import 'package:omborchi/core/network/network_state.dart';
import 'package:omborchi/feature/main/data/data_sources/remote_data_source/cost_remote_data_source.dart';

import 'package:omborchi/feature/main/domain/model/cost_model.dart';
import 'package:omborchi/feature/main/domain/repository/cost_repository.dart';

import '../model/remote_model/cost_network.dart';

class CostRepositoryImpl implements CostRepository {
  final CostRemoteDataSource costRemoteDataSource;

  CostRepositoryImpl(this.costRemoteDataSource);


  @override
  Future<State> createCost(CostModel cost) {
    return costRemoteDataSource.createCost(cost.toNetwork());
  }

  @override
  Future<State> deleteCost(CostModel cost) {
    return costRemoteDataSource.deleteCost(cost.toNetwork());
  }

  @override
  Future<State> getCosts(int productId) async {
    final response = await costRemoteDataSource.getCosts(productId);

    if (response is Success) {
      final List<CostNetwork> costs = response.value;
      final List<CostModel> costsModel = costs.map((e) => e.toModel()).toList();

      return Success(costsModel);
    }
    else {
      return response;
    }
  }

  @override
  Future<State> updateCost(CostModel cost) {
    return costRemoteDataSource.updateCost(cost.toNetwork());
  }

}