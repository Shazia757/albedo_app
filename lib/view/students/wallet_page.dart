import 'package:albedo_app/controller/student_controller.dart';
import 'package:albedo_app/model/stu_wallet_model.dart';
import 'package:albedo_app/model/users/student_model.dart';
import 'package:albedo_app/widgets/widgets.dart';
import 'package:flutter/material.dart';

SingleChildScrollView studentWalletTab(
    BuildContext context, Student student, StudentController c) {
  final cs = Theme.of(context).colorScheme;
  final wallet = student.wallet ?? StudentWallet();
  final balance = wallet.balance ?? 0;

  return SingleChildScrollView(
    padding: const EdgeInsets.fromLTRB(0, 0, 0, 32),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // ── Balance hero card ────────────────────────────────────
        _BalanceCard(balance: balance, wallet: wallet, cs: cs),

        Padding(
          padding: const EdgeInsets.fromLTRB(0, 14, 0, 0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // ── Filter row ─────────────────────────────────────
              _FilterRow(c: c, student: student),

              const SizedBox(height: 12),

              // ── Wallet Summary button ──────────────
              SizedBox(
                width: double.infinity,
                child: ElevatedButton.icon(
                  onPressed: () => _showWalletSummary(context, student, wallet),
                  iconAlignment: IconAlignment.end,
                  icon: const Icon(Icons.bar_chart_outlined,
                      size: 18, color: Colors.white),
                  label: const Text('Wallet Summary',
                      style: TextStyle(color: Colors.white, fontSize: 13)),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: cs.primary,
                    elevation: 0,
                    padding: const EdgeInsets.symmetric(vertical: 13),
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12)),
                  ),
                ),
              ),

              const SizedBox(height: 14),

              // ── Credit summary ─────────────────────────────────
              _CreditSummaryCard(student: student, cs: cs),
              const SizedBox(height: 10),

              // ── Deposits ───────────────────────────────────────
              _DepositsCard(student: student, cs: cs),
              const SizedBox(height: 10),

              // ── Wallet usage ───────────────────────────────────
              _WalletUsageCard(student: student, cs: cs),
              const SizedBox(height: 10),

              // ── Credit transactions ────────────────────────────
              _CreditTransactionsCard(student: student, cs: cs),
              const SizedBox(height: 10),

              // ── Registration fee ───────────────────────────────
              _RegistrationFeeCard(student: student, cs: cs),
              const SizedBox(height: 10),

              // ── Packages ───────────────────────────────────────
              _PackagesCard(student: student, cs: cs),
            ],
          ),
        ),
      ],
    ),
  );
}

// ─────────────────────────────────────────────────────────────────────
// BALANCE HERO CARD
// ─────────────────────────────────────────────────────────────────────
class _BalanceCard extends StatelessWidget {
  final double balance;
  final StudentWallet wallet;
  final ColorScheme cs;

  const _BalanceCard(
      {required this.balance, required this.wallet, required this.cs});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: cs.primary,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text("WALLET BALANCE",
              style: TextStyle(
                  color: cs.onPrimary.withOpacity(0.7),
                  fontSize: 11,
                  letterSpacing: 0.6)),
          const SizedBox(height: 4),
          Text(
            "₹${balance.toStringAsFixed(0)}",
            style: TextStyle(
                color: cs.onPrimary,
                fontSize: 34,
                fontWeight: FontWeight.w600,
                letterSpacing: -0.5),
          ),
          const SizedBox(height: 20),
          Row(
            children: [
              _BalanceStat(
                  label: "Available",
                  value: "₹${wallet.available?.toStringAsFixed(0) ?? '0'}"),
              const SizedBox(width: 32),
              _BalanceStat(
                  label: "On Hold",
                  value: "₹${wallet.onHold?.toStringAsFixed(0) ?? '0'}"),
            ],
          ),
        ],
      ),
    );
  }
}

class _BalanceStat extends StatelessWidget {
  final String label;
  final String value;
  const _BalanceStat({required this.label, required this.value});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label,
            style: const TextStyle(color: Colors.white60, fontSize: 11)),
        const SizedBox(height: 2),
        Text(value,
            style: const TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.w600,
                fontSize: 16)),
      ],
    );
  }
}

