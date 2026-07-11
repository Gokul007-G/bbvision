class StaffModel {
  final int id;
  final int candidateId;
  final int depId;
  final String empNo;
  final String empName;

  StaffModel({
    required this.id,
    required this.candidateId,
    required this.depId,
    required this.empNo,
    required this.empName,
  });

  factory StaffModel.fromJson(Map<String, dynamic> json) {
    return StaffModel(
      id: json['id'] ?? 0,
      candidateId: json['candid_id'] ?? 0,
      depId: int.tryParse(json['dep_id']) ?? 0,
      empNo: json['emp_no'] ?? '',
      empName: json['emp_name'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'candid_id': candidateId,
      'dep_id': depId,
      'emp_no': empNo,
      'emp_name': empName,
    };
  }
}
