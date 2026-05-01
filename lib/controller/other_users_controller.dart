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
            role: 'Finance'),
        OtherUsers(
          id: "EMP1002",
          name: "Nick",
          status: 'Active',
          email: "nick@email.com",
          phone: "+9876543210",
          joinedAt: DateTime.parse('2024-12-01 09:00:00'),
          role: 'HR'
        ),
      ]);

      applyFilters();
    } finally {
      isLoading.value = false;
    }
  }

  void applyFilters() {
    List<OtherUsers> temp = otherUsers;

    if (searchQuery.value.isNotEmpty) {
      temp = temp
          .where((t) =>
              t.name.toLowerCase().contains(searchQuery.value.toLowerCase()))
          .toList();
    }

    // Sort
    if (sortType.value == SortType.newest) {
      temp.sort((a, b) => b.joinedAt.compareTo(a.joinedAt));
    } else if (sortType.value == SortType.oldest) {
      temp.sort((a, b) => a.joinedAt.compareTo(b.joinedAt));
    } else if (sortType.value == SortType.name) {
      temp.sort((a, b) => a.name.compareTo(b.name));
    }

    filteredOtherUsers.assignAll(temp);
  }

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
