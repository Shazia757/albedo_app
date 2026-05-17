import 'package:albedo_app/controller/auth_controller.dart';
import 'package:albedo_app/controller/session_report_controller.dart';
import 'package:albedo_app/model/batch_model.dart';
import 'package:albedo_app/model/package_model.dart';
import 'package:albedo_app/model/session_model.dart';
import 'package:albedo_app/model/users/coordinator_model.dart';
import 'package:albedo_app/model/users/mentor_model.dart';
import 'package:albedo_app/model/users/student_model.dart';
import 'package:albedo_app/model/users/teacher_model.dart';
import 'package:albedo_app/view/sessions/session_report_dialog.dart';
import 'package:albedo_app/widgets/home_widgets.dart';
import 'package:albedo_app/widgets/widgets.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class BatchListController extends GetxController {
  final AuthController auth = Get.find();

  /// 🔁 Toggle
  final bool useMock = true;

  /// 🔄 State
  var isLoading = true.obs;
  var isDeleteButtonLoading = false.obs;
  RxBool isSearching = false.obs;

  var selectedTab = 0.obs;
  var searchQuery = ''.obs;
  Rx<Package?> selectedPackage = Rx<Package?>(null);

  /// 📦 Data

  final RxList<Batch> batchList = <Batch>[].obs;
  final RxList<Session> sessionList = <Session>[].obs;
  RxList<String> categoryList = <String>[].obs;
  RxList<Student> studentsList = <Student>[].obs;
  RxList<Teacher> teacherList = <Teacher>[].obs;
  RxList<Package> packagesList = <Package>[].obs;

  var batches = <String>[].obs;
  final teachersList = ["Teacher A", "Teacher B", "Teacher C"];

  RxList<Mentor> mentorsList = <Mentor>[].obs;
  RxList<Coordinator> coordinatorsList = <Coordinator>[].obs;

  RxList<SessionReport> reports = <SessionReport>[].obs;
  Rxn<SessionReport> reportRx = Rxn<SessionReport>();

  /// 🎯 Filters
  Rx<Teacher?> selectedTeacher = Rx<Teacher?>(null);

  Rx<Batch?> selectedBatch = Rx<Batch?>(null);

  /// 🧾 Controllers
  TextEditingController descriptionController = TextEditingController();
  TextEditingController searchController = TextEditingController();
  TextEditingController dateController = TextEditingController();
  TextEditingController timeController = TextEditingController();
  TextEditingController salaryController = TextEditingController();
  TextEditingController titleController = TextEditingController();
  TextEditingController categoryController = TextEditingController();

  /// 📅 Selection
  var selectedDate = Rxn<DateTime>();
  var selectedTime = Rxn<TimeOfDay>();
  var selectedDuration = Rxn<int>();
  RxString selectedType = "batch".obs;
  String selectedFile = '';

  final durationOptions = [30, 45, 60, 75, 90, 105, 120];

  ///  Tabs
  List<String> tabs = [
    "Active",
    "Upcoming",
    "Pending",
    "Completed",
  ];

  List<String> statusMap = [
    "started",
    "upcoming",
    "pending",
    "completed",
  ];

  /// 🚀 INIT
  @override
  void onInit() {
    super.onInit();
    fetchData();
  }

  /// 🌐 FETCH MAIN DATA
  Future<void> fetchData() async {
    try {
      isLoading.value = true;

      final user = auth.activeUser;

      final allSessions =
          useMock ? await _mockSessions() : await _apiSessions();

      List<Session> result = [];

      if (user?.role == "Admin") {
        result = allSessions;
      } else if (user?.role == "Coordinator") {
        result =
            allSessions.where((s) => s.coordinator?.id == user!.id).toList();
      } else if (user?.role == "Teacher") {
        result = allSessions.where((b) => b.teacher?.id == user!.id).toList();
      }

      sessionList.assignAll(result);
    } catch (e) {
      print("Batch Fetch Error: $e");
    } finally {
      isLoading.value = false;
    }
  }

  /// 🧪 MOCK DATA
  Future<List<Session>> _mockSessions() async {
    await Future.delayed(const Duration(seconds: 1));
    return _getDummySessions();
  }

  /// 🌐 API DATA
  Future<List<Session>> _apiSessions() async {
    try {
      // final res = await ApiService.getBatches();
      // return res.map<Batch>((e) => Batch.fromJson(e)).toList();

      throw UnimplementedError();
    } catch (e) {
      print("API Batch Error: $e");
      return [];
    }
  }

  /// 📊 FILTERED LIST (MAIN LOGIC)
  List<Session> get filteredSessions {
    final status = statusMap[selectedTab.value];

    List<Session> filtered = sessionList.where((s) {
      final matchesStatus = s.status == status;

      final query = searchQuery.value.toLowerCase();

      final matchesSearch =
          (s.batch?.batchName?.toLowerCase().contains(query) ?? false) ||
              (s.batch?.batchID?.toLowerCase().contains(query) ?? false) ||
              (s.id.toLowerCase().contains(query)) ||
              (s.package?.name?.toLowerCase().contains(query) ?? false) ||
              (s.package?.teacher?.name.toLowerCase().contains(query) ??
                  false) ||
              (s.package?.teacher?.id.toLowerCase().contains(query) ?? false) ||
              (s.package?.standard?.toLowerCase().contains(query) ?? false) ||
              (s.package?.syllabus?.toLowerCase().contains(query) ?? false) ||
              (s.date?.toString().toLowerCase().contains(query) ?? false);

      return matchesStatus && matchesSearch;
    }).toList();

    /// Optional teacher filter
    // if (selectedTeacher.value != null &&
    //     selectedTeacher.value != '') {
    //   filtered = filtered.where((s) {
    //     return s.package?.teacher?.name ==
    //         selectedTeacher.value;
    //   }).toList();
    // }

    /// Sort latest first
    filtered.sort(
      (a, b) => (b.date ?? DateTime.now()).compareTo(a.date ?? DateTime.now()),
    );

    return filtered;
  }

  void applyFilters() {
    List<Session> temp = sessionList;

    final status = statusMap[selectedTab.value];

    /// Status Filter
    temp = temp.where((s) {
      return s.status.toLowerCase() == status.toLowerCase();
    }).toList();

    /// Search Filter
    if (searchQuery.value.isNotEmpty) {
      final query = searchQuery.value.toLowerCase();

      temp = temp.where((s) {
        return (s.batch?.batchName?.toLowerCase().contains(query) ?? false) ||
            (s.batch?.batchID?.toLowerCase().contains(query) ?? false) ||
            s.id.toLowerCase().contains(query) ||
            (s.package?.name?.toLowerCase().contains(query) ?? false) ||
            (s.package?.teacher?.name.toLowerCase().contains(query) ?? false) ||
            (s.package?.teacher?.id.toLowerCase().contains(query) ?? false) ||
            (s.package?.standard?.toLowerCase().contains(query) ?? false) ||
            (s.package?.syllabus?.toLowerCase().contains(query) ?? false);
      }).toList();
    }

    /// Latest first
    temp.sort(
      (a, b) => (b.date ?? DateTime.now()).compareTo(a.date ?? DateTime.now()),
    );

    filteredSessions.assignAll(temp);
  }

  /// 👨‍🏫 FETCH USERS (API + MOCK)
  Future<void> fetchTeachers() async {
    try {
      isLoading.value = true;

      if (useMock) {
        await Future.delayed(const Duration(milliseconds: 500));
        teacherList.assignAll([
          Teacher(
            gender: 'Male',
            id: "T001",
            name: "Ameen Rahman",
            status: "Active",
            joinedAt: DateTime.now(),
          ),
          Teacher(
            gender: 'Female',
            id: "T002",
            name: "Fathima Noor",
            status: "Active",
            joinedAt: DateTime.now(),
          ),
        ]);
      } else {
        // final res = await ApiService.getTeachers();
        // teacherList.assignAll(res);
        throw UnimplementedError();
      }
    } catch (e) {
      print("Teacher Fetch Error: $e");
    } finally {
      isLoading.value = false;
    }
  }

  /// 🔍 HELPERS
  Batch? getBatchById(String id) {
    try {
      return sessionList
          .map((e) => e.batch)
          .whereType<Batch>()
          .firstWhere((e) => e.batchID == id);
    } catch (e) {
      return null;
    }
  }

  Teacher? getTeacherById(String id) {
    try {
      return teacherList.firstWhere((e) => e.id == id);
    } catch (e) {
      return null;
    }
  }

  /// ✏️ LOAD FOR EDIT
  void loadSession(Session session) {
    dateController.text = session.date != null ? formatDate(session.date!) : '';

    timeController.text = session.startTime ?? '';

    selectedDuration.value = session.duration;

    /// teacher
    // selectedTeacher.value = session.teacher;

    /// salary
    salaryController.text = session.teacherSalary?.toString() ?? '';
  }

  /// 🗑 DELETE
  void delete(String id) async {
    try {
      isDeleteButtonLoading.value = true;

      if (!useMock) {
        // await ApiService.deleteBatch(id);
      }

      sessionList.removeWhere((b) => b.id == id);

      Get.snackbar("Success", "Batch deleted successfully");
    } catch (e) {
      print("Delete Error: $e");
    } finally {
      isDeleteButtonLoading.value = false;
    }
  }

  /// 📝 REPORT
  void addOrUpdateReport(SessionReport report) {
    final index = reports.indexWhere((r) => r.studentId == report.studentId);

    if (index == -1) {
      reports.add(report);
    } else {
      reports[index] = report;
    }
  }

  void openSessionReportDialog(Session session) {
    final controller = Get.put(SessionReportController());

    controller.initFromSession(session);

    CustomWidgets().showCustomDialog(
      context: Get.context!,
      title: Text("Edit Session Report"),
      icon: Icons.description,
      formKey: GlobalKey<FormState>(),
      isViewOnly: false,
      submitWidget: Text(
        "Save Report",
        style: Theme.of(Get.context!)
            .textTheme
            .bodyMedium!
            .copyWith(color: Colors.white),
      ),
      onSubmit: controller.saveReport,
      sections: [
        SessionReportDialogBody(controller: controller),
      ],
    );
  }

  /// 🧪 DUMMY DATA
  List<Session> _getDummySessions() {
    return [
      Session(
        id: "SES001",
        status: "started",
        date: DateTime.now(),
        startTime: "10:00 AM",
        endTime: "11:00 AM",
        duration: 60,
        teacherSalary: 500,
        batch: Batch(
          id: "B001",
          batchID: "BT01",
          batchName: "10A Science",
        ),
        package: Package(
          name: "Physics Crash Course",
          standard: "10",
          syllabus: "CBSE",
          teacher: Teacher(
            id: "T001",
            name: "Ameen Rahman",
            gender: "Male",
            status: "active",
            joinedAt: DateTime.now(),
          ),
        ),
      ),
      Session(
        id: "SES002",
        status: "upcoming",
        date: DateTime.now().add(const Duration(days: 1)),
        startTime: "03:00 PM",
        endTime: "04:30 PM",
        duration: 90,
        teacherSalary: 650,
        batch: Batch(
          id: "B002",
          batchID: "BT02",
          batchName: "9B Maths",
        ),
        package: Package(
          name: "Mathematics Advanced",
          standard: "9",
          syllabus: "State",
          teacher: Teacher(
            id: "T002",
            name: "Fathima Noor",
            gender: "Female",
            status: "active",
            joinedAt: DateTime.now(),
          ),
        ),
      ),
    ];
  }

  void onBatchSelected(Batch batch) {
    selectedBatch.value = batch;

    // reset previous selection
    selectedPackage.value = null;

    // build packages list from student
    if (batch.packages != null) {
      packagesList.value = batch.packages ?? [];
    } else {
      packagesList.clear();
    }
  }

  bool validateSession(BuildContext context) {
    String error = "";
    if (selectedBatch.value == null) {
      error = "Please select a batch";
    }
    if (selectedPackage.value == null) {
      error = "Please select a package";
    } else if (selectedTeacher.value == null) {
      error = "Please select a teacher";
    } else if (salaryController.text.trim().isEmpty) {
      error = "Teacher salary is required";
    } else if (dateController.text.trim().isEmpty) {
      error = "Session date is required";
    } else if (timeController.text.trim().isEmpty) {
      error = "Session time is required";
    } else if (selectedDuration.value == null) {
      error = "Please select duration";
    }

    if (error.isNotEmpty) {
      Get.snackbar(
        "Error",
        error,
        snackPosition: SnackPosition.TOP,
      );
      return false;
    }

    return true;
  }

  void addSession() {}
}
