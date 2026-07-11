class CallSource {
  final int id;
  final String name;
  final int status;
  final String createdBy;

  CallSource({
    required this.id,
    required this.name,
    required this.status,
    required this.createdBy,
  });

  factory CallSource.fromJson(Map<String, dynamic> json) {
    return CallSource(
      id: int.tryParse(json['id'].toString()) ?? 0,
      name: json['name']?.toString().trim() ?? '',
      status: int.tryParse(json['status'].toString()) ?? 0,
      createdBy: json['created_by']?.toString().trim() ?? '',
    );
  }
}
