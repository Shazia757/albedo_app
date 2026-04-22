import 'package:albedo_app/model/batch_model.dart';
import 'package:albedo_app/model/users/student_model.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

enum SortType { newest, oldest, name }

class BatchController extends GetxController {
  var batches = <Batch>[].obs;
  var filteredBatches = <Batch>[].obs;
  final tabs = ["Active", "Inactive"];
  var selectedTab = 0.obs;
  var searchQuery = ''.obs;
  var sortType = SortType.newest.obs;
  var isLoading = true.obs;
  var isDeleteButtonLoading = true.obs;

  // --------------------------
  // Counts for tabs
  // --------------------------

  int get activeCount => batches.where((e) => e.status == "Active").length;

  int get inactiveCount => batches.where((e) => e.status == "Inactive").length;

  List<Map<String, dynamic>> get tabData => [
        {"label": "Active", "count": activeCount},
        {"label": "Inactive", "count": inactiveCount},
      ];

  TextEditingController batchNameController = TextEditingController();
  TextEditingController batchCodeController = TextEditingController();
  TextEditingController batchModeController = TextEditingController();
  TextEditingController phoneController = TextEditingController();
  TextEditingController courseController = TextEditingController();

  TextEditingController mentorController = TextEditingController();

  @override
  void onInit() {
    super.onInit();
    fetchBatches();
  }

  /// --------------------------
  /// Fetch
  /// --------------------------
  void fetchBatches() async {
    try {
      isLoading.value = true;

      // 🔥 Replace with your API call
      await Future.delayed(const Duration(seconds: 2));

      batches.assignAll([
        Batch(
          teacherName: '',
          batchName: 'ATTC PROGRAME COURSE BATCH 1',
          batchID: 'B-ATTAP2601',
          status: "Active",
        ),
        Batch(
          teacherName: '',
          batchName: '10 TH CBSE BATCH 1 2026-2027',
          batchID: 'B-10 MA2601',
          status: "Active",
        ),
      ]);
      filteredBatches.assignAll(batches);
    } catch (e) {
      print("Error: $e");
    } finally {
      isLoading.value = false;
    }
  }

  /// --------------------------
  /// Filters
  /// --------------------------
  void applyFilters() {
    List<Batch> temp = batches;

    // Tabs
    switch (selectedTab.value) {
      case 0:
        temp = temp.where((s) => s.status == "Active").toList();
        break;
      case 1:
        temp = temp.where((s) => s.status == "Inactive").toList();
        break;
    }

    // Search
    if (searchQuery.value.isNotEmpty) {
      temp = temp
          .where((s) =>
              s.batchName!
                  .toLowerCase()
                  .contains(searchQuery.value.toLowerCase()) ||
              s.batchID!
                  .toLowerCase()
                  .contains(searchQuery.value.toLowerCase()))
          .toList();
    }

    // Sort
    // if (sortType.value == SortType.newest) {
    //   temp.sort((a, b) => b..compareTo(a.joinedAt));
    // } else if (sortType.value == SortType.oldest) {
    //   temp.sort((a, b) => a.joinedAt.compareTo(b.joinedAt));
    // } else
    if (sortType.value == SortType.name) {
      temp.sort((a, b) => a.batchName!.compareTo(b.batchName!));
    }

    filteredBatches.assignAll(temp);
  }

  void loadBatches(Batch batch) {
    batchNameController.text = batch.batchName.toString();
    batchModeController.text = batch.mode.toString();
    batchNameController.text = batch.batchName.toString();
    mentorController.text = batch.mentorName.toString();
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
