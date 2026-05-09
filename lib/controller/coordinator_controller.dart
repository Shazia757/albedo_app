import 'package:albedo_app/model/users/coordinator_model.dart';
import 'package:albedo_app/model/users/mentor_model.dart';
import 'package:albedo_app/model/users/teacher_model.dart';
import 'package:albedo_app/view/users/add_teacher_page.dart';
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
  var selectedDate = Rxn<DateTime>();
  final RxString selectedBranch = ''.obs;
  final RxString selectedBank = ''.obs;
  final RxString selectedTimezone = ''.obs;
  var selectedIndex = 0.obs;
  final RxList<Map<String, dynamic>> accessOverrides =
      <Map<String, dynamic>>[].obs;

  final RxList<ExperienceFormData> experiences = <ExperienceFormData>[].obs;

  List<String> detailedTabs = [
    "Profile",
    "Professional",
    "Mentors",
    "Wallet",
  ];
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
  TextEditingController ifscController = TextEditingController();
  TextEditingController resumeController = TextEditingController();

  final Map<String, List<String>> bankBranches = {
    'State Bank of India': [
      'Kayamkulam',
      'Mavelikkara',
      'Haripad',
    ],
    'HDFC Bank': [
      'Kayamkulam',
      'Alappuzha',
      'Kollam',
    ],
    'ICICI Bank': [
      'Kayamkulam',
      'Karunagappally',
    ],
    'Federal Bank': [
      'Kayamkulam',
      'Cherthala',
    ],
  };

  @override
  void onInit() {
    super.onInit();
    fetchCoordinators();
    addExperience();
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
            mentor: [
              Mentor(name: 'Joy', empId: 'MEN001'),
              Mentor(name: 'Naila', empId: 'MEN002')
            ]),
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

  // void addExperience() {
  //   experiences.add(
  //     Experience(
  //       companyController: TextEditingController(),
  //       yearController: TextEditingController(),
  //       monthController: TextEditingController(),
  //     ),
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

  resign(String id) {
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

  void addCoordinator() {}

  bool validateCoordinator(BuildContext context) {
    String error = "";

    /// BASIC DETAILS
    if (nameController.text.trim().isEmpty) {
      error = "Coordinator name is required";
    } else if (emailController.text.trim().isEmpty) {
      error = "Email is required";
    } else if (!GetUtils.isEmail(emailController.text.trim())) {
      error = "Enter a valid email address";
    } else if (phoneController.text.trim().isEmpty) {
      error = "Phone number is required";
    } else if (phoneController.text.trim().length < 10) {
      error = "Enter a valid phone number";
    } else if (placeController.text.trim().isEmpty) {
      error = "Place is required";
    } else if (pincodeController.text.trim().isEmpty) {
      error = "Pincode is required";
    } else if (pincodeController.text.trim().length < 5) {
      error = "Enter a valid pincode";
    } else if (addressController.text.trim().isEmpty) {
      error = "Address is required";
    } else if (dobController.text.trim().isEmpty) {
      error = "Date of birth is required";
    } else if (qualificationController.text.trim().isEmpty) {
      error = "Qualification is required";
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

    /// BANK DETAILS
    if (error.isEmpty && accountNumberController.text.trim().isEmpty) {
      error = "Account number is required";
    } else if (error.isEmpty &&
        accountHolderNameController.text.trim().isEmpty) {
      error = "Account holder name is required";
    } else if (error.isEmpty && ifscController.text.trim().isEmpty) {
      error = "IFSC code is required";
    } else if (error.isEmpty && resumeController.text.trim().isEmpty) {
      error = "Resume URL is required";
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
