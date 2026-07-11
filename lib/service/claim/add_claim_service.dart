import 'package:flutter/material.dart';
import 'package:bbvision/service/service.dart';
import 'package:dio/dio.dart' as dio;

class AddClaimService {
  final api = Service();

  // get the travel types
  Future<List<Map<String, dynamic>>> getTravelType() async {
    try {
      final response = await api.dio.get('add_claim.php');

      if (response.statusCode == 200) {
        final data = response.data;

        if (data['status'] == 'success' && data['data'] is List) {
          return List<Map<String, dynamic>>.from(data['data']);
        }
      }
    } catch (e) {
      debugPrint('API Error: $e');
    }
    return [];
  }

  //insert data
  Future<bool> insertData(dio.FormData data) async {
    final response = await api.dio.post('add_claim.php', data: data);
    if (response.statusCode == 200) {
      final data = response.data;
      if (data['status'] == 'success') {
        return true;
      } else {
        print('${data['message']}');
      }
    }
    return false;
  }
}
