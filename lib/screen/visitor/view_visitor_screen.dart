import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:bbvision/controller/visitor/view_visitor_controller.dart';
import 'package:bbvision/screen/visitor/visitor_details_screen.dart';
import 'package:bbvision/widget/appColors.dart';

class ViewVisitorScreen extends StatelessWidget {
  ViewVisitorScreen({super.key});

  final controller = Get.put(ViewVisitorController());
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        titleSpacing: 0,
        title: Obx(() {
          return controller.search.value
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
                      controller.filteredListCnt(value); // optional
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
              : const Text('View Visitors');
        }),
        actions: [
          Obx(() {
            return controller.search.value
                ? const SizedBox() // hide menu while searching
                : PopupMenuButton<String>(
                    padding: const EdgeInsets.only(right: 12),
                    icon: const Icon(Icons.more_vert),
                    onSelected: (value) {
                      if (value == 'search') {
                        controller.toggleSearch();
                      } else if (value == 'date') {
                        // open date filter
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
                      // PopupMenuItem(
                      //   value: 'date',
                      //   child: Row(
                      //     children: [
                      //       Icon(
                      //         Icons.calendar_today,
                      //         size: 18,
                      //         color: AppColors.appBar,
                      //       ),
                      //       SizedBox(width: 8),
                      //       Text('Date Wise'),
                      //     ],
                      //   ),
                      // ),
                    ],
                  );
          }),
        ],
      ),
      body: RefreshIndicator(
        onRefresh: () async {
          await controller.getVisitorList();
        },
        child: Obx(() {
          if (controller.isLoading.value) {
            return const Center(child: CircularProgressIndicator());
          }

          if (controller.filteredList.isEmpty) {
            return Center(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 24),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.inbox_outlined,
                      size: 90,
                      color: Colors.grey.shade400,
                    ),
                    const SizedBox(height: 16),

                    const Text(
                      "No visitors found",
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const SizedBox(height: 8),

                    Text(
                      "Try refreshing or adjust your filters to see visitors.",
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 14,
                        color: Colors.grey.shade600,
                      ),
                    ),
                    const SizedBox(height: 20),

                    ElevatedButton.icon(
                      onPressed: () {
                        controller.toggleSearch();
                      },
                      icon: const Icon(Icons.refresh),
                      label: const Text("Refresh"),
                      style: ElevatedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 24,
                          vertical: 12,
                        ),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            );
          }
          return ListView.builder(
            padding: const EdgeInsets.all(16),
            itemCount: controller.filteredList.length,
            itemBuilder: (context, index) {
              final item = controller.filteredList[index];
              Color statusColor(String status) {
                return status == '1'
                    ? AppColors.buttonPrimary
                    : AppColors.success;
              }

              String statusText(String status) {
                return status == '1' ? "Pending" : "Approved";
              }

              return GestureDetector(
                onTap: () {
                  Get.to(() => VisitorDetailsScreen(visitor: item));
                },
                child: Container(
                  margin: const EdgeInsets.only(bottom: 14),
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(16),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.06),
                        blurRadius: 10,
                        offset: const Offset(0, 4),
                      ),
                    ],
                  ),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      /// Avatar
                      CircleAvatar(
                        radius: 24,
                        backgroundColor: statusColor(
                          item.status,
                        ).withOpacity(0.15),
                        child: Text(
                          item.firstName[0].toUpperCase(),
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            color: statusColor(item.status),
                          ),
                        ),
                      ),

                      const SizedBox(width: 12),

                      /// Info
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            /// Name + Status
                            Row(
                              children: [
                                Expanded(
                                  child: Text(
                                    item.firstName,
                                    style: const TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                ),
                                Container(
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 10,
                                    vertical: 4,
                                  ),
                                  decoration: BoxDecoration(
                                    color: statusColor(
                                      item.status,
                                    ).withOpacity(0.15),
                                    borderRadius: BorderRadius.circular(20),
                                  ),
                                  child: Text(
                                    statusText(item.status),
                                    style: TextStyle(
                                      fontSize: 12,
                                      fontWeight: FontWeight.w600,
                                      color: statusColor(item.status),
                                    ),
                                  ),
                                ),
                              ],
                            ),

                            const SizedBox(height: 6),

                            /// Company
                            if (item.email != '')
                              Row(
                                children: [
                                  Icon(
                                    Icons.email,
                                    size: 14,
                                    color: Colors.grey.shade600,
                                  ),
                                  const SizedBox(width: 6),
                                  Expanded(
                                    child: Text(
                                      item.email,
                                      style: TextStyle(
                                        fontSize: 13,
                                        color: Colors.grey.shade700,
                                      ),
                                    ),
                                  ),
                                ],
                              ),

                            const SizedBox(height: 4),

                            /// Date + Mobile
                            Row(
                              children: [
                                Icon(
                                  Icons.calendar_today,
                                  size: 14,
                                  color: Colors.grey.shade600,
                                ),
                                const SizedBox(width: 6),
                                Text(
                                  item.date.toString().split(' ')[0],
                                  style: TextStyle(
                                    fontSize: 13,
                                    color: Colors.grey.shade700,
                                  ),
                                ),
                                const SizedBox(width: 12),
                                Icon(
                                  Icons.phone,
                                  size: 14,
                                  color: Colors.grey.shade600,
                                ),
                                const SizedBox(width: 6),
                                Text(
                                  item.mobile,
                                  style: TextStyle(
                                    fontSize: 13,
                                    color: Colors.grey.shade700,
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),

                      /// Arrow
                      const Icon(Icons.chevron_right, color: Colors.grey),
                    ],
                  ),
                ),
              );
            },
          );
        }),
      ),
    );
  }
}
