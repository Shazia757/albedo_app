import 'dart:developer';

import 'package:albedo_app/api.dart';
import 'package:albedo_app/config/urls.dart';
import 'package:albedo_app/controller/auth_controller.dart';
import 'package:albedo_app/model/batch_model.dart';
import 'package:albedo_app/model/feedback_model.dart';
import 'package:albedo_app/model/package_model.dart';
import 'package:albedo_app/model/stu_wallet_model.dart';
import 'package:albedo_app/model/users/student_model.dart';
import 'package:albedo_app/model/wallet_model.dart';
import 'package:albedo_app/widgets/widgets.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

enum StudentSortType { newest, oldest, name }

enum StudentStatus {
  demoPending,
  demoCompleted,
  askedRefund,
  firstCallCompleted,
  joinedClass,
}

extension StudentStatusLabel on StudentStatus {
  String get label {
    switch (this) {
      case StudentStatus.demoPending:
        return "Demo Pending";
      case StudentStatus.demoCompleted:
        return "Demo Completed";
      case StudentStatus.askedRefund:
        return "Asked Refund";
      case StudentStatus.firstCallCompleted:
        return "First Call Completed";
      case StudentStatus.joinedClass:
        return "Joined Class";
    }
  }
}

class StudentController extends GetxController {
  final AuthController auth = Get.find();

  var students = <Student>[].obs;
  var filteredStudents = <Student>[].obs;
  RxList<Feedbacks> teacherFeedbacks = <Feedbacks>[].obs;
  RxList<Feedbacks> mentorFeedbacks = <Feedbacks>[].obs;

  var selectedTab = 0.obs;
  var searchQuery = ''.obs;
  var sortType = StudentSortType.newest.obs;
  var isSearching = false.obs;
  var isLoading = true.obs;
  var isDeleteButtonLoading = true.obs;
  var isDeactivateButtonLoading = true.obs;
  RxBool isActive = false.obs;
  Rx<StudentStatus> status = StudentStatus.demoPending.obs;
  var selectedIndex = 0.obs;
  RxString selectedFilter = "All".obs;
  Rx<Package?> selectedPackage = Rx<Package?>(null);
  final RxString selectedTimezone = ''.obs;
  final RxString selectedMentor = ''.obs;
  final RxString selectedAdvisor = ''.obs;
  final RxString selectedReferralSource = ''.obs;
  final certificateFormKey = GlobalKey<FormState>();
  final allCount = 0.obs;
  final activeCount = 0.obs;
  final batchCount = 0.obs;
  final tbaCount = 0.obs;
  final inactiveCount = 0.obs;

  RxInt feedbackTabIndex = 0.obs;

  // --------------------------
  // Counts for tabs
  // --------------------------
  Future<void> loadStudentTabCounts() async {
    try {
      final all = await Api().getStudentDetails(
        url: Urls.studentsDetails,
        page: 1,
        pageSize: 1,
      );

      final active = await Api().getStudentDetails(
        url: Urls.studentsDetailsActive,
        page: 1,
        pageSize: 1,
      );

      final batch = await Api().getStudentDetails(
        url: Urls.studentsWithBatches,
        page: 1,
        pageSize: 1,
      );

      final tba = await Api().getStudentDetails(
        url: "${Urls.studentsDetails}?tba=true",
        page: 1,
        pageSize: 1,
      );

      final inactive = await Api().getStudentDetails(
        url: "${Urls.studentsDetails}?is_live=false",
        page: 1,
        pageSize: 1,
      );

      allCount.value = all.count;
      activeCount.value = active.count;
      batchCount.value = batch.count;
      tbaCount.value = tba.count;
      inactiveCount.value = inactive.count;
    } catch (e) {
      log(e.toString());
    }
  }

  List<Map<String, dynamic>> get tabData => [
        {
          "label": "All",
          "count": allCount.value,
        },
        {
          "label": "Active",
          "count": activeCount.value,
        },
        {
          "label": "Batch",
          "count": batchCount.value,
        },
        {
          "label": "TBA",
          "count": tbaCount.value,
        },
        {
          "label": "Inactive",
          "count": inactiveCount.value,
        },
      ];

