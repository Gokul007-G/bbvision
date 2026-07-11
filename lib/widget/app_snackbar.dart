import 'package:flutter/material.dart';
import 'package:get/route_manager.dart';
import 'package:bbvision/widget/appColors.dart';

class AppSnackbar {

  static void success(String message, {String title = 'Success'}) {
    _show(
      title: title,
      message: message,
      icon: Icons.check_circle,
      backgroundColor: AppColors.success,
    );
  }
  
  static void error(String message, {String title = 'Error'}) {
    _show(
      title: title,
      message: message,
      icon: Icons.error,
      backgroundColor: AppColors.error,
    );
  }

  static void info(String message, {String title = 'Info'}) {
    _show(
      title: title,
      message: message,
      icon: Icons.info,
      backgroundColor: AppColors.primary,
    );
  }

  static void _show({
    required String title,
    required String message,
    required IconData icon,
    required Color backgroundColor,
  }) {
    Get.snackbar(
      title,
      message,
      snackPosition: SnackPosition.TOP,
      backgroundColor: backgroundColor,
      colorText: Colors.white,
      margin: const EdgeInsets.all(16),
      borderRadius: 14,
      icon: Icon(icon, color: Colors.white),
      shouldIconPulse: false,
      snackStyle: SnackStyle.FLOATING,
      duration: const Duration(seconds: 2),
      boxShadows: [
        BoxShadow(
          color: Colors.black.withOpacity(0.15),
          blurRadius: 10,
          offset: const Offset(0, 4),
        ),
      ],
    );
  }
}
