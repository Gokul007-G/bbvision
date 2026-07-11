class CrmCallModel {
  final int? id;
  final String? clientOrg;
  final String? clientName;
  final DateTime? createdOn;
  final String? contact;
  final String? email;
  final int? status;
  final String? empName;

  CrmCallModel({
    this.id,
    this.clientOrg,
    this.clientName,
    this.createdOn,
    this.contact,
    this.email,
    this.status,
    this.empName,
  });

  factory CrmCallModel.fromJson(Map<String, dynamic> json) {
    return CrmCallModel(
      id: int.tryParse(json['id']?.toString() ?? '0'),
      clientOrg: json['client_org'] ?? '',
      clientName: json['client_name'] ?? '',
      createdOn: _parseDate(json['created_on']),
      contact: json['contact'] ?? '',
      email: json['email'] ?? '',
      status: json['status'] == null
          ? null
          : int.tryParse(json['status'].toString()),
      empName: json['emp_name'] ?? '',
    );
  }

  static DateTime? _parseDate(dynamic date) {
    if (date == null || date.isEmpty || date == '' || date == '0000-00-00') {
      return null;
    }
    return DateTime.parse(date);
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'client_org': clientOrg,
      'client_name': clientName,
      'created_on': createdOn?.toIso8601String(),
      'contact': contact,
      'email': email,
      'status': status,
      'emp_name': empName,
    };
  }
}
