import 'package:bbvision/model/project/employee_model.dart';
import 'package:bbvision/model/project/role_model.dart';

class EmployeeResponseModel {
  final List<RoleModel> roles;
  final List<EmployeeModel> employees;

  EmployeeResponseModel({required this.roles, required this.employees});

  factory EmployeeResponseModel.fromJson(Map<String, dynamic> json) {
    return EmployeeResponseModel(
      roles: (json['roles'] as List).map((e) => RoleModel.fromJson(e)).toList(),
      employees: (json['data'] as List)
          .map((e) => EmployeeModel.fromJson(e))
          .toList(),
    );
  }
}
