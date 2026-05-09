import 'package:albedo_app/model/package_model.dart';
import 'package:albedo_app/model/users/teacher_model.dart';
import 'package:albedo_app/model/wallet_model.dart';
import 'package:get/get.dart';

class StudentWalletController extends GetxController {
  var selectedTab = 0.obs;

  // Dummy Transactions
  var transactions = <TransactionModel>[
    TransactionModel(
      status: "Success",
      type: "Credit",
      title: "Package Payment",
      description: "Paid for Maths package",
      amount: 2000,
      dateTime: DateTime.now(),
    ),
    TransactionModel(
      status: "Pending",
      type: "Debit",
      title: "Withdrawal",
      description: "Requested withdrawal",
      amount: 500,
      dateTime: DateTime.now(),
    ),
  ].obs;

  // Dummy Packages
  var packages = <Package>[
    Package(
      teacher: Teacher(
          id: '', name: '', status: '', joinedAt: DateTime.now(), gender: ''),
      subjectId: '',
      status: '',
      time: '',
      duration: '',
      subjectName: "Mathematics",
      syllabus: "CBSE",
      standard: "10",
      packageFee: 5000,
      takenFee: 3000,
      balance: 2000,
      withdrawals: [
        Withdrawal(amount: 500, date: DateTime.now(), note: 'sd'),
        Withdrawal(amount: 500, date: DateTime.now(), note: 'sf')
      ],
      note: "Partial withdrawal",
    ),
  ].obs;

  double get totalBalance {
    return packages.fold(
      0.0,
      (sum, p) => sum + getPackageBalance(p),
    );
  }

  double get totalDeposited {
    return packages.fold(0.0, (sum, p) {
      final packageFee = p.packageFee ?? 0;
      return sum + packageFee;
    });
  }

  double get totalUsed {
    return packages.fold(0.0, (sum, p) {
      final withdrawals = p.withdrawals ?? [];
      return sum + withdrawals.fold(0.0, (s, w) => s + w.amount);
    });
  }

  double getPackageBalance(Package p) {
    final withdrawals = p.withdrawals ?? [];

    final totalWithdrawals = withdrawals.fold(0.0, (sum, w) => sum + w.amount);

    return p.packageFee ?? 0 - totalWithdrawals;
  }

  void updateStatus(String id, String status) {
    final index = transactions.indexWhere((e) => e.id == id);

    if (index != -1) {
      transactions[index] = transactions[index].copyWith(status: status);
      transactions.refresh();
    }
  }
}
