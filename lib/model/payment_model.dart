import 'package:albedo_app/model/batch_model.dart';
import 'package:albedo_app/model/users/mentor_model.dart';

enum PaymentUserType { student, teacher, batch }

class StudentPaymentModel {
  final String name;
  final String id;
  String? studentId;

  double? balance;
  int? packages;
  double? admissionFee;
  bool? admissionFeePaid;
  double? courseFee;

  /// deposit transactions count
  int? depositTransactions;

  /// credit transactions count
  int? creditTransactions;

  /// total deposited amount
  double? depositedAmount;

  double? creditLimit;

  /// pending deposit requests
  double? depositPending;
  double? depositApproved;

  double? creditAmount;

  /// pending / approved
  String? status;

  /// NEW FIELDS
  String? email;
  String? registrationId;
  String? phoneNumber;
  String? place;
  String? pincode;
  String? tuitionMode;
  bool? isLive;
  double? registrationFee;

  double? creditPendingAmount;
  double? creditApprovedAmount;

  double? refundPendingAmount;
  double? refundApprovedAmount;

  String? mentorName;
  String? mentorEmpId;
  String? mentorPhoneNumber;

  String? coordinatorName;
  String? coordinatorEmpId;
  String? coordinatorPhoneNumber;

  String? teacherName;
  String? teacherId;
  String? teacherPhoneNumber;

  DateTime? studentCreatedAt;
  DateTime? classStartedAt;

  int? totalSessionsCount;
  int? completedSessionsCount;

  String? classStartNote;

  /// batch summary
  int? batchCount;
  double? batchFee;
  double? batchPaid;
  double? batchBalance;

  /// package summary
  double? packageFee;
  double? packagePaid;
  double? packageBalance;

  /// totals
  double? totalPaid;
  double? balanceDue;

  StudentPaymentModel({
    required this.name,
    required this.id,
    this.studentId,
    this.balance,
    this.admissionFeePaid,
    this.packages,
    this.admissionFee,
    this.courseFee,
    this.depositTransactions,
    this.creditTransactions,
    this.depositedAmount,
    this.creditLimit,
    this.depositPending,
    this.depositApproved,
    this.creditAmount,
    this.status,

    /// NEW
    this.email,
    this.registrationId,
    this.phoneNumber,
    this.place,
    this.pincode,
    this.tuitionMode,
    this.isLive,
    this.registrationFee,
    this.mentorName,
    this.mentorEmpId,
    this.mentorPhoneNumber,
    this.coordinatorName,
    this.coordinatorEmpId,
    this.coordinatorPhoneNumber,
    this.teacherName,
    this.teacherId,
    this.teacherPhoneNumber,
    this.studentCreatedAt,
    this.classStartedAt,
    this.totalSessionsCount,
    this.completedSessionsCount,
    this.classStartNote,
    this.batchCount,
    this.batchFee,
    this.batchPaid,
    this.batchBalance,
    this.creditPendingAmount,
    this.creditApprovedAmount,
    this.refundPendingAmount,
    this.refundApprovedAmount,
    this.packageFee,
    this.packagePaid,
    this.packageBalance,
    this.totalPaid,
    this.balanceDue,
  });

