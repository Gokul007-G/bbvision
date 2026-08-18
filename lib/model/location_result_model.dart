class LocationResultModel {
  final String employeeId;
  final double latitude;
  final double longitude;
  final String name;
  final String area;
  final String city;
  final String district;
  final String state;
  final String postalCode;
  final String country;
  final DateTime? createdAt;

  LocationResultModel({
    required this.employeeId,
    required this.latitude,
    required this.longitude,
    required this.name,
    required this.area,
    required this.city,
    required this.district,
    required this.state,
    required this.postalCode,
    required this.country,

    this.createdAt,
  });

  Map<String, dynamic> toJson() {
    return {
      "employee_id": employeeId,
      "latitude": latitude,
      "longitude": longitude,
      "location_name": name,
      "area": area,
      "city": city,
      "district": district,
      "state": state,
      "postal_code": postalCode,
      "country": country,
      "created_at": createdAt?.toIso8601String(),
    };
  }

  factory LocationResultModel.fromJson(Map<String, dynamic> json) {
    return LocationResultModel(
      employeeId: json["employee_id"]?.toString() ?? "",
      latitude: double.tryParse(json["latitude"]?.toString() ?? "") ?? 0.0,
      longitude: double.tryParse(json["longitude"]?.toString() ?? "") ?? 0.0,
      name: json["location_name"]?.toString() ?? "",
      area: json["area"]?.toString() ?? "",
      city: json["city"]?.toString() ?? "",
      district: json["district"]?.toString() ?? "",
      state: json["state"]?.toString() ?? "",
      postalCode: json["postal_code"]?.toString() ?? "",
      country: json["country"]?.toString() ?? "",
      createdAt: json["created_at"] != null
          ? DateTime.tryParse(json["created_at"].toString())
          : null,
    );
  }
}
