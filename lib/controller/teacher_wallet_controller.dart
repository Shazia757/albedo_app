import 'package:albedo_app/model/wallet_model.dart';
import 'package:get/get.dart';

class TeacherWalletController extends GetxController {
  var selectedMonth = "All".obs;
  var selectedYear = "All".obs;

  var expanded = false.obs;
  var wallets = <Wallet>[].obs;
  var transactions = <TransactionItem>[].obs;

  @override
  void onInit() {
    super.onInit();
    loadDummyData();
  }

  void loadDummyData() {
    wallets.value = [
      Wallet(
        month: "January",
        year: "2026",
        transactions: 12,
        net: 45000,
        earnings: Earnings(amount: 50000, count: 10),
        withdrawals: Withdrawals(amount: 5000, count: 2),
      ),
      Wallet(
        month: "February",
        year: "2026",
        transactions: 8,
        net: 30000,
        earnings: Earnings(amount: 35000, count: 6),
        withdrawals: Withdrawals(amount: 5000, count: 2),
      ),
    ];
  }

  List<Wallet> get filteredWallets {
    return wallets.where((w) {
      final monthMatch =
          selectedMonth.value == "All" || w.month == selectedMonth.value;

      final yearMatch =
          selectedYear.value == "All" || w.year == selectedYear.value;

      return monthMatch && yearMatch;
    }).toList();
  }

  void changeMonth(String v) => selectedMonth.value = v;
  void changeYear(String v) => selectedYear.value = v;

  void toggleExpanded() => expanded.value = !expanded.value;

  var selectedStudent = Rxn<Map<String, dynamic>>();

  void openStudent(Map<String, dynamic> student) {
    selectedStudent.value = student;

    final isWithdrawal = student["type"] == "withdrawal";

    /// 🔥 GENERATE CORRECT TRANSACTIONS
    transactions.value = List.generate(student["tx"], (i) {
      return TransactionItem(
        subject: "Subject ${i + 1}",
        subjectCode: "SUBJ-${100 + i}",
        note: isWithdrawal ? "Withdrawal processed" : "Tuition payment",
        dateTime: DateTime.now().subtract(Duration(days: i)),
        amount: student["amount"] ~/ student["tx"],
        isWithdrawal: isWithdrawal, // ✅ THIS FIXES YOUR BUG
      );
    });
  }

  void closeStudent() {
    selectedStudent.value = null;
    transactions.clear();
  }

// List<TransactionItem> transactions = [
//   TransactionItem(
//     subject: "Mathematics",
//     subjectCode: "SUBJ-101",
//     note: "Monthly tuition fee",
//     dateTime: DateTime.now(),
//     amount: 3000,
//     isWithdrawal: false,
//   ),
//   TransactionItem(
//     subject: "Physics",
//     subjectCode: "SUBJ-102",
//     note: "Extra class",
//     dateTime: DateTime.now().subtract(Duration(days: 1)),
//     amount: 2000,
//     isWithdrawal: false,
//   ),
// ];
}
