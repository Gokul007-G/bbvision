import 'package:bbvision/controller/chat/private_message_controller.dart';
import 'package:bbvision/model/chat/get_employee_model.dart';
import 'package:bbvision/model/chat/private_message_model.dart';
import 'package:bbvision/widget/appColors.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

class IndividualChatPage extends StatelessWidget {
  final GetEmployeeModel employee;

  const IndividualChatPage({super.key, required this.employee});

  PrivateMessageController get controller =>
      Get.put(PrivateMessageController(recevierId: employee.empCode));

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        backgroundColor: AppColors.primary,
        foregroundColor: Colors.white,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_rounded, size: 24),
          onPressed: () => Get.back(),
        ),
        titleSpacing: 0,
        title: Row(
          children: [
            CircleAvatar(
              radius: 20,
              backgroundColor: Colors.white.withOpacity(0.2),
              child: Text(
                employee.empName.isNotEmpty
                    ? employee.empName[0].toUpperCase()
                    : '?',
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 17,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    employee.empName,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    employee.designationName,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                      color: Colors.white.withOpacity(0.75),
                      fontSize: 12,
                      fontWeight: FontWeight.w400,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),

      body: Container(
        color: AppColors.scaffoldBg,

        child: Column(
          children: [
            // Messages
            Expanded(
              child: Obx(() {
                if (controller.isLoading.value) {
                  return const Center(child: CircularProgressIndicator());
                }

                if (controller.messagesList.isEmpty) {
                  return const Center(
                    child: Text(
                      'No messages yet',
                      style: TextStyle(color: Colors.grey, fontSize: 14),
                    ),
                  );
                }

                return ListView.builder(
                  controller: controller.scrollController,
                  padding: const EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 16,
                  ),
                  itemCount: controller.messagesList.length,
                  itemBuilder: (context, index) {
                    final message = controller.messagesList[index];

                    final isMe = message.senderId == controller.senderId;

                    return _MessageBubble(message: message, isMe: isMe);
                  },
                );
              }),
            ),

            // Message input
            _MessageInput(controller: controller, employee: employee),
          ],
        ),
      ),
    );
  }
}

class _MessageInput extends StatelessWidget {
  final PrivateMessageController controller;
  final GetEmployeeModel employee;

  const _MessageInput({required this.controller, required this.employee});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.fromLTRB(10, 8, 10, 10),
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 8,
            offset: const Offset(0, -2),
          ),
        ],
      ),
      child: SafeArea(
        top: false,
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            Expanded(
              child: TextField(
                controller: controller.messageController,
                minLines: 1,
                maxLines: 5,
                textInputAction: TextInputAction.newline,
                decoration: InputDecoration(
                  hintText: 'Type a message...',
                  filled: true,
                  fillColor: const Color(0xFFF1F2F6),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(24),
                    borderSide: BorderSide.none,
                  ),
                  contentPadding: const EdgeInsets.symmetric(
                    horizontal: 18,
                    vertical: 12,
                  ),
                ),
              ),
            ),

            const SizedBox(width: 8),

            Obx(
              () => CircleAvatar(
                radius: 23,
                backgroundColor: AppColors.primary,
                child: controller.isSending.value
                    ? const SizedBox(
                        height: 20,
                        width: 20,
                        child: CircularProgressIndicator(
                          strokeWidth: 2,
                          color: Colors.white,
                        ),
                      )
                    : IconButton(
                        onPressed: () {
                          controller.sendMessage(
                            recevierId: employee.empCode,
                            divId: employee.divId,
                          );
                        },
                        icon: const Icon(
                          Icons.send_rounded,
                          color: Colors.white,
                          size: 21,
                        ),
                      ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _MessageBubble extends StatelessWidget {
  final PrivateMessageModel message;
  final bool isMe;

  const _MessageBubble({required this.message, required this.isMe});

  String _formatTime(String dateTime) {
    try {
      final date = DateTime.parse(dateTime.replaceFirst(' ', 'T'));

      return DateFormat('h:mm a').format(date);
    } catch (e) {
      return '';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: isMe ? Alignment.centerRight : Alignment.centerLeft,
      child: Container(
        constraints: BoxConstraints(
          maxWidth: MediaQuery.of(context).size.width * 0.78,
        ),
        margin: EdgeInsets.only(
          bottom: 8,
          left: isMe ? 50 : 0,
          right: isMe ? 0 : 50,
        ),
        padding: const EdgeInsets.fromLTRB(12, 8, 8, 6),
        decoration: BoxDecoration(
          color: isMe ? AppColors.primary : const Color(0xFFFFF3E0),
          borderRadius: BorderRadius.only(
            topLeft: const Radius.circular(16),
            topRight: const Radius.circular(16),
            bottomLeft: Radius.circular(isMe ? 16 : 4),
            bottomRight: Radius.circular(isMe ? 4 : 16),
          ),
          border: isMe ? null : Border.all(color: AppColors.border),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            Flexible(
              child: Text(
                message.message,
                style: TextStyle(
                  color: isMe ? Colors.white : AppColors.textPrimary,
                  fontSize: 15,
                  height: 1.3,
                ),
              ),
            ),

            const SizedBox(width: 8),

            Text(
              _formatTime(message.createdAt),
              style: TextStyle(
                color: isMe
                    ? Colors.white.withOpacity(0.75)
                    : AppColors.textSecondary,
                fontSize: 10,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
