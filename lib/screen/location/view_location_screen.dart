import 'package:bbvision/controller/location_controller.dart';
import 'package:bbvision/widget/appColors.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

class ViewLocationScreen extends StatelessWidget {
  ViewLocationScreen({super.key});

  final controller = Get.put(LocationController());

  @override
  Widget build(BuildContext context) {
    String formatLocationDate(DateTime? date) {
      if (date == null) {
        return "Unknown";
      }

      return DateFormat("dd MMM yyyy, hh:mm a").format(date);
    }

    return Scaffold(
      appBar: AppBar(title: const Text("Locations")),

      body: Obx(() {
        if (controller.isLoading.value) {
          return const Center(child: CircularProgressIndicator());
        }

        if (controller.locationDetails.isEmpty) {
          return const Center(child: Text("No location found"));
        }

        return ListView.builder(
          padding: const EdgeInsets.all(16),
          itemCount: controller.locationDetails.length,
          itemBuilder: (context, index) {
            final location = controller.locationDetails[index];

            return Card(
              margin: const EdgeInsets.only(bottom: 12),
              elevation: 0,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
                side: const BorderSide(color: AppColors.border),
              ),
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Employee ID + Location icon
                    Row(
                      children: [
                        Container(
                          padding: const EdgeInsets.all(10),
                          decoration: BoxDecoration(
                            color: AppColors.primary.withOpacity(0.1),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: const Icon(
                            Icons.location_on_rounded,
                            color: AppColors.primary,
                          ),
                        ),

                        const SizedBox(width: 12),

                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Text(
                                "Employee ID",
                                style: TextStyle(
                                  fontSize: 11,
                                  color: AppColors.textSecondary,
                                ),
                              ),

                              const SizedBox(height: 2),

                              Text(
                                location!.employeeId,
                                style: const TextStyle(
                                  fontSize: 15,
                                  fontWeight: FontWeight.bold,
                                  color: AppColors.textPrimary,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),

                    const SizedBox(height: 16),

                    const Divider(color: AppColors.divider),

                    const SizedBox(height: 10),

                    // Latitude
                    _locationInfoRow(
                      icon: Icons.north_rounded,
                      title: "Latitude",
                      value: location.latitude.toStringAsFixed(7),
                    ),

                    const SizedBox(height: 10),

                    // Longitude
                    _locationInfoRow(
                      icon: Icons.east_rounded,
                      title: "Longitude",
                      value: location.longitude.toStringAsFixed(7),
                    ),

                    const SizedBox(height: 10),

                    // Created At
                    _locationInfoRow(
                      icon: Icons.access_time_rounded,
                      title: "Captured At",
                      value: formatLocationDate(location.createdAt),
                    ),
                  ],
                ),
              ),
            );
          },
        );
      }),
    );
  }

  Widget _locationInfoRow({
    required IconData icon,
    required String title,
    required String value,
  }) {
    return Row(
      children: [
        Icon(icon, size: 19, color: AppColors.primary),

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

              const SizedBox(height: 2),

              Text(
                value,
                style: const TextStyle(
                  fontSize: 14,
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
}
