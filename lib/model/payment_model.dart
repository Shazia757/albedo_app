import 'package:albedo_app/model/batch_model.dart';

enum PaymentUserType { student, teacher }

class StudentPaymentModel {
  final String name;
  final String id;

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

  double? creditAmount;

  /// pending / approved
  String? status;

  StudentPaymentModel({
    required this.name,
    required this.id,
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
    this.creditAmount,
    this.status,
  });

  StudentPaymentModel copyWith({
  String? name,
  String? id,
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
  double? creditAmount,
  String? status,
}) {
  return StudentPaymentModel(
    name: name ?? this.name,
    id: id ?? this.id,
    balance: balance ?? this.balance,
    packages: packages ?? this.packages,
    admissionFee: admissionFee ?? this.admissionFee,
    admissionFeePaid:
        admissionFeePaid ?? this.admissionFeePaid,
    courseFee: courseFee ?? this.courseFee,
    depositTransactions:
        depositTransactions ?? this.depositTransactions,
    creditTransactions:
        creditTransactions ?? this.creditTransactions,
    depositedAmount:
        depositedAmount ?? this.depositedAmount,
    creditLimit: creditLimit ?? this.creditLimit,
    depositPending:
        depositPending ?? this.depositPending,
    creditAmount: creditAmount ?? this.creditAmount,
    status: status ?? this.status,
  );
}
}

class TeacherPaymentModel {
  final String name;
  final String id;

  double? balance;

  /// total withdrawal transactions
  double? totalEarned;
  double? alreadyPaid;

  /// total withdrawn amount
  int? withdrawalRequests;
  List<MonthlyEarning>? monthlyEarnings;

  /// pending withdrawal requests
  int? pendingTransactions;

  /// pending / approved
  String? status;

  TeacherPaymentModel({
    required this.name,
    required this.id,
    this.balance,
    this.totalEarned,
    this.alreadyPaid,
    this.monthlyEarnings,
    this.withdrawalRequests,
    this.pendingTransactions,
    this.status,
  });
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
  String? status;
  Batch batch;
  List<PaymentItem> payments;

  BatchPaymentModel({
    this.status,
    required this.batch,
    required this.payments,
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
