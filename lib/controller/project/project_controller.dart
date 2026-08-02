import 'package:bbvision/model/project/employee_model.dart';
import 'package:bbvision/model/project/role_model.dart';
import 'package:bbvision/service/auth_local_storage.dart';
import 'package:bbvision/service/project/employee_list_service.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ProjectController extends GetxController {
  final service = Get.put(EmployeeListService());

  final projectName = TextEditingController().obs;
  final employeeList = <EmployeeModel>[].obs;
  final filteredEmployees = <EmployeeModel>[].obs;

  // Selected employees
  final selectedEmployees = <EmployeeModel>[].obs;
  final daysController = TextEditingController().obs;
  final days = 0.obs;

  //role master to get roles
  final roleList = <RoleModel>[].obs;
  RxList<RoleModel> filteredRoles = <RoleModel>[].obs;
  final TextEditingController roleSearchController = TextEditingController();
  Rx<RoleModel?> selectedRole = Rx<RoleModel?>(null);

  //Employee id -> List<TextEditingController>
  final RxMap<String, List<TextEditingController>> taskControllers =
      <String, List<TextEditingController>>{}.obs;
  List<Map<String, dynamic>> taskList = [];

  @override
  void onInit() {
    super.onInit();
    getEmployeeList();
  }

  Future submit() async {
    List<Map<String, dynamic>> taskList = [];

    taskControllers.forEach((empId, controllers) {
      for (int i = 0; i < controllers.length; i++) {
        taskList.add({
          "employee_id": empId,
          "day": i + 1,
          "task": controllers[i].text,
        });
      }
    });

    final login = await AuthLocalStorage.getLoginDetails();

    // API body
    final body = {
      "assigner_Id": login?.data?.assEmpId ?? "",
      "project_name": projectName.value.text,
      "role": selectedRole.value?.roleName,
      "days": days.value,
      "employees": selectedEmployees,
      "tasks": taskList,
    };

    print(body);
    final result = await service.addNewProject(
      assignerId: login?.data?.assEmpId ?? "",
      projectName: projectName.value.text,
      projectRole: selectedRole.value?.roleName ?? "",
      days: days.value,
      employees: selectedEmployees.map((e) => e.toJson()).toList(),
      tasks: taskList,
    );

    if (result) {
      print(result);
      Get.back();
    }

    // dio.post(url, data: body);
  }

  void generateTaskController() {
    taskControllers.clear();

    for (var employee in selectedEmployees) {
      taskControllers[employee.userName ?? ''] = List.generate(
        days.value,
        (_) => TextEditingController(),
      );
    }
  }

  void filterRoles(String value) {
    if (value.isEmpty) {
      filteredRoles.assignAll(roleList);
    } else {
      filteredRoles.assignAll(
        roleList.where(
          (role) => role.roleName!.toLowerCase().contains(value.toLowerCase()),
        ),
      );
    }
  }

  void filterEmployees(String value) {
    print(employeeList);
    print(value);
    if (value.isEmpty) {
      filteredEmployees.assignAll(employeeList);
    } else {
      filteredEmployees.assignAll(
        employeeList.where(
          (employee) => (employee.userGroupCode ?? "").toLowerCase().contains(
            value.toLowerCase(),
          ),
        ),
      );
    }
    print(filteredEmployees);
  }

  Future<void> getEmployeeList() async {
    final result = await service.getEmployeeList();

    if (result != null) {
      employeeList.assignAll(result.employees);
      roleList.assignAll(result.roles);
      filteredRoles.assignAll(result.roles);
    }
    print('----------------------');
    print(employeeList);
    print('----------------------');
  }

  void toggleEmployee(EmployeeModel employee) {
    final index = selectedEmployees.indexWhere(
      (e) => e.userId == employee.userId,
    );

    if (index != -1) {
      selectedEmployees.removeAt(index);
    } else {
      selectedEmployees.add(employee);
    }
  }
}