  // 🎯 Student-specific fields
  RxBool isAdmissionFeePaid = false.obs;
  var selectedRole = ''.obs;

  final totalCount = 0.obs;
  final currentPage = 0.obs;
  final pageSize = 10.obs;

  int get totalPages => (totalCount.value / pageSize.value).ceil();

  var step = 1.obs;
  RxList<String> packageList = <String>[].obs;
  RxList<String> mentorsList = <String>[].obs;
  RxList<String> advisorsList = <String>[].obs;

  TextEditingController nameController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  TextEditingController phoneController = TextEditingController();
  TextEditingController whatsappController = TextEditingController();
  TextEditingController genderController = TextEditingController();
  TextEditingController placeController = TextEditingController();
  TextEditingController pincodeController = TextEditingController();
  TextEditingController addressController = TextEditingController();
  TextEditingController timezoneController = TextEditingController();
  TextEditingController commentController = TextEditingController();
  TextEditingController couponcodeController = TextEditingController();
  TextEditingController refundAmountController = TextEditingController();
  TextEditingController refundMessageController = TextEditingController();
  TextEditingController remarkController = TextEditingController();

  TextEditingController parentNameController = TextEditingController();
  TextEditingController parentOccupationController = TextEditingController();
  TextEditingController mentorController = TextEditingController();
  TextEditingController advisorController = TextEditingController();
  TextEditingController referredByController = TextEditingController();

  @override
  void onInit() {
    super.onInit();
    loadStudentTabCounts();
    fetchStudents();
    refundedC.addListener(_updateConvenience);
  }

  List<String> tabs = [
    "Profile",
    "Packages",
    "Batches",
    "Wallet",
    "Batch Payments",
    "Assessments",
    "Sessions",
    "Feedbacks",
    "Certificates"
  ];

  void nextStep() {
    step.value = 2;
  }

  void reset() {
    step.value = 1;
  }

  var transactions = <TransactionModel>[].obs;

  List<String> feedbackTabs = ['Teacher', 'Mentor'];

  Future<void> fetchStudents() async {
    try {
      isLoading.value = true;
      String url = Urls.studentsDetails;

      switch (selectedTab.value) {
        case 1:
          url = Urls.studentsDetailsActive;
          break;

        case 2:
          url = "${Urls.base}/student/students-with-batches/";
          break;

        case 3:
          url = "${Urls.studentsDetails}?tba=true";
          break;

        case 4:
          url = "${Urls.studentsDetails}?is_live=false";
          break;
      }

      final response = await Api().getStudentDetails(
        url: url,
        page: currentPage.value + 1,
        pageSize: pageSize.value,
      );

      students.assignAll(response.results);

      totalCount.value = response.count;

      applyFilters();
    } catch (e) {
      log(e.toString());
    } finally {
      isLoading.value = false;
    }
  }

  /// --------------------------
  /// Filters
  /// --------------------------
  void applyFilters() {
    List<Student> temp = students;

    // Search
    if (searchQuery.value.isNotEmpty) {
      temp = temp
          .where((s) =>
              s.name.toLowerCase().contains(searchQuery.value.toLowerCase()) ||
              s.email!
                  .toLowerCase()
                  .contains(searchQuery.value.toLowerCase()) ||
              s.studentId!
                  .toLowerCase()
                  .contains(searchQuery.value.toLowerCase()))
          .toList();
    }

    // Sort
    if (sortType.value == StudentSortType.newest) {
      temp.sort(
        (a, b) => (b.joinedAt ?? DateTime(1900))
            .compareTo(a.joinedAt ?? DateTime(1900)),
      );
    } else if (sortType.value == StudentSortType.oldest) {
      temp.sort(
        (a, b) => (a.joinedAt ?? DateTime(1900))
            .compareTo(b.joinedAt ?? DateTime(1900)),
      );
    } else if (sortType.value == StudentSortType.name) {
      temp.sort(
        (a, b) => a.name.toLowerCase().compareTo(
              b.name.toLowerCase(),
            ),
      );
    }

    filteredStudents.assignAll(temp);
  }

