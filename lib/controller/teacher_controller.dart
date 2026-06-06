import 'dart:developer';

import 'package:albedo_app/api.dart';
import 'package:albedo_app/config/urls.dart';
import 'package:albedo_app/controller/auth_controller.dart';
import 'package:albedo_app/model/batch_model.dart';
import 'package:albedo_app/model/package_model.dart';
import 'package:albedo_app/model/session_model.dart';
import 'package:albedo_app/model/users/advisor_model.dart';
import 'package:albedo_app/model/users/coordinator_model.dart';
import 'package:albedo_app/model/users/mentor_model.dart';
import 'package:albedo_app/model/users/student_model.dart';
import 'package:albedo_app/model/users/teacher_model.dart';
import 'package:albedo_app/model/users/user_model.dart';
import 'package:albedo_app/view/users/add_teacher_page.dart';
import 'package:albedo_app/widgets/widgets.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

enum SortType { newest, oldest, name }

class TeacherController extends GetxController {
  final AuthController auth = Get.find();

  var teachers = <Teacher>[].obs;
  var filteredTeachers = <Teacher>[].obs;
  final tabs = ["All", "Active", "Batch", "Inactive"];
  var selectedTab = 0.obs;
  var selectedDate = Rxn<DateTime>();
  final RxString selectedBank = ''.obs;
  var selectedFromDate = Rxn<DateTime>();
  var selectedUntilDate = Rxn<DateTime>();
  final RxString selectedTimezone = ''.obs;
  final RxString selectedBranch = ''.obs;

  final RxList<ExperienceFormData> experiences = <ExperienceFormData>[].obs;

  var searchQuery = ''.obs;
  var sortType = SortType.newest.obs;
  var isSearching = false.obs;
  var isLoading = true.obs;
  var isDeleteButtonLoading = true.obs;
  var isDeactivateButtonLoading = true.obs;
  RxBool isActive = false.obs;
  RxString status = "Demo Pending".obs;
  var selectedIndex = 0.obs;
  RxString selectedFilter = "All".obs;
  final RxBool obscurePassword = true.obs;
  final RxBool obscureNewPassword = true.obs;
  final RxBool obscureConfirmPassword = true.obs;
  final RxBool showUnlockForm = false.obs;
  final RxBool selectAllStudents = false.obs;

  final RxString unlockFrom = ''.obs;
  final RxString unlockTo = ''.obs;
  final RxString reLockAfter = ''.obs;
  final allCount = 0.obs;
  final activeCount = 0.obs;
  final batchCount = 0.obs;
  final inactiveCount = 0.obs;
  final totalCount = 0.obs;
  final currentPage = 0.obs;

  final RxString targetType = 'All Students'.obs;

  RxInt feedbackTabIndex = 0.obs;

  List<Map<String, dynamic>> get tabData => [
        {"label": "All", "count": allCount.value},
        {"label": "Active", "count": activeCount.value},
        {"label": "Batch", "count": batchCount.value},
        {"label": "Inactive", "count": inactiveCount.value},
      ];

  List<String> detailedTabs = [
    "Profile",
    "Professional",
    "Students",
    "Batches",
    "Wallet",
    "Feedback",
    "Access"
  ];

  List<String> feedbackTabs = ['Student', 'Mentor'];

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
  TextEditingController usernameController = TextEditingController();
  TextEditingController currentPasswordController = TextEditingController();
  TextEditingController newPasswordController = TextEditingController();
  TextEditingController confirmNewPasswordController = TextEditingController();
  TextEditingController startDateController = TextEditingController();
  TextEditingController endDateController = TextEditingController();
  TextEditingController relockController = TextEditingController();
  final ifscController = TextEditingController();
  final resumeController = TextEditingController();
  final demoController = TextEditingController();

  final RxList<Map<String, dynamic>> students = [
    {"id": "STU001", "name": "Amina"},
    {"id": "STU002", "name": "Rayan"},
    {"id": "STU003", "name": "Sara"},
  ].obs;

  final RxList<Map<String, dynamic>> selectedStudents =
      <Map<String, dynamic>>[].obs;

