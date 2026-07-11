class DepartmentModel {
  final int id;
  final String deptName;
  final int status;

  DepartmentModel({
    required this.id,
    required this.deptName,
    required this.status,
  });

  factory DepartmentModel.fromJson(Map<String, dynamic> json) {
    return DepartmentModel(
      id: int.parse(json['id'].toString()),
      deptName: json['dept_name'] ?? '',
      status: int.parse(json['status'].toString()),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'dept_name': deptName,
      'status': status,
    };
  }
}
