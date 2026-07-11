import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:bbvision/controller/claim/view_claim_controller.dart';
import 'package:bbvision/model/claim/claim_request_model.dart';
import 'package:bbvision/service/service.dart';
import 'package:bbvision/widget/appColors.dart';

Color statusColor(int? status) {
  switch (status) {
    case 1:
      return AppColors.primary;
    case 2:
    case 3:
      return AppColors.success;
    case 4:
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
      return "Approved by Finance Department.";
    case 3:
      return "Approved by HOD & Finance Head.";
    case 4:
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
    case 3:
      return Icons.check_circle;
    case 4:
      return Icons.cancel;
    default:
      return Icons.info;
  }
}

String _statusMessage(int? status) {
  switch (status) {
    case 1:
      return "This claim request is pending. Please review and take action.";
    case 2:
      return "Approved by Finance Department.";
    case 3:
      return "Approved by HOD & Finance Head.";
    case 4:
      return "Request Rejected.";
    default:
      return "Unknown status.";
  }
}

class ViewClaimScreen extends StatelessWidget {
  ViewClaimScreen({super.key});

  final controller = Get.put(ViewClaimController());
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Obx(
          () => controller.isSearch.value
              ? Container(
                  margin: const EdgeInsets.symmetric(horizontal: 12),
                  height: 46,
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: TextField(
                    controller: controller.searchCnt,
                    autofocus: true,
                    onChanged: (value) {
                      controller.searchValue.value = value;
                      controller.filterSearch(value);
                    },
                    decoration: InputDecoration(
                      hintText: 'Search...',
                      border: InputBorder.none,
                      prefixIcon: const Icon(Icons.search),
                      suffixIcon: IconButton(
                        icon: const Icon(Icons.close),
                        onPressed: controller.toggleSearch,
                      ),
                      contentPadding: const EdgeInsets.symmetric(vertical: 10),
                    ),
                  ),
                )
              : Text('CLAIM REQUEST'),
        ),
        actions: [
          Obx(() {
            return controller.isSearch.value
                ? const SizedBox.shrink()
                : PopupMenuButton<String>(
                    padding: const EdgeInsets.only(right: 16),
                    icon: Icon(Icons.more_vert),
                    onSelected: (value) {
                      if (value == 'search') {
                        controller.toggleSearch();
                      }
                    },
                    itemBuilder: (context) => const [
                      PopupMenuItem(
                        value: 'search',
                        child: Row(
                          children: [
                            Icon(
                              Icons.search,
                              size: 18,
                              color: AppColors.appBar,
                            ),
                            SizedBox(width: 8),
                            Text('Search'),
                          ],
                        ),
                      ),
                    ],
                  );
          }),
        ],
      ),
      body: Obx(() {
        if (controller.isLoading.value) {
          return const Center(child: CircularProgressIndicator());
        }
        if (controller.filteredList.isEmpty) {
          return RefreshIndicator(
            onRefresh: controller.getClaimListCnt,
            child: ListView(
              children: const [
                SizedBox(height: 300),
                Center(child: Text("No Requests found")),
              ],
            ),
          );
        }
        return RefreshIndicator(
          onRefresh: controller.getClaimListCnt,
          child: ListView.builder(
            padding: const EdgeInsets.all(12),
            itemCount: controller.filteredList.length,
            itemBuilder: (context, index) {
              final item = controller.filteredList[index];
              return InkWell(
                onTap:
                    controller.userGroupCode.value == 'R008' ||
                        controller.userGroupCode.value == 'R003'
                    ? () async {
                        showApproveRejectSheet(context, item);
                      }
                    : null,
                child: Container(
                  margin: const EdgeInsets.only(bottom: 14),
                  padding: const EdgeInsets.all(14),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(18),
                    border: Border.all(color: Colors.grey.shade200),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.06),
                        blurRadius: 10,
                        offset: const Offset(0, 6),
                      ),
                    ],
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      /// 🔹 ROW 1 : S.No + Status
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Icon(Icons.badge, size: 18, color: AppColors.primary),
                          const SizedBox(width: 8),

                          Expanded(
                            child: Text(
                              item.empCode,
                              style: const TextStyle(fontSize: 14),
                            ),
                          ),
                          _statusChip(item.status),
                        ],
                      ),

                      const Divider(height: 20),
                      Row(
                        children: [
                          Icon(
                            Icons.person,
                            size: 18,
                            color: AppColors.primary,
                          ),
                          const SizedBox(width: 8),

                          Expanded(
                            child: Text(
                              item.fullName,
                              style: const TextStyle(fontSize: 14),
                            ),
                          ),
                          Icon(
                            Icons.calendar_today,
                            size: 18,
                            color: Colors.blueGrey,
                          ),
                          const SizedBox(width: 8),
                          Text(item.date),
                        ],
                      ),

                      const SizedBox(height: 6),

                      /// 🔹 CLAIM INFO
                      _infoRow(Icons.store, 'Customer', item.customerName),
                      _infoRow(Icons.location_on, 'Location', item.location),
                      _infoRow(Icons.description, 'Purpose', item.purpose),

                      /// 🔹 ACTION BUTTONS
                      if (item.file.isNotEmpty)
                        TextButton.icon(
                          onPressed: () {
                            final image = Service.claimImageUrl;
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
                                              '$image${item.file}',
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
                                                            color: Colors.white,
                                                          ),
                                                    );
                                                  },
                                              errorBuilder:
                                                  (context, error, stackTrace) {
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
                                                            color: Colors.white,
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
                            padding: EdgeInsets.only(bottom: 12),
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
                      Row(
                        children: [
                          /// 🚗 Travel Type
                          _iconChip(
                            icon: Icons.travel_explore,
                            label: item.travelType,
                            color: AppColors.primary,
                          ),

                          const SizedBox(width: 10),

                          /// 🛣 KMs (Only for type 1 & 4)
                          if (item.travelTypeId == 1 || item.travelTypeId == 4)
                            _iconChip(
                              icon: Icons.speed,
                              label: '${item.kms} KM',
                              color: AppColors.chartPending,
                            ),

                          const Spacer(),

                          /// 💰 Amount
                          _iconChip(
                            icon: Icons.currency_rupee,
                            label: item.amount,
                            color: Colors.green,
                            bold: true,
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              );
            },
          ),
        );
      }),
    );
  }

  void showApproveRejectSheet(BuildContext context, ClaimRequestModel item) {
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
                        item.fullName,
                        style: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        item.date,
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
                        controller.updateStatusCnt(item.id, 4);
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
                        controller.updateStatusCnt(
                          item.id,
                          controller.userGroupCode.value == 'R008' ? 2 : 3,
                        );
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

  Widget _infoRow(IconData icon, String label, String value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 6),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, size: 18, color: AppColors.primary),
          const SizedBox(width: 8),
          Text(
            '$label : ',
            style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 14),
          ),
          Expanded(child: Text(value, style: const TextStyle(fontSize: 14))),
        ],
      ),
    );
  }

  Widget _iconChip({
    required IconData icon,
    required String label,
    required Color color,
    bool bold = false,
  }) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      decoration: BoxDecoration(
        color: color.withOpacity(0.12),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: color.withOpacity(0.3)),
      ),
      child: Row(
        children: [
          Icon(icon, size: 16, color: color),
          const SizedBox(width: 6),
          Text(
            label,
            style: TextStyle(
              fontSize: 13,
              fontWeight: bold ? FontWeight.bold : FontWeight.w500,
              color: color,
            ),
          ),
        ],
      ),
    );
  }

  Widget _statusChip(int status) {
    Color color;
    String text;

    switch (status) {
      case 1:
        color = AppColors.chartPending;
        text = 'Request Pending';
        break;
      case 2:
        color = AppColors.success;
        text = 'Approved by Finance Department';
        break;
      case 3:
        color = AppColors.success;
        text = 'Approved by HOD and Finance Head';
        break;
      case 4:
        color = AppColors.error;
        text = 'Request Rejected';
        break;
      default:
        color = Colors.grey;
        text = 'Unknown';
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: color.withOpacity(0.15),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Text(
        text,
        overflow: TextOverflow.ellipsis,
        style: TextStyle(
          color: color,
          fontSize: 12,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }
}

class FullImageView extends StatelessWidget {
  final String imageUrl;

  const FullImageView({super.key, required this.imageUrl});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(backgroundColor: Colors.transparent),
      body: Center(child: InteractiveViewer(child: Image.network(imageUrl))),
    );
  }
}
