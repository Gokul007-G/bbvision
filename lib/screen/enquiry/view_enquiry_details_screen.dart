import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:bbvision/controller/enquiry/view_enquiry_controller.dart';
import 'package:bbvision/controller/payslip/payslip_controller.dart';
import 'package:bbvision/model/enquiry/call_details_model.dart';
import 'package:bbvision/service/service.dart';
import 'package:bbvision/widget/appColors.dart';
import 'package:bbvision/widget/custom_text_field.dart';

class ViewEnquiryDetailsScreen extends StatelessWidget {
  const ViewEnquiryDetailsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(ViewEnquiryController());
    final payslipController = Get.put(PayslipController());

    return Scaffold(
      appBar: AppBar(title: const Text('Enquiry Details')),
      body: Obx(() {
        if (controller.isLoading.value) {
          return const Center(child: CircularProgressIndicator());
        }

        final dataAll = controller.enquiryDetails.value;

        if (dataAll == null) {
          return const Center(child: Text('No data found'));
        }

        final imageUrl = Service.imageUrl;

        final data = dataAll.call;

        final feedbackData = dataAll.feedbacks;

        return SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _row(
                'Call Type',
                data.custType == '1' ? 'Corporate' : 'Individual',
              ),
              _row('Call Source', data.clientName),
              _row('Client Type', data.clientType == 1 ? 'New' : 'Existing'),
              _row('Organisation', data.clientOrg),
              _row('Client Name', data.clientName),
              _row('Contact', data.contact),
              _row('Whatsapp', data.whatsapp),
              _row('Email', data.email),
              _row('Alt Email', data.alternativeMail),
              _row('Website', data.website),
              _row('Address', data.address),
              _row(
                'Product',
                data.product == '1'
                    ? 'Product'
                    : data.product == '2'
                    ? 'Services'
                    : 'Solution',
              ),
              _row('Services', data.productName),
              _row('Remark', data.remarks),
              _row('Created By', data.fullName),
              for (var item in feedbackData) ...[
                Obx(
                  () => controller.isLoading.value
                      ? const CircularProgressIndicator()
                      : Container(
                          width: double.infinity,
                          margin: const EdgeInsets.only(bottom: 12),
                          padding: const EdgeInsets.all(14),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(14),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withOpacity(0.05),
                                blurRadius: 10,
                                offset: const Offset(0, 4),
                              ),
                            ],
                            border: Border.all(color: Colors.grey.shade200),
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              /// 🔹 Date Row
                              Row(
                                children: [
                                  const Icon(
                                    Icons.calendar_today,
                                    size: 16,
                                    color: Colors.blueGrey,
                                  ),
                                  const SizedBox(width: 6),
                                  Text(
                                    item.feedbackDate != '0000-00-00'
                                        ? item.feedbackDate
                                        : 'N/A',
                                    style: const TextStyle(
                                      fontSize: 13,
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                  const Spacer(),
                                  const Icon(
                                    Icons.schedule,
                                    size: 16,
                                    color: Colors.orange,
                                  ),
                                  const SizedBox(width: 6),
                                  Text(
                                    item.followUpDate != '0000-00-00'
                                        ? item.followUpDate
                                        : 'No Follow-up',
                                    style: const TextStyle(
                                      fontSize: 13,
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                ],
                              ),

                              const SizedBox(height: 10),

                              /// 🔹 Divider
                              Divider(color: Colors.grey.shade300),

                              const SizedBox(height: 6),

                              /// 🔹 Feedback Text
                              Row(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  const Icon(
                                    Icons.feedback_outlined,
                                    size: 18,
                                    color: Colors.green,
                                  ),
                                  const SizedBox(width: 8),
                                  Expanded(
                                    child: Text(
                                      item.feedback.isNotEmpty
                                          ? item.feedback
                                          : 'No feedback provided',
                                      style: const TextStyle(
                                        fontSize: 14,
                                        height: 1.4,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                ),
              ],

              const SizedBox(height: 16),

              if (data.image.isNotEmpty)
                Center(
                  child: GestureDetector(
                    onTap: () {
                      Get.dialog(
                        GestureDetector(
                          onTap: () => Get.back(),
                          child: Dialog(
                            backgroundColor: Colors.transparent,
                            child: InteractiveViewer(
                              child: Image.network(
                                '$imageUrl${data.image}',
                                errorBuilder: (_, __, ___) {
                                  return const Center(
                                    child: Icon(
                                      Icons.broken_image,
                                      size: 80,
                                      color: Colors.white,
                                    ),
                                  );
                                },
                              ),
                            ),
                          ),
                        ),
                      );
                    },
                    child: Container(
                      height: 220, // 🔑 FIXED HEIGHT
                      width: double.infinity,
                      margin: const EdgeInsets.symmetric(vertical: 16),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(16),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.15),
                            blurRadius: 10,
                            offset: const Offset(0, 5),
                          ),
                        ],
                      ),
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(16),
                        child: Image.network(
                          '$imageUrl${data.image}',
                          fit: BoxFit.cover,
                          loadingBuilder: (context, child, loadingProgress) {
                            if (loadingProgress == null) return child;
                            return const Center(
                              child: CircularProgressIndicator(),
                            );
                          },
                          errorBuilder: (context, error, stackTrace) {
                            return Container(
                              color: Colors.grey.shade300,
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: const [
                                  Icon(Icons.image_not_supported, size: 50),
                                  SizedBox(height: 8),
                                  Text(
                                    'Image not available',
                                    style: TextStyle(
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                ],
                              ),
                            );
                          },
                        ),
                      ),
                    ),
                  ),
                ),
              data.status == 1 || data.status == null
                  ? Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        ElevatedButton(
                          onPressed: () async {
                            await showModalBottomSheet(
                              context: context,
                              isDismissible: true,
                              isScrollControlled: true,
                              builder: (BuildContext context) {
                                return feedbackWidget(
                                  controller,
                                  context,
                                  data,
                                );
                              },
                            );
                            controller.clear();
                          },
                          child: const Text('Feedback+'),
                        ),
                        ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: AppColors.blue,
                          ),
                          onPressed: () {
                            showDialog(
                              context: context,
                              builder: (context) {
                                return Dialog(
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadiusGeometry.circular(
                                      16,
                                    ),
                                  ),
                                  child: SingleChildScrollView(
                                    padding: const EdgeInsets.all(22),
                                    child: Obx(() {
                                      final departmentList =
                                          payslipController.departmentList;
                                      final staffList =
                                          payslipController.staffList;

                                      return controller.dropValue.value
                                          ? Column(
                                              children: [
                                                Text(
                                                  'Remark',
                                                  style: TextStyle(
                                                    fontWeight: FontWeight.bold,
                                                    fontSize: 16,
                                                  ),
                                                ),
                                                CustomTextField(
                                                  controller:
                                                      controller.remarkCnt,
                                                  maxline: 3,
                                                  label: 'Enter Remark',
                                                  prefixIcon:
                                                      Icons.edit_document,
                                                ),
                                                Row(
                                                  children: [
                                                    // DROP button (Secondary / Destructive)
                                                    Expanded(
                                                      child: OutlinedButton.icon(
                                                        icon: const Icon(
                                                          Icons.close,
                                                        ),
                                                        label: const Text(
                                                          'Close',
                                                        ),
                                                        style: OutlinedButton.styleFrom(
                                                          foregroundColor:
                                                              AppColors.error,
                                                          side: BorderSide(
                                                            color:
                                                                AppColors.error,
                                                          ),
                                                          padding:
                                                              const EdgeInsets.symmetric(
                                                                vertical: 14,
                                                              ),
                                                          shape: RoundedRectangleBorder(
                                                            borderRadius:
                                                                BorderRadius.circular(
                                                                  12,
                                                                ),
                                                          ),
                                                        ),
                                                        onPressed: () {
                                                          Get.back();
                                                          controller
                                                                  .dropValue
                                                                  .value =
                                                              false;
                                                        },
                                                      ),
                                                    ),

                                                    const SizedBox(width: 12),

                                                    // ASSIGN button (Primary)
                                                    Expanded(
                                                      child: ElevatedButton.icon(
                                                        icon: const Icon(
                                                          Icons.check,
                                                        ),
                                                        label: const Text(
                                                          'Submit',
                                                        ),
                                                        style: ElevatedButton.styleFrom(
                                                          backgroundColor:
                                                              AppColors.error,
                                                          foregroundColor:
                                                              Colors.white,
                                                          elevation: 2,
                                                          padding:
                                                              const EdgeInsets.symmetric(
                                                                vertical: 14,
                                                              ),
                                                          shape: RoundedRectangleBorder(
                                                            borderRadius:
                                                                BorderRadius.circular(
                                                                  12,
                                                                ),
                                                          ),
                                                        ),
                                                        onPressed: () {
                                                          controller
                                                              .updateDropCnt(
                                                                data.id,
                                                              );
                                                        },
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                              ],
                                            )
                                          : Column(
                                              mainAxisSize: MainAxisSize.min,
                                              children: [
                                                Text(
                                                  'Assign To',
                                                  style: TextStyle(
                                                    fontWeight: FontWeight.bold,
                                                    fontSize: 16,
                                                  ),
                                                ),
                                                const SizedBox(height: 16),

                                                //department
                                                DropdownButtonFormField<int>(
                                                  isExpanded: true,
                                                  menuMaxHeight: 320,
                                                  value:
                                                      departmentList.any(
                                                        (e) =>
                                                            e.id ==
                                                            controller
                                                                .departmentId
                                                                .value,
                                                      )
                                                      ? controller
                                                            .departmentId
                                                            .value
                                                      : null,

                                                  decoration: InputDecoration(
                                                    labelText: "Departmet",
                                                    hintText:
                                                        controller
                                                            .departmentLoading
                                                            .value
                                                        ? "Loading Departments..."
                                                        : "Select Department",
                                                    border: OutlineInputBorder(
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                            12,
                                                          ),
                                                    ),
                                                    contentPadding:
                                                        const EdgeInsets.symmetric(
                                                          horizontal: 14,
                                                          vertical: 14,
                                                        ),

                                                    suffixIcon:
                                                        controller
                                                            .departmentLoading
                                                            .value
                                                        ? const Padding(
                                                            padding:
                                                                EdgeInsets.all(
                                                                  12,
                                                                ),
                                                            child: SizedBox(
                                                              height: 18,
                                                              width: 18,
                                                              child:
                                                                  CircularProgressIndicator(
                                                                    strokeWidth:
                                                                        2,
                                                                  ),
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

                                                  items: departmentList.map((
                                                    e,
                                                  ) {
                                                    return DropdownMenuItem<
                                                      int
                                                    >(
                                                      value: e.id,
                                                      child: Text(
                                                        e.departmentName,
                                                        overflow: TextOverflow
                                                            .ellipsis,
                                                      ),
                                                    );
                                                  }).toList(),

                                                  onChanged:
                                                      controller
                                                          .departmentLoading
                                                          .value
                                                      ? null
                                                      : (value) {
                                                          if (value != null) {
                                                            controller
                                                                    .departmentId
                                                                    .value =
                                                                value;
                                                            controller
                                                                    .staffId
                                                                    .value =
                                                                null;
                                                          }
                                                        },
                                                ),

                                                const SizedBox(height: 16),

                                                //Staff
                                                DropdownButtonFormField<int>(
                                                  isExpanded: true,
                                                  menuMaxHeight: 320,
                                                  value:
                                                      staffList.any(
                                                        (e) =>
                                                            e.id ==
                                                            controller
                                                                .staffId
                                                                .value,
                                                      )
                                                      ? controller.staffId.value
                                                      : null,

                                                  decoration: InputDecoration(
                                                    labelText: "Staff Name",
                                                    hintText:
                                                        controller
                                                            .staffLoading
                                                            .value
                                                        ? "Loading Staff Details..."
                                                        : controller
                                                                  .departmentId
                                                                  .value ==
                                                              null
                                                        ? 'Please select the department'
                                                        : "Select Staff",
                                                    border: OutlineInputBorder(
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                            12,
                                                          ),
                                                    ),
                                                    contentPadding:
                                                        const EdgeInsets.symmetric(
                                                          horizontal: 14,
                                                          vertical: 14,
                                                        ),

                                                    suffixIcon:
                                                        controller
                                                            .staffLoading
                                                            .value
                                                        ? const Padding(
                                                            padding:
                                                                EdgeInsets.all(
                                                                  12,
                                                                ),
                                                            child: SizedBox(
                                                              height: 18,
                                                              width: 18,
                                                              child:
                                                                  CircularProgressIndicator(
                                                                    strokeWidth:
                                                                        2,
                                                                  ),
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

                                                  items:
                                                      controller
                                                              .departmentId
                                                              .value ==
                                                          null
                                                      ? []
                                                      : staffList
                                                            .where(
                                                              (e) =>
                                                                  e.depId ==
                                                                  controller
                                                                      .departmentId
                                                                      .value,
                                                            )
                                                            .map((e) {
                                                              return DropdownMenuItem<
                                                                int
                                                              >(
                                                                value: e.id,
                                                                child: Text(
                                                                  e.empName,
                                                                  overflow:
                                                                      TextOverflow
                                                                          .ellipsis,
                                                                ),
                                                              );
                                                            })
                                                            .toList(),

                                                  onChanged:
                                                      controller
                                                          .staffLoading
                                                          .value
                                                      ? null
                                                      : (value) {
                                                          if (value != null) {
                                                            controller
                                                                    .staffId
                                                                    .value =
                                                                value;
                                                          }
                                                        },
                                                ),
                                                const SizedBox(height: 16),
                                                Row(
                                                  children: [
                                                    // DROP button (Secondary / Destructive)
                                                    Expanded(
                                                      child: OutlinedButton.icon(
                                                        icon: const Icon(
                                                          Icons.close,
                                                        ),
                                                        label: const Text(
                                                          'Drop',
                                                        ),
                                                        style: OutlinedButton.styleFrom(
                                                          foregroundColor:
                                                              AppColors.error,
                                                          side: BorderSide(
                                                            color:
                                                                AppColors.error,
                                                          ),
                                                          padding:
                                                              const EdgeInsets.symmetric(
                                                                vertical: 14,
                                                              ),
                                                          shape: RoundedRectangleBorder(
                                                            borderRadius:
                                                                BorderRadius.circular(
                                                                  12,
                                                                ),
                                                          ),
                                                        ),
                                                        onPressed: () {
                                                          controller
                                                                  .dropValue
                                                                  .value =
                                                              true;
                                                        },
                                                      ),
                                                    ),

                                                    const SizedBox(width: 12),

                                                    // ASSIGN button (Primary)
                                                    Expanded(
                                                      child: ElevatedButton.icon(
                                                        icon: const Icon(
                                                          Icons.check,
                                                        ),
                                                        label: const Text(
                                                          'Assign',
                                                        ),
                                                        style: ElevatedButton.styleFrom(
                                                          backgroundColor:
                                                              AppColors.primary,
                                                          foregroundColor:
                                                              Colors.white,
                                                          elevation: 2,
                                                          padding:
                                                              const EdgeInsets.symmetric(
                                                                vertical: 14,
                                                              ),
                                                          shape: RoundedRectangleBorder(
                                                            borderRadius:
                                                                BorderRadius.circular(
                                                                  12,
                                                                ),
                                                          ),
                                                        ),
                                                        onPressed: () {
                                                          controller
                                                              .updateAssignCnt(
                                                                data.id,
                                                              );
                                                        },
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                              ],
                                            );
                                    }),
                                  ),
                                );
                              },
                            );
                            controller.clearAssign();
                          },
                          child: const Text('Assign To'),
                        ),
                      ],
                    )
                  : Container(
                      width: double.infinity,
                      padding: const EdgeInsets.all(16),
                      margin: const EdgeInsets.only(bottom: 16),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(14),
                        border: Border.all(color: Colors.grey.shade200),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.06),
                            blurRadius: 12,
                            offset: const Offset(0, 6),
                          ),
                        ],
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // Title
                          Row(
                            children: [
                              Icon(
                                Icons.assignment_ind,
                                size: 20,
                                color: AppColors.primary,
                              ),
                              SizedBox(width: 8),
                              Text(
                                data.status == 2
                                    ? 'Assigned Details'
                                    : 'Remark Details',
                                style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.w600,
                                  color: AppColors.primary,
                                ),
                              ),
                            ],
                          ),

                          const SizedBox(height: 16),

                          // Department
                          if (data.status == 2)
                            _assigninfoRow(
                              icon: Icons.apartment,
                              label: 'Department',
                              value: data.department,
                            ),

                          const SizedBox(height: 12),

                          // Employee
                          if (data.status == 2)
                            _assigninfoRow(
                              icon: Icons.person,
                              label: 'Employee',
                              value: data.employee,
                            ),

                          // Remark
                          if (data.status == 5)
                            _assigninfoRow(
                              icon: Icons.edit_document,
                              label: 'Remark',
                              value: data.dropRemarks,
                            ),
                        ],
                      ),
                    ),
            ],
          ),
        );
      }),
    );
  }

