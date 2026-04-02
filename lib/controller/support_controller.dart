import 'package:albedo_app/model/support_model.dart';
import 'package:get/get.dart';

class SupportController extends GetxController {
  var selectedTab = 0.obs; // 0 = open, 1 = closed
  var searchQuery = ''.obs;

  var allSupports = <SupportModel>[].obs;
  var supports = <SupportModel>[].obs;

  final statusMap = ['open', 'closed'];

  @override
  void onInit() {
    super.onInit();
    loadDummyData();
    applyFilters();
  }

  void loadDummyData() {
    allSupports.assignAll([
      SupportModel(
          id: "SUP001",
          title: "Login Issue",
          description: "Unable to login with correct credentials",
          by: "Student A",
          status: "open"),
      SupportModel(
          id: "SUP002",
          title: "Payment Failed",
          description: "Transaction failed but amount deducted",
          by: "Student B",
          status: "open"),
      SupportModel(
          id: "SUP003",
          title: "App Crash",
          description: "App crashes when opening dashboard",
          by: "Teacher X",
          status: "closed"),
      SupportModel(
          id: "SUP004",
          title: "Wrong Data",
          description: "Incorrect student data displayed",
          by: "Admin",
          status: "closed"),
    ]);
  }

  void applyFilters() {
    final status = statusMap[selectedTab.value];

    supports.assignAll(
      allSupports.where((s) {
        final matchesStatus = s.status == status;
        final matchesSearch = s.title
                .toLowerCase()
                .contains(searchQuery.value.toLowerCase()) ||
            s.id.toLowerCase().contains(searchQuery.value.toLowerCase());

        return matchesStatus && matchesSearch;
      }).toList(),
    );
  }

  int getCount(int index) {
    return allSupports.where((e) => e.status == statusMap[index]).length;
  }
}