import 'package:omborchi/feature/auth/domain/model/employee.dart';

class EmployeeNetwork {
  final int? id;
  final String fullName;
  final String password;
  final List<String>? deviceName;
  final bool isVerified;

  EmployeeNetwork({
    this.id,
    required this.fullName,
    required this.password,
    this.deviceName,
    this.isVerified = false,
  });

  EmployeeNetwork copyWith({
    int? id,
    String? fullName,
    String? password,
    List<String>? deviceName,
    bool? isVerified,
  }) {
    return EmployeeNetwork(
      id: id ?? this.id,
      fullName: fullName ?? this.fullName,
      password: password ?? this.password,
      deviceName: deviceName ?? this.deviceName,
      isVerified: isVerified ?? this.isVerified,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'fullName': fullName,
      'password': password,
      'deviceName': deviceName,
      'isVerified': isVerified,
    };
  }

  factory EmployeeNetwork.fromJson(Map<String, dynamic> map) {
    return EmployeeNetwork(
      id: map['id']!.toInt(),
      fullName: map['fullName'] ?? '',
      password: map['password'] ?? '',
      deviceName: List<String>.from(map['deviceName'] ?? []),
      isVerified: map['isVerified'] ?? false,
    );
  }

  Employee toModel() {
    return Employee(
      id: id,
      fullName: fullName,
      password: password,
      deviceName: deviceName,
      isVerified: isVerified,
    );
  }

  @override
  String toString() {
    return 'Employee(id: $id, fullName: $fullName, password: $password, deviceName: $deviceName, isVerified: $isVerified)';
  }
}
