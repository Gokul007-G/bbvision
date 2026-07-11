import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:bbvision/controller/enquiry/add_enquiry_controller.dart';
import 'package:bbvision/widget/appColors.dart';
import 'package:bbvision/widget/custom_text_field.dart';
import 'package:bbvision/widget/enquiry_dropdownfield.dart';

class AddEnquiryScreen extends StatelessWidget {
  AddEnquiryScreen({super.key});
  final controller = Get.put(AddEnquiryController());
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('New Enquiry')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Obx(
          () => Form(
            key: controller.enquieyKey,
            child: Column(
              children: [
                //Call Type
                EnquiryDropdownfield(
                  label: 'Call Type *',
                  hint: 'Select Call Type',
                  items: controller.callTypeMap.keys.toList(),
                  value: controller.callTypeId.value == null
                      ? null
                      : controller.callTypeMap.entries
                            .firstWhere(
                              (e) => e.value == controller.callTypeId.value,
                            )
                            .key,
                  onChanged: (value) {
                    controller.callTypeId.value =
                        controller.callTypeMap[value]!;
                    controller.clearFields();

                    controller.cilentTypeId.value = null;
                  },
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please select Product/Service';
                    }
                    return null;
                  },
                ),

                //Call Source
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 12),
                  child: DropdownButtonFormField<int>(
                    value: controller.callSourceId.value,
                    decoration: InputDecoration(
                      labelText: 'Call Source *',
                      hintText: 'Select Call Source',
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                      contentPadding: const EdgeInsets.symmetric(
                        horizontal: 12,
                        vertical: 14,
                      ),
                    ),
                    items: controller.callSource
                        .map(
                          (e) => DropdownMenuItem<int>(
                            value: e.id, // ✅ VALUE = ID
                            child: Text(e.name), // ✅ SHOW NAME
                          ),
                        )
                        .toList(),
                    onChanged: (value) {
                      controller.callSourceId.value = value!;
                    },
                    validator: (value) {
                      if (value == null) {
                        return 'Please select call type';
                      }
                      return null;
                    },
                  ),
                ),

