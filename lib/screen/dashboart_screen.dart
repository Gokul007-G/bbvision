import 'package:bbvision/controller/location_controller.dart';
import 'package:bbvision/screen/chat/chat_employee_page.dart';
import 'package:bbvision/screen/location/view_location_screen.dart';
import 'package:bbvision/screen/project/project_assignment_screen.dart';
import 'package:bbvision/screen/project/view_project_emp_screen.dart';
import 'package:bbvision/screen/show_location.dart';
import 'package:bbvision/widget/AttendanceConfirmationDialog.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:bbvision/controller/login_controller.dart';
import 'package:bbvision/model/login_model.dart';
import 'package:bbvision/screen/claim/add_claim_screen.dart';
import 'package:bbvision/screen/claim/view_claim_screen.dart';
import 'package:bbvision/screen/enquiry/add_enquiry_screen.dart';
import 'package:bbvision/screen/enquiry/view_enquiry_screen.dart';
import 'package:bbvision/screen/leave_management/add_leave_request_screen.dart';
import 'package:bbvision/screen/leave_management/view_request_screen.dart';
import 'package:bbvision/screen/login_screen.dart';
import 'package:bbvision/screen/payslip/payslip_screen.dart';
import 'package:bbvision/screen/visitor/add_visitor_screen.dart';
import 'package:bbvision/screen/visitor/view_visitor_screen.dart';
import 'package:bbvision/service/auth_local_storage.dart';
import 'package:bbvision/widget/appColors.dart';

class DashboardScreen extends StatelessWidget {
  DashboardScreen({super.key});

  final loginController = Get.put(LoginController());

