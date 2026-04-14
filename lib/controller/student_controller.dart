import 'package:albedo_app/controller/session_controller.dart';
import 'package:albedo_app/model/student_model.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class StudentController extends GetxController {
  var students = <Student>[].obs;
  var filteredStudents = <Student>[].obs;

  var selectedTab = 0.obs;
  var searchQuery = ''.obs;
  var sortType = SortType.newest.obs;
  var isLoading = true.obs;
  var isDeleteButtonLoading = true.obs;

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

  /// --------------------------
  /// Fetch
  /// --------------------------
  void fetchStudents() async {
    try {
      isLoading.value = true;

      // 🔥 Replace with your API call
      await Future.delayed(const Duration(seconds: 2));

      students.assignAll([
        Student(
          admissionDate: DateTime.parse('2023-01-15 12:00:00'),
          studentId: "STU1001",
          name: "Riya Shah",
          email: "riya@email.com",
          status: "Active",
          type: "Batch",
          joinedAt: DateTime.now(),
        ),
        Student(
          admissionDate: DateTime.parse('2023-01-15 12:00:00'),
          studentId: "STU1002",
          name: "Ameen",
          email: "ameen@email.com",
          status: "Inactive",
          type: "TBA",
          joinedAt: DateTime.now().subtract(const Duration(days: 2)),
        ),
      ]);
      filteredStudents.assignAll(students);
    } catch (e) {
      print("Error: $e");
    } finally {
      isLoading.value = false;
    }
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
              s.name!.toLowerCase().contains(searchQuery.value.toLowerCase()) ||
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
    advisorController.text = student.advisor.toString();
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
}
