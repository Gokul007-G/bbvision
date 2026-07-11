import 'dart:io';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:bbvision/model/leave/leave_model.dart';
import 'package:bbvision/model/login_model.dart';
import 'package:bbvision/service/auth_local_storage.dart';
import 'package:bbvision/service/leave/add_leave_request_service.dart';
import 'package:dio/dio.dart' as dio;

import '../../service/service.dart';

class AddLeaveRequestController extends GetxController {
  final service = Get.put(AddLeaveRequestService());

  final leaveKey = GlobalKey<FormState>();

  final storageCnt = AuthLocalStorage();
  final nameCnt = TextEditingController();
  final leaveModel = <LeaveModel?>[].obs;
  final leaveTypeId = RxnInt();
  final leaveLoading = false.obs;

  final isLoading = false.obs;

  Rx<DateTime?> eligibleFromDate = Rx<DateTime?>(null);
  Rx<DateTime?> fromDate = Rx<DateTime?>(null);
  Rx<DateTime?> toDate = Rx<DateTime?>(null);
  final reasonCnt = TextEditingController();

  //Image file path variable
  final Rx<File?> selectedImage = Rx<File?>(null);
  final RxString selectedImageName = ''.obs;

  @override
  void onInit() async {
    // TODO: implement onInit
    super.onInit();
    getLeavetype();

    final login = await AuthLocalStorage.getLoginDetails();
    nameCnt.text = login?.data!.fullName ?? 'User';
  }

  //pick image 
  Future<void> pickImage() async {
    final picker = ImagePicker();
    final XFile? image = await picker.pickImage(
      source: ImageSource.gallery,
      imageQuality: 70,
    );
    if (image != null) {
      final now = DateTime.now();

      final originalName = image.name;

      final extension = originalName.split('.').last;

      final uniqueName =
          'IMG_${now.year}${now.month}${now.day}_${now.hour}${now.minute}${now.second}_${now.millisecond}.$extension';

      selectedImage.value = File(image.path);
      selectedImageName.value = uniqueName;
    }
  }

  //get leave type
  Future<void> getLeavetype() async {
    leaveLoading.value = true;
    final result = await service.getLeaveType();
    if (result != null) {
      leaveModel.value = result;
    }
    leaveLoading.value = false;
  }

  /// Upload Image
  Future<bool> submit() async {
    try {
      isLoading.value = true;

      LoginModel? login = await AuthLocalStorage.getLoginDetails();
      int? candidateId = login?.data!.candidateId ?? 0;

      final filteredFormDate = DateFormat('yyyy-MM-dd').format(fromDate.value!);
      final filteredToDate = DateFormat('yyyy-MM-dd').format(toDate.value!);
      final imageFile = selectedImage.value != null
          ? await dio.MultipartFile.fromFile(
              selectedImage.value!.path,
              filename: selectedImageName.value,
            )
          : '';

      final dio.FormData formData = dio.FormData.fromMap({
        'type': 'submit',
        'candids_id': candidateId, // yyyy-mm-dd
        'full_name': nameCnt.text,
        'leave_type': leaveTypeId,
        'from_date': filteredFormDate,
        'to_date': filteredToDate,
        'reason': reasonCnt.text,
        'uploadfile': imageFile,
      });

      final api = Service();
      final response = await api.dio.post(
        'add_leave_request.php',
        data: formData,
      );

      final Map<String, dynamic> data = response.data;

      if (data['status'] == 'success') {
        return true;
      } else {
        Get.snackbar(
          'Error',
          data['message'] ?? 'Upload failed',
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.red[300],
          colorText: Colors.white,
        );
        return false;
      }
    } catch (e) {
      return false;
    } finally {
      isLoading.value = false;
    }
  }
}