  factory StudentPaymentModel.fromJson(Map<String, dynamic> json) {
    return StudentPaymentModel(
      name: json['name'] ?? '',
      id: json['student_id'] ?? '',
      studentId: json['registration_id'] ?? '',

      balance: (json['current_wallet_balance'] ?? 0).toDouble(),

      status: json['status'],

      registrationFee: (json['registration_fee'] ?? 0).toDouble(),

      admissionFeePaid: json['registration_fee_paid'],

      /// course summary
      packages: json['course_summary']?['packages']?['count'] ?? 0,

      admissionFee:
          (json['course_summary']?['admission']?['fee_due'] ?? 0).toDouble(),

      courseFee: (json['course_summary']?['course_fee_total'] ?? 0).toDouble(),

      totalPaid: (json['course_summary']?['total_paid'] ?? 0).toDouble(),

      balanceDue: (json['course_summary']?['balance_due'] ?? 0).toDouble(),

      /// package summary
      packageFee:
          (json['course_summary']?['packages']?['total_fee'] ?? 0).toDouble(),

      packagePaid:
          (json['course_summary']?['packages']?['total_paid'] ?? 0).toDouble(),

      packageBalance:
          (json['course_summary']?['packages']?['balance'] ?? 0).toDouble(),

      /// batch summary
      batchCount: json['course_summary']?['batches']?['count'] ?? 0,

      batchFee:
          (json['course_summary']?['batches']?['total_fee'] ?? 0).toDouble(),

      batchPaid:
          (json['course_summary']?['batches']?['total_paid'] ?? 0).toDouble(),

      batchBalance:
          (json['course_summary']?['batches']?['balance'] ?? 0).toDouble(),

      /// transactions
      depositTransactions:
          json['transaction_statistics']?['deposit']?['total_count'] ?? 0,

      depositedAmount:
          (json['transaction_statistics']?['deposit']?['total_amount'] ?? 0)
              .toDouble(),

      depositPending: (json['transaction_statistics']?['deposit']?['pending']
                  ?['amount'] ??
              0)
          .toDouble(),
      depositApproved: (json['transaction_statistics']?['deposit']?['approved']
                  ?['amount'] ??
              0)
          .toDouble(),

      creditTransactions:
          json['transaction_statistics']?['total_credit_transactions'] ?? 0,

      creditLimit: (json['transaction_statistics']?['credit_limit']
                  ?['total_amount'] ??
              0)
          .toDouble(),

      creditAmount: (json['transaction_statistics']?['credit_payment']
                  ?['total_amount'] ??
              0)
          .toDouble(),

      creditPendingAmount: (json['transaction_statistics']?['credit_limit']
                  ?['pending']?['amount'] ??
              0)
          .toDouble(),

      creditApprovedAmount: (json['transaction_statistics']?['credit_limit']
                  ?['approved']?['amount'] ??
              0)
          .toDouble(),

      refundPendingAmount: (json['transaction_statistics']?['refund']
                  ?['pending']?['amount'] ??
              0)
          .toDouble(),

      refundApprovedAmount: (json['transaction_statistics']?['refund']
                  ?['approved']?['amount'] ??
              0)
          .toDouble(),

      /// extra fields
      email: json['email'],
      registrationId: json['registration_id'],
      phoneNumber: json['phone_number'],
      place: json['place'],
      pincode: json['pincode'],
      tuitionMode: json['tuition_mode'],
      isLive: json['is_live'],

      mentorName: json['mentor_name'],
      mentorEmpId: json['mentor_emp_id'],
      mentorPhoneNumber: json['mentor_phone_number'],

      coordinatorName: json['coordinator_name'],
      coordinatorEmpId: json['coordinator_emp_id'],
      coordinatorPhoneNumber: json['coordinator_phone_number'],

      teacherName: json['teacher_name'],
      teacherId: json['teacher_id'],
      teacherPhoneNumber: json['teacher_phone_number'],

      totalSessionsCount: json['total_sessions_count'] ?? 0,

      completedSessionsCount: json['completed_sessions_count'] ?? 0,

      classStartNote: json['class_start_note'],

      studentCreatedAt: json['student_created_at'] != null
          ? DateTime.parse(json['student_created_at'])
          : null,

      classStartedAt: json['class_started_at'] != null
          ? DateTime.parse(json['class_started_at'])
          : null,
    );
  }

