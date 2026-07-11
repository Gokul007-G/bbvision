import 'dart:convert';

import 'package:get/get_rx/get_rx.dart';
import 'package:bbvision/model/enquiry/call_details_model.dart';
import 'package:bbvision/model/enquiry/crm_calls_model.dart';
import 'package:bbvision/service/service.dart';

class ViewEnquiryService {
  final api = Service();

  final calls = <CrmCallModel?>[].obs;

  //insert the new feedback
  Future<bool> insertFeedback({
    required int callsId,
    required int userId,
    required String date,
    required String followUpDate,
    required String feedback,
  }) async {
    try {
      final response = await api.dio.post(
        'view_enquiry.php',
        data: {
          'type': 'submit',
          'calls_id': callsId,
          'feedback': feedback,
          'feedback_date': date,
          'follow_up_date': followUpDate,
          'userId': userId,
        },
      );
      if (response.statusCode == 200) {
        final data = response.data;
        if (data['status'] == 'success') {
          return true;
        }
      }
      return false;
    } catch (e) {
      return false;
    }
  }

  //update the assign
  Future<bool> updateAssign({
    required int id,
    required int department,
    required int employee,
  }) async {
    try {
      final response = await api.dio.post(
        'view_enquiry.php',
        data: {
          'type': 'assign',
          'id': id,
          'employee': employee,
          'department': department,
        },
      );
      if (response.statusCode == 200) {
        final data = response.data;
        if (data['status'] == 'success') {
          return true;
        }
      }
      return false;
    } catch (e) {
      return false;
    }
  }

  //drop function
  Future<bool> updateDrop({
    required int id,
    required String remark,
  }) async {
    try {
      final response = await api.dio.post(
        'view_enquiry.php',
        data: {
          'type': 'drop',
          'id': id,
          'remark': remark,
        },
      );
      if (response.statusCode == 200) {
        final data = response.data;
        if (data['status'] == 'success') {
          return true;
        }
      }
      return false;
    } catch (e) {
      return false;
    }
  }

  //get the list
  Future<List<CrmCallModel>?> getEnquiryList(int userId) async {
    try {
      final response = await api.dio.get(
        'view_enquiry.php',
        queryParameters: {'userId': userId},
      );
      if (response.statusCode == 200) {
        final data = response.data is String
            ? jsonDecode(response.data)
            : response.data;

        if (data['status'] == 'success') {
          return (data['data'] as List)
              .map((e) => CrmCallModel.fromJson(e))
              .toList();
        } else {
          return null;
        }
      }
      return null;
    } catch (e) {
      print('error $e');
    }
    return null;
  }

  //View Details
  Future<CallDetailsResponse?> viewEnquiryById(int id) async {
    try {
      final response = await api.dio.get(
        'view_enquiry_details.php',
        queryParameters: {'id': id},
      );
      if (response.statusCode == 200) {
        final data = response.data is String
            ? jsonDecode(response.data)
            : response.data;

        if (data['status'] == 'success') {
          return CallDetailsResponse.fromJson(data['data']);
        } else {
          return null;
        }
      }
      return null;
    } catch (e) {
      print('error $e');
    }
    return null;
  }
}
