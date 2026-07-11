import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:bbvision/model/visitor/visitor_model.dart';
import 'package:bbvision/service/visitor/view_visitor_service.dart';

class ViewVisitorController extends GetxController {
  final service = Get.put(ViewVisitorService());

  final isLoading = false.obs;

  final search = false.obs;
  final searchValue = RxnString();
  final searchCnt = TextEditingController();

  final visitorList = <VisitorModel>[].obs;
  final filteredList = <VisitorModel>[].obs;

  @override
  void onInit() async {
    super.onInit();
    getVisitorList();
  }

  //approve  the status
  Future<void> approveStatus(String id)async{
    isLoading.value = true;
    final result = await service.approveStatus(id);
    if(result){
      await getVisitorList();
      Get.back();
    }else{
      print('Error');
    }
    isLoading.value =false;
  }

  //get the Visitor total list
  Future<void> getVisitorList() async {
    isLoading.value = true;
    final result = await service.getVisitor();
    if (result != null && result.isNotEmpty) {
      visitorList.assignAll(result);
      filteredList.assignAll(result);
    } else {
      print('Error');
    }
    isLoading.value = false;
  }

  void filteredListCnt(String query) {
    if (query.isEmpty) {
      return filteredList.assignAll(visitorList);
    }
    final q = query.trim().toLowerCase();

    filteredList.assignAll(
      visitorList.where(
        (e) =>
            e.firstName.toLowerCase().contains(q) ||
            e.email.toLowerCase().contains(q) ||
            e.mobile.toLowerCase().contains(q) ||
            e.vehicleNo.toLowerCase().contains(q),
      ),
    );
  }

  void toggleSearch() {
    search.value = !search.value;

    if (!search.value) {
      searchCnt.clear();
      searchValue.value = '';
      filteredList.assignAll(visitorList);
      search.value = false;
    }
  }
}
