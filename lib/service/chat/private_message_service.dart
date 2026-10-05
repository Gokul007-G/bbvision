import 'package:bbvision/model/chat/private_message_model.dart';
import 'package:bbvision/service/service.dart';

class PrivateMessageService {
  final api = Service();

  //get messages
  Future<List<PrivateMessageModel>?> getMessagesList({
    required String senderId,
    required String receiverId,
  }) async {
    try {
      final response = await api.dio.get(
        'chat/private_message_view.php',
        queryParameters: {'sender_id': senderId, 'receiver_id': receiverId},
      );

      print('Get Messages Response: ${response.data}');

      if (response.statusCode == 200) {
        final responseData = response.data;

        if (responseData['status'] == true) {
          final data = responseData['data'];

          if (data is List) {
            return data
                .map(
                  (e) => PrivateMessageModel.fromJson(
                    Map<String, dynamic>.from(e),
                  ),
                )
                .toList();
          }

          // No messages
          return [];
        }

        print('API Error: ${responseData['message']}');
        return null;
      }

      return null;
    } catch (e) {
      print('Get message error: $e');
      return null;
    }
  }

  //insert the message
  Future<bool?> sendMessage({
    required String depId,
    required String divId,
    required String senderId,
    required String receiverId,
    required String fullName,
    required String message,
    required String messageType,
    String fileUrl = '',
  }) async {
    try {
      final response = await api.dio.post(
        'chat/private_message_add.php',
        data: {
          'depId': depId,
          'divId': divId,
          'senderId': senderId,
          'receiverId': receiverId,
          'fullName': fullName,
          'message': message,
          'message_type': messageType,
          'file_url': fileUrl,
        },
      );

      print('Response: ${response.data}');

      if (response.statusCode == 200) {
        final data = response.data;

        if (data['status'] == true) {
          return true;
        }

        print('API Error: ${data['message']}');
      }

      return null;
    } catch (e) {
      print('sendMessage API error: $e');
      return null;
    }
  }
}
