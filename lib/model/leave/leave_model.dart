class LeaveModel {
  final int? id;
  final String? leaveName;
  final int? noOfDays;
  final int? status;
  final dynamic flag;

  LeaveModel({this.id, this.leaveName, this.noOfDays, this.status, this.flag});

  factory LeaveModel.fromJson(Map<String, dynamic> json) {
    return LeaveModel(
      id: json['id'] ?? 0,
      leaveName: json['leave_name'] ?? '',
      noOfDays: json['no_of_days'] ?? 0,
      status: json['status'] ?? 0,
      flag: json['flag'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'leave_name': leaveName,
      'no_of_days': noOfDays,
      'status': status,
      'flag': flag,
    };
  }
}
