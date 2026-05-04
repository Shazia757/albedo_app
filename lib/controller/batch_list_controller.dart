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

  /// 📦 Data
  RxList<Batch> batchList = <Batch>[].obs;
  RxList<String> categoryList = <String>[].obs;
  RxList<Student> studentsList = <Student>[].obs;
  RxList<Teacher> teacherList = <Teacher>[].obs;

  var batches = <String>[].obs;
  final teachersList = ["Teacher A", "Teacher B", "Teacher C"];

  RxList<Mentor> mentorsList = <Mentor>[].obs;
  RxList<Coordinator> coordinatorsList = <Coordinator>[].obs;

  RxList<SessionReport> reports = <SessionReport>[].obs;
  Rxn<SessionReport> reportRx = Rxn<SessionReport>();

  /// 🎯 Filters
  var selectedTeacher = RxnString();
  var selectedBatch = RxnString();

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

  void applyFilters() {
    List<Batch> temp = batchList;
    final status = statusMap[selectedTab.value];
    temp = temp.where((s) {
      return s.status?.toLowerCase() == status.toLowerCase();
    }).toList();

    /// 🔍 Search
    if (searchQuery.value.isNotEmpty) {
      final query = searchQuery.value.toLowerCase();
      temp = temp.where((s) {
        return (s.batchName?.toLowerCase().contains(query) ?? false) ||
            (s.teacher!.name.toLowerCase().contains(query));
      }).toList();
    }
    filteredBatches.assignAll(temp);
  }

  /// 🌐 FETCH MAIN DATA
  Future<void> fetchData() async {
    try {
      isLoading.value = true;

      final user = auth.activeUser;

      final allBatches = useMock ? await _mockBatches() : await _apiBatches();

      List<Batch> result = [];

      if (user?.role == "admin") {
        result = allBatches;
      } else if (user?.role == "coordinator") {
        result =
            allBatches.where((b) => b.coordinator?.id == user!.id).toList();
      } else if (user?.role == "teacher") {
        result = allBatches.where((b) => b.teacher?.id == user!.id).toList();
      }

      batchList.assignAll(result);
    } catch (e) {
      print("Batch Fetch Error: $e");
    } finally {
      isLoading.value = false;
    }
  }

  /// 🧪 MOCK DATA
  Future<List<Batch>> _mockBatches() async {
    await Future.delayed(const Duration(seconds: 1));
    return _getDummyBatches();
  }

  /// 🌐 API DATA
  Future<List<Batch>> _apiBatches() async {
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
  List<Batch> get filteredBatches {
    final status = statusMap[selectedTab.value];

    List<Batch> filtered = batchList.where((b) {
      final matchesStatus = b.status == status;

      final query = searchQuery.value.toLowerCase();

      final matchesSearch =
          (b.batchName?.toLowerCase().contains(query) ?? false) ||
              (b.batchID?.toLowerCase().contains(query) ?? false) ||
              (b.teacher?.name.toLowerCase().contains(query) ?? false) ||
              (b.id?.toLowerCase().contains(query) ?? false) ||
              b.date.toString().toLowerCase().contains(query);

      return matchesStatus && matchesSearch;
    }).toList();

    /// 🎯 Teacher filter
    if (selectedTeacher.value != null && selectedTeacher.value!.isNotEmpty) {
      filtered = filtered
          .where((b) => b.teacher?.name == selectedTeacher.value)
          .toList();
    }

    /// 🔥 Sort (optional)
    filtered.sort((a, b) => b.date!.compareTo(a.date!));

    return filtered;
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
      return batchList.firstWhere((e) => e.batchID == id);
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
  void loadBatch(Batch batch) {
    dateController.text = batch.date.toString();
    timeController.text = batch.startTime ?? "";

    selectedDuration.value = batch.duration;
    selectedTeacher.value = batch.teacher?.name;

    salaryController.text = batch.teacher?.salary?.toString() ?? '';
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

  void openSessionReportDialog(Batch batch) {
    final controller = Get.put(SessionReportController());

    controller.initFromBatchSession(batch);

    CustomWidgets().showCustomDialog(
      context: Get.context!,
      title: const Text("Edit Session Report"),
      icon: Icons.description,
      formKey: GlobalKey<FormState>(),
      isViewOnly: false,
      submitText: "Save Report",
      onSubmit: controller.saveReport,
      sections: [
        SessionReportDialogBody(controller: controller),
      ],
    );
  }

  /// 🧪 DUMMY DATA
  List<Batch> _getDummyBatches() {
    return [
      Batch(
        id: "S001",
        batchName: "10A",
        batchID: "BT01",
        students: 5,
        teacher: Teacher(
          gender: "Male",
          id: "T001",
          name: "Ameen Rahman",
          status: "active",
          joinedAt: DateTime.now(),
        ),
        date: DateTime.now().subtract(const Duration(days: 1)),
        status: "started",
      ),
      Batch(
        id: "S002",
        batchName: "ATTC",
        batchID: "BT02",
        teacher: Teacher(
          gender: "Female",
          id: "T02",
          name: "David",
          status: "active",
          joinedAt: DateTime.now(),
        ),
        date: DateTime.now().add(const Duration(days: 1)),
        status: "upcoming",
      ),
      Batch(
        id: "S003",
        batchName: "9B",
        batchID: "BT03",
        teacher: Teacher(
          gender: "Male",
          id: "T003",
          name: "John",
          status: "active",
          joinedAt: DateTime.now(),
        ),
        date: DateTime.now(),
        status: "pending",
      ),
      Batch(
        id: "S004",
        batchName: "11A",
        batchID: "BT04",
        teacher: Teacher(
          gender: "Female",
          id: "T004",
          name: "Meera",
          status: "active",
          joinedAt: DateTime.now(),
        ),
        date: DateTime.now().subtract(const Duration(days: 3)),
        status: "completed",
      ),
    ];
  }
}
