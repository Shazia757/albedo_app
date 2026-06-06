import 'dart:developer';

import 'package:albedo_app/api.dart';
import 'package:albedo_app/model/batch_model.dart';
import 'package:albedo_app/model/payment_model.dart';
import 'package:albedo_app/model/users/mentor_model.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class PaymentController extends GetxController {
  PaymentController({
    required this.isStudent,
  });
  final bool? isStudent;
  RxBool isSearching = false.obs;
  var selectedTab = 0.obs; // 0 = pending, 1 = approved
  final tabs = ["Pending", "Approved"];
  RxList<StudentPaymentModel> studentPayments = <StudentPaymentModel>[].obs;

  RxBool isLoadingPayments = false.obs;

  RxString selectedStatus = 'pending'.obs;
  final currentPage = 0.obs;

  final pageSize = 9;

  final totalCount = 0.obs;
  final depPendingCount = 0.obs;
  final depApprovedCount = 0.obs;
  final credPendingCount = 0.obs;
  final credApprovedCount = 0.obs;
  final refPendingCount = 0.obs;
  final refApprovedCount = 0.obs;
  final pendingWithdrawalCount = 0.obs;
  final approvedWithdrawalCount = 0.obs;

  int get totalPages => (totalCount.value / pageSize).ceil();

  List<String> studentTabs = [
    "Dep Pending",
    "Dep Approved",
    "Cred Pending",
    "Cred Approved",
    "Ref Pending",
    "Ref Approved",
  ];

  var allStudentPayments = <StudentPaymentModel>[].obs;
  var allTeacherPayments = <TeacherPaymentModel>[].obs;
  var allBatchPayments = <BatchPaymentModel>[].obs;
  var teacherPayments = <TeacherPaymentModel>[].obs;
  var batchPayments = <BatchPaymentModel>[].obs;
  final filteredStudentPayments = <StudentPaymentModel>[].obs;

  final filteredTeacherPayments = <TeacherPaymentModel>[].obs;

  final filteredBatchPayments = <BatchPaymentModel>[].obs;

  var searchQuery = ''.obs;

  List<String> statusMap = ["pending", "approved"];

  @override
  void onInit() {
    super.onInit();

    if (isStudent == true) {
      loadStudentTabCounts();
      fetchWalletStudentTransactions();
    } else if (isStudent == false) {
      loadTeacherTabCounts();
      fetchWalletTeacherTransactions();
    }

    fetchBatchTransactions();
  }

  Future<void> fetchWalletStudentTransactions() async {
    try {
      isLoadingPayments.value = true;

      String status = "";

      switch (selectedTab.value) {
        case 0:
          status = "pending";
          break;

        case 1:
          status = "approved";
          break;

        case 2:
          status = "pending_credit";
          break;
      }

      final response = await Api().getWalletStudentTransactions(
        page: currentPage.value + 1,
        pageSize: pageSize,
        status: status,
      );

      studentPayments.assignAll(response.results);

      totalCount.value = response.count;

      applyFilters();
    } catch (e) {
      log(e.toString());

      Get.snackbar(
        'Error',
        e.toString(),
        colorText: Theme.of(Get.context!).colorScheme.onSurface,
      );
    } finally {
      isLoadingPayments.value = false;
    }
  }

  Future<void> loadStudentTabCounts() async {
    try {
      final depPending = await Api().getWalletStudentTransactions(
        page: 1,
        pageSize: 1,
        status: "pending",
      );

      final depApproved = await Api().getWalletStudentTransactions(
        page: 1,
        pageSize: 1,
        status: "approved",
      );

      final credPending = await Api().getWalletStudentTransactions(
        page: 1,
        pageSize: 1,
        status: "pending_credit",
      );
      final credApproved = await Api().getWalletStudentTransactions(
        page: 1,
        pageSize: 1,
        status: "approved_credit",
      );

      final refPending = await Api().getWalletStudentTransactions(
        page: 1,
        pageSize: 1,
        status: "pending_refund",
      );

      final refApproved = await Api().getWalletStudentTransactions(
        page: 1,
        pageSize: 1,
        status: "approved_refund",
      );

      depPendingCount.value = depPending.count;
      depApprovedCount.value = depApproved.count;
      credPendingCount.value = credPending.count;
      credApprovedCount.value = credApproved.count;
      refPendingCount.value = refPending.count;
      refApprovedCount.value = refApproved.count;
    } catch (e) {
      log(e.toString());
    }
  }

  Future<void> fetchWalletTeacherTransactions() async {
    try {
      isLoadingPayments.value = true;

      String status = "";

      switch (selectedTab.value) {
        case 0:
          status = "pending_withdrawal";
          break;

        case 1:
          status = "approved_withdrawal";
          break;
      }

      final response = await Api().getWalletTeacherTransactions(
        page: currentPage.value + 1,
        pageSize: pageSize,
        status: status,
      );

      teacherPayments.assignAll(response.results);

      totalCount.value = response.count;

      applyFilters();
    } catch (e) {
      log(e.toString());

      Get.snackbar(
        'Error',
        e.toString(),
        colorText: Theme.of(Get.context!).colorScheme.onSurface,
      );
    } finally {
      isLoadingPayments.value = false;
    }
  }

  Future<void> loadTeacherTabCounts() async {
    try {
      final pendingWithdrawal = await Api().getWalletTeacherTransactions(
        page: 1,
        pageSize: 1,
        status: "pending_withdrawal",
      );

      final approvedWithdrawal = await Api().getWalletTeacherTransactions(
        page: 1,
        pageSize: 1,
        status: "approved_withdrawal",
      );

      pendingWithdrawalCount.value = pendingWithdrawal.count;

      approvedWithdrawalCount.value = approvedWithdrawal.count;
    } catch (e) {
      log(e.toString());
    }
  }

  Future<void> fetchBatchTransactions() async {
    try {
      isLoadingPayments.value = true;

      batchPayments.clear();
      filteredBatchPayments.clear();

      final batches = await Api().getBatchTransactions();

      batchPayments.assignAll(batches);

      applyFilters();
    } catch (e) {
      Get.snackbar(
        'Error',
        e.toString(),
        colorText: Theme.of(Get.context!).colorScheme.onSurface,
      );
    } finally {
      isLoadingPayments.value = false;
    }
  }

  void applyFilters() {
    final query = searchQuery.value.toLowerCase().trim();

    if (isStudent == true) {
      List<StudentPaymentModel> temp = List.from(studentPayments);

      /// ───────── SEARCH ─────────
      if (query.isNotEmpty) {
        temp = temp.where((e) {
          return e.name.toLowerCase().contains(query) ||
              e.id.toLowerCase().contains(query) ||
              (e.registrationId ?? '').toLowerCase().contains(query) ||
              (e.phoneNumber ?? '').toLowerCase().contains(query);
        }).toList();
      }

      /// ───────── SORT ─────────
      temp.sort(
        (a, b) => a.name.toLowerCase().compareTo(
              b.name.toLowerCase(),
            ),
      );

      filteredStudentPayments.assignAll(temp);
    } else if (isStudent == false) {
      List<TeacherPaymentModel> temp = List.from(teacherPayments);

      /// ───────── SEARCH ─────────
      if (query.isNotEmpty) {
        temp = temp.where((e) {
          return e.name.toLowerCase().contains(query) ||
              e.id.toLowerCase().contains(query);
        }).toList();
      }

      /// ───────── SORT ─────────
      temp.sort(
        (a, b) => a.name.toLowerCase().compareTo(
              b.name.toLowerCase(),
            ),
      );

      filteredTeacherPayments.assignAll(temp);
    }

    List<BatchPaymentModel> batchTemp = List.from(batchPayments);

    /// ───────── TAB FILTER ─────────
    if (selectedTab.value == 0) {
      batchTemp = batchTemp.where((e) {
        return (e.pendingCount ?? 0) > 0;
      }).toList();
    } else {
      batchTemp = batchTemp.where((e) {
        return (e.approvedCount ?? 0) > 0;
      }).toList();
    }

    /// ───────── SEARCH ─────────
    if (query.isNotEmpty) {
      batchTemp = batchTemp.where((e) {
        return e.name.toLowerCase().contains(query) ||
            e.code.toLowerCase().contains(query) ||
            (e.mentor?.name.toLowerCase() ?? '').contains(query);
      }).toList();
    }

    /// ───────── SORT ─────────
    batchTemp.sort(
      (a, b) => a.name.toLowerCase().compareTo(
            b.name.toLowerCase(),
          ),
    );

    filteredBatchPayments.assignAll(batchTemp);
  }

  int get pendingCount => teacherPayments
      .where(
        (e) => (e.pendingTransactions ?? 0) > 0,
      )
      .length;

  int get approvedCount => teacherPayments
      .where(
        (e) => (e.pendingTransactions ?? 0) <= 0,
      )
      .length;

  int get pendingBatchCount => batchPayments
      .where(
        (e) => (e.pendingCount ?? 0) > 0,
      )
      .length;

  int get approvedBatchCount => batchPayments
      .where(
        (e) => (e.approvedCount ?? 0) > 0,
      )
      .length;

  List<Map<String, dynamic>> get studentTabData => [
        {
          "label": "Dep Pending",
          "count": depPendingCount.value,
        },
        {
          "label": "Dep Approved",
          "count": depApprovedCount.value,
        },
        {
          "label": "Cred Pending",
          "count": credPendingCount.value,
        },
        {
          "label": "Cred Approved",
          "count": credApprovedCount.value,
        },
        {
          "label": "Ref Pending",
          "count": refPendingCount.value,
        },
        {
          "label": "Ref Approved",
          "count": refApprovedCount.value,
        },
      ];

  List<Map<String, dynamic>> get tabData => [
        {
          "label": "Pending Withdrawal",
          "count": pendingWithdrawalCount.value,
        },
        {
          "label": "Approved Withdrawal",
          "count": approvedWithdrawalCount.value,
        },
      ];
  List<Map<String, dynamic>> get batchTabData => [
        {"label": "Pending", "count": pendingBatchCount},
        {"label": "Approved", "count": approvedBatchCount},
      ];
}
