import 'package:albedo_app/controller/auth_controller.dart';
import 'package:albedo_app/model/session_model.dart';
import 'package:albedo_app/model/users/coordinator_model.dart';
import 'package:albedo_app/model/users/mentor_model.dart';
import 'package:albedo_app/model/users/teacher_model.dart';
import 'package:albedo_app/view/users/add_teacher_page.dart';
import 'package:albedo_app/widgets/widgets.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

enum SortType { newest, oldest, name }

class MentorController extends GetxController {
  final AuthController auth = Get.find();

  var searchQuery = ''.obs;
  var sortType = SortType.newest.obs;
  var mentors = <Mentor>[].obs;
  var selectedTab = 0.obs;
  var filteredMentors = <Mentor>[].obs;
  var tabs = <String>[].obs;
  var isSearching = false.obs;
  var isLoading = true.obs;
  var isDeleteButtonLoading = true.obs;
  var isDeactivateButtonLoading = true.obs;
  var selectedIndex = 0.obs;
  final RxBool obscurePassword = true.obs;
  final RxBool obscureNewPassword = true.obs;
  final RxBool obscureConfirmPassword = true.obs;
  final RxBool showUnlockForm = false.obs;
  final RxBool selectAllStudents = false.obs;
  var selectedFromDate = Rxn<DateTime>();
  var selectedUntilDate = Rxn<DateTime>();
  final RxList<Map<String, dynamic>> selectedStudents =
      <Map<String, dynamic>>[].obs;

  final RxString unlockFrom = ''.obs;
  final RxString unlockTo = ''.obs;
  final RxString reLockAfter = ''.obs;

  final RxString targetType = 'All Students'.obs;

  RxInt feedbackTabIndex = 0.obs;

  List<String> feedbackTabs = ['Student', 'Teacher'];

  final RxList<Map<String, dynamic>> studentFeedbacks = <Map<String, dynamic>>[
    {
      "id": "FDB001",
      "student_name": "Amina",
      "rating": 4.8,
      "message":
          "Very supportive teacher. The sessions were easy to understand.",
      "date": "2026-05-01",
    },
    {
      "id": "FDB002",
      "student_name": "Rayan",
      "rating": 5.0,
      "message": "Excellent teaching style and good communication throughout.",
      "date": "2026-05-03",
    },
  ].obs;

  final RxList<Map<String, dynamic>> teacherFeedbacks = <Map<String, dynamic>>[
    {
      "id": "MFB001",
      "mentor_name": "Shahid",
      "rating": 4.5,
      "message": "Teacher manages students well and maintains consistency.",
      "date": "2026-05-02",
    },
    {
      "id": "MFB002",
      "mentor_name": "Nihal",
      "rating": 4.9,
      "message":
          "Very professional and active in handling batch responsibilities.",
      "date": "2026-05-05",
    },
  ].obs;

  final ratingFilters = [
    FilterOption<int>(label: "All", value: 0, icon: Icons.filter_alt),
    FilterOption<int>(label: "2 & Up", value: 2, icon: Icons.star),
    FilterOption<int>(label: "3 & Up", value: 3, icon: Icons.star),
    FilterOption<int>(label: "4 & Up", value: 4, icon: Icons.star),
  ];
  var selectedRating = 0.obs; // 0 = All
  final RxString selectedAccountType = ''.obs;

  final RxList<ExperienceFormData> experiences = <ExperienceFormData>[].obs;

  final RxList<Map<String, dynamic>> accessOverrides =
      <Map<String, dynamic>>[].obs;

  List<String> detailedTabs = [
    "Profile",
    "Professional",
    "Students",
    "Wallet",
    "Star of Month",
    "Feedbacks",
    "Access"
  ];
  // --------------------------
  // Counts for tabs
  // --------------------------

  int getCount(int index) {
    if (tabs.isEmpty || index >= tabs.length) return 0;

    final tab = tabs[index];

    if (tab == "All") return mentors.length;

    if (tab == "Unassigned") {
      return mentors.where((m) => m.coordinator == null).length;
    }

    return mentors.where((m) => m.coordinator?.name == tab).length;
  }

