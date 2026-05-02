import 'package:albedo_app/controller/payment_controller.dart';
import 'package:albedo_app/model/payment_model.dart';
import 'package:albedo_app/widgets/custom_tab.dart';
import 'package:albedo_app/widgets/widgets.dart';
import 'package:albedo_app/widgets/custom_appbar.dart';
import 'package:albedo_app/widgets/drawer_menu.dart';
import 'package:albedo_app/widgets/responsive.dart';
import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:get/get.dart';

class PaymentPage extends StatelessWidget {
  final PaymentUserType type;

  PaymentPage({super.key, required this.type}) {
    if (type == PaymentUserType.student) {
      c.fetchStudents();
    } else {
      c.fetchTeachers();
    }
  }

  final PaymentController c = Get.put(PaymentController());

  bool get _isStudent => type == PaymentUserType.student;

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    final isDesktop = Responsive.isDesktop(context);

    return Scaffold(
      appBar: const CustomAppBar(),
            backgroundColor: Theme.of(context).colorScheme.surface,

      drawer: isDesktop ? null : const DrawerMenu(),
      body: Row(
        children: [
          if (isDesktop) const DrawerMenu(),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // ── Search ────────────────────────────────────────────
                Padding(
                  padding: const EdgeInsets.fromLTRB(16, 16, 16, 0),
                  child: CustomWidgets().premiumSearch(
                    context,
                    hint: _isStudent
                        ? "Search students..."
                        : "Search teachers...",
                    onChanged: (v) => c.searchQuery.value = v,
                  ),
                ),

                // ── Tabs ──────────────────────────────────────────────
                Padding(
                  padding: const EdgeInsets.fromLTRB(16, 12, 16, 0),
                  child: Tabs(
                    selectedIndex: c.selectedTab,
                    onTap: (i) => c.selectedTab.value = i,
                    labels: ['Pending', 'Approved'],
                  ),
                ),

                const SizedBox(height: 12),

                // ── List ──────────────────────────────────────────────
                Expanded(
                  child: Obx(() {
                    final students = c.filteredStudentPayments;
                    final teachers = c.filteredTeacherPayments;
                    final count =
                        _isStudent ? students.length : teachers.length;

                    if (count == 0) {
                      return _EmptyState(cs: cs);
                    }

                    return LayoutBuilder(builder: (context, constraints) {
                      int crossAxisCount = 1;

                      if (constraints.maxWidth > 1200) {
                        crossAxisCount = 3;
                      } else if (constraints.maxWidth > 700) {
                        crossAxisCount = 2;
                      }
                      return SizedBox.expand(
                        child: MasonryGridView.count(
                          crossAxisCount: crossAxisCount,
                          padding: const EdgeInsets.fromLTRB(16, 0, 16, 24),
                          itemCount: count,
                          mainAxisSpacing: 12,
                          crossAxisSpacing: 12,
                          physics: const BouncingScrollPhysics(),
                          itemBuilder: (_, i) => _PaymentCard(
                            type: type,
                            student: _isStudent ? students[i] : null,
                            teacher: _isStudent ? null : teachers[i],
                          ),
                        ),
                      );
                    });
                  }),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

// ═══════════════════════════════════════════════════════════════════════
// PAYMENT CARD
// ═══════════════════════════════════════════════════════════════════════
class _PaymentCard extends StatelessWidget {
  final PaymentUserType type;
  final StudentPaymentModel? student;
  final TeacherPaymentModel? teacher;

  const _PaymentCard({
    required this.type,
    this.student,
    this.teacher,
  });

  bool get _isStudent => type == PaymentUserType.student;

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    final name = _isStudent ? student!.name : teacher!.name;
    final id = _isStudent ? student!.id : teacher!.id;
    final bal = _isStudent ? student!.balance : teacher!.balance;
    final accentColor = _isStudent ? cs.primary : cs.secondary;

    return Container(
      decoration: BoxDecoration(
        color: cs.surface,
        borderRadius: BorderRadius.circular(12),
        border:
            Border.all(color: cs.outlineVariant.withOpacity(0.4), width: 0.5),
      ),
      clipBehavior: Clip.antiAlias,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // ── Tinted header ───────────────────────────────────────
          Container(
            padding: const EdgeInsets.fromLTRB(14, 14, 14, 14),
            decoration: BoxDecoration(
              color: accentColor.withOpacity(0.06),
            ),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                // Avatar
                Container(
                  width: 40,
                  height: 40,
                  decoration: BoxDecoration(
                    color: accentColor.withOpacity(0.15),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  alignment: Alignment.center,
                  child: Text(
                    name.isNotEmpty ? name[0].toUpperCase() : "?",
                    style: TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.w500,
                      color: accentColor,
                    ),
                  ),
                ),
                const SizedBox(width: 12),

                // Name + ID
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        name,
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w500,
                          color: cs.onSurface,
                        ),
                      ),
                      const SizedBox(height: 2),
                      Text(
                        id,
                        style: TextStyle(
                          fontSize: 11,
                          color: cs.onSurface.withOpacity(0.45),
                          fontFamily: 'monospace',
                        ),
                      ),
                    ],
                  ),
                ),

                // Balance — right side, colored
                Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Text(
                      "BALANCE",
                      style: TextStyle(
                        fontSize: 10,
                        letterSpacing: 0.5,
                        color: cs.onSurface.withOpacity(0.4),
                      ),
                    ),
                    const SizedBox(height: 3),
                    Text(
                      "₹${bal?.toStringAsFixed(2) ?? "—"}",
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.w500,
                        color: accentColor,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),

          // ── Divider ─────────────────────────────────────────────
          Divider(
              height: 1,
              thickness: 0.5,
              color: cs.outlineVariant.withOpacity(0.4)),

          // ── Stats grid ──────────────────────────────────────────
          Padding(
            padding: const EdgeInsets.all(12),
            child: _isStudent
                ? _StudentStats(s: student!, cs: cs)
                : _TeacherStats(t: teacher!, cs: cs),
          ),
        ],
      ),
    );
  }
}

