import 'package:albedo_app/model/users/coordinator_model.dart';
import 'package:albedo_app/model/users/teacher_model.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

enum SortType { newest, oldest, name }

class CoordinatorController extends GetxController {
  var searchQuery = ''.obs;
  var sortType = SortType.newest.obs;
  var coordinators = <Coordinator>[].obs;
  var selectedTab = 0.obs;
  var filteredCoordinators = <Coordinator>[].obs;
  final tabs = ["Active", "Expired"];
  var isLoading = true.obs;
  var isDeleteButtonLoading = true.obs;
  var isDeactivateButtonLoading = true.obs;
  var isSearching = false.obs;

  var experiences = <ExperienceModel>[].obs;

  // --------------------------
  // Counts for tabs
  // --------------------------

  int get activeCount => coordinators.where((e) => e.status == "Active").length;

  int get expiredCount =>
      coordinators.where((e) => e.status == "Expired").length;

  List<Map<String, dynamic>> get tabData => [
        {"label": "Active", "count": activeCount},
        {"label": "Expired", "count": expiredCount},
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
    fetchCoordinators();
  }

  void fetchCoordinators() async {
    try {
      isLoading.value = true;

      await Future.delayed(const Duration(seconds: 2));

      coordinators.assignAll([
        Coordinator(
          id: "COO1001",
          name: "Maria",
          email: "maria@email.com",
          status: "Active",
          phone: "123456",
          joinedAt: DateTime.now(),
        ),
        Coordinator(
          id: "COO1002",
          name: "Nick",
          email: "nick@email.com",
          status: "Expired",
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
    List<Coordinator> temp = coordinators;

    switch (selectedTab.value) {
      case 0:
        temp = temp.where((t) => t.status == "Active").toList();
        break;

      case 1:
        temp = temp.where((t) => t.status == "Expired").toList();
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

    filteredCoordinators.assignAll(temp);
  }

  void loadCoordinators(Coordinator c) {
    nameController.text = c.name.toString();
    empIdController.text = c.id.toString();
    emailController.text = c.email.toString();
    phoneController.text = c.phone.toString();
    whatsappController.text = c.whatsapp.toString();
    dobController.text = c.dob.toString();
    qualificationController.text = c.qualification.toString();
    placeController.text = c.place.toString();
    pincodeController.text = c.pincode.toString();
    addressController.text = c.address.toString();
    prefLangController.text = c.prefLanguage.toString();
    accountNumberController.text = c.accountNumber.toString();
    accountHolderNameController.text = c.accountHolder.toString();
    upiIdController.text = c.upiId.toString();
    accountTypeController.text = c.accountType.toString();
    bankNameController.text = c.bankName.toString();
    bankBranchController.text = c.bankBranch.toString();
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

}
