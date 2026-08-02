import 'package:get/get.dart';

class EmployeeModel {
  final int? userId;
  final String? userName;
  final String? fullName;
  final String? userGroupCode;
  RxBool isSelected = false.obs;

  EmployeeModel({
    required this.userId,
    required this.userName,
    required this.fullName,
    required this.userGroupCode,
  });

  factory EmployeeModel.fromJson(Map<String, dynamic> json) {
    return EmployeeModel(
      userId: json['user_id'],
      userName: json['user_name'],
      fullName: json['full_name'],
      userGroupCode: json['user_group_code'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'user_id': userId,
      'user_name': userName,
      'full_name': fullName,
      "user_group_code": userGroupCode,
    };
  }
}
