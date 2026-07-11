import 'package:bbvision/model/payslip/department_model.dart';
import 'package:bbvision/model/payslip/payroll_model.dart';
import 'package:bbvision/model/payslip/staff_model.dart';

class PayslipResponseModel {
  final List<PayrollModel> payroll;
  final List<DepartmentModel> department;
  final List<StaffModel> staff;

  PayslipResponseModel({
    required this.payroll,
    required this.department,
    required this.staff,
  });

  factory PayslipResponseModel.fromJson(Map<String, dynamic> json) {
    return PayslipResponseModel(
      payroll: (json['payroll'] as List)
          .map((e) => PayrollModel.fromJson(e))
          .toList(),
      department: (json['department'] as List)
          .map((e) => DepartmentModel.fromJson(e))
          .toList(),
      staff: (json['staff'] as List)
          .map((e) => StaffModel.fromJson(e))
          .toList(),
    );
  }
}
