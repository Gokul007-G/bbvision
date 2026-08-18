import 'dart:convert';

import 'package:bbvision/model/location_result_model.dart';
import 'package:bbvision/service/service.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';

class LocationService {
  final api = Service();

  // intert the location for employee
  Future<bool> locationInsert(LocationResultModel location) async {
    debugPrint("Location service started");

    try {
      final response = await api.dio.post(
        'employee_location_add.php',
        data: location.toJson(),
        options: Options(
          contentType: Headers.jsonContentType,
          responseType: ResponseType.json,
        ),
      );

      debugPrint("Location response: ${response.data}");

      if (response.statusCode == 200) {
        return true;
      }

      return false;
    } on DioException catch (e) {
      debugPrint("Location API Error: ${e.message}");
      debugPrint("Response: ${e.response?.data}");

      return false;
    } catch (e) {
      debugPrint("Location Error: $e");
      return false;
    } finally {
      debugPrint("Location service ended");
    }
  }

  // get the location details
  Future<List<LocationResultModel>?> locationDetails() async {
    debugPrint("Location service started");

    try {
      final response = await api.dio.post('employee_location_view.php');

      debugPrint("Location response: ${response.data}");

      if (response.statusCode == 200) {
        final data = response.data is String
            ? jsonDecode(response.data)
            : response.data;

        if (data['status'] == "success") {
          return (data['data'] as List)
              .map((e) => LocationResultModel.fromJson(e))
              .toList();
        }
        return null;
      }

      return null;
    } on DioException catch (e) {
      debugPrint("Location API Error: ${e.message}");
      debugPrint("Response: ${e.response?.data}");

      return null;
    } catch (e) {
      debugPrint("Location Error: $e");
      return null;
    } finally {
      debugPrint("Location service ended");
    }
  }
}
