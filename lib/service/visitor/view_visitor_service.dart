import 'dart:convert';
import 'package:bbvision/model/visitor/visitor_model.dart';
import 'package:bbvision/service/auth_local_storage.dart';
import 'package:bbvision/service/service.dart';

class ViewVisitorService {
  final api = Service();

  //get the Visitor list
  Future<List<VisitorModel>?> getVisitor() async {
    final user = await AuthLocalStorage.getLoginDetails();
    final userGroupCode = user!.data!.userGroupCode;

    final response = await api.dio.get(
      'view_visitor.php',
      queryParameters: {'userGroupCode': userGroupCode},
    );

    if (response.statusCode == 200) {
      final data = response.data is String
          ? jsonDecode(response.data)
          : response.data;
      if (data['status'] == 'success') {
        return (data['data'] as List)
            .map((e) => VisitorModel.fromJson(e))
            .toList();
      } else {
        return null;
      }
    } else {
      return null;
    }
  }

  //approve the status
  Future<bool> approveStatus(String id) async {
    final response = await api.dio.get(
      'view_visitor.php',
      queryParameters: {'id': id},
    );

    if (response.statusCode == 200) {
      final data = response.data is String
          ? jsonDecode(response.data)
          : response.data;

      return data['status'] == 'success';
    }
    return false;
  }
}
