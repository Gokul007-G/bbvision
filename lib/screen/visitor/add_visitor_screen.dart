import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:intl/intl.dart';
import 'package:bbvision/controller/visitor/add_visitor_controller.dart';
import 'package:bbvision/widget/appColors.dart';
import 'package:bbvision/widget/custom_text_field.dart';

class AddVisitorScreen extends StatelessWidget {
  AddVisitorScreen({super.key});

  final controller = Get.put(AddVisitorController());
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Add Visitor')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: controller.visitorKey,
          child: Column(
            children: [
              /// 📅 Visiting Date
              Obx(
                () => GestureDetector(
                  onTap: () async {
                    DateTime? pickedDate = await showDatePicker(
                      context: context,
                      initialDate:
                          controller.visitingDate.value ?? DateTime.now(),
                      firstDate: DateTime(2000), // allow past dates
                      lastDate: DateTime(2100),
                    );
                    if (pickedDate != null) {
                      controller.visitingDate.value = pickedDate;
                    }
                  },
                  child: Container(
                    margin: const EdgeInsets.only(top: 10, bottom: 16),
                    height: 55,
                    padding: const EdgeInsets.symmetric(
                      vertical: 14,
                      horizontal: 12,
                    ),
                    decoration: BoxDecoration(
                      border: Border.all(color: Colors.grey),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Row(
                      children: [
                        const Icon(Icons.event, size: 20, color: Colors.grey),
                        const SizedBox(width: 10),
                        Text(
                          controller.visitingDate.value == null
                              ? 'Visiting Date'
                              : DateFormat(
                                  'dd-MM-yyyy',
                                ).format(controller.visitingDate.value!),
                          style: TextStyle(
                            color: controller.visitingDate.value == null
                                ? Colors.grey
                                : Colors.black,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),

              /// 👤 Name
              CustomTextField(
                controller: controller.nameCnt,
                label: 'Visitor Name',
                prefixIcon: Icons.person_outline,
                validator: (value) {
                  if (value == null || value.trim().isEmpty) {
                    return 'Please enter visitor name';
                  }
                  return null;
                },
              ),

              /// 📧 Email
              CustomTextField(
                controller: controller.emailCnt,
                label: 'Email Address',
                prefixIcon: Icons.email_outlined,
                keyboardType: TextInputType.emailAddress,
              ),

              /// 📞 Mobile
              CustomTextField(
                controller: controller.mobileCnt,
                label: 'Mobile Number',
                prefixIcon: Icons.phone_outlined,
                keyboardType: TextInputType.phone,
                validator: (value) {
                  if (value == null || value.trim().isEmpty) {
                    return 'Please enter mobile number';
                  } else if (value.length != 10) {
                    return 'Please enter correct mobile number';
                  }
                  return null;
                },
              ),

              /// 📍 Coming From
              CustomTextField(
                controller: controller.comingFromCnt,
                label: 'Coming From',
                prefixIcon: Icons.location_on_outlined,
              ),

              /// 🏢 Company
              CustomTextField(
                controller: controller.companyCnt,
                label: 'Company / Organization',
                prefixIcon: Icons.business_outlined,
                readOnly: true,
              ),

              /// 🏢 Purpose of Visit
              CustomTextField(
                controller: controller.purposeOfVisitCnt,
                label: 'Purpose of Visit',
                prefixIcon: Icons.description_outlined,
                maxline: 2,
              ),

              //Department List
              Obx(
                () => Padding(
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  child: DropdownButtonFormField<int>(
                    value: controller.departmentId.value,
                    decoration: InputDecoration(
                      labelText: 'Department Name',
                      hintText: controller.departmentLoading.value
                          ? 'Please Wait...'
                          : 'Select Department name',
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                      contentPadding: const EdgeInsets.symmetric(
                        horizontal: 12,
                        vertical: 14,
                      ),
                    ),
                    items: controller.departmentList
                        .map(
                          (item) => DropdownMenuItem<int>(
                            value: item!.id,
                            child: Text(item.deptName),
                          ),
                        )
                        .toList(),
                    onChanged: (value) {
                      controller.departmentId.value = value;
                      controller.getStaffList();
                    },
                    validator: (value) {
                      if (value == null) {
                        return 'Please select Department';
                      }
                      return null;
                    },
                  ),
                ),
              ),

              //Staff List
              Obx(
                () => Padding(
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  child: DropdownButtonFormField<int>(
                    menuMaxHeight: 250,
                    value: controller.staffId.value,
                    decoration: InputDecoration(
                      labelText: 'Staff Name',
                      hintText: controller.staffLoading.value
                          ? 'Please Wait...'
                          : controller.departmentId.value == null
                          ? 'Please select the department'
                          : 'Select Staff name',
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                      contentPadding: const EdgeInsets.symmetric(
                        horizontal: 12,
                        vertical: 14,
                      ),
                    ),
                    items: controller.departmentId.value == null
                        ? []
                        : controller.staffList
                              .map(
                                (item) => DropdownMenuItem<int>(
                                  value: item!.id,
                                  child: Text(item.empName),
                                ),
                              )
                              .toList(),
                    onChanged: (value) {
                      controller.staffId.value = value;
                    },
                    validator: (value) {
                      if (value == null) {
                        return 'Please select Staff';
                      }
                      return null;
                    },
                  ),
                ),
              ),

              //Travel List
              Obx(
                () => Padding(
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  child: DropdownButtonFormField<int>(
                    value: controller.travelId.value,
                    decoration: InputDecoration(
                      labelText: 'Travel Type',
                      hintText: controller.travelLoading.value
                          ? 'Please Wait...'
                          : 'Select Travel Type',
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                      contentPadding: const EdgeInsets.symmetric(
                        horizontal: 12,
                        vertical: 14,
                      ),
                    ),
                    items: controller.travelList
                        .map(
                          (item) => DropdownMenuItem<int>(
                            value: item!.id,
                            child: Text(item.travelType),
                          ),
                        )
                        .toList(),
                    onChanged: (value) {
                      controller.travelId.value = value;
                    },
                    validator: (value) {
                      if (value == null) {
                        return 'Please select Department';
                      }
                      return null;
                    },
                  ),
                ),
              ),

              /// Vehicle No
              CustomTextField(
                controller: controller.vehicleNoCnt,
                label: 'Vehicle No',
                prefixIcon: Icons.pedal_bike,
              ),

              /// Remark
              CustomTextField(
                controller: controller.remarkCnt,
                label: 'Remark',
                prefixIcon: Icons.note,
              ),

              //Submit button
              Container(
                width: double.infinity,
                height: 55,
                margin: const EdgeInsets.symmetric(vertical: 16),
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: controller.isLoading.value
                        ? AppColors.buttonDisabled
                        : AppColors.buttonPrimary,
                  ),
                  onPressed: () async {
                    if (!controller.visitorKey.currentState!.validate()) return;

                  await controller.submit();
                   
                  },
                  child: controller.isLoading.value
                      ? const CircularProgressIndicator(
                          color: Colors.white,
                          strokeWidth: 2,
                        )
                      : const Text('Submit', style: TextStyle(fontSize: 18)),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
