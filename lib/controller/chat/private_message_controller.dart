import 'package:bbvision/model/chat/get_employee_model.dart';
import 'package:bbvision/model/chat/private_message_model.dart';
import 'package:bbvision/model/login_model.dart';
import 'package:bbvision/service/auth_local_storage.dart';
import 'package:bbvision/service/chat/private_message_service.dart';
import 'package:flutter/widgets.dart';
import 'package:get/get.dart';

class PrivateMessageController extends GetxController {
  final String recevierId;

  PrivateMessageController({required this.recevierId});

  final service = Get.put(PrivateMessageService());

  final isLoading = false.obs;
  final isSending = false.obs;
  final messageController = TextEditingController();
  final empDetails = <GetEmployeeModel>{};
  var senderId = '';

  final messagesList = <PrivateMessageModel>[].obs;

  final ScrollController scrollController = ScrollController();

  @override
  Future<void> onInit() async {
    super.onInit();
    final user = await _loadUser();
    senderId = user!.userName;

    await getMessagesListCnt(recevierId: recevierId);
  }

  @override
  void onClose() {
    scrollController.dispose();
    messageController.dispose();
    super.onClose();
  }

  void scrollToBottom() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!scrollController.hasClients) return;

      scrollController.animateTo(
        scrollController.position.maxScrollExtent,
        duration: const Duration(milliseconds: 250),
        curve: Curves.easeOut,
      );
    });
  }

  Future<LoginData?> _loadUser() async {
    final login = await AuthLocalStorage.getLoginDetails();
    return login?.data;
  }

  //get the messages
  Future<void> getMessagesListCnt({required String recevierId}) async {
    isLoading.value = true;
    try {
      final result = await service.getMessagesList(
        senderId: senderId,
        receiverId: recevierId,
      );

      if (result != null) {
        messagesList.clear();
        messagesList.assignAll(result);
      }
      scrollToBottom();
    } catch (e) {
      print('controller Error $e');
    } finally {
      isLoading.value = false;
    }
  }

  //insert the message
  Future<void> sendMessage({
    required String recevierId,
    required String divId,
  }) async {
    isSending.value = true;

    try {
      final user = await _loadUser();

      if (user == null) {
        print('User not found');
        return;
      }

      final senderId = user.userName;
      final name = user.fullName;
      final depId = user.department;
      final message = messageController.text.trim();

      if (message.isEmpty) {
        print('Message is empty');
        return;
      }

      print('depId: $depId');
      print('divId: $divId');
      print('senderId: $senderId');
      print('receiverId: $recevierId');
      print('Sender name: $name');
      print('message: $message');

      final result = await service.sendMessage(
        depId: depId,
        divId: divId,
        senderId: senderId,
        receiverId: recevierId,
        fullName: name,
        message: message,
        messageType: 'text',
        fileUrl: '',
      );

      if (result != null) {
        // Clear input after successful insert
        messageController.clear();
        await getMessagesListCnt(recevierId: recevierId);
      }
      scrollToBottom();
    } catch (e) {
      print('send message error: $e');
    } finally {
      isSending.value = false;
    }
  }
}
