import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:bbvision/controller/leave_management/view_request_controller.dart';
import 'package:bbvision/model/leave/leave_request_model.dart';
import 'package:bbvision/service/service.dart';
import 'package:bbvision/widget/appColors.dart';

Color statusColor(int? status) {
  switch (status) {
    case 1:
      return AppColors.primary;
    case 2:
      return AppColors.success;
    case 3:
      return AppColors.error;
    default:
      return AppColors.buttonDisabled;
  }
}

String statusText(int? status) {
  switch (status) {
    case 1:
      return "Pending";
    case 2:
      return "Approved";
    case 3:
      return "Rejected";
    default:
      return "Unknown";
  }
}

IconData _statusIcon(int? status) {
  switch (status) {
    case 1:
      return Icons.hourglass_bottom;
    case 2:
      return Icons.check_circle;
    case 3:
      return Icons.cancel;
    default:
      return Icons.info;
  }
}

String _statusMessage(int? status) {
  switch (status) {
    case 1:
      return "This leave request is pending. Please review and take action.";
    case 2:
      return "This leave request has been approved.";
    case 3:
      return "This leave request has been rejected.";
    default:
      return "Unknown status.";
  }
}

class ViewRequestScreen extends StatelessWidget {
  ViewRequestScreen({super.key});

  final controller = Get.put(ViewRequestController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Staff Leave Approvals')),
      body: Obx(() {
        if (controller.leaveRequestModel.isEmpty) {
          return RefreshIndicator(
            onRefresh: controller.getLeaveRequestCnt,
            child: ListView(
              children: const [
                SizedBox(height: 300),
                Center(child: Text("No leave requests found")),
              ],
            ),
          );
        }
        if (controller.isLoading.value) {
          return const Center(child: CircularProgressIndicator());
        }

        return RefreshIndicator(
          onRefresh: controller.getLeaveRequestCnt,
          child: ListView.builder(
            padding: const EdgeInsets.all(12),
            itemCount: controller.leaveRequestModel.length,
            itemBuilder: (context, index) {
              final item = controller.leaveRequestModel[index];

              return InkWell(
                onTap: item?.reportingPerson != controller.userId.value
                    ? null
                    : () {
                        showApproveRejectSheet(context, item!);
                      },
                child: Container(
                  margin: const EdgeInsets.only(bottom: 12),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(color: Colors.grey.shade300),
                    boxShadow: [
                      BoxShadow(
                        color: AppColors.buttonDisabled.withOpacity(0.4),
                        blurRadius: 8,
                        offset: const Offset(0, 4),
                      ),
                    ],
                    color: Colors.white,
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(14),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    item?.empName ?? '',
                                    style: const TextStyle(
                                      fontSize: 17,
                                      fontWeight: FontWeight.w700,
                                    ),
                                  ),
                                  const SizedBox(height: 4),
                                  Text(
                                    "Emp Code: ${item?.empCode ?? ''}",
                                    style: TextStyle(
                                      fontSize: 13,
                                      color: Colors.grey.shade600,
                                    ),
                                  ),
                                ],
                              ),
                            ),

                            /// STATUS BADGE
                            Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 12,
                                vertical: 6,
                              ),
                              decoration: BoxDecoration(
                                color: statusColor(
                                  item?.status,
                                ).withOpacity(0.1),
                                borderRadius: BorderRadius.circular(30),
                              ),
                              child: Text(
                                statusText(item?.status),
                                style: TextStyle(
                                  fontSize: 12,
                                  fontWeight: FontWeight.w600,
                                  color: statusColor(item?.status),
                                ),
                              ),
                            ),
                          ],
                        ),

                        const SizedBox(height: 14),

                        /// REQUEST DATE
                        _infoRow("Request Date", item?.reqDate),

                        _infoRow("Leave Type", item?.leaveName),

                        const Divider(height: 14),

