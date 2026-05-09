import 'package:albedo_app/model/batch_model.dart';
import 'package:albedo_app/model/payment_model.dart';
import 'package:albedo_app/model/users/mentor_model.dart';
import 'package:albedo_app/model/wallet_model.dart';
import 'package:get/get.dart';

class PaymentController extends GetxController {
  PaymentController({
    required this.isStudent,
  });
  final bool isStudent;
  RxBool isSearching = false.obs;
  var selectedTab = 0.obs; // 0 = pending, 1 = approved
  final tabs = ["Pending", "Approved"];
  
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
  var studentPayments = <StudentPaymentModel>[].obs;
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

    if (isStudent) {
      fetchStudents();
    } else {
      fetchTeachers();
    }

    fetchBatches();

    applyFilters();
  }

  void fetchStudents() {
    studentPayments.value = [
      StudentPaymentModel(
        name: "JOANNA GRACE BENSON",
        id: "ALB/STU/02326",
        balance: 500.0,
        admissionFee: 500,
        depositTransactions: 1,
        creditTransactions: 0,
        depositedAmount: 0,
        creditLimit: 0,
        creditAmount: 0,
        depositPending: 11500,
        status: "pending",
      ),
      StudentPaymentModel(
        name: "ARUN KUMAR",
        id: "ALB/STU/04567",
        balance: 2000.0,
        admissionFee: 500,
        depositTransactions: 3,
        creditTransactions: 1,
        depositedAmount: 2000,
        creditLimit: 5000,
        depositPending: 0,
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
          withdrawalRequests: 24,
          pendingTransactions: 1,
          status: "pending",
          monthlyEarnings: [
            MonthlyEarning(month: 'May 2026', amount: 1000, status: 'Approved'),
            MonthlyEarning(
                month: 'March 2026', amount: 5000, status: 'Approved'),
            MonthlyEarning(
                month: 'April 2026', amount: 2000, status: 'Pending'),
          ]),
      TeacherPaymentModel(
        name: "MS. JANE SMITH",
        id: "ALB/TEA/05678",
        balance: 3000.0,
        withdrawalRequests: 10,
        pendingTransactions: 0,
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
          mentor: Mentor(name: 'John', empId: 'id'),
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
            mentor: Mentor(name: 'Mary Teacher', empId: 'empId')),
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

  void applyFilters() {
    final query = searchQuery.value.toLowerCase().trim();

    if (isStudent) {
      List<StudentPaymentModel> temp = List.from(studentPayments);

      final status = selectedTab.value;

      /// TAB FILTER
      switch (status) {
        case 0: // dep pending
          temp = temp.where((e) => (e.depositPending ?? 0) > 0).toList();
          break;

        case 1: // dep approved
          temp = temp.where((e) => (e.depositedAmount ?? 0) > 0).toList();
          break;

        case 2: // cred pending
          temp = temp.where((e) => e.status == 'cred_pending').toList();
          break;

        case 3: // cred approved
          temp = temp.where((e) => e.status == 'cred_approved').toList();
          break;

        case 4: // ref pending
          temp = temp.where((e) => e.status == 'ref_pending').toList();
          break;

        case 5: // ref approved
          temp = temp.where((e) => e.status == 'ref_approved').toList();
          break;
      }

      /// SEARCH
      if (query.isNotEmpty) {
        temp = temp.where((e) {
          return e.name.toLowerCase().contains(query) ||
              e.id.toLowerCase().contains(query);
        }).toList();
      }

      /// SORT
      temp.sort((a, b) => a.name.compareTo(b.name));

      filteredStudentPayments.assignAll(temp);
    } else {
      List<TeacherPaymentModel> temp = List.from(teacherPayments);

      /// TAB FILTER
      if (selectedTab.value == 0) {
        temp = temp.where((e) => (e.pendingTransactions ?? 0) > 0).toList();
      } else {
        temp = temp.where((e) => e.status == 'approved').toList();
      }

      /// SEARCH
      if (query.isNotEmpty) {
        temp = temp.where((e) {
          return e.name.toLowerCase().contains(query) ||
              e.id.toLowerCase().contains(query);
        }).toList();
      }

      temp.sort((a, b) => a.name.compareTo(b.name));

      filteredTeacherPayments.assignAll(temp);
    }
  }

  int get pendingCount =>
      batchPayments.where((e) => e.status == 'pending').length;

  int get approvedCount =>
      batchPayments.where((e) => e.status == 'approved').length;

  int get depPendingCount => studentPayments
      .where(
        (e) => (e.depositPending ?? 0) > 0,
      )
      .length;

  int get depApprovedCount => studentPayments
      .where(
        (e) => (e.depositedAmount ?? 0) > 0,
      )
      .length;

  int get credPendingCount => studentPayments
      .where(
        (e) => (e.creditAmount ?? 0) > 0 && (e.status == 'cred_pending'),
      )
      .length;

  int get credApprovedCount => studentPayments
      .where(
        (e) => (e.creditAmount ?? 0) > 0 && (e.status == 'cred_approved'),
      )
      .length;

  int get refPendingCount => studentPayments
      .where(
        (e) => e.status == 'ref_pending',
      )
      .length;

  int get refApprovedCount => studentPayments
      .where(
        (e) => e.status == 'ref_approved',
      )
      .length;

  List<Map<String, dynamic>> get studentTabData => [
        {
          "label": "Dep Pending",
          "count": depPendingCount,
        },
        {
          "label": "Dep Approved",
          "count": depApprovedCount,
        },
        {
          "label": "Cred Pending",
          "count": credPendingCount,
        },
        {
          "label": "Cred Approved",
          "count": credApprovedCount,
        },
        {
          "label": "Ref Pending",
          "count": refPendingCount,
        },
        {
          "label": "Ref Approved",
          "count": refApprovedCount,
        },
      ];
  List<Map<String, dynamic>> get tabData => [
        {"label": "Pending", "count": pendingCount},
        {"label": "Approved", "count": approvedCount},
      ];


 


}
