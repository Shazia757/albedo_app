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

                SizedBox(width: 14),

                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        teacher.name,
                        style: Theme.of(context)
                            .textTheme
                            .titleMedium!
                            .copyWith(color: cs.onSurface),
                      ),
                      SizedBox(height: 5),
                      Text(
                        teacher.id,
                        style: Theme.of(context)
                            .textTheme
                            .bodySmall!
                            .copyWith(color: cs.outline),
                      ),
                      SizedBox(height: 3),
                      Text(
                        "+91 9876543210",
                        style: Theme.of(context)
                            .textTheme
                            .bodySmall!
                            .copyWith(color: cs.outline),
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
                //     style: Theme.of(context).textTheme.titleSmall!.copyWith(//       //       //       color: teacher.status == "approved"
                //           ? Colors.green
                //           : Colors.orange,
                //),
                //   ),
                // ),
              ],
            ),
          ),

          SizedBox(height: 20),

          /// ───────────────── TITLE ─────────────────
          Text(
            "Monthly Earnings",
            style: Theme.of(context)
                .textTheme
                .titleLarge!
                .copyWith(color: cs.onSurface),
          ),

          SizedBox(height: 14),

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
                          SizedBox(width: 12),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  item.month,
                                  style: Theme.of(context)
                                      .textTheme
                                      .titleMedium!
                                      .copyWith(color: cs.onSurface),
                                ),
                                SizedBox(height: 4),
                                Text(
                                  "${item.status.toUpperCase()} • 12 Transactions",
                                  style: Theme.of(context)
                                      .textTheme
                                      .bodySmall!
                                      .copyWith(color: cs.outline),
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

                      SizedBox(height: 16),

                      Divider(
                        color: cs.outline.withOpacity(.12),
                      ),

                      SizedBox(height: 14),

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
          style: Theme.of(context)
              .textTheme
              .titleSmall!
              .copyWith(letterSpacing: 1, color: cs.outline),
        ),
        SizedBox(height: 6),
        Text(
          value,
          style: Theme.of(context)
              .textTheme
              .titleMedium!
              .copyWith(color: cs.onSurface),
        ),
      ],
    );
  }
}
