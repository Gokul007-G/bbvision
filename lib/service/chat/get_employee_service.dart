import 'package:bbvision/model/chat/get_employee_model.dart';
import 'package:bbvision/service/service.dart';

class GetEmployeeService {
  final api = Service();

  //get the employee details
  Future<List<GetEmployeeModel>?> getEmployeeList() async {
    try {
      final response = await api.dio.get('chat/get_employees.php');

      if (response.statusCode == 200) {
        final data = response.data;

        if (data['status'] == true) {
          return (data['data'] as List)
              .map((e) => GetEmployeeModel.fromJson(e))
              .toList();
        }
      }
      return null;
    } catch (e) {
      print('chat Employee service Error $e');
      return null;
    }
  }
}
