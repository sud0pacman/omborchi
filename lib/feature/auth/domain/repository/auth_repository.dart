import 'package:omborchi/feature/auth/domain/model/employee.dart';

import '../../../../core/network/network_state.dart';

abstract interface class AuthRepository {
  Future<State> getEmployeeData(int employeeId);
  Future<State> logOut(Employee employee);
  Future<State> logIn(Employee employee);
  Future<State> deleteAccount(String employeeId);
  Future<State> updateAccount(Employee employee);
  Future<State> createAccount(Employee employee);
}