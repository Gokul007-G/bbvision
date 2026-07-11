class TravelModel {
  final int id;
  final String travelType;

  TravelModel({required this.id, required this.travelType});

  factory TravelModel.fromJson(Map<String, dynamic> json) {
    return TravelModel(id: json['id'], travelType: json['travel_type']);
  }

  Map<String, dynamic> toJson() {
    return {'id': id, 'travel_type': travelType};
  }
}
