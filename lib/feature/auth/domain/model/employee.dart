import 'package:omborchi/feature/auth/data/remote_data_source/model/employee_request.dart';

class Employee {
  final int? id;
  final String fullName;
  final String password;
  final List<String>? deviceName;
  final bool isVerified;

  Employee({
    this.id,
    required this.fullName,
    required this.password,
    this.deviceName,
    this.isVerified = false,
  });

  Employee copyWith({
    int? id,
    String? fullName,
    String? password,
    List<String>? deviceName,
    bool? isVerified,
  }) {
    return Employee(
      id: id ?? this.id,
      fullName: fullName ?? this.fullName,
      password: password ?? this.password,
      deviceName: deviceName ?? this.deviceName,
      isVerified: isVerified ?? this.isVerified,
    );
  }

  EmployeeNetwork toNetwork() {
    return EmployeeNetwork(
      id: id,
      fullName: fullName,
      password: password,
      deviceName: deviceName,
      isVerified: isVerified,
    );
  }
}