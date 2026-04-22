import 'package:albedo_app/model/users/user_model.dart';
import 'package:get/get.dart';

class AuthController extends GetxController {
  Rx<Users?> currentUser = Rx<Users?>(null);

  Rx<Users?> impersonatedUser = Rx<Users?>(null);

  bool get isImpersonating => impersonatedUser.value != null;

  Users? get activeUser => impersonatedUser.value ?? currentUser.value;

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

    // Get.offAll(() => AdminDashboard());
  }
}
