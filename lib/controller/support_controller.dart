import 'package:albedo_app/model/support_model.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

enum SortType { newest, oldest, name }

class SupportController extends GetxController {
  var selectedTab = 0.obs; // 0 = open, 1 = closed
  var searchQuery = ''.obs;
  var sortType = SortType.newest.obs;

  var allTickets = <Ticket>[].obs;
  var filteredTickets = <Ticket>[].obs;
  RxString selectedType = "student".obs;

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

  void fetchData() async {
    try {
      isLoading.value = true;

      await Future.delayed(const Duration(seconds: 2));
      allTickets.assignAll([
        Ticket(
            id: "SUP001",
            title: "Login Issue",
            description: "Unable to login with correct credentials",
            status: "open"),
        Ticket(
            id: "SUP002",
            title: "Payment Failed",
            description: "Transaction failed but amount deducted",
            status: "open"),
        Ticket(
            id: "SUP003",
            title: "App Crash",
            description: "App crashes when opening dashboard",
            status: "closed"),
        Ticket(
            id: "SUP004",
            title: "Wrong Data",
            description: "Incorrect student data displayed",
            status: "closed"),
      ]);
      applyFilters();
    } catch (e) {
      print("Error: $e");
    } finally {
      isLoading.value = false;
    }
  }

  void applyFilters() {
    List<Ticket> temp = allTickets;

    /// 🎯 Tab-based status filter
    final status = statusMap[selectedTab.value];
    temp = temp.where((s) => s.status == status).toList();

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
}
