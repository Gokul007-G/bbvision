class ClaimRequestModel {
  final int id;
  final int candidateId;
  final String customerName;
  final int travelTypeId;
  final String location;
  final String kms;
  final String date;
  final String purpose;
  final String amount;
  final String file;
  final String? remark;
  final int status;
  final String? createdBy;
  final String createdOn;
  final String? modifiedBy;
  final String? modifiedOn;
  final String travelType;
  final String userGroupCode;
  final String fullName;
  final String empCode;

  ClaimRequestModel({
    required this.id,
    required this.candidateId,
    required this.customerName,
    required this.travelTypeId,
    required this.location,
    required this.kms,
    required this.date,
    required this.purpose,
    required this.amount,
    required this.file,
    this.remark,
    required this.status,
    this.createdBy,
    required this.createdOn,
    this.modifiedBy,
    this.modifiedOn,
    required this.travelType,
    required this.userGroupCode,
    required this.fullName,
    required this.empCode,
  });

  factory ClaimRequestModel.fromJson(Map<String, dynamic> json) {
    return ClaimRequestModel(
      id: json['id'],
      candidateId: int.parse(json['candidate_id'].toString()),
      customerName: json['customer_name'] ?? '',
      travelTypeId: json['travel_type'],
      location: json['location'] ?? '',
      kms: json['kms'] ?? '',
      date: json['date'] ?? '',
      purpose: json['purpose'] ?? '',
      amount: json['amount'] ?? '',
      file: json['file'] ?? '',
      remark: json['remark'],
      status: json['status'],
      createdBy: json['created_by'],
      createdOn: json['created_on'],
      modifiedBy: json['modified_by'],
      modifiedOn: json['modified_on'],
      travelType: json['travel_name'] ?? '',
      fullName: json['full_name'] ?? '',
      userGroupCode: json['user_group_code'] ?? '',
      empCode: json['emp_code'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'candidate_id': candidateId,
      'customer_name': customerName,
      'travel_type': travelTypeId,
      'location': location,
      'kms': kms,
      'date': date,
      'purpose': purpose,
      'amount': amount,
      'file': file,
      'remark': remark,
      'status': status,
      'created_by': createdBy,
      'created_on': createdOn,
      'modified_by': modifiedBy,
      'modified_on': modifiedOn,
      'travel_name': travelType,
      'user_group_code': userGroupCode,
      'full_name': fullName,
      'emp_code': empCode,
    };
  }
}
