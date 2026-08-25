import 'package:bbvision/controller/location_controller.dart';
import 'package:bbvision/model/location_result_model.dart';
import 'package:bbvision/widget/appColors.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ViewLocationScreen extends StatelessWidget {
  ViewLocationScreen({super.key});

  final controller = Get.put(LocationController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Locations"),
        actions: [
          IconButton(
            icon: const Icon(Icons.date_range),
            tooltip: "Select Date Range",
            onPressed: () async {
              final DateTimeRange? picked = await showDateRangePicker(
                context: context,
                firstDate: DateTime(1900),
                lastDate: DateTime(2100),
                saveText: "Submit",
              );

              if (picked != null) {
                final fromDate =
                    "${picked.start.year}-${picked.start.month.toString().padLeft(2, '0')}-${picked.start.day.toString().padLeft(2, '0')}";

                final toDate =
                    "${picked.end.year}-${picked.end.month.toString().padLeft(2, '0')}-${picked.end.day.toString().padLeft(2, '0')}";

                debugPrint("From Date: $fromDate");
                debugPrint("To Date: $toDate");

                // Call API here
                controller.getLocationByDate(
                  fromDate: fromDate,
                  toDate: toDate,
                );
              }
            },
          ),
        ],
      ),
      body: Obx(() {
        if (controller.isLoading.value) {
          return const Center(child: CircularProgressIndicator());
        }

        return Column(
          children: [
            // Selected date filter
            if (controller.fromDate.value.isNotEmpty &&
                controller.toDate.value.isNotEmpty)
              Container(
                margin: const EdgeInsets.fromLTRB(16, 12, 16, 4),
                padding: const EdgeInsets.symmetric(
                  horizontal: 12,
                  vertical: 8,
                ),
                decoration: BoxDecoration(
                  color: AppColors.blue.withOpacity(0.2),
                  borderRadius: BorderRadius.circular(10),
                  border: Border.all(color: AppColors.blue.withOpacity(0.5)),
                ),
                child: Row(
                  children: [
                    const Icon(Icons.date_range, size: 20),

                    const SizedBox(width: 8),

                    Expanded(
                      child: Text(
                        "${controller.fromDate.value}  →  ${controller.toDate.value}",
                        style: const TextStyle(fontWeight: FontWeight.w500),
                      ),
                    ),

                    IconButton(
                      icon: const Icon(Icons.close, size: 20),
                      tooltip: "Clear date filter",
                      onPressed: () {
                        controller.fromDate.value = "";
                        controller.toDate.value = "";

                        // Reload all locations
                        controller.getLocation();
                      },
                    ),
                  ],
                ),
              ),

            // Location list
            Expanded(
              child: controller.locationDetails.isEmpty
                  ? const Center(child: Text("No location found"))
                  : ListView.builder(
                      padding: const EdgeInsets.all(16),
                      itemCount: controller.locationDetails.length,
                      itemBuilder: (context, index) {
                        final location = controller.locationDetails[index]!;

                        return _attendanceCard(context, location);
                      },
                    ),
            ),
          ],
        );
      }),
    );
  }

  Widget _attendanceCard(BuildContext context, LocationResultModel location) {
    String formatLocationDate(DateTime? dateTime) {
      if (dateTime == null) {
        return "Not available";
      }

      final localDateTime = dateTime.toLocal();

      final day = localDateTime.day.toString().padLeft(2, '0');
      final month = localDateTime.month.toString().padLeft(2, '0');
      final year = localDateTime.year.toString();

      int hour = localDateTime.hour;
      final minute = localDateTime.minute.toString().padLeft(2, '0');

      final String period = hour >= 12 ? "PM" : "AM";

      hour = hour % 12;
      if (hour == 0) {
        hour = 12;
      }

      final formattedHour = hour.toString().padLeft(2, '0');

      return "$day/$month/$year, $formattedHour:$minute $period";
    }

    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: AppColors.border),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.04),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // ---------------------------------------------------------
          // Header
          // ---------------------------------------------------------
          Padding(
            padding: const EdgeInsets.all(16),
            child: Row(
              children: [
                Container(
                  height: 48,
                  width: 48,
                  decoration: BoxDecoration(
                    color: AppColors.primary.withOpacity(0.10),
                    borderRadius: BorderRadius.circular(14),
                  ),
                  child: const Icon(
                    Icons.fingerprint_rounded,
                    color: AppColors.primary,
                    size: 27,
                  ),
                ),

                const SizedBox(width: 12),

                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        "Attendance",
                        style: TextStyle(
                          fontSize: 12,
                          color: AppColors.textSecondary,
                        ),
                      ),

                      const SizedBox(height: 3),

                      Text(
                        location.employeeId,
                        style: const TextStyle(
                          fontSize: 17,
                          fontWeight: FontWeight.bold,
                          color: AppColors.textPrimary,
                        ),
                      ),
                    ],
                  ),
                ),

                _attendanceStatus(location),
              ],
            ),
          ),

          const Divider(height: 1, color: AppColors.divider),

          // ---------------------------------------------------------
          // IN / OUT TIME
          // ---------------------------------------------------------
          Padding(
            padding: const EdgeInsets.all(16),
            child: Row(
              children: [
                Expanded(
                  child: _timeCard(
                    icon: Icons.login_rounded,
                    title: "Check In",
                    value: formatLocationDate(location.inTime),
                  ),
                ),

                const SizedBox(width: 12),

                Expanded(
                  child: _timeCard(
                    icon: Icons.logout_rounded,
                    title: "Check Out",
                    value: location.outTime != null
                        ? formatLocationDate(location.outTime)
                        : "Not checked out",
                  ),
                ),
              ],
            ),
          ),
          // ---------------------------------------------------------
          // LOCATION
          // ---------------------------------------------------------
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Container(
              decoration: BoxDecoration(
                color: AppColors.drawerBg,
                borderRadius: BorderRadius.circular(14),
                border: Border.all(color: AppColors.border),
              ),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(14),
                child: Material(
                  color: AppColors.drawerBg,
                  child: Theme(
                    data: Theme.of(context).copyWith(
                      dividerColor: Colors.transparent,
                      splashColor: AppColors.primary.withOpacity(0.08),
                      highlightColor: AppColors.primary.withOpacity(0.04),
                    ),
                    child: ExpansionTile(
                      backgroundColor: AppColors.drawerBg,
                      collapsedBackgroundColor: AppColors.drawerBg,

                      leading: Container(
                        padding: const EdgeInsets.all(8),
                        decoration: BoxDecoration(
                          color: AppColors.primary.withOpacity(0.10),
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: const Icon(
                          Icons.location_on_rounded,
                          color: AppColors.primary,
                        ),
                      ),

                      title: const Text(
                        "Attendance Location",
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.bold,
                          color: AppColors.textPrimary,
                        ),
                      ),

                      subtitle: Text(
                        location.city.isNotEmpty
                            ? location.city
                            : "Location details",
                        style: const TextStyle(
                          fontSize: 12,
                          color: AppColors.textSecondary,
                        ),
                      ),

                      childrenPadding: const EdgeInsets.fromLTRB(14, 0, 14, 14),

                      children: [
                        const Divider(height: 1, color: AppColors.divider),

                        const SizedBox(height: 14),

                        _locationInfoRow(
                          icon: Icons.location_city_rounded,
                          title: "City",
                          value: location.city.isNotEmpty
                              ? location.city
                              : "Not available",
                        ),

                        const SizedBox(height: 12),

                        _locationInfoRow(
                          icon: Icons.map_rounded,
                          title: "Area",
                          value: location.area.isNotEmpty
                              ? location.area
                              : "Not available",
                        ),

                        const SizedBox(height: 12),

                        _locationInfoRow(
                          icon: Icons.north_rounded,
                          title: "Latitude",
                          value: location.latitude.toStringAsFixed(7),
                        ),

                        const SizedBox(height: 12),

                        _locationInfoRow(
                          icon: Icons.east_rounded,
                          title: "Longitude",
                          value: location.longitude.toStringAsFixed(7),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),
          const SizedBox(height: 16),
        ],
      ),
    );
  }

  Widget _locationInfoRow({
    required IconData icon,
    required String title,
    required String value,
  }) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Icon(icon, size: 18, color: AppColors.textSecondary),

        const SizedBox(width: 10),

        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: const TextStyle(
                  fontSize: 11,
                  color: AppColors.textSecondary,
                ),
              ),

              const SizedBox(height: 3),

              Text(
                value,
                style: const TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.w600,
                  color: AppColors.textPrimary,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _attendanceStatus(LocationResultModel location) {
    final bool completed = location.outTime != null;

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      decoration: BoxDecoration(
        color: completed
            ? Colors.green.withOpacity(0.10)
            : Colors.orange.withOpacity(0.10),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            completed ? Icons.check_circle_rounded : Icons.access_time_rounded,
            size: 15,
            color: completed ? Colors.green : Colors.orange,
          ),

          const SizedBox(width: 5),

          Text(
            completed ? "Completed" : "Active",
            style: TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w600,
              color: completed ? Colors.green : Colors.orange,
            ),
          ),
        ],
      ),
    );
  }

  Widget _timeCard({
    required IconData icon,
    required String title,
    required String value,
  }) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: AppColors.drawerBg,
        borderRadius: BorderRadius.circular(14),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(icon, size: 17, color: AppColors.primary),

              const SizedBox(width: 6),

              Text(
                title,
                style: const TextStyle(
                  fontSize: 11,
                  color: AppColors.textSecondary,
                ),
              ),
            ],
          ),

          const SizedBox(height: 8),

          Text(
            value,
            style: const TextStyle(
              fontSize: 13,
              fontWeight: FontWeight.w600,
              color: AppColors.textPrimary,
            ),
          ),
        ],
      ),
    );
  }
}
