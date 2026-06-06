import 'dart:developer';

import 'package:albedo_app/api.dart';
import 'package:albedo_app/controller/auth_controller.dart';
import 'package:albedo_app/controller/session_report_controller.dart';
import 'package:albedo_app/model/batch_model.dart';
import 'package:albedo_app/model/package_model.dart';
import 'package:albedo_app/model/session_model.dart';
import 'package:albedo_app/model/settings/syllabus_model.dart';
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
  final totalCount = 0.obs;

  /// 🔄 State
  var isLoading = true.obs;
  RxBool isSessionDetailLoading = false.obs;

  var isDeleteButtonLoading = false.obs;
  RxBool isSearching = false.obs;

  var selectedTab = 0.obs;
  var searchQuery = ''.obs;
  Rx<Package?> selectedPackage = Rx<Package?>(null);
  final activeCount = 0.obs;
  final upcomingCount = 0.obs;
  final pendingCount = 0.obs;
  final completedCount = 0.obs;
  final currentPage = 0.obs;
  final pageSize = 20.obs;

  int get totalPages => (totalCount.value / pageSize.value).ceil();

  final RxInt currentSessionIndex = 0.obs;


  /// 📦 Data
  final RxList<BatchSession> filteredBatchSessions = <BatchSession>[].obs;

  final RxList<Batch> batchList = <Batch>[].obs;
  final RxList<BatchSession> sessionList = <BatchSession>[].obs;
  RxList<Syllabus> categoryList = <Syllabus>[].obs;
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
    fetchAllCounts();
    fetchData();
  }

  Future<void> fetchData() async {
    try {
      isLoading.value = true;

      String category = "active";

      switch (selectedTab.value) {
        case 0:
          category = "active";
          break;

        case 1:
          category = "upcoming";
          break;

        case 2:
          category = "pending";
          break;

        case 3:
          category = "completed";
          break;
      }

      final response = await Api().getBatchSessionDetails(
        category: category,
        page: currentPage.value + 1,
        pageSize: pageSize.value,
      );

      sessionList.assignAll(response.results);

      totalCount.value = response.count;

      applyFilters();
    } catch (e) {
      log(e.toString());
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> fetchAllCounts() async {
    try {
      final active = await Api().getBatchSessionDetails(
        category: "active",
        page: 1,
        pageSize: 1,
      );

      final upcoming = await Api().getBatchSessionDetails(
        category: "upcoming",
        page: 1,
        pageSize: 1,
      );

      final pending = await Api().getBatchSessionDetails(
        category: "pending",
        page: 1,
        pageSize: 1,
      );

      final completed = await Api().getBatchSessionDetails(
        category: "completed",
        page: 1,
        pageSize: 1,
      );

      activeCount.value = active.count;
      upcomingCount.value = upcoming.count;
      pendingCount.value = pending.count;
      completedCount.value = completed.count;
    } catch (e) {
      log(e.toString());
    }
  }

  void applyFilters() {
    List<BatchSession> temp = sessionList;

    /// Search Filter
    if (searchQuery.value.isNotEmpty) {
      final query = searchQuery.value.toLowerCase();

      temp = temp.where((s) {
        return (s.batchName?.toLowerCase().contains(query) ?? false) ||
            (s.batchID?.toLowerCase().contains(query) ?? false) ||
            s.id!.toLowerCase().contains(query) ||
            (s.packageName?.toLowerCase().contains(query) ?? false);
        // (s.package.teacher?.name.toLowerCase().contains(query) ?? false) ||
        // (s.package?.teacher?.id.toLowerCase().contains(query) ?? false) ||
        // (s.package?.standard?.toLowerCase().contains(query) ?? false) ||
        // (s.package?.syllabus?.toLowerCase().contains(query) ?? false);
      }).toList();
    }

    /// Latest first
    // temp.sort(
    //   (a, b) => (b.date ?? DateTime.now()).compareTo(a.date ?? DateTime.now()),
    // );

    filteredBatchSessions.assignAll(temp);
  }

  Future<BatchSessionDetail?> fetchSessionDetail(String id) async {
    try {
      isSessionDetailLoading.value = true;

      return await Api().getBatchSessionDetail(id);
    } catch (e) {
      log(e.toString());
    } finally {
      isSessionDetailLoading.value = false;
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
  void loadSession(Batch session) {
    // dateController.text = session.date != null ? formatDate(session.date!) : '';

    // timeController.text = session.startTime ?? '';

    // selectedDuration.value = session.duration;

    /// teacher
    // selectedTeacher.value = session.teacher;

    /// salary
    // salaryController.text = session.teacherSalary?.toString() ?? '';
  }

  /// 🗑 DELETE
  void delete(String id) async {
    try {
      isDeleteButtonLoading.value = true;

      if (!useMock) {
        // await ApiService.deleteBatch(id);
      }

      batchList.removeWhere((b) => b.id == id);

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

  void openSessionReportDialog(BatchSession session) {
    final controller = Get.put(SessionReportController());

    // controller.initFromSession(session);

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
