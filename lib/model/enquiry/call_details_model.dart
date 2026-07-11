// class CallDetailsModel {
//   final String? custType;
//   final int? callType;
//   final int? clientType;
//   final String? clientOrg;
//   final String? clientName;
//   final String? contact;
//   final String? whatsapp;
//   final String? email;
//   final String? alternativeMail;
//   final String? website;
//   final String? address;
//   final String? product;
//   final String? services;
//   final String? remarks;
//   final String? image;
//   final String? feedback;
//   final String? feedbackDate;
//   final String? followUpDate;
//   final String? fullName;
//   final int? userId;
//   final String? department;
//   final String? name;
//   final String? productName;

//   CallDetailsModel({
//     this.custType,
//     this.callType,
//     this.clientType,
//     this.clientOrg,
//     this.clientName,
//     this.contact,
//     this.whatsapp,
//     this.email,
//     this.alternativeMail,
//     this.website,
//     this.address,
//     this.product,
//     this.services,
//     this.remarks,
//     this.image,
//     this.feedback,
//     this.feedbackDate,
//     this.followUpDate,
//     this.fullName,
//     this.userId,
//     this.department,
//     this.name,
//     this.productName,
//   });

//   factory CallDetailsModel.fromJson(Map<String, dynamic> json) {
//     return CallDetailsModel(
//       custType: json['cust_type']?.toString() ?? '',
//       callType: int.tryParse(json['call_type']?.toString() ?? ''),
//       clientType: int.tryParse(json['client_type']?.toString() ?? ''),
//       clientOrg: json['client_org'],
//       clientName: json['client_name'],
//       contact: json['contact'],
//       whatsapp: json['whatsapp'],
//       email: json['email'],
//       alternativeMail: json['alternative_mail'],
//       website: json['website'],
//       address: json['address'],
//       product: json['Product']?.toString(), // capital P handled
//       services: json['services']?.toString(),
//       remarks: json['remarks'],
//       image: json['image'],
//       feedback: json['feedback'],
//       feedbackDate: json['feedback_date'],
//       followUpDate: json['follow_up_date'],
//       fullName: json['full_name'],
//       userId: int.tryParse(json['user_id']?.toString() ?? ''),
//       department: json['department']?.toString(),
//       name: json['name'],
//       productName: json['productName'],
//     );
//   }

//   Map<String, dynamic> toJson() {
//     return {
//       'cust_type': custType,
//       'call_type': callType,
//       'client_type': clientType,
//       'client_org': clientOrg,
//       'client_name': clientName,
//       'contact': contact,
//       'whatsapp': whatsapp,
//       'email': email,
//       'alternative_mail': alternativeMail,
//       'website': website,
//       'address': address,
//       'Product': product,
//       'services': services,
//       'remarks': remarks,
//       'image': image,
//       'feedback': feedback,
//       'feedback_date': feedbackDate,
//       'follow_up_date': followUpDate,
//       'full_name': fullName,
//       'user_id': userId,
//       'department': department,
//       'name': name,
//       'productName': productName,
//     };
//   }
// }

class CallDetailsResponse {
  final Call call;
  final List<FeedbackModel> feedbacks;

  CallDetailsResponse({required this.call, required this.feedbacks});

  factory CallDetailsResponse.fromJson(Map<String, dynamic> json) {
    return CallDetailsResponse(
      call: Call.fromJson(json['call']),
      feedbacks: (json['feedbacks'] as List)
          .map((e) => FeedbackModel.fromJson(e))
          .toList(),
    );
  }
}

class Call {
  final int id;
  final int? status;
  final String custType;
  final int callType;
  final int clientType;
  final String clientOrg;
  final String clientName;
  final String contact;
  final String whatsapp;
  final String email;
  final String alternativeMail;
  final String website;
  final String address;
  final String product;
  final String services;
  final String remarks;
  final String dropRemarks;
  final String image;
  final String fullName;
  final int userId;
  final String callName;
  final String productName;
  final String department;
  final String employee;

  Call({
    required this.id,
    required this.status,
    required this.custType,
    required this.callType,
    required this.clientType,
    required this.clientOrg,
    required this.clientName,
    required this.contact,
    required this.whatsapp,
    required this.email,
    required this.alternativeMail,
    required this.website,
    required this.address,
    required this.product,
    required this.services,
    required this.remarks,
    required this.dropRemarks,
    required this.image,
    required this.fullName,
    required this.userId,
    required this.callName,
    required this.productName,
    required this.department,
    required this.employee,
  });

  factory Call.fromJson(Map<String, dynamic> json) {
    return Call(
      id: json['id'] ?? 0,
      status: json['status'],
      custType: json['cust_type'] ?? '',
      callType: json['call_type'] ?? 0,
      clientType: json['client_type'] ?? 0,
      clientOrg: json['client_org'] ?? '',
      clientName: json['client_name'] ?? '',
      contact: json['contact'] ?? '',
      whatsapp: json['whatsapp'] ?? '',
      email: json['email'] ?? '',
      alternativeMail: json['alternative_mail'] ?? '',
      website: json['website'] ?? '',
      address: json['address'] ?? '',
      product: json['Product'] ?? '',
      services: json['services'] ?? '',
      remarks: json['remarks'] ?? '',
      dropRemarks: json['drop_remark'] ?? '',
      image: json['image'] ?? '',
      fullName: json['full_name'] ?? '',
      userId: json['user_id'] ?? 0,
      callName: json['call_name'] ?? '',
      productName: json['productName'] ?? '',
      department: json['department'] ?? '',
      employee: json['employee'] ?? '',
    );
  }
}

class FeedbackModel {
  final String feedback;
  final String feedbackDate;
  final String followUpDate;

  FeedbackModel({
    required this.feedback,
    required this.feedbackDate,
    required this.followUpDate,
  });

  factory FeedbackModel.fromJson(Map<String, dynamic> json) {
    return FeedbackModel(
      feedback: json['feedback'] ?? '',
      feedbackDate: json['feedback_date'] ?? '',
      followUpDate: json['follow_up_date'] ?? '',
    );
  }
}