  TextEditingController nameController = TextEditingController();
  TextEditingController empIdController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  TextEditingController phoneController = TextEditingController();
  TextEditingController dobController = TextEditingController();
  TextEditingController whatsappController = TextEditingController();
  TextEditingController timezoneController = TextEditingController();
  TextEditingController qualificationController = TextEditingController();
  TextEditingController placeController = TextEditingController();
  TextEditingController pincodeController = TextEditingController();
  TextEditingController addressController = TextEditingController();
  TextEditingController prefLangController = TextEditingController();
  TextEditingController accountNumberController = TextEditingController();
  TextEditingController accountHolderNameController = TextEditingController();
  TextEditingController upiIdController = TextEditingController();
  TextEditingController ifscController = TextEditingController();
  TextEditingController resumeController = TextEditingController();
  TextEditingController accountTypeController = TextEditingController();
  TextEditingController bankNameController = TextEditingController();
  TextEditingController branchNameController = TextEditingController();
  TextEditingController bankBranchController = TextEditingController();
  TextEditingController usernameController = TextEditingController();
  TextEditingController currentPasswordController = TextEditingController();
  TextEditingController newPasswordController = TextEditingController();
  TextEditingController confirmNewPasswordController = TextEditingController();
  TextEditingController m1Controller = TextEditingController();
  TextEditingController m2Controller = TextEditingController();
  TextEditingController m3Controller = TextEditingController();
  TextEditingController m4Controller = TextEditingController();
  TextEditingController m5Controller = TextEditingController();
  TextEditingController startDateController = TextEditingController();
  TextEditingController endDateController = TextEditingController();
  TextEditingController relockController = TextEditingController();

  final RxList<Map<String, dynamic>> students = [
    {"id": "STU001", "name": "Amina"},
    {"id": "STU002", "name": "Rayan"},
    {"id": "STU003", "name": "Sara"},
  ].obs;

  @override
  void onInit() {
    super.onInit();
    fetchMentors();
    addExperience();
    selectedStudents.add({
      "id": "all",
      "name": "All Students",
    });
  }

  Future<void> fetchMentors() async {
    try {
      isLoading.value = true;

      final user = auth.activeUser;

      await Future.delayed(const Duration(seconds: 2));

      final allMentors = _getDummyMentors();

      List<Mentor> result;

      if (user?.role == "admin") {
        result = allMentors;
      } else if (user?.role == "coordinator") {
        result =
            allMentors.where((m) => m.coordinator?.id == user!.id).toList();
      } else if (user?.role == "mentor") {
        // Mentor should usually see only themselves
        result = allMentors.where((m) => m.id == user!.id).toList();
      } else {
        result = [];
      }

      mentors.assignAll(result);
      buildTabs();
      applyFilters();
    } catch (e) {
      print("Error: $e");
    } finally {
      isLoading.value = false;
    }
  }

  void buildTabs() {
    final coordinatorNames = mentors
        .map((m) => m.coordinator?.name)
        .whereType<String>() // removes null safely
        .toSet()
        .toList()
      ..sort();

    tabs.value = [
      "All",
      ...coordinatorNames,
      "Unassigned",
    ];

    selectedTab.value = 0;
  }

  List<Mentor> _getDummyMentors() {
    return [
      Mentor(
        empId: "MTR1001",
        name: "Maria",
        status: "Active",
        phone: "123456",
        joinedAt: DateTime.now(),
        coordinator: Coordinator(
          id: "COO1001",
          name: "Ameen",
          joinedAt: DateTime.now(),
        ),
      ),
      Mentor(
        empId: "MTR1002",
        name: "Nick",
        status: "Inactive",
        phone: "+9876543210",
        joinedAt: DateTime.parse('2024-12-01 09:00:00'),
        coordinator: Coordinator(
          id: "COO1002",
          name: "Rahul",
          joinedAt: DateTime.now(),
        ),
      ),
      Mentor(
        empId: "MTR1003",
        name: "Sara",
        status: "Active",
        phone: "55555",
        joinedAt: DateTime.now(),
        coordinator: null, // 👈 Unassigned
      ),
    ];
  }