  Widget _assigninfoRow({
    required IconData icon,
    required String label,
    required String value,
  }) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Icon(icon, size: 18, color: Colors.grey.shade600),
        const SizedBox(width: 10),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                label,
                style: TextStyle(fontSize: 13, color: Colors.grey.shade600),
              ),
              const SizedBox(height: 2),
              Text(
                value,
                style: const TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Obx feedbackWidget(
    ViewEnquiryController controller,
    BuildContext context,
    Call data,
  ) {
    return Obx(
      () => SingleChildScrollView(
        padding: EdgeInsets.only(
          bottom: MediaQuery.of(context).viewInsets.bottom,
        ),
        child: Form(
          key: controller.formKey,
          child: Container(
            width: double.infinity,
            padding: const EdgeInsets.all(16),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  width: 50,
                  height: 5,
                  margin: const EdgeInsets.only(bottom: 12),
                  decoration: BoxDecoration(color: Colors.grey),
                ),
                //Header
                Text(
                  'Feedback Entry',
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),

                //Feedback date
                GestureDetector(
                  onTap: () async {
                    DateTime? pickedDate = await showDatePicker(
                      context: context,
                      firstDate: DateTime(2000),
                      lastDate: DateTime(2500),
                      initialDate: DateTime.now(),
                    );
                    if (pickedDate != null) {
                      controller.feedbackDateValue.value = DateFormat(
                        'yyyy-MM-dd',
                      ).format(pickedDate);
                      controller.feedbackDate.value = pickedDate;
                      controller.followUpDate.value = null;
                      controller.dateError.value = '';
                    }
                  },
                  child: Container(
                    width: double.infinity,
                    margin: const EdgeInsets.only(top: 12),
                    padding: const EdgeInsets.symmetric(
                      horizontal: 12,
                      vertical: 12,
                    ),
                    decoration: BoxDecoration(
                      border: Border.all(
                        color: controller.dateError.value == ''
                            ? Colors.grey
                            : Colors.red,
                      ),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Row(
                      children: [
                        Icon(Icons.calendar_today, size: 18),
                        SizedBox(width: 10),
                        Text(
                          controller.feedbackDate.value == null
                              ? 'Select Feedback Date'
                              : DateFormat(
                                  'dd-MM-yyyy',
                                ).format(controller.feedbackDate.value!),
                          style: TextStyle(
                            color: controller.feedbackDate.value == null
                                ? Colors.grey
                                : Colors.black,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),

                //error text
                controller.dateError.value != ''
                    ? Align(
                        alignment: Alignment.centerLeft,
                        child: Text(
                          controller.dateError.value,
                          style: TextStyle(
                            color: AppColors.error,
                            fontSize: 12,
                          ),
                        ),
                      )
                    : const SizedBox.shrink(),

                //follow Up date
                GestureDetector(
                  onTap: controller.feedbackDate.value == null
                      ? null
                      : () async {
                          DateTime? pickedDate = await showDatePicker(
                            context: context,
                            firstDate:
                                controller.feedbackDate.value ?? DateTime(2000),
                            lastDate: DateTime(2500),
                          );
                          if (pickedDate != null) {
                            controller.followUpDateValue.value = DateFormat(
                              'yyyy-MM-dd',
                            ).format(pickedDate);
                            controller.followUpDate.value = pickedDate;
                            controller.followError.value = '';
                          }
                        },
                  child: Container(
                    width: double.infinity,
                    margin: const EdgeInsets.only(top: 12),
                    padding: const EdgeInsets.symmetric(
                      horizontal: 12,
                      vertical: 12,
                    ),
                    decoration: BoxDecoration(
                      border: Border.all(
                        color: controller.followError.value == ''
                            ? Colors.grey
                            : Colors.red,
                      ),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Row(
                      children: [
                        Icon(Icons.calendar_today, size: 18),
                        SizedBox(width: 10),
                        Text(
                          controller.feedbackDate.value == null
                              ? 'Please select feedback date'
                              : controller.followUpDate.value == null
                              ? 'Select Follow-up Date'
                              : DateFormat(
                                  'dd-MM-yyyy',
                                ).format(controller.followUpDate.value!),
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

                //error text
                controller.followError.value != ''
                    ? Align(
                        alignment: Alignment.centerLeft,
                        child: Text(
                          controller.followError.value,
                          style: TextStyle(
                            color: AppColors.error,
                            fontSize: 12,
                          ),
                        ),
                      )
                    : const SizedBox.shrink(),

                //feed back text
                CustomTextField(
                  controller: controller.feedback,
                  maxline: 3,
                  label: 'Feedback',
                  prefixIcon: Icons.feed_outlined,
                  validator: (value) {
                    if (value == null || value == '') {
                      return 'Please enter the feedback';
                    }
                    return null;
                  },
                ),

                //submit button
                Container(
                  margin: const EdgeInsets.only(top: 12, bottom: 20),
                  width: double.infinity,
                  height: 50,
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: controller.feedbackLoading.value
                          ? AppColors.buttonDisabled
                          : AppColors.buttonPrimary,
                    ),
                    onPressed: () {
                      if (controller.feedbackDate.value == null) {
                        controller.dateError.value = 'Please select the date';
                      }
                      if (controller.followUpDate.value == null) {
                        controller.followError.value =
                            'Please select the follow up date';
                      }
                      if (controller.feedback.text == '') {
                        controller.feedError.value =
                            'Please enter the feedback';
                      }
                      if (controller.formKey.currentState!.validate()) {
                        controller.insertFeedback(data.id, data.userId);
                      }
                    },
                    child: controller.feedbackLoading.value
                        ? const CircularProgressIndicator()
                        : const Text(
                            'Submit',
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 16,
                            ),
                          ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _row(String title, String? value) {
    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 12),
      decoration: BoxDecoration(
        color: Colors.grey.shade100,
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: Colors.grey.shade300),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 130,
            child: Text(
              title,
              style: const TextStyle(
                fontWeight: FontWeight.w600,
                color: Colors.black87,
              ),
            ),
          ),
          const Text(': ', style: TextStyle(fontWeight: FontWeight.bold)),
          Expanded(
            child: Text(
              value?.isNotEmpty == true ? value! : '-',
              style: const TextStyle(color: Colors.black54, height: 1.4),
            ),
          ),
        ],
      ),
    );
  }
}
