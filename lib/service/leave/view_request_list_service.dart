import 'dart:convert';
import 'package:bbvision/model/leave/leave_request_model.dart';
import 'package:bbvision/service/service.dart';

class ViewRequestListService {
  final api = Service();

  //get the List
  Future<List<LeaveRequestModel>?> getRequestList(int userId) async {
    final response = await api.dio.get(
      'view_leave_request.php',
      queryParameters: {'userId': userId},
    );

    if (response.statusCode == 200) {
      final data = response.data is String
          ? jsonDecode(response.data)
          : response.data;
      if (data['status'] == 'success') {
        return (data['data'] as List)
            .map((e) => LeaveRequestModel.fromJson(e))
            .toList();
      } else {
        return null;
      }
    }
    return null;
  }

  //approve the leave
  Future<bool> approveLeave() async {
    final response = await api.dio.post(
      'view_leave_request.php',
      queryParameters: {'approve': 1},
    );

    if (response.statusCode == 200) {
      final data = response.data is String
          ? jsonDecode(response.data)
          : response.data;
      if (data['status'] == 'success') {
        return true;
      } else {
        return false;
      }
    } else {
      return false;
    }
  }

  //reject the leave
  Future<bool> updateStatus(
    int userId,
    int tableId,
    String status
  ) async {
    final response = await api.dio.post(
      'view_leave_request.php',
      queryParameters: {'userId': userId, 'tableId': tableId, 'status': status},
    );

    if (response.statusCode == 200) {
      final data = response.data is String
          ? jsonDecode(response.data)
          : response.data;
      if (data['status'] == 'success') {
        return true;
      } else {
        return false;
      }
    } else {
      return false;
    }
  }
}
