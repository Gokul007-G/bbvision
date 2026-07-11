import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:bbvision/controller/claim/add_claim_controller.dart';
import 'package:bbvision/widget/appColors.dart';
import 'package:bbvision/widget/custom_text_field.dart';

class AddClaimScreen extends StatelessWidget {
  AddClaimScreen({super.key});

  final controller = Get.put(AddClaimController());
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Add Claim')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: controller.claimKey,
          child: Obx(
            () => Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                //Employee Name
                CustomTextField(
                  controller: controller.nameCnt,
                  label: 'Employee Name',
                  prefixIcon: Icons.person,
                  readOnly: true,
                ),

                //Date Picker
                GestureDetector(
                  onTap: () async {
                    DateTime? pickedDate = await showDatePicker(
                      context: context,
                      firstDate: DateTime(2000),
                      lastDate: DateTime.now(),
                      initialDate: DateTime.now(),
                    );
                    if (pickedDate != null) {
                      controller.dateCnt.value = pickedDate;
                    }
                  },
                  child: Container(
                    margin: const EdgeInsets.symmetric(vertical: 12),
                    padding: const EdgeInsets.symmetric(
                      vertical: 16,
                      horizontal: 14,
                    ),
                    decoration: BoxDecoration(
                      border: Border.all(
                        color: controller.dateErrorText.value.isEmpty
                            ? AppColors.textPrimary
                            : Colors.red,
                      ),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Row(
                      children: [
                        const Icon(Icons.event, size: 20, color: Colors.grey),
                        const SizedBox(width: 10),
                        Text(
                          controller.dateCnt.value == null
                              ? 'Select From Date'
                              : DateFormat(
                                  'dd-MM-yyyy',
                                ).format(controller.dateCnt.value!),
                          style: TextStyle(
                            color: controller.dateCnt.value == null
                                ? Colors.grey
                                : Colors.black,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),

                if (controller.dateErrorText.value.isNotEmpty)
                  Padding(
                    padding: const EdgeInsets.only(left: 8),
                    child: Text(
                      controller.dateErrorText.value,
                      style: const TextStyle(color: Colors.red, fontSize: 12),
                    ),
                  ),

                //Travel Type List
                Container(
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  child: DropdownButtonFormField<int>(
                    menuMaxHeight: 250,
                    value: controller.selectedTravelId.value,
                    decoration: InputDecoration(
                      labelText: 'Travel Type *',
                      hintText: controller.travelLoading.value
                          ? 'Please Wait...'
                          : controller.selectedTravelId.value == null
                          ? 'Please select the Travel Type'
                          : 'Select Travel Type',
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),

                      errorText: controller.travelErrorText.value.isEmpty
                          ? null
                          : controller.travelErrorText.value,

                      errorBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                        borderSide: const BorderSide(color: Colors.red),
                      ),
                      contentPadding: const EdgeInsets.symmetric(
                        horizontal: 12,
                        vertical: 14,
                      ),
                    ),
                    items: controller.travelList
                        .map(
                          (e) => DropdownMenuItem<int>(
                            value: e['id'],
                            child: Text(e['travel_type']),
                          ),
                        )
                        .toList(),
                    onChanged: (value) {
                      controller.selectedTravelId.value = value;
                      controller.kmsCnt.clear();
                      controller.amountCnt.clear();
                    },
                  ),
                ),

                controller.selectedTravelId.value == 1 ||
                        controller.selectedTravelId.value == 4
                    ? CustomTextField(
                        controller: controller.kmsCnt,
                        keyboardType: TextInputType.number,
                        label: 'Kms',
                        prefixIcon: Icons.speed,
                        onChange: (value) {
                          final kms = double.tryParse(value ?? '');

                          if (kms == null) {
                            controller.amountCnt.clear();
                            return;
                          }

                          double rate = 0;
                          if (controller.selectedTravelId.value == 1) {
                            rate = 2.5;
                          } else if (controller.selectedTravelId.value == 4) {
                            rate = 7;
                          }

                          controller.amountCnt.text = (kms * rate)
                              .toStringAsFixed(2);
                          return null;
                        },
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please enter Kms';
                          }
                          final kms = double.tryParse(value);
                          if (kms == null) {
                            return 'Enter valid number';
                          }
                          if (controller.selectedTravelId.value == 1) {
                            controller.amountCnt.text = (kms * 2.5)
                                .toStringAsFixed(2);
                          } else if (controller.selectedTravelId.value == 4) {
                            controller.amountCnt.text = (kms * 5)
                                .toStringAsFixed(2);
                          }

                          return null;
                        },
                      )
                    : const SizedBox.shrink(),

                //customer Name
                CustomTextField(
                  controller: controller.cusNameCnt,
                  label: 'Customer Name',
                  prefixIcon: Icons.boy,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter the customer name';
                    }
                    return null;
                  },
                ),

                //Loaction
                CustomTextField(
                  controller: controller.locationCnt,
                  label: 'Location',
                  prefixIcon: Icons.location_on,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter the location';
                    }
                    return null;
                  },
                ),

                //Purpose of Visit
                CustomTextField(
                  controller: controller.purposeCnt,
                  label: 'Purpose of Visit',
                  prefixIcon: Icons.add_comment_outlined,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter the reason';
                    }
                    return null;
                  },
                ),

                //Amonut
                CustomTextField(
                  controller: controller.amountCnt,
                  label: controller.selectedTravelId.value == 1
                      ? 'Per Kms Amount \$ 2.5'
                      : controller.selectedTravelId.value == 4
                      ? 'Per Kms Amount \$ 7'
                      : 'Amount',
                  prefixIcon: Icons.attach_money_outlined,
                  readOnly:
                      controller.selectedTravelId.value == 1 ||
                          controller.selectedTravelId.value == 4
                      ? true
                      : false,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter the amonut';
                    }
                    return null;
                  },
                ),

                // IMAGE PICKER
                GestureDetector(
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
                              ? const Icon(Icons.camera_alt, color: Colors.grey)
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

                const SizedBox(height: 16),
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
                            final isFormValid = controller
                                .claimKey
                                .currentState!
                                .validate();
                            final isDateValid = controller.validateDate();
                            final isTravelValid = controller.validateTravel();

                            if (!isFormValid ||
                                !isDateValid ||
                                !isTravelValid) {
                              return;
                            } else {
                              final result = await controller.submit();
                              if (result) {
                                Get.back();
                                Get.snackbar(
                                  'Success',
                                  'Data Inserted Successfully',
                                  backgroundColor: Colors.green,
                                  colorText: Colors.white,
                                );
                              }
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
