class DepartmentModel {
  final int id;
  final String departmentName;
  final int status;

  DepartmentModel({
    required this.id,
    required this.departmentName,
    required this.status,
  });

  factory DepartmentModel.fromJson(Map<String, dynamic> json) {
    return DepartmentModel(
      id: json['id'] ?? 0,
      departmentName: json['dept_name'] ?? 0,
      status: json['status'] ?? 0,
    );
  }

  Map<String, dynamic> toJson() {
    return {'id': id, 'dept_name': departmentName, 'status': status};
  }
}