  Future<LoginData?> _loadUser() async {
    final login = await AuthLocalStorage.getLoginDetails();
    return login?.data;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.scaffoldBg,
      body: FutureBuilder<LoginData?>(
        future: _loadUser(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          if (!snapshot.hasData) {
            return _emptyState();
          }

          return _dashboardContent(context, snapshot.data!);
        },
      ),
    );
  }

  // ================= DASHBOARD CONTENT =================

  Widget _dashboardContent(BuildContext context, LoginData user) {
    print(user.userName);
    return Column(
      children: [
        // 🔝 Fixed Header
        _header(user, context),

        const SizedBox(height: 12),

        // 🔹 Section title (fixed)
        Padding(
          padding: const EdgeInsets.only(top: 16, left: 16),
          child: _sectionTitle("Quick Actions"),
        ),

        // if (user.userGroupCode == 'R003')
        //   // 🔄 ONLY GRID SCROLLS
        //   Expanded(
        //     child: Padding(
        //       padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        //       child: GridView.count(
        //         crossAxisCount: 2,
        //         crossAxisSpacing: 14,
        //         mainAxisSpacing: 14,
        //         childAspectRatio: 1.4,
        //         children: [
        //           _actionCard(
        //             icon: Icons.note_add,
        //             title: "Add Enquiry",
        //             color: AppColors.primary,
        //             onTap: () => Get.to(() => AddEnquiryScreen()),
        //           ),
        //           _actionCard(
        //             icon: Icons.assignment,
        //             title: "View Enquiry",
        //             color: AppColors.blue,
        //             onTap: () => Get.to(() => ViewEnquiryScreen()),
        //           ),
        //           _actionCard(
        //             icon: Icons.person_add,
        //             title: "Add Visitor",
        //             color: AppColors.success,
        //             onTap: () => Get.to(() => AddVisitorScreen()),
        //           ),
        //           _actionCard(
        //             icon: Icons.groups,
        //             title: "View Visitor",
        //             color: AppColors.secondary,
        //             onTap: () => Get.to(() => ViewVisitorScreen()),
        //           ),
        //           _actionCard(
        //             icon: Icons.add_comment_sharp,
        //             title: "Leave Request",
        //             color: AppColors.chartPending,
        //             onTap: () => Get.to(() => AddLeaveRequestScreen()),
        //           ),
        //           _actionCard(
        //             icon: Icons.grading_outlined,
        //             title: "View Leave Request",
        //             color: AppColors.textPrimary,
        //             onTap: () => Get.to(() => ViewRequestScreen()),
        //           ),
        //           _actionCard(
        //             icon: Icons.add_card,
        //             title: "Add Claim",
        //             color: AppColors.warning,
        //             onTap: () => Get.to(() => AddClaimScreen()),
        //           ),
        //           _actionCard(
        //             icon: Icons.request_page,
        //             title: "Claim",
        //             color: AppColors.blue,
        //             onTap: () => Get.to(() => ViewClaimScreen()),
        //           ),
        //           _actionCard(
        //             icon: Icons.paypal_sharp,
        //             title: "Payslip View",
        //             color: AppColors.blue,
        //             onTap: () => Get.to(() => PayslipScreen()),
        //           ),
        //           _actionCard(
        //             icon: Icons.assignment_ind,
        //             title: "Project Assignment",
        //             color: AppColors.appBar,
        //             onTap: () => Get.to(() => ViewProjectsScreen()),
        //           ),
        //         ],
        //       ),
        //     ),
        //   ),

        // if (user.userGroupCode != 'R003')
        Expanded(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            child: GridView.count(
              crossAxisCount: 2,
              crossAxisSpacing: 14,
              mainAxisSpacing: 14,
              childAspectRatio: 1.4,
              children: [
                _actionCard(
                  icon: Icons.note_add,
                  title: "Add Enquiry",
                  color: AppColors.primary,
                  onTap: () => Get.to(() => AddEnquiryScreen()),
                ),
                _actionCard(
                  icon: Icons.assignment,
                  title: "View Enquiry",
                  color: AppColors.blue,
                  onTap: () => Get.to(() => ViewEnquiryScreen()),
                ),
                _actionCard(
                  icon: Icons.person_add,
                  title: "Add Visitor",
                  color: AppColors.success,
                  onTap: () => Get.to(() => AddVisitorScreen()),
                ),
                _actionCard(
                  icon: Icons.groups,
                  title: "View Visitor",
                  color: AppColors.secondary,
                  onTap: () => Get.to(() => ViewVisitorScreen()),
                ),
                _actionCard(
                  icon: Icons.add_comment_sharp,
                  title: "Leave Request",
                  color: AppColors.chartPending,
                  onTap: () => Get.to(() => AddLeaveRequestScreen()),
                ),
                _actionCard(
                  icon: Icons.grading_outlined,
                  title: "View Leave Request",
                  color: AppColors.textPrimary,
                  onTap: () => Get.to(() => ViewRequestScreen()),
                ),
                _actionCard(
                  icon: Icons.add_card,
                  title: "Add Claim",
                  color: AppColors.warning,
                  onTap: () => Get.to(() => AddClaimScreen()),
                ),
                _actionCard(
                  icon: Icons.request_page,
                  title: "Claim",
                  color: AppColors.blue,
                  onTap: () => Get.to(() => ViewClaimScreen()),
                ),
                _actionCard(
                  icon: Icons.paypal_sharp,
                  title: "Payslip View",
                  color: AppColors.blue,
                  onTap: () => Get.to(() => PayslipScreen()),
                ),
                _actionCard(
                  icon: Icons.assignment_ind,
                  title: "Project Assignment",
                  color: AppColors.appBar,
                  onTap: () {
                    if (user.userGroupCode != "R003") {
                      Get.to(() => ViewProjectEmpScreen());
                    } else {
                      Get.to(() => ProjectAssignmentScreen());
                    }
                  },
                ),
                _actionCard(
                  icon: Icons.fingerprint,
                  title: "Mark Attendance",
                  color: AppColors.appBar,
                  onTap: () => Get.to(() => ViewLocationScreen()),
                ),
                _actionCard(
                  icon: Icons.chat,
                  title: "Chat",
                  color: AppColors.appBar,
                  onTap: () => Get.to(() => ChatEmployeePage()),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  // ================= HEADER =================
  Widget _header(LoginData user, BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.fromLTRB(16, 60, 16, 30),
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          colors: [AppColors.primary, AppColors.secondary],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.vertical(bottom: Radius.circular(30)),
      ),
      child: Column(
        children: [
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 18),
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.15),
              borderRadius: BorderRadius.circular(20),
              border: Border.all(color: Colors.white.withOpacity(0.2)),
            ),
            child: Row(
              children: [
                CircleAvatar(
                  radius: 35,
                  backgroundColor: Colors.white,
                  child: Text(
                    user.fullName[0].toUpperCase(),
                    style: const TextStyle(
                      fontSize: 28,
                      fontWeight: FontWeight.bold,
                      color: AppColors.primary,
                    ),
                  ),
                ),

                const SizedBox(width: 16),

                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "Welcome",
                        style: TextStyle(
                          color: Colors.white.withOpacity(0.8),
                          fontSize: 14,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        user.fullName,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 4),
                      // Role / Username
                      Text(
                        user.userGroupCode,
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 14,
                        ),
                      ),
                    ],
                  ),
                ),

                Material(
                  color: Colors.white.withOpacity(0.2),
                  borderRadius: BorderRadius.circular(12),
                  child: InkWell(
                    borderRadius: BorderRadius.circular(12),
                    onTap: () {
                      Get.bottomSheet(
                        Container(
                          padding: const EdgeInsets.all(25),
                          decoration: const BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.vertical(
                              top: Radius.circular(25),
                            ),
                          ),
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Container(
                                width: 50,
                                height: 5,
                                decoration: BoxDecoration(
                                  color: Colors.grey.shade300,
                                  borderRadius: BorderRadius.circular(20),
                                ),
                              ),
                              const SizedBox(height: 20),

                              const CircleAvatar(
                                radius: 35,
                                backgroundColor: Color(0xFFFFEBEE),
                                child: Icon(
                                  Icons.logout_rounded,
                                  color: AppColors.error,
                                  size: 35,
                                ),
                              ),

                              const SizedBox(height: 20),

                              const Text(
                                "Logout",
                                style: TextStyle(
                                  fontSize: 22,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),

                              const SizedBox(height: 10),

                              const Text(
                                "Are you sure you want to logout?",
                                textAlign: TextAlign.center,
                                style: TextStyle(color: Colors.grey),
                              ),

                              const SizedBox(height: 25),

                              SizedBox(
                                width: double.infinity,
                                child: ElevatedButton(
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: AppColors.error,
                                    foregroundColor: Colors.white,
                                    padding: const EdgeInsets.symmetric(
                                      vertical: 14,
                                    ),
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(15),
                                    ),
                                  ),
                                  onPressed: () async {
                                    await AuthLocalStorage.clear();
                                    loginController.userNameController.clear();
                                    loginController.passwordController.clear();

                                    Get.offAll(() => LoginScreen());
                                  },
                                  child: const Text(
                                    "Logout",
                                    style: TextStyle(fontSize: 16),
                                  ),
                                ),
                              ),

                              TextButton(
                                onPressed: () => Get.back(),
                                child: const Text("Cancel"),
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                    child: const Padding(
                      padding: EdgeInsets.all(12),
                      child: Icon(
                        Icons.logout_rounded,
                        color: Colors.white,
                        size: 24,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),

          const SizedBox(height: 18),

          // Quick Info
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              _headerInfo(Icons.badge, "Emp ID", user.userName),
              _headerInfo(
                Icons.apartment,
                "Dept",
                user.departmentName == '' ? 'Founder' : user.departmentName,
              ),
              GestureDetector(
                onTap: () async {
                  final locationController = Get.put(LocationController());
                  print('----------------------------');
                  print('--------------this is attendances--------------');
                  try {
                    final response = await locationController.getAttendancesCnt(
                      user.userName,
                    );
                    print('---------$response-----------');
                    final int statusLog = response?["log"] ?? 0;
                    final int tableId = response?["tableId"] ?? 0;

                    print(statusLog);
                    print(tableId);
                    if (context.mounted) {
                      await _showLocationConfirmation(
                        context,
                        tableId,
                        statusLog,
                        locationController,
                      );
                    }
                  } finally {
                    if (Get.isRegistered<LocationController>()) {
                      Get.delete<LocationController>();
                    }
                  }
                },
                child: _headerInfo(Icons.location_on, "Mark", "Attendance"),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Future<void> _showLocationConfirmation(
    BuildContext context,
    int? tableId,
    int? statusLog,
    LocationController locationController,
  ) async {
    final bool? confirm = await showDialog<bool>(
      context: context,
      builder: (_) => AttendanceConfirmationDialog(status: statusLog!),
    );
    if (confirm != true) return;

    _showLocationLoading(context);

    try {
      if (statusLog == 0) {
        final location = await locationController.getCurrentLocation(context);

        if (context.mounted) {
          Navigator.pop(context);
        }

        if (location == null) return;

        if (context.mounted) {
          showLocation(context, location);
        }
      }
      if (statusLog == 1 && tableId != null) {
        final updateStatus = await locationController.updateLogoutCnt(tableId);

        if (updateStatus) {
          Get.snackbar("Success", "Logout update succesfully");
        }
        Navigator.pop(context);
      }
    } catch (e) {
      if (context.mounted) {
        Navigator.pop(context);
      }

      debugPrint("Location Error: $e");
    }
  }

  void _showLocationLoading(BuildContext context) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) {
        return const AlertDialog(
          content: Row(
            children: [
              SizedBox(
                width: 25,
                height: 25,
                child: CircularProgressIndicator(strokeWidth: 3),
              ),
              SizedBox(width: 20),
              Expanded(child: Text("Getting your current location...")),
            ],
          ),
        );
      },
    );
  }

  Widget _headerInfo(IconData icon, String label, String value) {
    return Column(
      children: [
        Icon(icon, color: Colors.white70, size: 20),
        const SizedBox(height: 4),
        Text(
          label,
          style: const TextStyle(color: Colors.white70, fontSize: 12),
        ),
        const SizedBox(height: 2),
        Text(
          value,
          style: const TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
          ),
        ),
      ],
    );
  }

  // ================= ACTION CARD =================

  Widget _actionCard({
    required IconData icon,
    required String title,
    required Color color,
    required VoidCallback onTap,
  }) {
    return InkWell(
      borderRadius: BorderRadius.circular(18),
      onTap: onTap,
      child: Container(
        decoration: BoxDecoration(
          color: AppColors.cardBg,
          borderRadius: BorderRadius.circular(18),
          boxShadow: [
            BoxShadow(
              color: color.withOpacity(0.15),
              blurRadius: 10,
              offset: const Offset(0, 6),
            ),
          ],
        ),
        padding: const EdgeInsets.all(16),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              padding: const EdgeInsets.all(14),
              decoration: BoxDecoration(
                color: color.withOpacity(0.15),
                shape: BoxShape.circle,
              ),
              child: Icon(icon, color: color, size: 28),
            ),
            const SizedBox(height: 12),
            Text(
              title,
              textAlign: TextAlign.center,
              style: const TextStyle(
                fontWeight: FontWeight.w600,
                fontSize: 12,
                color: AppColors.textPrimary,
              ),
            ),
          ],
        ),
      ),
    );
  }

  // ================= EMPTY =================

  Widget _emptyState() {
    return const Center(
      child: Text(
        "No user data found",
        style: TextStyle(color: AppColors.textSecondary),
      ),
    );
  }

  Widget _sectionTitle(String title) {
    return Align(
      alignment: Alignment.centerLeft,
      child: Text(
        title,
        style: const TextStyle(
          fontSize: 22,
          fontWeight: FontWeight.bold,
          color: AppColors.textPrimary,
        ),
      ),
    );
  }
}