  @override
  void onInit() {
    super.onInit();
    loadTeacherTabCounts();
    fetchTeachers();
    selectedStudents.add({
      "id": "all",
      "name": "All Students",
    });
    addExperience();
  }

  Future<void> fetchTeachers() async {
    try {
      isLoading.value = true;
      String url = Urls.teachers;

      switch (selectedTab.value) {
        case 1:
          url = "${Urls.teachers}?is_live=true";
          break;

        case 2:
          url = Urls.teachersWithBatches;
          break;

        case 3:
          url = "${Urls.teachers}?is_live=false";
          break;

        default:
          url = Urls.teachers;
      }

      final response = await Api().getTeacherDetails(
        url: url,
        page: currentPage.value + 1,
        pageSize: 10,
      );

      teachers.assignAll(response.results);

      totalCount.value = response.count;

      applyFilters();
    } catch (e) {
      log(e.toString());
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> loadTeacherTabCounts() async {
    try {
      final all = await Api().getTeacherDetails(
        url: Urls.teachers,
        page: 1,
        pageSize: 1,
      );

      final active = await Api().getTeacherDetails(
        url: "${Urls.teachers}?is_live=true",
        page: 1,
        pageSize: 1,
      );

      final batch = await Api().getTeacherDetails(
        url: Urls.teachersWithBatches,
        page: 1,
        pageSize: 1,
      );

      final inactive = await Api().getTeacherDetails(
        url: "${Urls.teachers}?is_live=false",
        page: 1,
        pageSize: 1,
      );

      allCount.value = all.count;
      activeCount.value = active.count;
      batchCount.value = batch.count;
      inactiveCount.value = inactive.count;
    } catch (e) {
      log(e.toString());
    }
  }

  Users teacherToUser(Teacher t) {
    return Users(
      empId: t.id,
      name: t.name,
      role: "teacher",
    );
  }

  void applyFilters() {
    List<Teacher> temp = teachers;

    if (searchQuery.value.isNotEmpty) {
      temp = temp
          .where((t) =>
              t.name.toLowerCase().contains(searchQuery.value.toLowerCase()))
          .toList();
    }

    // Sort
    if (sortType.value == SortType.newest) {
      temp.sort(
        (a, b) => (b.joinedAt ?? DateTime(1900))
            .compareTo(a.joinedAt ?? DateTime(1900)),
      );
    } else if (sortType.value == SortType.oldest) {
      temp.sort(
        (a, b) => (a.joinedAt ?? DateTime(1900))
            .compareTo(b.joinedAt ?? DateTime(1900)),
      );
    } else if (sortType.value == SortType.name) {
      temp.sort(
        (a, b) => a.name.toLowerCase().compareTo(
              b.name.toLowerCase(),
            ),
      );
    }

    filteredTeachers.assignAll(temp);
  }

  final RxMap<String, List<Map<String, dynamic>>> studentFeedbacks =
      <String, List<Map<String, dynamic>>>{
    'T001': [
      {
        "id": "FDB001",
        "student_name": "Amina",
        "rating": 4.8,
        "message":
            "Very supportive teacher. The sessions were easy to understand.",
        "date": "2026-05-01",
      },
    ],
    'TEA002': [
      {
        "id": "FDB010",
        "student_name": "Hiba",
        "rating": 5.0,
        "message": "Very interactive classes.",
        "date": "2026-05-04",
      },
    ],
  }.obs;
  final RxMap<String, List<Map<String, dynamic>>> mentorFeedbacks =
      <String, List<Map<String, dynamic>>>{
    'TEA001': [
      {
        "id": "MFB001",
        "mentor_name": "Shahid",
        "rating": 4.5,
        "message": "Teacher manages students well and maintains consistency.",
        "date": "2026-05-02",
      },
    ],
  }.obs;
  final RxList<Map<String, dynamic>> accessOverrides =
      <Map<String, dynamic>>[].obs;

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

  void handleDelete(BuildContext context, Teacher teacher) {
    final user = auth.activeUser;

    if (user?.role == "coordinator") {
      CustomWidgets().showDeleteDialog(
        dltText: Obx(
          () => isLoading.value
              ? const SizedBox(
                  width: 18,
                  height: 18,
                  child: CircularProgressIndicator(
                    strokeWidth: 2,
                    color: Colors.white,
                  ),
                )
              : Text(
                  "Yes",
                  style: Theme.of(context)
                      .textTheme
                      .titleSmall!
                      .copyWith(color: Colors.white),
                ),
        ),
        title: 'Are you sure?',
        context: context,
        text: "Do you want to request deletion of this teacher?",
        onConfirm: () => requestDelete(teacher.id),
      );
    } else {
      CustomWidgets().showDeleteDialog(
        dltText: Obx(
          () => isLoading.value
              ? const SizedBox(
                  width: 18,
                  height: 18,
                  child: CircularProgressIndicator(
                    strokeWidth: 2,
                    color: Colors.white,
                  ),
                )
              : Text(
                  "Yes",
                  style: Theme.of(context)
                      .textTheme
                      .titleSmall!
                      .copyWith(color: Colors.white),
                ),
        ),
        title: 'Are you sure?',
        context: context,
        text: "Are you sure you want to delete this teacher permanently?",
        onConfirm: () => delete(teacher.id),
      );
    }
  }

  void handleDeactivate(BuildContext context, Teacher teacher) {
    final user = auth.activeUser;

    if (user?.role == "coordinator") {
      CustomWidgets().showDeactivateDialog(
        context: context,
        text: "Do you want to request inactivation for this teacher?",
        onConfirm: () => requestDeactivate(teacher.id),
      );
    } else {
      CustomWidgets().showDeactivateDialog(
        context: context,
        text: "Are you sure you want to deactivate this teacher permanently?",
        onConfirm: () => deactivate(teacher.id),
      );
    }
  }

  deactivate(String id) {
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

  void requestDeactivate(String studentId) {
    print("Request sent to deactivate student: $studentId");

    // TODO:
    // Call API → create approval request
    // Show snackbar
  }

  void requestDelete(String studentId) {
    print("Request sent to delete student: $studentId");

    // TODO:
    // Call API → create approval request
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

  void addExperience() {
    experiences.add(ExperienceFormData());
  }

  void removeExperience(int index) {
    experiences[index].dispose();
    experiences.removeAt(index);
  }

  void addTeacher() {}

  bool validateTeacher(BuildContext context) {
    String error = "";

    if (nameController.text.trim().isEmpty) {
      error = "Teacher name is required";
    } else if (emailController.text.trim().isEmpty) {
      error = "Email is required";
    } else if (!GetUtils.isEmail(emailController.text.trim())) {
      error = "Enter a valid email address";
    } else if (phoneController.text.trim().isEmpty) {
      error = "Phone number is required";
    } else if (phoneController.text.trim().length < 10) {
      error = "Enter a valid phone number";
    } else if (genderController.text.trim().isEmpty) {
      error = "Gender is required";
    } else if (dobController.text.trim().isEmpty) {
      error = "Date of birth is required";
    } else if (qualificationController.text.trim().isEmpty) {
      error = "Qualification is required";
    } else if (placeController.text.trim().isEmpty) {
      error = "Place is required";
    } else if (pincodeController.text.trim().isEmpty) {
      error = "Pincode is required";
    } else if (pincodeController.text.trim().length < 5) {
      error = "Enter a valid pincode";
    } else if (addressController.text.trim().isEmpty) {
      error = "Address is required";
    } else if (selectedTimezone.value.trim().isEmpty) {
      error = "Please select a time zone";
    } else if (prefLangController.text.trim().isEmpty) {
      error = "Preferred language is required";
    } else if (tutionModeController.text.trim().isEmpty) {
      error = "Tuition mode is required";
    }

    /// Experience Validation
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

    /// Bank Details
    if (error.isEmpty && accountNumberController.text.trim().isEmpty) {
      error = "Account number is required";
    } else if (error.isEmpty &&
        accountHolderNameController.text.trim().isEmpty) {
      error = "Account holder name is required";
    } else if (error.isEmpty && selectedBank.value.trim().isEmpty) {
      error = "Please select a bank";
    } else if (error.isEmpty && selectedBranch.value.trim().isEmpty) {
      error = "Please select a branch";
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

  updateTeacher() {}
}
