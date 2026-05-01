import 'package:albedo_app/controller/auth_controller.dart';
import 'package:albedo_app/model/session_model.dart';
import 'package:albedo_app/model/support_model.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

enum SortType { newest, oldest, name }

enum PriorityFilter { all, high, medium, low }

class SupportController extends GetxController {
  final AuthController auth = Get.find();

  var selectedTab = 0.obs; // 0 = open, 1 = closed
  var searchQuery = ''.obs;
  var sortType = SortType.newest.obs;
  var selectedPriority = PriorityFilter.all.obs;
  

  var allTickets = <Ticket>[].obs;
  var filteredTickets = <Ticket>[].obs;
  RxString selectedType = "student".obs;
  RxList<String> categoryList = <String>[].obs;


  RxBool isSearching = false.obs;
  RxBool isLoading = true.obs;
  RxBool isDeleteButtonLoading = false.obs;

  final statusMap = ['open', 'closed'];

  TextEditingController titleController = TextEditingController();
  TextEditingController categoryController = TextEditingController();
  TextEditingController priorityController = TextEditingController();
  TextEditingController userTypeController = TextEditingController();
  TextEditingController stuNameController = TextEditingController();
  TextEditingController teaNameController = TextEditingController();
  TextEditingController descriptionController = TextEditingController();

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

      final all = _getDummyTickets();

      List<Ticket> result;

      if (user?.role == "admin") {
        result = all; // full access
      } else if (user?.role == "coordinator") {
        result = all.where((t) => t.coordinatorId == user!.id).toList();
      } else if (user?.role == "teacher") {
        result = all.where((t) => t.teacherId == user!.id).toList();
      } else if (user?.role == "student") {
        result = all.where((t) => t.studentId == user!.id).toList();
      } else {
        result = [];
      }

      allTickets.assignAll(result);
      applyFilters();
    } catch (e) {
      print("Error: $e");
    } finally {
      isLoading.value = false;
    }
  }

  List<Ticket> _getDummyTickets() {
    return [
      Ticket(
        id: "SUP001",
        title: "Login Issue",
        description: "Unable to login",
        status: "open",
        studentId: "STU001",
      ),
      Ticket(
        id: "SUP002",
        title: "Payment Failed",
        description: "Amount deducted",
        status: "open",
        teacherId: "T001",
      ),
      Ticket(
        id: "SUP003",
        title: "App Crash",
        description: "Crash on dashboard",
        status: "closed",
        coordinatorId: "COO1001",
      ),
      Ticket(
        id: "SUP004",
        title: "Wrong Data",
        description: "Incorrect data",
        status: "closed",
        studentId: "STU002",
      ),
    ];
  }

  void applyFilters() {
    List<Ticket> temp = allTickets;

    /// 🎯 Status filter (tabs)
    final status = statusMap[selectedTab.value];
    temp = temp.where((s) => s.status == status).toList();

    /// ⭐ Priority filter (NEW)
    if (selectedPriority.value != PriorityFilter.all) {
      temp = temp.where((s) {
        return s.priority?.toLowerCase() ==
            selectedPriority.value.name; // "high", "medium", "low"
      }).toList();
    }

    /// 🔍 Search
    if (searchQuery.value.isNotEmpty) {
      final query = searchQuery.value.toLowerCase();

      temp = temp.where((s) {
        return s.title.toLowerCase().contains(query) ||
            s.id.toLowerCase().contains(query);
      }).toList();
    }

    filteredTickets.assignAll(temp);
  }

  int getCount(int index) {
    return allTickets.where((e) => e.status == statusMap[index]).length;
  }

  void loadTicket(Ticket ticket) {
    titleController.text = ticket.title.toString();
    categoryController.text = ticket.category.toString();
    priorityController.text = ticket.priority.toString();
    userTypeController.text = ticket.userType.toString();
    stuNameController.text = ticket.studentName.toString();
    teaNameController.text = ticket.teacherName.toString();
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

  void postReply({
    required String ticketId,
    required String message,
    String? template,
  }) {
    final ticketIndex = filteredTickets.indexWhere((t) => t.id == ticketId);

    if (ticketIndex == -1) return;

    final ticket = filteredTickets[ticketIndex];

    final reply = Reply(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      message: message,
      sender: "admin",
      createdAt: DateTime.now(),
    );

    /// 🔥 Important: make list mutable
    final updatedReplies = List<Reply>.from(ticket.replies);
    updatedReplies.add(reply);

    ticket.replies = updatedReplies;

    /// 🔁 trigger UI update
    filteredTickets.refresh();
  }

  final priorityOptions = [
    FilterOption<PriorityFilter>(
      label: "All",
      value: PriorityFilter.all,
      icon: Icons.filter_alt,
    ),
    FilterOption<PriorityFilter>(
      label: "High",
      value: PriorityFilter.high,
      icon: Icons.priority_high,
    ),
    FilterOption<PriorityFilter>(
      label: "Medium",
      value: PriorityFilter.medium,
      icon: Icons.trending_flat,
    ),
    FilterOption<PriorityFilter>(
      label: "Low",
      value: PriorityFilter.low,
      icon: Icons.low_priority,
    ),
  ];
}
