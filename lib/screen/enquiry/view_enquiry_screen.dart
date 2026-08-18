import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:bbvision/controller/enquiry/view_enquiry_controller.dart';
import 'package:bbvision/screen/enquiry/view_enquiry_details_screen.dart';

import '../../widget/appColors.dart';

class ViewEnquiryScreen extends StatelessWidget {
  ViewEnquiryScreen({super.key});
  final controller = Get.put(ViewEnquiryController());
  
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
                      controller.filteredEnqueryList(value); // optional
                    },
                    decoration: InputDecoration(
                      hintText: 'Search enquiries...',
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
              : const Text('View Enquiry');
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
          await controller.getEnquiryListCnt();
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
                      "No enquiries found",
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const SizedBox(height: 8),

                    Text(
                      "Try refreshing or adjust your filters to see enquiries.",
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 14,
                        color: Colors.grey.shade600,
                      ),
                    ),
                    const SizedBox(height: 20),

                    ElevatedButton.icon(
                      onPressed: () {
                        controller.getEnquiryListCnt();
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

          return Column(
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 8,
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    /// Dropdown
                    Row(
                      children: [
                        const Text("Show "),
                        Obx(
                          () => DropdownButton<int>(
                            value: controller.itemsPerPage.value,
                            items: [10, 20, 30, 50, 100]
                                .map(
                                  (e) => DropdownMenuItem(
                                    value: e,
                                    child: Text("$e"),
                                  ),
                                )
                                .toList(),
                            onChanged: (value) {
                              if (value != null) {
                                controller.changeItemsPerPage(value);
                              }
                            },
                          ),
                        ),
                        const Text(" entries"),
                      ],
                    ),

                    /// Total count
                    Obx(
                      () => Text(
                        "Total: ${controller.totalItems}",
                        style: const TextStyle(fontWeight: FontWeight.bold),
                      ),
                    ),
                  ],
                ),
              ),

              Expanded(
                child: ListView.builder(
                  padding: const EdgeInsets.all(16),
                  itemCount: controller.paginatedList.length,
                  itemBuilder: (context, index) {
                    final item = controller.paginatedList[index];
                    final sno =
                        ((controller.currentPage.value - 1) *
                            controller.itemsPerPage.value) +
                        index +
                        1;

                    return InkWell(
                      borderRadius: BorderRadius.circular(14),
                      onTap: () async {
                        await controller.getEnquiryDetailsById(item.id!);
                        Get.to(() => const ViewEnquiryDetailsScreen());
                      },
                      child: Container(
                        margin: const EdgeInsets.only(bottom: 14),
                        padding: const EdgeInsets.all(5),
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
                        child: Padding(
                          padding: const EdgeInsets.all(14),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              // 🔹 Top Row
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Expanded(
                                    child: Text(
                                      (item.clientName == '' ||
                                              item.clientName == null)
                                          ? '$sno .N/A'
                                          : '$sno .${item.clientName!}',
                                      style: const TextStyle(
                                        fontSize: 16,
                                        fontWeight: FontWeight.w600,
                                      ),
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                  ),

                                  Container(
                                    padding: const EdgeInsets.symmetric(
                                      horizontal: 10,
                                      vertical: 4,
                                    ),
                                    decoration: BoxDecoration(
                                      color:
                                          item.status ==
                                              5 //InActive
                                          ? Colors.red.shade100
                                          : Colors.green.shade100,
                                      borderRadius: BorderRadius.circular(20),
                                    ),
                                    child: Text(
                                      controller.getStatusText(item.status),
                                      style: TextStyle(
                                        fontSize: 12,
                                        color:
                                            item.status ==
                                                5 // Assigned
                                            ? Colors.red.shade700
                                            : Colors.green.shade700,
                                        fontWeight: FontWeight.w600,
                                      ),
                                    ),
                                  ),
                                ],
                              ),

                              const SizedBox(height: 8),

                              // 🔹 Organisation
                              Row(
                                children: [
                                  const Icon(
                                    Icons.business,
                                    size: 16,
                                    color: Colors.grey,
                                  ),
                                  const SizedBox(width: 6),
                                  Expanded(
                                    child: Text(
                                      item.clientOrg!,
                                      style: const TextStyle(
                                        color: Colors.black87,
                                      ),
                                      maxLines: 2,
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                  ),
                                ],
                              ),

                              const SizedBox(height: 6),

                              // 🔹 Date & Created By //
                              Row(
                                children: [
                                  const Icon(
                                    Icons.calendar_today,
                                    size: 14,
                                    color: Colors.grey,
                                  ),
                                  const SizedBox(width: 6),
                                  Text(
                                    controller.formatDate(item.createdOn),
                                    style: const TextStyle(fontSize: 12),
                                  ),
                                  const Spacer(),
                                  const Icon(
                                    Icons.person,
                                    size: 14,
                                    color: Colors.grey,
                                  ),
                                  const SizedBox(width: 6),
                                  Text(
                                    item.empName ?? '',
                                    style: const TextStyle(fontSize: 12),
                                  ),
                                ],
                              ),

                              const SizedBox(height: 10),

                              // 🔹 View Details Hint
                              Row(
                                mainAxisAlignment: MainAxisAlignment.end,
                                children: const [
                                  Text(
                                    "View Details",
                                    style: TextStyle(
                                      color: Colors.blue,
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                  SizedBox(width: 4),
                                  Icon(
                                    Icons.arrow_forward_ios,
                                    size: 14,
                                    color: Colors.blue,
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ),
                    );
                  },
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(16),
                child: Obx(
                  () => Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 10,
                    ),
                    decoration: BoxDecoration(
                      color: Colors.grey.shade100,
                      borderRadius: BorderRadius.circular(16),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.05),
                          blurRadius: 8,
                          offset: const Offset(0, 4),
                        ),
                      ],
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        /// 🔹 Previous Button
                        ElevatedButton.icon(
                          onPressed: controller.currentPage.value > 1
                              ? () => controller.currentPage.value--
                              : null,
                          icon: const Icon(Icons.arrow_back_ios_new, size: 16),
                          label: const Text("Previous"),
                          style: ElevatedButton.styleFrom(
                            elevation: 0,
                            backgroundColor: controller.currentPage.value > 1
                                ? Colors.blue
                                : Colors.grey.shade400,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                          ),
                        ),

                        /// 🔹 Page Indicator
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 16,
                            vertical: 8,
                          ),
                          decoration: BoxDecoration(
                            color: Colors.blue.shade50,
                            borderRadius: BorderRadius.circular(30),
                          ),
                          child: Text(
                            "Page ${controller.currentPage.value} of ${controller.totalPages}",
                            style: const TextStyle(
                              fontWeight: FontWeight.w600,
                              fontSize: 14,
                            ),
                          ),
                        ),

                        /// 🔹 Next Button
                        ElevatedButton.icon(
                          onPressed:
                              controller.currentPage.value <
                                  controller.totalPages
                              ? () => controller.currentPage.value++
                              : null,
                          icon: const Icon(Icons.arrow_forward_ios, size: 16),
                          label: const Text("Next"),
                          style: ElevatedButton.styleFrom(
                            elevation: 0,
                            backgroundColor:
                                controller.currentPage.value <
                                    controller.totalPages
                                ? Colors.blue
                                : Colors.grey.shade400,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 12),
            ],
          );
        }),
      ),
    );
  }
}
