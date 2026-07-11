//8 6 51 =>  500 server error
//8 6 52 => 200 ok


import 'package:bbvision/model/payslip/payslip_response_model.dart';
import 'package:bbvision/service/service.dart';

class PayslipService {
  final api = Service();

  //get the list box details

  Future<PayslipResponseModel?> getPayslipData() async {
    try {
      final response = await api.dio.get('view_payslip.php');

      if (response.statusCode == 200) {
        final data = response.data;

        if (data['status'] == 'success') {
          return PayslipResponseModel.fromJson(data);
        }
      }
    } catch (e) {
      print("Error fetching payslip data: $e");
    }

    return null;
  }

  //get the details
  Future<Map<String, dynamic>> getDetails(
    int payrollId,
    int department,
    int employee,
  ) async {
    final response = await api.dio.get(
      'view_payslip_details.php',
      queryParameters: {
        'payroll_id': payrollId,
        'department': department,
        'employee': employee,
      },
    );

    if (response.statusCode == 200) {
      final data = response.data;
      if (data['status'] == 'success') {
        return data;
      } else {
        return {'message': data['message']};
      }
    }
    return {};
  }
}
