import 'dart:convert';

import 'package:bbvision/model/location_result_model.dart';
import 'package:bbvision/service/service.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';

class LocationService {
  final api = Service();

  // attendance to in and out [ server to return the status 0 => login :: 1 => logout :: 2 => already logout infrom to HR ]
  Future<Map<String, dynamic>?> getAttendances(String empId) async {
    debugPrint("getAttendances service started");

    try {
      final response = await api.dio.get(
        'employee_attendance.php',
        queryParameters: {"empId": empId},
      );

      debugPrint("getAttendances response: ${response.data}");

      if (response.statusCode == 200) {
        final data = response.data is String
            ? jsonEncode(response.data)
            : response.data;
        if (data['status'] == true) {
          return data;
        }
      }

      return null;
    } on DioException catch (e) {
      debugPrint("getAttendances API Error: ${e.message}");
      debugPrint("Response: ${e.response?.data}");

      return null;
    } catch (e) {
      debugPrint("getAttendances Error: $e");
      return null;
    } finally {
      debugPrint("getAttendances service ended");
    }
  }

  // intert the location for employee
  Future<bool> locationInsert(LocationResultModel location) async {
    debugPrint("Location service started");
    debugPrint(location.employeeId);
    debugPrint(location.latitude.toString());
    debugPrint(location.longitude.toString());

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

  // update the logout time
  Future<bool> updateLogout(int tableId) async {
    debugPrint("Location service started ------------------- $tableId");

    try {
      final response = await api.dio.get(
        'employee_location_add.php',
        queryParameters: {"tableId": tableId},
      );

      debugPrint("tableId response: ${response.data}");

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
  Future<List<LocationResultModel>?> locationDetails({
    required String userId,
    required String userGroupCode,
    String? fromDate,
    String? toDate,
  }) async {
    debugPrint("Location service started");

    try {
      final response;

      if (userGroupCode == "R003") {
        if (fromDate != null && toDate != null) {
          response = await api.dio.post(
            'employee_location_view.php',
            queryParameters: {"fromDate": fromDate, "toDate": toDate},
          );
        } else {
          response = await api.dio.post('employee_location_view.php');
        }
      } else {
        if (fromDate != null && toDate != null) {
          response = await api.dio.get(
            'employee_location_view.php',
            queryParameters: {
              "empId": userId,
              "fromDate": fromDate,
              "toDate": toDate,
            },
          );
        } else {
          response = await api.dio.get(
            'employee_location_view.php',
            queryParameters: {"empId": userId},
          );
        }
      }

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
