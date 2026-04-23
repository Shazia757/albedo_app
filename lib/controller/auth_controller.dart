import 'package:albedo_app/database/local_storage.dart';
import 'package:albedo_app/model/users/user_model.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';

class AuthController extends GetxController {
  final box = GetStorage();

  Rx<Users?> currentUser = Rx<Users?>(null);
  Rx<Users?> impersonatedUser = Rx<Users?>(null);

  bool get isImpersonating => impersonatedUser.value != null;
  Users? get activeUser => impersonatedUser.value ?? currentUser.value;

  @override
  void onInit() {
    super.onInit();

    final storedUser = LocalStorage().readUser();

    if (storedUser != null && storedUser.id != null) {
      currentUser.value = storedUser;
    }

    print("Loaded user: ${currentUser.value}");
  }

  void startImpersonation(Users targetUser) {
    if (currentUser.value == null) {
      Get.snackbar("Error", "No active session");
      return;
    }

    if (currentUser.value!.role != 'admin') {
      Get.snackbar("Access denied", "Only admin can impersonate");
      return;
    }

    if (targetUser.role == 'admin') {
      Get.snackbar("Invalid action", "Cannot impersonate admin");
      return;
    }

    impersonatedUser.value = targetUser;
  }

  void stopImpersonation() {
    impersonatedUser.value = null;
  }
}
