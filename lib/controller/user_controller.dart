import 'package:albedo_app/controller/session_controller.dart';
import 'package:albedo_app/model/student_model.dart';
import 'package:get/get.dart';

class UserController extends GetxController {
  var students = <Student>[].obs;
  var filteredStudents = <Student>[].obs;

  var selectedTab = 0.obs;
  var searchQuery = ''.obs;
  var sortType = SortType.newest.obs;

  @override
  void onInit() {
    fetchStudents();
    super.onInit();
  }

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

  /// 🔌 Replace with API call
  void fetchStudents() async {
    await Future.delayed(const Duration(seconds: 1));

    students.assignAll([
      Student(
        admissionDate: DateTime.parse('2023-01-15 12:00:00'),
        id: "STU1001",
        name: "Riya Shah",
        email: "riya@email.com",
        status: "Active",
        type: "Batch",
        joinedAt: DateTime.now(),
      ),
      Student(
        admissionDate: DateTime.parse('2023-01-15 12:00:00'),
        id: "STU1002",
        name: "Ameen",
        email: "ameen@email.com",
        status: "Inactive",
        type: "TBA",
        joinedAt: DateTime.now().subtract(const Duration(days: 2)),
      ),
    ]);

    applyFilters();
  }

  void applyFilters() {
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
              s.name.toLowerCase().contains(searchQuery.value.toLowerCase()) ||
              s.email.toLowerCase().contains(searchQuery.value.toLowerCase()) ||
              s.id.toLowerCase().contains(searchQuery.value.toLowerCase()))
          .toList();
    }

    /// Sort
    if (sortType.value == "Newest") {
      temp.sort((a, b) => b.joinedAt.compareTo(a.joinedAt));
    } else if (sortType.value == "Oldest") {
      temp.sort((a, b) => a.joinedAt.compareTo(b.joinedAt));
    } else {
      temp.sort((a, b) => a.name.compareTo(b.name));
    }

    filteredStudents.assignAll(temp);
  }
}
