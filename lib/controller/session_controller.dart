import 'package:albedo_app/model/session_model.dart';
import 'package:get/get.dart';

enum SortType { newest, oldest, student, teacher }

enum UserPageType { student, teacher }

class SessionController extends GetxController {
  var selectedTab = 0.obs;
  var selectedStatus = 0.obs;
  var searchQuery = ''.obs;
  var sortType = SortType.newest.obs;
  var sessions = <Session>[].obs;
  var selectedTeacher = ''.obs;


  List<String> tabs = [
    "Active",
    "Action",
    "Upcoming",
    "Pending",
    "Completed",
    "Meets"
  ];

  List<String> statusMap = [
    "started",
    "no_balance",
    "upcoming",
    "pending",
    "completed",
    "meet_done"
  ];

  List<Session> get filteredSessions {
    final status = statusMap[selectedTab.value];

    // ✅ Step 1: Filter first
    List<Session> filtered = sessions.where((s) {
      final matchesStatus = s.status == status;

      final matchesSearch = s.studentName
              .toLowerCase()
              .contains(searchQuery.value.toLowerCase()) ||
          s.teacherName.toLowerCase().contains(searchQuery.value.toLowerCase());

      return matchesStatus && matchesSearch;
    }).toList();
    if (selectedTeacher.value.isNotEmpty) {
      filtered = filtered
          .where((s) => s.teacherName == selectedTeacher.value)
          .toList();
    }

    // 🔥 Step 2: ADD SORTING HERE (THIS IS WHAT YOU ASKED)
    switch (sortType.value) {
      case SortType.newest:
        filtered.sort((a, b) => b.dateTime.compareTo(a.dateTime));
        break;
      case SortType.oldest:
        filtered.sort((a, b) => a.dateTime.compareTo(b.dateTime));
        break;
      case SortType.student:
        filtered.sort((a, b) => a.studentName.compareTo(b.studentName));
        break;
      case SortType.teacher:
        filtered.sort((a, b) => a.teacherName.compareTo(b.teacherName));
        break;
    }

    // ✅ Step 3: Return final list
    return filtered;
  }

  @override
  void onInit() {
    super.onInit();

    sessions.assignAll([
      Session(
        id: "S001",
        studentName: "Aisha",
        studentId: "ST01",
        subject: "Math",
        className: "10A",
        teacherName: "John",
        teacherId: "T01",
        dateTime: DateTime.now().subtract(const Duration(days: 1)),
        status: "started",
      ),
      Session(
        id: "S002",
        studentName: "Rahul",
        studentId: "ST02",
        subject: "Science",
        className: "9B",
        teacherName: "David",
        teacherId: "T02",
        dateTime: DateTime.now().add(const Duration(days: 1)),
        status: "upcoming",
      ),
      Session(
        id: "S003",
        studentName: "Fatima",
        studentId: "ST03",
        subject: "English",
        className: "8C",
        teacherName: "John",
        teacherId: "T01",
        dateTime: DateTime.now(),
        status: "pending",
      ),
      Session(
        id: "S004",
        studentName: "Arjun",
        studentId: "ST04",
        subject: "Physics",
        className: "11A",
        teacherName: "Meera",
        teacherId: "T03",
        dateTime: DateTime.now().subtract(const Duration(days: 3)),
        status: "completed",
      ),
      Session(
        id: "S005",
        studentName: "Nisha",
        studentId: "ST05",
        subject: "Chemistry",
        className: "12B",
        teacherName: "David",
        teacherId: "T02",
        dateTime: DateTime.now(),
        status: "no_balance",
      ),
      Session(
        id: "S006",
        studentName: "Ali",
        studentId: "ST06",
        subject: "Biology",
        className: "10A",
        teacherName: "Meera",
        teacherId: "T03",
        dateTime: DateTime.now().subtract(const Duration(hours: 5)),
        status: "meet_done",
      ),
      Session(
        id: "S007",
        studentName: "Sneha",
        studentId: "ST07",
        subject: "Math",
        className: "9A",
        teacherName: "John",
        teacherId: "T01",
        dateTime: DateTime.now().add(const Duration(hours: 3)),
        status: "started",
      ),
    ]);
  }

  void applyFilters() {
    List<Session> temp = sessions;

    /// 🔍 Search
    if (searchQuery.value.isNotEmpty) {
      temp = temp
          .where((s) =>
              s.studentName
                  .toLowerCase()
                  .contains(searchQuery.value.toLowerCase()) ||
              s.teacherName
                  .toLowerCase()
                  .contains(searchQuery.value.toLowerCase()))
          .toList();
    }

    /// 🎯 Filter (example: status)
    if (selectedStatus.value != "All") {
      temp = temp.where((s) => s.status == selectedStatus.value).toList();
    }

    /// ↕️ Sort
    if (sortType.value == "new") {
      temp.sort((a, b) => b.dateTime.compareTo(a.dateTime));
    } else if (sortType.value == "old") {
      temp.sort((a, b) => a.dateTime.compareTo(b.dateTime));
    } else if (sortType.value == "name") {
      temp.sort((a, b) => a.studentName.compareTo(b.studentName));
    }

    filteredSessions.assignAll(temp);
  }
}
