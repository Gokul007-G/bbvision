import 'package:bbvision/controller/project/view_project_emp_controller.dart';
import 'package:bbvision/model/project/project_model_emp.dart';
import 'package:bbvision/widget/appColors.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ViewProjectEmpScreen extends StatelessWidget {
  ViewProjectEmpScreen({super.key});

  final controller = Get.put(ViewProjectEmpController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF6F7FB),
      appBar: AppBar(
        elevation: 0,
        leading: IconButton(
          onPressed: () => Get.back(),
          icon: Icon(Icons.arrow_back, color: AppColors.textPrimary),
        ),
        backgroundColor: Colors.white,
        surfaceTintColor: Colors.white,
        title: const Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "My Projects",
              style: TextStyle(
                color: Color(0xFF1A1D29),
                fontSize: 21,
                fontWeight: FontWeight.w700,
              ),
            ),
            SizedBox(height: 2),
            Text(
              "Track your assigned tasks",
              style: TextStyle(
                color: Color(0xFF8A8F9C),
                fontSize: 12,
                fontWeight: FontWeight.w400,
              ),
            ),
          ],
        ),
        actions: [
          IconButton(
            onPressed: controller.getProjectCnt,
            icon: const Icon(Icons.refresh_rounded, color: Color(0xFF5B61F4)),
          ),
          const SizedBox(width: 8),
        ],
      ),
      body: Obx(() {
        final projects = controller.projectList;

        if (projects.isEmpty) {
          return _emptyState();
        }

        final groupedProjects = _groupProjects(projects);

        return RefreshIndicator(
          color: const Color(0xFF5B61F4),
          onRefresh: controller.getProjectCnt,
          child: ListView(
            physics: const AlwaysScrollableScrollPhysics(),
            padding: const EdgeInsets.fromLTRB(16, 18, 16, 30),
            children: [
              _summaryCard(groupedProjects),

              const SizedBox(height: 22),

              Row(
                children: [
                  const Text(
                    "Assigned Projects",
                    style: TextStyle(
                      fontSize: 17,
                      fontWeight: FontWeight.w700,
                      color: Color(0xFF1A1D29),
                    ),
                  ),
                  const Spacer(),
                  Text(
                    "${groupedProjects.length} Projects",
                    style: const TextStyle(
                      color: Color(0xFF8A8F9C),
                      fontSize: 12,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 12),

              ...groupedProjects.values.map(
                (projectTasks) => _projectCard(projectTasks),
              ),
            ],
          ),
        );
      }),
    );
  }

  Map<int, List<ProjectModelEmp>> _groupProjects(
    List<ProjectModelEmp?> projects,
  ) {
    final Map<int, List<ProjectModelEmp>> grouped = {};

    for (final project in projects) {
      if (project == null) continue;

      grouped.putIfAbsent(project.projectId, () => []);
      grouped[project.projectId]!.add(project);
    }

    return grouped;
  }

  Widget _summaryCard(Map<int, List<ProjectModelEmp>> groupedProjects) {
    int totalTasks = 0;
    int completedTasks = 0;

    for (final tasks in groupedProjects.values) {
      totalTasks += tasks.length;

      completedTasks += tasks.where((task) => task.status == 1).length;
    }

    final progress = totalTasks == 0 ? 0.0 : completedTasks / totalTasks;

    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [Color(0xFF5B61F4), Color(0xFF7479F7)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(22),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFF5B61F4).withOpacity(.20),
            blurRadius: 18,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(.18),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: const Icon(
                  Icons.dashboard_rounded,
                  color: Colors.white,
                  size: 22,
                ),
              ),
              const SizedBox(width: 12),
              const Text(
                "My Work Overview",
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 16,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ],
          ),

          const SizedBox(height: 22),

          Row(
            children: [
              _summaryItem(
                value: "${groupedProjects.length}",
                label: "Projects",
              ),
              _verticalDivider(),
              _summaryItem(value: "$totalTasks", label: "Tasks"),
              _verticalDivider(),
              _summaryItem(value: "$completedTasks", label: "Completed"),
            ],
          ),

          const SizedBox(height: 20),

          Row(
            children: [
              const Text(
                "Overall progress",
                style: TextStyle(color: Colors.white70, fontSize: 12),
              ),
              const Spacer(),
              Text(
                "${(progress * 100).round()}%",
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 13,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ],
          ),

          const SizedBox(height: 8),

          ClipRRect(
            borderRadius: BorderRadius.circular(10),
            child: LinearProgressIndicator(
              value: progress,
              minHeight: 7,
              backgroundColor: Colors.white.withOpacity(.20),
              valueColor: const AlwaysStoppedAnimation<Color>(Colors.white),
            ),
          ),
        ],
      ),
    );
  }

  Widget _summaryItem({required String value, required String label}) {
    return Expanded(
      child: Column(
        children: [
          Text(
            value,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 22,
              fontWeight: FontWeight.w800,
            ),
          ),
          const SizedBox(height: 3),
          Text(
            label,
            style: const TextStyle(color: Colors.white70, fontSize: 11),
          ),
        ],
      ),
    );
  }

  Widget _verticalDivider() {
    return Container(
      height: 35,
      width: 1,
      color: Colors.white.withOpacity(.20),
    );
  }

  Widget _projectCard(List<ProjectModelEmp> tasks) {
    if (tasks.isEmpty) {
      return const SizedBox();
    }

    final first = tasks.first;

    final completed = tasks.where((task) => task.status == 1).length;

    final total = tasks.length;

    final progress = total == 0 ? 0.0 : completed / total;

    tasks.sort((a, b) => a.dayNumber.compareTo(b.dayNumber));

    final isCompleted = completed == total;

    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: const Color(0xFFE9EAF0)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.035),
            blurRadius: 12,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        borderRadius: BorderRadius.circular(20),
        clipBehavior: Clip.antiAlias,
        child: Theme(
          data: Theme.of(Get.context!).copyWith(
            dividerColor: Colors.transparent,
            splashColor: const Color(0xFFEEF0FF),
            highlightColor: const Color(0xFFF6F7FF),
          ),
          child: ExpansionTile(
            backgroundColor: Colors.white,
            collapsedBackgroundColor: Colors.white,

            tilePadding: const EdgeInsets.fromLTRB(16, 12, 16, 12),

            childrenPadding: const EdgeInsets.fromLTRB(16, 0, 16, 16),

            iconColor: const Color(0xFF5B61F4),
            collapsedIconColor: const Color(0xFF8A8F9C),

            title: Row(
              children: [
                Container(
                  width: 48,
                  height: 48,
                  decoration: BoxDecoration(
                    color: const Color(0xFFEEF0FF),
                    borderRadius: BorderRadius.circular(14),
                  ),
                  child: const Icon(
                    Icons.folder_copy_rounded,
                    color: Color(0xFF5B61F4),
                    size: 24,
                  ),
                ),

                const SizedBox(width: 12),

                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        first.projectName,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w700,
                          color: Color(0xFF1A1D29),
                        ),
                      ),

                      const SizedBox(height: 4),

                      Row(
                        children: [
                          const Icon(
                            Icons.work_outline_rounded,
                            size: 13,
                            color: Color(0xFF8A8F9C),
                          ),
                          const SizedBox(width: 4),
                          Text(
                            first.roleName,
                            style: const TextStyle(
                              fontSize: 12,
                              color: Color(0xFF8A8F9C),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),

                const SizedBox(width: 8),

                _statusBadge(isCompleted),
              ],
            ),

            subtitle: Padding(
              padding: const EdgeInsets.only(left: 60, top: 12),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Text(
                        "$completed/$total tasks completed",
                        style: const TextStyle(
                          color: Color(0xFF666B78),
                          fontSize: 11,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      const Spacer(),
                      Text(
                        "${(progress * 100).round()}%",
                        style: const TextStyle(
                          color: Color(0xFF5B61F4),
                          fontSize: 11,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: 7),

                  ClipRRect(
                    borderRadius: BorderRadius.circular(10),
                    child: LinearProgressIndicator(
                      value: progress,
                      minHeight: 5,
                      backgroundColor: const Color(0xFFEDEEF3),
                      valueColor: const AlwaysStoppedAnimation<Color>(
                        Color(0xFF5B61F4),
                      ),
                    ),
                  ),
                ],
              ),
            ),

            children: tasks.map(_taskTile).toList(),
          ),
        ),
      ),
    );
  }

  Widget _taskTile(ProjectModelEmp task) {
    final isCompleted = task.status == 1;
    final user = controller.user.value;
    var groupCode = "";
    if (user != null) {
      groupCode = user.userGroupCode;
    }
    return GestureDetector(
      onTap: isCompleted
          ? null
          : (groupCode == "R003" || groupCode == "")
          ? null
          : () {
              Get.dialog(
                AlertDialog(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20),
                  ),
                  title: const Text(
                    "Complete Task",
                    style: TextStyle(fontSize: 19, fontWeight: FontWeight.w700),
                  ),
                  content: const Text(
                    "Have you completed this task?",
                    style: TextStyle(fontSize: 14, color: Color(0xFF666B78)),
                  ),
                  actions: [
                    TextButton(
                      onPressed: () {
                        Get.back();
                      },
                      child: const Text(
                        "No",
                        style: TextStyle(
                          color: Color(0xFF777C89),
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                    ElevatedButton(
                      onPressed: () {
                        Get.back();
                        // TODO: Call API to update task status
                        controller.updateStatusCnt(task.taskId);
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF5B61F4),
                        foregroundColor: Colors.white,
                        elevation: 0,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                      child: const Text(
                        "Yes, Completed",
                        style: TextStyle(fontWeight: FontWeight.w600),
                      ),
                    ),
                  ],
                ),
              );
            },
      child: Container(
        margin: const EdgeInsets.only(top: 8),
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
          color: isCompleted
              ? const Color(0xFFF3FBF6)
              : const Color(0xFFF8F9FC),
          borderRadius: BorderRadius.circular(14),
          border: Border.all(
            color: isCompleted
                ? const Color(0xFFD7F0DE)
                : const Color(0xFFEDEEF2),
          ),
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              width: 38,
              height: 38,
              decoration: BoxDecoration(
                color: isCompleted
                    ? const Color(0xFFDDF5E4)
                    : const Color(0xFFEDEEFF),
                shape: BoxShape.circle,
              ),
              child: Center(
                child: isCompleted
                    ? const Icon(
                        Icons.check_rounded,
                        color: Color(0xFF25A55F),
                        size: 21,
                      )
                    : Text(
                        "${task.dayNumber}",
                        style: const TextStyle(
                          color: Color(0xFF5B61F4),
                          fontSize: 13,
                          fontWeight: FontWeight.w800,
                        ),
                      ),
              ),
            ),

            const SizedBox(width: 12),

            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Text(
                        "Day ${task.dayNumber}",
                        style: TextStyle(
                          fontSize: 11,
                          fontWeight: FontWeight.w600,
                          color: isCompleted
                              ? const Color(0xFF25A55F)
                              : const Color(0xFF777C89),
                        ),
                      ),
                      const SizedBox(width: 8),
                      _smallStatus(isCompleted),
                    ],
                  ),

                  const SizedBox(height: 6),

                  Text(
                    task.task,
                    style: TextStyle(
                      fontSize: 14,
                      height: 1.35,
                      fontWeight: FontWeight.w600,
                      color: isCompleted
                          ? const Color(0xFF477055)
                          : const Color(0xFF292D39),
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(width: 8),

            Icon(
              Icons.chevron_right_rounded,
              size: 20,
              color: isCompleted
                  ? const Color(0xFF9AC9A9)
                  : const Color(0xFFB4B7C1),
            ),
          ],
        ),
      ),
    );
  }

  Widget _statusBadge(bool completed) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 9, vertical: 5),
      decoration: BoxDecoration(
        color: completed ? const Color(0xFFE7F8ED) : const Color(0xFFFFF4E5),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Text(
        completed ? "Completed" : "In Progress",
        style: TextStyle(
          color: completed ? const Color(0xFF249957) : const Color(0xFFE38A18),
          fontSize: 9,
          fontWeight: FontWeight.w700,
        ),
      ),
    );
  }

  Widget _smallStatus(bool completed) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 7, vertical: 3),
      decoration: BoxDecoration(
        color: completed ? const Color(0xFFE7F8ED) : const Color(0xFFFFF1DE),
        borderRadius: BorderRadius.circular(10),
      ),
      child: Text(
        completed ? "Done" : "Pending",
        style: TextStyle(
          color: completed ? const Color(0xFF249957) : const Color(0xFFE38A18),
          fontSize: 8,
          fontWeight: FontWeight.w700,
        ),
      ),
    );
  }

  Widget _emptyState() {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(30),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              width: 90,
              height: 90,
              decoration: BoxDecoration(
                color: const Color(0xFFEEF0FF),
                shape: BoxShape.circle,
              ),
              child: const Icon(
                Icons.assignment_outlined,
                size: 42,
                color: Color(0xFF5B61F4),
              ),
            ),

            const SizedBox(height: 20),

            const Text(
              "No Projects Assigned",
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w700,
                color: Color(0xFF1A1D29),
              ),
            ),

            const SizedBox(height: 8),

            const Text(
              "Your assigned projects and tasks\nwill appear here.",
              textAlign: TextAlign.center,
              style: TextStyle(
                height: 1.5,
                fontSize: 13,
                color: Color(0xFF8A8F9C),
              ),
            ),

            const SizedBox(height: 20),

            OutlinedButton.icon(
              onPressed: controller.getProjectCnt,
              icon: const Icon(Icons.refresh_rounded),
              label: const Text("Refresh"),
            ),
          ],
        ),
      ),
    );
  }
}
