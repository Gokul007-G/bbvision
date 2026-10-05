import 'package:bbvision/model/chat/get_employee_model.dart';
import 'package:bbvision/controller/chat/get_employee_controller.dart';
import 'package:bbvision/screen/chat/Individual_chat_page.dart';
import 'package:bbvision/widget/appColors.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ChatEmployeePage extends StatelessWidget {
  ChatEmployeePage({super.key});

  final controller = Get.put(GetEmployeeController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.scaffoldBg,

      appBar: AppBar(
        elevation: 0,
        backgroundColor: AppColors.appBar,
        foregroundColor: Colors.white,
        titleSpacing: 16,
        title: Obx(
          () => Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Chats',
                style: TextStyle(fontSize: 21, fontWeight: FontWeight.w700),
              ),
              const SizedBox(height: 2),
              Text(
                '${controller.employeeList.length} employees',
                style: const TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w400,
                  color: Colors.white70,
                ),
              ),
            ],
          ),
        ),
        actions: [
          IconButton(
            onPressed: () {
              _showSearch(context);
            },
            icon: const Icon(Icons.search_rounded),
          ),
          PopupMenuButton<String>(
            icon: const Icon(Icons.more_vert_rounded),
            onSelected: (value) {
              if (value == 'refresh') {
                controller.getEmployeeList();
              }
            },
            itemBuilder: (context) {
              return const [
                PopupMenuItem(
                  value: 'refresh',
                  child: Row(
                    children: [
                      Icon(Icons.refresh_rounded),
                      SizedBox(width: 12),
                      Text('Refresh'),
                    ],
                  ),
                ),
              ];
            },
          ),
        ],
      ),

      body: Obx(() {
        if (controller.isLoading.value) {
          return const Center(
            child: CircularProgressIndicator(color: AppColors.primary),
          );
        }

        if (controller.employeeList.isEmpty) {
          return _buildEmptyState();
        }

        return RefreshIndicator(
          color: AppColors.primary,
          onRefresh: controller.getEmployeeList,
          child: ListView.separated(
            physics: const AlwaysScrollableScrollPhysics(
              parent: BouncingScrollPhysics(),
            ),
            padding: const EdgeInsets.only(top: 8, bottom: 90),
            itemCount: controller.employeeList.length,
            separatorBuilder: (_, __) {
              return const Padding(
                padding: EdgeInsets.only(left: 88),
                child: Divider(height: 1, color: AppColors.divider),
              );
            },
            itemBuilder: (context, index) {
              final employee = controller.employeeList[index];

              return _buildEmployeeTile(context, employee);
            },
          ),
        );
      }),

      floatingActionButton: FloatingActionButton(
        backgroundColor: AppColors.primary,
        foregroundColor: Colors.white,
        elevation: 5,
        onPressed: () {
          controller.getEmployeeList();
        },
        child: const Icon(Icons.group_add_rounded, size: 24),
      ),
    );
  }

  // ---------------------------------------------------------------
  // EMPLOYEE TILE
  // ---------------------------------------------------------------

  Widget _buildEmployeeTile(BuildContext context, GetEmployeeModel employee) {
    final name = _getName(employee);
    final department = _getDepartment(employee);
    final designation = _getDesignation(employee);

    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: () {
          _openChat(employee);
        },
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
          child: Row(
            children: [
              // ---------------------------------------------------
              // AVATAR
              // ---------------------------------------------------
              Stack(
                children: [
                  CircleAvatar(
                    radius: 29,
                    backgroundColor: AppColors.primary.withValues(alpha: 0.12),
                    child: Text(
                      _getInitial(name),
                      style: const TextStyle(
                        color: AppColors.primary,
                        fontSize: 20,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ),

                  // Online indicator
                  Positioned(
                    right: 1,
                    bottom: 1,
                    child: Container(
                      width: 14,
                      height: 14,
                      decoration: BoxDecoration(
                        color: AppColors.success,
                        shape: BoxShape.circle,
                        border: Border.all(
                          color: AppColors.scaffoldBg,
                          width: 2.5,
                        ),
                      ),
                    ),
                  ),
                ],
              ),

              const SizedBox(width: 14),

              // ---------------------------------------------------
              // EMPLOYEE DETAILS
              // ---------------------------------------------------
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Expanded(
                          child: Text(
                            name,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: const TextStyle(
                              color: AppColors.textPrimary,
                              fontSize: 16,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),

                        const SizedBox(width: 8),

                        Text(
                          employee.empCode.isNotEmpty == true
                              ? employee.empCode
                              : '',
                          style: const TextStyle(
                            color: AppColors.textSecondary,
                            fontSize: 11,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ],
                    ),

                    const SizedBox(height: 5),

                    Row(
                      children: [
                        if (department.isNotEmpty)
                          Flexible(
                            child: Text(
                              department,
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: const TextStyle(
                                color: AppColors.textSecondary,
                                fontSize: 13,
                              ),
                            ),
                          ),

                        if (department.isNotEmpty && designation.isNotEmpty)
                          const Padding(
                            padding: EdgeInsets.symmetric(horizontal: 5),
                            child: Text(
                              '•',
                              style: TextStyle(color: AppColors.hintText),
                            ),
                          ),

                        if (designation.isNotEmpty)
                          Flexible(
                            child: Text(
                              designation,
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: const TextStyle(
                                color: AppColors.textSecondary,
                                fontSize: 13,
                              ),
                            ),
                          ),
                      ],
                    ),
                  ],
                ),
              ),

              const SizedBox(width: 8),

              const Icon(
                Icons.chevron_right_rounded,
                color: AppColors.hintText,
                size: 22,
              ),
            ],
          ),
        ),
      ),
    );
  }

  // ---------------------------------------------------------------
  // EMPTY STATE
  // ---------------------------------------------------------------

  Widget _buildEmptyState() {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              width: 82,
              height: 82,
              decoration: BoxDecoration(
                color: AppColors.primary.withValues(alpha: 0.10),
                shape: BoxShape.circle,
              ),
              child: const Icon(
                Icons.chat_bubble_outline_rounded,
                color: AppColors.primary,
                size: 40,
              ),
            ),

            const SizedBox(height: 20),

            const Text(
              'No employees found',
              style: TextStyle(
                color: AppColors.textPrimary,
                fontSize: 18,
                fontWeight: FontWeight.w700,
              ),
            ),

            const SizedBox(height: 8),

            const Text(
              'No employees are currently available for chat.',
              textAlign: TextAlign.center,
              style: TextStyle(color: AppColors.textSecondary, fontSize: 14),
            ),

            const SizedBox(height: 20),

            ElevatedButton.icon(
              onPressed: controller.getEmployeeList,
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.primary,
                foregroundColor: Colors.white,
                elevation: 0,
                padding: const EdgeInsets.symmetric(
                  horizontal: 20,
                  vertical: 12,
                ),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(14),
                ),
              ),
              icon: const Icon(Icons.refresh_rounded),
              label: const Text('Refresh'),
            ),
          ],
        ),
      ),
    );
  }

  // ---------------------------------------------------------------
  // SEARCH
  // ---------------------------------------------------------------

  void _showSearch(BuildContext context) {
    showSearch(
      context: context,
      delegate: EmployeeSearchDelegate(
        employees: controller.employeeList,
        onEmployeeSelected: _openChat,
      ),
    );
  }

  // ---------------------------------------------------------------
  // OPEN CHAT
  // ---------------------------------------------------------------

  void _openChat(GetEmployeeModel employee) {
    Get.to(() => IndividualChatPage(employee: employee));
  }

  // ---------------------------------------------------------------
  // HELPERS
  // ---------------------------------------------------------------

  String _getName(GetEmployeeModel employee) {
    final name = employee.empName.trim();

    if (name.isEmpty) {
      return 'Unknown Employee';
    }

    return name;
  }

  String _getDepartment(GetEmployeeModel employee) {
    return employee.deptName.trim();
  }

  String _getDesignation(GetEmployeeModel employee) {
    return employee.designationName.trim();
  }

  String _getInitial(String name) {
    if (name.isEmpty) {
      return '?';
    }

    return name.substring(0, 1).toUpperCase();
  }
}

