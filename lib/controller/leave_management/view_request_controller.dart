import 'package:get/get.dart';
import 'package:bbvision/model/leave/leave_request_model.dart';
import 'package:bbvision/service/auth_local_storage.dart';
import 'package:bbvision/service/leave/view_request_list_service.dart';

class ViewRequestController extends GetxController {
  final service = Get.put(ViewRequestListService());

  RxList<LeaveRequestModel?> leaveRequestModel = <LeaveRequestModel?>[].obs;
  final isLoading = false.obs;
  final userId = 0.obs;

  @override
  void onInit() async {
    super.onInit();
    final user = await AuthLocalStorage.getLoginDetails();
    userId.value = user?.data?.candidateId ?? 0;
    await getLeaveRequestCnt();
  }

  //get the leave list
  Future<void> getLeaveRequestCnt() async {
    isLoading.value = true;
    final result = await service.getRequestList(userId.value);
    if (result != null && result.isNotEmpty) {
      leaveRequestModel.assignAll(result);
    } else {
      print('error');
    }
    isLoading.value = false;
  }

  //updateLeaveStatus
  Future<void> updateStatusCnt(int tableId, String status) async {
    isLoading.value = true;
    final result = await service.updateStatus(userId.value, tableId, status);
    if (result) {
      await getLeaveRequestCnt();
      Get.back();
    }
    isLoading.value = false;
  }
}
