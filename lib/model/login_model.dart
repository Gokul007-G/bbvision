class LoginModel {
  final String status;
  final LoginData? data;

  LoginModel({required this.status, this.data});

  factory LoginModel.fromJson(Map<String, dynamic> json) {
    return LoginModel(
      status: json['status']?.toString().trim().toLowerCase() ?? '',
      data: json['data'] != null && json['data'] is Map<String, dynamic>
          ? LoginData.fromJson(json['data'])
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {'status': status, 'data': data?.toJson()};
  }
}

class LoginData {
  final String assEmpId;
  final int candidateId;
  final int userId;
  final String department;
  final String userName;
  final String fullName;
  final String userGroupCode;
  final String? profile;
  final int? consultantId;
  final String email;
  final String departmentName;
  final String mobileNo;
  final String gender;

  LoginData({
    required this.assEmpId,
    required this.candidateId,
    required this.userId,
    required this.department,
    required this.userName,
    required this.fullName,
    required this.userGroupCode,
    this.profile,
    this.consultantId,
    required this.email,
    required this.departmentName,
    required this.mobileNo,
    required this.gender,
  });

  factory LoginData.fromJson(Map<String, dynamic> json) {
    return LoginData(
      assEmpId: json['ass_emp_id']?.toString() ?? '',
      candidateId: int.tryParse(json['candidate_id']?.toString() ?? '0') ?? 0,
      userId: int.tryParse(json['user_id']?.toString() ?? '0') ?? 0,
      department: json['department']?.toString() ?? '',
      userName: json['user_name']?.toString() ?? '',
      fullName: json['full_name']?.toString() ?? '',
      userGroupCode: json['user_group_code']?.toString() ?? '',
      profile: json['profile'] == null || json['profile'] == "NULL"
          ? null
          : json['profile'].toString(),
      consultantId: json['consultant_id'] == null
          ? null
          : int.tryParse(json['consultant_id'].toString()),
      email: json['email_id']?.toString() ?? '',
      departmentName: json['dept_name']?.toString() ?? '',
      mobileNo: json['mobile_no']?.toString() ?? '',
      gender: json['gender']?.toString() ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'ass_emp_id': assEmpId,
      'candidate_id': candidateId,
      'user_id': userId,
      'department': department,
      'user_name': userName,
      'full_name': fullName,
      'user_group_code': userGroupCode,
      'profile': profile,
      'consultant_id': consultantId,
      'email_id': email,
      'dept_name': departmentName,
      'mobile_no': mobileNo,
      'gender': gender,
    };
  }
}
