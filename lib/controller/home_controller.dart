import 'package:flutter/material.dart';
import 'package:get/get.dart';

enum TimeFilter { all, week, month, year }

class HomeController extends GetxController {
  var studentCount = 0.obs;
  var teacherCount = 0.obs;
  var coordinatorCount = 0.obs;
  var mentorCount = 0.obs;

  var studentData = <double>[].obs;
  var teacherData = <double>[].obs;
  var coordinatorData = <double>[].obs;
  var mentorData = <double>[].obs;
  var isLoading = true.obs;
  var isUsersExpanded = false.obs;
  var selectedIndex = 0.obs;
  var selectedSubIndex = 0.obs;
  var totalPackage = 0.0.obs;

  var packageData = <Map<String, dynamic>>[].obs;

  var totalHours = <double>[].obs;
  var classAmount = <double>[].obs;
  var totalSalary = <double>[].obs;

  var years = ["2021", "2022", "2023", "2024", "2025", "2026"];

  var expenseRatio = 0.0.obs;
  var totalExpense = 0.0.obs;
  var totalIncome = 0.0.obs;
  var selectedFilter = TimeFilter.all.obs;
  var studentRange = "All".obs;
  var teacherRange = "All".obs;
  var coordinatorRange = "All".obs;
  var mentorRange = "All".obs;
  var summaryRange = "All".obs;
  var expenseRange = "All".obs;

  var studentLabels = <String>[].obs;
  var teacherLabels = <String>[].obs;
  var coordinatorLabels = <String>[].obs;
  var mentorLabels = <String>[].obs;
  var expenseLabels = <String>[].obs;

  void updateStudentData({TimeFilter? filter, String? range}) {
    if (range != null) {
      switch (range) {
        case "All":
          studentData.assignAll([10, 30, 20, 40, 35, 50]);
          studentLabels
              .assignAll(["2021", "2022", "2023", "2024", "2025", "2026"]);
          break;

        case "This Month":
          studentData.assignAll([5, 8, 6, 7, 9, 10]);
          studentLabels.assignAll(["W1", "W2", "W3", "W4", "W5", "W6"]);
          break;

        case "This Year":
          studentData.assignAll([100, 200, 300, 400, 500, 600]);
          studentLabels
              .assignAll(["2019", "2020", "2021", "2022", "2023", "2024"]);
          break;
      }
      return;
    }
  }

  void updateTeacherData({String? range}) {
    switch (range) {
      case "All":
        teacherData.assignAll([2, 5, 3, 6, 4, 7]);
        teacherLabels.assignAll(["Jan", "Feb", "Mar", "Apr", "May", "Jun"]);
        break;

      case "This Month":
        teacherData.assignAll([1, 2, 3, 2, 4, 3]);
        teacherLabels.assignAll(["W1", "W2", "W3", "W4", "W5", "W6"]);
        break;

      case "This Year":
        teacherData.assignAll([10, 20, 30, 25, 35, 40]);
        teacherLabels
            .assignAll(["2019", "2020", "2021", "2022", "2023", "2024"]);
        break;
    }
  }

  void updatecoordinatorData({String? range}) {
    switch (range) {
      case "All":
        coordinatorData.assignAll([1, 2, 1, 3, 2, 4]);
        coordinatorLabels.assignAll(["Jan", "Feb", "Mar", "Apr", "May", "Jun"]);
        break;

      case "This Month":
        coordinatorData.assignAll([1, 1, 2, 1, 2, 2]);
        coordinatorLabels.assignAll(["W1", "W2", "W3", "W4", "W5", "W6"]);
        break;

      case "This Year":
        coordinatorData.assignAll([5, 10, 15, 20, 25, 30]);
        coordinatorLabels
            .assignAll(["2019", "2020", "2021", "2022", "2023", "2024"]);
        break;
    }
  }

  void updateMentorData({String? range}) {
    switch (range) {
      case "All":
        mentorData.assignAll([1, 2, 1, 3, 2, 4]);
        mentorLabels.assignAll(["Jan", "Feb", "Mar", "Apr", "May", "Jun"]);
        break;

      case "This Month":
        mentorData.assignAll([1, 1, 2, 1, 2, 2]);
        mentorLabels.assignAll(["W1", "W2", "W3", "W4", "W5", "W6"]);
        break;

      case "This Year":
        mentorData.assignAll([5, 10, 15, 20, 25, 30]);
        mentorLabels
            .assignAll(["2019", "2020", "2021", "2022", "2023", "2024"]);
        break;
    }
  }