  void applyFilters() {
    if (tabs.isEmpty) return;

    List<Mentor> temp = mentors;

    final selected = tabs[selectedTab.value];

    // 🎯 Tab filter
    if (selected == "All") {
      // no filter
    } else if (selected == "Unassigned") {
      temp = temp.where((t) => t.coordinator == null).toList();
    } else {
      temp = temp.where((t) => t.coordinator?.name == selected).toList();
    }

    if (selectedRating.value != 0) {
      temp =
          temp.where((t) => (t.rating ?? 0) >= selectedRating.value).toList();
    }

    // 🔍 Search
    if (searchQuery.value.isNotEmpty) {
      temp = temp
          .where((t) =>
              t.name.toLowerCase().contains(searchQuery.value.toLowerCase()))
          .toList();
    }

    // 🔃 Sort
    if (sortType.value == SortType.newest) {
      temp.sort((a, b) {
        final aDate = a.joinedAt ?? DateTime.fromMillisecondsSinceEpoch(0);
        final bDate = b.joinedAt ?? DateTime.fromMillisecondsSinceEpoch(0);
        return bDate.compareTo(aDate);
      });
    } else if (sortType.value == SortType.oldest) {
      temp.sort((a, b) {
        final aDate = a.joinedAt ?? DateTime.fromMillisecondsSinceEpoch(0);
        final bDate = b.joinedAt ?? DateTime.fromMillisecondsSinceEpoch(0);
        return aDate.compareTo(bDate);
      });
    } else if (sortType.value == SortType.name) {
      temp.sort((a, b) => a.name.compareTo(b.name));
    }

    filteredMentors.assignAll(temp);
  }

  void loadMentors(Mentor c) {
    nameController.text = c.name.toString();
    empIdController.text = c.id.toString();
    emailController.text = c.email.toString();
    phoneController.text = c.phone.toString();
    whatsappController.text = c.whatsapp.toString();
    timezoneController.text = c.timezone.toString();
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

  void handleDelete(BuildContext context, Mentor mentor) {
    final user = auth.activeUser;

    if (user?.role == "coordinator") {
      CustomWidgets().showDeleteDialog(
        title: 'Are you sure?',

        context: context,
        text: "Do you want to request deletion of this mentor?",
        onConfirm: () => requestDelete(mentor.id!),
      );
    } else {
      CustomWidgets().showDeleteDialog(
        title: 'Are you sure?',

        context: context,
        text: "Are you sure you want to delete this mentor permanently?",
        onConfirm: () => delete(mentor.id!),
      );
    }
  }

  void handleResign(BuildContext context, Mentor mentor) {
    final user = auth.activeUser;

    if (user?.role == "coordinator") {
      CustomWidgets().showDeactivateDialog(
        context: context,
        text: "Do you want to request resignation for this mentor?",
        onConfirm: () => requestDeactivate(mentor.id!),
      );
    } else {
      CustomWidgets().showDeactivateDialog(
        context: context,
        text: "Are you sure you want to resign this mentor permanently?",
        onConfirm: () => resign(mentor.id!),
      );
    }
  }

  resign(String id) {
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

  void requestDeactivate(String mentorId) {
    print("Request sent to deactivate mentor: $mentorId");

    // TODO:
    // Call API → create approval request
    // Show snackbar
  }

  void requestDelete(String mentorId) {
    print("Request sent to delete mentor: $mentorId");

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

  void addMentor() {}

  bool validateMentor(BuildContext context) {
    String error = "";

    /// BASIC DETAILS
    if (nameController.text.trim().isEmpty) {
      error = "Mentor name is required";
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
