import 'package:bbvision/controller/project/view_project_controller.dart';
import 'package:bbvision/model/project/project_model.dart';
import 'package:bbvision/screen/project/project_assignment_screen.dart';
import 'package:bbvision/screen/project/single_project_view_screen.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

class ViewProjectsScreen extends StatelessWidget {
  ViewProjectsScreen({super.key});

  final controller = Get.put(ViewProjectController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Projects"),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 12),
            child: TextButton.icon(
              onPressed: () => Get.to(() => ProjectAssignmentScreen()),
              icon: const Icon(
                Icons.assignment_ind_rounded,
                color: Colors.white,
                size: 22,
              ),
              label: const Text(
                "Assign",
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 15,
                  fontWeight: FontWeight.w600,
                ),
              ),
              style: TextButton.styleFrom(
                backgroundColor: Colors.white.withOpacity(0.15),
                padding: const EdgeInsets.symmetric(
                  horizontal: 12,
                  vertical: 8,
                ),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
            ),
          ),
        ],
      ),
      body: Obx(() {
        if (controller.projectList.isEmpty) {
          return const Center(child: Text("No Projects Found"));
        }

        return ListView.builder(
          padding: const EdgeInsets.all(16),
          itemCount: controller.projectList.length,
          itemBuilder: (context, index) {
            final project = controller.projectList[index];

            return _projectCard(project);
          },
        );
      }),
    );
  }

  Widget _projectCard(ProjectModel project) {
    return Card(
      elevation: 6,
      margin: const EdgeInsets.only(bottom: 15),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(18)),
      child: Padding(
        padding: const EdgeInsets.all(18),
        child: Column(
          children: [
            Row(
              children: [
                CircleAvatar(
                  radius: 26,
                  backgroundColor: Colors.orange.shade100,
                  child: const Icon(Icons.folder, color: Colors.orange),
                ),

                const SizedBox(width: 15),

                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        project.projectName ?? "",
                        style: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),

                      const SizedBox(height: 4),

                      Text(
                        project.date != null
                            ? DateFormat(
                                'dd MMM yyyy • hh:mm a',
                              ).format(DateTime.parse(project.date!))
                            : "",
                        style: TextStyle(color: Colors.grey.shade600),
                      ),
                    ],
                  ),
                ),
              ],
            ),

            const Divider(height: 28),

            _item(Icons.person, "Team", project.empRoleName ?? ""),

            const SizedBox(height: 10),

            _item(
              Icons.badge,
              "Assigner",
              "${project.empname}"
                  " - ${project.assignerId}",
            ),

            const SizedBox(height: 10),

            _item(Icons.date_range, "Days", "${project.days}"),

            const SizedBox(height: 15),

            SizedBox(
              width: double.infinity,
              child: ElevatedButton.icon(
                onPressed: () async {
                  await controller.getSingleProjects(
                    project.projectId.toString(),
                  );
                  Get.to(()=>SingleProjectViewScreen(projectModel: project));
                },
                icon: const Icon(Icons.visibility),
                label: const Text("View Details"),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _item(IconData icon, String title, String value) {
    return Row(
      children: [
        Icon(icon, size: 20, color: Colors.orange),

        const SizedBox(width: 10),

        Text("$title : ", style: const TextStyle(fontWeight: FontWeight.w600)),

        Expanded(child: Text(value)),
      ],
    );
  }
}
