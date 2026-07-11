import 'package:bbvision/model/claim/claim_request_model.dart';
import 'package:bbvision/service/service.dart';

class ViewClaimService {
  final api = Service();

  //get the claim list
  Future<List<ClaimRequestModel>?> getClaimList(int userId) async {
    final response = await api.dio.get(
      'view_claim.php',
      queryParameters: {'user_id': userId},
    );

    if (response.statusCode == 200) {
      final data = response.data;
      if (data['status'] == 'success') {
        return (data['data'] as List)
            .map((e) => ClaimRequestModel.fromJson(e))
            .toList();
      } else {
        return null;
      }
    }
    return null;
  }

  //update status
  Future<bool> updateStatus(int tableId, int status) async {
    final response = await api.dio.post(
      'view_claim.php',
      data: {'table_id': tableId, 'status': status},
    );
    if (response.statusCode == 200) {
      final data = response.data;
      if (data['status'] == 'success') {
        return true;
      } else {
        return false;
      }
    }
    return false;
  }
}