                //Client Type
                EnquiryDropdownfield(
                  label: 'Client Type *',
                  hint: controller.callTypeId.value == null
                      ? 'Please Select the Call Type'
                      : 'Select Client Type',
                  items: controller.callTypeId.value == null
                      ? []
                      : controller.callTypeId.value == 1
                      ? controller.cilentTypeMap.keys
                            .toList() // Corporate
                      : controller.indiviualCilentTypeMap.keys
                            .toList(), // Individual

                  value: controller.cilentTypeId.value == null
                      ? null
                      : controller.callTypeId.value == 1
                      ? controller.cilentTypeMap.entries
                            .firstWhere(
                              (e) => e.value == controller.cilentTypeId.value,
                            )
                            .key
                      : controller.indiviualCilentTypeMap.entries
                            .firstWhere(
                              (e) => e.value == controller.cilentTypeId.value,
                            )
                            .key,

                  onChanged: (value) async {
                    if (controller.callTypeId.value == 1) {
                      // 🏢 Corporate
                      controller.cilentTypeId.value =
                          controller.cilentTypeMap[value]!;
                    } else {
                      // 👤 Individual
                      controller.cilentTypeId.value =
                          controller.indiviualCilentTypeMap[value]!;
                    }
                    if (value == 'Existing') {
                      controller.companyType.value = value;
                      await controller.getcompanyName();
                    } else {
                      controller.clearFields();
                    }
                  },
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please select Product/Service';
                    }
                    return null;
                  },
                ),

                //Company Names
                controller.companyType.value == 'Existing' &&
                        controller.callTypeId.value == 1
                    ? Padding(
                        padding: const EdgeInsets.symmetric(vertical: 12),
                        child: DropdownButtonFormField<int>(
                          menuMaxHeight: 350,
                          value: controller.companyId.value,
                          decoration: InputDecoration(
                            labelText: 'Company Name',
                            hintText: controller.isLoadingCompany.value
                                ? 'Please Wait...'
                                : 'Select Company Name',
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10),
                            ),
                            contentPadding: const EdgeInsets.symmetric(
                              horizontal: 12,
                              vertical: 14,
                            ),
                          ),
                          items: controller.companyName
                              .map(
                                (e) => DropdownMenuItem<int>(
                                  value: e.id, // ✅ VALUE = ID
                                  child: Text(e.name), // ✅ SHOW NAME
                                ),
                              )
                              .toList(),
                          onChanged: (value) {
                            controller.companyId.value = value!;
                            controller.getcompanyDetails(value);
                          },
                          validator: (value) {
                            if (value == null) {
                              return 'Please select call type';
                            }
                            return null;
                          },
                        ),
                      )
                    : CustomTextField(
                        controller: controller.newCompanyNameCnt,
                        label: 'Company Name *',
                        prefixIcon: Icons.home,
                        validator: (value) {
                          if (value != null && value.trim().isEmpty) {
                            return 'Please enter company name';
                          }
                          return null;
                        },
                      ),

                //client Name
                CustomTextField(
                  controller: controller.clientNameCnt,
                  label: controller.isLoadingValues.value
                      ? 'Fetching Client Name...'
                      : 'Client Name *',
                  prefixIcon: Icons.person,
                  validator: (value) {
                    if (value != null && value.trim().isEmpty) {
                      return 'Please enter client name';
                    }
                    return null;
                  },
                ),

                //Contact Number
                CustomTextField(
                  controller: controller.contantCnt,
                  label: controller.isLoadingValues.value
                      ? 'Fetching Contact Number...'
                      : 'Contact Number *',
                  prefixIcon: Icons.phone,
                  keyboardType: TextInputType.number,
                  validator: (value) {
                    if (value != null && value.length != 10) {
                      return 'Please enter 10 Numbers';
                    }
                    return null;
                  },
                ),

                //Whatsapp Number
                CustomTextField(
                  controller: controller.whatsappCnt,
                  label: controller.isLoadingValues.value
                      ? 'Fetching Whatsapp Number...'
                      : 'Whatsapp Number',
                  prefixIcon: Icons.phone_android,
                  keyboardType: TextInputType.number,
                ),

                // Email
                CustomTextField(
                  controller: controller.emailIdCnt,
                  label: controller.isLoadingValues.value
                      ? 'Fetching Email Id...'
                      : 'Email Id *',
                  prefixIcon: Icons.mark_email_read,
                  keyboardType: TextInputType.emailAddress,
                  validator: (value) {
                    if (value == null || value.trim().isEmpty) {
                      return 'Email is required';
                    }

                    final email = value.trim();
                    final emailRegex = RegExp(
                      r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$',
                    );

                    if (!emailRegex.hasMatch(email)) {
                      return 'Enter a valid email address';
                    }

                    return null;
                  },
                ),

                // Alternative Email
                CustomTextField(
                  controller: controller.alterEmailIdCnt,
                  label: controller.isLoadingValues.value
                      ? 'Fetching Alternative Email Id...'
                      : 'Alternative Email Id',
                  prefixIcon: Icons.email,
                  keyboardType: TextInputType.emailAddress,
                ),

                //Website
                CustomTextField(
                  controller: controller.websiteCnt,
                  label: controller.isLoadingValues.value
                      ? 'Fetching Website link...'
                      : 'Website link',
                  prefixIcon: Icons.web,
                ),

                //Address
                CustomTextField(
                  controller: controller.addressCnt,
                  label: controller.isLoadingValues.value
                      ? 'Address...'
                      : 'Address',
                  prefixIcon: Icons.location_on,
                ),

                //Product/Service
                EnquiryDropdownfield(
                  label: 'Product/Service *',
                  hint: 'Select Product/Service*',
                  items: controller.productServiceMap.keys.toList(),
                  value: controller.productService.value == null
                      ? null
                      : controller.productServiceMap.entries
                            .firstWhere(
                              (e) => e.value == controller.productService.value,
                            )
                            .key,
                  onChanged: (value) {
                    controller.productService.value =
                        controller.productServiceMap[value]!;

                    controller.productSerivceId.value = null;
                    controller.productSerivceList.clear();
                    controller.getProductService(
                      controller.productService.value!,
                    );
                  },
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please select Product/Service';
                    }
                    return null;
                  },
                ),

                //List of product and services
                Obx(
                  () => Padding(
                    padding: const EdgeInsets.symmetric(vertical: 12),
                    child: DropdownButtonFormField<int>(
                      value:
                          controller.productSerivceList.any(
                            (e) => e.id == controller.productSerivceId.value,
                          )
                          ? controller.productSerivceId.value
                          : null,
                      decoration: InputDecoration(
                        labelText: 'Product Service *',
                        hintText: 'First select Product Service',
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                        contentPadding: const EdgeInsets.symmetric(
                          horizontal: 12,
                          vertical: 14,
                        ),
                      ),
                      items: controller.productSerivceList
                          .map(
                            (e) => DropdownMenuItem<int>(
                              value: e.id, // ✅ VALUE = ID
                              child: Text(e.name), // ✅ SHOW NAME
                            ),
                          )
                          .toList(),
                      onChanged: (value) {
                        controller.productSerivceId.value = value!;
                      },
                      validator: (value) {
                        if (value == null) {
                          return 'Please select Product Service';
                        }
                        return null;
                      },
                    ),
                  ),
                ),

                // IMAGE PICKER
                Obx(
                  () => GestureDetector(
                    onTap: controller.pickImage,
                    child: Container(
                      height: 80,
                      width: double.infinity,
                      margin: const EdgeInsets.symmetric(vertical: 10),
                      padding: const EdgeInsets.symmetric(horizontal: 12),
                      decoration: BoxDecoration(
                        border: Border.all(color: Colors.grey.shade400),
                        borderRadius: BorderRadius.circular(10),
                        color: Colors.grey.shade50,
                      ),
                      child: Row(
                        children: [
                          // IMAGE PREVIEW / ICON
                          Container(
                            height: 50,
                            width: 50,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(8),
                              color: Colors.grey.shade200,
                            ),
                            child: controller.selectedImage.value == null
                                ? const Icon(
                                    Icons.camera_alt,
                                    color: Colors.grey,
                                  )
                                : ClipRRect(
                                    borderRadius: BorderRadius.circular(8),
                                    child: Image.file(
                                      controller.selectedImage.value!,
                                      fit: BoxFit.cover,
                                    ),
                                  ),
                          ),

                          const SizedBox(width: 12),

                          // TEXT
                          Expanded(
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  controller.selectedImage.value == null
                                      ? 'Upload Image'
                                      : 'Change Image',
                                  style: const TextStyle(
                                    fontSize: 14,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                                const SizedBox(height: 4),
                                Text(
                                  controller.selectedImage.value == null
                                      ? 'Tap to select from gallery'
                                      : 'Tap to replace the image',
                                  style: TextStyle(
                                    fontSize: 12,
                                    color: Colors.grey.shade600,
                                  ),
                                ),
                              ],
                            ),
                          ),

                          // REMOVE BUTTON
                          if (controller.selectedImage.value != null)
                            IconButton(
                              icon: const Icon(
                                Icons.close,
                                color: Colors.redAccent,
                              ),
                              onPressed: () {
                                controller.selectedImage.value = null;
                              },
                            ),
                        ],
                      ),
                    ),
                  ),
                ),

                //Remark
                CustomTextField(
                  controller: controller.remarkCnt,
                  label: 'Remark',
                  prefixIcon: Icons.question_answer,
                ),

                //Feed Back
                Container(
                  padding: const EdgeInsets.all(16),
                  margin: const EdgeInsets.only(bottom: 16),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(14),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.08),
                        blurRadius: 10,
                        offset: Offset(0, 4),
                      ),
                    ],
                    border: Border.all(color: Colors.blue.shade100),
                  ),
                  child: Column(
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(top: 8),
                        child: Text(
                          'Feedback: ${DateFormat('dd-MM-yyyy').format(DateTime.now())}',
                          style: TextStyle(
                            color: Colors.grey[700],
                            fontWeight: FontWeight.bold,
                            fontSize: 18,
                          ),
                        ),
                      ),
                      CustomTextField(
                        controller: controller.feedbackCnt,
                        label: 'Feedback',
                        prefixIcon: Icons.feedback,
                        maxline: 3,
                        validator: (value) {
                          if (value == null || value.trim().isEmpty) {
                            return 'Please enter the feedback';
                          }
                          return null;
                        },
                      ),

                      Obx(
                        () => GestureDetector(
                          onTap: () async {
                            DateTime? pickedDate = await showDatePicker(
                              context: Get.context!,
                              initialDate:
                                  controller.followUpDate.value ??
                                  DateTime.now(),
                              firstDate: DateTime.now(),
                              lastDate: DateTime(2100),
                            );

                            if (pickedDate != null) {
                              controller.followUpDate.value = pickedDate;
                              controller.followUpDateValue.value = DateFormat(
                                'yyyy-MM-dd',
                              ).format(pickedDate);
                              controller.errorFollowDate.value = '';
                            }
                          },
                          child: Container(
                            margin: const EdgeInsets.only(top: 10, bottom: 16),
                            padding: const EdgeInsets.symmetric(
                              vertical: 14,
                              horizontal: 12,
                            ),
                            decoration: BoxDecoration(
                              border: Border.all(
                                color: controller.errorFollowDate.value != ''
                                    ? AppColors.error
                                    : Colors.grey,
                              ),
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: Row(
                              children: [
                                Icon(Icons.calendar_today, size: 18),
                                SizedBox(width: 10),
                                Text(
                                  controller.followUpDate.value == null
                                      ? 'Select Follow-up Date'
                                      : DateFormat('dd-MM-yyyy').format(
                                          controller.followUpDate.value!,
                                        ),
                                  style: TextStyle(
                                    color: controller.followUpDate.value == null
                                        ? Colors.grey
                                        : Colors.black,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                      // const SizedBox(height: 12),
                      Obx(
                        () => controller.followUpDate.value == null
                            ? Align(
                                alignment: Alignment.centerLeft,
                                child: Text(
                                  controller.errorFollowDate.value,
                                  style: TextStyle(color: AppColors.error),
                                ),
                              )
                            : const SizedBox.shrink(),
                      ),
                    ],
                  ),
                ),

                //Submit button
                SizedBox(
                  width: double.infinity,
                  height: 55,
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: controller.isLoading.value
                          ? AppColors.buttonDisabled
                          : AppColors.buttonPrimary,
                    ),
                    onPressed: controller.isLoading.value
                        ? null
                        : () async {
                            if (controller.followUpDate.value == null) {
                              controller.followError();
                            }
                            if (controller.enquieyKey.currentState!
                                .validate()) {
                              final result = await controller.submit();
                              if (result) {
                                Get.back();
                                Get.snackbar(
                                  'Success',
                                  'Data Inserted Successfully',
                                  backgroundColor: Colors.green,
                                  colorText: Colors.white,
                                );
                              } else {
                                Get.snackbar(
                                  'Error',
                                  'Data not inserted',
                                  backgroundColor: Colors.red,
                                  colorText: Colors.white,
                                );
                              }
                              return;
                            }
                          },
                    child: controller.isLoading.value
                        ? const CircularProgressIndicator(
                            color: Colors.white,
                            strokeWidth: 2,
                          )
                        : const Text('Submit'),
                  ),
                ),
                const SizedBox(height: 30),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
