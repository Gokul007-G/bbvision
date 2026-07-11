class VisitorModel {
  final String id;
  final DateTime? date;
  final String firstName;
  final String email;
  final String mobile;
  final String comingFrom;
  final String company;
  final String purpose;
  final String department;
  final String employee;
  final String vehicle;
  final String vehicleNo;
  final String remarks;
  final String status;
  final String departmentName;
  final String employeeName;
  final String vehicelName;

  VisitorModel({
    required this.id,
    required this.date,
    required this.firstName,
    required this.email,
    required this.mobile,
    required this.comingFrom,
    required this.company,
    required this.purpose,
    required this.department,
    required this.employee,
    required this.vehicle,
    required this.vehicleNo,
    required this.remarks,
    required this.status,
    required this.departmentName,
    required this.employeeName,
    required this.vehicelName,
  });

  /// ✅ From JSON
  factory VisitorModel.fromJson(Map<String, dynamic> json) {
    return VisitorModel(
      id: json['id']?.toString() ?? '0',
      date: _parseDate(json['Date']),
      firstName:
          (json['first_name'] == null || json['first_name'].toString().isEmpty)
          ? 'General Visitor'
          : json['first_name'].toString(),
      email: json['email']?.toString() ?? '',
      mobile: json['mob_num']?.toString() ?? '',
      comingFrom: json['Coming_from']?.toString() ?? '',
      company: json['companys']?.toString() ?? '',
      purpose: json['Purpose']?.toString() ?? '',
      department: json['Department']?.toString() ?? '',
      employee: json['employee']?.toString() ?? '',
      vehicle: json['vehicle']?.toString() ?? '',
      vehicleNo: json['veh_no']?.toString() ?? '',
      remarks: json['Remarks']?.toString() ?? '',
      status: json['status']?.toString() ?? '0',
      departmentName: json['department_name']?.toString() ?? '',
      employeeName: json['employee_name']?.toString() ?? '',
      vehicelName: json['vehicle_name']?.toString() ?? '',
    );
  }

  /// ✅ To JSON (if needed)
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'Date': date?.toIso8601String().split('T').first,
      'first_name': firstName,
      'email': email,
      'mob_num': mobile,
      'Coming_from': comingFrom,
      'companys': company,
      'Purpose': purpose,
      'Department': department,
      'employee': employee,
      'vehicle': vehicle,
      'veh_no': vehicleNo,
      'Remarks': remarks,
      'status': status,
      'department_name': departmentName,
      'employee_name': employeeName,
      'vehicle_name': vehicelName,
    };
  }

  static DateTime? _parseDate(dynamic value) {
    if (value == null || value == '' || value == '0000-00-00') {
      return null;
    }
    return DateTime.tryParse(value.toString());
  }
}
