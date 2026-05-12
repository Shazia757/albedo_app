import 'package:albedo_app/controller/payment_controller.dart';
import 'package:albedo_app/model/payment_model.dart';
import 'package:albedo_app/view/payment/student_payment_detail_page.dart';
import 'package:albedo_app/view/payment/teacher_payment_detail_page.dart';
import 'package:albedo_app/widgets/header_with_search.dart';
import 'package:albedo_app/widgets/session_widgets.dart';
import 'package:albedo_app/widgets/widgets.dart';
import 'package:albedo_app/widgets/custom_appbar.dart';
import 'package:albedo_app/widgets/drawer_menu.dart';
import 'package:albedo_app/widgets/responsive.dart';
import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:get/get.dart';

class PaymentPage extends StatelessWidget {
  final PaymentUserType type;

  late final PaymentController c;

  PaymentPage({
    super.key,
    required this.type,
  }) {
    c = Get.put(
      PaymentController(
        isStudent: type == PaymentUserType.student,
      ),
      tag: type.name,
    );

    if (type == PaymentUserType.student) {
      c.fetchStudents();
    } else {
      c.fetchTeachers();
    }
  }
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
              children: [
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: HeaderWithSearch(
                    title: _isStudent ? "Student Payments" : "Teacher Payments",
                    hint: _isStudent
                        ? "Search students..."
                        : "Search teachers...",
                    isSearching: c.isSearching,
                    searchQuery: c.searchQuery,
                    onSearchChanged: () => c.applyFilters(),
                  ),
                ),

                // ── Tabs ──────────────────────────────────────────────
                Obx(
                  () {
                    return CustomWidgets().customTabs(
                      context,
                      tabs: c.isStudent ? c.studentTabs : c.tabs,
                      selectedIndex: c.selectedTab.value,
                      onTap: (index) {
                        c.selectedTab.value = index;
                        c.applyFilters();
                      },
                      getCount: (index) {
                        if (_isStudent) {
                          return c.studentTabData[index]['count'];
                        }

                        return c.tabData[index]['count'];
                      },
                    );
                  },
                ),

                SizedBox(height: 12),

