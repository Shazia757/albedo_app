import 'package:albedo_app/model/payment_model.dart';
import 'package:albedo_app/view/teacher/add_wallet_page.dart';
import 'package:albedo_app/widgets/custom_appbar.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class TeacherPaymentDetailsPage extends StatelessWidget {
  const TeacherPaymentDetailsPage({
    super.key,
    required this.teacher,
  });

  final TeacherPaymentModel teacher;

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;

    final earnings = (teacher.monthlyEarnings ?? [])
        .where(
          (e) => e.status.toLowerCase() == "pending",
        )
        .toList();

    return Scaffold(
      appBar: const CustomAppBar(),
      backgroundColor: cs.surface,
      floatingActionButton: FloatingActionButton(
        mini: true,
        onPressed: () => Get.to(() => AddWalletPage()),
        backgroundColor: context.theme.colorScheme.primary,
        child: Icon(
          Icons.add,
          color: context.theme.colorScheme.onPrimary,
        ),
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          /// ───────────────── PROFILE CARD ─────────────────
          Container(
            padding: const EdgeInsets.all(16),
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

                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        teacher.name,
                        style: TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.w700,
                          color: cs.onSurface,
                        ),
                      ),
                      const SizedBox(height: 5),
                      Text(
                        teacher.id,
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

                // Container(
                //   padding: const EdgeInsets.symmetric(
                //     horizontal: 12,
                //     vertical: 7,
                //   ),
                //   decoration: BoxDecoration(
                //     color: teacher.status == "approved"
                //         ? Colors.green.withOpacity(.12)
                //         : Colors.orange.withOpacity(.12),
                //     borderRadius: BorderRadius.circular(30),
                //   ),
                //   child: Text(
                //     teacher.status.toUpperCase(),
                //     style: TextStyle(
                //       fontSize: 11,
                //       fontWeight: FontWeight.w700,
                //       color: teacher.status == "approved"
                //           ? Colors.green
                //           : Colors.orange,
                //     ),
                //   ),
                // ),
              ],
            ),
          ),

          const SizedBox(height: 20),

          /// ───────────────── TITLE ─────────────────
          Text(
            "Monthly Earnings",
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w700,
              color: cs.onSurface,
            ),
          ),

          const SizedBox(height: 14),

          /// ───────────────── EARNINGS LIST ─────────────────
          ...earnings.map(
            (item) {
              return Padding(
                padding: const EdgeInsets.only(bottom: 14),
                child: Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: cs.onPrimary,
                    borderRadius: BorderRadius.circular(22),
                    border: Border.all(
                      color: cs.outline.withOpacity(.5),
                    ),
                  ),
                  child: Column(
                    children: [
                      /// top row
                      Row(
                        children: [
                          Container(
                            width: 48,
                            height: 48,
                            decoration: BoxDecoration(
                              color: Colors.orange.withOpacity(.08),
                              borderRadius: BorderRadius.circular(16),
                            ),
                            child: Icon(
                              Icons.calendar_month_rounded,
                              color: Colors.orange,
                            ),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  item.month,
                                  style: TextStyle(
                                    fontSize: 15,
                                    fontWeight: FontWeight.w700,
                                    color: cs.onSurface,
                                  ),
                                ),
                                const SizedBox(height: 4),
                                Text(
                                  "${item.status.toUpperCase()} • 12 Transactions",
                                  style: TextStyle(
                                    fontSize: 12,
                                    color: cs.outline,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          ElevatedButton.icon(
                            onPressed: () {},
                            style: ElevatedButton.styleFrom(
                              elevation: 0,
                              backgroundColor: cs.primary,
                              foregroundColor: Colors.white,
                              padding: const EdgeInsets.symmetric(
                                horizontal: 14,
                                vertical: 10,
                              ),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(14),
                              ),
                            ),
                            icon: Icon(
                              Icons.approval_rounded,
                              color: cs.onPrimary,
                              size: 16,
                            ),
                            label: Text(
                              "Approve",
                            ),
                          ),
                        ],
                      ),

                      const SizedBox(height: 16),

                      Divider(
                        color: cs.outline.withOpacity(.12),
                      ),

                      const SizedBox(height: 14),

                      /// details
                      Row(
                        children: [
                          Expanded(
                            child: _infoTile(
                              context,
                              "Earned Amount",
                              "₹${item.amount}",
                            ),
                          ),
                          Expanded(
                            child: _infoTile(
                              context,
                              "Paid Amount",
                              "₹0",
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              );
            },
          ),
        ],
      ),
    );
  }

  Widget _infoTile(
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
          style: TextStyle(
            fontSize: 10,
            letterSpacing: 1,
            fontWeight: FontWeight.w700,
            color: cs.outline,
          ),
        ),
        const SizedBox(height: 6),
        Text(
          value,
          style: TextStyle(
            fontSize: 15,
            fontWeight: FontWeight.w800,
            color: cs.onSurface,
          ),
        ),
      ],
    );
  }
}
