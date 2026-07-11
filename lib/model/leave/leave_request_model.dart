class LeaveRequestModel {
  final int? id;
  final int? reportingPerson;
  final int? candidId;
  final String? empCode;
  final String? empName;
  final int? leaveType;
  final String? leaveName;
  final String? reqDate;
  final String? leaveDate;
  final String? fromDate;
  final String? toDate;
  final double? noOfDays;
  final String? leaveReason;
  final String? sickDoc;
  final int? status;
  final int? createdBy;
  final String? createdOn;
  final String? modifiedOn;
  final int? modifiedBy;

  LeaveRequestModel({
    this.id,
    this.reportingPerson,
    this.candidId,
    this.empCode,
    this.empName,
    this.leaveType,
    this.reqDate,
    this.leaveName,
    this.leaveDate,
    this.fromDate,
    this.toDate,
    this.noOfDays,
    this.leaveReason,
    this.sickDoc,
    this.status,
    this.createdBy,
    this.createdOn,
    this.modifiedOn,
    this.modifiedBy,
  });

  /// From JSON
  factory LeaveRequestModel.fromJson(Map<String, dynamic> json) {
    return LeaveRequestModel(
      id: json['id'],
      reportingPerson: json['reporting_person'],
      candidId: json['candid_id'],
      empCode: json['emp_code'],
      empName: json['emp_name'],
      leaveType: json['leave_type'],
      leaveName: json['leave_name'],
      reqDate: json['req_date'],
      leaveDate: json['leave_date'],
      fromDate: json['from_date'],
      toDate: json['to_date'],
      noOfDays: json['no_of_days'] != null
          ? double.tryParse(json['no_of_days'].toString())
          : null,
      leaveReason: json['leave_reason'],
      sickDoc: json['sick_doc'],
      status: json['status'],
      createdBy: json['created_by'],
      createdOn: json['created_on'],
      modifiedOn: json['modified_on'],
      modifiedBy: json['modified_by'],
    );
  }

  /// To JSON (for POST/PUT)
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'reporting_person': reportingPerson,
      'candid_id': candidId,
      'emp_code': empCode,
      'emp_name': empName,
      'leave_type': leaveType,
      'leave_name': leaveName,
      'req_date': reqDate,
      'leave_date': leaveDate,
      'from_date': fromDate,
      'to_date': toDate,
      'no_of_days': noOfDays,
      'leave_reason': leaveReason,
      'sick_doc': sickDoc,
      'status': status,
      'created_by': createdBy,
      'created_on': createdOn,
      'modified_on': modifiedOn,
      'modified_by': modifiedBy,
    };
  }
}
