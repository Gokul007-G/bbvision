import 'package:bbvision/controller/project/view_project_controller.dart';
import 'package:bbvision/model/project/project_model.dart';
import 'package:bbvision/widget/appColors.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class SingleProjectViewScreen extends StatelessWidget {
  final ProjectModel projectModel;

  SingleProjectViewScreen({super.key, required this.projectModel});

  final controller = Get.put(ViewProjectController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.cardBg,
      appBar: AppBar(
        elevation: 0,
        backgroundColor: AppColors.cardBg,
        foregroundColor: AppColors.textPrimary,
        title: const Text(
          "Project Details",
          style: TextStyle(fontWeight: FontWeight.w700, fontSize: 20),
        ),
      ),
      body: Obx(() {
        final tasks = controller.singleProjectList;

        if (tasks.isEmpty) {
          return const Center(
            child: Text(
              "No task details available",
              style: TextStyle(color: AppColors.textSecondary, fontSize: 15),
            ),
          );
        }

        // Group tasks by employee
        final Map<String, List<dynamic>> employeeGroups = {};

        for (final task in tasks) {
          employeeGroups.putIfAbsent(task.employeeId, () => []);
          employeeGroups[task.employeeId]!.add(task);
          print(task.employeeId);
        }

        return SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _projectHeader(),

              const SizedBox(height: 16),

              _summaryCard(
                employeeCount: employeeGroups.length,
                taskCount: tasks.length,
              ),

              const SizedBox(height: 24),

              const Text(
                "Team Tasks",
                style: TextStyle(
                  fontSize: 19,
                  fontWeight: FontWeight.w700,
                  color: AppColors.textPrimary,
                ),
              ),

              const SizedBox(height: 12),

              ...employeeGroups.entries.map(
                (entry) =>
                    _employeeSection(employeeId: entry.key, tasks: entry.value),
              ),

              const SizedBox(height: 20),
            ],
          ),
        );
      }),
    );
  }

  // ----------------------------------------------------------
  // PROJECT HEADER
  // ----------------------------------------------------------

  Widget _projectHeader() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [AppColors.buttonPrimary, AppColors.primary],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(22),
        boxShadow: [
          BoxShadow(
            color: AppColors.primary.withOpacity(0.3),
            blurRadius: 15,
            offset: const Offset(0, 7),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(11),
                decoration: BoxDecoration(
                  color: AppColors.cardBg.withOpacity(0.20),
                  borderRadius: BorderRadius.circular(13),
                ),
                child: const Icon(
                  Icons.folder_rounded,
                  color: AppColors.cardBg,
                  size: 25,
                ),
              ),

              const SizedBox(width: 12),

              const Expanded(
                child: Text(
                  "Project",
                  style: TextStyle(color: Colors.white70, fontSize: 13),
                ),
              ),

              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 12,
                  vertical: 6,
                ),
                decoration: BoxDecoration(
                  color: AppColors.cardBg.withOpacity(0.18),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Text(
                  "#${projectModel.projectId ?? '-'}",
                  style: const TextStyle(
                    color: AppColors.cardBg,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
            ],
          ),

          const SizedBox(height: 18),

          Text(
            projectModel.projectName ?? "Unnamed Project",
            style: const TextStyle(
              color: AppColors.cardBg,
              fontSize: 24,
              fontWeight: FontWeight.w800,
            ),
          ),

          const SizedBox(height: 14),

          Row(
            children: [
              _headerInfo(
                Icons.person_outline,
                projectModel.empname ?? "Unknown",
              ),
              const SizedBox(width: 18),
              _headerInfo(
                Icons.work_outline,
                projectModel.empRoleName ?? "No Role",
              ),
            ],
          ),

          const SizedBox(height: 12),

          Row(
            children: [
              _headerInfo(
                Icons.calendar_today_outlined,
                "${projectModel.days ?? 0} Days",
              ),
              const SizedBox(width: 18),
              _headerInfo(
                Icons.access_time_rounded,
                _formatDate(projectModel.date),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _headerInfo(IconData icon, String text) {
    return Expanded(
      child: Row(
        children: [
          Icon(icon, color: AppColors.cardBg, size: 17),
          const SizedBox(width: 6),
          Expanded(
            child: Text(
              text,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: const TextStyle(
                color: AppColors.cardBg,
                fontSize: 13,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
        ],
      ),
    );
  }

  // ----------------------------------------------------------
  // SUMMARY
  // ----------------------------------------------------------

  Widget _summaryCard({required int employeeCount, required int taskCount}) {
    final completedCount = controller.singleProjectList
        .where((task) => task.status == 1)
        .length;

    return Container(
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: AppColors.cardBg,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: const Color(0xFFE5E7EB)),
      ),
      child: Row(
        children: [
          Expanded(
            child: _summaryItem(
              icon: Icons.groups_rounded,
              value: employeeCount.toString(),
              label: "Employees",
            ),
          ),

          _verticalDivider(),

          Expanded(
            child: _summaryItem(
              icon: Icons.task_alt_rounded,
              value: taskCount.toString(),
              label: "Total Tasks",
            ),
          ),

          _verticalDivider(),

          Expanded(
            child: _summaryItem(
              icon: Icons.check_circle_outline_rounded,
              value: completedCount.toString(),
              label: "Completed",
            ),
          ),
        ],
      ),
    );
  }

  Widget _summaryItem({
    required IconData icon,
    required String value,
    required String label,
  }) {
    return Column(
      children: [
        Icon(icon, size: 22, color: AppColors.primary),
        const SizedBox(height: 7),
        Text(
          value,
          style: const TextStyle(
            fontSize: 21,
            fontWeight: FontWeight.w800,
            color: AppColors.textPrimary,
          ),
        ),
        const SizedBox(height: 3),
        Text(
          label,
          textAlign: TextAlign.center,
          style: const TextStyle(fontSize: 11, color: AppColors.textSecondary),
        ),
      ],
    );
  }

  Widget _verticalDivider() {
    return Container(height: 50, width: 1, color: AppColors.cardBg);
  }

  // ----------------------------------------------------------
  // EMPLOYEE SECTION
  // ----------------------------------------------------------

  Widget _employeeSection({
    required String employeeId,
    required List<dynamic> tasks,
  }) {
    final employeeName = tasks.isNotEmpty
        ? tasks.first.empName
        : "Unknown Employee";

    final completed = tasks.where((task) => task.status == 1).length;

    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      decoration: BoxDecoration(
        color: AppColors.cardBg,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: AppColors.border),
      ),
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16),
            child: Row(
              children: [
                Container(
                  height: 46,
                  width: 46,
                  decoration: BoxDecoration(
                    color: AppColors.primary.withOpacity(0.12),
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(
                    Icons.person_rounded,
                    color: AppColors.primary,
                  ),
                ),

                const SizedBox(width: 12),

                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        employeeName,
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w700,
                          color: Color(0xFF111827),
                        ),
                      ),

                      const SizedBox(height: 4),

                      Text(
                        employeeId,
                        style: const TextStyle(
                          fontSize: 12,
                          color: AppColors.textSecondary,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ],
                  ),
                ),

                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 10,
                    vertical: 6,
                  ),
                  decoration: BoxDecoration(
                    color: completed == tasks.length
                        ? const Color(0xFFE8F7EE)
                        : const Color(0xFFFFF4E8),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Text(
                    "$completed/${tasks.length}",
                    style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w700,
                      color: completed == tasks.length
                          ? const Color(0xFF16834A)
                          : AppColors.primary,
                    ),
                  ),
                ),
              ],
            ),
          ),

          const Divider(height: 1, color: Color(0xFFE5E7EB)),

          Padding(
            padding: const EdgeInsets.all(12),
            child: Column(children: [...tasks.map((task) => _taskCard(task))]),
          ),
        ],
      ),
    );
  }

  // ----------------------------------------------------------
  // TASK CARD
  // ----------------------------------------------------------

  Widget _taskCard(dynamic task) {
    final bool isCompleted = task.status == 1;

    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: const Color(0xFFF9FAFB),
        borderRadius: BorderRadius.circular(15),
        border: Border.all(color: const Color(0xFFE5E7EB)),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            height: 42,
            width: 42,
            decoration: BoxDecoration(
              color: isCompleted
                  ? const Color(0xFFE8F7EE)
                  : const Color(0xFFFFF1E8),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(
              isCompleted ? Icons.check_rounded : Icons.assignment_outlined,
              color: isCompleted
                  ? const Color(0xFF16834A)
                  : const Color(0xFFFF7A3D),
              size: 22,
            ),
          ),

          const SizedBox(width: 12),

          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 8,
                        vertical: 4,
                      ),
                      decoration: BoxDecoration(
                        color: const Color(0xFFEFF3FF),
                        borderRadius: BorderRadius.circular(7),
                      ),
                      child: Text(
                        "DAY ${task.dayNumber}",
                        style: const TextStyle(
                          fontSize: 10,
                          fontWeight: FontWeight.w800,
                          color: AppColors.blue,
                        ),
                      ),
                    ),

                    const Spacer(),

                    _statusBadge(isCompleted),
                  ],
                ),

                const SizedBox(height: 10),

                Text(
                  task.task,
                  style: const TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.w700,
                    color: Color(0xFF1F2937),
                  ),
                ),

                const SizedBox(height: 6),

                Text(
                  "Task ID: #${task.taskId}",
                  style: const TextStyle(
                    fontSize: 11,
                    color: AppColors.textSecondary,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _statusBadge(bool completed) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 9, vertical: 5),
      decoration: BoxDecoration(
        color: completed ? const Color(0xFFE8F7EE) : const Color(0xFFFFF4E8),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Text(
        completed ? "Completed" : "Pending",
        style: TextStyle(
          fontSize: 10,
          fontWeight: FontWeight.w700,
          color: completed ? const Color(0xFF16834A) : AppColors.primary,
        ),
      ),
    );
  }

  String _formatDate(String? date) {
    if (date == null || date.isEmpty) {
      return "No Date";
    }

    if (date.length >= 10) {
      return date.substring(0, 10);
    }

    return date;
  }
}