                        /// Leave Info -> From Date To Date
                        Row(
                          children: [
                            const Icon(Icons.calendar_month, size: 18),
                            const SizedBox(width: 6),
                            Text(
                              "${item?.fromDate} → ${item?.toDate}",
                              style: const TextStyle(
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ],
                        ),

                        //No Of Days
                        const SizedBox(height: 8),

                        _infoRow("Days", item?.noOfDays),

                        //Reason
                        Text(
                          "Reason: ${item?.leaveReason}",
                          maxLines: 5,
                          overflow: TextOverflow.ellipsis,
                        ),

                        /// Sick Document (Image)
                        if (item?.sickDoc != null && item!.sickDoc!.isNotEmpty)
                          TextButton.icon(
                            onPressed: () {
                              final image = Service.leaveImageUrl;
                              showGeneralDialog(
                                context: context,
                                barrierDismissible: true,
                                barrierLabel: "Image Preview",
                                barrierColor: Colors.black.withOpacity(0.9),
                                transitionDuration: const Duration(
                                  milliseconds: 300,
                                ),
                                pageBuilder: (context, animation, secondaryAnimation) {
                                  return SafeArea(
                                    child: Scaffold(
                                      backgroundColor: Colors.black,
                                      body: Stack(
                                        children: [
                                          Center(
                                            child: InteractiveViewer(
                                              minScale: 0.8,
                                              maxScale: 4,
                                              child: Image.network(
                                                '$image${item.sickDoc}',
                                                fit: BoxFit.contain,
                                                loadingBuilder:
                                                    (
                                                      context,
                                                      child,
                                                      loadingProgress,
                                                    ) {
                                                      if (loadingProgress ==
                                                          null) {
                                                        return child;
                                                      }
                                                      return const Center(
                                                        child:
                                                            CircularProgressIndicator(
                                                              color:
                                                                  Colors.white,
                                                            ),
                                                      );
                                                    },
                                                errorBuilder:
                                                    (
                                                      context,
                                                      error,
                                                      stackTrace,
                                                    ) {
                                                      return const Column(
                                                        mainAxisAlignment:
                                                            MainAxisAlignment
                                                                .center,
                                                        children: [
                                                          Icon(
                                                            Icons.broken_image,
                                                            size: 60,
                                                            color: Colors.white,
                                                          ),
                                                          SizedBox(height: 10),
                                                          Text(
                                                            "Image not available",
                                                            style: TextStyle(
                                                              color:
                                                                  Colors.white,
                                                            ),
                                                          ),
                                                        ],
                                                      );
                                                    },
                                              ),
                                            ),
                                          ),

                                          // Close Button
                                          Positioned(
                                            top: 10,
                                            right: 10,
                                            child: CircleAvatar(
                                              backgroundColor: Colors.black
                                                  .withOpacity(0.6),
                                              child: IconButton(
                                                icon: const Icon(
                                                  Icons.close,
                                                  color: Colors.white,
                                                ),
                                                onPressed: () =>
                                                    Navigator.pop(context),
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  );
                                },
                                transitionBuilder:
                                    (
                                      context,
                                      animation,
                                      secondaryAnimation,
                                      child,
                                    ) {
                                      return FadeTransition(
                                        opacity: animation,
                                        child: child,
                                      );
                                    },
                              );
                            },
                            style: TextButton.styleFrom(
                              padding: EdgeInsets.only(top: 12),
                              minimumSize: Size.zero,
                              tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                            ),
                            icon: const Icon(
                              Icons.attach_file,
                              size: 18,
                              color: AppColors.blue,
                            ),
                            label: const Text(
                              "Medical Document Attached",
                              style: TextStyle(
                                color: AppColors.blue,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ),
                      ],
                    ),
                  ),
                ),
              );
            },
          ),
        );
      }),
    );
  }

  Widget _infoRow(String label, dynamic value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 6),
      child: Row(
        children: [
          Text(
            "$label: ",
            style: TextStyle(fontSize: 13, color: Colors.grey.shade600),
          ),
          Expanded(
            child: Text(
              value?.toString() ?? '',
              style: const TextStyle(fontWeight: FontWeight.w500),
            ),
          ),
        ],
      ),
    );
  }

  void showApproveRejectSheet(BuildContext context, LeaveRequestModel item) {
    final bool isPending = item.status == 1;

    Get.bottomSheet(
      Container(
        padding: const EdgeInsets.all(20),
        decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            /// Drag Handle
            Center(
              child: Container(
                width: 45,
                height: 5,
                decoration: BoxDecoration(
                  color: Colors.grey.shade300,
                  borderRadius: BorderRadius.circular(20),
                ),
              ),
            ),

            const SizedBox(height: 20),

            /// Status Header
            Row(
              children: [
                CircleAvatar(
                  radius: 22,
                  backgroundColor: statusColor(item.status).withOpacity(0.15),
                  child: Icon(
                    _statusIcon(item.status),
                    color: statusColor(item.status),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        item.empName ?? '',
                        style: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        "${item.fromDate} → ${item.toDate}",
                        style: TextStyle(color: Colors.grey.shade600),
                      ),
                    ],
                  ),
                ),
              ],
            ),

            const SizedBox(height: 20),

            /// Status Message
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: statusColor(item.status).withOpacity(0.08),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Text(
                _statusMessage(item.status),
                style: TextStyle(
                  color: statusColor(item.status),
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),

            const SizedBox(height: 24),

            /// Action Buttons (Only if Pending)
            if (isPending)
              Row(
                children: [
                  /// Reject Button
                  Expanded(
                    child: OutlinedButton.icon(
                      icon: const Icon(Icons.close, color: Colors.red),
                      label: const Text(
                        "Reject",
                        style: TextStyle(color: Colors.red),
                      ),
                      style: OutlinedButton.styleFrom(
                        side: const BorderSide(color: Colors.red),
                        padding: const EdgeInsets.symmetric(vertical: 14),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      onPressed: () {
                        controller.updateStatusCnt(item.id!, 'reject');
                      },
                    ),
                  ),

                  const SizedBox(width: 14),

                  /// Approve Button
                  Expanded(
                    child: ElevatedButton.icon(
                      icon: const Icon(Icons.check),
                      label: const Text("Approve"),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.green,
                        padding: const EdgeInsets.symmetric(vertical: 14),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      onPressed: () {
                        controller.updateStatusCnt(item.id!, 'approve');
                      },
                    ),
                  ),
                ],
              ),

            const SizedBox(height: 10),
          ],
        ),
      ),
      isScrollControlled: true,
    );
  }
}
