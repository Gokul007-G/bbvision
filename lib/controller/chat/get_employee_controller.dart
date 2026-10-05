import 'package:bbvision/model/chat/get_employee_model.dart';
import 'package:bbvision/service/chat/get_employee_service.dart';
import 'package:get/get.dart';

class GetEmployeeController extends GetxController {
  final service = Get.put(GetEmployeeService());

  final employeeList = <GetEmployeeModel>[].obs;

  final isLoading = false.obs;

  @override
  void onInit() {
    super.onInit();
    getEmployeeList();
  }

  //get the employee list
  Future<void> getEmployeeList() async {
    try {
      isLoading.value = true;

      final result = await service.getEmployeeList();
      // print("This is Get employee list page $result");
      if (result != null && result.isNotEmpty) {
        employeeList.assignAll(result);
      }
    } catch (e) {
      print("Controller side error $e");
    } finally {
      isLoading.value = false;
    }
  }
}
