import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:bbvision/controller/payslip/payslip_controller.dart';
import 'package:bbvision/widget/appColors.dart';

class PayslipScreen extends StatelessWidget {
  PayslipScreen({super.key});

  final controller = Get.put(PayslipController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Payslip View')),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: controller.payslipKey,
          child: Column(
            children: [
              //payroll
              Obx(() {
                final payrollList = controller.payrollList;
                return DropdownButtonFormField<int>(
                  isExpanded: true,
                  menuMaxHeight: 320,
                  value:
                      payrollList.any((e) => e.id == controller.payrollId.value)
                      ? controller.payrollId.value
                      : null,

                  decoration: InputDecoration(
                    labelText: "Payroll Period",
                    hintText: controller.payrollLoading.value
                        ? "Loading payroll periods..."
                        : "Select payroll period",
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    contentPadding: const EdgeInsets.symmetric(
                      horizontal: 14,
                      vertical: 14,
                    ),

                    suffixIcon: controller.payrollLoading.value
                        ? const Padding(
                            padding: EdgeInsets.all(12),
                            child: SizedBox(
                              height: 18,
                              width: 18,
                              child: CircularProgressIndicator(strokeWidth: 2),
                            ),
                          )
                        : null,
                  ),

                  validator: (value) {
                    if (value == null) {
                      return 'Please select the payroll period';
                    }
                    return null;
                  },

                  items: payrollList.map((e) {
                    return DropdownMenuItem<int>(
                      value: e.id,
                      child: Text(
                        e.monthRange,
                        overflow: TextOverflow.ellipsis,
                      ),
                    );
                  }).toList(),

                  onChanged: controller.payrollLoading.value
                      ? null
                      : (value) {
                          if (value != null) {
                            controller.payrollId.value = value;
                          }
                        },
                );
              }),

              const SizedBox(height: 16),

              //department
              Obx(() {
                final departmentList = controller.departmentList;
                return DropdownButtonFormField<int>(
                  isExpanded: true,
                  menuMaxHeight: 320,
                  value:
                      departmentList.any(
                        (e) => e.id == controller.departmentId.value,
                      )
                      ? controller.departmentId.value
                      : null,

                  decoration: InputDecoration(
                    labelText: "Departmet",
                    hintText: controller.departmentLoading.value
                        ? "Loading Departments..."
                        : "Select Department",
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    contentPadding: const EdgeInsets.symmetric(
                      horizontal: 14,
                      vertical: 14,
                    ),

                    suffixIcon: controller.departmentLoading.value
                        ? const Padding(
                            padding: EdgeInsets.all(12),
                            child: SizedBox(
                              height: 18,
                              width: 18,
                              child: CircularProgressIndicator(strokeWidth: 2),
                            ),
                          )
                        : null,
                  ),

                  validator: (value) {
                    if (value == null) {
                      return 'Please select the department';
                    }
                    return null;
                  },

                  items: departmentList.map((e) {
                    return DropdownMenuItem<int>(
                      value: e.id,
                      child: Text(
                        e.departmentName,
                        overflow: TextOverflow.ellipsis,
                      ),
                    );
                  }).toList(),

                  onChanged: controller.departmentLoading.value
                      ? null
                      : (value) {
                          if (value != null) {
                            controller.departmentId.value = value;
                            controller.staffId.value = null;
                          }
                        },
                );
              }),

              const SizedBox(height: 16),

              //Staff
              Obx(() {
                final staffList = controller.staffList;

                return DropdownButtonFormField<int>(
                  isExpanded: true,
                  menuMaxHeight: 320,
                  value: staffList.any((e) => e.id == controller.staffId.value)
                      ? controller.staffId.value
                      : null,

                  decoration: InputDecoration(
                    labelText: "Staff Name",
                    hintText: controller.staffLoading.value
                        ? "Loading Staff Details..."
                        : controller.departmentId.value == null
                        ? 'Please select the department'
                        : "Select Staff",
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    contentPadding: const EdgeInsets.symmetric(
                      horizontal: 14,
                      vertical: 14,
                    ),

                    suffixIcon: controller.staffLoading.value
                        ? const Padding(
                            padding: EdgeInsets.all(12),
                            child: SizedBox(
                              height: 18,
                              width: 18,
                              child: CircularProgressIndicator(strokeWidth: 2),
                            ),
                          )
                        : null,
                  ),

                  validator: (value) {
                    if (value == null) {
                      return 'Please select the staff';
                    }
                    return null;
                  },

                  items: controller.departmentId.value == null
                      ? []
                      : staffList
                            .where(
                              (e) => e.depId == controller.departmentId.value,
                            )
                            .map((e) {
                              return DropdownMenuItem<int>(
                                value: e.id,
                                child: Text(
                                  e.empName,
                                  overflow: TextOverflow.ellipsis,
                                ),
                              );
                            })
                            .toList(),

                  onChanged: controller.staffLoading.value
                      ? null
                      : (value) {
                          if (value != null) {
                            controller.staffId.value = value;
                          }
                        },
                );
              }),

              const SizedBox(height: 20),

              Obx(
                () => SizedBox(
                  width: double.infinity,
                  height: 55,
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.primary,
                      disabledBackgroundColor: Colors.grey.shade400,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      elevation: 4,
                    ),
                    onPressed: controller.isLoading.value
                        ? null
                        : () {
                            if (!controller.payslipKey.currentState!
                                .validate()) {
                              return;
                            }
                            controller.getDetailsCnt();
                          },
                    child: controller.isLoading.value
                        ? const SizedBox(
                            height: 22,
                            width: 22,
                            child: CircularProgressIndicator(
                              strokeWidth: 2,
                              color: Colors.white,
                            ),
                          )
                        : const Text(
                            'Submit',
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                              letterSpacing: 1,
                            ),
                          ),
                  ),
                ),
              ),
              const SizedBox(height: 20),

              Obx(() {
                if (controller.fetchLoading.value) {
                  return const Padding(
                    padding: EdgeInsets.all(20),
                    child: CircularProgressIndicator(),
                  );
                }

                if (controller.fetchError.value) {
                  return Container(
                    margin: const EdgeInsets.symmetric(vertical: 15),
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: Colors.red.shade50,
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(color: Colors.red.shade300),
                    ),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Icon(
                          Icons.warning_amber_rounded,
                          color: Colors.red.shade700,
                          size: 28,
                        ),
                        const SizedBox(width: 10),
                        Expanded(
                          child: Text(
                            controller.fetchErrorDetails.value.isEmpty
                                ? "You have not uploaded attendance for this candidate."
                                : controller.fetchErrorDetails.value,
                            style: TextStyle(
                              color: Colors.red.shade800,
                              fontSize: 14,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ),
                      ],
                    ),
                  );
                }

                return const SizedBox.shrink();
              }),
            ],
          ),
        ),
      ),
    );
  }
}
