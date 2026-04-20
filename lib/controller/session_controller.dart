import 'package:albedo_app/model/session_model.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

enum SortType { newest, oldest, student, teacher }

class SessionController extends GetxController {
  var selectedTab = 0.obs;
  var selectedStatus = 0.obs;
  var searchQuery = ''.obs;
  var selectAllMentors = false.obs;
  var selectAllTeachers = false.obs;
  var selectAllStudents = false.obs;
  var selectAllCoordinators = false.obs;
  var selectAllAdvisors = false.obs;
  var selectAllOtherUsers = false.obs;
  var sortType = SortType.newest.obs;
  var sessions = <Session>[].obs;
  var selectedTeacher = RxnString();
  RxList<String> selectedStudents = <String>[].obs;
  RxList<String> selectedTeachers = <String>[].obs;
  RxList<String> selectedMentors = <String>[].obs;
  RxList<String> selectedCoordinators = <String>[].obs;
  RxList<String> selectedAdvisors = <String>[].obs;
  RxList<String> selectedOtherUsers = <String>[].obs;
  var selectedTeacherEdit = RxnString();
  final formKey = GlobalKey<FormState>();
  var selectedDuration = Rxn<int>();
  var selectedPackage = RxnString();
  var selectedDate = Rxn<DateTime>();
  var selectedTime = Rxn<TimeOfDay>();
  RxString selectedType = "session".obs;
  RxList<String> mentorsList = <String>[].obs;
  RxList<String> coordinatorsList = <String>[].obs;
  RxList<String> advisorsList = <String>[].obs;
  RxList<String> otherUsersList = <String>[].obs;

  TextEditingController dateController = TextEditingController();
  TextEditingController timeController = TextEditingController();
  TextEditingController durationController = TextEditingController();
  TextEditingController salaryController = TextEditingController();
  TextEditingController teacherController = TextEditingController();
  TextEditingController meetTitleController = TextEditingController();
  TextEditingController descriptionController = TextEditingController();

  final durationOptions = [30, 45, 60, 75, 90, 105, 120];
  final studentList = ['Student A', 'Student B', 'Student C'];
  final packageOptions = ['Package A', 'Package B', 'Package C'];
  final teacherList = ["Teacher A", "Teacher B", "Teacher C"];

  RxBool isLoading = true.obs;
  RxBool isDeleteButtonLoading = false.obs;

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
    if (selectedTeacher.value != null && selectedTeacher.value!.isNotEmpty) {
      filtered = filtered
          .where((s) => s.teacherName == selectedTeacher.value)
          .toList();
    }

    // 🔥 Step 2: ADD SORTING HERE (THIS IS WHAT YOU ASKED)
    switch (sortType.value) {
      case SortType.newest:
        filtered.sort((a, b) => b.date.compareTo(a.date));
        break;
      case SortType.oldest:
        filtered.sort((a, b) => a.date.compareTo(b.date));
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
    fetchData();
  }

  Future<void> fetchData() async {
    try {
      isLoading.value = true;

      await Future.delayed(const Duration(seconds: 2));

      sessions.assignAll([
        Session(
          id: "S001",
          studentName: "Aisha",
          studentId: "ST01",
          subject: "Math",
          className: "10A",
          teacherName: "John",
          teacherId: "T01",
          date: DateTime.now().subtract(const Duration(days: 1)),
          time: DateTime.now(),
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
          date: DateTime.now().add(const Duration(days: 1)),
          time: DateTime.now(),
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
          date: DateTime.now(),
          time: DateTime.now(),
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
          date: DateTime.now().subtract(const Duration(days: 3)),
          time: DateTime.now(),
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
          date: DateTime.now(),
          time: DateTime.now(),
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
          time: DateTime.now(),
          date: DateTime.now().subtract(const Duration(hours: 5)),
          status: "meet_done",
        ),
        Session(
          id: "S007",
          studentName: "Sneha",
          studentId: "ST07",
          subject: "Math",
          className: "9A",
          time: DateTime.now(),
          teacherName: "John",
          teacherId: "T01",
          date: DateTime.now().add(const Duration(hours: 3)),
          status: "started",
        ),
      ]);
      filteredSessions.assignAll(sessions);
    } catch (e) {
      print("Error: $e");
    } finally {
      isLoading.value = false;
    }
  }

  void applyFilters() {
    List<Session> temp = sessions;

    /// 🎯 Tab-based status filter
    final status = statusMap[selectedTab.value];
    temp = temp.where((s) => s.status == status).toList();

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
      temp.sort((a, b) => b.date.compareTo(a.date));
    } else if (sortType.value == "old") {
      temp.sort((a, b) => a.date.compareTo(b.date));
    } else if (sortType.value == "name") {
      temp.sort((a, b) => a.studentName.compareTo(b.studentName));
    }

    /// ✅ Final update
    filteredSessions.assignAll(temp);
  }

  Future<void> pickTime(BuildContext context) async {
    final TimeOfDay? picked = await showTimePicker(
      context: context,
      initialTime: selectedTime.value ?? TimeOfDay.now(),
      initialEntryMode: TimePickerEntryMode.input,
      builder: (context, child) {
        return Theme(
            data: Theme.of(context).copyWith(
                timePickerTheme: TimePickerThemeData(
                    dayPeriodColor: Theme.of(context).colorScheme.primary)),
            child: child!);
      },
    );

    if (picked != null) {
      selectedTime.value = picked;
      timeController.text = picked.format(context);
    }
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
      text: "${data.date.day}/${data.date.month}/${data.date.year}",
    );

    timeController = TextEditingController(
      text: "${data.date.hour}:${data.date.minute}",
    );

    salaryController =
        TextEditingController(text: data.teacherSalary.toString());
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

  void loadSession(Session session) {
    dateController.text = session.date.toString();
    timeController.text = session.time.toString();

    selectedDuration.value = session.duration;
    selectedTeacher.value = session.teacherName;

    salaryController.text = session.teacherSalary?.toString() ?? '';
  }

  void updateSession(String id) {
    final updatedData = {
      "date": dateController.text,
      "time": timeController.text,
      "duration": selectedDuration.value,
      "teacher": selectedTeacher.value,
      "salary": salaryController.text,
    };

    // API / DB update
    print("Updating session $id with $updatedData");
  }
}
