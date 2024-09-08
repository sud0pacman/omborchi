import 'package:omborchi/core/network/network_state.dart';
import 'package:omborchi/feature/auth/data/remote_data_source/model/employee_network.dart';

import 'package:omborchi/feature/auth/domain/model/employee.dart';

import '../../../domain/repository/auth_repository.dart';
import '../auth_remote_data_source.dart';

class AuthRepositoryImpl implements AuthRepository {
  final AuthRemoteDataSource authRemoteDataSource;

  AuthRepositoryImpl(this.authRemoteDataSource);

  @override
  Future<State> createAccount(Employee employee) {
    return authRemoteDataSource.createAccount(employee.toNetwork());
  }

  @override
  Future<State> deleteAccount(String employeeId) {
    return authRemoteDataSource.deleteAccount(employeeId);
  }

  @override
  Future<State> getEmployeeData(int employeeId) async {
    final res = await authRemoteDataSource.getEmployeeData(employeeId);

    if (res is Success) {
      final EmployeeNetwork employee = res.value;
      
      return Success(employee.toModel());
    } else {
      return res;
    }
  }

  @override
  Future<State> logIn(Employee employee) {
    return authRemoteDataSource.logIn(employee.toNetwork());
  }

  @override
  Future<State> logOut(Employee employee) {
    return authRemoteDataSource.logOut(employee.toNetwork());
  }

  @override
  Future<State> updateAccount(Employee employee) async {
    final res = await authRemoteDataSource.updateAccount(employee.toNetwork());

    if (res is Success) {
      final EmployeeNetwork employee = res.value;
      return Success(employee.toModel());
    } else {
      return res;
    }
  }
}