// ─────────────────────────────────────────────────────────────────────
// FILTER ROW  — old button design kept
// ─────────────────────────────────────────────────────────────────────
class _FilterRow extends StatelessWidget {
  final StudentController c;
  final Student student;

  const _FilterRow({required this.c, required this.student});

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    final items = ["All", "Withdraw", "Payment", "Refund"];

    return Row(
      children: [
        Expanded(
          child: CustomWidgets().customDropdownField(
            context: context,
            hint: 'Filter',
            items: items,
            onChanged: (val) => c.selectedFilter.value = val ?? "All",
            itemLabel: (e) => e.toString(),
            autoSelectFirst: true,
          ),
        ),
        const SizedBox(width: 8),

        // ── Coupon button — old style ──────────────────────────
        Tooltip(
          message: "Apply Coupon",
          child: ElevatedButton(
            onPressed: () => CustomWidgets().showCustomDialog(
              context: context,
              title: const Text('Apply Coupon'),
              formKey: GlobalKey(),
              sections: [
                CustomWidgets().labelWithAsterisk('Coupon Code'),
                const SizedBox(height: 10),
                CustomWidgets().dropdownStyledTextField(
                    context: context,
                    hint: 'Enter coupon code',
                    controller: c.couponcodeController),
              ],
              onSubmit: () {},
              submitText: 'Validate & Apply',
            ),
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.green,
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10)),
              padding: const EdgeInsets.all(12),
              elevation: 0,
            ),
            child: const Icon(Icons.local_offer, size: 18, color: Colors.white),
          ),
        ),

        const SizedBox(width: 10),

        // ── Refund button — old style ──────────────────────────
        Tooltip(
          message: 'Request refund',
          child: ElevatedButton(
            onPressed: () => _showRefundDialog(context, student, c, cs),
            style: ElevatedButton.styleFrom(
              backgroundColor: cs.error,
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10)),
              padding: const EdgeInsets.all(12),
              elevation: 0,
            ),
            child: const Icon(Icons.refresh, size: 18, color: Colors.white),
          ),
        ),
      ],
    );
  }

  void _showRefundDialog(BuildContext context, Student student,
      StudentController c, ColorScheme cs) {
    CustomWidgets().showCustomDialog(
      context: context,
      title: const Text('Request Refund'),
      formKey: GlobalKey(),
      sections: [
        Row(
          children: [
            Expanded(
              child: _RefundStatCell(
                title: "Total Deposit",
                value:
                    "₹${student.wallet?.totalDeposited?.toStringAsFixed(0) ?? '0'}",
                color: const Color(0xFF0F6E56),
                cs: cs,
              ),
            ),
            const SizedBox(width: 10),
            Expanded(
              child: _RefundStatCell(
                title: "Class Taken",
                value: "₹${student.totalAmount?.toStringAsFixed(0) ?? '0'}",
                color: const Color(0xFF854F0B),
                cs: cs,
              ),
            ),
          ],
        ),
        const SizedBox(height: 12),
        Container(
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: cs.primary.withOpacity(0.05),
            borderRadius: BorderRadius.circular(10),
            border: Border.all(color: cs.primary.withOpacity(0.2)),
          ),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Icon(Icons.info_outline, size: 16, color: cs.primary),
              const SizedBox(width: 8),
              Expanded(
                child: Text(
                  "You can request a refund up to your Total Deposit Amount. "
                  "This does not include credits or coupons.",
                  style: TextStyle(
                      fontSize: 12, color: cs.onSurface.withOpacity(0.7)),
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 12),
        CustomWidgets().labelWithAsterisk('Refund Amount (₹)', required: true),
        const SizedBox(height: 8),
        CustomWidgets().dropdownStyledTextField(
          context: context,
          hint: 'e.g. 250 (max: ₹${student.wallet?.totalDeposited})',
          controller: c.refundAmountController,
        ),
        const SizedBox(height: 12),
        CustomWidgets().labelWithAsterisk('Message', required: true),
        const SizedBox(height: 8),
        CustomWidgets().dropdownStyledTextField(
          context: context,
          hint: 'Reason for refund...',
          controller: c.refundMessageController,
          isMultiline: true,
        ),
        const SizedBox(height: 12),
        CustomWidgets().labelWithAsterisk('Remark'),
        const SizedBox(height: 8),
        CustomWidgets().dropdownStyledTextField(
          context: context,
          hint: 'Additional internal notes...',
          controller: c.remarkController,
        ),
        const SizedBox(height: 10),
      ],
      submitText: 'Request',
      onSubmit: () {},
    );
  }
}

