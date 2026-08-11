import 'package:bbvision/model/project/project_model_emp.dart';
import 'package:bbvision/service/auth_local_storage.dart';
import 'package:bbvision/service/project/view_project_emp_service.dart';
import 'package:get/get.dart';

class ViewProjectEmpController extends GetxController {
  final service = Get.put(ViewProjectEmpService());

  final projectList = <ProjectModelEmp?>[].obs;

  @override
  void onInit() async {
    super.onInit();
    await getProjectCnt();
  }

  //update the status
  Future<void> updateStatusCnt(int taskId) async {
    final result = await service.updateStatus(taskId);
    
    if (result) {
      getProjectCnt();
    }
  }

  // Get the project list
  Future<void> getProjectCnt() async {
    final login = await AuthLocalStorage.getLoginDetails();

    final data = login?.data;

    if (data != null) {
      final employeeId = data.userName;

      final result = await service.getProjectList(employeeId);

      if (result != null) {
        projectList.assignAll(result);
      }
    }
  }
}
