class StudentWallet {
  double balance;
  double available;
  double onHold;

  /// 🔷 Credit
  double creditLimit;
  double creditUsed;

  /// 🔷 Deposits
  double totalDeposited;
  double pendingDeposits;

  /// 🔷 Usage
  double walletUsed;
  double creditUsedAmount;

  /// 🔷 Registration
  double registrationFee;
  DateTime? registrationPaidAt;

  /// 🔷 Transactions
  List<WalletTransaction> transactions;

  /// 🔷 Credit history
  List<CreditTransaction> creditTransactions;

  StudentWallet({
    this.balance = 0,
    this.available = 0,
    this.onHold = 0,
    this.creditLimit = 0,
    this.creditUsed = 0,
    this.totalDeposited = 0,
    this.pendingDeposits = 0,
    this.walletUsed = 0,
    this.creditUsedAmount = 0,
    this.registrationFee = 0,
    this.registrationPaidAt,
    this.transactions = const [],
    this.creditTransactions = const [],
  });
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