// ─────────────────────────────────────────────────────────────────────
// SECTION CARD — shared container
// ─────────────────────────────────────────────────────────────────────
class _WalletSection extends StatelessWidget {
  final String title;
  final Widget child;
  final ColorScheme cs;
  final Widget? trailing;

  const _WalletSection({
    required this.title,
    required this.child,
    required this.cs,
    this.trailing,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: cs.surface,
        borderRadius: BorderRadius.circular(12),
        border:
            Border.all(color: cs.outlineVariant.withOpacity(0.4), width: 0.5),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(title,
                  style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                      color: cs.onSurface)),
              if (trailing != null) trailing!,
            ],
          ),
          Divider(
              height: 18,
              thickness: 0.5,
              color: cs.outlineVariant.withOpacity(0.4)),
          child,
        ],
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────────────
// CREDIT SUMMARY CARD
// ─────────────────────────────────────────────────────────────────────
class _CreditSummaryCard extends StatelessWidget {
  final Student student;
  final ColorScheme cs;
  const _CreditSummaryCard({required this.student, required this.cs});

  @override
  Widget build(BuildContext context) {
    final wallet = student.wallet ?? StudentWallet();
    final limit = wallet.creditLimit ?? 0;
    final used = wallet.creditUsed ?? 0;
    final balance = limit - used;

    return _WalletSection(
      title: "Credit Summary",
      cs: cs,
      trailing: IconButton(
        onPressed: () {},
        icon: Icon(Icons.edit_outlined,
            size: 16, color: cs.onSurface.withOpacity(0.5)),
        padding: EdgeInsets.zero,
        constraints: const BoxConstraints(),
      ),
      child: Row(
        children: [
          Expanded(
              child: _MetricCell(
                  label: "Limit",
                  value: "₹${limit.toStringAsFixed(0)}",
                  color: cs.primary,
                  cs: cs)),
          const SizedBox(width: 8),
          Expanded(
              child: _MetricCell(
                  label: "Used",
                  value: "₹${used.toStringAsFixed(0)}",
                  color: const Color(0xFF854F0B),
                  cs: cs)),
          const SizedBox(width: 8),
          Expanded(
              child: _MetricCell(
                  label: "Balance",
                  value: "₹${balance.toStringAsFixed(0)}",
                  color: const Color(0xFF0F6E56),
                  cs: cs)),
        ],
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────────────
// DEPOSITS CARD
// ─────────────────────────────────────────────────────────────────────
class _DepositsCard extends StatelessWidget {
  final Student student;
  final ColorScheme cs;
  const _DepositsCard({required this.student, required this.cs});

  @override
  Widget build(BuildContext context) {
    return _WalletSection(
      title: "Deposits",
      cs: cs,
      child: Row(
        children: [
          Expanded(
            child: _MetricCell(
              label: "Pending",
              value:
                  "₹${student.wallet?.pendingDeposits?.toStringAsFixed(0) ?? '0'}",
              color: const Color(0xFF854F0B),
              cs: cs,
            ),
          ),
          const SizedBox(width: 8),
          Expanded(
            child: _MetricCell(
              label: "Lifetime",
              value:
                  "₹${student.wallet?.totalDeposited?.toStringAsFixed(0) ?? '0'}",
              color: const Color(0xFF0F6E56),
              cs: cs,
            ),
          ),
        ],
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────────────
// WALLET USAGE CARD
// ─────────────────────────────────────────────────────────────────────
class _WalletUsageCard extends StatelessWidget {
  final Student student;
  final ColorScheme cs;
  const _WalletUsageCard({required this.student, required this.cs});

  @override
  Widget build(BuildContext context) {
    final packages = student.packages ?? [];

    return _WalletSection(
      title: "Wallet Usage",
      cs: cs,
      child: Column(
        children: [
          _UsageRow(
            label: "Wallet Used",
            value: "₹${student.wallet?.walletUsed?.toStringAsFixed(0) ?? '0'}",
            cs: cs,
          ),
          const SizedBox(height: 6),
          _UsageRow(
            label: "Credit Used",
            value:
                "₹${student.wallet?.creditUsedAmount?.toStringAsFixed(0) ?? '0'}",
            cs: cs,
          ),
          if (packages.isNotEmpty) ...[
            Divider(
                height: 18,
                thickness: 0.5,
                color: cs.outlineVariant.withOpacity(0.4)),
            ...packages.map((p) {
              final taken = p.takenFee ?? 0;
              final isActive = p.status == "Active";
              final statusColor =
                  isActive ? const Color(0xFF1D9E75) : const Color(0xFFBA7517);

              return Padding(
                padding: const EdgeInsets.only(bottom: 8),
                child: Row(
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(p.name ?? "—",
                              style: TextStyle(
                                  fontSize: 13,
                                  fontWeight: FontWeight.w500,
                                  color: cs.onSurface)),
                          const SizedBox(height: 2),
                          Text(
                            "${p.subjectName ?? '—'} · ${p.mode ?? '—'}",
                            style: TextStyle(
                                fontSize: 11,
                                color: cs.onSurface.withOpacity(0.45)),
                          ),
                        ],
                      ),
                    ),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        Text("₹${taken.toStringAsFixed(0)}",
                            style: TextStyle(
                                fontSize: 13,
                                fontWeight: FontWeight.w500,
                                color: cs.onSurface)),
                        Container(
                          margin: const EdgeInsets.only(top: 3),
                          padding: const EdgeInsets.symmetric(
                              horizontal: 7, vertical: 2),
                          decoration: BoxDecoration(
                            color: statusColor.withOpacity(0.1),
                            borderRadius: BorderRadius.circular(4),
                          ),
                          child: Text(p.status,
                              style: TextStyle(
                                  fontSize: 10,
                                  fontWeight: FontWeight.w500,
                                  color: statusColor)),
                        ),
                      ],
                    ),
                  ],
                ),
              );
            }),
          ],
        ],
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────────────
// CREDIT TRANSACTIONS CARD
// ─────────────────────────────────────────────────────────────────────
class _CreditTransactionsCard extends StatelessWidget {
  final Student student;
  final ColorScheme cs;
  const _CreditTransactionsCard({required this.student, required this.cs});

  @override
  Widget build(BuildContext context) {
    final txns = student.wallet?.creditTransactions ?? [];
    final limitChanges = txns.where((e) => e.type == "limit_change").length;
    final repayments = txns.where((e) => e.type == "repayment").length;
    final classPayments = txns.where((e) => e.type == "class_payment").length;

    return _WalletSection(
      title: "Credit Transactions",
      cs: cs,
      child: Row(
        children: [
          Expanded(
            child: _CreditStatCell(
              title: "Limit Changes",
              value: limitChanges.toString(),
              icon: Icons.trending_up_rounded,
              color: cs.primary,
              cs: cs,
            ),
          ),
          const SizedBox(width: 8),
          Expanded(
            child: _CreditStatCell(
              title: "Repayments",
              value: repayments.toString(),
              icon: Icons.account_balance_wallet_outlined,
              color: const Color(0xFF0F6E56),
              cs: cs,
            ),
          ),
          const SizedBox(width: 8),
          Expanded(
            child: _CreditStatCell(
              title: "Class Payments",
              value: classPayments.toString(),
              icon: Icons.school_outlined,
              color: const Color(0xFF854F0B),
              cs: cs,
            ),
          ),
        ],
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────────────
// REGISTRATION FEE CARD
// ─────────────────────────────────────────────────────────────────────
class _RegistrationFeeCard extends StatelessWidget {
  final Student student;
  final ColorScheme cs;
  const _RegistrationFeeCard({required this.student, required this.cs});

  @override
  Widget build(BuildContext context) {
    final fee = student.wallet?.registrationFee ?? 0;
    final isPaid = (student.regFee ?? 0) > 0;
    final paidColor = isPaid ? const Color(0xFF1D9E75) : cs.error;

    return _WalletSection(
      title: "Registration Fee",
      cs: cs,
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "₹${fee.toStringAsFixed(0)}",
                  style: TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.w600,
                      color: cs.onSurface),
                ),
                const SizedBox(height: 3),
                Text(
                  student.admissionDate != null
                      ? "${student.wallet?.registrationPaidAt?.toLocal()}"
                          .split('.')[0]
                      : "—",
                  style: TextStyle(
                      fontSize: 11, color: cs.onSurface.withOpacity(0.4)),
                ),
              ],
            ),
          ),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
            decoration: BoxDecoration(
              color: paidColor.withOpacity(0.09),
              borderRadius: BorderRadius.circular(6),
              border: Border.all(color: paidColor.withOpacity(0.3), width: 0.5),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(
                    isPaid ? Icons.check_circle_outline : Icons.cancel_outlined,
                    size: 14,
                    color: paidColor),
                const SizedBox(width: 5),
                Text(isPaid ? "Paid" : "Unpaid",
                    style: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w500,
                        color: paidColor)),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────────────
// PACKAGES CARD
// ─────────────────────────────────────────────────────────────────────
class _PackagesCard extends StatelessWidget {
  final Student student;
  final ColorScheme cs;
  const _PackagesCard({required this.student, required this.cs});

  @override
  Widget build(BuildContext context) {
    final packages = student.packages ?? [];

    return _WalletSection(
      title: "Packages",
      cs: cs,
      trailing: Container(
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
        decoration: BoxDecoration(
          color: cs.primary.withOpacity(0.1),
          borderRadius: BorderRadius.circular(4),
        ),
        child: Text("${packages.length}",
            style: TextStyle(
                fontSize: 12, fontWeight: FontWeight.w600, color: cs.primary)),
      ),
      child: packages.isEmpty
          ? Text("No packages available",
              style:
                  TextStyle(fontSize: 13, color: cs.onSurface.withOpacity(0.4)))
          : Column(
              children: packages.map((p) {
                final isActive = p.status == "Active";
                final statusColor = isActive
                    ? const Color(0xFF1D9E75)
                    : const Color(0xFFBA7517);

                return Container(
                  margin: const EdgeInsets.only(bottom: 8),
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(
                        color: cs.outlineVariant.withOpacity(0.35), width: 0.5),
                    color: cs.surfaceContainerLowest,
                  ),
                  child: Row(
                    children: [
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              "${p.standard} · ${p.syllabus}",
                              style: TextStyle(
                                  fontSize: 13,
                                  fontWeight: FontWeight.w500,
                                  color: cs.onSurface),
                            ),
                            const SizedBox(height: 2),
                            Text(p.subjectName ?? "—",
                                style: TextStyle(
                                    fontSize: 11,
                                    color: cs.onSurface.withOpacity(0.45))),
                          ],
                        ),
                      ),
                      Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 8, vertical: 3),
                        decoration: BoxDecoration(
                          color: statusColor.withOpacity(0.09),
                          borderRadius: BorderRadius.circular(4),
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Container(
                                width: 5,
                                height: 5,
                                decoration: BoxDecoration(
                                    color: statusColor,
                                    shape: BoxShape.circle)),
                            const SizedBox(width: 5),
                            Text(p.status,
                                style: TextStyle(
                                    fontSize: 11,
                                    fontWeight: FontWeight.w500,
                                    color: statusColor)),
                          ],
                        ),
                      ),
                    ],
                  ),
                );
              }).toList(),
            ),
    );
  }
}

