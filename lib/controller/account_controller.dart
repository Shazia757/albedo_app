import 'package:albedo_app/model/user_model.dart';
import 'package:albedo_app/modules/admin/view/home_page.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';

class AccountController extends GetxController {
  final nameController = TextEditingController();
  final emailController = TextEditingController();
  final contactController = TextEditingController();
  final passwordController = TextEditingController();

  var rememberMe = false.obs;
  var obscurePassword = true.obs;
  var isLoading = false.obs;
  final box = GetStorage();
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

      if (rememberMe.value) {
        box.write('isLoggedIn', true);
        box.write('user', {
          'name': 'Test',
          'employeeId': 'EMP001',
        });
      }

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

  void logout() {
    box.erase(); // clears saved login
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
