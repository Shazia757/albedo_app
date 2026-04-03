import 'package:albedo_app/model/user_model.dart';
import 'package:albedo_app/view/home_page.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class AccountController extends GetxController {
  final nameController = TextEditingController();
  final emailController = TextEditingController();
  final contactController = TextEditingController();
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

  var isEditing = false.obs;

  var user = UserModel(
    name: "Shazia",
    employeeId: "EMP123",
    role: "Software Developer",
    email: "shazia@email.com",
    contact: "9876543210",
    profileImage: "https://via.placeholder.com/150",
  ).obs;

  void toggleEdit() {
    isEditing.value = !isEditing.value;

    if (isEditing.value) {
      user(); // preload values when editing starts
    }
  }

  void updateUser(
      {required String name, required String email, required String contact}) {
    user.update((val) {
      val!.name = name;
      val.email = email;
      val.contact = contact;
    });
    isEditing.value = false;
  }

  void cancelEdit() {
    isEditing.value = false;
  }

  void resetPassword() {
    Get.snackbar("Reset Password", "Password reset link sent to email");
  }
}
