import 'package:albedo_app/controller/auth_controller.dart';
import 'package:albedo_app/model/batch_model.dart';
import 'package:albedo_app/model/users/coordinator_model.dart';
import 'package:albedo_app/model/users/mentor_model.dart';
import 'package:albedo_app/model/users/teacher_model.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class BatchListController extends GetxController {
  var isLoading = true.obs;
  var isDeleteButtonLoading = true.obs;
  RxBool isSearching = false.obs;

  var selectedTab = 0.obs;
  var batches = <String>[].obs;
  RxList<Batch> batchList = <Batch>[].obs;
  RxList<Teacher> teacherList = <Teacher>[].obs;
  RxList<Mentor> mentorsList = <Mentor>[].obs;
  RxList<Coordinator> coordinatorsList = <Coordinator>[].obs;

  var selectedBatch = RxnString();
  final auth = Get.find<AuthController>();

  // RxList<Batch> filteredBatches = <Batch>[].obs;
  var searchQuery = ''.obs;
  final teachersList = ["Teacher A", "Teacher B", "Teacher C"];
  var selectedDuration = Rxn<int>();
  var selectedTeacher = RxnString();
  var selectedDate = Rxn<DateTime>();
  var selectedTime = Rxn<TimeOfDay>();

  final formKey = GlobalKey<FormState>();

  final durationOptions = [30, 45, 60, 75, 90, 105, 120];

  TextEditingController dateController = TextEditingController();
  TextEditingController durationController = TextEditingController();
  TextEditingController timeController = TextEditingController();
  TextEditingController salaryController = TextEditingController();

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

  @override
  void onInit() {
    super.onInit();
    fetchData();
  }

  Future<void> fetchData() async {
    try {
      isLoading.value = true;

      final user = auth.activeUser;

      await Future.delayed(const Duration(seconds: 2));

      final allBatches = _getDummyBatches();

      List<Batch> result;

      if (user?.role == "admin") {
        result = allBatches;
      } else if (user?.role == "coordinator") {
        /// 👉 if coordinator manages batches (depends on your model)
        result =
            allBatches.where((b) => b.coordinator?.id == user!.id).toList();
      } else if (user?.role == "teacher") {
        result = allBatches.where((b) => b.teacher?.id == user!.id).toList();
      } else {
        result = [];
      }

      batchList.assignAll(result);
      filteredBatches.assignAll(result);
    } catch (e) {
      print("Error: $e");
    } finally {
      isLoading.value = false;
    }
  }

  List<Batch> _getDummyBatches() {
    return [
      Batch(
        id: "S001",
        batchName: "10A",
        batchID: "BT01",
        package: ["Math"],
        students: 5,
        coordinator: Coordinator(
          id: "COO1001",
          name: "Maria",
          joinedAt: DateTime.now(),
        ),
        teacher: Teacher(
          id: "T001",
          name: "Ameen Rahman",
          status: "active",
          joinedAt: DateTime(2023, 1, 1),
          gender: "male",
        ),
        date: DateTime.now().subtract(const Duration(days: 1)),
        status: "started",
      ),
      Batch(
        id: "S002",
        batchName: "ATTC",
        batchID: "BT02",
        package: ["Science"],
        teacher: Teacher(
          id: "T02",
          name: "David",
          status: "active",
          joinedAt: DateTime(2023, 2, 1),
          gender: "male",
        ),
        date: DateTime.now().add(const Duration(days: 1)),
        status: "upcoming",
      ),
      Batch(
        id: "S003",
        batchName: "9B",
        batchID: "ST03",
        package: ["English"],
        teacher: Teacher(
          id: "T001",
          name: "John",
          status: "active",
          joinedAt: DateTime(2023, 1, 1),
          gender: "male",
        ),
        date: DateTime.now(),
        status: "pending",
      ),
      Batch(
        id: "S004",
        batchName: "11A",
        batchID: "ST04",
        package: ["Physics"],
        teacher: Teacher(
          id: "T003",
          name: "Meera",
          status: "active",
          joinedAt: DateTime(2023, 3, 1),
          gender: "female",
        ),
        date: DateTime.now().subtract(const Duration(days: 3)),
        status: "completed",
      ),
      Batch(
        id: "S005",
        batchName: "12B",
        batchID: "ST05",
        package: ["Chemistry"],
        teacher: Teacher(
          id: "T02",
          name: "David",
          status: "active",
          joinedAt: DateTime(2023, 2, 1),
          gender: "male",
        ),
        date: DateTime.now(),
        status: "no_balance",
      ),
      Batch(
        id: "S006",
        batchName: "10A",
        batchID: "ST06",
        package: ["Biology"],
        teacher: Teacher(
          id: "T003",
          name: "Meera",
          status: "active",
          joinedAt: DateTime(2023, 3, 1),
          gender: "female",
        ),
        date: DateTime.now().subtract(const Duration(hours: 5)),
        status: "meet_done",
      ),
      Batch(
        id: "S007",
        batchName: "9A",
        batchID: "ST07",
        package: ["Math"],
        teacher: Teacher(
          id: "T01",
          name: "John",
          status: "active",
          joinedAt: DateTime(2023, 1, 1),
          gender: "male",
        ),
        date: DateTime.now().add(const Duration(hours: 3)),
        status: "started",
      ),
    ];
  }

  void loadBatch(Batch batch) {
    dateController.text = batch.date.toString();
    timeController.text = batch.startTime.toString();

    selectedDuration.value = batch.duration;
    selectedTeacher.value = batch.teacher?.name;

    salaryController.text = batch.teacher?.salary?.toString() ?? '';
  }

  Teacher? getTeacherById(String id) {
    try {
      return teacherList.firstWhere((e) => e.id == id);
    } catch (e) {
      return null;
    }
  }

  void initEdit(Batch data) {
    final uniqueTeachers =
        batchList.map((e) => e.teacher?.name).toSet().toList();

    teacherList.clear();
    // teacherList.addAll(uniqueTeachers);

    selectedDuration.value =
        durationOptions.contains(data.duration) ? data.duration : null;

    selectedTeacher.value =
        teacherList.contains(data.teacher?.name) ? data.teacher?.name : null;

    // Controllers
    dateController = TextEditingController(
      text: "${data.date?.day}/${data.date?.month}/${data.date?.year}",
    );

    timeController = TextEditingController(
      text: data.startTime,
    );

    salaryController =
        TextEditingController(text: data.teacher?.salary.toString());
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

  List<Batch> get filteredBatches {
    final status = statusMap[selectedTab.value];

    // ✅ Step 1: Filter first
    List<Batch> filtered = batchList.where((s) {
      final matchesStatus = s.status == status;

      final matchesSearch = s.batchName!
              .toLowerCase()
              .contains(searchQuery.value.toLowerCase()) ||
          s.batchID!.toLowerCase().contains(searchQuery.value.toLowerCase()) ||
          s.teacher!.id
              .toLowerCase()
              .contains(searchQuery.value.toLowerCase()) ||
          s.teacher!.name
              .toLowerCase()
              .contains(searchQuery.value.toLowerCase()) ||
          s.id!.toLowerCase().contains(searchQuery.value.toLowerCase()) ||
          s.date.toString().contains(searchQuery.value.toLowerCase());

      return matchesStatus && matchesSearch;
    }).toList();
    if (selectedTeacher.value != null && selectedTeacher.value!.isNotEmpty) {
      filtered = filtered
          .where((s) => s.teacher?.name == selectedTeacher.value)
          .toList();
    }

    return filtered;
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

  Batch? getBatchById(String id) {
    try {
      return batchList.firstWhere((e) => e.batchID == id);
    } catch (e) {
      return null;
    }
  }
}
