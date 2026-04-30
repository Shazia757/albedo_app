class Wallet {
  final String month;
  final String year;
  final int transactions;
  final int net;
  final Earnings earnings;
  final Withdrawals withdrawals;

  Wallet({
    required this.month,
    required this.year,
    required this.transactions,
    required this.net,
    required this.earnings,
    required this.withdrawals,
  });
}

class Earnings {
  final int amount;
  final int count;

  Earnings({required this.amount, required this.count});
}

class Withdrawals {
  final int amount;
  final int count;

  Withdrawals({required this.amount, required this.count});
}

class TransactionItem {
  final String subject;
  final String subjectCode;
  final String note;
  final DateTime dateTime;
  final int amount;
  final bool isWithdrawal;

  TransactionItem({
    required this.subject,
    required this.subjectCode,
    required this.note,
    required this.dateTime,
    required this.amount,
    required this.isWithdrawal,
  });
}

class TransactionModel {
  final String status;
  final String type;
  final String title;
  final String description;
  final double amount;
  final DateTime dateTime;

  TransactionModel({
    required this.status,
    required this.type,
    required this.title,
    required this.description,
    required this.amount,
    required this.dateTime,
  });
}

class Withdrawal {
  final double amount;
  final DateTime date;
  final String? note;

  Withdrawal({
    required this.amount,
    required this.date,
    this.note,
  });
}