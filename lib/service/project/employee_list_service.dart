import 'dart:convert';

import 'package:bbvision/model/project/employee_response_model.dart';
import 'package:bbvision/service/service.dart';
import 'package:dio/dio.dart';

class EmployeeListService {
  final api = Service();

  //get the emplotee list
  Future<EmployeeResponseModel?> getEmployeeList() async {
    try {
      final response = await api.dio.get('project/employee_list.php');
      if (response.statusCode == 200) {
        print(response.data);
        final data = response.data is String
            ? jsonDecode(response.data)
            : response.data;
        if (data['status'] == 'success') {
          print(response.data);
          return EmployeeResponseModel.fromJson(response.data);
        } else {
          return null;
        }
      } else {
        return null;
      }
    } catch (e) {
      print(e);
    }
    return null;
  }

  //add the new project
  Future<bool> addNewProject({
    required String assignerId,
    required String projectName,
    required String projectRole,
    required int days,
    required List employees,
    required List tasks,
  }) async {
    try {
      // final data = FormData({
      //   "projectName": projectName,
      //   "projectRole": projectRole,
      //   "days": days,
      //   "employees": employees,
      //   "tasks": tasks,
      // });

      final body = {
        "assigner_Id": assignerId,
        "project_name": projectName,
        "role": projectRole,
        "days": days,
        "employees": employees,
        "tasks": tasks,
      };

      final response = await api.dio.post(
        'project/add_project.php',
        data: body,
        options: Options(contentType: Headers.jsonContentType),
      );

      if (response.statusCode == 200) {
        print(response.data);
        return true;
      } else {
        print("Some Want Wrong ${response.statusCode}");
        return false;
      }
    } catch (e) {
      print(e);
      return false;
    }
  }
}
