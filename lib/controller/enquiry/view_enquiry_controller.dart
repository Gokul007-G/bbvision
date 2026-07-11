import 'dart:math';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:bbvision/model/enquiry/call_details_model.dart';
import 'package:bbvision/model/enquiry/crm_calls_model.dart';
import 'package:bbvision/model/login_model.dart';
import 'package:bbvision/service/auth_local_storage.dart';
import 'package:bbvision/service/enquiry/view_enquiry_service.dart';

class ViewEnquiryController extends GetxController {
  final service = Get.put(ViewEnquiryService());
  final enquiryList = <CrmCallModel>[].obs;
  final filteredList = <CrmCallModel>[].obs;

  final Rxn<CallDetailsResponse> enquiryDetails = Rxn<CallDetailsResponse>();

  final search = false.obs;
  final searchValue = RxnString();
  final searchCnt = TextEditingController();

  final isLoading = false.obs;

  //Add new feedback and assign to variables
  final formKey = GlobalKey<FormState>();
  final feedbackLoading = false.obs;
  Rx<DateTime?> feedbackDate = Rx<DateTime?>(null);
  Rx<DateTime?> followUpDate = Rx<DateTime?>(null);
  final feedback = TextEditingController();
  final feedbackDateValue = ''.obs;
  final followUpDateValue = ''.obs;

  final feedError = ''.obs;
  final dateError = ''.obs;
  final followError = ''.obs;

  //assign to variables
  final dropValue = false.obs;
  final remarkCnt = TextEditingController();

  final departmentId = RxnInt();
  final staffId = RxnInt();

  final departmentLoading = false.obs;
  final staffLoading = false.obs;

  //pagination
  final currentPage = 1.obs;
  final itemsPerPage = 10.obs;

  int get totalItems => filteredList.length;

  int get totalPages => (totalItems / itemsPerPage.value).ceil();

  List<CrmCallModel> get paginatedList {
    int start = (currentPage.value - 1) * itemsPerPage.value;
    int end = start + itemsPerPage.value;
    if (end > totalItems) end = totalItems;
    return filteredList.sublist(start, end);
  }

  void changeItemsPerPage(int value) {
    itemsPerPage.value = value;
    currentPage.value = 1;
  }

  void clearAssign() {
    dropValue.value = false;
    remarkCnt.clear();
    departmentId.value = null;
    staffId.value = null;
  }

  void clear() {
    feedbackDate.value = null;
    feedbackDateValue.value = '';
    followUpDate.value = null;
    followUpDateValue.value = '';
    feedback.clear();
    feedError.value = '';
    dateError.value = '';
    followError.value = '';
  }

  String formatDate(DateTime? date) {
    if (date == null) return '-';
    return DateFormat('dd-MM-yyyy').format(date);
  }

  String getStatusText(int? status) {
    if (status == 5) {
      return 'InActive';
    } else {
      return 'Active';
    }
  }

  @override
  void onInit() async {
    super.onInit();
    await getEnquiryListCnt();
  }

  // insert the new feedback
  Future<void> insertFeedback(int id, int userId) async {
    final result = await service.insertFeedback(
      callsId: id,
      userId: userId,
      date: feedbackDateValue.value,
      followUpDate: followUpDateValue.value,
      feedback: feedback.text,
    );
    if (result) {
      await getEnquiryDetailsById(id);
      Get.back();
    } else {
      print('some want wrong');
    }
  }

  // update the assing
  Future<void> updateAssignCnt(int id) async {
    final result = await service.updateAssign(
      id: id,
      department: departmentId.value!,
      employee: staffId.value!,
    );
    if (result) {
      await getEnquiryDetailsById(id);

      Get.back();
    } else {
      print('some want wrong');
    }
  }

  // update the drop
  Future<void> updateDropCnt(int id) async {
    final result = await service.updateDrop(id: id, remark: remarkCnt.text);
    if (result) {
      await getEnquiryDetailsById(id);
      Get.back();
    } else {
      print('some want wrong');
    }
  }

  //get the list
  Future<void> getEnquiryListCnt() async {
    isLoading.value = true;
    LoginModel? login = await AuthLocalStorage.getLoginDetails();
    int? userId = login?.data!.userId ?? 0;

    final result = await service.getEnquiryList(userId);

    if (result != null) {
      currentPage.value = 1;
      itemsPerPage.value = 10;
      enquiryList.assignAll(result);
      filteredList.assignAll(result);
    } else {
      print('error controller');
    }
    isLoading.value = false;
  }

  //get the deatils
  Future<void> getEnquiryDetailsById(int id) async {
    isLoading.value = true;
    final result = await service.viewEnquiryById(id);
    if (result != null) {
      enquiryDetails.value = result;
    } else {
      print('error controller');
    }
    isLoading.value = false;
  }

  void filteredEnqueryList(String query) {
    searchValue.value = query;

    if (query.trim().isEmpty) {
      filteredList.assignAll(enquiryList);
      return;
    }

    final q = query.toLowerCase();

    filteredList.assignAll(
      enquiryList.where(
        (e) =>
            e.clientName!.toLowerCase().contains(q) ||
            e.clientOrg!.toLowerCase().contains(q),
      ),
    );
  }

  void toggleSearch() {
    search.value = !search.value;

    if (!search.value) {
      searchCnt.clear();
      searchValue.value = '';
      filteredList.assignAll(enquiryList);
      search.value = false;
    }
  }
}
