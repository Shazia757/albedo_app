import 'package:albedo_app/controller/session_controller.dart';
import 'package:albedo_app/model/student_model.dart';
import 'package:albedo_app/model/teacher_model.dart';
import 'package:get/get.dart';

class UserController extends GetxController {
  var students = <Student>[].obs;
  var teachers = <TeacherModel>[].obs;
  var filteredStudents = <Student>[].obs;
  var filteredTeachers = <TeacherModel>[].obs;

  var selectedTab = 0.obs;
  var searchQuery = ''.obs;
  var sortType = SortType.newest.obs;
  final UserPageType userType;
  RxBool isLoading = true.obs;

  UserController(this.userType);

  void onInit() {
    super.onInit();
    if (userType == UserPageType.student) {
      fetchStudents();
    } else {
      fetchTeachers();
    }
  }

  // --------------------------
  // Counts for tabs
  // --------------------------
  int get allCount =>
      userType == UserPageType.student ? students.length : teachers.length;

  int get activeCount => userType == UserPageType.student
      ? students.where((e) => e.status == "Active").length
      : teachers.where((e) => e.status == "Active").length;

  int get batchCount => userType == UserPageType.student
      ? students.where((e) => e.type == "Batch").length
      : teachers.where((e) => e.type == "Batch").length;

  int get tbaCount => userType == UserPageType.student
      ? students.where((e) => e.type == "TBA").length
      : 0; // teachers don’t have TBA

  int get inactiveCount => userType == UserPageType.student
      ? students.where((e) => e.status == "Inactive").length
      : teachers.where((e) => e.status == "Inactive").length;

  List<Map<String, dynamic>> get tabData => [
        {"label": "All", "count": allCount},
        {"label": "Active", "count": activeCount},
        {"label": "Batch", "count": batchCount},
        {"label": "TBA", "count": tbaCount},
        {"label": "Inactive", "count": inactiveCount},
      ];

  /// 🔌 Replace with API call
  void fetchTeachers() async {
    try {
      isLoading.value = true;

      // 🔥 Replace with your API call
      await Future.delayed(const Duration(seconds: 2));
      teachers.assignAll([
        TeacherModel(
          id: "TEA1001",
          name: "Mr. John",
          email: "john@email.com",
          status: "Active",
          type: "Batch",
          phone: "+1234567890",
          joinedAt: DateTime.parse('2022-12-01 09:00:00'),
        ),
        TeacherModel(
          id: "TEA1002",
          name: "Ms. Smith",
          email: "smith@email.com",
          status: "Inactive",
          type: "Batch",
          phone: "+9876543210",
          joinedAt: DateTime.parse('2024-12-01 09:00:00'),
        ),
      ]);
      filteredTeachers.assignAll(teachers);
    } catch (e) {
      print("Error: $e");
    } finally {
      isLoading.value = false;
    }

    applyFilters();
  }

  /// 🔌 Replace with API call
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

    applyFilters();
  }

  void applyFilters() {
    if (userType == UserPageType.student) {
      List<Student> temp = students;

      /// Tabs
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

      /// Search
      if (searchQuery.value.isNotEmpty) {
        temp = temp
            .where((s) =>
                s.name!
                    .toLowerCase()
                    .contains(searchQuery.value.toLowerCase()) ||
                s.email!
                    .toLowerCase()
                    .contains(searchQuery.value.toLowerCase()) ||
                s.studentId!
                    .toLowerCase()
                    .contains(searchQuery.value.toLowerCase()))
            .toList();
      }

      /// Sort
      if (sortType.value == "Newest") {
        temp.sort((a, b) => b.joinedAt.compareTo(a.joinedAt));
      } else if (sortType.value == "Oldest") {
        temp.sort((a, b) => a.joinedAt.compareTo(b.joinedAt));
      } else {
        temp.sort((a, b) => a.name!.compareTo(b.name!));
      }

      filteredStudents.assignAll(temp);
    } else {
      List<TeacherModel> temp = teachers;

      // Tabs
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

      // Search
      if (searchQuery.value.isNotEmpty) {
        temp = temp
            .where((t) =>
                t.name
                    .toLowerCase()
                    .contains(searchQuery.value.toLowerCase()) ||
                t.email
                    .toLowerCase()
                    .contains(searchQuery.value.toLowerCase()) ||
                t.id.toLowerCase().contains(searchQuery.value.toLowerCase()))
            .toList();
      }

      // Sort
      if (sortType.value == SortType.newest) {
        temp.sort((a, b) => a.id.compareTo(b.id)); // or any date if available
      } else if (sortType.value == SortType.oldest) {
        temp.sort((a, b) => b.id.compareTo(a.id));
      } else {
        temp.sort((a, b) => a.name.compareTo(b.name));
      }

      filteredTeachers.assignAll(temp);
    }
  }
}
