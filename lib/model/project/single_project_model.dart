class SingleProjectModel {
  final String empName;
  final int taskId;
  final int projectId;
  final String employeeId;
  final int dayNumber;
  final String task;
  final int status;

  SingleProjectModel({
    required this.empName,
    required this.taskId,
    required this.projectId,
    required this.employeeId,
    required this.dayNumber,
    required this.task,
    required this.status,
  });

  factory SingleProjectModel.fromJson(Map<String, dynamic> json) {
    return SingleProjectModel(
      empName: json['emp_name'] ?? '',
      taskId: json['task_id'] ?? 0,
      projectId: json['project_id'] ?? 0,
      employeeId: json['employee_id'] ?? '',
      dayNumber: json['day_number'] ?? 0,
      task: json['task'] ?? '',
      status: json['status'] ?? 0,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'emp_name': empName,
      'task_id': taskId,
      'project_id': projectId,
      'employee_id': employeeId,
      'day_number': dayNumber,
      'task': task,
      'status': status,
    };
  }
}