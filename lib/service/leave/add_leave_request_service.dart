import 'dart:convert';
import 'package:bbvision/model/leave/leave_model.dart';
import 'package:bbvision/service/service.dart';

class AddLeaveRequestService {
  final api = Service();


  //get the Leave Types
  Future<List<LeaveModel>?> getLeaveType() async {
    final response = await api.dio.get(
      'add_leave_request.php',
      queryParameters: {'type': 'leave_details'},
    );

    if (response.statusCode == 200) {
      final data = response.data is String
          ? jsonDecode(response.data)
          : response.data;

      if (data['status'] == 'success') {
        return (data['data'] as List)
            .map((e) => LeaveModel.fromJson(e))
            .toList();
      } else {
        return null;
      }
    }
    return null;
  }

}
