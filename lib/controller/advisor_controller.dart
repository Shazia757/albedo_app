import 'package:albedo_app/model/users/advisor_model.dart';
import 'package:albedo_app/model/users/teacher_model.dart';
import 'package:albedo_app/model/users/user_model.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

enum SortType { newest, oldest, name }

class AdvisorController extends GetxController {
  var searchQuery = ''.obs;
  var sortType = SortType.newest.obs;
  var advisors = <Advisor>[].obs;
  var selectedTab = 0.obs;
  var filteredAdvisors = <Advisor>[].obs;
  final tabs = ["Active", "Expired"];
  var isLoading = true.obs;
  var isSearching = false.obs;
  var isDeleteButtonLoading = true.obs;
  var isDeactivateButtonLoading = true.obs;

  var experiences = <ExperienceModel>[].obs;

  // --------------------------
  // Counts for tabs
  // --------------------------

  int get activeCount => advisors.where((e) => e.status == "Active").length;

  int get inactiveCount => advisors.where((e) => e.status == "Inactive").length;

  List<Map<String, dynamic>> get tabData => [
        {"label": "Active", "count": activeCount},
        {"label": "Expired", "count": inactiveCount},
      ];

  TextEditingController nameController = TextEditingController();
  TextEditingController empIdController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  TextEditingController phoneController = TextEditingController();
  TextEditingController dobController = TextEditingController();
  TextEditingController whatsappController = TextEditingController();
  TextEditingController qualificationController = TextEditingController();
  TextEditingController placeController = TextEditingController();
  TextEditingController pincodeController = TextEditingController();
  TextEditingController addressController = TextEditingController();
  TextEditingController prefLangController = TextEditingController();
  TextEditingController accountNumberController = TextEditingController();
  TextEditingController accountHolderNameController = TextEditingController();
  TextEditingController upiIdController = TextEditingController();
  TextEditingController accountTypeController = TextEditingController();
  TextEditingController bankNameController = TextEditingController();
  TextEditingController branchNameController = TextEditingController();
  TextEditingController bankBranchController = TextEditingController();

  @override
  void onInit() {
    super.onInit();
    fetchAdvisors();
  }

  void fetchAdvisors() async {
    try {
      isLoading.value = true;

      await Future.delayed(const Duration(seconds: 2));

      advisors.assignAll([
        Advisor(
          id: "ADV1001",
          name: "Anjana",
          email: "anjana@email.com",
          status: "Active",
          phone: "123456",
          joinedAt: DateTime.now(),
        ),
        Advisor(
          id: "ADV1002",
          name: "Ardra",
          email: "ardra@email.com",
          status: "Inactive",
          phone: "+9876543210",
          joinedAt: DateTime.parse('2024-12-01 09:00:00'),
        ),
      ]);

      applyFilters();
    } finally {
      isLoading.value = false;
    }
  }

  void applyFilters() {
    List<Advisor> temp = advisors;

    switch (selectedTab.value) {
      case 0:
        temp = temp.where((t) => t.status == "Active").toList();
        break;

      case 1:
        temp = temp.where((t) => t.status == "Inactive").toList();
        break;
    }

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

    filteredAdvisors.assignAll(temp);
  }

  void loadAdvisors(Advisor a) {
    nameController.text = a.name.toString();
    empIdController.text = a.id.toString();
    emailController.text = a.email.toString();
    phoneController.text = a.phone.toString();
    whatsappController.text = a.whatsapp.toString();
    dobController.text = a.dob.toString();
    qualificationController.text = a.qualification.toString();
    placeController.text = a.place.toString();
    pincodeController.text = a.pincode.toString();
    addressController.text = a.address.toString();
  }

  void addExperience() {
    experiences.add(
      ExperienceModel(
        companyController: TextEditingController(),
        yearController: TextEditingController(),
        monthController: TextEditingController(),
      ),
    );
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

     deactivate(String id) {
    isDeactivateButtonLoading.value = true;
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

Users advisorToUser(Advisor a) {
  return Users(
    id: a.id,
    name: a.name,
    role: "advisor",
  );
}
}
