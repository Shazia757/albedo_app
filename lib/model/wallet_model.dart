import 'package:albedo_app/model/package_model.dart';
import 'package:albedo_app/model/users/student_model.dart';

class Wallet {
  String? month;
  String? year;
  List<Transactions>? transactions;
  int? net;
  int? availableCredit;
  int? creditLimit;
  int? creditUsed;
  Earnings? earnings;
  Withdrawals? withdrawals;

  Wallet({
    this.month,
    this.year,
    this.availableCredit,
    this.transactions,
    this.net,
    this.earnings,
    this.withdrawals,
  });
}

class Transactions {
  int? amount;
  DateTime? date;
  String? description;
  Package? package;
  Student? student;
  String? transactionType;
}

class Earnings {
  int? amount; //total
  int? count;

  Earnings({this.amount, this.count});
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
  String? status;
  final String? type;
  final String? title;
  final String? addedBy;
  final String? description;
  final double? amount;
  final DateTime? dateTime;
  final String id;

  TransactionModel({
    this.status,
    this.type,
    this.title,
    this.addedBy,
    this.description,
    this.amount,
    this.dateTime,
    this.id = '',
  });

  TransactionModel copyWith({
    String? status,
    String? type,
    String? title,
    String? addedBy,
    String? description,
    double? amount,
    DateTime? dateTime,
    String? id,
  }) {
    return TransactionModel(
      status: status ?? this.status,
      type: type ?? this.type,
      title: title ?? this.title,
      addedBy: addedBy ?? this.addedBy,
      description: description ?? this.description,
      amount: amount ?? this.amount,
      dateTime: dateTime ?? this.dateTime,
      id: id ?? this.id,
    );
  }
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
