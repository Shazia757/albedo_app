import 'package:albedo_app/model/session_model.dart';
import 'package:albedo_app/model/users/other_users_model.dart';
import 'package:albedo_app/model/users/teacher_model.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

enum SortType { newest, oldest, name }

class OtherUsersController extends GetxController {
  var searchQuery = ''.obs;
  var sortType = SortType.newest.obs;
  var otherUsers = <OtherUsers>[].obs;
  var selectedTab = 0.obs;
  var filteredOtherUsers = <OtherUsers>[].obs;
  final tabs = ["Active", "Inactive"];
  var isSearching = false.obs;
  var isLoading = true.obs;
  var isDeleteButtonLoading = true.obs;
  var selectedPosition = ''.obs;
  var selectedRole = "all".obs;
  var customPositionController = TextEditingController();

  var experiences = <ExperienceModel>[].obs;

  TextEditingController nameController = TextEditingController();
  TextEditingController empIdController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  TextEditingController phoneController = TextEditingController();
  TextEditingController dobController = TextEditingController();
  TextEditingController whatsappController = TextEditingController();
  TextEditingController positionController = TextEditingController();

  @override
  void onInit() {
    super.onInit();
    fetchOtherUsers();
  }

  void updateRole(String role) {
    selectedRole.value = role;
    applyFilters();
  }

  void fetchOtherUsers() async {
    try {
      isLoading.value = true;

      await Future.delayed(const Duration(seconds: 2));

      otherUsers.assignAll([
        OtherUsers(
            id: "EMP1001",
            name: "Maria",
            email: "maria@email.com",
            status: 'Active',
            phone: "123456",
            joinedAt: DateTime.now(),
            role: 'finance'),
        OtherUsers(
            id: "EMP1002",
            name: "Nick",
            status: 'Active',
            email: "nick@email.com",
            phone: "+9876543210",
            joinedAt: DateTime.parse('2024-12-01 09:00:00'),
            role: 'hr'),
        OtherUsers(
            id: "EMP1002",
            name: "Unknown",
            status: 'Active',
            email: "nick@email.com",
            phone: "+9876543210",
            joinedAt: DateTime.parse('2024-12-01 09:00:00'),
            role: 'Intern'),
      ]);

      applyFilters();
    } finally {
      isLoading.value = false;
    }
  }

  void applyFilters() {
    List<OtherUsers> temp = List.from(otherUsers);

    /// 🔍 SEARCH FILTER
    if (searchQuery.value.isNotEmpty) {
      temp = temp.where((t) {
        final name = t.name?.toLowerCase() ?? "";
        return name.contains(searchQuery.value.toLowerCase());
      }).toList();
    }

    /// 🎯 ROLE FILTER
    if (selectedRole.value != "all") {
      temp = temp
          .where((t) =>
              (t.role ?? "").toLowerCase().trim() ==
              selectedRole.value.toLowerCase().trim())
          .toList();
    }

    /// 🔃 SORTING
    switch (sortType.value) {
      case SortType.newest:
        temp.sort((a, b) =>
            (b.joinedAt ?? DateTime(0)).compareTo(a.joinedAt ?? DateTime(0)));
        break;

      case SortType.oldest:
        temp.sort((a, b) =>
            (a.joinedAt ?? DateTime(0)).compareTo(b.joinedAt ?? DateTime(0)));
        break;

      case SortType.name:
        temp.sort((a, b) => (a.name ?? "")
            .toLowerCase()
            .compareTo((b.name ?? "").toLowerCase()));
        break;
    }

    filteredOtherUsers.assignAll(temp);
  }

  final List<FilterOption<String>> roleFilters = [
    FilterOption(label: "All", value: "all", icon: Icons.groups),
    FilterOption(
        label: "Admin", value: "admin", icon: Icons.admin_panel_settings),
    FilterOption(
        label: "Finance", value: "finance", icon: Icons.account_balance_wallet),
    FilterOption(
        label: "Sales Head", value: "sales_head", icon: Icons.show_chart),
    FilterOption(label: "HR", value: "hr", icon: Icons.people),
    FilterOption(
        label: "Advisor", value: "advisor", icon: Icons.person_outline),
    FilterOption(label: "Others", value: "others", icon: Icons.more_horiz),
  ];

  void loadOtherUsers(OtherUsers c) {
    nameController.text = c.name.toString();
    empIdController.text = c.id.toString();
    emailController.text = c.email.toString();
    phoneController.text = c.phone.toString();
    dobController.text = c.dob.toString();
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
}
