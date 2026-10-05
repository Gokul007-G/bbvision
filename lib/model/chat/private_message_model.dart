class PrivateMessageModel {
  final int id;
  final String senderId;
  final String receiverId;
  final String departmentId;
  final String divisionId;
  final String fullname;
  final String message;
  final String messageType;
  final String fileUrl;
  final String createdAt;

  PrivateMessageModel({
    required this.id,
    required this.senderId,
    required this.receiverId,
    required this.departmentId,
    required this.divisionId,
    required this.fullname,
    required this.message,
    required this.messageType,
    required this.fileUrl,
    required this.createdAt,
  });

  factory PrivateMessageModel.fromJson(Map<String, dynamic> json) {
    return PrivateMessageModel(
      id: int.tryParse(json['id'].toString()) ?? 0,
      senderId: json['sender_id']?.toString() ?? '',
      receiverId: json['receiver_id']?.toString() ?? '',
      departmentId: json['department_id']?.toString() ?? '',
      divisionId: json['division_id']?.toString() ?? '',
      fullname: json['fullname']?.toString() ?? '',
      message: json['message']?.toString() ?? '',
      messageType: json['message_type']?.toString() ?? 'text',
      fileUrl: json['file_url']?.toString() ?? '',
      createdAt: json['created_at']?.toString() ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'sender_id': senderId,
      'receiver_id': receiverId,
      'department_id': departmentId,
      'division_id': divisionId,
      'fullname': fullname,
      'message': message,
      'message_type': messageType,
      'file_url': fileUrl,
      'created_at': createdAt,
    };
  }
}