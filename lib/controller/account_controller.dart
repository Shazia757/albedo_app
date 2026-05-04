import 'package:albedo_app/login_page.dart';
import 'package:albedo_app/controller/auth_controller.dart';
import 'package:albedo_app/database/local_storage.dart';
import 'package:albedo_app/model/users/user_model.dart';
import 'package:albedo_app/view/home_page.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class AccountController extends GetxController {
  final nameController = TextEditingController();
  final emailController = TextEditingController();
  final contactController = TextEditingController();
  final passwordController = TextEditingController();
  final oldPasswordController = TextEditingController();
  final newPasswordController = TextEditingController();
  final confirmPassController = TextEditingController();

  var rememberMe = true.obs;
  var obscurePassword = true.obs;
  var isLoading = false.obs;

  @override
  onInit() {
    super.onInit();
    if (kDebugMode) {
      emailController.text = 'student@gmail.com';
      passwordController.text = '0000';
    }
  }

  Future<void> login() async {
    if (emailController.text.isEmpty || passwordController.text.isEmpty) {
      Get.snackbar("Error", "Please fill all fields");
      return;
    }

    isLoading.value = true;

    try {
      await Future.delayed(const Duration(seconds: 2));

      final AuthController auth = Get.find<AuthController>();

      Users user;

      /// 🔥 TEMP ROLE SWITCH (replace with API later)
      if (emailController.text.contains("admin")) {
        user = Users(
          name: 'Admin',
          id: 'EMP001',
          role: 'admin',
          email: emailController.text,
          contact: '9999999999',
        );
      } else if (emailController.text.contains("student")) {
        user = Users(
          name: 'Student User',
          id: 'STU001',
          role: 'student',
          email: emailController.text,
          contact: '8888888888',
        );
      } else if (emailController.text.contains("teacher")) {
        user = Users(
          name: 'Teacher User',
          id: 'TCH001',
          role: 'teacher',
          email: emailController.text,
          contact: '7777777777',
        );
      } else if (emailController.text.contains("mentor")) {
        user = Users(
          name: 'Mentor User',
          id: 'MTR001',
          role: 'mentor',
          email: emailController.text,
          contact: '6666666666',
        );
      } else if (emailController.text.contains("coordinator")) {
        user = Users(
          name: 'Coordinator User',
          id: 'COR001',
          role: 'coordinator',
          email: emailController.text,
          contact: '5555555555',
        );
      } else if (emailController.text.contains("advisor")) {
        user = Users(
          name: 'Advisor User',
          id: 'ADV001',
          role: 'advisor',
          email: emailController.text,
          contact: '4444444444',
        );
      } else if (emailController.text.contains("finance")) {
        user = Users(
          name: 'Finance User',
          id: 'FIN001',
          role: 'finance',
          email: emailController.text,
          contact: '0000000000',
        );
      } else if (emailController.text.contains("hr")) {
        user = Users(
          name: 'HR User',
          id: 'HR001',
          role: 'hr',
          email: emailController.text,
          contact: '4444444444',
        );
      } else if (emailController.text.contains("sales")) {
        user = Users(
          name: 'Sales User',
          id: 'SAL001',
          role: 'sales',
          email: emailController.text,
          contact: '4444444444',
        );
      } else {
        /// default fallback
        user = Users(
          name: 'Guest User',
          id: 'GST001',
          role: 'guest',
          email: emailController.text,
          contact: '0000000000',
        );
      }

      auth.currentUser.value = user;
      auth.impersonatedUser.value = null;

      LocalStorage().writeUser(user);

      Get.snackbar("Success", "Login Successful as ${user.role}");
      Get.offAll(() => HomeView());
    } catch (e) {
      Get.snackbar("Error", "Login Failed");
    } finally {
      isLoading.value = false;
    }
  }

  var isEditing = false.obs;

  void toggleEdit() {
    isEditing.value = !isEditing.value;

    final AuthController auth = Get.find<AuthController>();
    final user = auth.currentUser.value;
    if (isEditing.value) {
      user; // preload values when editing starts
    }
  }

  void updateUser(
      {required String name, required String email, required String contact}) {
    final AuthController auth = Get.find<AuthController>();
    final user = auth.activeUser;
    if (user == null) return;
    user.copyWith(
      name: name,
      email: email,
      contact: contact,
    );

    isEditing.value = false;
  }

  void cancelEdit() {
    isEditing.value = false;
  }

  Future<void> resetPassword({
    required String email,
    required String oldPassword,
    required String newPassword,
  }) async {
    try {
      if (email.isEmpty || oldPassword.isEmpty || newPassword.isEmpty) {
        Get.snackbar("Error", "All fields are required");
        return;
      }

      if (newPassword.length < 6) {
        Get.snackbar("Error", "Password must be at least 6 characters");
        return;
      }

      /// 🔄 Show loader
      Get.dialog(
        const Center(child: CircularProgressIndicator()),
        barrierDismissible: false,
      );

      /// 👉 CALL YOUR API HERE
      // await _fakeApiCall(email, oldPassword, newPassword);

      Get.back(); // close loader

      Get.snackbar("Success", "Password updated successfully");
    } catch (e) {
      Get.back(); // close loader
      Get.snackbar("Error", e.toString());
    }
  }

  void logout() {
    LocalStorage().clearAll();
    Get.offAll(LoginView()); // clears saved login
  }

  void forgotPassword() async {
    if (emailController.text.isEmpty) {
      Get.snackbar("Error", "Please enter your email address");
      return;
    }
    isLoading.value = true;
    try {
      // Call your API here
      await Future.delayed(Duration(seconds: 2));

      Get.snackbar(
        "Success",
        "Password reset link sent to your email",
      );
    } catch (e) {
      Get.snackbar("Error", "Something went wrong");
    } finally {
      isLoading.value = false;
    }
  }
}
