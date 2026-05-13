import 'package:albedo_app/config/root.dart';
import 'package:albedo_app/controller/auth_controller.dart';
import 'package:albedo_app/controller/student_controller.dart';
import 'package:albedo_app/model/feedback_model.dart';
import 'package:albedo_app/model/package_model.dart';
import 'package:albedo_app/model/settings/assessment_model.dart';
import 'package:albedo_app/model/users/student_model.dart';
import 'package:albedo_app/view/students/add_assessment_page.dart';
import 'package:albedo_app/view/students/add_package_page.dart';
import 'package:albedo_app/view/students/stu_package_page.dart';
import 'package:albedo_app/view/students/wallet_page.dart';
import 'package:albedo_app/widgets/custom_appbar.dart';
import 'package:albedo_app/widgets/dialog.dart';
import 'package:albedo_app/widgets/session_widgets.dart';
import 'package:albedo_app/widgets/widgets.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

// ─── Color tokens (from your theme) ─────────────────────────
const _blue = Color(0xFF058DCE);
const _purple = Color(0xFF793078);

// ─── Tiny helpers ────────────────────────────────────────────
Color _statusColor(String? status) => status?.toLowerCase() == 'active'
    ? const Color(0xFF22C55E)
    : const Color(0xFFF59E0B);

// ============================================================
//  EXTENSION
// ============================================================
extension PackageCalculations on Package {
  double get totalTeacherSalary {
    final rate = hourlyRate ?? 0;
    final sessions = sessionsCompleted ?? 0;
    return rate * sessions;
  }

  double get totalStudentPaid => takenFee ?? 0;
  double get totalStudentBalance => balance ?? 0;

  double get progressPercent {
    final total = sessionsTotal ?? 0;
    final done = sessionsCompleted ?? 0;
    if (total == 0) return 0;
    return done / total;
  }
}

// ============================================================
//  PAGE
// ============================================================
class StudentDetailsPage extends StatelessWidget {
  final Student student;
  final int initialIndex;

  StudentDetailsPage({
    super.key,
    required this.student,
    required this.initialIndex,
  });

  final c = Get.find<StudentController>();

