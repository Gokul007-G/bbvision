class GetEmployeeModel {
  final String candidateId;
  final String empCode;
  final String empName;
  final String divName;
  final String deptName;
  final String designationName;
  final String depId;
  final String divId;

  GetEmployeeModel({
    required this.candidateId,
    required this.empCode,
    required this.empName,
    required this.divName,
    required this.deptName,
    required this.designationName,
    required this.depId,
    required this.divId,
  });

  factory GetEmployeeModel.fromJson(Map<String, dynamic> json) {
    return GetEmployeeModel(
      candidateId: json['candid_id'].toString(),
      empCode: json['emp_code'].toString(),
      empName: json['emp_name'].toString(),
      divName: json['div_name'].toString(),
      deptName: json['dept_name'].toString(),
      designationName: json['designation_name'].toString(),
      depId: json['dep_id'].toString(),
      divId: json['div_id'].toString(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      "candid_id": candidateId,
      "emp_code": empCode,
      "emp_name": empName,
      "div_name": divName,
      "dept_name": deptName,
      "designation_name": designationName,
    };
  }
}
