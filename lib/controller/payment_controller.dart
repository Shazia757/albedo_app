import 'package:albedo_app/model/batch_model.dart';
import 'package:albedo_app/model/payment_model.dart';
import 'package:get/get.dart';

class PaymentController extends GetxController {
  // var selectedType = PaymentUserType.student.obs;
  var selectedTab = 0.obs; // 0 = pending, 1 = approved

  var allStudentPayments = <StudentPaymentModel>[].obs;
  var allTeacherPayments = <TeacherPaymentModel>[].obs;
  var allBatchPayments = <BatchPaymentModel>[].obs;
  var studentPayments = <StudentPaymentModel>[].obs;
  var teacherPayments = <TeacherPaymentModel>[].obs;
  var batchPayments = <BatchPaymentModel>[].obs;
  var searchQuery = ''.obs;

  List<String> statusMap = ["pending", "approved"];

  @override
  void onInit() {
    super.onInit();
    fetchBatches();
  }

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

  void fetchBatches() {
    batchPayments.value = [
      BatchPaymentModel(
        batch: Batch(
          batchName: "ATTC",
          batchID: "ALB/BAT/01234",
          mentorName: "John Mentor",
        ),
        status: "pending",
        payments: [
          PaymentItem(
            id: "P001",
            studentName: "Akhil",
            studentId: "STU1001",
            paymentDate: DateTime(2026, 4, 10),
            amount: 5000,
            balance: 1500,
            status: "pending",
          ),
          PaymentItem(
            id: "P002",
            studentName: "Nihal",
            studentId: "STU1002",
            paymentDate: DateTime(2026, 4, 12),
            amount: 4500,
            balance: 1000,
            status: "completed",
          ),
          PaymentItem(
            id: "P003",
            studentName: "Sana",
            studentId: "STU1003",
            paymentDate: DateTime(2026, 4, 15),
            amount: 6000,
            balance: 2000,
            status: "declined",
          ),
        ],
      ),
      BatchPaymentModel(
        batch: Batch(
          batchName: "10th CBSE",
          batchID: "ALB/BAT/05678",
          mentorName: "Mary Teacher",
        ),
        status: "approved",
        payments: [
          PaymentItem(
            id: "P101",
            studentName: "Arjun",
            studentId: "STU2001",
            paymentDate: DateTime(2026, 4, 5),
            amount: 7000,
            balance: 3000,
            status: "completed",
          ),
          PaymentItem(
            id: "P102",
            studentName: "Diya",
            studentId: "STU2002",
            paymentDate: DateTime(2026, 4, 8),
            amount: 6500,
            balance: 2500,
            status: "pending",
          ),
          PaymentItem(
            id: "P103",
            studentName: "Rohan",
            studentId: "STU2003",
            paymentDate: DateTime(2026, 4, 11),
            amount: 8000,
            balance: 0,
            status: "completed",
          ),
          PaymentItem(
            id: "P104",
            studentName: "Ananya",
            studentId: "STU2004",
            paymentDate: DateTime(2026, 4, 18),
            amount: 5000,
            balance: 500,
            status: "declined",
          ),
        ],
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

  List<BatchPaymentModel> get filteredBatchPayments {
    return batchPayments.where((e) {
      return selectedTab.value == 0
          ? e.status == 'pending'
          : e.status == 'approved';
    }).toList();
  }

}
