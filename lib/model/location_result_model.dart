class LocationResultModel {
  final int id;
  final String employeeId;
  final double latitude;
  final double longitude;
  final String area;
  final String city;
  final int status;
  final DateTime? inTime;
  final DateTime? outTime;
  final DateTime? createdAt;

  LocationResultModel({
    required this.id,
    required this.employeeId,
    required this.latitude,
    required this.longitude,
    required this.area,
    required this.city,
    required this.status,
    this.inTime,
    this.outTime,
    this.createdAt,
  });

  Map<String, dynamic> toJson() {
    return {
      "id": id,
      "employee_id": employeeId,
      "latitude": latitude,
      "longitude": longitude,
      "area": area,
      "city": city,
      "status": status,
      "in_time": inTime?.toIso8601String(),
      "out_time": outTime?.toIso8601String(),
      "created_at": createdAt?.toIso8601String(),
    };
  }

  factory LocationResultModel.fromJson(Map<String, dynamic> json) {
    return LocationResultModel(
      id: int.tryParse(json["id"]?.toString() ?? "") ?? 0,

      employeeId: json["employee_id"]?.toString() ?? "",

      latitude: double.tryParse(json["latitude"]?.toString() ?? "") ?? 0.0,

      longitude: double.tryParse(json["longitude"]?.toString() ?? "") ?? 0.0,

      area: json["area"]?.toString() ?? "",

      city: json["city"]?.toString() ?? "",

      status: int.tryParse(json["status"]?.toString() ?? "") ?? 0,

      inTime:
          json["in_time"] != null &&
              json["in_time"].toString().isNotEmpty &&
              json["in_time"].toString() != "0000-00-00 00:00:00"
          ? DateTime.tryParse(json["in_time"].toString().replaceFirst(" ", "T"))
          : null,

      outTime:
          json["out_time"] != null &&
              json["out_time"].toString().isNotEmpty &&
              json["out_time"].toString() != "0000-00-00 00:00:00"
          ? DateTime.tryParse(
              json["out_time"].toString().replaceFirst(" ", "T"),
            )
          : null,

      createdAt:
          json["created_at"] != null && json["created_at"].toString().isNotEmpty
          ? DateTime.tryParse(
              json["created_at"].toString().replaceFirst(" ", "T"),
            )
          : null,
    );
  }
}
