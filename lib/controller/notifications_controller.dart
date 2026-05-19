import 'package:albedo_app/api.dart';
import 'package:albedo_app/controller/settings_controller.dart';
import 'package:albedo_app/model/settings/notification_model.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class NotificationsController extends GetxController {
  var selectedTab = 0.obs;
  var msgs = <Notifications>[].obs;
  var isLoading = true.obs;
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

  delete(id) {
    isDeleteButtonLoading.value = true;
    // Api().deleteProgram(id).then(
    //   (value) {
    //     if (value?.status == true) {
    //       isDeleteButtonLoading.value = false;
    //       Get.back();
    //       Get.back();
    //       Get.snackbar(
    //           "Success", value?.message ?? "Program deleted successfully.");
    //     } else {
    //       // CustomWidgets.showSnackBar(
    //       //     "Error", value?.message ?? 'Failed to delete program.');
    //     }
    //   },
    // );
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

}
