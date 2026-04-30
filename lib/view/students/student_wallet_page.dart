import 'package:albedo_app/controller/student_wallet_controller.dart';
import 'package:albedo_app/model/package_model.dart';
import 'package:albedo_app/model/wallet_model.dart';
import 'package:albedo_app/widgets/custom_appbar.dart';
import 'package:albedo_app/widgets/widgets.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_connect/http/src/utils/utils.dart';

class StudentWalletPage extends StatelessWidget {
  StudentWalletPage({super.key});

  final c = Get.put(StudentWalletController());

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;

    return DefaultTabController(
      length: 2,
      child: Builder(builder: (context) {
        final tabController = DefaultTabController.of(context);
        return Scaffold(
          appBar: CustomAppBar(),
          floatingActionButton: AnimatedBuilder(
            animation: tabController,
            builder: (_, __) {
              // ✅ Show FAB only on Transactions tab (index 0)
              if (tabController.index != 0) return const SizedBox();

              return FloatingActionButton.extended(
                elevation: 3,
                backgroundColor: cs.primary,
                foregroundColor: cs.onPrimary,
                onPressed: () => _showDepositDialog(context),
                icon: const Icon(Icons.add_rounded, size: 20),
                label: const Text(
                  "Deposit",
                  style: TextStyle(
                    fontWeight: FontWeight.w600,
                    letterSpacing: 0.5,
                  ),
                ),
              );
            },
          ),
          body: Column(
            children: [
              // Title Section
              Container(
                width: double.infinity,
                padding: const EdgeInsets.fromLTRB(20, 16, 20, 8),
                child: Text(
                  "Wallet",
                  style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                        fontWeight: FontWeight.w700,
                        letterSpacing: -0.5,
                      ),
                ),
              ),

              _totalBalance(context),

              // Tab Bar
              Container(
                margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                decoration: BoxDecoration(
                  color: cs.surfaceContainerHighest,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: TabBar(
                  dividerColor: Colors.transparent,
                  indicator: BoxDecoration(
                    color: cs.primary,
                    borderRadius: BorderRadius.circular(10),
                  ),
                  indicatorSize: TabBarIndicatorSize.tab,
                  labelColor: cs.onPrimary,
                  unselectedLabelColor: cs.onSurfaceVariant,
                  labelStyle: const TextStyle(
                    fontWeight: FontWeight.w600,
                    fontSize: 14,
                  ),
                  unselectedLabelStyle: const TextStyle(
                    fontWeight: FontWeight.w500,
                    fontSize: 14,
                  ),
                  tabs: const [
                    Tab(text: "Transactions"),
                    Tab(text: "Packages"),
                  ],
                ),
              ),

              const SizedBox(height: 8),

              Expanded(
                child: TabBarView(
                  children: [
                    _transactionsTab(context),
                    _packagesTab(context),
                  ],
                ),
              ),
            ],
          ),
        );
      }),
    );
  }

  void _showDepositDialog(BuildContext context) {
    final formKey = GlobalKey<FormState>();

    final amountController = TextEditingController();
    final descController = TextEditingController();
    final dateController = TextEditingController();

    RxString attachmentName = "".obs;

    CustomWidgets().showCustomDialog(
      context: context,
      formKey: formKey,
      icon: Icons.account_balance_wallet,
      title: const Text("Deposit Funds"),
      sections: [
        // 🔷 Amount

        CustomWidgets().labelWithAsterisk('Amount(₹)', required: true),
        const SizedBox(height: 10),
        CustomWidgets().dropdownStyledTextField(
            context: context,
            hint: 'Enter deposit amount',
            controller: amountController),
        const SizedBox(height: 10),
        CustomWidgets().labelWithAsterisk('Description (Optional)'),
        const SizedBox(height: 10),
        CustomWidgets().dropdownStyledTextField(
            context: context,
            hint: 'Bank transfer, cash deposit, etc.',
            controller: descController),
        const SizedBox(height: 10),
        CustomWidgets().labelWithAsterisk('Deposit Date', required: true),
        const SizedBox(height: 10),
        CustomWidgets().dropdownStyledTextField(
            context: context,
            hint: 'Bank transfer, cash deposit, etc.',
            controller: dateController),
        const SizedBox(height: 10),
        CustomWidgets().labelWithAsterisk('Attatchment (Proof of payment)'),
        const SizedBox(height: 10),
        CustomWidgets().dropdownStyledTextField(
          context: context,
          hint: 'Select Screenshots',
        ),
        const SizedBox(height: 10),
      ],
      onSubmit: () {
        final amount = double.tryParse(amountController.text) ?? 0;

        c.transactions.add(
          TransactionModel(
            status: "Success",
            type: "Credit",
            title: "Wallet Deposit",
            description: descController.text,
            amount: amount,
            dateTime: DateTime.now(),
          ),
        );
      },
    );
  }

  // ---------------- TRANSACTIONS ----------------

  Widget _transactionsTab(BuildContext context) {
    final cs = Theme.of(context).colorScheme;

    return Obx(() {
      if (c.transactions.isEmpty) {
        return Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                padding: const EdgeInsets.all(24),
                decoration: BoxDecoration(
                  color: cs.surfaceContainerHighest,
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  Icons.receipt_long_outlined,
                  size: 48,
                  color: cs.outline,
                ),
              ),
              const SizedBox(height: 16),
              Text(
                "No Transactions Yet",
                style: Theme.of(context).textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.w600,
                    ),
              ),
              const SizedBox(height: 8),
              Text(
                "Your transaction history will appear here",
                style: Theme.of(context).textTheme.bodySmall?.copyWith(
                      color: cs.onSurfaceVariant,
                    ),
              ),
            ],
          ),
        );
      }

      return ListView.builder(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        itemCount: c.transactions.length,
        itemBuilder: (_, i) {
          final t = c.transactions[i];
          final isCredit = t.type == "Credit";

          return Container(
            margin: const EdgeInsets.only(bottom: 12),
            decoration: BoxDecoration(
              color: cs.surface,
              borderRadius: BorderRadius.circular(16),
              border: Border.all(
                color: cs.outlineVariant.withOpacity(0.5),
                width: 1,
              ),
              boxShadow: [
                BoxShadow(
                  color: cs.shadow.withOpacity(0.05),
                  blurRadius: 8,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Row(
                children: [
                  // ICON
                  Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: isCredit
                          ? const Color(0xFF10B981).withOpacity(0.12)
                          : const Color(0xFFEF4444).withOpacity(0.12),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Icon(
                      isCredit
                          ? Icons.arrow_downward_rounded
                          : Icons.arrow_upward_rounded,
                      color: isCredit
                          ? const Color(0xFF10B981)
                          : const Color(0xFFEF4444),
                      size: 20,
                    ),
                  ),

                  const SizedBox(width: 14),

                  // DETAILS
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          t.title,
                          style: const TextStyle(
                            fontWeight: FontWeight.w600,
                            fontSize: 15,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          t.description,
                          style: TextStyle(
                            fontSize: 13,
                            color: cs.onSurfaceVariant,
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                        const SizedBox(height: 6),
                        Row(
                          children: [
                            Icon(
                              Icons.access_time_outlined,
                              size: 12,
                              color: cs.outline,
                            ),
                            const SizedBox(width: 4),
                            Text(
                              _formatDateTime(t.dateTime),
                              style: TextStyle(
                                fontSize: 12,
                                color: cs.outline,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(width: 12),

                  // AMOUNT & STATUS
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Text(
                        "${isCredit ? '+' : '-'}₹${t.amount.toStringAsFixed(2)}",
                        style: TextStyle(
                          color: isCredit
                              ? const Color(0xFF10B981)
                              : const Color(0xFFEF4444),
                          fontWeight: FontWeight.w700,
                          fontSize: 16,
                        ),
                      ),
                      const SizedBox(height: 6),
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 10,
                          vertical: 4,
                        ),
                        decoration: BoxDecoration(
                          color: _getStatusColor(t.status).withOpacity(0.12),
                          borderRadius: BorderRadius.circular(6),
                        ),
                        child: Text(
                          t.status,
                          style: TextStyle(
                            fontSize: 11,
                            fontWeight: FontWeight.w600,
                            color: _getStatusColor(t.status),
                          ),
                        ),
                      ),
                    ],
                  )
                ],
              ),
            ),
          );
        },
      );
    });
  }

  Color _getStatusColor(String status) {
    switch (status.toLowerCase()) {
      case 'success':
        return const Color(0xFF10B981);
      case 'pending':
        return const Color(0xFFF59E0B);
      case 'failed':
        return const Color(0xFFEF4444);
      default:
        return Colors.grey;
    }
  }

  String _formatDateTime(DateTime dateTime) {
    final now = DateTime.now();
    final difference = now.difference(dateTime);

    if (difference.inDays == 0) {
      return "Today, ${dateTime.hour.toString().padLeft(2, '0')}:${dateTime.minute.toString().padLeft(2, '0')}";
    } else if (difference.inDays == 1) {
      return "Yesterday, ${dateTime.hour.toString().padLeft(2, '0')}:${dateTime.minute.toString().padLeft(2, '0')}";
    } else {
      return "${dateTime.day}/${dateTime.month}/${dateTime.year}";
    }
  }

  Widget _totalBalance(BuildContext context) {
    final cs = Theme.of(context).colorScheme;

    return Container(
      width: double.infinity,
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            cs.primary,
            cs.primary.withOpacity(0.8),
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: cs.primary.withOpacity(0.3),
            blurRadius: 16,
            offset: const Offset(0, 8),
          )
        ],
      ),
      child: Obx(() {
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Icon(
                          Icons.account_balance_wallet_outlined,
                          color: Colors.white.withOpacity(0.9),
                          size: 16,
                        ),
                        const SizedBox(width: 6),
                        Text(
                          "Total Balance",
                          style: TextStyle(
                            color: Colors.white.withOpacity(0.9),
                            fontSize: 13,
                            fontWeight: FontWeight.w500,
                            letterSpacing: 0.3,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),
                    Text(
                      "₹${c.totalBalance.toStringAsFixed(2)}",
                      style: const TextStyle(
                        fontSize: 32,
                        fontWeight: FontWeight.w800,
                        color: Colors.white,
                        letterSpacing: -0.5,
                      ),
                    ),
                  ],
                ),
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.2),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: const Icon(
                    Icons.currency_rupee_rounded,
                    color: Colors.white,
                    size: 28,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.15),
                borderRadius: BorderRadius.circular(12),
                border: Border.all(
                  color: Colors.white.withOpacity(0.2),
                  width: 1,
                ),
              ),
              child: Row(
                children: [
                  Expanded(
                    child: _miniStat(
                      "Deposited",
                      c.totalDeposited,
                      Icons.arrow_downward_rounded,
                    ),
                  ),
                  Container(
                    width: 1,
                    height: 30,
                    color: Colors.white.withOpacity(0.3),
                  ),
                  Expanded(
                    child: _miniStat(
                      "Used",
                      c.totalUsed,
                      Icons.arrow_upward_rounded,
                    ),
                  ),
                ],
              ),
            ),
          ],
        );
      }),
    );
  }

  Widget _miniStat(String label, double value, IconData icon) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                icon,
                color: Colors.white,
                size: 14,
              ),
              const SizedBox(width: 4),
              Text(
                label,
                style: TextStyle(
                  color: Colors.white.withOpacity(0.9),
                  fontSize: 12,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
          const SizedBox(height: 4),
          Text(
            "₹${value.toStringAsFixed(2)}",
            style: const TextStyle(
              color: Colors.white,
              fontSize: 16,
              fontWeight: FontWeight.w700,
            ),
          ),
        ],
      ),
    );
  }

  // ---------------- PACKAGES ----------------

  Widget _packagesTab(BuildContext context) {
    final cs = Theme.of(context).colorScheme;

    return Obx(() {
      if (c.packages.isEmpty) {
        return Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                padding: const EdgeInsets.all(24),
                decoration: BoxDecoration(
                  color: cs.surfaceContainerHighest,
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  Icons.inventory_2_outlined,
                  size: 48,
                  color: cs.outline,
                ),
              ),
              const SizedBox(height: 16),
              Text(
                "No Packages Yet",
                style: Theme.of(context).textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.w600,
                    ),
              ),
              const SizedBox(height: 8),
              Text(
                "Your enrolled packages will appear here",
                style: Theme.of(context).textTheme.bodySmall?.copyWith(
                      color: cs.onSurfaceVariant,
                    ),
              ),
            ],
          ),
        );
      }

      return ListView.builder(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        itemCount: c.packages.length,
        itemBuilder: (_, i) {
          final p = c.packages[i];
          final balance = c.getPackageBalance(p);

          return GestureDetector(
            onTap: () => _showPackageDialog(context, p),
            child: Container(
              margin: const EdgeInsets.only(bottom: 12),
              decoration: BoxDecoration(
                color: cs.surface,
                borderRadius: BorderRadius.circular(16),
                border: Border.all(
                  color: cs.outlineVariant.withOpacity(0.5),
                  width: 1,
                ),
                boxShadow: [
                  BoxShadow(
                    color: cs.shadow.withOpacity(0.05),
                    blurRadius: 8,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(14),
                      decoration: BoxDecoration(
                        color: cs.primaryContainer,
                        borderRadius: BorderRadius.circular(14),
                      ),
                      child: Icon(
                        Icons.menu_book_rounded,
                        color: cs.onPrimaryContainer,
                        size: 24,
                      ),
                    ),
                    const SizedBox(width: 14),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            p.subjectName,
                            style: const TextStyle(
                              fontWeight: FontWeight.w600,
                              fontSize: 15,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Row(
                            children: [
                              Icon(
                                Icons.school_outlined,
                                size: 12,
                                color: cs.onSurfaceVariant,
                              ),
                              const SizedBox(width: 4),
                              Text(
                                "${p.standard} • ${p.syllabus}",
                                style: TextStyle(
                                  fontSize: 13,
                                  color: cs.onSurfaceVariant,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        Text(
                          "Balance",
                          style: TextStyle(
                            fontSize: 11,
                            color: cs.onSurfaceVariant,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        const SizedBox(height: 2),
                        Text(
                          "₹${balance.toStringAsFixed(2)}",
                          style: const TextStyle(
                            fontWeight: FontWeight.w700,
                            fontSize: 16,
                            color: Color(0xFF10B981),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(width: 8),
                    Icon(
                      Icons.arrow_forward_ios_rounded,
                      size: 16,
                      color: cs.outline,
                    ),
                  ],
                ),
              ),
            ),
          );
        },
      );
    });
  }

  // ---------------- DIALOG ----------------

  void _showPackageDialog(BuildContext context, Package p) {
    final formKey = GlobalKey<FormState>();

    double totalWithdrawals = p.withdrawals.fold(0, (sum, w) => sum + w.amount);

    CustomWidgets().showCustomDialog(
      context: context,
      formKey: formKey,
      isViewOnly: true,
      icon: Icons.account_balance_wallet,
      title: Text("${p.subjectName} (${p.standard} - ${p.syllabus})"),
      sections: [
        // 🔷 SUMMARY
        _sectionTitle(context, "Summary"),
        _groupCard(
          context,
          [
            _infoTile("Package Fee", p.packageFee),
            _infoTile("Class Taken", totalWithdrawals),
            _infoTile(
              "Balance",
              p.packageFee - totalWithdrawals,
              highlight: true,
            ),
          ],
        ),

        const SizedBox(height: 12),

        // 🔷 WITHDRAWAL HISTORY
        _sectionTitle(context, "Withdrawals"),

        ...p.withdrawals.map((w) {
          return Container(
            margin: const EdgeInsets.only(bottom: 8),
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: Theme.of(context).colorScheme.surfaceContainerHighest,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(
                color: Theme.of(context)
                    .colorScheme
                    .outlineVariant
                    .withOpacity(0.5),
                width: 1,
              ),
            ),
            child: Row(
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "₹${w.amount.toStringAsFixed(2)}",
                        style: const TextStyle(
                          fontWeight: FontWeight.w600,
                          fontSize: 15,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        _formatDateTime(w.date),
                        style: TextStyle(
                          fontSize: 12,
                          color: Theme.of(context).colorScheme.onSurfaceVariant,
                        ),
                      ),
                    ],
                  ),
                ),
                if (w.note != null && w.note!.isNotEmpty)
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 10,
                      vertical: 4,
                    ),
                    decoration: BoxDecoration(
                      color: Theme.of(context).colorScheme.primaryContainer,
                      borderRadius: BorderRadius.circular(6),
                    ),
                    child: Text(
                      w.note!,
                      style: TextStyle(
                        fontSize: 12,
                        color: Theme.of(context).colorScheme.onPrimaryContainer,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
              ],
            ),
          );
        }).toList(),
      ],
      onSubmit: () {},
    );
  }

  Widget _sectionTitle(BuildContext context, String title) {
    final cs = Theme.of(context).colorScheme;

    return Padding(
      padding: const EdgeInsets.only(bottom: 8, top: 4),
      child: Row(
        children: [
          Container(
            width: 3,
            height: 16,
            decoration: BoxDecoration(
              color: cs.primary,
              borderRadius: BorderRadius.circular(2),
            ),
          ),
          const SizedBox(width: 8),
          Text(
            title,
            style: TextStyle(
              fontWeight: FontWeight.w700,
              fontSize: 15,
              color: cs.onSurface,
            ),
          ),
        ],
      ),
    );
  }

  Widget _groupCard(BuildContext context, List<Widget> children) {
    final cs = Theme.of(context).colorScheme;

    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: cs.surfaceContainerHighest,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: cs.outlineVariant.withOpacity(0.5),
          width: 1,
        ),
      ),
      child: Column(children: children),
    );
  }

  Widget _infoTile(String title, dynamic value, {bool highlight = false}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            title,
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w500,
              color: Colors.grey.shade700,
            ),
          ),
          Text(
            value is double ? "₹${value.toStringAsFixed(2)}" : value.toString(),
            style: TextStyle(
              fontWeight: highlight ? FontWeight.w700 : FontWeight.w600,
              fontSize: highlight ? 16 : 14,
              color: highlight ? const Color(0xFF10B981) : Colors.black87,
            ),
          ),
        ],
      ),
    );
  }
}
