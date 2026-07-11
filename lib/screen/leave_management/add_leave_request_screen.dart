import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:bbvision/controller/leave_management/add_leave_request_controller.dart';
import 'package:bbvision/widget/appColors.dart';
import 'package:bbvision/widget/custom_text_field.dart';

class AddLeaveRequestScreen extends StatelessWidget {
  AddLeaveRequestScreen({super.key});

  final controller = Get.put(AddLeaveRequestController());
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Leave Request')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: controller.leaveKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              CustomTextField(
                controller: controller.nameCnt,
                label: 'Employee Name *',
                prefixIcon: Icons.person,
                readOnly: true,
              ),
              const Text('From Date : *'),
              Obx(
                () => GestureDetector(
                  onTap: () async {
                    DateTime? pickedDate = await showDatePicker(
                      context: context,
                      firstDate: DateTime(2000),
                      lastDate: DateTime(2100),
                      initialDate: DateTime.now(),
                    );
                    if (pickedDate != null) {
                      controller.fromDate.value = pickedDate;
                    }
                  },
                  child: Container(
                    margin: const EdgeInsets.symmetric(vertical: 12),
                    padding: const EdgeInsets.symmetric(
                      vertical: 16,
                      horizontal: 14,
                    ),
                    decoration: BoxDecoration(
                      border: Border.all(color: AppColors.textPrimary),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Row(
                      children: [
                        const Icon(Icons.event, size: 20, color: Colors.grey),
                        const SizedBox(width: 10),
                        Text(
                          controller.fromDate.value == null
                              ? 'Select From Date'
                              : DateFormat(
                                  'dd-MM-yyyy',
                                ).format(controller.fromDate.value!),
                          style: TextStyle(
                            color: controller.fromDate.value == null
                                ? Colors.grey
                                : Colors.black,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              const Text('To Date : *'),
              Obx(
                () => GestureDetector(
                  onTap: controller.fromDate.value == null
                      ? null
                      : () async {
                          DateTime? pickedDate = await showDatePicker(
                            context: context,
                            firstDate:
                                controller.fromDate.value ?? DateTime(2000),
                            lastDate: DateTime(2100),
                            initialDate:
                                controller.fromDate.value ?? DateTime.now(),
                          );
                          if (pickedDate != null) {
                            controller.toDate.value = pickedDate;
                          }
                        },
                  child: Container(
                    margin: const EdgeInsets.symmetric(vertical: 12),
                    padding: const EdgeInsets.symmetric(
                      vertical: 16,
                      horizontal: 14,
                    ),
                    decoration: BoxDecoration(
                      border: Border.all(color: AppColors.textPrimary),
                      borderRadius: BorderRadius.circular(8),
                    ),

                    child: Row(
                      children: [
                        const Icon(Icons.event, size: 20, color: Colors.grey),
                        const SizedBox(width: 10),
                        Text(
                          controller.fromDate.value == null
                              ? 'First select the from date'
                              : controller.toDate.value == null
                              ? 'Select To Date'
                              : DateFormat(
                                  'dd-MM-yyyy',
                                ).format(controller.toDate.value!),
                          style: TextStyle(
                            color: controller.toDate.value == null
                                ? Colors.grey
                                : Colors.black,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),

              //leave type
              Obx(
                () => Container(
                  padding: const EdgeInsets.symmetric(
                    vertical: 16,
                  ),
                  child: DropdownButtonFormField<int>(
                    menuMaxHeight: 250,
                    value: controller.leaveTypeId.value,
                    decoration: InputDecoration(
                      labelText: 'Leave Type *',
                      hintText: controller.leaveLoading.value
                          ? 'Please Wait...'
                          : controller.leaveTypeId.value == null
                          ? 'Please select the Leave Type'
                          : 'Select Leave Type',
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                      contentPadding: const EdgeInsets.symmetric(
                        horizontal: 12,
                        vertical: 14,
                      ),
                    ),
                    items: controller.leaveModel
                        .map(
                          (item) => DropdownMenuItem<int>(
                            value: item?.id,
                            child: Text(item?.leaveName ?? ''),
                          ),
                        )
                        .toList(),
                    onChanged: (value) {
                      controller.leaveTypeId.value = value!;
                    },
                    validator: (value) {
                      if (value == null) {
                        return 'Please select the leave type';
                      }
                      return null;
                    },
                  ),
                ),
              ),

              CustomTextField(
                controller: controller.reasonCnt,
                label: 'Reason For Leave : *',
                prefixIcon: Icons.add_comment_rounded,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter the reason';
                  }
                  return null;
                },
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
              ),

              //Submit button
              Container(
                margin: const EdgeInsets.symmetric(vertical: 16),
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
                          if (!controller.leaveKey.currentState!.validate()) {
                            return;
                          } else {
                            if (controller.fromDate.value == null ||
                                controller.toDate.value == null) {
                              Get.snackbar(
                                'Error',
                                'Please select the date',
                                snackPosition: SnackPosition.BOTTOM,
                                backgroundColor: Colors.red[300],
                                colorText: Colors.white,
                              );
                              return;
                            }
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
    );
  }
}
