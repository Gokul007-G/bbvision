import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:bbvision/model/login_model.dart';
import 'package:bbvision/screen/dashboart_screen.dart';
import 'package:bbvision/service/auth_local_storage.dart';
import 'package:bbvision/service/login_service.dart';
import 'package:bbvision/widget/app_snackbar.dart';

class LoginController extends GetxController {
  final service = Get.put(LoginService());

  final user = Rxn<LoginData>();
  final userNameController = TextEditingController();
  final passwordController = TextEditingController();

  final loginKey = GlobalKey<FormState>();

  final visibility = true.obs;
  final isLoading = false.obs;

  @override
  void onInit() {
    super.onInit();
    _loadUser();
  }

  //load the user data
  Future<void> _loadUser() async {
    final login = await AuthLocalStorage.getLoginDetails();
    if (login != null) {
      userNameController.text = login.data!.userName;
      final password = await AuthLocalStorage.getPassword();
      passwordController.text = password.toString();
    }
  }

  @override
  void onClose() {
    userNameController.dispose();
    passwordController.dispose();
  }

  //login controller
  Future<void> loginCnt() async {
    try {
      isLoading.value = true;
      final result = await service.login(
        userNameController.text,
        passwordController.text,
      );
      if (result != null && result.status == 'success' && result.data != null) {
        user.value = result.data;

        await AuthLocalStorage.saveLogin(result, passwordController.text);

        AppSnackbar.success('Welcome ${result.data?.fullName ?? ''}');
        Get.off(() => DashboardScreen());
      } else {
        AppSnackbar.error('Invalid username or password');
      }
    } on DioException catch (e) {
      if (e.type == DioExceptionType.connectionTimeout ||
          e.type == DioExceptionType.receiveTimeout) {
        AppSnackbar.error('Server is taking too long. Try again');
      } else if (e.type == DioExceptionType.connectionError) {
        AppSnackbar.error('No internet connection');
      } else {
        AppSnackbar.error('Something went wrong');
      }
    } catch (e) {
      AppSnackbar.info('Please check your internet connection $e');
    } finally {
      isLoading.value = false;
    }
  }
}
