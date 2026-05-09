import 'package:albedo_app/model/users/advisor_model.dart';
import 'package:albedo_app/model/users/student_model.dart';
import 'package:albedo_app/model/users/teacher_model.dart';
import 'package:albedo_app/model/users/user_model.dart';
import 'package:albedo_app/view/users/add_teacher_page.dart';
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
  var selectedIndex = 0.obs;
  final RxList<Map<String, dynamic>> accessOverrides =
      <Map<String, dynamic>>[].obs;

  final RxString selectedBranch = ''.obs;
  final RxString selectedBank = ''.obs;

  final RxList<ExperienceFormData> experiences = <ExperienceFormData>[].obs;

  // --------------------------
  // Counts for tabs
  // --------------------------

  List<String> detailedTabs = [
    "Profile",
    "Professional",
    "Students",
    "Access",
  ];
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
    addExperience();
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
            student: [Student(name: 'Riya', studentId: 'STU001')]),
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

  // void addExperience() {
  //   experiences.add(

  //     // Experience(
  //     //   companyName: TextEditingController(),
  //     //   yearController: TextEditingController(),
  //     //   monthController: TextEditingController(),
  //     // ),
  //   );
  // }

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

  void addAdvisor() {}

  bool validateAdvisor(BuildContext context) {
    String error = "";

    /// BASIC DETAILS
    if (nameController.text.trim().isEmpty) {
      error = "Advisor name is required";
    } else if (emailController.text.trim().isEmpty) {
      error = "Email is required";
    } else if (!GetUtils.isEmail(emailController.text.trim())) {
      error = "Enter a valid email address";
    } else if (phoneController.text.trim().isEmpty) {
      error = "Phone number is required";
    } else if (phoneController.text.trim().length < 10) {
      error = "Enter a valid phone number";
    } else if (dobController.text.trim().isEmpty) {
      error = "Joining date is required";
    } else if (qualificationController.text.trim().isEmpty) {
      error = "Qualification is required";
    } else if (addressController.text.trim().isEmpty) {
      error = "Address is required";
    }

    /// EXPERIENCE VALIDATION
    else if (experiences.isEmpty) {
      error = "At least one experience is required";
    } else {
      for (int i = 0; i < experiences.length; i++) {
        final exp = experiences[i];

        if (exp.companyController.text.trim().isEmpty) {
          error = "Company name is required in Experience ${i + 1}";
          break;
        } else if (exp.yearController.text.trim().isEmpty) {
          error = "Years is required in Experience ${i + 1}";
          break;
        } else if (exp.monthController.text.trim().isEmpty) {
          error = "Months is required in Experience ${i + 1}";
          break;
        }
      }
    }

    if (error.isNotEmpty) {
      Get.snackbar(
        "Error",
        error,
        snackPosition: SnackPosition.TOP,
        margin: const EdgeInsets.all(12),
      );

      return false;
    }

    return true;
  }

  void addExperience() {
    experiences.add(ExperienceFormData());
  }

  void removeExperience(int index) {
    experiences[index].dispose();
    experiences.removeAt(index);
  }
}