// ═══════════════════════════════════════════════════════════════════════
// WALLET SUMMARY DIALOG
// ═══════════════════════════════════════════════════════════════════════
void _showWalletSummary(
    BuildContext context, Student student, StudentWallet wallet) {
  final transactions = wallet.transactions ?? [];
  final totalTransactions = transactions.length;
  final available = wallet.available ?? 0;
  final creditLimit = wallet.creditLimit ?? 0;
  final creditUsed = wallet.creditUsed ?? 0;
  final walletUsed = wallet.walletUsed ?? 0;
  final creditUsedAmount = wallet.creditUsedAmount ?? 0;

  final totalClassTaken = transactions
      .where((t) => t.type == "class_payment" && t.status == "success")
      .fold(0.0, (s, t) => s + t.amount);
  final totalCoupons = transactions
      .where((t) => t.type == "coupon")
      .fold(0.0, (s, t) => s + t.amount);
  final totalRefunds = transactions
      .where((t) => t.type == "refund" && t.status == "approved")
      .fold(0.0, (s, t) => s + t.amount);
  final totalDeposits = transactions
      .where((t) => t.type == "deposit" && t.status == "approved")
      .fold(0.0, (s, t) => s + t.amount);
  final creditRepayments = wallet.creditTransactions
          ?.where((t) => t.type == "repayment")
          .fold(0, (s, t) => s + t.count) ??
      0;

  CustomWidgets().showCustomDialog(
    context: context,
    title: Text('Wallet Summary ($totalTransactions transactions)'),
    formKey: GlobalKey(),
    isViewOnly: true,
    onSubmit: () {},
    sections: [
      ListView.separated(
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        itemCount: 6,
        separatorBuilder: (_, __) => const SizedBox(height: 8),
        itemBuilder: (ctx, i) {
          final items = [
            _WalletSummaryItem(
              title: "Available Funds",
              value: "₹${available.toStringAsFixed(0)}",
              isExpandable: true,
              breakdown: [
                {
                  "label": "Wallet Balance",
                  "value": "₹${available.toStringAsFixed(0)}"
                },
                {
                  "label": "Credit Balance",
                  "value": "₹${(creditLimit - creditUsed).toStringAsFixed(0)}"
                },
              ],
            ),
            _WalletSummaryItem(
              title: "Class Taken Amount",
              value: "₹${totalClassTaken.toStringAsFixed(0)}",
              isExpandable: true,
              breakdown: [
                {
                  "label": "Wallet Payment",
                  "value": "₹${walletUsed.toStringAsFixed(0)}"
                },
                {
                  "label": "Credit Payment",
                  "value": "₹${creditUsedAmount.toStringAsFixed(0)}"
                },
              ],
            ),
            _WalletSummaryItem(
                title: "Coupon Amount",
                value: "₹${totalCoupons.toStringAsFixed(0)}"),
            _WalletSummaryItem(
                title: "Refund Amount",
                value: "₹${totalRefunds.toStringAsFixed(0)}"),
            _WalletSummaryItem(
                title: "Approved Deposits",
                value: "₹${totalDeposits.toStringAsFixed(0)}"),
            _WalletSummaryItem(
                title: "Credit Repayments", value: creditRepayments.toString()),
          ];
          return ExpandableSummaryCard(
            title: items[i].title,
            value: items[i].value,
            isExpandable: items[i].isExpandable,
            breakdown: items[i].breakdown,
          );
        },
      ),
    ],
  );
}

