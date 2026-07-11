import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:bbvision/model/claim/claim_request_model.dart';
import 'package:bbvision/model/login_model.dart';
import 'package:bbvision/service/auth_local_storage.dart';
import 'package:bbvision/service/claim/view_claim_service.dart';

class ViewClaimController extends GetxController {
  final service = Get.put(ViewClaimService());

  final userGroupCode = RxnString();
  final isLoading = false.obs;

  final isSearch = false.obs;
  final searchCnt = TextEditingController();
  final searchValue = ''.obs;

  final requestList = <ClaimRequestModel>[].obs;
  final filteredList = <ClaimRequestModel>[].obs;

  @override
  void onInit() {
    super.onInit();
    getClaimListCnt();
  }

  void filterSearch(String query) {
    final q = query.toLowerCase();
    if (q.trim().isEmpty) {
      return filteredList.assignAll(requestList);
    }
    filteredList.assignAll(
      requestList.where(
        (e) =>
            e.empCode.toLowerCase().contains(q) ||
            e.customerName.toLowerCase().contains(q) ||
            e.date.toLowerCase().contains(q) ||
            e.fullName.toLowerCase().contains(q),
      ),
    );
  }

  void toggleSearch() {
    isSearch.value = !isSearch.value;
    if (!isSearch.value) {
      searchCnt.clear();
      searchValue.value = '';
      filteredList.assignAll(requestList);
      isSearch.value = false;
    }
  }

  //update the status
  Future<bool> updateStatusCnt(int tableId, int status) async {
    try {
      isLoading.value = true;
      final result = await service.updateStatus(tableId, status);
      if (result == true) {
        Get.back();
        await getClaimListCnt();
        return result;
      } else {
        return result;
      }
    } catch (e) {
      return false;
    } finally {
      isLoading.value = false;
    }
  }

  // get the claim list
  Future<void> getClaimListCnt() async {
    try {
      isLoading.value = true;
      LoginModel? user = await AuthLocalStorage.getLoginDetails();
      final userId = user?.data?.candidateId;
      userGroupCode.value = user?.data?.userGroupCode;

      if (userId == null) {
        Get.snackbar(
          'Error',
          'User not logged in',
          backgroundColor: Colors.red,
          colorText: Colors.white,
        );
        return;
      }

      final result = await service.getClaimList(userId);

      if (result != null && result.isNotEmpty) {
        result.length;
        requestList.assignAll(result);
        filteredList.assignAll(result);
      } else {
        // 👇 ELSE EXECUTE ERROR MESSAGE
        requestList.clear();
        Get.snackbar(
          'No Data',
          'No claim records found',
          backgroundColor: Colors.orange,
          colorText: Colors.white,
        );
      }
    } catch (e) {
      // 👇 API / Network / Parsing error
      Get.snackbar(
        'Error',
        'Something went wrong. Please try again',
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
    } finally {
      isLoading.value = false;
    }
  }
}