  StudentPaymentModel copyWith({
    String? name,
    String? id,
    String? studentId,
    double? balance,
    int? packages,
    double? admissionFee,
    bool? admissionFeePaid,
    double? courseFee,
    int? depositTransactions,
    int? creditTransactions,
    double? depositedAmount,
    double? creditLimit,
    double? depositPending,
    double? depositApproved,
    double? creditAmount,
    String? status,
  }) {
    return StudentPaymentModel(
      name: name ?? this.name,
      id: id ?? this.id,
      studentId: studentId ?? this.studentId,
      balance: balance ?? this.balance,
      packages: packages ?? this.packages,
      admissionFee: admissionFee ?? this.admissionFee,
      admissionFeePaid: admissionFeePaid ?? this.admissionFeePaid,
      courseFee: courseFee ?? this.courseFee,
      depositTransactions: depositTransactions ?? this.depositTransactions,
      creditTransactions: creditTransactions ?? this.creditTransactions,
      depositedAmount: depositedAmount ?? this.depositedAmount,
      creditLimit: creditLimit ?? this.creditLimit,
      depositPending: depositPending ?? this.depositPending,
      depositApproved: depositApproved ?? this.depositApproved,
      creditAmount: creditAmount ?? this.creditAmount,
      status: status ?? this.status,
    );
  }
}

class TeacherPaymentModel {
  final String id;
  final String teacherId;
  final String name;

  String? email;
  String? phoneNumber;
  String? place;
  String? pincode;
  String? qualification;
  String? mode;

  bool? isLive;

  double? balance;

  /// financial summary
  double? totalEarned;
  double? totalSalary;
  double? totalBatchSalary;
  double? totalCommission;
  double? totalBonus;

  double? alreadyPaid;
  double? pendingWithdrawn;
  double? rejectedWithdrawn;

  double? netEarnings;
  double? availableToWithdraw;

  double? outstandingBalance;

  /// withdrawal stats
  int? withdrawalRequests;
  int? pendingTransactions;

  /// pending / approved
  String? status;

  List<MonthlyEarning>? monthlyEarnings;

  TeacherPaymentModel({
    required this.id,
    required this.teacherId,
    required this.name,
    this.email,
    this.phoneNumber,
    this.place,
    this.pincode,
    this.qualification,
    this.mode,
    this.isLive,
    this.balance,
    this.totalEarned,
    this.totalSalary,
    this.totalBatchSalary,
    this.totalCommission,
    this.totalBonus,
    this.alreadyPaid,
    this.pendingWithdrawn,
    this.rejectedWithdrawn,
    this.netEarnings,
    this.availableToWithdraw,
    this.outstandingBalance,
    this.withdrawalRequests,
    this.pendingTransactions,
    this.status,
    this.monthlyEarnings,
  });

  factory TeacherPaymentModel.fromJson(Map<String, dynamic> json) {
    final financial = json['financial_summary'] ?? {};
    final transaction = json['transaction_statistics'] ?? {};

    final outstandingBreakdown =
        financial['outstanding_breakdown'] as List? ?? [];

    return TeacherPaymentModel(
      id: json['id'] ?? '',
      teacherId: json['teacher_id'] ?? '',
      name: json['name'] ?? '',

      email: json['email'],
      phoneNumber: json['phone_number'],
      place: json['place'],
      pincode: json['pincode'],
      qualification: json['qualification'],
      mode: json['mode'],

      isLive: json['is_live'],

      balance: (json['current_wallet_balance'] ?? 0).toDouble(),

      /// financial summary
      totalEarned: (financial['all_time_total_earnings'] ?? 0).toDouble(),

      totalSalary: (financial['total_salary'] ?? 0).toDouble(),

      totalBatchSalary: (financial['total_batch_salary'] ?? 0).toDouble(),

      totalCommission: (financial['total_commission'] ?? 0).toDouble(),

      totalBonus: (financial['total_bonus'] ?? 0).toDouble(),

      alreadyPaid: (financial['already_paid_effective'] ?? 0).toDouble(),

      pendingWithdrawn: (financial['total_pending_withdrawn'] ?? 0).toDouble(),

      rejectedWithdrawn:
          (financial['total_rejected_withdrawn'] ?? 0).toDouble(),

      netEarnings: (financial['net_earnings'] ?? 0).toDouble(),

      availableToWithdraw: (financial['available_to_withdraw'] ?? 0).toDouble(),

      outstandingBalance: (financial['outstanding_balance'] ?? 0).toDouble(),

      /// withdrawal stats
      withdrawalRequests: transaction['withdrawal']?['total_count'] ?? 0,

      pendingTransactions: transaction['withdrawal']?['pending']?['count'] ?? 0,

      status: (transaction['withdrawal']?['pending']?['count'] ?? 0) > 0
          ? 'pending'
          : 'approved',

      /// monthly earnings
      monthlyEarnings: outstandingBreakdown.map<MonthlyEarning>((e) {
        return MonthlyEarning(
          month: e['month_label_short'] ?? '',
          amount: (e['outstanding_amount'] ?? 0).toDouble(),
          status: (e['has_pending_request'] ?? false) ? 'Pending' : 'Approved',
        );
      }).toList(),
    );
  }
}

