import 'dart:developer';

import 'package:albedo_app/api.dart';
import 'package:albedo_app/view/login_page.dart';
import 'package:albedo_app/controller/auth_controller.dart';
import 'package:albedo_app/database/local_storage.dart';
import 'package:albedo_app/model/users/user_model.dart';
import 'package:albedo_app/view/home_page.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:image_picker/image_picker.dart';

class AccountController extends GetxController {
  final nameController = TextEditingController();
  final empIdController = TextEditingController();
  final phoneController = TextEditingController();
  final positionController = TextEditingController();
  final emailController = TextEditingController();
  final otpController = TextEditingController();
  final contactController = TextEditingController();
  final passwordController = TextEditingController();
  final oldPasswordController = TextEditingController();
  final newPasswordController = TextEditingController();
  final confirmPassController = TextEditingController();
  final AuthController auth = Get.find();

  final bool useMock = false;
  var obscurePassword = true.obs;
  var isLoading = false.obs;
  var isEditing = false.obs;
  var isEditLoading = false.obs;
  var errorMessage = ''.obs;
  RxInt forgotStep = 1.obs;
  var profileImagePath = ''.obs;
  var remoteProfileImage = ''.obs;

  @override
  onInit() {
    super.onInit();
    if (kDebugMode) {
      emailController.text = 'albedoeducator@gmail.com';
      passwordController.text = 'adm@7012';
    }
  }

  //------------------Login---------------------------//

  Future<void> login() async {
    errorMessage.value = '';

    await LocalStorage().clearToken();

    final email = emailController.text;
    final password = passwordController.text;

    if (email.isEmpty || password.isEmpty) {
      Get.snackbar("Error", "Please fill all fields");
      return;
    }

    isLoading.value = true;

    final result = await Api().login({
      'email': email,
      'password': password,
    });

    if (result is LoginResponse) {
      await LocalStorage().writeUser(result.data ?? Users());

      await LocalStorage().writeToken(
        result.accessToken ?? '',
        result.refreshToken ?? '',
      );

      await getUserDetails();

      Get.snackbar('Welcome', auth.activeUser?.name ?? '',
          icon: Icon(
            Icons.login,
            color: Theme.of(Get.context!).colorScheme.onSurface,
          ),
          colorText: Theme.of(Get.context!).colorScheme.onSurface);

      Get.offAll(() => HomeView());
    } else {
      Get.snackbar('Error', result.toString(),
          colorText: Theme.of(Get.context!).colorScheme.onPrimary);
    }

    isLoading.value = false;
  }

//------------------Google Login---------------------------//

  Future<void> googleLogin() async {
    errorMessage.value = '';

    try {
      isLoading.value = true;

      final GoogleSignIn googleSignIn = GoogleSignIn.instance;

      await googleSignIn.initialize();

      final GoogleSignInAccount googleUser = await googleSignIn.authenticate();

      final GoogleSignInAuthentication googleAuth = googleUser.authentication;

      final idToken = googleAuth.idToken;

      if (idToken == null || idToken.isEmpty) {
        Get.snackbar(
          'Error',
          'Failed to get Google token',
        );

        isLoading.value = false;
        return;
      }

      final result = await Api().googleLogin({
        'id_token': idToken,
      });

      if (result is LoginResponse) {
        await LocalStorage().writeUser(
          result.data ?? Users(),
        );

        await LocalStorage().writeToken(
          result.accessToken ?? '',
          result.refreshToken ?? '',
        );

        Get.snackbar(
          'Welcome',
          '',
          icon: Icon(
            Icons.login,
            color: Theme.of(Get.context!).colorScheme.onSurface,
          ),
        );

        Get.offAll(() => HomeView());
      } else {
        Get.snackbar(
          'Error',
          result.toString(),
        );
      }
    } catch (e) {
      log("Google Login Error: $e");

      Get.snackbar(
        'Error',
        'Google login failed',
      );
    } finally {
      isLoading.value = false;
    }
  }

//------------------User Details---------------------------//

  Future<void> getUserDetails() async {
    errorMessage.value = '';

    isLoading.value = true;

    final result = await Api().userDetails();

    if (result is Users) {
      /// Save updated user
      await LocalStorage().writeUser(result);

      /// Update current user
      auth.currentUser.value = result;
    } else {
      Get.snackbar(
        'Error',
        result.toString(),
        colorText: Theme.of(Get.context!).colorScheme.onPrimary,
      );
    }

    isLoading.value = false;
  }

