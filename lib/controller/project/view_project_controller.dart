import 'package:bbvision/model/project/project_model.dart';
import 'package:bbvision/model/project/single_project_model.dart';
import 'package:bbvision/service/project/view_project_service.dart';
import 'package:get/get.dart';

class ViewProjectController extends GetxController {
  final service = Get.put(ViewProjectService());

  final projectList = <ProjectModel>[].obs;
  final singleProjectList = <SingleProjectModel>[].obs;

  @override
  void onInit() async {
    super.onInit();
    await getProjects();
  }

  //get the project
  Future<void> getProjects() async {
    final result = await service.getProjectDetails();

    if (result != null && result.isNotEmpty) {
      projectList.assignAll(result);
      print(result);
    }
  }

  //get individual the project
  Future<void> getSingleProjects(String projectId) async {
    final result = await service.getSingleProjectDetails(projectId);

    if (result != null && result.isNotEmpty) {
      singleProjectList.assignAll(result);
      for (final pro in singleProjectList) {
        print(pro.employeeId);
        print(pro.task);
      }
    }
  }
}
