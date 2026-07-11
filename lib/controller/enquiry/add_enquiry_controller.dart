import 'dart:convert';
import 'dart:io';
import 'package:dio/dio.dart' as dio;
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:bbvision/model/enquiry/call_type_model.dart';
import 'package:bbvision/model/enquiry/company_details_model.dart';
import 'package:bbvision/model/enquiry/company_model.dart';
import 'package:bbvision/model/enquiry/product_service_model.dart';
import 'package:bbvision/model/login_model.dart';
import 'package:bbvision/service/auth_local_storage.dart';
import 'package:bbvision/service/enquiry/add_enquiry_service.dart';
import 'package:bbvision/service/service.dart';

class AddEnquiryController extends GetxController {
  final service = Get.put(AddEnquiryService());

  final enquieyKey = GlobalKey<FormState>();

  //submit loading
  final isLoading = false.obs;

  //Call Type
  final callTypeId = RxnInt();

  final Map<String, int> callTypeMap = {'Corporate': 1, 'Individual': 2};

  //Client Type
  final cilentTypeId = RxnInt();

  final Map<String, int> cilentTypeMap = {'New': 1, 'Existing': 2};

  final Map<String, int> indiviualCilentTypeMap = {'New': 3, 'Existing': 4};

  // final cilentType = ''.obs;
  final callSource = <CallSource>[].obs;
  final callSourceId = RxnInt();

  // New , Existing
  final companyType = ''.obs;

  //DB to get the company names
  final companyName = <CompanyModel>[].obs;
  final companyId = RxnInt();
  final newCompanyNameCnt = TextEditingController();
  final isLoadingCompany = false.obs;
  final isLoadingValues = false.obs;

  //Company Details
  final companyDetails = <CompanyDetails>[].obs;

  //client Name
  final clientNameCnt = TextEditingController();

  //Contact Number
  final contantCnt = TextEditingController();

  //Whatsapp Number
  final whatsappCnt = TextEditingController();

  //Email Id
  final emailIdCnt = TextEditingController();

  //Alternative Email Id
  final alterEmailIdCnt = TextEditingController();

  //Address
  final addressCnt = TextEditingController();

  //Website
  final websiteCnt = TextEditingController();

  //Product/Service
  final productService = RxnInt();

  final Map<String, int> productServiceMap = {
    'Product': 1,
    'Services': 2,
    'Solution': 3,
  };

  //List of Product and services from DB
  final productSerivceList = <ProductServiceModel>[].obs;
  final productSerivceId = RxnInt();

  //remark
  final remarkCnt = TextEditingController();

  //Image file path variable
  final Rx<File?> selectedImage = Rx<File?>(null);
  final RxString selectedImageName = ''.obs;

  //feedback
  final feedbackCnt = TextEditingController();

  // Auto today date
  final feedbackDate = DateFormat('yyyy-MM-dd').format(DateTime.now());

  // Follow-up date (selectable)
  Rx<DateTime?> followUpDate = Rx<DateTime?>(null);
  final followUpDateValue = RxnString();
  final errorFollowDate = ''.obs;

  @override
  void onInit() {
    super.onInit();
    getCallSource();
  }

  //print the follow date error
  void followError() {
    if(followUpDate.value == null){
      errorFollowDate.value = 'Please select the follow Up date';
    }
  }

  //get the call types
  Future<void> getCallSource() async {
    final result = await service.callSource();
    if (result != null) {
      callSource.assignAll(result);
    } else {
      print('error in controller');
    }
  }

  //get comapany names
  Future<void> getcompanyName() async {
    isLoadingCompany.value = true;
    final result = await service.companyName();
    if (result != null) {
      companyName.assignAll(result);
    } else {
      print('controller error');
    }
    isLoadingCompany.value = false;
  }

  //get comapany Details
  Future<void> getcompanyDetails(int companyId) async {
    clientNameCnt.clear();
    contantCnt.clear();
    whatsappCnt.clear();
    emailIdCnt.clear();
    alterEmailIdCnt.clear();
    websiteCnt.clear();
    addressCnt.clear();
    isLoadingValues.value = true;
    final result = await service.companyDetails(companyId);
    if (result != null) {
      companyDetails.assignAll(result);

      //assign the existing details to controller
      newCompanyNameCnt.text = companyDetails[0].orgName;
      clientNameCnt.text = companyDetails[0].itName;
      contantCnt.text = companyDetails[0].itMob1;
      whatsappCnt.text = companyDetails[0].itMob2;
      emailIdCnt.text = companyDetails[0].itMail1;
      alterEmailIdCnt.text = companyDetails[0].itMail2;
      addressCnt.text = companyDetails[0].address;
      websiteCnt.text = companyDetails[0].website;
    } else {
      print('controller error');
    }
    isLoadingValues.value = false;
  }

  //get product service List
  Future<void> getProductService(int id) async {
    final result = await service.productServiceDetails(id);
    if (result != null) {
      productSerivceList.assignAll(result);
    } else {
      print('controller error');
    }
  }

  //image picker
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

  /// Upload Image
  Future<bool> submit() async {
    try {
      isLoading.value = true;

      LoginModel? login = await AuthLocalStorage.getLoginDetails();
      int? userId = login?.data!.userId ?? 0;

      final feedbackDate = DateFormat('yyyy-MM-dd').format(DateTime.now());
      final followUpDatelocal = followUpDateValue.value == null
          ? null
          : DateFormat('yyyy-MM-dd').format(followUpDate.value!);

      final dio.FormData formData = dio.FormData.fromMap({
        'type': 'submit',
        'userId': userId,
        'call_type': callTypeId.value,
        'call_source': callSourceId.value,
        'cilent_type': cilentTypeId.value,
        'company_id': companyId.value,
        'company_name': newCompanyNameCnt.text,
        'client_name': clientNameCnt.text,
        'contact': contantCnt.text,
        'whatsapp': whatsappCnt.text,
        'email_id': emailIdCnt.text,
        'alternative_email_id': alterEmailIdCnt.text,
        'address': addressCnt.text,
        'website': websiteCnt.text,
        'product_service_id': productService.value,
        'selected_product_service': productSerivceId.value,
        'image': selectedImage.value != null
            ? await dio.MultipartFile.fromFile(
                selectedImage.value!.path,
                filename: selectedImageName.value,
              )
            : '',
        'remark': remarkCnt.text,

        // feed back form values
        'feedback': feedbackCnt.text,
        'feedback_date': feedbackDate,
        'follow_up_date': followUpDatelocal,
      });

      final api = Service();
      final response = await api.dio.post('add_enquiry.php', data: formData);

      final data = response.data is String
          ? jsonDecode(response.data)
          : response.data;
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

  //clear fileds
  void clearFields() {
    newCompanyNameCnt.clear();
    clientNameCnt.clear();
    contantCnt.clear();
    whatsappCnt.clear();
    emailIdCnt.clear();
    alterEmailIdCnt.clear();
    addressCnt.clear();
    websiteCnt.clear();
    companyName.clear();
    companyType.value = '';
    companyId.value = null;
  }
}
