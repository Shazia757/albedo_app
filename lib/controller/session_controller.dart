import 'package:albedo_app/model/session_model.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

enum SortType { newest, oldest, student, teacher }

enum UserPageType { student, teacher }

class SessionController extends GetxController {
  var selectedTab = 0.obs;
  var selectedStatus = 0.obs;
  var searchQuery = ''.obs;
  var sortType = SortType.newest.obs;
  var sessions = <Session>[].obs;
  var selectedTeacher = RxnString();
  var selectedTeacherEdit = RxnString();
  final formKey = GlobalKey<FormState>();

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

  late TextEditingController dateController;
  late TextEditingController timeController;
  late TextEditingController salaryController;
  var selectedDuration = RxnInt();
  final durationOptions = [30, 45, 60, 75, 90, 105, 120];
  final teacherList = ["Teacher A", "Teacher B", "Teacher C"];

  RxBool isLoading = false.obs;
  RxBool isDeleteButtonLoading = false.obs;

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
    if (selectedTeacher.value != null && selectedTeacher.value!.isNotEmpty) {
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

    /// 🎯 Tab-based status filter
    if (selectedTab.value != 0) {
      final status = statusMap[selectedTab.value];
      temp = temp.where((s) => s.status == status).toList();
    }

    /// 🔍 Search
    if (searchQuery.value.isNotEmpty) {
      final query = searchQuery.value.toLowerCase();

      temp = temp.where((s) {
        return s.studentName.toLowerCase().contains(query) ||
            s.teacherName.toLowerCase().contains(query);
      }).toList();
    }

    /// ↕️ Sort (keep if needed)
    if (sortType.value == "new") {
      temp.sort((a, b) => b.dateTime.compareTo(a.dateTime));
    } else if (sortType.value == "old") {
      temp.sort((a, b) => a.dateTime.compareTo(b.dateTime));
    } else if (sortType.value == "name") {
      temp.sort((a, b) => a.studentName.compareTo(b.studentName));
    }

    /// ✅ Final update
    filteredSessions.assignAll(temp);
  }

  void initEdit(Session data) {
    // Ensure teacher list is ready
    final uniqueTeachers = sessions.map((e) => e.teacherName).toSet().toList();

    teacherList.clear();
    teacherList.addAll(uniqueTeachers);

    // ✅ Set initial values safely
    selectedDuration.value =
        durationOptions.contains(data.duration) ? data.duration : null;

    selectedTeacher.value =
        teacherList.contains(data.teacherName) ? data.teacherName : null;

    // Controllers
    dateController = TextEditingController(
      text: "${data.dateTime.day}/${data.dateTime.month}/${data.dateTime.year}",
    );

    timeController = TextEditingController(
      text: "${data.dateTime.hour}:${data.dateTime.minute}",
    );

    salaryController =
        TextEditingController(text: data.teacherSalary.toString());
  }

  delete(int id) {
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
