class ProjectModel {
  final String? empname;
  final String? projectId;
  final String? assignerId;
  final String? projectName;
  final String? empRoleName;
  final String? days;
  final String? date;

  ProjectModel({
    required this.empname,
    required this.projectId,
    required this.assignerId,
    required this.projectName,
    required this.empRoleName,
    required this.days,
    required this.date,
  });

  factory ProjectModel.fromJson(Map<String, dynamic> json) {
    return ProjectModel(
      empname: json['emp_name'],
      projectId: json['project_id'].toString(),
      assignerId: json['assigner_id'],
      projectName: json['project_name'],
      empRoleName: json['role_name'],
      days: json['total_days'].toString(),
      date: json['created_at'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'emp_name': empname,
      'project_id': projectId,
      'full_name': assignerId,
      "project_name": projectName,
      "role_name": empRoleName,
      "total_days": days,
      "created_at": date,
    };
  }
}
