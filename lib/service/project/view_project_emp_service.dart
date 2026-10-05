import 'dart:developer';

import 'package:bbvision/model/project/project_model_emp.dart';
import 'package:bbvision/service/service.dart';

class ViewProjectEmpService {
  final api = Service();

  //update the status
  Future<bool> updateStatus(int taskId) async {
    try {
      final response = await api.dio.get(
        'project/employee_view_project.php',
        queryParameters: {"taskId": taskId},
      );
      print(response.data);

      if (response.statusCode == 200 && response.data['status']) {
        return response.data['status'];
      } else {
        print(response.data);
        return false;
      }
    } catch (e) {
      print(e);
    }
    return false;
  }

  //get the project list based on the employee id
  Future<List<ProjectModelEmp>?> getProjectList(
    String userGroupCode,
    String employeeId,
  ) async {
    try {
      final response = await api.dio.get(
        'project/employee_view_project.php',
        queryParameters: {
          "userGroupCode": userGroupCode,
          "employeeId": employeeId,
        },
      );
      print(employeeId);
      print(response.statusCode);
      print(response.data);

      if (response.statusCode == 200 && response.data['status'] == "success") {
        final data = response.data['data'];
        return (data as List).map((e) => ProjectModelEmp.fromJson(e)).toList();
      } else {
        print(response.data);
        return null;
      }
    } catch (e) {
      print(e);
    }
    return null;
  }
}
