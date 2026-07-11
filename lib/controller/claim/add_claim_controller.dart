import 'dart:io';
import 'package:dio/dio.dart' as dio;
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:bbvision/model/login_model.dart';
import 'package:bbvision/service/auth_local_storage.dart';
import 'package:bbvision/service/claim/add_claim_service.dart';
import 'package:bbvision/widget/appColors.dart';

class AddClaimController extends GetxController {
  final service = Get.put(AddClaimService());

  final isLoading = false.obs;
  final claimKey = GlobalKey<FormState>();

  RxList<Map<String, dynamic>> travelList = <Map<String, dynamic>>[].obs;
  // final travelList = RxList();
  final searchCnt = TextEditingController();
  final selectedTravelId = RxnInt();
  final travelLoading = false.obs;

  //controllers
  final empId = RxnInt();
  final nameCnt = TextEditingController();
  Rx<DateTime?> dateCnt = Rx<DateTime?>(null);
  final kmsCnt = TextEditingController();
  final cusNameCnt = TextEditingController();
  final locationCnt = TextEditingController();
  final purposeCnt = TextEditingController();
  final amountCnt = TextEditingController();
  final Rx<File?> selectedImage = Rx<File?>(null);

  //error variable
  final dateErrorText = ''.obs;
  final travelErrorText = ''.obs;

  @override
  void onInit() {
    super.onInit();
    getTravelListCnt();
  }

  bool validateDate() {
    if (dateCnt.value == null) {
      dateErrorText.value = 'Please select a date';
      return false;
    }
    dateErrorText.value = '';
    return true;
  }

  bool validateTravel() {
    if (selectedTravelId.value == null) {
      travelErrorText.value = 'Please select a Travel Type';
      return false;
    }
    travelErrorText.value = '';
    return true;
  }

  Future<void> pickImage() async {
    Get.bottomSheet(
      Container(
        padding: const EdgeInsets.all(16),
        decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 50,
              height: 5,
              margin: EdgeInsets.only(bottom: 10),
              decoration: BoxDecoration(color: AppColors.buttonDisabled),
            ),
            const Text(
              'Select Image',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),

            ListTile(
              leading: const Icon(Icons.camera_alt),
              title: const Text('Camera'),
              onTap: () {
                Get.back();
                _pickFromSource(ImageSource.camera);
              },
            ),

            ListTile(
              leading: const Icon(Icons.photo_library),
              title: const Text('Gallery'),
              onTap: () {
                Get.back();
                _pickFromSource(ImageSource.gallery);
              },
            ),
          ],
        ),
      ),
    );
  }

  /// Pick image from source
  Future<void> _pickFromSource(ImageSource source) async {
    final picker = ImagePicker();
    final XFile? image = await picker.pickImage(
      source: source,
      imageQuality: 70,
    );

    if (image != null) {
      selectedImage.value = File(image.path);
    }
  }

  //submit
  Future<bool> submit() async {
    try {
      isLoading.value = true;

      final formattedDate = DateFormat('yyyy-MM-dd').format(dateCnt.value!);

      final dio.FormData fromData = dio.FormData.fromMap({
        'type': 'submit',
        'emp_id': empId.value,
        'date': formattedDate,
        'travel_id': selectedTravelId.value,
        'cus_name': cusNameCnt.text,
        'location': locationCnt.text,
        'purpose_visit': purposeCnt.text,
        'kms': kmsCnt.text,
        'amount': amountCnt.text,
        'image': selectedImage.value != null
            ? await dio.MultipartFile.fromFile(
                selectedImage.value!.path,
                filename: selectedImage.value!.path.split('/').last,
              )
            : '',
      });

      final result = await service.insertData(fromData);

      return result;
    } catch (e) {
      return false;
    } finally {
      isLoading.value = false;
    }
  }

  //get the travel List
  Future<void> getTravelListCnt() async {
    travelLoading.value = true;
    LoginModel? user = await AuthLocalStorage.getLoginDetails();
    nameCnt.text = user?.data?.fullName ?? 'NULL';
    empId.value = user?.data?.userId ?? 0;

    final result = await service.getTravelType();
    if (result.isNotEmpty) {
      travelList.assignAll(result);
    } else {
      print('error');
    }
    travelLoading.value = false;
  }
}