  void toggleEdit() {
    isEditing.value = !isEditing.value;

    final AuthController auth = Get.find<AuthController>();
    final user = auth.currentUser.value;
    if (isEditing.value) {
      user; // preload values when editing starts
    }
  }

  //------------------Edit User---------------------------//
  Future<void> updateUser({
    required String empId,
    required String id,
    required String name,
    required String email,
    required String contact,
  }) async {
    isLoading.value = true;

    try {
      final oldUser = auth.currentUser.value;
      final userId = oldUser?.id;

      final result = await Api().updateUser(id, {
        "emp_id": empId,
        "name": name,
        "email": email,
        "phone_number": contact,
      });

      if (result is Users) {
        final updatedUser = result;

        updatedUser.id ??= userId;

        await LocalStorage().writeUser(updatedUser);

        auth.currentUser.value = updatedUser;

        await getUserDetails();

        Get.back();

        Get.snackbar(
          "Success",
          "Profile updated successfully",
          icon: Icon(
            Icons.check_circle,
            color: Theme.of(Get.context!).colorScheme.primary,
          ),
        );
      } else {
        Get.snackbar("Error", result.toString());
      }
    } finally {
      isLoading.value = false;
    }
  }

  void cancelEdit() {
    isEditing.value = false;
  }

//------------------Logout---------------------------//

  void logout() {
    log('Logging out');
    isLoading.value = true;
    Api().logout().then(
      (value) {
        isLoading.value = false;
        if (value) {
          LocalStorage().clearAll();
          Get.offAll(() => LoginView());
          Get.snackbar("Success", "Logged out successfully",
              colorText: Theme.of(Get.context!).colorScheme.onPrimary);
        }
      },
    );
  }

//------------------Forgot Password---------------------------//

  Future<bool> forgotPasswordRequest() async {
    errorMessage.value = '';

    final email = emailController.text.trim();

    if (email.isEmpty) {
      Get.snackbar("Error", "Please enter your email");
      return false;
    }

    isLoading.value = true;

    final result = await Api().forgotPasswordRequest({
      'email': email,
    });

    isLoading.value = false;

    if (result == true) {
      Get.snackbar(
        'Success',
        'Password reset link sent to your email',
        icon: Icon(
          Icons.email,
          color: Theme.of(Get.context!).colorScheme.onPrimary,
        ),
        colorText: Theme.of(Get.context!).colorScheme.onPrimary,
      );

      return true;
    }

    Get.snackbar(
      'Error',
      result.toString(),
      colorText: Theme.of(Get.context!).colorScheme.onPrimary,
    );

    return false;
  }

  Future<bool> validateForgotPasswordTokenRequest() async {
    errorMessage.value = '';

    final email = emailController.text.trim();
    final otp = otpController.text.trim();

    if (email.isEmpty || otp.isEmpty) {
      Get.snackbar("Error", "Please enter OTP");
      return false;
    }

    isLoading.value = true;

    final result = await Api().validateForgotPasswordToken({
      'email': email,
      'token': otp,
    });

    isLoading.value = false;

    if (result == true) {
      Get.snackbar(
        'Success',
        'OTP validated successfully',
        icon: Icon(
          Icons.verified,
          color: Theme.of(Get.context!).colorScheme.onPrimary,
        ),
        colorText: Theme.of(Get.context!).colorScheme.onPrimary,
      );

      return true;
    }

    Get.snackbar(
      'Error',
      result.toString(),
      colorText: Theme.of(Get.context!).colorScheme.onPrimary,
    );

    return false;
  }

