class ProductServiceModel {
  final int id;
  final int mappingId;
  final String name;

  ProductServiceModel({
    required this.id,
    required this.mappingId,
    required this.name,
  });

  factory ProductServiceModel.fromJson(Map<String, dynamic> json) {
    return ProductServiceModel(
      id: int.tryParse(json['id'].toString()) ?? 0,
      mappingId: int.tryParse(json['mapping_id'].toString()) ?? 0,
      name: json['name']?.toString().trim() ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'mapping_id': mappingId,
      'name': name,
    };
  }
}
