import 'package:albedo_app/controller/teacher_wallet_controller.dart';
import 'package:albedo_app/model/wallet_model.dart';
import 'package:albedo_app/widgets/custom_appbar.dart';
import 'package:albedo_app/widgets/widgets.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class TeacherWalletPage extends StatelessWidget {
  TeacherWalletPage({super.key});

  final c = Get.put(TeacherWalletController());

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;

    return Scaffold(
      appBar: CustomAppBar(),
      backgroundColor: Theme.of(context).colorScheme.surface,

      body: Column(
        children: [
          _totalBalance(cs),
          _filters(context),
          Expanded(
            child: Obx(() {
              final data = c.filteredWallets;
              return ListView.builder(
                padding: const EdgeInsets.all(12),
                itemCount: data.length,
                itemBuilder: (_, i) => _monthCard(context, data[i], cs),
              );
            }),
          ),
        ],
      ),
    );
  }

  Widget _filters(BuildContext context) {
    final months = const [
      "All",
      "January",
      "February",
      "March",
      "April",
      "May",
      "June",
      "July",
      "August",
      "September",
      "October",
      "November",
      "December"
    ];

    final years = ["All", ...List.generate(6, (i) => (2021 + i).toString())];

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      child: Row(
        children: [
          Expanded(
            child: Obx(() {
              return CustomWidgets().customDropdownField<String>(
                context: context,
                hint: "Select Month",
                items: months,
                value: c.selectedMonth.value,
                onChanged: (v) => c.changeMonth(v),
              );
            }),
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Obx(() {
              return CustomWidgets().customDropdownField<String>(
                context: context,
                hint: "Select Year",
                items: years,
                value: c.selectedYear.value,
                onChanged: (v) => c.changeYear(v),
              );
            }),
          ),
        ],
      ),
    );
  }

  Widget _totalBalance(ColorScheme cs) {
    return Container(
      margin: const EdgeInsets.all(12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: cs.primaryContainer,
        borderRadius: BorderRadius.circular(12),
      ),
      child: const Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text("Total Balance"),
          Text("₹45,000", style: TextStyle(fontWeight: FontWeight.bold)),
        ],
      ),
    );
  }

  Widget _monthCard(BuildContext context, Wallet data, ColorScheme cs) {
    return InkWell(
      borderRadius: BorderRadius.circular(16),
      onTap: () => _openDialog(context, data),
      child: Container(
        margin: const EdgeInsets.only(bottom: 12),
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(16),
          color: cs.surface,
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.04),
              blurRadius: 10,
              offset: const Offset(0, 4),
            )
          ],
          border: Border.all(color: cs.outline.withOpacity(0.08)),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "${data.month} ${data.year}",
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    Text(
                      "${data.transactions} transactions",
                      style: TextStyle(
                        fontSize: 12,
                        color: cs.onSurface.withOpacity(0.6),
                      ),
                    ),
                  ],
                ),

                /// 💰 NET (highlighted)
                Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Text(
                      "₹${data.net}",
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: cs.primary,
                      ),
                    ),
                    Text(
                      "Net",
                      style: TextStyle(
                        fontSize: 11,
                        color: cs.onSurface.withOpacity(0.6),
                      ),
                    ),
                  ],
                ),
              ],
            ),

            const SizedBox(height: 12),

            /// 🔥 MINI CARDS
            Row(
              children: [
                Expanded(
                  child: _miniCard(
                    "Earnings",
                    data.earnings.amount,
                    data.earnings.count,
                    Colors.green,
                  ),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: _miniCard(
                    "Withdrawals",
                    data.withdrawals.amount,
                    data.withdrawals.count,
                    Colors.red,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  void _openDialog(BuildContext context, Wallet data) {
    final c = Get.find<TeacherWalletController>();

    c.selectedStudent.value = null;

    CustomWidgets().showCustomDialog(
      context: context,

      title: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text("${data.month} ${data.year}"),
          Text(
            "${data.transactions} transactions",
            style: const TextStyle(fontSize: 12, color: Colors.white70),
          ),
        ],
      ),

      icon: Icons.wallet,

      formKey: GlobalKey<FormState>(),

      sections: [
        Obx(() {
          final student = c.selectedStudent.value;

          if (student != null) {
            return _studentDetailsView(c, student);
          }

          /// 🔁 DEFAULT VIEW
          return Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              _buildSummaryToggle(c, data),
              const SizedBox(height: 12),
              _buildTabsSection(data),
            ],
          );
        }),
      ],

      onSubmit: () {},
      isViewOnly: true
    );
  }

  Widget _studentDetailsView(
    TeacherWalletController c,
    Map<String, dynamic> student,
  ) {
    final tx = student["tx"];
    final amount = student["amount"];

    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            IconButton(
              onPressed: c.closeStudent,
              icon: const Icon(Icons.arrow_back),
            ),
            Text(
              student["name"],
              style: const TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 16,
              ),
            ),
          ],
        ),

        const SizedBox(height: 6),

        Text("$tx transactions • ₹$amount"),

        const SizedBox(height: 10),

        /// 🔥 TRANSACTIONS LIST
        SizedBox(
          height: 300,
          child: ListView.builder(
            itemCount: c.transactions.length,
            itemBuilder: (_, i) {
              final t = c.transactions[i];

              final sign = t.isWithdrawal ? "-" : "+";
              final color = t.isWithdrawal ? Colors.red : Colors.green;

              return Container(
                margin: const EdgeInsets.only(bottom: 10),
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(14),
                  color: Colors.white,
                  border: Border.all(color: Colors.grey.withOpacity(0.1)),
                ),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    /// LEFT
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            t.subject,
                            style: const TextStyle(fontWeight: FontWeight.w600),
                          ),
                          const SizedBox(height: 2),
                          Text(
                            t.subjectCode,
                            style: const TextStyle(
                                fontSize: 11, color: Colors.grey),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            _formatDate(t.dateTime),
                            style: const TextStyle(
                                fontSize: 11, color: Colors.grey),
                          ),
                          const SizedBox(height: 6),
                          Text(
                            "Note: ${t.note}",
                            style: const TextStyle(fontSize: 12),
                          ),
                        ],
                      ),
                    ),

                    /// RIGHT (IMPORTANT)
                    Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 10, vertical: 6),
                      decoration: BoxDecoration(
                        color: color.withOpacity(0.08),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Text(
                        "$sign₹${t.amount}",
                        style: TextStyle(
                          color: color,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ],
                ),
              );
            },
          ),
        )
      ],
    );
  }

  String _formatDate(DateTime dt) {
    return "${dt.day}/${dt.month}/${dt.year} • ${dt.hour}:${dt.minute}";
  }

  Widget _buildSummaryToggle(TeacherWalletController c, Wallet data) {
    return Obx(() {
      final isExpanded = c.expanded.value;

      return Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          /// 🔵 COMPACT TOGGLE
          InkWell(
            onTap: () {
              if (!c.expanded.value) {
                Future.microtask(() => c.expanded.value = true);
              } else {
                Future.microtask(() => c.expanded.value = false);
              }
            },
            child: Row(
              children: [
                Icon(
                  isExpanded
                      ? Icons.keyboard_arrow_up
                      : Icons.keyboard_arrow_down,
                  size: 18,
                  color: Colors.blue,
                ),
                const SizedBox(width: 4),
                const Text(
                  "View summary",
                  style: TextStyle(fontSize: 13, color: Colors.blue),
                ),
              ],
            ),
          ),

          /// 🔽 ONLY SHOW WHEN EXPANDED
          if (isExpanded) ...[
            const SizedBox(height: 8),

            /// 🔥 SAME HEIGHT CARDS
            IntrinsicHeight(
              child: Row(
                children: [
                  Expanded(
                    child: _summaryCard(
                      "Earnings",
                      data.earnings.amount,
                      _totalEarningTx(), // ✅ dynamic
                      Colors.green,
                    ),
                  ),
                  const SizedBox(width: 6),
                  Expanded(
                    child: _summaryCard(
                      "Withdrawals",
                      data.withdrawals.amount,
                      _totalWithdrawalTx(),
                      Colors.red,
                    ),
                  ),
                  const SizedBox(width: 6),
                  Expanded(
                    child: _summaryCard(
                      "Net",
                      data.net,
                      null,
                      Colors.blue,
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 10),

            if (data.earnings.amount != 0) _earningsBreakdown(),
          ],
        ],
      );
    });
  }

  int _totalEarningTx() {
    final students = _earningStudents();
    return students.fold(0, (sum, e) => sum + (e['tx'] as int));
  }

  int _totalWithdrawalTx() {
    final items = _withdrawalItems();
    return items.fold(0, (sum, e) => sum + (e['tx'] as int));
  }

  List<Map<String, dynamic>> _earningStudents() {
    return [
      {
        "name": "John Doe",
        "tx": 5,
        "amount": 15000,
        "type": "earning",
      },
      {
        "name": "Sarah",
        "tx": 5,
        "amount": 35000,
        "type": "earning",
      },
    ];
  }

  List<Map<String, dynamic>> _withdrawalItems() {
    return [
      {
        "name": "Bank Transfer",
        "tx": 2,
        "amount": 5000,
        "type": "withdrawal",
      },
    ];
  }

  Widget _earningsTab() {
    final students = _earningStudents();

    return ListView(
      shrinkWrap: true,
      physics: const ClampingScrollPhysics(),
      children: students.map((e) {
        return _studentCard(e);
      }).toList(),
    );
  }

  Widget _summaryCard(
    String title,
    int amount,
    int? count,
    Color color,
  ) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(14),
        color: color.withOpacity(0.07),
        border: Border.all(color: color.withOpacity(0.25)),
      ),
      child: Column(
        children: [
          Text(
            title,
            style: TextStyle(
              fontSize: 12,
              color: color,
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            "₹$amount",
            style: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
            ),
          ),
          if (count != null)
            Text(
              "$count transactions",
              style: const TextStyle(
                fontSize: 11,
                color: Colors.grey,
              ),
            ),
        ],
      ),
    );
  }

  Widget _earningsBreakdown() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text("Earnings Breakdown",
            style: TextStyle(fontWeight: FontWeight.bold)),
        const SizedBox(height: 8),
        IntrinsicHeight(
          child: Row(
            children: [
              Expanded(child: _breakdownCard("Salary", 30000, 6)),
              Expanded(child: _breakdownCard("Bonus", 10000, 2)),
              Expanded(child: _breakdownCard("Commission", 10000, 2)),
            ],
          ),
        ),
      ],
    );
  }

  Widget _breakdownCard(String title, int amount, int count) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 2),
      padding: const EdgeInsets.all(8),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10),
        color: Colors.green.withOpacity(0.06),
        border: Border.all(color: Colors.green.withOpacity(0.3)),
      ),
      child: Column(
        children: [
          Text(title,
              style: const TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.w600,
              )),

          const SizedBox(height: 4),

          Text(
            "₹$amount",
            style: const TextStyle(fontWeight: FontWeight.bold),
          ),

          /// 🔢 TX COUNT UNDER EACH BREAKDOWN
          Text(
            "$count txns",
            style: const TextStyle(fontSize: 11, color: Colors.grey),
          ),
        ],
      ),
    );
  }

  Widget _buildTabsSection(Wallet data) {
    return DefaultTabController(
      length: 2,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          TabBar(
            labelColor: Colors.black,
            tabs: [
              Tab(text: "Earnings (${data.earnings.count})"),
              Tab(text: "Withdrawals (${data.withdrawals.count})"),
            ],
          ),
          SizedBox(
            height: 280,
            child: TabBarView(
              children: [
                _earningsTab(),
                _withdrawalsTab(),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _withdrawalsTab() {
    final items = _withdrawalItems();

    return ListView(
      shrinkWrap: true,
      physics: const ClampingScrollPhysics(),
      children: items.map((e) {
        return _studentCard(e);
      }).toList(),
    );
  }

  Widget _studentCard(Map<String, dynamic> student) {
    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(14),
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.04),
            blurRadius: 8,
            offset: const Offset(0, 3),
          )
        ],
      ),
      child: ListTile(
        contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
        title: Text(
          student["name"],
          style: const TextStyle(fontWeight: FontWeight.w600),
        ),
        subtitle: Text(
          "${student["tx"]} transactions",
          style: const TextStyle(fontSize: 12),
        ),
        trailing: Text(
          "₹${student["amount"]}",
          style: const TextStyle(fontWeight: FontWeight.bold),
        ),
        onTap: () {
          final c = Get.find<TeacherWalletController>();
          c.openStudent(student);
        },
      ),
    );
  }

  Widget _miniCard(String title, int amount, int count, Color color) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(14),
        color: color.withOpacity(0.06),
        border: Border.all(color: color.withOpacity(0.2)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: TextStyle(
              fontSize: 12,
              color: color,
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 6),
          Text(
            "₹$amount",
            style: const TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 14,
            ),
          ),
          Text(
            "$count transactions",
            style: const TextStyle(
              fontSize: 11,
              color: Colors.grey,
            ),
          ),
        ],
      ),
    );
  }
}
