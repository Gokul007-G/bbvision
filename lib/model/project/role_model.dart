class RoleModel {
  final int? id;
  final String? code;
  final String? empRoleName;

  RoleModel({required this.id, required this.code, required this.empRoleName});

  factory RoleModel.fromJson(Map<String, dynamic> json) {
    return RoleModel(
      id: json['id'],
      code: json['code'] ?? "",
      empRoleName: json['role_name'] ?? "",
    );
  }

  Map<String, dynamic> toJson() {
    return {'id': id, 'code': code, 'role_name': empRoleName};
  }
}
