import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/state_manager.dart';
import 'package:bbvision/controller/visitor/view_visitor_controller.dart';
import 'package:bbvision/model/visitor/visitor_model.dart';
import 'package:bbvision/widget/appColors.dart';

class VisitorDetailsScreen extends StatelessWidget {
  final VisitorModel visitor;

  VisitorDetailsScreen({super.key, required this.visitor});

  final controller = Get.find<ViewVisitorController>();

  Color statusColor(String status) =>
      status == '1' ? Colors.orange : Colors.green;

  String statusText(String status) => status == '1' ? "Pending" : "Approved";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F6FA),
      appBar: AppBar(
        elevation: 0,
        title: const Text('Visitor Details'),
        actions: [
          Container(
            margin: const EdgeInsets.only(right: 16),
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
            decoration: BoxDecoration(
              color: AppColors.scaffoldBg,
              borderRadius: BorderRadius.circular(20),
            ),
            child: Text(
              statusText(visitor.status),
              style: TextStyle(
                color: statusColor(visitor.status),
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ],
      ),

      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            /// Header Card
            _headerCard(context),

            const SizedBox(height: 16),

            /// General Info
            _infoCard(
              title: "General Information",
              children: [
                _infoRow(
                  Icons.calendar_today,
                  "Date",
                  visitor.date.toString().split(' ')[0],
                ),
                _infoRow(Icons.phone, "Mobile", visitor.mobile),
                _infoRow(Icons.email, "Email", visitor.email),
                _infoRow(Icons.location_on, "Coming From", visitor.comingFrom),
              ],
            ),

            const SizedBox(height: 16),

            /// Visit Info
            _infoCard(
              title: "Visit Details",
              children: [
                _infoRow(Icons.business, "Company", visitor.company),
                _infoRow(Icons.work, "Department", visitor.departmentName),
                _infoRow(Icons.person, "Employee", visitor.employeeName),
                _infoRow(Icons.assignment, "Purpose", visitor.purpose),
              ],
            ),

            const SizedBox(height: 16),

            /// Vehicle Info
            _infoCard(
              title: "Vehicle Details",
              children: [
                _infoRow(
                  Icons.directions_car,
                  "Vehicle Type",
                  visitor.vehicelName,
                ),
                _infoRow(
                  Icons.confirmation_number,
                  "Vehicle No",
                  visitor.vehicleNo,
                ),
              ],
            ),

            const SizedBox(height: 16),

            /// Remarks
            if (visitor.remarks.isNotEmpty)
              _infoCard(
                title: "Remarks",
                children: [
                  Text(visitor.remarks, style: const TextStyle(fontSize: 14)),
                ],
              ),

            if (visitor.status == '1')
              Obx(
                () => ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: controller.isLoading.value
                        ? AppColors.buttonDisabled
                        : AppColors.buttonPrimary,
                  ),
                  onPressed: () {
                    controller.approveStatus(visitor.id.toString());
                  },
                  child: controller.isLoading.value
                      ? const CircularProgressIndicator()
                      : const Text('Approved'),
                ),
              ),
          ],
        ),
      ),
    );
  }

  /// Header
  Widget _headerCard(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          CircleAvatar(
            radius: 32,
            backgroundColor: statusColor(visitor.status).withOpacity(0.15),
            child: Text(
              visitor.firstName[0].toUpperCase(),
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: statusColor(visitor.status),
              ),
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  visitor.firstName,
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  visitor.company,
                  style: TextStyle(fontSize: 14, color: Colors.grey.shade600),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  /// Info Card
  Widget _infoCard({required String title, required List<Widget> children}) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.04),
            blurRadius: 8,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
          ),
          const SizedBox(height: 12),
          ...children,
        ],
      ),
    );
  }

  /// Info Row
  Widget _infoRow(IconData icon, String label, String value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: Row(
        children: [
          Icon(icon, size: 18, color: Colors.grey.shade600),
          const SizedBox(width: 10),
          SizedBox(
            width: 100,
            child: Text(
              label,
              style: TextStyle(fontSize: 14, color: Colors.grey.shade600),
            ),
          ),
          Expanded(
            child: Text(
              value.isEmpty ? "-" : value,
              style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w500),
            ),
          ),
        ],
      ),
    );
  }
}
