import 'package:albedo_app/view/home_page.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class AccountController extends GetxController {
  final emailController = TextEditingController();
  final passwordController = TextEditingController();

  var rememberMe = false.obs;
  var obscurePassword = true.obs;
  var isLoading = false.obs;

  void toggleRemember(bool? value) {
    rememberMe.value = value ?? false;
  }

  void togglePassword() {
    obscurePassword.value = !obscurePassword.value;
  }

  Future<void> login() async {
    if (emailController.text.isEmpty || passwordController.text.isEmpty) {
      Get.snackbar("Error", "Please fill all fields");
      return;
    }

    try {
      isLoading.value = true;

      // TODO: API CALL HERE
      await Future.delayed(const Duration(seconds: 2));

      Get.snackbar("Success", "Login Successful");
      Get.to(() => HomeView());
    } catch (e) {
      Get.snackbar("Error", "Login Failed");
    } finally {
      isLoading.value = false;
    }
  }
}
