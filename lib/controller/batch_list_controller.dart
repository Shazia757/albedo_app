import 'package:albedo_app/model/batch_model.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class BatchListController extends GetxController {
  var isLoading = true.obs;

  var selectedTab = 0.obs;
  var batches = <Batch>[].obs;
  RxList<Batch> filteredBatches = <Batch>[].obs;
  var searchQuery = ''.obs;
  final teacherList = ["Teacher A", "Teacher B", "Teacher C"];
  var selectedDuration = RxnInt();
  var selectedTeacher = RxnString();
  final formKey = GlobalKey<FormState>();

  final durationOptions = [30, 45, 60, 75, 90, 105, 120];

  TextEditingController dateController = TextEditingController();
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

      // 🔥 Replace with your API call
      await Future.delayed(const Duration(seconds: 2));

      batches.assignAll([
        Batch(
          id: "S001",
          batchName: "10A",
          batchID: "BT01",
          subject: "Math",
          teacherName: "John",
          teacherId: "T01",
          date: DateTime.now().subtract(const Duration(days: 1)),
          status: "started",
        ),
        Batch(
          id: "S002",
          batchName: "Rahul",
          batchID: "BT02",
          subject: "Science",
          teacherName: "David",
          teacherId: "T02",
          date: DateTime.now().add(const Duration(days: 1)),
          status: "upcoming",
        ),
        Batch(
          id: "S003",
          batchName: "9B",
          batchID: "ST03",
          subject: "English",
          teacherName: "John",
          teacherId: "T01",
          date: DateTime.now(),
          status: "pending",
        ),
        Batch(
          id: "S004",
          batchID: "ST04",
          subject: "Physics",
          batchName: "11A",
          teacherName: "Meera",
          teacherId: "T03",
          date: DateTime.now().subtract(const Duration(days: 3)),
          status: "completed",
        ),
        Batch(
          id: "S005",
          batchID: "ST05",
          subject: "Chemistry",
          batchName: "12B",
          teacherName: "David",
          teacherId: "T02",
          date: DateTime.now(),
          status: "no_balance",
        ),
        Batch(
          id: "S006",
          batchID: "ST06",
          subject: "Biology",
          batchName: "10A",
          teacherName: "Meera",
          teacherId: "T03",
          date: DateTime.now().subtract(const Duration(hours: 5)),
          status: "meet_done",
        ),
        Batch(
          id: "S007",
          batchID: "ST07",
          subject: "Math",
          batchName: "9A",
          teacherName: "John",
          teacherId: "T01",
          date: DateTime.now().add(const Duration(hours: 3)),
          status: "started",
        ),
      ]);
      filteredBatches.assignAll(batches);
    } catch (e) {
      print("Error: $e");
    } finally {
      isLoading.value = false;
    }
  }

  void initEdit(Batch data) {
    // Ensure teacher list is ready
    final uniqueTeachers = batches.map((e) => e.teacherName).toSet().toList();

    teacherList.clear();
    teacherList.addAll(uniqueTeachers);

    // ✅ Set initial values safely
    selectedDuration.value =
        durationOptions.contains(data.duration) ? data.duration : null;

    selectedTeacher.value =
        teacherList.contains(data.teacherName) ? data.teacherName : null;

    // Controllers
    dateController = TextEditingController(
      text: "${data.date?.day}/${data.date?.month}/${data.date?.year}",
    );

    timeController = TextEditingController(
      text: data.startTime,
    );

    salaryController =
        TextEditingController(text: data.teacherSalary.toString());
  }

  void applyFilters() {
    List<Batch> temp = batches;

    /// 🎯 Tab filter (ALWAYS apply)
    final status = statusMap[selectedTab.value];

    temp = temp.where((s) {
      return s.status?.toLowerCase() == status.toLowerCase();
    }).toList();

    /// 🔍 Search
    if (searchQuery.value.isNotEmpty) {
      final query = searchQuery.value.toLowerCase();

      temp = temp.where((s) {
        return (s.batchName?.toLowerCase().contains(query) ?? false) ||
            (s.teacherName.toLowerCase().contains(query));
      }).toList();
    }

    filteredBatches.assignAll(temp);
  }
}