// ═══════════════════════════════════════════════════════════════════════
// STUDENT STATS GRID
// ═══════════════════════════════════════════════════════════════════════
class _StudentStats extends StatelessWidget {
  final StudentPaymentModel s;
  final ColorScheme cs;

  const _StudentStats({required this.s, required this.cs});

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final cols = constraints.maxWidth < 340 ? 2 : 3;
        final ratio = constraints.maxWidth < 340 ? 1.6 : 2.0;
        return GridView.count(
          crossAxisCount: cols,
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          crossAxisSpacing: 8,
          mainAxisSpacing: 8,
          childAspectRatio: ratio,
          children: [
            _StatCell(label: "Adm. Fee", value: "₹${s.admissionFee}", cs: cs),
            _StatCell(
                label: "Deposited",
                value: "₹${s.deposited}",
                variant: _Variant.positive,
                cs: cs),
            _StatCell(
                label: "Credit",
                value: "₹${s.creditAmount}",
                variant: _Variant.info,
                cs: cs),
            _StatCell(
                label: "Dep Pending",
                value: "₹${s.depPending}",
                variant: _Variant.warning,
                cs: cs),
            _StatCell(
                label: "Credit Limit", value: "₹${s.creditLimit}", cs: cs),
            _StatCell(label: "Dep Txns", value: s.depTxns.toString(), cs: cs),
          ],
        );
      },
    );
  }
}

// ═══════════════════════════════════════════════════════════════════════
// TEACHER STATS GRID
// ═══════════════════════════════════════════════════════════════════════
class _TeacherStats extends StatelessWidget {
  final TeacherPaymentModel t;
  final ColorScheme cs;

  const _TeacherStats({required this.t, required this.cs});

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(builder: (context, constraints) {
      final ratio = constraints.maxWidth < 340 ? 1.6 : 2.0;
      return GridView.count(
        crossAxisCount: 3,
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        crossAxisSpacing: 8,
        mainAxisSpacing: 8,
        childAspectRatio: ratio,
        children: [
          _StatCell(label: "Total", value: "₹${t.total}", cs: cs),
          _StatCell(
              label: "Pending",
              value: "₹${t.pending}",
              variant: _Variant.warning,
              cs: cs),
          _StatCell(label: "Withdrawal", value: "₹${t.totalWithdawal}", cs: cs),
        ],
      );
    });
  }
}

// ═══════════════════════════════════════════════════════════════════════
// STAT CELL
// ═══════════════════════════════════════════════════════════════════════
enum _Variant { neutral, positive, warning, info }

class _StatCell extends StatelessWidget {
  final String label;
  final String value;
  final _Variant variant;
  final ColorScheme cs;

  const _StatCell({
    required this.label,
    required this.value,
    this.variant = _Variant.neutral,
    required this.cs,
  });

  Color _valueColor() {
    switch (variant) {
      case _Variant.positive:
        return const Color(0xFF0F6E56);
      case _Variant.warning:
        return const Color(0xFF854F0B);
      case _Variant.info:
        return const Color(0xFF058DCE);
      case _Variant.neutral:
        return cs.onSurface;
    }
  }

  Color _bgColor() {
    switch (variant) {
      case _Variant.positive:
        return const Color(0xFF0F6E56).withOpacity(0.07);
      case _Variant.warning:
        return const Color(0xFFBA7517).withOpacity(0.07);
      case _Variant.info:
        return const Color(0xFF058DCE).withOpacity(0.06);
      case _Variant.neutral:
        return cs.surfaceContainerLowest;
    }
  }

  Color _borderColor() {
    switch (variant) {
      case _Variant.positive:
        return const Color(0xFF0F6E56).withOpacity(0.18);
      case _Variant.warning:
        return const Color(0xFFBA7517).withOpacity(0.2);
      case _Variant.info:
        return const Color(0xFF058DCE).withOpacity(0.18);
      case _Variant.neutral:
        return cs.outlineVariant.withOpacity(0.3);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
      decoration: BoxDecoration(
        color: _bgColor(),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: _borderColor(), width: 0.5),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            label,
            style:
                TextStyle(fontSize: 11, color: cs.onSurface.withOpacity(0.45)),
          ),
          const SizedBox(height: 3),
          Text(
            value,
            style: TextStyle(
              fontSize: 13,
              fontWeight: FontWeight.w500,
              color: _valueColor(),
            ),
            overflow: TextOverflow.ellipsis,
          ),
        ],
      ),
    );
  }
}

// ═══════════════════════════════════════════════════════════════════════
// EMPTY STATE
// ═══════════════════════════════════════════════════════════════════════
class _EmptyState extends StatelessWidget {
  final ColorScheme cs;
  const _EmptyState({required this.cs});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: cs.primaryContainer.withOpacity(0.35),
              shape: BoxShape.circle,
            ),
            child: Icon(
              Icons.receipt_long_outlined,
              size: 36,
              color: cs.primary.withOpacity(0.6),
            ),
          ),
          const SizedBox(height: 16),
          Text(
            "No payments found",
            style: TextStyle(
              fontSize: 15,
              fontWeight: FontWeight.w500,
              color: cs.onSurface.withOpacity(0.65),
            ),
          ),
          const SizedBox(height: 6),
          Text(
            "Try adjusting your search or filter",
            style:
                TextStyle(fontSize: 13, color: cs.onSurface.withOpacity(0.4)),
          ),
        ],
      ),
    );
  }
}
