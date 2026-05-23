import 'package:albedo_app/api.dart';
import 'package:albedo_app/controller/settings_controller.dart';
import 'package:albedo_app/model/settings/notification_model.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class NotificationsController extends GetxController {
  var selectedTab = 0.obs;
  var msgs = <Notifications>[].obs;
  var isLoading = false.obs;
  var isImportant = false.obs;
  var errorMessage = ''.obs;
  RxBool isDeleteButtonLoading = false.obs;
  RxList<VisibleTo> selected = <VisibleTo>[].obs;

  var filteredMessages = <Notifications>[].obs;
  final tabs = ["All", "Important", "Updates"];

  TextEditingController titleController = TextEditingController();
  TextEditingController messageController = TextEditingController();

  @override
  void onInit() {
    super.onInit();

    applyFilters();
    isLoading.value = false;
  }

  Future<void> getNotifications() async {
    errorMessage.value = '';

    try {
      isLoading.value = true;

      final result = await Api().getNotifications();

      if (result is String) {
        Get.snackbar(
          'Error',
          result,
          colorText: Theme.of(Get.context!).colorScheme.onPrimary,
        );

        return;
      }

      msgs.assignAll(
        result
            .map<Notifications>(
              (e) => Notifications.fromJson(e),
            )
            .toList(),
      );
    } catch (e) {
      Get.snackbar(
        'Error',
        e.toString(),
        colorText: Theme.of(Get.context!).colorScheme.onPrimary,
      );
    } finally {
      isLoading.value = false;
    }
  }

  Future<Notifications?> addNotification() async {
    isLoading.value = true;

    try {
      final result = await Api().addNotification(
        title: titleController.text.trim(),
        message: messageController.text.trim(),
        dashboardTarget: selected.map((e) => e.apiValue).toList(),
        isImportant: isImportant.value,
      );
      if (result != null) {
        Get.back();

        Get.snackbar(
          "Success",
          "Notification added successfully",
        );
      } else {
        Get.snackbar(
          "Error",
          "Failed to add notification",
        );
      }
      return result;
    } catch (e) {
      Get.snackbar(
        "Error",
        e.toString(),
      );
      return null;
    } finally {
      isLoading.value = false;
    }
  }

  int getCount(int index) {
    switch (index) {
      case 0:
        return msgs.length;

      case 1:
        return msgs.where((e) => e.isImportant == true).length;

      case 2:
        return msgs.where((e) => e.isImportant == false).length;

      default:
        return 0;
    }
  }

  Future<bool> deleteNotification(
    String id,
  ) async {
    isLoading.value = true;

    try {
      final success = await Api().deleteNotification(id);

      if (success) {
        msgs.removeWhere((e) => e.id == id);

        Get.snackbar("Success", "Deleted successfully");
        return true;
      } else {
        Get.snackbar("Error", "Delete failed");
        return false;
      }
    } catch (e) {
      Get.snackbar("Error", e.toString());
      return false;
    } finally {
      isLoading.value = false;
    }
  }

  void applyFilters() {
    List<Notifications> temp = msgs;

    // Tabs
    switch (selectedTab.value) {
      case 0:
        temp = temp;
        break;
      case 1:
        temp = temp.where((s) => s.isImportant == true).toList();
        break;
      case 2:
        temp = temp.where((s) => s.isImportant == false).toList();
        break;
    }

    filteredMessages.value = temp;
  }

  VisibleTo visibleToFromString(String value) {
    switch (value.toUpperCase()) {
      case 'ADMIN':
        return VisibleTo.admin;

      case 'TEACHER':
        return VisibleTo.teacher;

      case 'STUDENT':
        return VisibleTo.student;

      case 'MENTOR':
        return VisibleTo.mentor;

      case 'COORDINATOR':
        return VisibleTo.coordinator;

      default:
        return VisibleTo.other;
    }
  }

  Future<void> updateNotification({
    required String id,
  }) async {
    isLoading.value = true;

    try {
      final success = await Api().updateNotification(
        id: id,
        title: titleController.text.trim(),
        message: messageController.text.trim(),
        dashboardTarget: selected.map((e) => e.apiValue).toList(),
        isImportant: isImportant.value,
      );

      if (success) {
        Get.back();

        Get.snackbar(
          "Success",
          "Notification updated",
        );
      } else {
        Get.snackbar(
          "Error",
          "Update failed",
        );
      }
    } catch (e) {
      Get.snackbar(
        "Error",
        e.toString(),
      );
    } finally {
      isLoading.value = false;
    }
  }
}
