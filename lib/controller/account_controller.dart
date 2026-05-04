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

  final bool useMock = true;
  var obscurePassword = true.obs;
  var isLoading = false.obs;
  var isEditing = false.obs;

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
      Users user = useMock ? await _mockLogin() : await _apiLogin();

      final AuthController auth = Get.find<AuthController>();

      auth.currentUser.value = user;
      auth.impersonatedUser.value = null;

      LocalStorage().writeUser(user);

      Get.snackbar("Success", "Login Successful as ${user.role}");
      Get.offAll(() => HomeView());
    } catch (e) {
      Get.snackbar("Error", e.toString());
    } finally {
      isLoading.value = false;
    }
  }

  Future<Users> _mockLogin() async {
    await Future.delayed(const Duration(seconds: 2));

    final email = emailController.text;

    if (email.contains("admin")) {
      return Users(
          name: 'Admin',
          id: 'EMP001',
          role: 'admin',
          email: email,
          contact: '9999999999');
    } else if (email.contains("student")) {
      return Users(
          name: 'Student User',
          id: 'STU001',
          role: 'student',
          email: email,
          contact: '8888888888');
    } else if (email.contains("teacher")) {
      return Users(
          name: 'Teacher User',
          id: 'TCH001',
          role: 'teacher',
          email: email,
          contact: '7777777777');
    } else if (email.contains("mentor")) {
      return Users(
          name: 'Mentor User',
          id: 'MTR001',
          role: 'mentor',
          email: email,
          contact: '6666666666');
    } else if (email.contains("coordinator")) {
      return Users(
          name: 'Coordinator User',
          id: 'COR001',
          role: 'coordinator',
          email: email,
          contact: '5555555555');
    } else if (email.contains("advisor")) {
      return Users(
          name: 'Advisor User',
          id: 'ADV001',
          role: 'advisor',
          email: email,
          contact: '4444444444');
    } else if (email.contains("finance")) {
      return Users(
          name: 'Finance User',
          id: 'FIN001',
          role: 'finance',
          email: email,
          contact: '0000000000');
    } else if (email.contains("hr")) {
      return Users(
          name: 'HR User',
          id: 'HR001',
          role: 'hr',
          email: email,
          contact: '4444444444');
    } else if (email.contains("sales")) {
      return Users(
          name: 'Sales User',
          id: 'SAL001',
          role: 'sales',
          email: email,
          contact: '4444444444');
    }

    return Users(
      name: 'Guest User',
      id: 'GST001',
      role: 'guest',
      email: email,
      contact: '0000000000',
    );
  }

  Future<Users> _apiLogin() async {
    // Example structure
    // final response = await ApiService.login(
    //   emailController.text,
    //   passwordController.text,
    // );

    // if (!response.success) throw Exception(response.message);

    // return Users.fromJson(response.data);

    throw UnimplementedError("API not implemented yet");
  }

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
    if (email.isEmpty || oldPassword.isEmpty || newPassword.isEmpty) {
      Get.snackbar("Error", "All fields are required");
      return;
    }

    if (newPassword.length < 6) {
      Get.snackbar("Error", "Password must be at least 6 characters");
      return;
    }

    Get.dialog(
      const Center(child: CircularProgressIndicator()),
      barrierDismissible: false,
    );

    try {
      if (useMock) {
        await Future.delayed(const Duration(seconds: 2));
      } else {
        await _apiResetPassword(email, oldPassword, newPassword);
      }

      Get.back();
      Get.snackbar("Success", "Password updated successfully");
    } catch (e) {
      Get.back();
      Get.snackbar("Error", e.toString());
    }
  }

  Future<void> _apiResetPassword(
    String email,
    String oldPassword,
    String newPassword,
  ) async {
    // await ApiService.resetPassword(email, oldPassword, newPassword);
  }

  void logout() {
    LocalStorage().clearAll();
    Get.offAll(LoginView()); 
  }

  Future<void> forgotPassword() async {
    if (emailController.text.isEmpty) {
      Get.snackbar("Error", "Please enter your email address");
      return;
    }

    isLoading.value = true;

    try {
      if (useMock) {
        await Future.delayed(const Duration(seconds: 2));
      } else {
        await _apiForgotPassword();
      }

      Get.snackbar("Success", "Password reset link sent");
    } catch (e) {
      Get.snackbar("Error", e.toString());
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> _apiForgotPassword() async {
    // await ApiService.forgotPassword(emailController.text);
  }
}
