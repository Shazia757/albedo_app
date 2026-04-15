import 'package:albedo_app/controller/session_controller.dart';
import 'package:albedo_app/model/teacher_model.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class TeacherController extends GetxController {
  var teachers = <Teacher>[].obs;
  var filteredTeachers = <Teacher>[].obs;

  var selectedTab = 0.obs;
  var searchQuery = ''.obs;
  var sortType = SortType.newest.obs;
  var isLoading = true.obs;
  var isDeleteButtonLoading = true.obs;

  // --------------------------
  // Counts for tabs
  // --------------------------
  int get allCount => teachers.length;

  int get activeCount => teachers.where((e) => e.status == "Active").length;

  int get batchCount => teachers.where((e) => e.type == "Batch").length;

  int get inactiveCount => teachers.where((e) => e.status == "Inactive").length;

  List<Map<String, dynamic>> get tabData => [
        {"label": "All", "count": allCount},
        {"label": "Active", "count": activeCount},
        {"label": "Batch", "count": batchCount},
        {"label": "Inactive", "count": inactiveCount},
      ];

  // 🎯 Teacher-specific fields
  TextEditingController nameController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  TextEditingController phoneController = TextEditingController();
  TextEditingController teacherIdController = TextEditingController();
  TextEditingController whatsappController = TextEditingController();
  TextEditingController genderController = TextEditingController();
  TextEditingController placeController = TextEditingController();
  TextEditingController pincodeController = TextEditingController();
  TextEditingController addressController = TextEditingController();
  TextEditingController timezoneController = TextEditingController();
  TextEditingController dobController = TextEditingController();
  TextEditingController qualificationController = TextEditingController();
  TextEditingController prefLangController = TextEditingController();
  TextEditingController tutionModeController = TextEditingController();
  TextEditingController accountNumberController = TextEditingController();
  TextEditingController accountHolderNameController = TextEditingController();
  TextEditingController upiIdController = TextEditingController();
  TextEditingController accountTypeController = TextEditingController();
  TextEditingController bankNameController = TextEditingController();
  TextEditingController branchNameController = TextEditingController();
  TextEditingController bankBranchController = TextEditingController();

  var experiences = <ExperienceModel>[].obs;

  @override
  void onInit() {
    super.onInit();
    fetchTeachers();
  }

  void fetchTeachers() async {
    try {
      isLoading.value = true;

      await Future.delayed(const Duration(seconds: 2));

      teachers.assignAll([
        Teacher(
            id: "TEA1001",
            name: "John",
            email: "john@email.com",
            status: "Active",
            type: "Batch",
            phone: "123456",
            joinedAt: DateTime.now(),
            gender: 'Male'),
        Teacher(
            id: "TEA1002",
            name: "Ms. Smith",
            email: "smith@email.com",
            status: "Inactive",
            type: "Batch",
            phone: "+9876543210",
            joinedAt: DateTime.parse('2024-12-01 09:00:00'),
            gender: 'Female'),
      ]);

      applyFilters();
    } finally {
      isLoading.value = false;
    }
  }

  void applyFilters() {
    List<Teacher> temp = teachers;

    switch (selectedTab.value) {
      case 1:
        temp = temp.where((t) => t.status == "Active").toList();
        break;
      case 2:
        temp = temp.where((t) => t.type == "Batch").toList();
        break;
      case 3:
        temp = temp.where((t) => t.status == "Inactive").toList();
        break;
    }

    if (searchQuery.value.isNotEmpty) {
      temp = temp
          .where((t) =>
              t.name.toLowerCase().contains(searchQuery.value.toLowerCase()))
          .toList();
    }

    filteredTeachers.assignAll(temp);
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

  void loadTeachers(Teacher teacher) {
    nameController.text = teacher.name.toString();
    emailController.text = teacher.email.toString();
    phoneController.text = teacher.phone.toString();
    whatsappController.text = teacher.whatsapp.toString();
    genderController.text = teacher.gender.toString();
    placeController.text = teacher.place.toString();
    pincodeController.text = teacher.pincode.toString();
    addressController.text = teacher.address.toString();
    timezoneController.text = teacher.timezone.toString();
    tutionModeController.text = teacher.tuitionMode.toString();
    accountNumberController.text = teacher.accountNumber.toString();
    accountHolderNameController.text = teacher.accountHolder.toString();
    upiIdController.text = teacher.upiId.toString();
    accountTypeController.text = teacher.accountType.toString();
    bankNameController.text = teacher.bankName.toString();
    bankBranchController.text = teacher.bankBranch.toString();
  }

  delete(String id) {
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
