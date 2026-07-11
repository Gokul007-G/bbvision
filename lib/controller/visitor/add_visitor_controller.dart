import 'package:flutter/widgets.dart';
import 'package:get/get.dart';
import 'package:bbvision/model/visitor/department_model.dart';
import 'package:bbvision/model/visitor/staff_model.dart';
import 'package:bbvision/model/visitor/travel_model.dart';
import 'package:bbvision/service/visitor/add_visitor_service.dart';

class AddVisitorController extends GetxController {
  final service = Get.put(AddVisitorService());
  final visitorKey = GlobalKey<FormState>();

  final isLoading = false.obs;

  Rx<DateTime?> visitingDate = Rx<DateTime?>(DateTime.now());

  final nameCnt = TextEditingController();
  final emailCnt = TextEditingController();
  final mobileCnt = TextEditingController();
  final comingFromCnt = TextEditingController();
  final companyCnt = TextEditingController(
    text: 'Quadsel Systems Private Limited',
  );
  final purposeOfVisitCnt = TextEditingController();

  final departmentLoading = false.obs;
  final departmentList = <DepartmentModel?>[].obs;
  final departmentId = RxnInt();

  final staffLoading = false.obs;
  final staffList = <StaffModel?>[].obs;
  final staffId = RxnInt();

  final travelLoading = false.obs;
  final travelList = <TravelModel?>[].obs;
  final travelId = RxnInt();

  final vehicleNoCnt = TextEditingController();
  final remarkCnt = TextEditingController();

  @override
  void onInit() {
    super.onInit();
    getDepartmentList();
    getTravelList();
  }

  //get Department Lsit
  Future<void> getDepartmentList() async {
    departmentLoading.value = true;
    final result = await service.getDepartment();
    if (result != null && result.isNotEmpty) {
      departmentList.value = result;
    }
    departmentLoading.value = false;
  }

  //get Staff List
  Future<void> getStaffList() async {
    staffLoading.value = true;
    final result = await service.getStaff(departmentId.value!);
    if (result != null && result.isNotEmpty) {
      staffList.value = result;
    }
    staffLoading.value = false;
  }

  //get Travel List
  Future<void> getTravelList() async {
    travelLoading.value = true;

    final result = await service.getTravel();
    if (result != null && result.isNotEmpty) {
      travelList.value = result;
    }
    travelLoading.value = false;
  }

  //submit
  Future<void> submit() async {
    final result = await service.submit(
      visitingDate.value!,
      nameCnt.text,
      emailCnt.text,
      mobileCnt.text,
      comingFromCnt.text,
      companyCnt.text,
      purposeOfVisitCnt.text,
      departmentId.value!.toString(),
      staffId.value!.toString(),
      travelId.value!.toString(),
      vehicleNoCnt.text,
      remarkCnt.text,
    );

    if (result) {
      Get.back();
    } else {
      print('Error');
    }
  }
}
