import 'package:albedo_app/model/payment_model.dart';
import 'package:get/get.dart';

class PaymentController extends GetxController {
  // var selectedType = PaymentUserType.student.obs;
  var selectedTab = 0.obs; // 0 = pending, 1 = approved

  var allStudentPayments = <StudentPaymentModel>[].obs;
  var allTeacherPayments = <TeacherPaymentModel>[].obs;
  var studentPayments = <StudentPaymentModel>[].obs;
  var teacherPayments = <TeacherPaymentModel>[].obs;
  var searchQuery = ''.obs;

  List<String> statusMap = ["pending", "approved"];


  // void fetchPayments() async {
  //   // 🔥 Call API based on type
  //   // Example:
  //   // final data = await api.getPayments(type: selectedType.value);

  //   // dummy
  //   allPayments.value = [];

  //   applyFilters();
  // }

  void fetchStudents() {
    studentPayments.value = [
      StudentPaymentModel(
        name: "JOANNA GRACE BENSON",
        id: "ALB/STU/02326",
        balance: -500.0,
        admissionFee: 500,
        depTxns: 1,
        credTxns: 0,
        deposited: 0,
        creditLimit: 0,
        creditAmount: 0,
        depPending: 11500,
        status: "pending",
      ),
      StudentPaymentModel(
        name: "ARUN KUMAR",
        id: "ALB/STU/04567",
        balance: 2000.0,
        admissionFee: 500,
        depTxns: 3,
        credTxns: 1,
        deposited: 2000,
        creditLimit: 5000,
        depPending: 0,
        creditAmount: 1000,
        status: "approved",
      ),
    ];
  }

  void fetchTeachers() {
    teacherPayments.value = [
      TeacherPaymentModel(
        name: "MR. JOHN DOE",
        id: "ALB/TEA/01234",
        balance: 1500.0,
        total: 5000,
        totalWithdawal: 3500,
        pending: 1,
        status: "pending",
      ),
      TeacherPaymentModel(
        name: "MS. JANE SMITH",
        id: "ALB/TEA/05678",
        balance: 3000.0,
        total: 8000,
        totalWithdawal: 5000,
        pending: 0,
        status: "approved",
      ),
    ];
  }

  List<StudentPaymentModel> get filteredStudentPayments {
    return studentPayments.where((e) {
      return selectedTab.value == 0
          ? e.status == 'pending'
          : e.status == 'approved';
    }).toList();
  }
  List<TeacherPaymentModel> get filteredTeacherPayments {
    return teacherPayments.where((e) {
      return selectedTab.value == 0
          ? e.status == 'pending'
          : e.status == 'approved';
    }).toList();
  }

  // void switchType(PaymentUserType type) {
  //   selectedType.value = type;
  //   fetchPayments();
  // }

  // void applyFilters() {
  //   filteredPayments.value = allPayments
  //       .where((e) => e.status == statusMap[selectedTab.value])
  //       .toList();
  // }
}
