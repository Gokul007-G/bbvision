import 'package:bbvision/screen/project/project_assignment_screen.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ViewProjects extends StatelessWidget {
  const ViewProjects({super.key});

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
      body: SingleChildScrollView(padding: const EdgeInsets.all(16),),
    );
  }
}