// ==================================================================
// SEARCH DELEGATE
// ==================================================================

class EmployeeSearchDelegate extends SearchDelegate<GetEmployeeModel?> {
  final List<GetEmployeeModel> employees;

  final void Function(GetEmployeeModel employee) onEmployeeSelected;

  EmployeeSearchDelegate({
    required this.employees,
    required this.onEmployeeSelected,
  });

  @override
  List<Widget>? buildActions(BuildContext context) {
    return [
      if (query.isNotEmpty)
        IconButton(
          onPressed: () {
            query = '';
          },
          icon: const Icon(Icons.clear_rounded),
        ),
    ];
  }

  @override
  Widget? buildLeading(BuildContext context) {
    return IconButton(
      onPressed: () {
        close(context, null);
      },
      icon: const Icon(Icons.arrow_back_rounded),
    );
  }

  @override
  Widget buildResults(BuildContext context) {
    return _buildResults();
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    return _buildResults();
  }

  Widget _buildResults() {
    final searchText = query.trim().toLowerCase();

    final results = employees.where((employee) {
      final name = employee.empName.toLowerCase();

      final code = employee.empCode.toLowerCase();

      final department = employee.deptName.toLowerCase();

      final designation = employee.designationName.toLowerCase();

      return name.contains(searchText) ||
          code.contains(searchText) ||
          department.contains(searchText) ||
          designation.contains(searchText);
    }).toList();

    if (results.isEmpty) {
      return const Center(
        child: Text(
          'No employees found',
          style: TextStyle(color: AppColors.textSecondary, fontSize: 15),
        ),
      );
    }

    return ListView.separated(
      padding: const EdgeInsets.only(top: 8),
      itemCount: results.length,
      separatorBuilder: (_, __) {
        return const Divider(height: 1, color: AppColors.divider);
      },
      itemBuilder: (context, index) {
        final employee = results[index];

        final name = employee.empName.trim().isNotEmpty == true
            ? employee.empName.trim()
            : 'Unknown Employee';

        return ListTile(
          contentPadding: const EdgeInsets.symmetric(
            horizontal: 16,
            vertical: 5,
          ),
          leading: CircleAvatar(
            radius: 25,
            backgroundColor: AppColors.primary.withValues(alpha: 0.12),
            child: Text(
              name.substring(0, 1).toUpperCase(),
              style: const TextStyle(
                color: AppColors.primary,
                fontWeight: FontWeight.w700,
              ),
            ),
          ),
          title: Text(
            name,
            style: const TextStyle(fontWeight: FontWeight.w600),
          ),
          subtitle: Text(
            employee.deptName,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
          onTap: () {
            close(context, employee);
            onEmployeeSelected(employee);
          },
        );
      },
    );
  }
}