  @override
  Widget build(BuildContext context) {
    final cs = Get.theme.colorScheme;

    return Scaffold(
      appBar: CustomAppBar(),
      // ── FAB is untouched ────────────────────────────────────
      floatingActionButton: Obx(() {
        final index = c.selectedIndex.value;

        if (c.tabs[index] == 'Packages') {
          return FloatingActionButton(
            mini: true,
            onPressed: () => Get.to(() => AddPackagePage()),
            backgroundColor: context.theme.colorScheme.primary,
            child: Icon(
              Icons.add,
              color: context.theme.colorScheme.onPrimary,
            ),
          );
        }
        if (c.tabs[index] == 'Wallet') {
          return FloatingActionButton(
            mini: true,
            onPressed: () => DialogUtils.showDepositDialog(
              context,
              onSubmit: (txn) => c.transactions.add(txn),
            ),
            backgroundColor: context.theme.colorScheme.primary,
            child: Icon(
              Icons.add,
              color: context.theme.colorScheme.onPrimary,
            ),
          );
        }
        if (c.tabs[index] == 'Assessments') {
          return FloatingActionButton(
            mini: true,
            onPressed: () => Get.to(() => AddAssessmentPage()),
            backgroundColor: context.theme.colorScheme.primary,
            child: Icon(
              Icons.add,
              color: context.theme.colorScheme.onPrimary,
            ),
          );
        }
        if (c.tabs[index] == 'Certificates') {
          return FloatingActionButton(
            mini: true,
            onPressed: () {
              CustomWidgets().showCustomDialog(
                context: context,
                title: Text('Create Certificate'),
                formKey: GlobalKey<FormState>(),
                sections: [
                  Obx(() {
                    if (c.step.value == 1) {
                      return Column(children: [
                        CustomWidgets().labelWithAsterisk('Certificate Name',
                            required: true),
                        SizedBox(height: 10),
                        CustomWidgets().dropdownStyledTextField(
                            context: context,
                            hint: 'Certificate of Completion',
                            controller: c.nameController),
                        SizedBox(height: 10),
                        CustomWidgets().labelWithAsterisk('Select Package',
                            required: true),
                        SizedBox(height: 10),
                        CustomWidgets().customDropdownField<Package>(
                          context: context,
                          hint: 'Choose a package',
                          items: student.packages ?? [],
                          onChanged: (p0) => c.selectedPackage.value = p0,
                          itemLabel: (item) => item.name ?? '',
                        ),
                      ]);
                    }
                    return Column(children: [
                      _optionCard(title: 'Generate Certificate', onTap: () {}),
                      _optionCard(title: 'Upload Certificate', onTap: () {}),
                    ]);
                  }),
                ],
                submitText: 'Continue',
                onSubmit: () {
                  final isValid = c.validate(context);
                  if (!isValid) return;
                  if (c.step.value == 1) {
                    Future.microtask(() => c.step.value = 2);
                    return;
                  }
                  Get.back();
                },
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

      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // ── Tabs (untouched) ───────────────────────────────
            Obx(() => CustomWidgets().customTabs(
                  context,
                  tabs: c.tabs,
                  selectedIndex: c.selectedIndex.value,
                  onTap: (index) => c.selectedIndex.value = index,
                )),
            SizedBox(height: 16),

            // ── Tab bodies (upgraded) ──────────────────────────
            Obx(() {
              final index = c.selectedIndex.value;
              final packages = student.packages ?? [];
              final assessments = student.assessment ?? [];

              // ─── PROFILE ───────────────────────────────────
              if (c.tabs[index] == 'Profile') return _profileTab(context, cs);

              // ─── PACKAGES ──────────────────────────────────
              if (c.tabs[index] == 'Packages') {
                if (packages.isEmpty) {
                  return EmptyState(
                    cs: cs,
                    icon: Icons.inventory_2_outlined,
                    title: 'No packages yet',
                    subtitle: '',
                  );
                }
                return _packagesTab(context, cs, packages);
              }

              // ─── BATCHES ───────────────────────────────────
              if (c.tabs[index] == 'Batches') {
                final batches = student.batch ?? [];
                if (batches.isEmpty) {
                  return EmptyState(
                      cs: cs,
                      subtitle: '',
                      icon: Icons.groups_outlined,
                      title: 'No batches assigned');
                }
                return _batchesTab(context, cs, batches);
              }

              // ─── WALLET ────────────────────────────────────
              if (c.tabs[index] == 'Wallet') {
                return studentWalletTab(context, student, c);
              }

              // ─── BATCH PAYMENTS ────────────────────────────
              if (c.tabs[index] == 'Batch Payments') {
                final batches = student.batch ?? [];
                final hasPayments = batches.any((b) =>
                    b.amountPaid != null &&
                    b.amountPaid.toString().trim().isNotEmpty);
                if (!hasPayments) {
                  return EmptyState(
                    icon: Icons.receipt_long_outlined,
                    cs: cs,
                    title: 'No batch payments found',
                    subtitle: '',
                  );
                }
                return _batchPaymentsTab(context, cs, batches);
              }

              // ─── ASSESSMENTS ───────────────────────────────
              if (c.tabs[index] == 'Assessments') {
                if (assessments.isEmpty) {
                  return EmptyState(
                    cs: cs,
                    icon: Icons.quiz_outlined,
                    title: 'No assessments available0',
                    subtitle: '',
                  );
                }
                return ListView.builder(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemCount: assessments.length,
                  itemBuilder: (context, i) =>
                      studentAssessmentCard(context, assessments[i]),
                );
              }

              // ─── SESSIONS ──────────────────────────────────
              if (c.tabs[index] == 'Sessions') {
                if (packages.isEmpty) {
                  return EmptyState(
                    cs: cs,
                    icon: Icons.event_note_outlined,
                    title: 'No packages available',
                    subtitle: '',
                  );
                }
                return _sessionsTab(context, cs, packages);
              }

              // ─── FEEDBACKS ─────────────────────────────────
              if (c.tabs[index] == 'Feedbacks') {
                return _feedbacksTab(context, cs);
              }

              // ─── CERTIFICATES ──────────────────────────────
              if (c.tabs[index] == 'Certificates') {
                final certs = student.certificate ?? [];
                if (certs.isEmpty) {
                  return EmptyState(
                      cs: cs,
                      icon: Icons.workspace_premium_outlined,
                      subtitle: '',
                      title: 'No certificates yet');
                }
                return ListView.builder(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemCount: certs.length,
                  itemBuilder: (context, i) => CertificateCard(cert: certs[i]),
                );
              }

              return SizedBox();
            }),
          ],
        ),
      ),
    );
  }

  // ══════════════════════════════════════════════════════════
  //  PROFILE TAB
  // ══════════════════════════════════════════════════════════
  Widget _profileTab(BuildContext context, ColorScheme cs) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _profileCard(context),
        SizedBox(height: 16),

        // Personal Information card
        _glassCard(
          context: context,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _cardHeader(context, 'Personal Information',
                  icon: Icons.person_outline),
              _divider(cs),
              _infoGridRow(context,
                  label1: 'Created By',
                  value1: student.createdBy ?? '-',
                  label2: 'Created At',
                  value2: 'Oct 10, 2024'),
              SizedBox(height: 14),
              _contactRow(context, Icons.phone_outlined, 'Mobile',
                  student.phone ?? '-'),
              SizedBox(height: 10),
              _contactRow(context, Icons.chat_bubble_outline, 'WhatsApp',
                  student.whatsapp ?? '-'),
              _divider(cs),
              _parentSection(context),
            ],
          ),
        ),

        SizedBox(height: 16),

        // Academic Details card
        _glassCard(
          context: context,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  _cardHeader(context, 'Academic Details',
                      icon: Icons.school_outlined),
                  TextButton.icon(
                    onPressed: () {},
                    icon: const Icon(Icons.badge_outlined, size: 16),
                    label: Text('View ID Card', style: Get.textTheme.bodySmall),
                  ),
                ],
              ),
              _divider(cs),
              _labelValue('Current Address', student.address ?? '-'),
              SizedBox(height: 14),
              _divider(cs),
              Row(
                children: [
                  Expanded(
                      child: _statPill(context, 'Category',
                          student.category ?? '-', Icons.category_outlined)),
                  SizedBox(width: 12),
                  Expanded(
                      child: _statPill(
                          context,
                          'Standard',
                          student.standard?.toString() ?? '-',
                          Icons.menu_book_outlined)),
                ],
              ),
            ],
          ),
        ),

        SizedBox(height: 16),

        // Support Staff
        _cardHeader(context, 'Support Staff',
            icon: Icons.support_agent_outlined),
        SizedBox(height: 10),
        ...[
          _supportTile(context, 'Coordinator', student.coordinator?.name ?? '-',
              student.coordinator?.id ?? '-', 'Oct 12, 2024',
              imageUrl: student.coordinator?.imageUrl),
          _supportTile(context, 'Mentor', student.mentor?.name ?? '-',
              student.mentor?.id ?? '-', 'Oct 15, 2024 - 02:30 PM'),
          _supportTile(context, 'Advisor', student.advisorName ?? '-',
              student.advisorId ?? '-', 'Oct 11, 2024 - 10:00 AM'),
          _supportTile(context, 'Referral', student.referralName ?? '-', '',
              'Oct 05, 2024 - 09:00 AM'),
        ].map((w) =>
            Padding(padding: const EdgeInsets.only(bottom: 10), child: w)),
      ],
    );
  }

  // ══════════════════════════════════════════════════════════
  //  PACKAGES TAB
  // ══════════════════════════════════════════════════════════
  Widget _packagesTab(
      BuildContext context, ColorScheme cs, List<Package> packages) {
    return Column(
      children: [
        CustomWidgets().premiumSearch(context,
            hint: 'Search by package name', onChanged: (p0) {}),
        SizedBox(height: 10),
        // Summary button (untouched logic)
        SizedBox(
          width: double.infinity,
          child: ElevatedButton.icon(
            onPressed: () {
              double totalPackageAmount = 0,
                  totalPaid = 0,
                  totalHours = 0,
                  totalTeacherSalary = 0;
              for (var pkg in packages) {
                totalPackageAmount += pkg.packageFee ?? 0;
                totalPaid += pkg.takenFee ?? 0;
                totalHours += pkg.sessionsCompleted ?? 0;
                totalTeacherSalary += pkg.totalTeacherSalary;
              }
              CustomWidgets().showCustomDialog(
                context: context,
                title: Text('Package Summary (${packages.length} packages)'),
                formKey: GlobalKey(),
                isViewOnly: true,
                onSubmit: () {},
                sections: [
                  ListView.separated(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    itemCount: 4,
                    separatorBuilder: (_, __) => SizedBox(height: 10),
                    itemBuilder: (context, index) {
                      final items = [
                        {
                          "title": "Total Package",
                          "value": "₹${totalPackageAmount.toStringAsFixed(0)}",
                          "color": Colors.blue
                        },
                        {
                          "title": "Class Taken Amount",
                          "value": "₹${totalPaid.toStringAsFixed(0)}",
                          "color": Colors.green
                        },
                        {
                          "title": "Total Hours",
                          "value": totalHours.toStringAsFixed(0),
                          "color": Colors.orange
                        },
                        {
                          "title": "Teacher Salary",
                          "value": "₹${totalTeacherSalary.toStringAsFixed(0)}",
                          "color": Colors.purple
                        },
                        {
                          "title": "Expense Ratio",
                          "value": "26.7%",
                          "color": Colors.red,
                        },
                      ];
                      final item = items[index];
                      return summaryCard(
                          title: item["title"] as String,
                          value: item["value"] as String,
                          color: item["color"] as Color);
                    },
                  ),
                ],
              );
            },
            iconAlignment: IconAlignment.end,
            label: Text('Package Summary',
                style: Get.textTheme.bodySmall!.copyWith(color: Colors.white)),
            style: ElevatedButton.styleFrom(
              backgroundColor: Get.theme.colorScheme.primary,
              elevation: 0,
              padding: const EdgeInsets.symmetric(vertical: 12),
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12)),
            ),
          ),
        ),
        SizedBox(height: 10),
        ListView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemCount: packages.length,
          itemBuilder: (context, index) =>
              studentPackageCard(context, packages[index]),
        ),
      ],
    );
  }

  // ══════════════════════════════════════════════════════════
  //  BATCHES TAB  (redesigned)
  // ══════════════════════════════════════════════════════════
  Widget _batchesTab(BuildContext context, ColorScheme cs, List batches) {
    return ListView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: batches.length,
      itemBuilder: (context, i) {
        final batch = batches[i];
        final isActive = batch.status == 'Active';
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
                        _statusBadge(batch.status ?? '-', statusColor),
                      ],
                    ),
                    SizedBox(height: 4),
                    Text('ID: ${batch.id ?? '-'}',
                        style: Get.textTheme.labelSmall!
                            .copyWith(color: cs.outline)),
                    SizedBox(height: 14),
                    Divider(height: 1, color: cs.outline.withOpacity(0.15)),
                    SizedBox(height: 14),

                    // Mentor row
                    Row(
                      children: [
                        CustomWidgets()
                            .squareAvatar(batch.mentor?.imageUrl, 44),
                        SizedBox(width: 12),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text('Assigned Mentor',
                                style: Get.textTheme.labelSmall!
                                    .copyWith(color: cs.outline)),
                            SizedBox(height: 2),
                            Text(batch.mentor?.name ?? '-',
                                style: Get.textTheme.titleSmall),
                            Text('ID: ${batch.mentor?.id ?? '-'}',
                                style: Get.textTheme.labelSmall!
                                    .copyWith(color: cs.outline)),
                          ],
                        ),
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
  //  BATCH PAYMENTS TAB  (redesigned)
  // ══════════════════════════════════════════════════════════
  Widget _batchPaymentsTab(BuildContext context, ColorScheme cs, List batches) {
    return ListView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: batches.length,
      itemBuilder: (context, i) {
        final batch = batches[i];
        final amountPaid = batch.amountPaid?.toString() ?? '';
        final balStr = batch.balance?.toString() ?? '0';
        if (amountPaid.trim().isEmpty) return const SizedBox.shrink();

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
                  offset: const Offset(0, 4))
            ],
          ),
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Expanded(
                          child: Text(batch.batchName ?? 'No Name',
                              style: Get.textTheme.titleMedium),
                        ),
                        _statusBadge(
                            batch.status ?? '-', _statusColor(batch.status)),
                      ],
                    ),
                    SizedBox(height: 4),
                    Text('Code: ${batch.id ?? '-'}',
                        style: Get.textTheme.bodySmall!
                            .copyWith(color: cs.outline)),
                    SizedBox(height: 14),

                    // Amount pills
                    Row(
                      children: [
                        Expanded(
                          child: _amountPill(
                            context: context,
                            label: 'Paid',
                            value: '₹$amountPaid',
                            color: const Color(0xFF22C55E),
                            icon: Icons.arrow_downward_rounded,
                          ),
                        ),
                        SizedBox(width: 10),
                        Expanded(
                          child: _amountPill(
                            context: context,
                            label: 'Balance',
                            value: '₹$balStr',
                            color: cs.error,
                            icon: Icons.arrow_upward_rounded,
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 12),
                    Row(
                      children: [
                        Icon(Icons.calendar_today_outlined,
                            size: 13, color: cs.outline),
                        SizedBox(width: 6),
                        Text('Paid on: ${batch.paidDate ?? '-'}',
                            style: Get.textTheme.bodySmall!
                                .copyWith(color: cs.outline)),
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
  //  SESSIONS TAB
  // ══════════════════════════════════════════════════════════
  Widget _sessionsTab(
      BuildContext context, ColorScheme cs, List<Package> packages) {
    return Column(
      children: [
        CustomWidgets().premiumSearch(context,
            hint: 'Search by package name', onChanged: (p0) {}),
        SizedBox(height: 10),
        // Session summary button (untouched logic)
        SizedBox(
          width: double.infinity,
          child: ElevatedButton.icon(
            onPressed: () {
              final allSessions = student.packages
                      ?.expand((pkg) => pkg.sessions ?? [])
                      .toList() ??
                  [];
              int totalActive =
                  allSessions.where((s) => s.status == 'active').length;
              int totalUpcoming =
                  allSessions.where((s) => s.status == 'upcoming').length;
              int totalPending =
                  allSessions.where((s) => s.status == 'pending').length;
              int totalActionNeeded =
                  allSessions.where((s) => s.status == 'actionNeeded').length;
              int totalCompleted =
                  allSessions.where((s) => s.status == 'completed').length;
              CustomWidgets().showCustomDialog(
                context: context,
                title: Text('Session Summary (${allSessions.length} sessions)'),
                formKey: GlobalKey(),
                isViewOnly: true,
                onSubmit: () {},
                sections: [
                  ListView.separated(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    itemCount: 5,
                    separatorBuilder: (_, __) => SizedBox(height: 10),
                    itemBuilder: (context, index) {
                      final items = [
                        {
                          "title": "Active",
                          "value": totalActive.toString(),
                          "color": Colors.blue
                        },
                        {
                          "title": "Upcoming",
                          "value": totalUpcoming.toString(),
                          "color": Colors.green
                        },
                        {
                          "title": "Pending",
                          "value": totalPending.toString(),
                          "color": Colors.orange
                        },
                        {
                          "title": "Action Needed",
                          "value": totalActionNeeded.toString(),
                          "color": Colors.purple
                        },
                        {
                          "title": "Completed",
                          "value": totalCompleted.toString(),
                          "color": Colors.grey
                        },
                      ];
                      final item = items[index];
                      return summaryCard(
                          title: item["title"] as String,
                          value: item["value"] as String,
                          color: item["color"] as Color);
                    },
                  ),
                ],
              );
            },
            iconAlignment: IconAlignment.end,
            label: Text('Session Summary',
                style: Get.textTheme.bodySmall!.copyWith(color: Colors.white)),
            style: ElevatedButton.styleFrom(
              backgroundColor: Get.theme.colorScheme.primary,
              elevation: 0,
              padding: const EdgeInsets.symmetric(vertical: 12),
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12)),
            ),
          ),
        ),
        SizedBox(height: 10),
        ListView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemCount: packages.length,
          itemBuilder: (context, index) =>
              studentPackageSessionCard(context, packages[index]),
        ),
      ],
    );
  }

  // ══════════════════════════════════════════════════════════
  //  FEEDBACKS TAB
  // ══════════════════════════════════════════════════════════
  Widget _feedbacksTab(BuildContext context, ColorScheme cs) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Obx(() => CustomWidgets().customTabs(
              context,
              tabs: c.feedbackTabs,
              selectedIndex: c.feedbackTabIndex.value,
              onTap: (i) => c.feedbackTabIndex.value = i,
            )),
        SizedBox(height: 12),
        Obx(() {
          final isTeacher = c.feedbackTabIndex.value == 0;
          final feedbacks = isTeacher ? c.teacherFeedbacks : c.mentorFeedbacks;
          final label = isTeacher ? 'teacher' : 'mentor';

          if (feedbacks.isEmpty) {
            return EmptyState(
              cs: cs,
              icon: Icons.feedback_outlined,
              title: 'No feedback from $label yet',
              subtitle: 'Feedback added by $label will appear here',
            );
          }
          return ListView.separated(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: feedbacks.length,
            separatorBuilder: (_, __) => SizedBox(height: 10),
            itemBuilder: (_, i) => feedbackCard(feedbacks[i], context),
          );
        }),
      ],
    );
  }

  // ══════════════════════════════════════════════════════════
  //  PROFILE CARD  (upgraded)
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
                    child: CustomWidgets(). squareAvatar(student.imageUrl, 64, radius: 12),
                  ),
                ),

                Transform.translate(
                  offset: const Offset(0, -20),
                  child: Column(
                    children: [
                      Text(student.name, style: Get.textTheme.titleLarge),
                      SizedBox(height: 4),
                      Text(student.email ?? '-',
                          style: Get.textTheme.bodySmall!
                              .copyWith(color: cs.outline)),
                      SizedBox(height: 10),

                      // ID badge
                      Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 14, vertical: 6),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(30),
                          border: Border.all(color: _blue.withOpacity(0.3)),
                        ),
                        child: Text('ID: ${student.studentId}',
                            style: Get.textTheme.titleSmall!
                                .copyWith(color: _blue)),
                      ),

                      SizedBox(height: 12),

                      // Fee status chip
                      _feeStatusChip(context, student.isFeePaid),

                      SizedBox(height: 16),

                      // Dashboard button
                      SizedBox(
                        width: double.infinity,
                        child: ElevatedButton.icon(
                          onPressed: () {
                            final auth = Get.find<AuthController>();
                            final user = studentToUser(student);

                            auth.startImpersonation(user);
                            Get.offAll(() => const Root());
                          },
                          icon: const Icon(Icons.arrow_right_alt,
                              size: 15, color: Colors.white),
                          iconAlignment: IconAlignment.end,
                          label: Text('Go to Dashboard',
                              style: Get.textTheme.bodySmall!
                                  .copyWith(color: Colors.white)),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: cs.primary,
                            elevation: 0,
                            padding: const EdgeInsets.symmetric(vertical: 12),
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12)),
                          ),
                        ),
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
  //  PACKAGE CARD  (upgraded)
  // ══════════════════════════════════════════════════════════
  Widget studentPackageCard(BuildContext context, Package package) {
    final cs = Get.theme.colorScheme;
    final packageFee = package.packageFee ?? 0;
    final paidFee = package.takenFee ?? 0;
    final balance = package.balance ?? (packageFee - paidFee);
    final hourly = package.hourlyRate ?? 0;
    final totalSessions = student.totalSession ?? 0;
    final completedSessions = student.classesTaken ?? 0;
    final sessionProgress =
        totalSessions == 0 ? 0.0 : completedSessions / totalSessions;
    final feeProgress = packageFee == 0 ? 0.0 : paidFee / packageFee;
    final isActive = (package.status ?? '').toLowerCase() == 'active';
    final statusColor =
        isActive ? const Color(0xFF22C55E) : const Color(0xFFF59E0B);

    return Container(
      margin: const EdgeInsets.only(bottom: 16),
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
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // HEADER
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(package.name ?? '-',
                              style: Get.textTheme.titleMedium),
                          SizedBox(height: 6),
                          _statusBadge(package.status ?? '', statusColor),
                        ],
                      ),
                    ),
                    PopupMenuButton<String>(
                      icon: Icon(Icons.more_vert, color: cs.outline),
                      onSelected: (value) {},
                      itemBuilder: (context) => const [
                        PopupMenuItem(value: "edit", child: Text("Edit")),
                        PopupMenuItem(value: "delete", child: Text("Delete")),
                        PopupMenuItem(
                            value: "refund", child: Text("Request Refund")),
                        PopupMenuItem(
                            value: "deactivate", child: Text("Deactivate")),
                      ],
                    ),
                  ],
                ),

                SizedBox(height: 6),
                Row(
                  children: [
                    Icon(Icons.calendar_today_outlined,
                        size: 12, color: cs.outline),
                    SizedBox(width: 5),
                    Text('Enrolled: 12 Oct 2024 • 10:30 AM',
                        style: Get.textTheme.bodySmall!
                            .copyWith(color: cs.outline)),
                  ],
                ),

                _sectionDivider(cs),

                // COURSE + TEACHER
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          _metaChip(context, Icons.menu_book_outlined,
                              'Std ${student.standard}'),
                          SizedBox(height: 6),
                          _metaChip(context, Icons.science_outlined,
                              package.subjectName ?? '-'),
                          SizedBox(height: 6),
                          _metaChip(context, Icons.school_outlined,
                              student.course ?? '-'),
                        ],
                      ),
                    ),
                    // Teacher
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        CircleAvatar(
                          radius: 22,
                          backgroundImage: const NetworkImage(
                              "https://i.pravatar.cc/150?img=3"),
                        ),
                        SizedBox(height: 6),
                        Text(package.teacher?.name ?? '',
                            style: Get.textTheme.titleSmall),
                        Text(package.teacher?.id ?? '',
                            style: Get.textTheme.labelSmall!
                                .copyWith(color: cs.outline)),
                      ],
                    ),
                  ],
                ),

                _sectionDivider(cs),

                // MODE / TIME / DURATION
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    _iconStat(context, Icons.videocam_outlined, 'Mode',
                        package.mode ?? '-'),
                    _iconStat(context, Icons.schedule_outlined, 'Time',
                        package.time ?? '-'),
                    _iconStat(context, Icons.timer_outlined, 'Duration',
                        package.duration ?? '-'),
                  ],
                ),

                _sectionDivider(cs),

                // PROGRESS
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Progress', style: Get.textTheme.titleSmall),
                    SizedBox(height: 10),
                    _progressRow(
                        context, 'Sessions', sessionProgress, cs.primary),
                    SizedBox(height: 8),
                    _progressRow(
                        context, 'Fees', feeProgress, const Color(0xFF22C55E)),
                    SizedBox(height: 8),
                    Text(
                      '$completedSessions/$totalSessions sessions  •  ${student.totalHour ?? 0} hrs  •  ${(feeProgress * 100).toStringAsFixed(0)}% fee',
                      style:
                          Get.textTheme.labelSmall!.copyWith(color: cs.outline),
                    ),
                  ],
                ),

                _sectionDivider(cs),

                // STATUS TOGGLE
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Obx(() => Row(
                          children: [
                            Icon(
                              c.isActive.value
                                  ? Icons.check_circle_outline
                                  : Icons.cancel_outlined,
                              size: 16,
                              color: c.isActive.value
                                  ? const Color(0xFF22C55E)
                                  : cs.error,
                            ),
                            SizedBox(width: 6),
                            Text(c.status.value,
                                style: Get.textTheme.titleSmall!.copyWith(
                                    color: c.isActive.value
                                        ? const Color(0xFF22C55E)
                                        : cs.error)),
                          ],
                        )),
                    Obx(() => Switch(
                          value: c.isActive.value,
                          activeColor: const Color(0xFF22C55E),
                          onChanged: (v) {
                            c.isActive.value = v;
                            c.status.value =
                                v ? 'Demo Completed' : 'Demo Pending';
                          },
                        )),
                  ],
                ),

                _sectionDivider(cs),

                // TEACHER FEES
                _feesSection(
                  context,
                  title: 'Teacher Fees',
                  icon: Icons.person_outline,
                  color: _purple,
                  items: [
                    _feeRow('Hourly Salary',
                        '₹${(package.hourlyRate ?? 0).toStringAsFixed(0)}'),
                    _feeRow('Expense Ratio', '${package.expenseRatio ?? 0}%'),
                    _feeRow('Total Salary',
                        '₹${package.totalTeacherSalary.toStringAsFixed(0)}',
                        bold: true),
                  ],
                ),

                SizedBox(height: 12),

                // STUDENT FEES
                _feesSection(
                  context,
                  title: 'Student Fees',
                  icon: Icons.school_outlined,
                  color: _blue,
                  items: [
                    _feeRow('Hourly', '₹${hourly.toStringAsFixed(0)}'),
                    _feeRow('Package', '₹${packageFee.toStringAsFixed(0)}'),
                    _feeRow('Collected', '₹${paidFee.toStringAsFixed(0)}',
                        valueColor: const Color(0xFF22C55E)),
                    _feeRow('Balance', '₹${balance.toStringAsFixed(0)}',
                        valueColor: cs.error, bold: true),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // ══════════════════════════════════════════════════════════
  //  SESSION CARD
  // ══════════════════════════════════════════════════════════
  Widget studentPackageSessionCard(BuildContext context, Package package) {
    if ((package.name ?? '').trim().isEmpty) return SizedBox();
    final cs = Get.theme.colorScheme;
    final totalSessions = package.sessions?.length ?? 0;

    return InkWell(
      onTap: () => Get.to(PackageSessionPage(), arguments: package),
      borderRadius: BorderRadius.circular(14),
      child: Container(
        margin: const EdgeInsets.only(bottom: 12),
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: cs.onPrimary,
          borderRadius: BorderRadius.circular(14),
          border: Border.all(color: cs.outline.withOpacity(0.5)),
          boxShadow: [
            BoxShadow(
                color: cs.shadow.withOpacity(0.04),
                blurRadius: 10,
                offset: const Offset(0, 4))
          ],
        ),
        child: Row(
          children: [
            Container(
              width: 42,
              height: 42,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10),
              ),
              child: Icon(Icons.event_note_outlined, color: _blue, size: 20),
            ),
            SizedBox(width: 12),
            Expanded(
              child:
                  Text(package.name ?? '-', style: Get.textTheme.titleMedium),
            ),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(20),
                  color: _blue.withOpacity(0.2)),
              child: Text('$totalSessions Sessions',
                  style: Get.textTheme.titleSmall!.copyWith(color: _blue)),
            ),
          ],
        ),
      ),
    );
  }

  // ══════════════════════════════════════════════════════════
  //  ASSESSMENT CARD
  // ══════════════════════════════════════════════════════════
  Widget studentAssessmentCard(BuildContext context, Assessment assessment) {
    final cs = Get.theme.colorScheme;

    return InkWell(
      onTap: () => DialogUtils().showAssessmentDialog(context, assessment),
      borderRadius: BorderRadius.circular(16),
      child: Container(
        margin: const EdgeInsets.only(bottom: 14),
        decoration: BoxDecoration(
          color: cs.onPrimary,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: cs.outline.withOpacity(0.5)),
          boxShadow: [
            BoxShadow(
                color: cs.shadow.withOpacity(0.04),
                blurRadius: 12,
                offset: const Offset(0, 4))
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              height: 4,
              decoration: BoxDecoration(
                borderRadius:
                    const BorderRadius.vertical(top: Radius.circular(16)),
              ),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 14, 8, 14),
              child: Row(
                children: [
                  Container(
                    width: 40,
                    height: 40,
                    decoration: BoxDecoration(
                      color: _blue.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Icon(Icons.quiz_outlined, color: _blue, size: 20),
                  ),
                  SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(assessment.type ?? 'Assessment',
                            style: Get.textTheme.titleMedium),
                        SizedBox(height: 4),
                        Row(
                          children: [
                            Icon(Icons.calendar_today_outlined,
                                size: 12, color: cs.outline),
                            SizedBox(width: 4),
                            Text(assessment.date ?? '-',
                                style: Get.textTheme.bodySmall!
                                    .copyWith(color: cs.outline)),
                            SizedBox(width: 12),
                            Icon(Icons.schedule_outlined,
                                size: 12, color: cs.outline),
                            SizedBox(width: 4),
                            Text('10:30 AM',
                                style: Get.textTheme.bodySmall!
                                    .copyWith(color: cs.outline)),
                          ],
                        ),
                      ],
                    ),
                  ),
                  IconButton(
                      icon: const Icon(Icons.edit_outlined, size: 18),
                      onPressed: () {}),
                  IconButton(
                      icon:
                          Icon(Icons.delete_outline, size: 18, color: cs.error),
                      onPressed: () {}),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  // ══════════════════════════════════════════════════════════
  //  FEEDBACK CARD
  // ══════════════════════════════════════════════════════════
  Widget feedbackCard(Feedbacks f, BuildContext context) {
    final cs = Get.theme.colorScheme;
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: cs.onPrimary,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: cs.outline.withOpacity(0.5)),
        boxShadow: [
          BoxShadow(
              color: cs.shadow.withOpacity(0.04),
              blurRadius: 10,
              offset: const Offset(0, 4))
        ],
      ),
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: []),
    );
  }

  Widget buildCertificateSection(BuildContext context, Student student) {
    if (c.step.value == 1) {
      return Column(children: [
        CustomWidgets().labelWithAsterisk('Certificate Name', required: true),
        SizedBox(height: 10),
        CustomWidgets().dropdownStyledTextField(
            context: context,
            hint: 'Certificate of Completion',
            controller: c.nameController),
        SizedBox(height: 10),
        CustomWidgets().labelWithAsterisk('Select Package', required: true),
        SizedBox(height: 10),
        CustomWidgets().customDropdownField<Package>(
          context: context,
          hint: 'Choose a package',
          items: student.packages ?? [],
          onChanged: (p0) => c.selectedPackage.value = p0,
          itemLabel: (item) => item.name ?? '',
        ),
      ]);
    }
    return Column(children: [
      _optionCard(title: 'Generate Certificate', onTap: () {}),
      _optionCard(title: 'Upload Certificate', onTap: () {}),
    ]);
  }

  Widget _optionCard({required String title, required VoidCallback onTap}) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(12),
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
            border: Border.all(color: Colors.grey.shade300),
            borderRadius: BorderRadius.circular(12)),
        child: Row(children: [
          const Icon(Icons.description),
          SizedBox(width: 12),
          Text(title),
        ]),
      ),
    );
  }

  Widget CertificateCard({required cert}) => SizedBox();

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
    final cs = Get.theme.colorScheme;
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

  Widget _sectionDivider(ColorScheme cs) => Padding(
        padding: const EdgeInsets.symmetric(vertical: 12),
        child: Divider(height: 1, color: cs.outline.withOpacity(0.12)),
      );

  Widget _infoGridRow(BuildContext context,
      {required String label1,
      required String value1,
      required String label2,
      required String value2}) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        _miniStat(context, label1, value1),
        _miniStat(context, label2, value2),
      ],
    );
  }

  Widget _miniStat(BuildContext context, String label, String value) {
    final cs = Get.theme.colorScheme;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label,
            style: Get.textTheme.labelSmall!.copyWith(color: cs.outline)),
        SizedBox(height: 3),
        Text(value, style: Get.textTheme.titleSmall),
      ],
    );
  }

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
                style: Get.textTheme.labelSmall!.copyWith(color: cs.outline)),
            Text(value, style: Get.textTheme.titleSmall),
          ],
        ),
      ],
    );
  }

  Widget _parentSection(BuildContext context) {
    final cs = Get.theme.colorScheme;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('Parent Details',
            style: Get.textTheme.titleSmall!.copyWith(color: cs.outline)),
        SizedBox(height: 4),
        Text(student.parentName ?? '-', style: Get.textTheme.titleSmall),
        if (student.parentOccupation != null)
          Text(student.parentOccupation!,
              style: Get.textTheme.bodySmall!.copyWith(color: cs.outline)),
      ],
    );
  }

  Widget _statPill(
      BuildContext context, String label, String value, IconData icon) {
    final cs = Get.theme.colorScheme;
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
      decoration: BoxDecoration(
        color: _blue.withOpacity(0.06),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: _blue.withOpacity(0.15)),
      ),
      child: Row(
        children: [
          Icon(icon, size: 16, color: _blue),
          SizedBox(width: 8),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(label,
                  style: Get.textTheme.labelSmall!.copyWith(color: cs.outline)),
              Text(value, style: Get.textTheme.titleSmall),
            ],
          ),
        ],
      ),
    );
  }

  Widget _feeStatusChip(BuildContext context, bool paid) {
    final color = paid ? const Color(0xFF22C55E) : Get.theme.colorScheme.error;
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 7),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(30),
        border: Border.all(color: color.withOpacity(0.4)),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(paid ? Icons.task_alt : Icons.cancel_outlined,
              size: 15, color: color),
          SizedBox(width: 6),
          Text(paid ? 'Admission Fee Paid' : 'Admission Fee Unpaid',
              style: Get.textTheme.titleSmall!.copyWith(color: color)),
        ],
      ),
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
      child:
          Text(label, style: Get.textTheme.titleSmall!.copyWith(color: color)),
    );
  }

  Widget _metaChip(BuildContext context, IconData icon, String label) {
    final cs = Get.theme.colorScheme;
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(icon, size: 13, color: cs.outline),
        SizedBox(width: 5),
        Text(label,
            style: Get.textTheme.bodySmall!.copyWith(color: cs.onSurface)),
      ],
    );
  }

  Widget _iconStat(
      BuildContext context, IconData icon, String label, String value) {
    final cs = Get.theme.colorScheme;
    return Column(
      children: [
        Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: _blue.withOpacity(0.08),
            borderRadius: BorderRadius.circular(10),
          ),
          child: Icon(icon, size: 18, color: _blue),
        ),
        SizedBox(height: 5),
        Text(label,
            style: Get.textTheme.labelSmall!.copyWith(color: cs.outline)),
        SizedBox(height: 2),
        Text(value, style: Get.textTheme.titleSmall),
      ],
    );
  }

  Widget _progressRow(
      BuildContext context, String label, double value, Color color) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(label, style: Get.textTheme.labelMedium),
            Text('${(value * 100).toStringAsFixed(0)}%',
                style: Get.textTheme.titleSmall!.copyWith(color: color)),
          ],
        ),
        SizedBox(height: 4),
        ClipRRect(
          borderRadius: BorderRadius.circular(6),
          child: LinearProgressIndicator(
            value: value.clamp(0.0, 1.0),
            minHeight: 6,
            backgroundColor: color.withOpacity(0.12),
            valueColor: AlwaysStoppedAnimation<Color>(color),
          ),
        ),
      ],
    );
  }

  Widget _feesSection(BuildContext context,
      {required String title,
      required IconData icon,
      required Color color,
      required List<Widget> items}) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: color.withOpacity(0.04),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: color.withOpacity(0.5)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(icon, size: 15, color: color),
              SizedBox(width: 6),
              Text(title,
                  style: Get.textTheme.titleSmall!.copyWith(color: color)),
            ],
          ),
          SizedBox(height: 10),
          ...items,
        ],
      ),
    );
  }

  Widget _feeRow(String label, String value,
      {Color? valueColor, bool bold = false}) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 5),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label, style: Get.textTheme.bodySmall),
          Text(value,
              style: Get.textTheme.bodySmall!.copyWith(
                  fontWeight: bold ? FontWeight.w700 : FontWeight.w500,
                  color: valueColor)),
        ],
      ),
    );
  }

  Widget _amountPill({
    required BuildContext context,
    required String label,
    required String value,
    required Color color,
    required IconData icon,
  }) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
      decoration: BoxDecoration(
        color: color.withOpacity(0.08),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: color.withOpacity(0.5)),
      ),
      child: Row(
        children: [
          Icon(icon, size: 15, color: color),
          SizedBox(width: 6),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(label,
                  style: Get.textTheme.labelSmall!.copyWith(color: color)),
              Text(value,
                  style: Get.textTheme.titleSmall!.copyWith(color: color)),
            ],
          ),
        ],
      ),
    );
  }
}

// ═══════════════════════════════════════════════════════════
//  TOP-LEVEL HELPERS  (unchanged signatures, upgraded visuals)
// ═══════════════════════════════════════════════════════════

Widget _labelValue(String label, String value) {
  return Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      Text(label,
          style: Get.textTheme.labelSmall!.copyWith(color: Colors.grey)),
      SizedBox(height: 3),
      Text(value, style: Get.textTheme.titleSmall),
    ],
  );
}

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
                style: Get.textTheme.titleLarge!.copyWith(color: color)),
          ),
        ),
        SizedBox(width: 14),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(title,
                style: Get.textTheme.labelSmall!
                    .copyWith(color: color.withOpacity(0.8))),
            SizedBox(height: 3),
            Text(value,
                style: Get.textTheme.titleLarge!.copyWith(color: color)),
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
                  style: Get.textTheme.titleSmall!.copyWith(color: _blue)),
              SizedBox(height: 2),
              Text(name, style: Get.textTheme.titleSmall),
              SizedBox(height: 3),
              Text('$id  •  $date',
                  style: Get.textTheme.labelSmall!.copyWith(color: cs.outline)),
            ],
          ),
        ),
      ],
    ),
  );
}
