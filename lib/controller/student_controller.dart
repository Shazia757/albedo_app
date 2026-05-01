import 'package:albedo_app/controller/auth_controller.dart';
import 'package:albedo_app/model/users/student_model.dart';
import 'package:albedo_app/widgets/widgets.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

enum SortType { newest, oldest, name }

class StudentController extends GetxController {
  final AuthController auth = Get.find();

  var students = <Student>[].obs;
  var filteredStudents = <Student>[].obs;

  var selectedTab = 0.obs;
  var searchQuery = ''.obs;
  var sortType = SortType.newest.obs;
  var isSearching = false.obs;
  var isLoading = true.obs;
  var isDeleteButtonLoading = true.obs;
  var isDeactivateButtonLoading = true.obs;

  // --------------------------
  // Counts for tabs
  // --------------------------
  int get allCount => students.length;

  int get activeCount => students.where((e) => e.status == "Active").length;

  int get batchCount => students.where((e) => e.type == "Batch").length;

  int get tbaCount => students.where((e) => e.type == "TBA").length;

  int get inactiveCount => students.where((e) => e.status == "Inactive").length;

  List<Map<String, dynamic>> get tabData => [
        {"label": "All", "count": allCount},
        {"label": "Active", "count": activeCount},
        {"label": "Batch", "count": batchCount},
        {"label": "TBA", "count": tbaCount},
        {"label": "Inactive", "count": inactiveCount},
      ];

  // 🎯 Student-specific fields
  RxBool isAdmissionFeePaid = false.obs;
  var selectedRole = ''.obs;
  RxList<String> mentorsList = <String>[].obs;
  RxList<String> advisorsList = <String>[].obs;

  TextEditingController nameController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  TextEditingController phoneController = TextEditingController();
  TextEditingController whatsappController = TextEditingController();
  TextEditingController genderController = TextEditingController();
  TextEditingController placeController = TextEditingController();
  TextEditingController pincodeController = TextEditingController();
  TextEditingController addressController = TextEditingController();
  TextEditingController timezoneController = TextEditingController();
  TextEditingController commentController = TextEditingController();

  TextEditingController parentNameController = TextEditingController();
  TextEditingController parentOccupationController = TextEditingController();
  TextEditingController mentorController = TextEditingController();
  TextEditingController advisorController = TextEditingController();
  TextEditingController referredByController = TextEditingController();

  @override
  void onInit() {
    super.onInit();
    fetchStudents();
  }

  Future<void> fetchStudents() async {
    try {
      isLoading.value = true;

      final user = auth.activeUser;

      await Future.delayed(const Duration(seconds: 2));

      final allStudents = _getDummyStudents();

      List<Student> result;

      if (user?.role == "admin") {
        result = allStudents; // full access
      } else if (user?.role == "coordinator") {
        result = allStudents.where((s) => s.coordinatorId == user!.id).toList();
      } else if (user?.role == "teacher") {
        result = allStudents.where((s) => s.teacherId == user!.id).toList();
      } else if (user?.role == "mentor") {
        result = allStudents.where((s) => s.mentorId == user!.id).toList();
      } else {
        result = [];
      }

      students.assignAll(result);
      filteredStudents.assignAll(result);
    } catch (e) {
      print("Error: $e");
    } finally {
      isLoading.value = false;
    }
  }

  List<Student> _getDummyStudents() {
    return [
      Student(
        studentId: "STU1001",
        name: "Riya Shah",
        email: "riya@email.com",
        status: "Active",
        type: "Batch",
        joinedAt: DateTime.now(),
        isFeePaid: true,
        admissionDate: DateTime.parse('2023-01-15 12:00:00'),
        teacherId: "T001",
        mentorId: "MTR001",
        coordinatorId: "COO1001",
      ),
      Student(
        studentId: "STU1002",
        name: "Ameen",
        email: "ameen@email.com",
        status: "Inactive",
        type: "TBA",
        joinedAt: DateTime.now(),
        admissionDate: DateTime.parse('2023-01-15 12:00:00'),
        teacherId: "T002",
        mentorId: "MTR002",
        coordinatorId: "COO1002",
      ),
    ];
  }

  /// --------------------------
  /// Filters
  /// --------------------------
  void applyFilters() {
    List<Student> temp = students;

    // Tabs
    switch (selectedTab.value) {
      case 1:
        temp = temp.where((s) => s.status == "Active").toList();
        break;
      case 2:
        temp = temp.where((s) => s.type == "Batch").toList();
        break;
      case 3:
        temp = temp.where((s) => s.type == "TBA").toList();
        break;
      case 4:
        temp = temp.where((s) => s.status == "Inactive").toList();
        break;
    }

    // Search
    if (searchQuery.value.isNotEmpty) {
      temp = temp
          .where((s) =>
              s.name.toLowerCase().contains(searchQuery.value.toLowerCase()) ||
              s.email!
                  .toLowerCase()
                  .contains(searchQuery.value.toLowerCase()) ||
              s.studentId!
                  .toLowerCase()
                  .contains(searchQuery.value.toLowerCase()))
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

    filteredStudents.assignAll(temp);
  }

  void loadStudents(Student student) {
    nameController.text = student.name.toString();
    emailController.text = student.email.toString();
    phoneController.text = student.phone.toString();
    whatsappController.text = student.whatsapp.toString();
    parentNameController.text = student.parentName.toString();
    parentOccupationController.text = student.parentOccupation.toString();
    whatsappController.text = student.whatsapp.toString();
    genderController.text = student.gender.toString();
    placeController.text = student.place.toString();
    pincodeController.text = student.pincode.toString();
    addressController.text = student.address.toString();
    timezoneController.text = student.timezone.toString();
    mentorController.text = student.mentor.toString();
    advisorController.text = student.advisorName.toString();
    referredByController.text = student.referredBy.toString();
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

  void handleDelete(BuildContext context, Student student) {
    final user = auth.activeUser;

    if (user?.role == "coordinator") {
      CustomWidgets().showDeleteDialog(
        context: context,
        text: "Do you want to request deletion of this student?",
        onConfirm: () => requestDelete(student.studentId!),
      );
    } else {
      CustomWidgets().showDeleteDialog(
        context: context,
        text: "Are you sure you want to delete this student permanently?",
        onConfirm: () => delete(student.studentId!),
      );
    }
  }

  void handleDeactivate(BuildContext context, Student student) {
    final user = auth.activeUser;

    if (user?.role == "coordinator") {
      CustomWidgets().showDeactivateDialog(
        context: context,
        text: "Do you want to request inactivation for this student?",
        onConfirm: () => requestDeactivate(student.studentId!),
      );
    } else {
      CustomWidgets().showDeactivateDialog(
        context: context,
        text: "Are you sure you want to deactivate this student permanently?",
        onConfirm: () => deactivate(student.studentId!),
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
}