class MonthlyEarning {
  final String month;
  final double amount;
  final String status;

  MonthlyEarning({
    required this.month,
    required this.amount,
    required this.status,
  });
}

class BatchPaymentModel {
  final String id;
  final String name;
  final String code;

  final Mentor? mentor;

  /// financial summary
  double? totalFee;
  double? totalPaid;
  double? totalPending;
  double? totalDeclined;
  double? balance;

  int? studentCount;
  int? pendingCount;
  int? approvedCount;
  int? declinedCount;

  BatchPaymentModel({
    required this.id,
    required this.name,
    required this.code,
    this.mentor,
    this.totalFee,
    this.totalPaid,
    this.totalPending,
    this.totalDeclined,
    this.balance,
    this.studentCount,
    this.pendingCount,
    this.approvedCount,
    this.declinedCount,
  });

  factory BatchPaymentModel.fromJson(Map<String, dynamic> json) {
    final financial = json['financial_summary'] ?? {};

    return BatchPaymentModel(
      id: json['id'] ?? '',
      name: json['name'] ?? '',
      code: json['code'] ?? '',
      mentor: json['mentor'] != null ? Mentor.fromJson(json['mentor']) : null,
      totalFee: (financial['total_fee'] ?? 0).toDouble(),
      totalPaid: (financial['total_paid'] ?? 0).toDouble(),
      totalPending: (financial['total_pending'] ?? 0).toDouble(),
      totalDeclined: (financial['total_declined'] ?? 0).toDouble(),
      balance: (financial['balance'] ?? 0).toDouble(),
      studentCount: financial['student_count'] ?? 0,
      pendingCount: financial['pending_count'] ?? 0,
      approvedCount: financial['approved_count'] ?? 0,
      declinedCount: financial['declined_count'] ?? 0,
    );
  }
}

class PaginatedStudentPaymentResponse {
  final int count;
  final String? next;
  final String? previous;
  final List<StudentPaymentModel> results;

  PaginatedStudentPaymentResponse({
    required this.count,
    required this.results,
    this.next,
    this.previous,
  });
}

class PaginatedTeacherPaymentResponse {
  final int count;
  final String? next;
  final String? previous;
  final List<TeacherPaymentModel> results;

  PaginatedTeacherPaymentResponse({
    required this.count,
    required this.results,
    this.next,
    this.previous,
  });
}

class PaymentItem {
  String id;
  String studentName;
  String studentId;
  String? paymentType;
  DateTime paymentDate;
  double amount;
  double balance;
  String status; // pending / completed / declined

  PaymentItem({
    required this.id,
    required this.studentName,
    required this.studentId,
    required this.paymentDate,
    this.paymentType,
    required this.amount,
    required this.balance,
    required this.status,
  });
}
