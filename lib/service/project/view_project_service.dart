import 'dart:convert';

import 'package:bbvision/model/project/project_model.dart';
import 'package:bbvision/model/project/single_project_model.dart';
import 'package:bbvision/service/service.dart';

class ViewProjectService {
  final api = Service();

  //get the project list
  Future<List<ProjectModel>?> getProjectDetails() async {
    try {
      final response = await api.dio.get("project/view_project.php");

      if (response.statusCode == 200) {
        final data = response.data is String
            ? jsonEncode(response.data)
            : response.data;
        print(data);
        if (data['status'] == "success") {
          return (data['data'] as List)
              .map((e) => ProjectModel.fromJson(e))
              .toList();
        } else {
          return null;
        }
      }
    } catch (e) {
      print(e);
      return null;
    }
    return null;
  }

  //get the individuval project
  Future<List<SingleProjectModel>?> getSingleProjectDetails(
    String projectId,
  ) async {
    try {
      final response = await api.dio.get(
        "project/view_project.php",
        queryParameters: {"projectId": projectId},
      );

      if (response.statusCode == 200) {
        final data = response.data is String
            ? jsonEncode(response.data)
            : response.data;
        print("project ----------- $data");
        if (data['status'] == "success") {
          return (data['data'] as List)
              .map((e) => SingleProjectModel.fromJson(e))
              .toList();
        } else {
          return null;
        }
      }
    } catch (e) {
      print(e);
      return null;
    }
    return null;
  }
}