  void updateSummaryData(String range) {
    switch (range) {
      case "All":
        loadDummyData(); // existing
        break;

      case "This Month":
        packageData.assignAll([
          {
            "name": "Total Package",
            "value": 12000000.0,
            "color": Colors.orange,
            "icon": Icons.inventory_2_outlined,
          },
          {
            "name": "To Collect",
            "value": 6000000.0,
            "color": Colors.purple,
            "icon": Icons.currency_rupee,
          },
        ]);
        break;

      case "This Year":
        packageData.assignAll([
          {
            "name": "Total Package",
            "value": 50000000.0,
            "color": Colors.orange,
            "icon": Icons.inventory_2_outlined,
          },
          {
            "name": "To Collect",
            "value": 20000000.0,
            "color": Colors.purple,
            "icon": Icons.currency_rupee,
          },
        ]);
        break;
    }

    // recalculate total
    totalPackage.value = packageData.fold(
      0,
      (sum, item) => sum + (item['value'] as double),
    );
  }

  void updateExpenseData(String range) {
    switch (range) {
      case "All":
        loadChartData();
        expenseLabels
            .assignAll(["2021", "2022", "2023", "2024", "2025", "2026"]);
        break;

      case "This Month":
        totalHours.assignAll([0, 0, 10, 20, 30, 40]);
        classAmount.assignAll([0, 0, 2000000, 4000000, 6000000, 8000000]);
        totalSalary.assignAll([0, 0, 1000000, 2000000, 3000000, 4000000]);
        expenseLabels.assignAll(["W1", "W2", "W3", "W4", "W5", "W6"]);
        break;

      case "This Year":
        totalHours.assignAll([50, 80, 100, 120, 150, 200]);
        classAmount.assignAll(
            [5000000, 8000000, 10000000, 15000000, 18000000, 20000000]);
        totalSalary.assignAll(
            [2000000, 4000000, 6000000, 8000000, 10000000, 12000000]);
        expenseLabels
            .assignAll(["2019", "2020", "2021", "2022", "2023", "2024"]);
        break;
    }

    totalExpense.value = totalSalary.reduce((a, b) => a + b);
    totalIncome.value = classAmount.reduce((a, b) => a + b);
    expenseRatio.value = (totalExpense.value / totalIncome.value) * 100;
  }

  @override
  void onInit() {
    super.onInit();
    fetchDashboardData();
    loadDummyData();
    loadChartData();
  }

  Future<void> fetchDashboardData() async {
    try {
      isLoading.value = true;

      // 🔥 Replace with your API call
      await Future.delayed(const Duration(seconds: 2));

      // Example response mapping
      studentCount.value = 1034;
      teacherCount.value = 10;
      coordinatorCount.value = 4;
      mentorCount.value = 18;

      studentData.assignAll([10, 30, 20, 40, 35, 50]);
      teacherData.assignAll([2, 5, 3, 6, 4, 7]);
      coordinatorData.assignAll([1, 2, 1, 3, 2, 4]);
    } catch (e) {
      print("Error: $e");
    } finally {
      isLoading.value = false;
    }
  }

  void toggleUsers() {
    isUsersExpanded.value = !isUsersExpanded.value;
  }

  void setIndex(int index) {
    selectedIndex.value = index;
  }

  void setSubIndex(int index) {
    selectedSubIndex.value = index;
  }

  void loadDummyData() {
    final data = [
      {
        "name": "Total Package",
        "value": 32919144.18,
        "color": Colors.orange,
        "icon": Icons.inventory_2_outlined,
      },
      {
        "name": "To Collect",
        "value": 20624645.51,
        "color": Colors.purple,
        "icon": Icons.currency_rupee,
      },
      {
        "name": "Refund",
        "value": 162388.63,
        "color": Colors.red,
        "icon": Icons.receipt_long,
      },
      {
        "name": "Coupon Code",
        "value": 1297.5,
        "color": Colors.blue,
        "icon": Icons.local_offer,
      },
    ];

    packageData.assignAll(data);

    totalPackage.value = data.fold(
      0,
      (sum, item) => sum + (item['value'] as double),
    );
  }

  void loadChartData() {
    totalHours.assignAll([0, 0, 0, 0, 0, 0]);
    classAmount.assignAll([0, 0, 0, 0, 16000000, 7000000]);
    totalSalary.assignAll([0, 0, 0, 0, 5000000, 2000000]);

    totalExpense.value = 8117251.30;
    totalIncome.value = 25375041.46;

    expenseRatio.value = (totalExpense.value / totalIncome.value) * 100;
  }
}