                // ── List ──────────────────────────────────────────────
                Expanded(
                  child: Obx(() {
                    final students = c.filteredStudentPayments;
                    final teachers = c.filteredTeacherPayments;
                    final count =
                        _isStudent ? students.length : teachers.length;

                    if (count == 0) {
                      return EmptyState(
                        cs: cs,
                        icon: Icons.not_interested_rounded,
                        title: 'No payments found',
                        subtitle: '',
                      );
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
                          padding: const EdgeInsets.fromLTRB(20, 8, 20, 24),
                          itemCount: count,
                          mainAxisSpacing: 12,
                          crossAxisSpacing: 12,
                          physics: const BouncingScrollPhysics(),
                          itemBuilder: (_, i) => _PaymentCard(
                            student: _isStudent ? students[i] : null,
                            teacher: _isStudent ? null : teachers[i],
                            paymentC: c,
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
  const _PaymentCard({
    this.student,
    this.teacher,
    required this.paymentC,
  });

  final StudentPaymentModel? student;
  final TeacherPaymentModel? teacher;
  final PaymentController paymentC;

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;

    final isStudent = student != null;

    final name = isStudent ? student!.name : teacher!.name;
    final id = isStudent ? student!.id : teacher!.id;
    final status = isStudent
        ? (student!.status ?? 'pending')
        : (teacher!.status ?? 'pending');

    final balance = isStudent
        ? ((student!.courseFee ?? 0) - (student!.depositedAmount ?? 0))
        : ((teacher!.totalEarned ?? 0) - (teacher!.alreadyPaid ?? 0));

    final statusColor = status == 'approved' ? Colors.green : Colors.orange;

    return InkWell(
      borderRadius: BorderRadius.circular(22),
      onTap: () {
        if (isStudent) {
          Get.to(
            () => StudentPaymentDetailsPage(
              student: student!,
              paymentC: paymentC,
            ),
          );
        } else {
          Get.to(
            () => TeacherPaymentDetailsPage(
              teacher: teacher!,
            ),
          );
        }
      },
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: cs.onPrimary,
          borderRadius: BorderRadius.circular(22),
          border: Border.all(
            color: cs.outline.withOpacity(.5),
          ),
          boxShadow: [
            BoxShadow(
              color: cs.shadow.withOpacity(.04),
              blurRadius: 16,
              offset: const Offset(0, 6),
            ),
          ],
        ),
        child: Column(
          children: [
            /// ── TOP ─────────────────────────────
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  width: 48,
                  height: 48,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(16),
                    color: cs.primary.withOpacity(.08),
                  ),
                  child: Icon(
                    Icons.person_outline_rounded,
                    color: cs.primary,
                  ),
                ),
                SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        name,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: Theme.of(context)
                            .textTheme
                            .titleSmall!
                            .copyWith(color: cs.onSurface),
                      ),
                      SizedBox(height: 4),
                      Text(
                        id,
                        style: Theme.of(context)
                            .textTheme
                            .labelSmall!
                            .copyWith(color: cs.outline),
                      ),
                    ],
                  ),
                ),
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 10,
                    vertical: 6,
                  ),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(30),
                    color: statusColor.withOpacity(.12),
                  ),
                  child: Text(
                    status.toUpperCase(),
                    style: Theme.of(context)
                        .textTheme
                        .labelMedium!
                        .copyWith(color: statusColor),
                  ),
                ),
              ],
            ),

            SizedBox(height: 12),

            /// ── BALANCE CARD ────────────────────
            Container(
              padding: const EdgeInsets.fromLTRB(0, 12, 12, 12),
              decoration: BoxDecoration(
                color: Colors.red.withOpacity(.04),
              ),
              child: Row(
                children: [
                  /// left outline indicator
                  Container(
                    width: 4,
                    height: 52,
                    decoration: BoxDecoration(
                      color: Colors.red,
                      borderRadius: BorderRadius.circular(30),
                    ),
                  ),

                  SizedBox(width: 14),

                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "BALANCE DUE",
                          style: Theme.of(context)
                              .textTheme
                              .labelMedium!
                              .copyWith(
                                  letterSpacing: 1.1,
                                  color: Colors.red.shade700),
                        ),
                        SizedBox(height: 4),
                        Text(
                          "₹${balance.toStringAsFixed(0)}",
                          style:
                              Theme.of(context).textTheme.titleLarge!.copyWith(

                                  /// same red color as title
                                  color: Colors.red.shade700),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(height: 12),

            Divider(
              color: cs.outline.withOpacity(.15),
              height: 1,
            ),

            SizedBox(height: 12),
            if (!isStudent) ...[
              Builder(
                builder: (_) {
                  final earnings = teacher?.monthlyEarnings
                          ?.where((e) => e.amount > 0)
                          .toList() ??
                      [];

                  if (earnings.isEmpty) {
                    return SizedBox();
                  }

                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "MONTHLY EARNINGS",
                        style: Theme.of(context)
                            .textTheme
                            .labelMedium!
                            .copyWith(letterSpacing: 1, color: cs.outline),
                      ),
                      SizedBox(height: 10),
                      SizedBox(
                        height: 92,
                        child: ListView.separated(
                          scrollDirection: Axis.horizontal,
                          itemCount: earnings.length,
                          separatorBuilder: (_, __) => SizedBox(width: 10),
                          itemBuilder: (_, i) {
                            final item = earnings[i];
                            final isApproved =
                                item.status.toLowerCase() == 'approved';

                            final bgColor = isApproved
                                ? Colors.green.withOpacity(.08)
                                : cs.outline.withOpacity(.10);

                            final borderColor = isApproved
                                ? Colors.green.withOpacity(.15)
                                : cs.outline.withOpacity(.18);

                            final textColor =
                                isApproved ? Colors.green.shade700 : cs.outline;

                            return Container(
                              width: 84,
                              padding: const EdgeInsets.symmetric(
                                horizontal: 10,
                                vertical: 10,
                              ),
                              decoration: BoxDecoration(
                                color: bgColor,
                                borderRadius: BorderRadius.circular(16),
                                border: Border.all(
                                  color: borderColor,
                                ),
                              ),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Text(
                                    item.month.toUpperCase(),
                                    style: Theme.of(context)
                                        .textTheme
                                        .labelMedium!
                                        .copyWith(
                                            letterSpacing: 1, color: textColor),
                                  ),
                                  SizedBox(height: 6),
                                  Text(
                                    "₹${item.amount}",
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                    style: Theme.of(context)
                                        .textTheme
                                        .labelMedium!
                                        .copyWith(
                                            color: textColor,
                                            fontWeight: FontWeight.bold),
                                  ),
                                ],
                              ),
                            );
                          },
                        ),
                      ),
                      SizedBox(height: 14),
                      Divider(
                        color: cs.outline.withOpacity(.15),
                        height: 1,
                      ),
                      SizedBox(height: 12),
                    ],
                  );
                },
              ),
            ],

            /// ── DETAILS ─────────────────────────
            if (isStudent)
              Column(
                children: [
                  Row(
                    children: [
                      Expanded(
                        child: _info(
                          context,
                          "Course Fee",
                          "₹${student!.courseFee ?? 0}",
                        ),
                      ),
                      Expanded(
                        child: _info(
                          context,
                          "Already Paid",
                          "₹${student!.depositedAmount ?? 0}",
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 12),
                  Row(
                    children: [
                      Expanded(
                        child: _info(
                          context,
                          "Pending Deposit",
                          "₹${student!.depositPending ?? 0}",
                        ),
                      ),
                      Expanded(
                        child: _info(
                          context,
                          "Credit Limit",
                          "₹${student!.creditLimit ?? 0}",
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 12),
                  Row(
                    children: [
                      Expanded(
                        child: _info(
                          context,
                          "Credit Pending",
                          "₹${student!.creditAmount ?? 0}",
                        ),
                      ),
                      const Expanded(child: SizedBox()),
                    ],
                  ),
                ],
              ),

            if (!isStudent)
              Column(
                children: [
                  Row(
                    children: [
                      Expanded(
                        child: _info(
                          context,
                          "Withdrawal Requests",
                          "₹${teacher!.withdrawalRequests ?? 0}",
                        ),
                      ),
                      Expanded(
                        child: _info(
                          context,
                          "Pending Requests",
                          "${teacher!.pendingTransactions ?? 0}",
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 12),
                  Row(
                    children: [
                      Expanded(
                        child: _info(
                          context,
                          "Total Earned",
                          "₹${teacher!.totalEarned ?? 0}",
                        ),
                      ),
                      Expanded(
                        child: _info(
                          context,
                          "Already Paid",
                          "${teacher!.alreadyPaid ?? 0}",
                        ),
                      ),
                    ],
                  ),
                ],
              ),

            SizedBox(height: 14),
            if (isStudent) ...[
              Divider(
                color: cs.outline.withOpacity(.15),
                height: 1,
              ),

              SizedBox(height: 14),

              /// ── FOOTER ──────────────────────────

              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 10,
                  vertical: 8,
                ),
                decoration: BoxDecoration(
                  color: cs.surfaceContainerHighest.withOpacity(.35),
                  borderRadius: BorderRadius.circular(14),
                ),
                child: Row(
                  children: [
                    Icon(
                      Icons.inventory_2_outlined,
                      size: 18,
                      color: cs.primary,
                    ),
                    SizedBox(width: 6),
                    Text(
                      "${student?.packages ?? 0} Packages",
                      style: Theme.of(context)
                          .textTheme
                          .titleSmall!
                          .copyWith(color: cs.onSurface),
                    ),
                    const Spacer(),
                    Text(
                      "Admission Fee:",
                      style: Theme.of(context)
                          .textTheme
                          .bodySmall!
                          .copyWith(color: cs.outline),
                    ),
                    SizedBox(width: 6),
                    Text(
                      (student?.admissionFeePaid ?? false) ? "Paid" : "Unpaid",
                      style: Theme.of(context).textTheme.titleSmall!.copyWith(
                          color: (student?.admissionFeePaid ?? false)
                              ? Colors.green
                              : cs.error),
                    ),
                  ],
                ),
              )
            ]
          ],
        ),
      ),
    );
  }

  Widget _info(
    BuildContext context,
    String label,
    String value,
  ) {
    final cs = Theme.of(context).colorScheme;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label.toUpperCase(),
          style: Theme.of(context)
              .textTheme
              .labelMedium!
              .copyWith(color: cs.outline, letterSpacing: .5),
        ),
        SizedBox(height: 5),
        Text(
          value,
          style: Theme.of(context)
              .textTheme
              .titleSmall!
              .copyWith(color: cs.onSurface),
        ),
      ],
    );
  }
}