  Future<void> forgotPasswordConfirmRequest() async {
    errorMessage.value = '';

    final email = emailController.text.trim();
    final token = LocalStorage().readAccessToken();
    final password = passwordController.text.trim();
    final confirmPassword = confirmPassController.text.trim();

    if (email.isEmpty ||
        (token?.isEmpty ?? true) ||
        password.isEmpty ||
        confirmPassword.isEmpty) {
      Get.snackbar("Error", "Please fill all fields");
      return;
    }

    if (password != confirmPassword) {
      Get.snackbar("Error", "Passwords do not match");
      return;
    }

    isLoading.value = true;

    final result = await Api().forgotPasswordConfirm({
      'email': email,
      'token': token,
      'password': password,
      'password_confirmation': confirmPassword,
    });

    if (result == true) {
      Get.snackbar(
        'Success',
        'Password reset successful',
        icon: Icon(
          Icons.check_circle,
          color: Theme.of(Get.context!).colorScheme.onPrimary,
        ),
        colorText: Theme.of(Get.context!).colorScheme.onPrimary,
      );

      /// Optional navigation
      /// Get.offAll(() => LoginView());
    } else {
      Get.snackbar(
        'Error',
        result.toString(),
        colorText: Theme.of(Get.context!).colorScheme.onPrimary,
      );
    }

    isLoading.value = false;
  }

  //   Future<void> changePassword(String id) async {
  //   isLoading.value = true;
  //   Api().changePassword({
  //     'old_password': oldpasswordController.text,
  //     'new_password': confirmPassController.text
  //   }).then((value) {
  //     isLoading.value = false;
  //     if (value?.status ?? false) {
  //       Get.to(() => LoginScreen());
  //       CustomWidgets.showSnackBar(
  //           'Success', value?.message ?? 'Password Changed.');
  //     } else {
  //       Get.back();
  //       CustomWidgets.showSnackBar(
  //           'Error', value?.message ?? 'Password not changed.');
  //     }
  //   });
  // }

//------------------Reset Password---------------------------//

  Future<bool> passwordResetRequest() async {
    errorMessage.value = '';

    final email = emailController.text.trim();

    if (email.isEmpty) {
      Get.snackbar("Error", "Please enter your email");
      return false;
    }

    isLoading.value = true;

    final result = await Api().passwordResetRequest({
      'email': email,
    });

    isLoading.value = false;

    if (result is String) {
      Get.snackbar(
        'Success',
        result,
        icon: Icon(
          Icons.email,
          color: Theme.of(Get.context!).colorScheme.onPrimary,
        ),
        colorText: Theme.of(Get.context!).colorScheme.onPrimary,
      );

      return true;
    }

    Get.snackbar(
      'Error',
      result.toString(),
      colorText: Theme.of(Get.context!).colorScheme.onPrimary,
    );

    return false;
  }

  Future<bool> resetPasswordConfirmRequest() async {
    errorMessage.value = '';

    final email = emailController.text.trim();
    final token = otpController.text.trim();
    final password = newPasswordController.text.trim();
    final confirmPassword = confirmPassController.text.trim();

    if (email.isEmpty ||
        token.isEmpty ||
        password.isEmpty ||
        confirmPassword.isEmpty) {
      Get.snackbar("Error", "Please fill all fields");
      return false;
    }

    if (password != confirmPassword) {
      Get.snackbar("Error", "Passwords do not match");
      return false;
    }

    isLoading.value = true;

    final result = await Api().resetPasswordConfirm({
      'email': email,
      'token': token,
      'new_password': password,
      'confirm_password': confirmPassword,
    });

    isLoading.value = false;

    if (result == true) {
      Get.snackbar(
        'Success',
        'Password reset successful',
        icon: Icon(
          Icons.check_circle,
          color: Theme.of(Get.context!).colorScheme.onPrimary,
        ),
        colorText: Theme.of(Get.context!).colorScheme.onPrimary,
      );

      return true;
    }

    Get.snackbar(
      'Error',
      result.toString(),
      colorText: Theme.of(Get.context!).colorScheme.onPrimary,
    );

    return false;
  }

  Future<void> pickProfileImage() async {
    final picker = ImagePicker();

    final pickedFile = await picker.pickImage(
      source: ImageSource.gallery,
    );

    if (pickedFile != null) {
      profileImagePath.value = pickedFile.path;
    }
  }

  // Future<void> resetPassword(String id) async {
  //   isLoading.value = true;
  //   Api().resetPassword({
  //     'admission_number': id,
  //     'new_password': confirmPassController.text
  //   }).then((value) {
  //     isLoading.value = false;
  //     if (value?.status ?? false) {
  //       Get.back();
  //       CustomWidgets.showSnackBar(
  //           'Success', value?.message ?? 'Password Changed.');
  //     } else {
  //       Get.back();
  //       CustomWidgets.showSnackBar(
  //           'Error', value?.message ?? 'Password not changed.');
  //     }
  //   });
  // }
}
