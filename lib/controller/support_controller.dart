import 'dart:developer';

import 'package:albedo_app/api.dart';
import 'package:albedo_app/controller/auth_controller.dart';
import 'package:albedo_app/model/session_model.dart';
import 'package:albedo_app/model/settings/syllabus_model.dart';
import 'package:albedo_app/model/support_model.dart';
import 'package:albedo_app/model/users/student_model.dart';
import 'package:albedo_app/model/users/teacher_model.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

enum SortType { newest, oldest, name }

enum PriorityFilter { all, high, medium, low }

class SupportController extends GetxController {
  final AuthController auth = Get.find();

  var selectedTab = 0.obs; // 0 = open, 1 = closed
  var searchQuery = ''.obs;
  final tabs = ["Open", "Closed"];

  int get openCount => allTickets.where((e) => e.status == "Open").length;

  int get closedCount => allTickets.where((e) => e.status == "Closed").length;

  List<Map<String, dynamic>> get tabData => [
        {"label": "Open", "count": openCount},
        {"label": "Closed", "count": closedCount},
      ];

  var sortType = SortType.newest.obs;
  var selectedPriority = PriorityFilter.all.obs;

  var allTickets = <Ticket>[].obs;
  var filteredTickets = <Ticket>[].obs;
  RxString selectedType = "student".obs;
  RxList<String> categoryList = <String>[].obs;
  RxList<Syllabus> categories = <Syllabus>[].obs;
  RxList<Student> students = <Student>[].obs;
  RxList<Teacher> teachers = <Teacher>[].obs;
  Rx<Syllabus?> selectedCategory = Rx<Syllabus?>(null);
  Rx<Student?> selectedStudent = Rx<Student?>(null);
  Rx<Teacher?> selectedTeacher = Rx<Teacher?>(null);
  Rx<String?> selectedPriorityList = Rx<String?>(null);

  RxBool isSearching = false.obs;
  RxBool isLoading = true.obs;
  RxBool isDeleteButtonLoading = false.obs;

  final statusMap = ['OPEN', 'CLOSED'];

  TextEditingController titleController = TextEditingController();
  TextEditingController categoryController = TextEditingController();
  TextEditingController priorityController = TextEditingController();
  TextEditingController userTypeController = TextEditingController();
  TextEditingController studentController = TextEditingController();
  TextEditingController teacherController = TextEditingController();
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

      final List<Ticket> all = await Api().getSupportTickets();

      List<Ticket> filtered;

      if (user?.role == "ADMIN") {
        filtered = all; // full access
      } else if (user?.role == "COORDINATOR") {
        filtered = all.where((t) => t.coordinatorId == user!.id).toList();
      } else if (user?.role == "TEACHER") {
        filtered = all.where((t) => t.teacher!.id == user!.id).toList();
      } else if (user?.role == "STUDENT") {
        filtered = all.where((t) => t.student!.studentId == user!.id).toList();
      } else {
        filtered = [];
      }

      allTickets.assignAll(filtered);
      log(allTickets.toString());
      applyFilters();

      final List<Student> studentList = await Api().getStudentList();

      students.assignAll(studentList);
      final List<Teacher> teacherList = await Api().getTeacherList();

      teachers.assignAll(teacherList);
      final List<Syllabus> categoryList = await Api().getSupportCategories();

      categories.assignAll(categoryList);
    } catch (e) {
      log(e.toString());
      Get.snackbar(
        'Error',
        e.toString(),
        colorText: Theme.of(Get.context!).colorScheme.shadow,
      );
    } finally {
      isLoading.value = false;
    }
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

  Future<Ticket?> addTicket(String name) async {
    isLoading.value = true;

    try {
      final result = await Api().addTicket(name);

      return result;
    } catch (e) {
      Get.snackbar(
        "Error",
        e.toString(),
      );
      return null;
    } finally {
      isLoading.value = false;
    }
  }

  Future<bool> updateTicket(
      {required String id, required String ticket}) async {
    isLoading.value = true;

    try {
      final success = await Api().updateTicket(id, ticket);

      if (success) {
        if (Get.isDialogOpen ?? false) Get.back();
        Get.snackbar("Success", "Updated successfully");
        return true;
      } else {
        Get.snackbar("Error", "Update failed");
        return false;
      }
    } catch (e) {
      Get.snackbar("Error", e.toString());
      return false;
    } finally {
      isLoading.value = false;
    }
  }

  Future<bool> deleteTicket(
    String id,
  ) async {
    isLoading.value = true;

    try {
      final success = await Api().deleteTicket(id);

      if (success) {
        allTickets.removeWhere((e) => e.id == id);

        Get.snackbar("Success", "Deleted successfully");
        return true;
      } else {
        Get.snackbar("Error", "Delete failed");
        return false;
      }
    } catch (e) {
      Get.snackbar("Error", e.toString());
      return false;
    } finally {
      isLoading.value = false;
    }
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

    final updatedReplies = List<Reply>.from(ticket.replies);
    updatedReplies.add(reply);

    // ticket.replies = updatedReplies;

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
