import 'package:bbvision/controller/project/project_controller.dart';
import 'package:bbvision/screen/project/view_project_emp_screen.dart';
import 'package:bbvision/widget/appColors.dart';
import 'package:bbvision/widget/custom_text_field.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ProjectAssignmentScreen extends StatelessWidget {

  ProjectAssignmentScreen({super.key});

  final controller = Get.put(ProjectController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Project Assignment"),
        actions: [
          IconButton(
            onPressed: () {
              Get.to(ViewProjectEmpScreen());
            },
            icon: Icon(Icons.assignment),
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            //project name
            CustomTextField(
              controller: controller.projectName.value,
              label: "Project Name",
              prefixIcon: Icons.work,
            ),

            //select role
            Obx(
              () => InkWell(
                borderRadius: BorderRadius.circular(14),
                onTap: showRoleBottomSheet,
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 200),
                  padding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 14,
                  ),
                  margin: EdgeInsets.only(bottom: 12),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(14),
                    border: Border.all(
                      color: controller.selectedRole.value == null
                          ? Colors.grey.shade300
                          : Colors.blue.shade400,
                      width: 1.2,
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.grey.withOpacity(0.12),
                        blurRadius: 10,
                        offset: const Offset(0, 4),
                      ),
                    ],
                  ),
                  child: Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.all(10),
                        decoration: BoxDecoration(
                          color: Colors.blue.shade50,
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: Icon(
                          Icons.badge_outlined,
                          color: Colors.blue.shade700,
                          size: 22,
                        ),
                      ),

                      const SizedBox(width: 14),

                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              "Project Role",
                              style: TextStyle(
                                fontSize: 12,
                                color: Colors.grey.shade600,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                            const SizedBox(height: 3),
                            Text(
                              controller.selectedRole.value?.empRoleName ??
                                  "Select Employee Role",
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: TextStyle(
                                fontSize: 15,
                                fontWeight: FontWeight.w600,
                                color: controller.selectedRole.value == null
                                    ? Colors.grey.shade500
                                    : Colors.black87,
                              ),
                            ),
                          ],
                        ),
                      ),

                      Icon(
                        Icons.keyboard_arrow_down_rounded,
                        color: Colors.grey.shade700,
                        size: 30,
                      ),
                    ],
                  ),
                ),
              ),
            ),

            //Employee List
            Obx(
              () => InkWell(
                onTap: () => controller.selectedRole.value == null
                    ? null
                    : showEmployeeBottomSheet(context),
                borderRadius: BorderRadius.circular(12),
                child: Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(14),
                  decoration: BoxDecoration(
                    color: AppColors.cardBg,
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(
                      color: controller.selectedEmployees.isNotEmpty
                          ? AppColors.primary
                          : AppColors.border,
                      width: 1.5,
                    ),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Label
                      const Text(
                        "Assign Employees",
                        style: TextStyle(
                          fontSize: 13,
                          color: AppColors.textSecondary,
                          fontWeight: FontWeight.w500,
                        ),
                      ),

                      const SizedBox(height: 8),

                      Row(
                        children: [
                          Icon(
                            Icons.groups_outlined,
                            color: controller.selectedEmployees.isNotEmpty
                                ? AppColors.primary
                                : AppColors.hintText,
                          ),

                          const SizedBox(width: 10),

                          Expanded(
                            child: controller.selectedEmployees.isEmpty
                                ? Text(
                                    controller.selectedRole.value == null
                                        ? "Please Select the role"
                                        : "Select employees",
                                    style: TextStyle(
                                      color: AppColors.hintText,
                                      fontSize: 15,
                                    ),
                                  )
                                : Wrap(
                                    spacing: 6,

                                    children: controller.selectedEmployees
                                        .map(
                                          (e) => Chip(
                                            label: Text(
                                              e.fullName ?? "",
                                              style: const TextStyle(
                                                fontSize: 13,
                                              ),
                                            ),
                                            backgroundColor: AppColors.primary
                                                .withOpacity(0.12),
                                            side: BorderSide.none,
                                            deleteIcon: const Icon(
                                              Icons.close,
                                              size: 16,
                                            ),
                                            onDeleted: () {
                                              controller.toggleEmployee(e);
                                            },
                                          ),
                                        )
                                        .toList(),
                                  ),
                          ),

                          const SizedBox(width: 5),

                          // Arrow / count
                          Column(
                            children: [
                              Text(
                                "${controller.selectedEmployees.length}",
                                style: const TextStyle(
                                  color: AppColors.primary,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              const Icon(
                                Icons.keyboard_arrow_down,
                                color: AppColors.textSecondary,
                              ),
                            ],
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ),

            //No of days
            Obx(
              () => CustomTextField(
                controller: controller.daysController.value,
                label: "No Of Days",
                hintText: controller.selectedEmployees.isEmpty
                    ? "Please select employees first"
                    : "Enter number of days",
                readOnly: controller.selectedEmployees.isEmpty,
                prefixIcon: Icons.calendar_month,
                keyboardType: TextInputType.number,
                onChange: (value) {
                  controller.days.value = int.tryParse(value ?? "0") ?? 0;
                  controller.generateTaskController();
                  return null;
                },
              ),
            ),

            //list of days task assign
            Obx(() {
              final days = controller.days.value;

              if (controller.selectedEmployees.isEmpty || days <= 0) {
                return const SizedBox.shrink();
              }
              return Column(
                children: controller.selectedEmployees.map((employee) {
                  return Card(
                    margin: const EdgeInsets.only(bottom: 16),
                    child: Padding(
                      padding: const EdgeInsets.all(12),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            employee.fullName ?? "",
                            style: const TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(height: 10),

                          ...List.generate(days, (index) {
                            return Padding(
                              padding: const EdgeInsets.only(bottom: 10),
                              child: CustomTextField(
                                controller: controller
                                    .taskControllers[employee.userName]![index],
                                label: "Day ${index + 1}",
                                hintText: "Enter project task",
                                prefixIcon: Icons.work,
                              ),
                            );
                          }),
                        ],
                      ),
                    ),
                  );
                }).toList(),
              );
            }),
            SizedBox(
              width: double.infinity,
              height: 55,
              child: ElevatedButton.icon(
                onPressed: controller.submit,
                icon: const Icon(
                  Icons.send_rounded,
                  size: 22,
                  color: Colors.white,
                ),
                label: const Text(
                  "Assign Project",
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    color: Colors.white,
                  ),
                ),
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.primary, // Your theme color
                  foregroundColor: Colors.white,
                  elevation: 5,
                  shadowColor: AppColors.primary.withOpacity(0.4),
                  padding: const EdgeInsets.symmetric(vertical: 15),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(14),
                  ),
                ),
              ),
            ),
            const SizedBox(height: 16),
          ],
        ),
      ),
    );
  }

  //employee
  void showEmployeeBottomSheet(BuildContext context) {
    Get.bottomSheet(
      Container(
        height: Get.height * 0.7,
        padding: const EdgeInsets.all(16),
        decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
        ),
        child: Column(
          children: [
            const Text(
              "Select Employees",
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),

            const SizedBox(height: 15),

            Expanded(
              child: Obx(() {
                final employee = controller.filteredEmployees;
                controller.selectedEmployees.length;

                if (employee.isEmpty) {
                  return Center(child: Text('Employee Not Found'));
                }
                return ListView.builder(
                  itemCount: controller.filteredEmployees.length,
                  itemBuilder: (context, index) {
                    final employee = controller.filteredEmployees[index];

                    final isSelected = controller.selectedEmployees.any(
                      (e) => e.userId == employee.userId,
                    );

                    return Card(
                      color: AppColors.cardBg,
                      child: ListTile(
                        contentPadding: const EdgeInsets.symmetric(
                          horizontal: 12,
                          vertical: 4,
                        ),

                        leading: CircleAvatar(
                          backgroundColor: AppColors.primary.withOpacity(0.15),
                          child: const Icon(
                            Icons.person,
                            color: AppColors.primary,
                          ),
                        ),

                        title: Text(
                          employee.fullName ?? "",
                          style: const TextStyle(
                            fontWeight: FontWeight.w600,
                            color: AppColors.textPrimary,
                          ),
                        ),

                        subtitle: Row(
                          children: [
                            const Icon(
                              Icons.badge_outlined,
                              size: 16,
                              color: AppColors.textSecondary,
                            ),
                            const SizedBox(width: 5),
                            Text(
                              employee.userName ?? "",
                              style: const TextStyle(
                                color: AppColors.textSecondary,
                              ),
                            ),
                          ],
                        ),

                        trailing: Checkbox(
                          activeColor: AppColors.primary,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(5),
                          ),
                          value: isSelected,
                          onChanged: (val) {
                            controller.toggleEmployee(employee);
                          },
                        ),

                        onTap: () {
                          controller.toggleEmployee(employee);
                        },
                      ),
                    );
                  },
                );
              }),
            ),

            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () {
                  Get.back();
                },
                child: const Text("Done"),
              ),
            ),
          ],
        ),
      ),
      isScrollControlled: true,
    );
  }

  //roles
  void showRoleBottomSheet() {
    controller.roleSearchController.clear();
    controller.filteredRoles.assignAll(controller.roleList);
    print(controller.roleList);
    print(controller.filteredRoles);
    Get.bottomSheet(
      Container(
        height: Get.height * 0.72,
        decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
        ),
        child: Column(
          children: [
            const SizedBox(height: 10),

            Container(
              width: 50,
              height: 5,
              decoration: BoxDecoration(
                color: Colors.grey.shade300,
                borderRadius: BorderRadius.circular(20),
              ),
            ),

            const SizedBox(height: 15),

            const Text(
              "Select Project Role",
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),

            const SizedBox(height: 15),

            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: TextField(
                controller: controller.roleSearchController,
                onChanged: controller.filterRoles,
                decoration: InputDecoration(
                  hintText: "Search role...",
                  prefixIcon: const Icon(Icons.search),
                  filled: true,
                  fillColor: Colors.grey.shade100,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(14),
                    borderSide: BorderSide.none,
                  ),
                ),
              ),
            ),

            const SizedBox(height: 12),

            Expanded(
              child: Obx(
                () => ListView.separated(
                  padding: const EdgeInsets.symmetric(horizontal: 10),
                  itemCount: controller.filteredRoles.length,
                  separatorBuilder: (_, __) => const SizedBox(height: 4),
                  itemBuilder: (_, index) {
                    final role = controller.filteredRoles[index];
                    final selected =
                        controller.selectedRole.value?.id == role.id;

                    return Card(
                      elevation: selected ? 2 : 0,
                      color: selected ? Colors.blue.shade50 : Colors.white,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                        side: BorderSide(
                          color: selected ? Colors.blue : Colors.grey.shade200,
                        ),
                      ),
                      child: ListTile(
                        leading: CircleAvatar(
                          backgroundColor: Colors.blue.shade100,
                          child: Text(
                            role.empRoleName![0],
                            style: TextStyle(
                              color: Colors.blue.shade700,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                        title: Text(
                          role.empRoleName ?? "",
                          style: const TextStyle(fontWeight: FontWeight.w600),
                        ),
                        subtitle: Text(role.code ?? ""),
                        trailing: selected
                            ? const Icon(
                                Icons.check_circle,
                                color: Colors.green,
                              )
                            : const Icon(Icons.chevron_right),
                        onTap: () {
                          controller.selectedRole.value = role;
                          controller.filterEmployees(role.code ?? "");
                          Get.back();
                        },
                      ),
                    );
                  },
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
