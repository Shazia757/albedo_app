import 'dart:developer';

import 'package:albedo_app/api.dart';
import 'package:albedo_app/controller/auth_controller.dart';
import 'package:albedo_app/model/batch_model.dart';
import 'package:albedo_app/model/package_model.dart';
import 'package:albedo_app/model/payment_model.dart';
import 'package:albedo_app/model/users/student_model.dart';
import 'package:albedo_app/model/users/teacher_model.dart';
import 'package:albedo_app/widgets/widgets.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

enum SortType { newest, oldest, name }

class BatchController extends GetxController {
  final AuthController auth = Get.find();

  RxBool isSearching = false.obs;
  var selectedIndex = 0.obs;

  var batches = <Batch>[].obs;

  final currentPage = 1.obs;
  final RxInt totalCount = 0.obs;
  final isLoading = false.obs;
  final hasMore = true.obs;

  final int pageSize = 10;
  final activeCount = 0.obs;
  final inactiveCount = 0.obs;
  var filteredBatches = <Batch>[].obs;
  final tabs = ["Active", "Inactive"];
  var selectedTab = 0.obs;
  var searchQuery = ''.obs;
  var sortType = SortType.newest.obs;
  var isDeleteButtonLoading = true.obs;
  RxList<Student> studentsList = <Student>[].obs;
  Rx<Student?> selectedStudent = Rx<Student?>(null);
  Rx<String> selectedMaterialType = 'drive'.obs;

  List<String> detailedTabs = [
    "Batch",
    "Packages",
    "Students",
    "Payments",
    "Materials",
  ];

  TextEditingController batchNameController = TextEditingController();
  TextEditingController batchCodeController = TextEditingController();
  TextEditingController batchModeController = TextEditingController();
  TextEditingController phoneController = TextEditingController();
  TextEditingController courseController = TextEditingController();
  TextEditingController totalFeeController = TextEditingController();
  TextEditingController spotFeeController = TextEditingController();

  TextEditingController mentorController = TextEditingController();

  @override
  void onInit() {
    super.onInit();
    loadTabCounts();
    fetchBatches();
  }

  /// --------------------------
  /// Fetch
  /// --------------------------
  Future<void> fetchBatches() async {
    try {
      isLoading.value = true;

      final bool isLive = selectedTab.value == 0;

      final response = await Api().getStudentBatches(
        page: currentPage.value + 1,
        pageSize: 10,
        isLive: isLive,
      );

      batches.assignAll(response.results);
      totalCount.value = response.count;

      applyFilters();
    } catch (e) {
      log(e.toString());
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> loadTabCounts() async {
    try {
      final activeResponse = await Api().getStudentBatches(
        page: 1,
        pageSize: 1,
        isLive: true,
      );

      final inactiveResponse = await Api().getStudentBatches(
        page: 1,
        pageSize: 1,
        isLive: false,
      );

      activeCount.value = activeResponse.count;
      inactiveCount.value = inactiveResponse.count;
    } catch (e) {
      log(e.toString());
    }
  }

  List<Map<String, dynamic>> get tabData => [
        {"label": "Active", "count": activeCount.value},
        {"label": "Inactive", "count": inactiveCount.value},
      ];

  /// --------------------------
  /// Filters
  /// --------------------------
  void applyFilters() {
    List<Batch> temp = batches;

    // Search
    if (searchQuery.value.isNotEmpty) {
      temp = temp
          .where((s) =>
              s.name!
                  .toLowerCase()
                  .contains(searchQuery.value.toLowerCase()) ||
              s.id!
                  .toLowerCase()
                  .contains(searchQuery.value.toLowerCase()))
          .toList();
    }

    if (sortType.value == SortType.name) {
      temp.sort((a, b) => a.name!.compareTo(b.name!));
    }

    filteredBatches.assignAll(temp);
  }

  void loadBatches(Batch batch) {
    batchNameController.text = batch.name.toString();
    // batchModeController.text = batch.mode.toString();
    mentorController.text = batch.mentor?.name ?? '';
  }

  final itemsPerPage = 10;

  int get totalPages => (totalCount.value / pageSize).ceil();

  List<Batch> get paginatedBatches {
    final start = currentPage.value * itemsPerPage;
    final end = (start + itemsPerPage) > filteredBatches.length
        ? filteredBatches.length
        : (start + itemsPerPage);

    return filteredBatches.sublist(start, end);
  }

  final batch = Batch(
    id: "BTH001",
    name: "NEET Evening Batch",
  );

  final payments = [
    PaymentItem(
      id: "PAY001",
      studentName: "Amina Rashid",
      studentId: "STU1023",
      paymentType: "UPI",
      amount: 4500,
      status: "Paid",
      paymentDate: DateTime.now(),
      balance: 2000,
    ),
    PaymentItem(
      id: "PAY002",
      studentName: "Rayan Kareem",
      studentId: "STU1041",
      paymentType: "Bank Transfer",
      amount: 6000,
      status: "Pending",
      paymentDate: DateTime.now(),
      balance: 2000,
    ),
    PaymentItem(
      id: "PAY003",
      studentName: "Hiba Fathima",
      studentId: "STU1099",
      paymentType: "Cash",
      amount: 3500,
      status: "Paid",
      paymentDate: DateTime.now(),
      balance: 2000,
    ),
    PaymentItem(
      id: "PAY004",
      studentName: "Nihal Basheer",
      studentId: "STU1107",
      paymentType: "Card",
      amount: 8000,
      status: "Failed",
      paymentDate: DateTime.now(),
      balance: 2000,
    ),
  ];

  void handleDelete(BuildContext context, Batch batch) {
    final user = auth.activeUser;

    if ((user?.role == "coordinator") || (user?.role == "mentor")) {
      CustomWidgets().showDeleteDialog(
        dltText: Obx(
          () => isLoading.value
              ? const SizedBox(
                  width: 18,
                  height: 18,
                  child: CircularProgressIndicator(
                    strokeWidth: 2,
                    color: Colors.white,
                  ),
                )
              : Text(
                  "Yes",
                  style: Theme.of(context)
                      .textTheme
                      .titleSmall!
                      .copyWith(color: Colors.white),
                ),
        ),
        title: 'Are you sure?',
        context: context,
        text: "Do you want to request deletion of this batch?",
        onConfirm: () => requestDelete(batch.id!),
      );
    } else {
      CustomWidgets().showDeleteDialog(
        dltText: Obx(
          () => isLoading.value
              ? const SizedBox(
                  width: 18,
                  height: 18,
                  child: CircularProgressIndicator(
                    strokeWidth: 2,
                    color: Colors.white,
                  ),
                )
              : Text(
                  "Yes",
                  style: Theme.of(context)
                      .textTheme
                      .titleSmall!
                      .copyWith(color: Colors.white),
                ),
        ),
        title: 'Are you sure?',
        context: context,
        text: "Are you sure you want to delete this batch permanently?",
        onConfirm: () => delete(batch.id!),
      );
    }
  }

  void requestDelete(String batchId) {
    print("Request sent to delete batch: $batchId");

    // TODO:
    // Call API → create approval request
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
