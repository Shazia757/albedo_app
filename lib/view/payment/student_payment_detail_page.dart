import 'package:albedo_app/controller/payment_controller.dart';
import 'package:albedo_app/controller/student_wallet_controller.dart';
import 'package:albedo_app/model/payment_model.dart';
import 'package:albedo_app/model/wallet_model.dart';
import 'package:albedo_app/view/batch_payment_detailed.dart';
import 'package:albedo_app/widgets/custom_appbar.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class StudentPaymentDetailsPage extends StatelessWidget {
  StudentPaymentDetailsPage({
    super.key,
    required this.student,
    required this.paymentC,
  });

  final StudentPaymentModel student;
  final PaymentController paymentC;

  final c = Get.find<StudentWalletController>();

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;

    return Scaffold(
      appBar: const CustomAppBar(),
      backgroundColor: cs.surface,
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          /// ───────────────── STUDENT CARD ─────────────────
          _StudentExpandableCard(student: student),

          const SizedBox(height: 18),

          /// ───────────────── TRANSACTIONS TITLE ─────────────────
          Text(
            "Transactions",
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w700,
              color: cs.onSurface,
            ),
          ),

          const SizedBox(height: 14),

          /// ───────────────── TRANSACTION LIST ─────────────────

          Obx(
            () => Column(
              children: c.transactions.asMap().entries.map((entry) {
                final index = entry.key;
                final item = entry.value;
                return Padding(
                  padding: const EdgeInsets.only(bottom: 12),
                  child: _TransactionCard(
                    amount: item.amount ?? 0,
                    addedBy: item.addedBy ?? '',
                    date: item.dateTime ?? DateTime.now(),
                    status: item.status ?? 'pending',
                    onStatusChanged: (newStatus) {
                      c.updateStatus(
                        index,
                        newStatus,
                        student,
                        paymentC,
                      );
                    },
                  ),
                );
              }).toList(),
            ),
          ),
        ],
      ),
    );
  }
}

/// ─────────────────────────────────────────────────────────
/// STUDENT EXPANDABLE CARD
/// ─────────────────────────────────────────────────────────

class _StudentExpandableCard extends StatefulWidget {
  const _StudentExpandableCard({
    required this.student,
  });

  final StudentPaymentModel student;

  @override
  State<_StudentExpandableCard> createState() => _StudentExpandableCardState();
}

class _StudentExpandableCardState extends State<_StudentExpandableCard> {
  bool expanded = false;

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;

