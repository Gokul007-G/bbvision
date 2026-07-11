class StaffModel {
  final int id;
  final String empName;
  final String empCode;

  StaffModel({required this.id, required this.empName, required this.empCode});

  factory StaffModel.fromJson(Map<String, dynamic> json) {
    return StaffModel(
      id: json['id'],
      empName: json['emp_name'],
      empCode: json['emp_code'],
    );
  }

  Map<String, dynamic> toJson() {
    return {'id': id, 'emp_name': empName, 'emap_code': empCode};
  }
}
