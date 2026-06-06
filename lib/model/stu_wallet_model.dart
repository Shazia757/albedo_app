class StudentWallet {
  double? balance;
  double? available;
  double? onHold;

  /// 🔷 Credit
  double? creditLimit;
  double? creditUsed;

  /// 🔷 Deposits
  double? totalDeposited;
  double? pendingDeposits;

  /// 🔷 Usage
  double? walletUsed;
  double? creditUsedAmount;

  /// 🔷 Registration
  double? registrationFee;
  DateTime? registrationPaidAt;

  /// 🔷 Transactions
  List<WalletTransaction>? transactions;

  /// 🔷 Credit history
  List<CreditTransaction>? creditTransactions;

  StudentWallet({
    this.balance,
    this.available,
    this.onHold,
    this.creditLimit,
    this.creditUsed,
    this.totalDeposited,
    this.pendingDeposits,
    this.walletUsed,
    this.creditUsedAmount,
    this.registrationFee,
    this.registrationPaidAt,
    this.transactions,
    this.creditTransactions,
  });

  factory StudentWallet.fromJson(Map<String, dynamic> json) {
    final creditInfo = json['credit_info'] ?? {};

    return StudentWallet(
      balance: double.tryParse(json['balance']?.toString() ?? ''),
      available: double.tryParse(json['available_funds']?.toString() ?? ''),
      onHold: double.tryParse(json['pending_balance']?.toString() ?? ''),

      creditLimit:
          double.tryParse(creditInfo['credit_limit']?.toString() ?? ''),
      creditUsed:
          double.tryParse(creditInfo['credit_used']?.toString() ?? ''),
      creditUsedAmount:
          double.tryParse(creditInfo['credit_consumed']?.toString() ?? ''),

      totalDeposited: null,
      pendingDeposits: null,
      walletUsed: null,
      registrationFee: null,

      transactions: null,
      creditTransactions: null,

      registrationPaidAt: json['date_added'] != null
          ? DateTime.tryParse(json['date_added'])
          : null,
    );
  }
}
class WalletTransaction {
  String type; // deposit, refund, class_payment
  String status; // success, pending
  double amount;
  String description;
  DateTime date;

  WalletTransaction({
    required this.type,
    required this.status,
    required this.amount,
    required this.description,
    required this.date,
  });
}

class CreditTransaction {
  String type; // limit_change, repayment, class_payment
  int count;
  DateTime date;

  CreditTransaction({
    required this.type,
    required this.count,
    required this.date,
  });
}