  void loadStudents(Student student) {
    nameController.text = student.name.toString();
    emailController.text = student.email.toString();
    phoneController.text = student.phone.toString();
    whatsappController.text = student.whatsapp.toString();
    parentNameController.text = student.parentName.toString();
    parentOccupationController.text = student.parentOccupation.toString();
    whatsappController.text = student.whatsapp.toString();
    genderController.text = student.gender.toString();
    placeController.text = student.place.toString();
    pincodeController.text = student.pincode.toString();
    addressController.text = student.address.toString();
    timezoneController.text = student.timezone.toString();
    mentorController.text = student.mentor.toString();
    advisorController.text = student.advisorName.toString();
    referredByController.text = student.referredBy.toString();
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

  void handleDelete(BuildContext context, Student student) {
    final user = auth.activeUser;

    if (user?.role == "coordinator") {
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
        text: "Do you want to request deletion of this student?",
        onConfirm: () => requestDelete(student.studentId!),
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
        text: "Are you sure you want to delete this student permanently?",
        onConfirm: () => delete(student.studentId!),
      );
    }
  }

  void handleDeactivate(BuildContext context, Student student) {
    final user = auth.activeUser;

    if (user?.role == "coordinator") {
      CustomWidgets().showDeactivateDialog(
        context: context,
        text: "Do you want to request inactivation for this student?",
        onConfirm: () => requestDeactivate(student.studentId!),
      );
    } else {
      CustomWidgets().showDeactivateDialog(
        context: context,
        text: "Are you sure you want to deactivate this student permanently?",
        onConfirm: () => deactivate(student.studentId!),
      );
    }
  }

