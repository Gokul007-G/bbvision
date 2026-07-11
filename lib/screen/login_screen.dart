import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:bbvision/controller/login_controller.dart';
import 'package:bbvision/widget/appColors.dart';
import 'package:bbvision/widget/app_snackbar.dart';
import 'package:bbvision/widget/custom_text_field.dart';

class LoginScreen extends StatelessWidget {
  LoginScreen({super.key});
  final controller = Get.put(LoginController());

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return Scaffold(
      body: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              AppColors.primary,
              Color(0xFFFFB74D),
              AppColors.scaffoldBg,
            ],
          ),
        ),
        child: SafeArea(
          child: SingleChildScrollView(
            child: SizedBox(
              height: size.height * 0.9,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                mainAxisSize: MainAxisSize.max,
                children: [
                  // App Logo / Title
                  Container(
                    padding: const EdgeInsets.all(32),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      shape: BoxShape.circle,
                      boxShadow: [
                        BoxShadow(color: Colors.black26, blurRadius: 15),
                      ],
                    ),
                    child: Image.asset('assets/icons/logo123.jpg', height: 150),
                  ),
                  const SizedBox(height: 16),
                  const Column(
                    children: [
                      Text(
                        "Welcome Back!",
                        style: TextStyle(
                          fontSize: 28,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                      SizedBox(height: 8),
                      Text(
                        "Sign in to continue",
                        style: TextStyle(fontSize: 18, color: Colors.white),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),

                  // White Card Container
                  Container(
                    margin: const EdgeInsets.symmetric(horizontal: 24),
                    padding: const EdgeInsets.all(24),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(25),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black12,
                          blurRadius: 20,
                          offset: const Offset(0, 10),
                        ),
                      ],
                    ),
                    child: Form(
                      key: controller.loginKey,
                      child: Column(
                        children: [
                          CustomTextField(
                            controller: controller.userNameController,
                            validator: (value) {
                              if (value == null || value.trim().isEmpty) {
                                return 'Please enter the username';
                              }
                              return null;
                            },
                            label: "User Name",
                            prefixIcon: Icons.person,
                          ),
                          const SizedBox(height: 16),

                          // Password Field
                          Obx(
                            () => CustomTextField(
                              label: "Password",
                              controller: controller.passwordController,

                              validator: (value) {
                                if (value == null || value.trim().isEmpty) {
                                  return 'Please enter the password';
                                }
                                if (value.length < 6) {
                                  return 'Password must be at least 6 characters';
                                }
                                return null;
                              },
                              prefixIcon: Icons.lock_outline,
                              surfixIcon: controller.visibility.value
                                  ? IconButton(
                                      onPressed: () {
                                        controller.visibility.value =
                                            !controller.visibility.value;
                                      },
                                      icon: Icon(Icons.visibility_off),
                                    )
                                  : IconButton(
                                      onPressed: () {
                                        controller.visibility.value =
                                            !controller.visibility.value;
                                      },
                                      icon: Icon(Icons.visibility),
                                    ),
                              obscureText: controller.visibility.value,
                            ),
                          ),

                          const SizedBox(height: 24),

                          Obx(
                            () => SizedBox(
                              width: double.infinity,
                              height: 48,
                              child: ElevatedButton(
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: AppColors.primary,
                                  foregroundColor: Colors.white,
                                  elevation: 8,
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(15),
                                  ),
                                ),
                                onPressed: controller.isLoading.value
                                    ? null // Disable button while loading
                                    : () async {
                                        FocusScope.of(Get.context!).unfocus();

                                        controller.visibility.value = true;

                                        final isValid = controller
                                            .loginKey
                                            .currentState!
                                            .validate();
                                        if (!isValid) {
                                          AppSnackbar.error(
                                            'Please fix the errors',
                                          );
                                          return;
                                        }

                                        await controller.loginCnt();
                                      },
                                child: controller.isLoading.value
                                    ? Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: const [
                                          SizedBox(
                                            height: 20,
                                            width: 20,
                                            child: CircularProgressIndicator(
                                              strokeWidth: 2,
                                              color: Colors.white,
                                            ),
                                          ),
                                          SizedBox(width: 12),
                                          Text("Logging in..."),
                                        ],
                                      )
                                    : const Text(
                                        "Login",
                                        style: TextStyle(fontSize: 16),
                                      ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
