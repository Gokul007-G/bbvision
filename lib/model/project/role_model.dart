class RoleModel {
  final int? id;
  final String? code;
  final String? roleName;

  RoleModel({required this.id, required this.code, required this.roleName});

  factory RoleModel.fromJson(Map<String, dynamic> json) {
    return RoleModel(
      id: json['id'],
      code: json['code'] ?? "",
      roleName: json['role_name'] ?? "",
    );
  }

  Map<String, dynamic> toJson() {
    return {'id': id, 'code': code, 'role_name': roleName};
  }
}
