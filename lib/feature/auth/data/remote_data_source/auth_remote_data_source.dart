import 'dart:async';
import 'dart:io';

import 'package:omborchi/feature/auth/data/remote_data_source/model/employee_request.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../../../../core/network/network_state.dart';
import '../../../../core/utils/consants.dart';

abstract interface class AuthRemoteDataSource {
  Future<State> getEmployeeData(int employeeId);
  Future<State> logOut(EmployeeNetwork employee);
  Future<State> logIn(EmployeeNetwork employee);
  Future<State> deleteAccount(String employeeId);
  Future<State> updateAccount(EmployeeNetwork employee);
  Future<State> createAccount(EmployeeNetwork employee);
}

class AuthRemoteDataSourceImpl implements AuthRemoteDataSource {
  final SupabaseClient supabaseClient;

  AuthRemoteDataSourceImpl(this.supabaseClient);

  @override
  Future<State> createAccount(EmployeeNetwork employee) async {
    try {
      final user = await getEmployeeData(employee.id ?? -1);

      if (user is UserNotFound) {
        final newUser = await supabaseClient
            .from(ExpenseFields.employeeTable)
            .insert(employee.toJson())
            .select();

        return Success(newUser);
      } else {
        return user;
      }
    } on SocketException catch (e) {
      AppRes.logger.e(e);
      return NoInternet(Exception("No Internet"));
    } on TimeoutException catch (e) {
      AppRes.logger.e(e);
      return NoInternet(Exception("No Internet"));
    } catch (e) {
      AppRes.logger.e(e);
      return GenericError(e);
    }
  }

  @override
  Future<State> deleteAccount(String employeeId) async {
    try {
      await supabaseClient
          .from(ExpenseFields.employeeTable)
          .delete()
          .eq('id', employeeId);

      return Success(true);
    } on SocketException catch (e) {
      AppRes.logger.e(e);
      return NoInternet(Exception("No Internet"));
    } on TimeoutException catch (e) {
      AppRes.logger.e(e);
      return NoInternet(Exception("No Internet"));
    } catch (e) {
      AppRes.logger.e(e);
      return GenericError(e);
    }
  }

  @override
  Future<State> getEmployeeData(int employeeId) async {
    try {
      final user = await supabaseClient
          .from(ExpenseFields.employeeTable)
          .select()
          .eq('id', employeeId)
          .single();

      if (user.isEmpty) {
        return UserNotFound();
      }

      return Success(EmployeeNetwork.fromJson(user));
    } on SocketException catch (e) {
      AppRes.logger.e(e);
      return NoInternet(Exception("No Internet"));
    } on TimeoutException catch (e) {
      AppRes.logger.e(e);
      return NoInternet(Exception("No Internet"));
    } catch (e) {
      AppRes.logger.e(e);
      return GenericError(e);
    }
  }

  @override
  Future<State> logIn(EmployeeNetwork employee) async {
    try {
      final user = await getEmployeeData(employee.id ?? -1);

      AppRes.logger.t(user.toString());

      return user;
    } on SocketException catch (e) {
      AppRes.logger.e(e);
      return NoInternet(Exception("No Internet"));
    } on TimeoutException catch (e) {
      AppRes.logger.e(e);
      return NoInternet(Exception("No Internet"));
    } catch (e) {
      AppRes.logger.e(e);
      return GenericError(e);
    }
  }

  @override
  Future<State> logOut(EmployeeNetwork employee) async {
    try {
      await supabaseClient
          .from(ExpenseFields.employeeTable)
          .update({'isVerified': false})
          .eq('id', employee.id!);

      return Success(true);
    }
    on SocketException catch (e) {
      AppRes.logger.e(e);
      return NoInternet(Exception("No Internet"));
    } on TimeoutException catch (e) {
      AppRes.logger.e(e);
      return NoInternet(Exception("No Internet"));
    } catch (e) {
      AppRes.logger.e(e);
      return GenericError(e);
    }
  }

  @override
  Future<State> updateAccount(EmployeeNetwork employee) async {
    try {
      AppRes.logger.t(employee.toString());

      final newUserRes = await supabaseClient
          .from(ExpenseFields.employeeTable)
          .update(employee.toJson())
          .eq('id', employee.id!)
          .single();

      return Success(EmployeeNetwork.fromJson(newUserRes));
    }
    on SocketException catch (e) {
      AppRes.logger.e(e);
      return NoInternet(Exception("No Internet"));
    } on TimeoutException catch (e) {
      AppRes.logger.e(e);
      return NoInternet(Exception("No Internet"));
    } catch (e) {
      AppRes.logger.e(e);
      return GenericError(e);
    }
  }
}