class _WalletSummaryItem {
  final String title;
  final String value;
  final bool isExpandable;
  final List<Map<String, String>>? breakdown;
  const _WalletSummaryItem({
    required this.title,
    required this.value,
    this.isExpandable = false,
    this.breakdown,
  });
}

// ═══════════════════════════════════════════════════════════════════════
// EXPANDABLE SUMMARY CARD — kept, only colors cleaned up
// ═══════════════════════════════════════════════════════════════════════
class ExpandableSummaryCard extends StatefulWidget {
  final String title;
  final String value;
  final bool isExpandable;
  final List<Map<String, String>>? breakdown;

  const ExpandableSummaryCard({
    super.key,
    required this.title,
    required this.value,
    this.isExpandable = false,
    this.breakdown,
  });

  @override
  State<ExpandableSummaryCard> createState() => _ExpandableSummaryCardState();
}

class _ExpandableSummaryCardState extends State<ExpandableSummaryCard> {
  bool isExpanded = false;

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    final color = cs.primary;

    return AnimatedContainer(
      duration: const Duration(milliseconds: 200),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: color.withOpacity(0.06),
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: color.withOpacity(0.25), width: 0.8),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(widget.title,
                  style: TextStyle(
                      fontSize: 12, color: cs.onSurface.withOpacity(0.6))),
              if (widget.isExpandable)
                GestureDetector(
                  onTap: () => setState(() => isExpanded = !isExpanded),
                  child: Icon(
                    isExpanded
                        ? Icons.keyboard_arrow_up_rounded
                        : Icons.keyboard_arrow_down_rounded,
                    size: 18,
                    color: color,
                  ),
                ),
            ],
          ),
          const SizedBox(height: 6),
          Text(widget.value,
              style: TextStyle(
                  fontSize: 16, fontWeight: FontWeight.w600, color: color)),
          if (widget.isExpandable &&
              isExpanded &&
              widget.breakdown != null) ...[
            const SizedBox(height: 10),
            Divider(
                height: 1,
                thickness: 0.5,
                color: cs.outlineVariant.withOpacity(0.4)),
            const SizedBox(height: 10),
            ...widget.breakdown!.map((e) => Padding(
                  padding: const EdgeInsets.symmetric(vertical: 3),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(e["label"]!,
                          style: TextStyle(
                              fontSize: 12,
                              color: cs.onSurface.withOpacity(0.6))),
                      Text(e["value"]!,
                          style: const TextStyle(
                              fontSize: 12, fontWeight: FontWeight.w600)),
                    ],
                  ),
                )),
          ],
        ],
      ),
    );
  }
}

