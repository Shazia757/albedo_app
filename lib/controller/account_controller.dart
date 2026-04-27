import 'package:albedo_app/common_views/login_page.dart';
import 'package:albedo_app/config/root.dart';
import 'package:albedo_app/controller/auth_controller.dart';
import 'package:albedo_app/database/local_storage.dart';
import 'package:albedo_app/model/users/user_model.dart';
import 'package:albedo_app/modules/admin/view/home_page.dart';
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
    if (kDebugMode) {
      emailController.text = 'test@gmail.com';
      passwordController.text = '0000';
    }

    super.onInit();
  }

  Future<void> login() async {
    if (emailController.text.isEmpty || passwordController.text.isEmpty) {
      Get.snackbar("Error", "Please fill all fields");
      return;
    }
    isLoading.value = true;
    try {
      // TODO: API CALL HERE
      await Future.delayed(const Duration(seconds: 2));
      final user = Users(
        name: 'Test',
        id: 'EMP001',
        role: 'admin',
      );

      LocalStorage().writeUser(user);
      

      final AuthController auth = Get.find<AuthController>();

      auth.currentUser.value = user;

      Get.snackbar("Success", "Login Successful");
      Get.offAll(() => HomeView());
    } catch (e) {
      Get.snackbar("Error", "Login Failed");
    } finally {
      isLoading.value = false;
    }
  }

  var isEditing = false.obs;

  var user = Users(
    name: "Shazia",
    id: "EMP123",
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
