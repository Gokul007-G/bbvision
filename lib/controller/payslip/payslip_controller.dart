import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:bbvision/model/login_model.dart';
import 'package:bbvision/model/payslip/department_model.dart';
import 'package:bbvision/model/payslip/payroll_model.dart';
import 'package:bbvision/model/payslip/staff_model.dart';
import 'package:bbvision/screen/payslip/payslip_details_screen.dart';
import 'package:bbvision/service/auth_local_storage.dart';
import 'package:bbvision/service/payslip/payslip_service.dart';

class PayslipController extends GetxController {
  final service = Get.put(PayslipService());

  final isLoading = false.obs;
  final isDownloading = false.obs;

  final fetchLoading = false.obs;
  final fetchError = false.obs;
  final fetchErrorDetails = ''.obs;

  final payslipKey = GlobalKey<FormState>();

  final payrollList = <PayrollModel>[].obs;
  final departmentList = <DepartmentModel>[].obs;
  final staffList = <StaffModel>[].obs;

  final payrollId = RxnInt();
  final departmentId = RxnInt();
  final staffId = RxnInt();

  final payrollLoading = false.obs;
  final departmentLoading = false.obs;
  final staffLoading = false.obs;

  final payslipDetails = {}.obs;

  @override
  void onInit() async {
    super.onInit();
    loadPayslipData();
    LoginModel? user = await AuthLocalStorage.getLoginDetails();
    if (user?.data?.userGroupCode != 'R003') {
      departmentId.value = int.tryParse(user?.data?.department ?? '0');
      staffId.value = user?.data?.userId ?? 0;
    }
  }

  //load the data
  Future<void> loadPayslipData() async {
    isLoading.value = true;
    final result = await service.getPayslipData();

    if (result != null) {
      payrollList.value = result.payroll;
      departmentList.value = result.department;
      staffList.value = result.staff;
    }
    isLoading.value = false;
  }

  //get the deatails
  Future<void> getDetailsCnt() async {
    fetchError.value = false;

    fetchLoading.value = true;
    final result = await service.getDetails(
      payrollId.value!,
      departmentId.value!,
      staffId.value!,
    );
    if (result.isNotEmpty && result['status'] == 'success') {
      payslipDetails.value = result;
      Get.to(() => PayslipDetailsScreen());
    } else {
      fetchError.value = true;
      fetchErrorDetails.value = result['message'].toString();
    }
    fetchLoading.value = false;
  }
}
