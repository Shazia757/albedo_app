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
  var filteredBatches = <Batch>[].obs;
  final tabs = ["Active", "Inactive"];
  var selectedTab = 0.obs;
  var searchQuery = ''.obs;
  var sortType = SortType.newest.obs;
  var isLoading = true.obs;
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
  TextEditingController totalFeeController = TextEditingController();
  TextEditingController spotFeeController = TextEditingController();

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
          student: [
            Student(
                name: 'Nivina',
                spotFee: 1000,
                totalAmount: 2000,
                status: 'completed')
          ],
          payment: [
            PaymentItem(
                id: '1',
                studentName: 'Nivina',
                studentId: '',
                paymentDate: DateTime.now(),
                amount: 1000,
                balance: 2000,
                status: 'pending')
          ],
          packages: [
            Package(
              name: "NEET Biology Foundation",
              standard: "Plus One",
              syllabus: "CBSE",
              timeCompleted: 1620,
              timeTotal: 2700,
              teacherSalaryPerHour: 850,
              teacher: Teacher(
                id: "TCH102",
                name: "Afsal Rahman",
                imageUrl: "https://i.pravatar.cc/300?img=12",
              ),
            ),
            Package(
              name: "JEE Advanced Physics",
              standard: "Plus Two",
              syllabus: "NCERT",
              sessionsCompleted: 25,
              sessionsTotal: 40,
              timeCompleted: 2250,
              timeTotal: 3600,
              teacherSalaryPerHour: 1200,
              teacher: Teacher(
                id: "TCH204",
                name: "Nihal Basheer",
                imageUrl: "https://i.pravatar.cc/300?img=15",
              ),
            ),
          ],
          batchName: 'ATTC PROGRAME COURSE BATCH 1',
          batchID: 'B-ATTAP2601',
          status: "Active",
        ),
        Batch(
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
    mentorController.text = batch.mentor?.name ?? '';
  }

  final batch = Batch(
    id: "BTH001",
    batchName: "NEET Evening Batch",
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
