import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:intl/intl.dart';
import 'package:bbvision/model/visitor/department_model.dart';
import 'package:bbvision/model/visitor/staff_model.dart';
import 'package:bbvision/model/visitor/travel_model.dart';
import 'package:bbvision/service/service.dart';

class AddVisitorService {
  final api = Service();

  //get the department list
  Future<List<DepartmentModel>?> getDepartment() async {
    final response = await api.dio.get(
      'add_visitor.php',
      queryParameters: {'type': 'department'},
    );

    if (response.statusCode == 200) {
      final data = response.data is String
          ? jsonDecode(response.data)
          : response.data;
      if (data['status'] == 'success') {
        return (data['data'] as List)
            .map((e) => DepartmentModel.fromJson(e))
            .toList();
      } else {
        return null;
      }
    } else {
      return null;
    }
  }

  //get the Staff list
  Future<List<StaffModel>?> getStaff(int depId) async {
    final response = await api.dio.get(
      'add_visitor.php',
      queryParameters: {'type': 'staff', 'departmentId': depId},
    );

    if (response.statusCode == 200) {
      final data = response.data is String
          ? jsonDecode(response.data)
          : response.data;
      if (data['status'] == 'success') {
        return (data['data'] as List)
            .map((e) => StaffModel.fromJson(e))
            .toList();
      } else {
        return null;
      }
    } else {
      return null;
    }
  }

  //get the Travel list
  Future<List<TravelModel>?> getTravel() async {
    final response = await api.dio.get(
      'add_visitor.php',
      queryParameters: {'type': 'travel'},
    );

    if (response.statusCode == 200) {
      final data = response.data is String
          ? jsonDecode(response.data)
          : response.data;
      if (data['status'] == 'success') {
        return (data['data'] as List)
            .map((e) => TravelModel.fromJson(e))
            .toList();
      } else {
        return null;
      }
    } else {
      return null;
    }
  }

  //submit
  Future<bool> submit(
    DateTime date,
    String name,
    String email,
    String mobile,
    String comingFrom,
    String company,
    String purpose,
    String department,
    String staff,
    String travel,
    String vehicleNo,
    String remark,
  ) async {
    try {
      final vistingDate = DateFormat('yyyy-MM-dd').format(date);
      print(vistingDate);
      final response = await api.dio.post(
        'add_visitor.php',
        data: FormData.fromMap({
          'type': 'submit',
          'date': vistingDate, // yyyy-mm-dd
          'first_name': name,
          'email': email,
          'mob_num': mobile,
          'coming_from': comingFrom,
          'companys': company,
          'purpose': purpose,
          'department': department,
          'employee': staff,
          'travel': travel,
          'vehicle_No': vehicleNo,
          'remarks': remark,
        }),
      );
      if (response.statusCode == 200) {
        final data = response.data;

        if (data['status'] == 'success') {
          return true;
        } else {
          print("Server Error: ${data['message']}");
          return false;
        }
      }
      return false;
    } catch (e) {
      print("Submit Error: $e");
      return false;
    }
  }

  
}