  deactivate(String id) {
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

  void requestDeactivate(String studentId) {
    print("Request sent to deactivate student: $studentId");

    // TODO:
    // Call API → create approval request
    // Show snackbar
  }

  void requestDelete(String studentId) {
    print("Request sent to delete student: $studentId");

    // TODO:
    // Call API → create approval request
  }

  bool validate(BuildContext context) {
    String error = "";

    if (nameController.text.trim().isEmpty) {
      error = "Parent Opinion is required";
    } else if (selectedPackage.value == null) {
      error = "Please select a package";
    }

    if (error.isNotEmpty) {
      Get.snackbar(
        "Error",
        error,
        snackPosition: SnackPosition.TOP,
      );
      return false;
    }

    return true;
  }

  bool validateStudent(BuildContext context) {
    String error = "";

    if (nameController.text.trim().isEmpty) {
      error = "Student name is required";
    } else if (emailController.text.trim().isEmpty) {
      error = "Email is required";
    } else if (!GetUtils.isEmail(emailController.text.trim())) {
      error = "Enter a valid email address";
    } else if (phoneController.text.trim().isEmpty) {
      error = "Phone number is required";
    } else if (phoneController.text.trim().length < 10) {
      error = "Enter a valid phone number";
    } else if (whatsappController.text.trim().isNotEmpty &&
        whatsappController.text.trim().length < 10) {
      error = "Enter a valid WhatsApp number";
    } else if (placeController.text.trim().isEmpty) {
      error = "Place is required";
    } else if (pincodeController.text.trim().isEmpty) {
      error = "Pincode is required";
    } else if (pincodeController.text.trim().length < 5) {
      error = "Enter a valid pincode";
    } else if (addressController.text.trim().isEmpty) {
      error = "Address is required";
    } else if (selectedTimezone.value.trim().isEmpty) {
      error = "Please select a time zone";
    } else if (selectedMentor.value.trim().isEmpty) {
      error = "Please select a mentor";
    } else if (selectedAdvisor.value.trim().isEmpty) {
      error = "Please select an advisor";
    } else if (selectedRole.value.isEmpty) {
      error = "Please select referred by type";
    } else if (selectedReferralSource.value.trim().isEmpty) {
      error = "Please select referral source";
    }

    if (error.isNotEmpty) {
      Get.snackbar(
        "Error",
        error,
        snackPosition: SnackPosition.TOP,
        margin: const EdgeInsets.all(12),
      );

      return false;
    }

    return true;
  }

  void addStudent() {}

  void updateStudent() {}

  final packageRefundC = TextEditingController();
  final refundableC = TextEditingController();
  final refundedC = TextEditingController();
  final convenienceC = TextEditingController();
  final reasonC = TextEditingController();

  double packageFee = 0;
  double takenFee = 0;
  double totalPaid = 0;

  double refundable = 0;

  void init({
    required double packageFee,
    required double takenFee,
    required double totalPaid,
  }) {
    this.packageFee = packageFee;
    this.takenFee = takenFee;
    this.totalPaid = totalPaid;

    refundedC.removeListener(_updateConvenience);
    refundedC.addListener(_updateConvenience);

    _recalculateAll();
  }

  void _recalculateAll() {
    final packageRefund = packageFee - takenFee;
    refundable = totalPaid - takenFee;

    packageRefundC.text = packageRefund.toStringAsFixed(2);
    refundableC.text = refundable.toStringAsFixed(2);

    // default refunded = refundable initially
    if (refundedC.text.isEmpty) {
      refundedC.text = refundable.toStringAsFixed(2);
    }

    _updateConvenience();
  }

  void onRefundedChanged(String value) {
    final refunded = double.tryParse(value) ?? 0;

    if (refunded > refundable) {
      refundedC.text = refundable.toStringAsFixed(2);
      return;
    }

    _updateConvenience();
  }

  void submitRefund(Map<String, Object> payload) {}

  void _updateConvenience() {
    final refunded = double.tryParse(refundedC.text) ?? 0;

    final conv = (refundable - refunded).clamp(0, double.infinity);

    convenienceC.text = conv.toStringAsFixed(2);
  }

  @override
  void onClose() {
    refundedC.removeListener(_updateConvenience);

    packageRefundC.dispose();
    refundableC.dispose();
    refundedC.dispose();
    convenienceC.dispose();
    reasonC.dispose();

    super.onClose();
  }

  bool validateCouponCode(BuildContext context) {
    String error = "";

    if (couponcodeController.text.trim().isEmpty) {
      error = "Coupon Code is required";
    }

    if (error.isNotEmpty) {
      Get.snackbar(
        "Error",
        error,
        snackPosition: SnackPosition.TOP,
      );
      return false;
    }

    return true;
  }

  void applyCoupon() {}

  bool validateRequest(BuildContext context) {
    String error = "";

    if (refundAmountController.text.trim().isEmpty) {
      error = "Coupon Code is required";
    } else if (refundMessageController.text.trim().isEmpty) {
      error = "Reason is required";
    }

    if (error.isNotEmpty) {
      Get.snackbar(
        "Error",
        error,
        snackPosition: SnackPosition.TOP,
      );
      return false;
    }

    return true;
  }

  void requestRefund() {}

  bool validateCertificate(BuildContext context) {
    String error = "";

    if (step.value == 1) {
      if (nameController.text.trim().isEmpty) {
        error = "Certificate name is required";
      } else if (selectedPackage.value == null) {
        error = "Please select a package";
      }
    }

    if (error.isNotEmpty) {
      Get.snackbar(
        "Error",
        error,
        snackPosition: SnackPosition.TOP,
      );

      return false;
    }

    return true;
  }

  Future<Student?> fetchStudentById(String id) async {
    try {
      return await Api().getStudentById(id);
    } catch (e) {
      debugPrint(e.toString());
      return null;
    }
  }

  Future<List<Package>> fetchStudentPackagesById(String id) async {
    try {
      return await Api().getStudentPackagesById(id);
    } catch (e) {
      debugPrint(e.toString());
      return [];
    }
  }

  Future<List<Batch>> fetchStudentBatchesById(String id) async {
    try {
      return await Api().getStudentBatchesById(id);
    } catch (e) {
      debugPrint(e.toString());
      return [];
    }
  }

  Future<StudentWallet?> fetchStudentWalletById(String id) async {
    try {
      debugPrint('Fetching wallet for: $id');
      return await Api().getStudentWalletById(id);
    } catch (e) {
      debugPrint(e.toString());
      return null;
    }
  }
}
