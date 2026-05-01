import 'package:albedo_app/controller/auth_controller.dart';
import 'package:albedo_app/model/users/coordinator_model.dart';
import 'package:albedo_app/model/users/mentor_model.dart';
import 'package:albedo_app/model/users/teacher_model.dart';
import 'package:albedo_app/model/users/user_model.dart';
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

  var searchQuery = ''.obs;
  var sortType = SortType.newest.obs;
  var isSearching = false.obs;
  var isLoading = true.obs;
  var isDeleteButtonLoading = true.obs;
  var isDeactivateButtonLoading = true.obs;

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

  Future<void> fetchTeachers() async {
    try {
      isLoading.value = true;

      final user = auth.activeUser;

      await Future.delayed(const Duration(seconds: 2));

      final allTeachers = _getDummyTeachers();

      List<Teacher> result;

      if (user?.role == "admin") {
        result = allTeachers;
      } else if (user?.role == "coordinator") {
        result =
            allTeachers.where((t) => t.coordinator?.id == user!.id).toList();
      } else if (user?.role == "mentor") {
        result = allTeachers.where((t) => t.mentor?.id == user!.id).toList();
      } else {
        result = []; // teachers shouldn't see other teachers usually
      }

      teachers.assignAll(result);
      applyFilters();
    } catch (e) {
      print("Error: $e");
    } finally {
      isLoading.value = false;
    }
  }

  List<Teacher> _getDummyTeachers() {
    return [
      Teacher(
          id: "TEA1001",
          name: "John",
          email: "john@email.com",
          status: "Active",
          type: "Batch",
          phone: "123456",
          joinedAt: DateTime.now(),
          gender: 'Male',
          coordinator: Coordinator(name: '', id: '', joinedAt: DateTime.now()),
          mentor: Mentor(
            name: '',
            id: '',
            joinedAt: DateTime.now(),
          )),
      Teacher(
        id: "TEA1002",
        name: "Ms. Smith",
        email: "smith@email.com",
        status: "Inactive",
        type: "Batch",
        phone: "+9876543210",
        joinedAt: DateTime.parse('2024-12-01 09:00:00'),
        gender: 'Female',
        coordinator: Coordinator(name: '', id: '', joinedAt: DateTime.now()),
        mentor: Mentor(
          name: '',
          id: '',
          joinedAt: DateTime.now(),
        ),
      )
    ];
  }

  Users teacherToUser(Teacher t) {
    return Users(
      id: t.id,
      name: t.name,
      role: "teacher",
    );
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

    // Sort
    if (sortType.value == SortType.newest) {
      temp.sort((a, b) => b.joinedAt.compareTo(a.joinedAt));
    } else if (sortType.value == SortType.oldest) {
      temp.sort((a, b) => a.joinedAt.compareTo(b.joinedAt));
    } else if (sortType.value == SortType.name) {
      temp.sort((a, b) => a.name.compareTo(b.name));
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

  void handleDelete(BuildContext context, Teacher teacher) {
    final user = auth.activeUser;

    if (user?.role == "coordinator") {
      CustomWidgets().showDeleteDialog(
        context: context,
        text: "Do you want to request deletion of this teacher?",
        onConfirm: () => requestDelete(teacher.id!),
      );
    } else {
      CustomWidgets().showDeleteDialog(
        context: context,
        text: "Are you sure you want to delete this teacher permanently?",
        onConfirm: () => delete(teacher.id!),
      );
    }
  }

  void handleDeactivate(BuildContext context, Teacher teacher) {
    final user = auth.activeUser;

    if (user?.role == "coordinator") {
      CustomWidgets().showDeactivateDialog(
        context: context,
        text: "Do you want to request inactivation for this teacher?",
        onConfirm: () => requestDeactivate(teacher.id!),
      );
    } else {
      CustomWidgets().showDeactivateDialog(
        context: context,
        text: "Are you sure you want to deactivate this teacher permanently?",
        onConfirm: () => deactivate(teacher.id!),
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
}
