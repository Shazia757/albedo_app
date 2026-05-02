import 'package:albedo_app/model/settings/notification_model.dart';
import 'package:get/get.dart';

class NotificationsController extends GetxController {
  var selectedTab = 0.obs;
  var msgs = <Notifications>[].obs;
  var isLoading = true.obs;
  var filteredMessages = <Notifications>[].obs;

  @override
  void onInit() {
    super.onInit();

    // mock data
    msgs.value = [
      Notifications(
        id: "1",
        title: "Session Reminder",
        message: "Your session starts in 1 hour",
        visibleTo: [],
        isImportant: true,
      ),
      Notifications(
        id: "2",
        title: "Payment Update",
        message: "Your payment has been received",
        visibleTo: [],
        isImportant: false,
      ),
    ];

    applyFilters();
    isLoading.value = false;
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
}