// ═══════════════════════════════════════════════════════════════════════
// SMALL SHARED WIDGETS
// ═══════════════════════════════════════════════════════════════════════

/// Stat cell used in credit summary, deposits
class _MetricCell extends StatelessWidget {
  final String label;
  final String value;
  final Color color;
  final ColorScheme cs;

  const _MetricCell(
      {required this.label,
      required this.value,
      required this.color,
      required this.cs});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
      decoration: BoxDecoration(
        color: color.withOpacity(0.07),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: color.withOpacity(0.2), width: 0.5),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(label,
              style: TextStyle(
                  fontSize: 11, color: cs.onSurface.withOpacity(0.5))),
          const SizedBox(height: 4),
          Text(value,
              style: TextStyle(
                  fontSize: 14, fontWeight: FontWeight.w600, color: color)),
        ],
      ),
    );
  }
}

/// Usage label-value row
class _UsageRow extends StatelessWidget {
  final String label;
  final String value;
  final ColorScheme cs;

  const _UsageRow({required this.label, required this.value, required this.cs});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(label,
            style:
                TextStyle(fontSize: 13, color: cs.onSurface.withOpacity(0.6))),
        Text(value,
            style: TextStyle(
                fontSize: 13,
                fontWeight: FontWeight.w500,
                color: cs.onSurface)),
      ],
    );
  }
}

