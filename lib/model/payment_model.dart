enum PaymentUserType { student, teacher }

class StudentPaymentModel {
  final String name;
  final String id;
  double? balance;
  double? admissionFee;
  int? depTxns;
  int? credTxns;
  double? deposited;
  double? creditLimit;
  int? depPending;
  double? creditAmount;
  String? status; // pending / approved

  StudentPaymentModel({
    required this.name,
    required this.id,
    this.balance,
    this.admissionFee,
    this.depTxns,
    this.credTxns,
    this.deposited,
    this.creditLimit,
    this.depPending,
    this.creditAmount,
    this.status,
  });
}

class TeacherPaymentModel {
  final String name;
  final String id;
  double? balance;
  int? total;
  double? totalWithdawal;
  int? pending;
  String? status; // pending / approved

  TeacherPaymentModel({
    required this.name,
    required this.id,
    this.balance,
    this.total,
    this.totalWithdawal,
    this.pending,
    this.status,
  });
}