    return AnimatedContainer(
      duration: const Duration(milliseconds: 250),
      decoration: BoxDecoration(
        color: cs.onPrimary,
        borderRadius: BorderRadius.circular(22),
        border: Border.all(
          color: cs.outline.withOpacity(.12),
        ),
        boxShadow: [
          BoxShadow(
            color: cs.shadow.withOpacity(.04),
            blurRadius: 16,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: Column(
        children: [
          /// ───────── HEADER ─────────
          InkWell(
            borderRadius: BorderRadius.circular(22),
            onTap: () {
              setState(() {
                expanded = !expanded;
              });
            },
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Row(
                children: [
                  Container(
                    width: 56,
                    height: 56,
                    decoration: BoxDecoration(
                      color: cs.primary.withOpacity(.08),
                      borderRadius: BorderRadius.circular(18),
                    ),
                    child: Icon(
                      Icons.person_outline_rounded,
                      color: cs.primary,
                    ),
                  ),

                  const SizedBox(width: 14),

                  /// student details
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          widget.student.name,
                          style: TextStyle(
                            fontSize: 15,
                            fontWeight: FontWeight.w700,
                            color: cs.onSurface,
                          ),
                        ),
                        const SizedBox(height: 5),
                        Text(
                          widget.student.id,
                          style: TextStyle(
                            fontSize: 12,
                            color: cs.outline,
                          ),
                        ),
                        const SizedBox(height: 3),
                        Text(
                          "+91 9876543210",
                          style: TextStyle(
                            fontSize: 12,
                            color: cs.outline,
                          ),
                        ),
                      ],
                    ),
                  ),

                  AnimatedRotation(
                    turns: expanded ? .5 : 0,
                    duration: const Duration(milliseconds: 250),
                    child: Icon(
                      Icons.keyboard_arrow_down_rounded,
                      size: 28,
                      color: cs.outline,
                    ),
                  ),
                ],
              ),
            ),
          ),

          /// ───────── EXPANDED CONTENT ─────────
          AnimatedCrossFade(
            duration: const Duration(milliseconds: 250),
            crossFadeState:
                expanded ? CrossFadeState.showSecond : CrossFadeState.showFirst,
            firstChild: const SizedBox(),
            secondChild: Padding(
              padding: const EdgeInsets.fromLTRB(
                16,
                0,
                16,
                16,
              ),
              child: Column(
                children: [
                  Divider(
                    color: cs.outline.withOpacity(.12),
                  ),

                  const SizedBox(height: 14),

                  /// mentor + coordinator
                  Container(
                    padding: const EdgeInsets.all(14),
                    decoration: BoxDecoration(
                      color: cs.surfaceContainerHighest.withOpacity(
                        .25,
                      ),
                      borderRadius: BorderRadius.circular(18),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        _personTile(
                          context,
                          title: "Mentor",
                          name: "John Sir",
                          id: "ALB/MEN/0012",
                          phone: "+91 9999999999",
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(
                            vertical: 14,
                          ),
                          child: Divider(
                            height: 1,
                            color: cs.outline.withOpacity(.12),
                          ),
                        ),
                        _personTile(
                          context,
                          title: "Coordinator",
                          name: "Shahana Miss",
                          id: "ALB/COR/0032",
                          phone: "+91 8888888888",
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 14),

                  /// timeline card
                  Container(
                    padding: const EdgeInsets.all(14),
                    decoration: BoxDecoration(
                      color: cs.surfaceContainerHighest.withOpacity(
                        .25,
                      ),
                      borderRadius: BorderRadius.circular(18),
                    ),
                    child: Column(
                      children: [
                        _timelineTile(
                          context,
                          title: "Student Created",
                          value: "12 May 2026 • 09:30 AM",
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(
                            vertical: 14,
                          ),
                          child: Divider(
                            height: 1,
                            color: cs.outline.withOpacity(.12),
                          ),
                        ),
                        _timelineTile(
                          context,
                          title: "Session Started",
                          value: "18 May 2026 • 10:00 AM",
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _personTile(
    BuildContext context, {
    required String title,
    required String name,
    required String id,
    required String phone,
  }) {
    final cs = Theme.of(context).colorScheme;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title.toUpperCase(),
          style: TextStyle(
            fontSize: 10,
            fontWeight: FontWeight.w700,
            letterSpacing: 1,
            color: cs.primary,
          ),
        ),
        const SizedBox(height: 10),
        Text(
          name,
          style: TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w700,
            color: cs.onSurface,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          id,
          style: TextStyle(
            fontSize: 12,
            color: cs.outline,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          phone,
          style: TextStyle(
            fontSize: 12,
            color: cs.outline,
          ),
        ),
      ],
    );
  }

  Widget _timelineTile(
    BuildContext context, {
    required String title,
    required String value,
  }) {
    final cs = Theme.of(context).colorScheme;

    return Row(
      children: [
        Icon(
          Icons.schedule_rounded,
          size: 18,
          color: cs.primary,
        ),
        const SizedBox(width: 10),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: TextStyle(
                  fontSize: 11,
                  color: cs.outline,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                value,
                style: TextStyle(
                  fontWeight: FontWeight.w700,
                  color: cs.onSurface,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

/// ─────────────────────────────────────────────────────────
/// TRANSACTION CARD
/// ─────────────────────────────────────────────────────────

class _TransactionCard extends StatelessWidget {
  const _TransactionCard({
    required this.amount,
    required this.addedBy,
    required this.date,
    required this.status,
    required this.onStatusChanged,
  });

  final double amount;
  final String addedBy;
  final DateTime date;
  final String status;
  final Function(String) onStatusChanged;

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    final c = Get.find<StudentWalletController>();

    final normalizedStatus = status.toLowerCase().trim() ?? 'pending';

    final color = normalizedStatus == "approved"
        ? Colors.green
        : normalizedStatus == "rejected"
            ? Colors.red
            : Colors.orange;

    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: cs.onPrimary,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(
          color: cs.outline.withOpacity(.5),
        ),
      ),
      child: Row(
        children: [
          Container(
            width: 4,
            height: 54,
            decoration: BoxDecoration(
              color: color,
              borderRadius: BorderRadius.circular(30),
            ),
          ),

          const SizedBox(width: 14),

          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "₹${amount.toStringAsFixed(0)}",
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w800,
                    color: cs.onSurface,
                  ),
                ),
                const SizedBox(height: 6),
                Text(
                  date.toString(),
                  style: TextStyle(
                    fontSize: 12,
                    color: cs.outline,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  "Added by $addedBy",
                  style: TextStyle(
                    fontSize: 12,
                    color: cs.outline,
                  ),
                ),
              ],
            ),
          ),

          /// Status Switch
          Container(
            padding: const EdgeInsets.all(4),
            decoration: BoxDecoration(
              color: cs.surface,
              borderRadius: BorderRadius.circular(30),
              border: Border.all(
                color: cs.outline.withOpacity(.15),
              ),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                _StatusButton(
                  icon: Icons.pending,
                  color: Colors.orange,
                  selected: normalizedStatus == "pending",
                  onTap: () => onStatusChanged("pending"),
                ),
                _StatusButton(
                  icon: Icons.check_circle,
                  color: Colors.green,
                  selected: normalizedStatus == "approved",
                  onTap: () => onStatusChanged("approved"),
                ),
                _StatusButton(
                  icon: Icons.cancel,
                  color: Colors.red,
                  selected: normalizedStatus == "rejected",
                  onTap: () => onStatusChanged("rejected"),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _StatusButton extends StatelessWidget {
  const _StatusButton({
    required this.icon,
    required this.color,
    required this.selected,
    required this.onTap,
  });

  final IconData icon;
  final Color color;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        margin: const EdgeInsets.symmetric(horizontal: 2),
        padding: const EdgeInsets.all(8),
        decoration: BoxDecoration(
          color: selected ? color.withOpacity(.15) : Colors.transparent,
          shape: BoxShape.circle,
        ),
        child: Icon(
          icon,
          size: 20,
          color: selected ? color : Colors.grey,
        ),
      ),
    );
  }
}