/// Credit stat mini card (Limit Changes / Repayments / Class Payments)
class _CreditStatCell extends StatelessWidget {
  final String title;
  final String value;
  final IconData icon;
  final Color color;
  final ColorScheme cs;

  const _CreditStatCell({
    required this.title,
    required this.value,
    required this.icon,
    required this.color,
    required this.cs,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: color.withOpacity(0.07),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: color.withOpacity(0.25), width: 0.5),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, size: 16, color: color),
          const SizedBox(height: 6),
          Text(value,
              style: TextStyle(
                  fontSize: 18, fontWeight: FontWeight.w600, color: color)),
          const SizedBox(height: 3),
          Text(title,
              style: TextStyle(
                  fontSize: 11, color: cs.onSurface.withOpacity(0.5))),
        ],
      ),
    );
  }
}

/// Refund stat cell inside refund dialog
class _RefundStatCell extends StatelessWidget {
  final String title;
  final String value;
  final Color color;
  final ColorScheme cs;

  const _RefundStatCell({
    required this.title,
    required this.value,
    required this.color,
    required this.cs,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: color.withOpacity(0.07),
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: color.withOpacity(0.25), width: 0.5),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(title,
              style: TextStyle(
                  fontSize: 12, color: cs.onSurface.withOpacity(0.55))),
          const SizedBox(height: 6),
          Text(value,
              style: TextStyle(
                  fontSize: 16, fontWeight: FontWeight.w600, color: color)),
        ],
      ),
    );
  }
}
