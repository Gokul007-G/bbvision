import 'package:bbvision/controller/project/view_project_controller.dart';
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
  void onInit() async {
    super.onInit();
    await getEmployeeList();
  }

  Future submit() async {
    // 1. Project name validation
    if (projectName.value.text.trim().isEmpty) {
      Get.snackbar(
        "Validation",
        "Please enter project name",
        snackPosition: SnackPosition.BOTTOM,
      );
      return;
    }

    // 2. Role validation
    if (selectedRole.value == null) {
      Get.snackbar(
        "Validation",
        "Please select employee role",
        snackPosition: SnackPosition.BOTTOM,
      );
      return;
    }

    // 3. Employee validation
    if (selectedEmployees.isEmpty) {
      Get.snackbar(
        "Validation",
        "Please select at least one employee",
        snackPosition: SnackPosition.BOTTOM,
      );
      return;
    }

    // 4. Number of days validation
    final daysText = daysController.value.text.trim();

    if (daysText.isEmpty) {
      Get.snackbar(
        "Validation",
        "Please enter number of days",
        snackPosition: SnackPosition.BOTTOM,
      );
      return;
    }

    final numberOfDays = int.tryParse(daysText);

    if (numberOfDays == null || numberOfDays <= 0) {
      Get.snackbar(
        "Validation",
        "Please enter a valid number of days",
        snackPosition: SnackPosition.BOTTOM,
      );
      return;
    }

    // 5. Task validation
    for (final employee in selectedEmployees) {
      final controllers = taskControllers[employee.userName];

      if (controllers == null) {
        Get.snackbar(
          "Validation",
          "Task details are missing for ${employee.fullName}",
          snackPosition: SnackPosition.BOTTOM,
        );
        return;
      }

      for (int i = 0; i < controllers.length; i++) {
        if (controllers[i].text.trim().isEmpty) {
          Get.snackbar(
            "Validation",
            "Please enter Day ${i + 1} task for ${employee.fullName}",
            snackPosition: SnackPosition.BOTTOM,
          );
          return;
        }
      }
    }
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
      "role": selectedRole.value?.empRoleName,
      "days": days.value,
      "employees": selectedEmployees,
      "tasks": taskList,
    };

    print(body);
    final result = await service.addNewProject(
      assignerId: login?.data?.assEmpId ?? "",
      projectName: projectName.value.text,
      projectRole: selectedRole.value?.empRoleName ?? "",
      days: days.value,
      employees: selectedEmployees.map((e) => e.toJson()).toList(),
      tasks: taskList,
    );

    if (result) {
      print(result);
      final controller = Get.put(ViewProjectController());

      await controller.getProjects();
      Get.back();
    }
    print("Validation successful");
    print("Project: ${projectName.value.text}");
    print("Role: ${selectedRole.value?.empRoleName}");
    print("Employees: ${selectedEmployees.length}");
    print("Days: $numberOfDays");
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
          (role) =>
              role.empRoleName!.toLowerCase().contains(value.toLowerCase()),
        ),
      );
    }
  }

  void filterEmployees(String value) {
    print('---------------$value----------');
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
    print("filteredEmployees $filteredEmployees");
  }

  Future<void> getEmployeeList() async {
    final result = await service.getEmployeeList();
    print('--------Project COntroller----------------');

    if (result != null) {
      employeeList.assignAll(result.employees);
      roleList.assignAll(result.roles);
      filteredRoles.assignAll(result.roles);
    }
    print('----------------------');
    print('Employtee $employeeList');
    print('Role : $roleList');
    print('----------------------');
    print('------------------------');
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
