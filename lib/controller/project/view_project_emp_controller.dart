import 'package:bbvision/model/login_model.dart';
import 'package:bbvision/model/project/project_model_emp.dart';
import 'package:bbvision/service/auth_local_storage.dart';
import 'package:bbvision/service/project/view_project_emp_service.dart';
import 'package:get/get.dart';

class ViewProjectEmpController extends GetxController {
  final service = Get.put(ViewProjectEmpService());

  final projectList = <ProjectModelEmp?>[].obs;

  Rxn<LoginData?> user = Rxn<LoginData>();

  @override
  void onInit() async {
    super.onInit();
    await getProjectCnt();
    await loadUser();
  }

  //update the status
  Future<void> updateStatusCnt(int taskId) async {
    final result = await service.updateStatus(taskId);

    if (result) {
      getProjectCnt();
    }
  }

  //user details
  Future<void> loadUser() async {
    final login = await AuthLocalStorage.getLoginDetails();

    if (login?.data != null) {
      user.value = login!.data;
    }

    print("User: ${user.value?.userName}");
    print("Group: ${user.value?.userGroupCode}");
  }

  // Get the project list
  Future<void> getProjectCnt() async {
    final login = await AuthLocalStorage.getLoginDetails();

    final data = login?.data;

    if (data != null) {
      final userGroupCode = data.userGroupCode;
      final employeeId = data.userName;

      final result = await service.getProjectList(userGroupCode, employeeId);

      print("----------------------view Project emp---------------");

      print(result);
      print("----------------------view Project emp---------------");

      if (result != null) {
        projectList.assignAll(result);
      }
    }
  }
}
