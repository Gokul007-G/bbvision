class ProjectModelEmp {
  final int taskId;
  final int projectId;
  final String employeeId;
  final int dayNumber;
  final String task;
  final int status;
  final String assignerId;
  final String projectName;
  final String roleName;
  final int totalDays;
  final String createdAt;

  ProjectModelEmp({
    required this.taskId,
    required this.projectId,
    required this.employeeId,
    required this.dayNumber,
    required this.task,
    required this.status,
    required this.assignerId,
    required this.projectName,
    required this.roleName,
    required this.totalDays,
    required this.createdAt,
  });

  factory ProjectModelEmp.fromJson(Map<String, dynamic> json) {
    return ProjectModelEmp(
      taskId: int.tryParse(json['task_id'].toString()) ?? 0,
      projectId: int.tryParse(json['project_id'].toString()) ?? 0,
      employeeId: json['employee_id']?.toString() ?? '',
      dayNumber: int.tryParse(json['day_number'].toString()) ?? 0,
      task: json['task']?.toString() ?? '',
      status: int.tryParse(json['status'].toString()) ?? 0,
      assignerId: json['assigner_id']?.toString() ?? '',
      projectName: json['project_name']?.toString() ?? '',
      roleName: json['role_name']?.toString() ?? '',
      totalDays: int.tryParse(json['total_days'].toString()) ?? 0,
      createdAt: json['created_at']?.toString() ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'task_id': taskId,
      'project_id': projectId,
      'employee_id': employeeId,
      'day_number': dayNumber,
      'task': task,
      'status': status,
      'assigner_id': assignerId,
      'project_name': projectName,
      'role_name': roleName,
      'total_days': totalDays,
      'created_at': createdAt,
    };
  }
}