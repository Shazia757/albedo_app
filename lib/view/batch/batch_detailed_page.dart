import 'package:albedo_app/controller/batch_controller.dart';
import 'package:albedo_app/model/batch_model.dart';
import 'package:albedo_app/model/users/student_model.dart';
import 'package:albedo_app/view/add_batch_package_page.dart';
import 'package:albedo_app/widgets/custom_appbar.dart';
import 'package:albedo_app/widgets/session_widgets.dart';
import 'package:albedo_app/widgets/widgets.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

// ─── Color tokens (from your theme) ─────────────────────────
const _blue = Color(0xFF058DCE);

class BatchDetailedPage extends StatelessWidget {
  final Batch batch;
  final int initialIndex;

  BatchDetailedPage({
    super.key,
    required this.batch,
    required this.initialIndex,
  });

  final c = Get.find<BatchController>();

  @override
  Widget build(BuildContext context) {
    final cs = Get.theme.colorScheme;

    return Scaffold(
      appBar: CustomAppBar(),
      // ── FAB  ────────────────────────────────────
      floatingActionButton: Obx(() {
        final index = c.selectedIndex.value;

        if (c.detailedTabs[index] == 'Packages') {
          return FloatingActionButton(
            mini: true,
            onPressed: () => Get.to(() => AddBatchPackagePage()),
            backgroundColor: context.theme.colorScheme.primary,
            child: Icon(
              Icons.add,
              color: context.theme.colorScheme.onPrimary,
            ),
          );
        }
        if (c.detailedTabs[index] == 'Students') {
          return FloatingActionButton(
            mini: true,
            onPressed: () => CustomWidgets().showCustomDialog(
              context: context,
              title: Text('Assign Student to Batch'),
              formKey: GlobalKey(),
              sections: [
                CustomWidgets()
                    .labelWithAsterisk('Select Student', required: true),
                SizedBox(height: 10),
                CustomWidgets().customDropdownField<Student>(
                  context: context,
                  hint: 'Select Student',
                  items: c.studentsList,
                  value: c.selectedStudent.value,
                  itemLabel: (s) => s.name,
                  onChanged: (student) {},
                ),
                SizedBox(height: 10),
                CustomWidgets().labelWithAsterisk('Total Fee', required: true),
                SizedBox(height: 10),
                CustomWidgets().dropdownStyledTextField(
                    context: context,
                    hint: 'Enter total Fee',
                    controller: c.totalFeeController,
                    isNumber: true),
                SizedBox(height: 10),
                CustomWidgets().labelWithAsterisk('Spot Fee', required: true),
                SizedBox(height: 10),
                CustomWidgets().dropdownStyledTextField(
                    context: context,
                    hint: 'Enter spot Fee',
                    controller: c.spotFeeController,
                    isNumber: true),
                SizedBox(height: 10),
                CustomWidgets().labelWithAsterisk('Upload Payment Receipt'),
                SizedBox(height: 10),
         CustomWidgets().mediaPickerField(
  context: context,
  // fileName: c.selectedMedia.value?.path.split('/').last,
  onTap: () async {
    // await c.pickMedia();
  },
  onClear: () {
    // c.selectedMedia.value = null;
  },
),
              ],
               submitWidget: Text(
      "Assign",
      style:
          Theme.of(context).textTheme.bodyMedium!.copyWith(color: Colors.white),
    ),
              onSubmit: () {},
            ),
            backgroundColor: context.theme.colorScheme.primary,
            child: Icon(
              Icons.add,
              color: context.theme.colorScheme.onPrimary,
            ),
          );
        }
        // if (c.detailedTabs[index] == 'Payments') {
        //   return FloatingActionButton(
        //     mini: true,
        //     onPressed: () {},
        //     backgroundColor: context.theme.colorScheme.primary,
        //     child: Icon(
        //       Icons.add,
        //       color: context.theme.colorScheme.onPrimary,
        //     ),
        //   );
        // }
        if (c.detailedTabs[index] == 'Materials') {
          return FloatingActionButton(
            mini: true,
            onPressed: () {
              CustomWidgets().showCustomDialog(
                context: context,
                title: Text("Add Material"),
                formKey: GlobalKey<FormState>(),
                submitWidget: Text(
      "Add",
      style:
          Theme.of(context).textTheme.bodyMedium!.copyWith(color: Colors.white),
    ),
                onSubmit: () {},
                sections: [
                  CustomWidgets().labelWithAsterisk('Title'),
                  SizedBox(height: 10),
                  CustomWidgets().dropdownStyledTextField(
                      context: context, hint: 'Enter title'),

                  SizedBox(height: 10),

                  /// Material type
                  Obx(
                    () => Column(
                      children: [
                        RadioListTile(
                          dense: true,
                          title: Text('Drive'),
                          value: "drive",
                          groupValue: c.selectedMaterialType.value,
                          onChanged: (value) =>
                              c.selectedMaterialType.value = value!,
                        ),
                        RadioListTile(
                          dense: true,
                          title: Text('Youtube'),
                          value: "youtube",
                          groupValue: c.selectedMaterialType.value,
                          onChanged: (value) =>
                              c.selectedMaterialType.value = value!,
                        ),
                        RadioListTile(
                          dense: true,
                          title: Text('File'),
                          value: "file",
                          groupValue: c.selectedMaterialType.value,
                          onChanged: (value) =>
                              c.selectedMaterialType.value = value!,
                        ),
                      ],
                    ),
                  ),

                  SizedBox(height: 10),

                  Obx(() {
                    if (c.selectedMaterialType.value == 'drive') {
                      return Column(
                        children: [
                          CustomWidgets().labelWithAsterisk('Drive Link'),
                          SizedBox(height: 10),
                          CustomWidgets().dropdownStyledTextField(
                              context: context, hint: 'Paste Drive Link')
                        ],
                      );
                    }

                    if (c.selectedMaterialType.value == 'youtube') {
                      return Column(
                        children: [
                          CustomWidgets().labelWithAsterisk('YouTube Link'),
                          SizedBox(height: 10),
                          CustomWidgets().dropdownStyledTextField(
                              context: context, hint: 'Paste YouTube Link')
                        ],
                      );
                    }

                    if (c.selectedMaterialType.value == 'file') {
                      return Column(
                        children: [
                          CustomWidgets().labelWithAsterisk('Upload file'),
                          SizedBox(height: 10),
                        CustomWidgets().mediaPickerField(
  context: context,
  // fileName: c.selectedMedia.value?.path.split('/').last,
  onTap: () async {
    // await c.pickMedia();
  },
  onClear: () {
    // c.selectedMedia.value = null;
  },
),
                        ],
                      );
                    }

                    return SizedBox();
                  }),

                  SizedBox(height: 10),

                  CustomWidgets().labelWithAsterisk('Description'),
                  SizedBox(height: 10),
                  CustomWidgets().dropdownStyledTextField(
                      context: context,
                      hint: 'Enter description',
                      isMultiline: true),
                ],
              );
            },
            backgroundColor: context.theme.colorScheme.primary,
            child: Icon(
              Icons.add,
              color: context.theme.colorScheme.onPrimary,
            ),
          );
        }

        return SizedBox();
      }),

      body: Column(
        children: [
          SizedBox(height: 16),
          // ── Tabs  ───────────────────────────────
          Obx(() => CustomWidgets().customTabs(
                context,
                tabs: c.detailedTabs,
                selectedIndex: c.selectedIndex.value,
                onTap: (index) => c.selectedIndex.value = index,
              )),
          SizedBox(height: 12),

          // ── Tab bodies ──────────────────────────
          Expanded(
            child: Obx(() {
              final index = c.selectedIndex.value;

              // ─── PROFILE ───────────────────────────────────
              if (c.detailedTabs[index] == 'Batch') {
                return _profileTab(context, cs);
              }
              // ─── PACKAGES  ───────────────────────────────────
              if (c.detailedTabs[index] == 'Packages') {
                return _packagesTab(context, cs);
              }
              // ─── STUDENTS  ───────────────────────────────────
              if (c.detailedTabs[index] == 'Students') {
                return _studentsTab(context, cs);
              }
              // ─── MATERIALS  ───────────────────────────────────
              if (c.detailedTabs[index] == 'Materials') {
                final materials = batch.materials ?? [];

                if (materials.isEmpty) {
                  return EmptyState(
                    cs: cs,
                    icon: Icons.find_in_page_sharp,
                    title: 'No Materials available',
                    subtitle: 'Materials will appear here',
                  );
                }
                return ListView.builder(
                    padding: const EdgeInsets.all(16),
                    itemCount: materials.length,
                    itemBuilder: (_, i) {
                      final m = materials[i];

                      return Container(
                        margin: const EdgeInsets.only(bottom: 12),
                        padding: const EdgeInsets.all(14),
                        decoration: BoxDecoration(
                          color: cs.onPrimary,
                          borderRadius: BorderRadius.circular(14),
                          border: Border.all(color: cs.outline.withOpacity(.3)),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              m.title ?? '-',
                              style: Get.textTheme.titleSmall,
                            ),
                            SizedBox(height: 6),
                            Text(
                              m.description ?? '',
                              style: Get.textTheme
                                  .bodyMedium!
                                  .copyWith(color: cs.outline),
                            ),
                          ],
                        ),
                      );
                    });
              }

              // ─── PAYMENTS ───────────────────────────────────
              if (c.detailedTabs[index] == 'Payments') {
                final payments = batch.payment ?? [];

                if (payments.isEmpty) {
                  return EmptyState(
                    cs: cs,
                    icon: Icons.payments_outlined,
                    title: 'No Payments Found',
                    subtitle: 'Payment records will appear here',
                  );
                }

                return ListView.separated(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemCount: payments.length,
                  separatorBuilder: (_, __) => SizedBox(height: 12),
                  itemBuilder: (_, i) {
                    final payment = payments[i];

                    final isPaid = payment.status == 'Paid';

                    return Container(
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: cs.onPrimary,
                        borderRadius: BorderRadius.circular(16),
                        border: Border.all(
                          color: cs.outline.withOpacity(.5),
                        ),
                        boxShadow: [
                          BoxShadow(
                            color: cs.shadow.withOpacity(.04),
                            blurRadius: 10,
                            offset: const Offset(0, 4),
                          ),
                        ],
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          /// ---------------- TOP ROW ----------------
                          Row(
                            children: [
                              Container(
                                padding: const EdgeInsets.all(12),
                                decoration: BoxDecoration(
                                  color: cs.primary.withOpacity(.08),
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                child: Icon(
                                  Icons.payments_outlined,
                                  color: cs.primary,
                                ),
                              ),

                              SizedBox(width: 14),

                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      payment.studentName ?? '-',
                                      style: Get.textTheme
                                          .titleMedium!
                                          .copyWith(color: cs.onSurface),
                                    ),
                                    SizedBox(height: 4),
                                    Text(
                                      'ID: ${payment.studentId ?? '-'}',
                                      style: Get.textTheme
                                          .bodySmall!
                                          .copyWith(color: cs.outline),
                                    ),
                                  ],
                                ),
                              ),

                              /// Status Badge
                              Container(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 10,
                                  vertical: 6,
                                ),
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(30),
                                  color: isPaid
                                      ? Colors.green.withOpacity(.12)
                                      : Colors.orange.withOpacity(.12),
                                ),
                                child: Text(
                                  payment.status ?? '-',
                                  style: Get.textTheme
                                      .titleSmall!
                                      .copyWith(
                                          color: isPaid
                                              ? Colors.green
                                              : Colors.orange),
                                ),
                              ),
                            ],
                          ),

                          SizedBox(height: 16),

                          /// ---------------- PAYMENT DETAILS ----------------
                          Container(
                            padding: const EdgeInsets.all(14),
                            decoration: BoxDecoration(
                              color: cs.primary.withOpacity(.05),
                              borderRadius: BorderRadius.circular(14),
                            ),
                            child: Row(
                              children: [
                                /// Payment Type
                                Expanded(
                                  child: _compactPaymentItem(
                                    context,
                                    title: 'Type',
                                    value: payment.paymentType ?? '-',
                                    icon: Icons.account_balance_wallet_outlined,
                                  ),
                                ),

                                Container(
                                  width: 1,
                                  height: 38,
                                  color: cs.outline.withOpacity(.15),
                                ),

                                /// Amount
                                Expanded(
                                  child: Padding(
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 12),
                                    child: _compactPaymentItem(
                                      context,
                                      title: 'Amount',
                                      value: '₹${payment.amount ?? 0}',
                                      icon: Icons.currency_rupee,
                                    ),
                                  ),
                                ),

                                Container(
                                  width: 1,
                                  height: 38,
                                  color: cs.outline.withOpacity(.15),
                                ),

                                /// Date
                                Expanded(
                                  child: Padding(
                                    padding: const EdgeInsets.only(left: 12),
                                    child: _compactPaymentItem(
                                      context,
                                      title: 'Date',
                                      value: payment.paymentDate.toString() ??
                                          '-',
                                      icon: Icons.calendar_today_outlined,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    );
                  },
                );
              }

              return SizedBox();
            }),
          ),
        ],
      ),
    );
  }

  Widget _compactPaymentItem(
    BuildContext context, {
    required String title,
    required String value,
    required IconData icon,
  }) {
    final cs = Get.theme.colorScheme;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Icon(
              icon,
              size: 14,
              color: cs.primary,
            ),
            SizedBox(width: 4),
            Text(
              title,
              style: Get.textTheme
                  .labelSmall!
                  .copyWith(color: cs.outline),
            ),
          ],
        ),
        SizedBox(height: 6),
        Text(
          value,
          style: Get.textTheme.titleSmall,
          overflow: TextOverflow.ellipsis,
        ),
      ],
    );
  }

  // ══════════════════════════════════════════════════════════
  //  PROFILE TAB
  // ══════════════════════════════════════════════════════════
  Widget _profileTab(BuildContext context, ColorScheme cs) {
    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        /// Profile Card
        _profileCard(context),

        SizedBox(height: 16),

        /// ---------------- COURSE DETAILS ----------------
        _glassCard(
          context: context,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _cardHeader(
                context,
                'Course Details',
                icon: Icons.menu_book_outlined,
              ),
              _divider(cs),
              Row(
                children: [
                  Expanded(
                    child: _contactRow(
                      context,
                      Icons.book_outlined,
                      'Course Name',
                      batch.course ?? '-',
                    ),
                  ),
                  SizedBox(width: 12),
                  Expanded(
                    child: _contactRow(
                      context,
                      Icons.timer_outlined,
                      'Duration',
                      batch.duration.toString(),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),

        SizedBox(height: 16),

        /// ---------------- BATCH STATISTICS ----------------
        _glassCard(
          context: context,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _cardHeader(
                context,
                'Batch Statistics',
                icon: Icons.analytics_outlined,
              ),
              _divider(cs),
              Row(
                children: [
                  Expanded(
                    child: _statCard(
                      context,
                      title: 'Students',
                      value: '${batch.students ?? 0}',
                      icon: Icons.people_alt_outlined,
                    ),
                  ),
                  SizedBox(width: 12),
                  Expanded(
                    child: _statCard(
                      context,
                      title: 'Packages',
                      value: '${batch.packages?.length ?? 0}',
                      icon: Icons.inventory_2_outlined,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),

        SizedBox(height: 16),

        /// ---------------- PAYMENT SUMMARY ----------------
        _glassCard(
          context: context,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _cardHeader(
                context,
                'Payment Summary',
                icon: Icons.account_balance_wallet_outlined,
              ),
              _divider(cs),
              Row(
                children: [
                  Expanded(
                    child: _paymentTile(
                      context,
                      title: 'Total Fee',
                      value: '₹${batch.totalFee ?? 0}',
                      icon: Icons.currency_rupee,
                    ),
                  ),
                  SizedBox(width: 12),
                  Expanded(
                    child: _paymentTile(
                      context,
                      title: 'Total Paid',
                      value: '₹${batch.totalPaid ?? 0}',
                      icon: Icons.payments_outlined,
                    ),
                  ),
                ],
              ),
              SizedBox(height: 12),
              Row(
                children: [
                  Expanded(
                    child: _paymentTile(
                      context,
                      title: 'Balance',
                      value: '₹${batch.balance ?? 0}',
                      icon: Icons.pending_actions_outlined,
                    ),
                  ),
                  SizedBox(width: 12),
                  Expanded(
                    child: _paymentTile(
                      context,
                      title: 'Expense Ratio',
                      value: '${batch.expenseRatio ?? 0}%',
                      icon: Icons.pie_chart_outline,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),

        SizedBox(height: 16),

        /// ---------------- ASSIGNED PERSONNEL ----------------
        _cardHeader(
          context,
          'Assigned Personnel',
          icon: Icons.support_agent_outlined,
        ),

        SizedBox(height: 10),

        ...[
          _supportTile(
            context,
            'Coordinator',
            batch.coordinator?.name ?? '-',
            batch.coordinator?.id ?? '-',
            'Assigned Coordinator',
            imageUrl: batch.coordinator?.imageUrl,
          ),
          _supportTile(
            context,
            'Mentor',
            batch.mentor?.name ?? '-',
            batch.mentor?.id ?? '-',
            'Assigned Mentor',
            imageUrl: batch.mentor?.imageUrl,
          ),
        ].map(
          (w) => Padding(
            padding: const EdgeInsets.only(bottom: 10),
            child: w,
          ),
        ),
      ],
    );
  }

  Widget _statCard(
    BuildContext context, {
    required String title,
    required String value,
    required IconData icon,
  }) {
    final cs = Get.theme.colorScheme;

    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: cs.primary.withOpacity(.06),
        borderRadius: BorderRadius.circular(14),
      ),
      child: Column(
        children: [
          Icon(icon, color: cs.primary),
          SizedBox(height: 10),
          Text(
            value,
            style: Get.textTheme.titleLarge,
          ),
          SizedBox(height: 4),
          Text(
            title,
            style: Get.textTheme
                .bodySmall!
                .copyWith(color: cs.outline),
          ),
        ],
      ),
    );
  }

  Widget _paymentTile(
    BuildContext context, {
    required String title,
    required String value,
    required IconData icon,
  }) {
    final cs = Get.theme.colorScheme;

    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(14),
        border: Border.all(
          color: cs.outline.withOpacity(.2),
        ),
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: cs.primary.withOpacity(.08),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Icon(
              icon,
              size: 18,
              color: cs.primary,
            ),
          ),
          SizedBox(width: 10),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: Get.textTheme
                      .labelSmall!
                      .copyWith(color: cs.outline),
                ),
                SizedBox(height: 4),
                Text(
                  value,
                  style: Get.textTheme.titleSmall,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // ══════════════════════════════════════════════════════════
  //  BATCHES TAB
  // ══════════════════════════════════════════════════════════
  Widget _batchesTab(
      BuildContext context, ColorScheme cs, List<Batch> batches) {
    return ListView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: batches.length,
      itemBuilder: (context, i) {
        final batch = batches[i];
        final status = batch.status ?? 'Unknown';
        final isActive = status == 'Active';
        final statusColor =
            isActive ? const Color(0xFF22C55E) : const Color(0xFFF59E0B);

        return Container(
          margin: const EdgeInsets.only(bottom: 14),
          decoration: BoxDecoration(
            color: cs.onPrimary,
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: cs.outline.withOpacity(0.5)),
            boxShadow: [
              BoxShadow(
                  color: cs.shadow.withOpacity(0.04),
                  blurRadius: 12,
                  offset: const Offset(0, 4)),
            ],
          ),
          child: Column(
            children: [
              // ── colored top stripe
              Container(
                height: 4,
                decoration: BoxDecoration(
                  borderRadius:
                      const BorderRadius.vertical(top: Radius.circular(16)),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Expanded(
                          child: Text(
                            batch.batchName ?? 'No Name',
                            style: Get.textTheme.titleMedium,
                          ),
                        ),
                        _statusBadge(status, statusColor),
                      ],
                    ),
                    SizedBox(height: 4),
                    Text('ID: ${batch.id ?? '-'}',
                        style: Get.textTheme
                            .labelSmall!
                            .copyWith(color: cs.outline)),
                    SizedBox(height: 14),
                    Divider(height: 1, color: cs.outline.withOpacity(0.15)),
                    SizedBox(height: 14),

                    // Mentor row
                    Row(
                      children: [
                        CustomWidgets().squareAvatar(batch.mentor?.imageUrl, 44),
                        SizedBox(width: 12),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text('Assigned Mentor',
                                style: Get.textTheme
                                    .labelSmall!
                                    .copyWith(color: cs.outline)),
                            SizedBox(height: 2),
                            Text(batch.mentor?.name ?? '-',
                                style: Get.textTheme.titleSmall),
                            Text('ID: ${batch.mentor?.id ?? '-'}',
                                style: Get.textTheme
                                    .labelSmall!
                                    .copyWith(color: cs.outline)),
                          ],
                        )
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  // ══════════════════════════════════════════════════════════
  //  PROFILE CARD
  // ══════════════════════════════════════════════════════════
  Widget _profileCard(BuildContext context) {
    final cs = Get.theme.colorScheme;

    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        color: cs.onPrimary,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: cs.outline.withOpacity(0.5)),
        boxShadow: [
          BoxShadow(
              color: cs.shadow.withOpacity(0.06),
              blurRadius: 16,
              offset: const Offset(0, 6))
        ],
      ),
      child: Column(
        children: [
          // gradient banner
          Container(
            height: 72,
            decoration: BoxDecoration(
              borderRadius:
                  const BorderRadius.vertical(top: Radius.circular(20)),
            ),
          ),

          Padding(
            padding: const EdgeInsets.fromLTRB(24, 0, 24, 24),
            child: Column(
              children: [
                // avatar overlapping banner
                Transform.translate(
                  offset: const Offset(0, -32),
                  child: Container(
                    padding: const EdgeInsets.all(3),
                    decoration: BoxDecoration(
                      color: cs.onPrimary,
                      borderRadius: BorderRadius.circular(14),
                      boxShadow: [
                        BoxShadow(
                            color: cs.shadow.withOpacity(0.1), blurRadius: 8)
                      ],
                    ),
                    child: CustomWidgets().squareAvatar(batch.imageUrl, 64, radius: 12),
                  ),
                ),

                Transform.translate(
                  offset: const Offset(0, -20),
                  child: Column(
                    children: [
                      Text(batch.batchName ?? '-',
                          style: Get.textTheme.titleLarge),

                      // ID badge
                      Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 14, vertical: 6),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(30),
                          border: Border.all(color: _blue.withOpacity(0.3)),
                        ),
                        child: Text('CODE: ${batch.id}',
                            style: Get.textTheme
                                .titleSmall!
                                .copyWith(color: _blue)),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // ══════════════════════════════════════════════════════════
  //  FEEDBACK CARD
  // ══════════════════════════════════════════════════════════
  Widget feedbackCard(Map<String, dynamic> feedback, BuildContext context) {
    final cs = Get.theme.colorScheme;

    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: cs.onPrimary,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: cs.outline.withOpacity(.15),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              CircleAvatar(
                radius: 20,
                backgroundColor: cs.primary.withOpacity(.1),
                child: Icon(
                  Icons.person,
                  color: cs.primary,
                  size: 18,
                ),
              ),
              SizedBox(width: 10),

              /// NAME + DATE
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      feedback['student_name'] ??
                          feedback['mentor_name'] ??
                          '-',
                      style: Get.textTheme.titleSmall,
                    ),
                    SizedBox(height: 2),
                    Text(
                      feedback['date'] ?? '-',
                      style: Get.textTheme
                          .labelSmall!
                          .copyWith(color: cs.outline),
                    ),
                  ],
                ),
              ),

              /// RATING
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 8,
                  vertical: 4,
                ),
                decoration: BoxDecoration(
                  color: Colors.amber.withOpacity(.12),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Row(
                  children: [
                    const Icon(
                      Icons.star,
                      size: 14,
                      color: Colors.amber,
                    ),
                    SizedBox(width: 4),
                    Text(
                      "${feedback['rating'] ?? 0}",
                      style: Get.textTheme.titleSmall,
                    ),
                  ],
                ),
              ),
            ],
          ),
          SizedBox(height: 12),
          Text(
            feedback['message'] ?? '-',
            style: Get.textTheme
                .bodySmall!
                .copyWith(color: cs.onSurface.withOpacity(.8), height: 1.4),
          ),
        ],
      ),
    );
  }
  // ══════════════════════════════════════════════════════════
  //  SMALL HELPERS
  // ══════════════════════════════════════════════════════════

  Widget _glassCard({required BuildContext context, required Widget child}) {
    final cs = Get.theme.colorScheme;
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: cs.onPrimary,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: cs.outline.withOpacity(0.5)),
        boxShadow: [
          BoxShadow(
              color: cs.shadow.withOpacity(0.05),
              blurRadius: 14,
              offset: const Offset(0, 5))
        ],
      ),
      child: child,
    );
  }

  Widget _cardHeader(BuildContext context, String title,
      {required IconData icon}) {
    return Row(
      children: [
        Container(
          padding: const EdgeInsets.all(6),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(8),
          ),
          child: Icon(icon, size: 16, color: _blue),
        ),
        SizedBox(width: 10),
        Text(title, style: Get.textTheme.titleMedium),
      ],
    );
  }

  Widget _divider(ColorScheme cs) => Padding(
        padding: const EdgeInsets.symmetric(vertical: 14),
        child: Divider(height: 1, color: cs.outline.withOpacity(0.15)),
      );

  Widget _contactRow(
      BuildContext context, IconData icon, String label, String value) {
    final cs = Get.theme.colorScheme;
    return Row(
      children: [
        Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: _blue.withOpacity(0.08),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Icon(icon, size: 16, color: _blue),
        ),
        SizedBox(width: 12),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(label,
                style: Get.textTheme
                    .labelSmall!
                    .copyWith(color: cs.outline)),
            Text(value, style: Get.textTheme.titleSmall),
          ],
        ),
      ],
    );
  }

  Widget _statusBadge(String label, Color color) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: color.withOpacity(0.12),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: color.withOpacity(0.4)),
      ),
      child: Text(label,
          style:
              Get.textTheme.titleSmall!.copyWith(color: color)),
    );
  }


  Widget _studentsTab(BuildContext context, ColorScheme cs) {
    final students = batch.student ?? [];

    if (students.isEmpty) {
       return EmptyState(
          cs: cs,
          title: 'No students assigned',
          subtitle: '',
          icon: Icons.group);
    }

    return Column(
      children: [
        /// Search
        CustomWidgets().premiumSearch(
          context,
          hint: 'Search students...',
          onChanged: (p0) {},
        ),

        SizedBox(height: 10),

        /// Students List
        ListView.builder(
          padding: const EdgeInsets.all(16),
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemCount: students.length,
          itemBuilder: (context, index) {
            final student = students[index];

            return Container(
              margin: const EdgeInsets.only(bottom: 12),
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: cs.onPrimary,
                borderRadius: BorderRadius.circular(16),
                border: Border.all(
                  color: cs.outline.withOpacity(.5),
                ),
                boxShadow: [
                  BoxShadow(
                    color: cs.shadow.withOpacity(.04),
                    blurRadius: 10,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              child: Column(
                children: [
                  /// ---------------- TOP SECTION ----------------
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      /// Profile Image
                      Container(
                        width: 56,
                        height: 56,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(14),
                          color: cs.primary.withOpacity(.08),
                          image: student.imageUrl != null &&
                                  student.imageUrl!.isNotEmpty
                              ? DecorationImage(
                                  image: NetworkImage(
                                    student.imageUrl!,
                                  ),
                                  fit: BoxFit.cover,
                                )
                              : null,
                        ),
                        child: (student.imageUrl == null ||
                                student.imageUrl!.isEmpty)
                            ? Icon(
                                Icons.person_outline,
                                color: cs.primary,
                                size: 24,
                              )
                            : null,
                      ),

                      SizedBox(width: 14),

                      /// Student Info
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              student.name ?? '-',
                              style: Get.textTheme
                                  .titleMedium!
                                  .copyWith(color: cs.onSurface),
                            ),
                            SizedBox(height: 4),
                            Text(
                              'ID: ${student.studentId ?? '-'}',
                              style: Get.textTheme
                                  .bodySmall!
                                  .copyWith(color: cs.outline),
                            ),
                            SizedBox(height: 4),
                            Text(
                              student.email ?? '-',
                              style: Get.textTheme
                                  .bodySmall!
                                  .copyWith(color: cs.outline),
                              overflow: TextOverflow.ellipsis,
                            ),
                          ],
                        ),
                      ),

                      /// Status Badge
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 10,
                          vertical: 6,
                        ),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(30),
                          color: student.status?.toLowerCase() == 'completed'
                              ? Colors.green.withOpacity(.12)
                              : Colors.red.withOpacity(.12),
                        ),
                        child: Text(
                          student.status ?? '-',
                          style: Get.textTheme
                              .titleSmall!
                              .copyWith(
                                  color: student.status?.toLowerCase() ==
                                          'completed'
                                      ? Colors.green
                                      : Colors.red),
                        ),
                      ),
                    ],
                  ),

                  SizedBox(height: 14),

                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 14,
                      vertical: 12,
                    ),
                    decoration: BoxDecoration(
                      color: cs.primary.withOpacity(.05),
                      borderRadius: BorderRadius.circular(14),
                    ),
                    child: Row(
                      children: [
                        /// Spot Fee
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Spot Fee',
                                style: Get.textTheme
                                    .labelSmall!
                                    .copyWith(color: cs.outline),
                              ),
                              SizedBox(height: 4),
                              Text(
                                '₹${student.spotFee ?? 0}',
                                style: Get.textTheme.titleSmall,
                              ),
                            ],
                          ),
                        ),

                        Container(
                          width: 1,
                          height: 34,
                          color: cs.outline.withOpacity(.15),
                        ),

                        /// Total Fee
                        Expanded(
                          child: Padding(
                            padding: const EdgeInsets.only(left: 14),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'Total Fee',
                                  style: Get.textTheme
                                      .labelSmall!
                                      .copyWith(color: cs.outline),
                                ),
                                SizedBox(height: 4),
                                Text(
                                  '₹${student.totalAmount ?? 0}',
                                  style: Get.textTheme.titleSmall,
                                ),
                              ],
                            ),
                          ),
                        ),

                        SizedBox(width: 8),

                        /// Edit
                        IconButton(
                          onPressed: () {
                            /// edit
                          },
                          style: IconButton.styleFrom(
                            backgroundColor: cs.primary.withOpacity(.08),
                          ),
                          icon: Icon(
                            Icons.edit_outlined,
                            color: cs.primary,
                            size: 20,
                          ),
                        ),

                        SizedBox(width: 6),

                        /// Delete
                        IconButton(
                          onPressed: () {
                            /// delete
                          },
                          style: IconButton.styleFrom(
                            backgroundColor: Colors.red.withOpacity(.08),
                          ),
                          icon: const Icon(
                            Icons.delete_outline,
                            color: Colors.red,
                            size: 20,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            );
          },
        ),
      ],
    );
  }

  // ══════════════════════════════════════════════════════════
  //  PACKAGES TAB
  // ══════════════════════════════════════════════════════════
  Widget _packagesTab(BuildContext context, ColorScheme cs) {
    final packages = batch.packages ?? [];

    if (packages.isEmpty) {
      return EmptyState(
        cs: cs,
        icon: Icons.inventory_2_outlined,
        title: 'No Packages Found',
        subtitle: 'Assigned packages will appear here',
      );
    }

    return SizedBox(
      height: MediaQuery.of(context).size.height,
      child: ListView.separated(
        padding: const EdgeInsets.all(16),
        shrinkWrap: true,
        itemCount: packages.length,
        separatorBuilder: (_, __) => SizedBox(height: 12),
        itemBuilder: (_, i) {
          final package = packages[i];

          final completedSessions = package.sessionsCompleted ?? 0;

          final totalSessions = package.sessionsTotal ?? 0;

          return Container(
            padding: const EdgeInsets.all(14),
            decoration: BoxDecoration(
              color: cs.onPrimary,
              borderRadius: BorderRadius.circular(16),
              border: Border.all(
                color: cs.outline.withOpacity(.5),
              ),
              boxShadow: [
                BoxShadow(
                  color: cs.shadow.withOpacity(.04),
                  blurRadius: 10,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                /// ---------------- TOP SECTION ----------------
                Row(
                  children: [
                    /// Teacher Image
                    Container(
                      width: 52,
                      height: 52,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(14),
                        color: cs.primary.withOpacity(.08),
                        image: package.teacher?.imageUrl != null &&
                                package.teacher!.imageUrl!.isNotEmpty
                            ? DecorationImage(
                                image: NetworkImage(
                                  package.teacher!.imageUrl!,
                                ),
                                fit: BoxFit.cover,
                              )
                            : null,
                      ),
                      child: package.teacher?.imageUrl == null ||
                              package.teacher!.imageUrl!.isEmpty
                          ? Icon(
                              Icons.person_outline,
                              color: cs.primary,
                            )
                          : null,
                    ),

                    SizedBox(width: 12),

                    /// Teacher + Package Info
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          /// Package Name
                          Text(
                            package.name ?? '-',
                            style: Get.textTheme
                                .titleMedium!
                                .copyWith(color: cs.onSurface),
                          ),

                          SizedBox(height: 4),

                          /// Teacher
                          Text(
                            package.teacher?.name ?? '-',
                            style: Get.textTheme
                                .titleSmall!
                                .copyWith(color: cs.onSurface),
                          ),

                          SizedBox(height: 2),

                          Text(
                            'ID: ${package.teacher?.id ?? '-'}',
                            style: Get.textTheme
                                .labelSmall!
                                .copyWith(color: cs.outline),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),

                SizedBox(height: 14),

                /// ---------------- TAGS ----------------
                Wrap(
                  spacing: 8,
                  runSpacing: 8,
                  children: [
                    _miniTag(
                      cs,
                      Icons.book_outlined,
                      package.name ?? '-',
                    ),
                    _miniTag(
                      cs,
                      Icons.school_outlined,
                      package.standard ?? '-',
                    ),
                    _miniTag(
                      cs,
                      Icons.language_outlined,
                      package.syllabus ?? '-',
                    ),
                  ],
                ),

                SizedBox(height: 14),

                /// ---------------- STATS CARD ----------------
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: cs.primary.withOpacity(.05),
                    borderRadius: BorderRadius.circular(14),
                  ),
                  child: Row(
                    children: [
                      /// Sessions
                      Expanded(
                        child: _compactPackageInfo(
                          context,
                          title: 'Sessions',
                          value: '$completedSessions/$totalSessions',
                          icon: Icons.play_lesson_outlined,
                        ),
                      ),

                      Container(
                        width: 1,
                        height: 34,
                        color: cs.outline.withOpacity(.15),
                      ),

                      /// Time
                      Expanded(
                        child: Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 12),
                          child: _compactPackageInfo(
                            context,
                            title: 'Time',
                            value:
                                '${package.timeCompleted}m/${package.timeTotal}m',
                            icon: Icons.timer_outlined,
                          ),
                        ),
                      ),

                      Container(
                        width: 1,
                        height: 34,
                        color: cs.outline.withOpacity(.15),
                      ),

                      /// Salary
                      Expanded(
                        child: Padding(
                          padding: const EdgeInsets.only(left: 12),
                          child: _compactPackageInfo(
                            context,
                            title: 'Salary',
                            value: '₹${package.teacherSalaryPerHour ?? 0}/hr',
                            icon: Icons.currency_rupee,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _miniTag(
    ColorScheme cs,
    IconData icon,
    String text,
  ) {
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: 10,
        vertical: 6,
      ),
      decoration: BoxDecoration(
        color: cs.primary.withOpacity(.08),
        borderRadius: BorderRadius.circular(30),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            icon,
            size: 14,
            color: cs.primary,
          ),
          SizedBox(width: 5),
          Text(
            text,
            style: Get.textTheme
                .titleSmall!
                .copyWith(color: cs.primary),
          ),
        ],
      ),
    );
  }

  Widget _compactPackageInfo(
    BuildContext context, {
    required String title,
    required String value,
    required IconData icon,
  }) {
    final cs = Get.theme.colorScheme;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Icon(
              icon,
              size: 14,
              color: cs.primary,
            ),
            SizedBox(width: 4),
            Text(
              title,
              style: Get.textTheme
                  .labelSmall!
                  .copyWith(color: cs.outline),
            ),
          ],
        ),
        SizedBox(height: 6),
        Text(
          value,
          style: Get.textTheme.titleSmall,
          overflow: TextOverflow.ellipsis,
        ),
      ],
    );
  }
// ═══════════════════════════════════════════════════════════
//  TOP-LEVEL HELPERS
// ═══════════════════════════════════════════════════════════

  Widget summaryCard({
    required String title,
    required String value,
    required Color color,
  }) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: color.withOpacity(0.3)),
      ),
      child: Row(
        children: [
          Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              color: color.withOpacity(0.15),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Center(
              child: Text(value.substring(0, 1),
                  style: Get.textTheme
                      .titleLarge!
                      .copyWith(color: color)),
            ),
          ),
          SizedBox(width: 14),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(title,
                  style: Get.textTheme
                      .labelSmall!
                      .copyWith(color: color.withOpacity(0.8))),
              SizedBox(height: 3),
              Text(value,
                  style: Get.textTheme
                      .titleLarge!
                      .copyWith(color: color)),
            ],
          ),
        ],
      ),
    );
  }

  Widget _supportTile(
    BuildContext context,
    String role,
    String name,
    String id,
    String date, {
    String? imageUrl,
  }) {
    final cs = Get.theme.colorScheme;
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: cs.onPrimary,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: cs.outline.withOpacity(0.5)),
        boxShadow: [
          BoxShadow(
              color: cs.shadow.withOpacity(0.04),
              blurRadius: 10,
              offset: const Offset(0, 3))
        ],
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          // avatar
          Container(
            width: 52,
            height: 52,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(12),
              image: imageUrl != null
                  ? DecorationImage(
                      image: NetworkImage(imageUrl), fit: BoxFit.cover)
                  : null,
            ),
            child: imageUrl == null
                ? Icon(Icons.person, size: 24, color: _blue.withOpacity(0.6))
                : null,
          ),

          SizedBox(width: 14),

          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(role,
                    style: Get.textTheme
                        .titleSmall!
                        .copyWith(color: _blue)),
                SizedBox(height: 2),
                Text(name, style: Get.textTheme.titleSmall),
                SizedBox(height: 3),
                Text('$id  •  $date',
                    style: Get.textTheme
                        .labelSmall!
                        .copyWith(color: cs.outline)),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
