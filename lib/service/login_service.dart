import 'dart:convert';
import 'package:dio/dio.dart';
import 'package:bbvision/model/login_model.dart';
import 'package:bbvision/service/service.dart';

class LoginService {
  final api = Service();
  //login
  Future<LoginModel?> login(String username, String password) async {
    try {
      final response = await api.dio.post(
        'login.php',
        queryParameters: {'username': username, 'password': password},
      );

      if (response.statusCode == 200) {
        final dynamic rawData = response.data;

        final Map<String, dynamic> data = rawData is String
            ? jsonDecode(rawData)
            : rawData;
        if (data['status'] == 'success') {
          return LoginModel.fromJson(data);
        } else {
          return LoginModel(status: 'failed', data: null);
        }
      }
      return null;
    } on DioException catch (e) {
      print('Dio Error Type: ${e.type}');
      print('Dio Error Message: ${e.message}');
      print('Dio Error: ${e.error}');
      print('Request URL: ${e.requestOptions.uri}');
      print('Response: ${e.response?.data}');
      rethrow;
    } finally {
      print('Service end');
    }
  }
}
