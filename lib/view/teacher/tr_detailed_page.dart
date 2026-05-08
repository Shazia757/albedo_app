import 'package:albedo_app/controller/student_controller.dart';
import 'package:albedo_app/controller/teacher_controller.dart';
import 'package:albedo_app/controller/teacher_wallet_controller.dart';
import 'package:albedo_app/model/batch_model.dart';
import 'package:albedo_app/model/feedback_model.dart';
import 'package:albedo_app/model/package_model.dart';
import 'package:albedo_app/model/users/teacher_model.dart';
import 'package:albedo_app/view/teacher/add_wallet_page.dart';
import 'package:albedo_app/view/teacher/tr_package_session_page.dart';
import 'package:albedo_app/view/teacher/tr_wallet_tab.dart';
import 'package:albedo_app/widgets/custom_appbar.dart';
import 'package:albedo_app/widgets/session_widgets.dart';
import 'package:albedo_app/widgets/widgets.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

// ─── Color tokens (from your theme) ─────────────────────────
const _blue = Color(0xFF058DCE);

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
class TeacherDetailsPage extends StatelessWidget {
  final Teacher teacher;
  final int initialIndex;

  TeacherDetailsPage({
    super.key,
    required this.teacher,
    required this.initialIndex,
  });

  final c = Get.find<TeacherController>();

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;

    return Scaffold(
      appBar: CustomAppBar(),
      // ── FAB is untouched ────────────────────────────────────
      floatingActionButton: Obx(() {
        final index = c.selectedIndex.value;

        if (c.detailedTabs[index] == 'Wallet') {
          return FloatingActionButton(
            mini: true,
            onPressed: () => Get.to(() => AddWalletPage(
                  teacher: teacher,
                )),
            child: const Icon(Icons.add),
          );
        }

        return const SizedBox();
      }),

      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // ── Tabs (untouched) ───────────────────────────────
            Obx(() => CustomWidgets().customTabs(
                  context,
                  tabs: c.detailedTabs,
                  selectedIndex: c.selectedIndex.value,
                  onTap: (index) => c.selectedIndex.value = index,
                )),
            const SizedBox(height: 16),

            // ── Tab bodies (upgraded) ──────────────────────────
            Obx(() {
              final index = c.selectedIndex.value;
              final walletController = Get.put(TeacherWalletController());

              // ─── PROFILE ───────────────────────────────────
              if (c.detailedTabs[index] == 'Profile') {
                return _profileTab(context, cs);
              }
              // ─── PROFESSIONAL  ───────────────────────────────────
              if (c.detailedTabs[index] == 'Professional') {
                return _professionalTab(context, cs);
              }
              // ─── STUDENTS  ───────────────────────────────────
              if (c.detailedTabs[index] == 'Students') {
                return _studentsTab(context, cs);
              }

              // ─── BATCHES ───────────────────────────────────
              if (c.detailedTabs[index] == 'Batches') {
                final batches = teacher.batch ?? [];

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
              if (c.detailedTabs[index] == 'Wallet') {
                return teacherWalletTab(context, teacher, c, walletController);
              }

              // ─── FEEDBACKS ─────────────────────────────────
              if (c.detailedTabs[index] == 'Feedback') {
                return _feedbacksTab(context, cs);
              }
              // ─── ACCESS ─────────────────────────────────
              if (c.detailedTabs[index] == 'Access') {
                final overrides = c.accessOverrides;

                return Column(
                  children: [
                    if (overrides.isEmpty)
                      EmptyState(
                        cs: cs,
                        icon: Icons.lock_open_outlined,
                        title: "No overrides found",
                        subtitle: "Add unlock to grant temporary access",
                      )
                    else
                      ListView(
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        children: overrides
                            .map((e) => _accessCard(e, context))
                            .toList(),
                      ),
                    const SizedBox(height: 12),
                    _unlockButton(context),
                    _unlockForm(context),
                  ],
                );
              }

              return const SizedBox();
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
        const SizedBox(height: 16),

        // Personal Information card
        _glassCard(
          context: context,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _cardHeader(context, 'Personal Information',
                  icon: Icons.person_outline),
              _divider(cs),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  _contactRow(context, Icons.phone_outlined, 'Mobile',
                      teacher.phone ?? '-'),
                  const SizedBox(height: 10),
                  _contactRow(context, Icons.chat_bubble_outline, 'WhatsApp',
                      teacher.whatsapp ?? '-'),
                ],
              ),
              _divider(cs),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  _contactRow(
                      context, Icons.place, 'Place', teacher.place ?? "-"),
                  const SizedBox(height: 10),
                  _contactRow(context, Icons.calendar_today_outlined,
                      'Date Of Birth', teacher.dob ?? "-"),
                ],
              ),
            ],
          ),
        ),

        const SizedBox(height: 16),

        // Academic Details card
        _glassCard(
          context: context,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _cardHeader(context, 'Payment Details', icon: Icons.payment),
              _divider(cs),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('UPI ID',
                      style: TextStyle(
                          fontSize: 11,
                          color: cs.outline,
                          fontWeight: FontWeight.w600)),
                  const SizedBox(height: 4),
                  Text(teacher.upiId ?? '-',
                      style: const TextStyle(
                          fontSize: 14, fontWeight: FontWeight.w700)),
                  const SizedBox(height: 8),
                  Text('Account No.',
                      style: TextStyle(
                          fontSize: 11,
                          color: cs.outline,
                          fontWeight: FontWeight.w600)),
                  const SizedBox(height: 4),
                  Text(teacher.accountNumber ?? '-',
                      style: const TextStyle(
                          fontSize: 14, fontWeight: FontWeight.w700)),
                  const SizedBox(height: 8),
                  Text('IFSC Code',
                      style: TextStyle(
                          fontSize: 11,
                          color: cs.outline,
                          fontWeight: FontWeight.w600)),
                  const SizedBox(height: 4),
                  Text(teacher.ifscCode ?? '-',
                      style: const TextStyle(
                          fontSize: 14, fontWeight: FontWeight.w700)),
                ],
              )
            ],
          ),
        ),
      ],
    );
  }

  // ══════════════════════════════════════════════════════════
  //  PROFESSIONAL TAB
  // ══════════════════════════════════════════════════════════
  Widget _professionalTab(BuildContext context, ColorScheme cs) {
    final experiences = teacher.experience ?? [];

    int totalYears = 0;
    int totalMonths = 0;

    /// 🔹 Add all experience entries
    for (final exp in experiences) {
      totalYears += exp.years ?? 0;
      totalMonths += exp.months ?? 0;
    }

    /// 🔹 Convert extra months into years
    totalYears += totalMonths ~/ 12;
    totalMonths = totalMonths % 12;

    /// 🔹 Final formatted text
    final experienceText = '$totalYears Years ${totalMonths} Months';

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        /// 🔹 Professional Details
        _glassCard(
          context: context,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _cardHeader(
                context,
                'Professional Details',
                icon: Icons.work_outline,
              ),

              _divider(cs),

              const SizedBox(height: 14),

              /// Qualification + Experience
              Row(
                children: [
                  Expanded(
                    child: _infoTile(
                      context,
                      title: 'Qualification',
                      value: teacher.qualification ?? '-',
                      icon: Icons.school_outlined,
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: _infoTile(
                      context,
                      title: 'Experience',
                      value: experienceText,
                      icon: Icons.workspace_premium_outlined,
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 14),

              /// Preferred Language
              _infoTile(
                context,
                title: 'Preferred Language',
                value: teacher.prefLanguage ?? '-',
                icon: Icons.language_outlined,
              ),

              const SizedBox(height: 14),

              /// Work Experience
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(
                    color: cs.outline.withOpacity(0.2),
                  ),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Work Experience',
                      style: TextStyle(
                        fontSize: 13,
                        fontWeight: FontWeight.w700,
                        color: cs.onSurface,
                      ),
                    ),
                    const SizedBox(height: 10),
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        if ((teacher.experience ?? []).isEmpty)
                          Text(
                            'No work experience added',
                            style: TextStyle(
                              fontSize: 12,
                              color: cs.outline,
                            ),
                          )
                        else
                          Column(
                            children: (teacher.experience ?? []).map((exp) {
                              return Container(
                                margin: const EdgeInsets.only(bottom: 10),
                                child: Row(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Container(
                                      height: 36,
                                      width: 36,
                                      decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(10),
                                        color: cs.primary.withOpacity(0.08),
                                      ),
                                      child: Icon(
                                        Icons.business_center_outlined,
                                        size: 18,
                                        color: cs.primary,
                                      ),
                                    ),
                                    const SizedBox(width: 10),
                                    SizedBox(
                                      width: MediaQuery.of(context).size.width *
                                          0.6,
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            exp.companyName ?? '-',
                                            style: TextStyle(
                                              fontSize: 13,
                                              fontWeight: FontWeight.w700,
                                              color: cs.onSurface,
                                            ),
                                          ),
                                          const SizedBox(height: 2),
                                          Text(
                                            '${exp.years ?? 0} Years ${exp.months ?? 0} Months',
                                            style: TextStyle(
                                              fontSize: 11,
                                              color: cs.outline,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                              );
                            }).toList(),
                          )
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),

        const SizedBox(height: 16),

        /// 🔹 Documents & Security
        _glassCard(
          context: context,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _cardHeader(
                context,
                'Documents & Security',
                icon: Icons.folder_outlined,
              ),

              _divider(cs),

              const SizedBox(height: 14),

              /// 🔹 Documents
              Text(
                'Documents',
                style: TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w700,
                  color: cs.outline,
                ),
              ),

              const SizedBox(height: 10),

              Wrap(
                spacing: 10,
                runSpacing: 10,
                children: [
                  _docButton(
                    context,
                    cs,
                    title: 'ID Card',
                    icon: Icons.badge_outlined,
                    onTap: () {},
                  ),
                  _docButton(
                    context,
                    cs,
                    title: 'Resume',
                    icon: Icons.description_outlined,
                    onTap: () {},
                  ),
                  _docButton(
                    context,
                    cs,
                    title: 'Educational Certificate',
                    icon: Icons.school_outlined,
                    onTap: () {},
                  ),
                  _docButton(
                    context,
                    cs,
                    title: 'Aadhar Front',
                    icon: Icons.credit_card_outlined,
                    onTap: () {},
                  ),
                  _docButton(
                    context,
                    cs,
                    title: 'Aadhar Back',
                    icon: Icons.credit_card,
                    onTap: () {},
                  ),
                ],
              ),

              const SizedBox(height: 18),

              /// 🔹 Security
              Text(
                'Security',
                style: TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w700,
                  color: cs.outline,
                ),
              ),

              const SizedBox(height: 10),

              Row(
                children: [
                  Expanded(
                    child: _docButton(
                      context,
                      cs,
                      title: 'Change Username',
                      icon: Icons.person_outline,
                      onTap: () => CustomWidgets().showCustomDialog(
                        context: context,
                        title: Text('Change Username'),
                        formKey: GlobalKey(),
                        sections: [
                          CustomWidgets().labelWithAsterisk('New Username',
                              required: true),
                          const SizedBox(height: 10),
                          CustomWidgets().dropdownStyledTextField(
                              context: context,
                              hint: 'Enter new username',
                              controller: c.usernameController),
                        ],
                        submitText: 'Change',
                        onSubmit: () {},
                      ),
                    ),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: _docButton(
                      context,
                      cs,
                      title: 'Change Password',
                      icon: Icons.lock_outline,
                      onTap: () => CustomWidgets().showCustomDialog(
                        context: context,
                        title: Text('Change Password'),
                        formKey: GlobalKey(),
                        sections: [
                          CustomWidgets().labelWithAsterisk('Current Password',
                              required: true),
                          const SizedBox(height: 10),
                          Obx(
                            () => CustomWidgets().dropdownStyledTextField(
                              context: context,
                              isPassword: true,
                              hint: 'Enter current password',
                              controller: c.currentPasswordController,
                              obscureText: c.obscurePassword.value,
                              onTogglePassword: () {
                                c.obscurePassword.value =
                                    !c.obscurePassword.value;
                              },
                            ),
                          ),
                          const SizedBox(height: 10),
                          CustomWidgets().labelWithAsterisk('New Password',
                              required: true),
                          const SizedBox(height: 10),
                          Obx(
                            () => CustomWidgets().dropdownStyledTextField(
                              context: context,
                              hint: 'Enter new password',
                              isPassword: true,
                              controller: c.newPasswordController,
                              obscureText: c.obscureNewPassword.value,
                              onTogglePassword: () {
                                c.obscureNewPassword.value =
                                    !c.obscureNewPassword.value;
                              },
                            ),
                          ),
                          const SizedBox(height: 10),
                          CustomWidgets().labelWithAsterisk('Confirm Password',
                              required: true),
                          const SizedBox(height: 10),
                          Obx(
                            () => CustomWidgets().dropdownStyledTextField(
                                context: context,
                                isPassword: true,
                                obscureText: c.obscureConfirmPassword.value,
                                onTogglePassword: () {
                                  c.obscureConfirmPassword.value =
                                      !c.obscureConfirmPassword.value;
                                },
                                hint: 'Confirm new password',
                                controller: c.confirmNewPasswordController),
                          ),
                        ],
                        submitText: 'Change',
                        onSubmit: () {},
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        )
      ],
    );
  }

  Widget _infoTile(
    BuildContext context, {
    required String title,
    required String value,
    required IconData icon,
  }) {
    final cs = Theme.of(context).colorScheme;

    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: cs.outline.withOpacity(0.12),
        ),
      ),
      child: Row(
        children: [
          Container(
            height: 38,
            width: 38,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10),
              color: cs.primary.withOpacity(0.08),
            ),
            child: Icon(
              icon,
              size: 18,
              color: cs.primary,
            ),
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
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  value,
                  style: TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.w700,
                    color: cs.onSurface,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _docButton(
    BuildContext context,
    ColorScheme cs, {
    required String title,
    required IconData icon,
    required VoidCallback onTap,
  }) {
    return InkWell(
      borderRadius: BorderRadius.circular(12),
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 180),
        padding: const EdgeInsets.symmetric(
          horizontal: 14,
          vertical: 12,
        ),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(14),
          color: cs.primary.withOpacity(0.06),
          border: Border.all(
            color: cs.primary.withOpacity(0.15),
          ),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              icon,
              size: 18,
              color: cs.primary,
            ),
            const SizedBox(width: 8),
            Text(
              title,
              style: TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.w600,
                color: cs.onSurface,
              ),
            ),
          ],
        ),
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
                            style: const TextStyle(
                                fontSize: 15, fontWeight: FontWeight.w700),
                          ),
                        ),
                        _statusBadge(status, statusColor),
                      ],
                    ),
                    const SizedBox(height: 4),
                    Text('ID: ${batch.id ?? '-'}',
                        style: TextStyle(fontSize: 11, color: cs.outline)),
                    const SizedBox(height: 14),
                    Divider(height: 1, color: cs.outline.withOpacity(0.15)),
                    const SizedBox(height: 14),

                    // Mentor row
                    Row(
                      children: [
                        _squareAvatar(batch.mentor?.imageUrl, 44),
                        const SizedBox(width: 12),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text('Assigned Mentor',
                                style:
                                    TextStyle(fontSize: 11, color: cs.outline)),
                            const SizedBox(height: 2),
                            Text(batch.mentor?.name ?? '-',
                                style: const TextStyle(
                                    fontSize: 13, fontWeight: FontWeight.w600)),
                            Text('ID: ${batch.mentor?.id ?? '-'}',
                                style:
                                    TextStyle(fontSize: 11, color: cs.outline)),
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
        const SizedBox(height: 12),
        Obx(() {
          final isStudent = c.feedbackTabIndex.value == 0;
          final feedbacks = isStudent ? c.studentFeedbacks : c.mentorFeedbacks;
          final label = isStudent ? 'Student' : 'Mentor';

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
            separatorBuilder: (_, __) => const SizedBox(height: 10),
            itemBuilder: (_, i) => feedbackCard(feedbacks[i], context),
          );
        }),
      ],
    );
  }

  // ══════════════════════════════════════════════════════════
  //  PROFILE CARD
  // ══════════════════════════════════════════════════════════
  Widget _profileCard(BuildContext context) {
    final cs = Theme.of(context).colorScheme;

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
                    child: _squareAvatar(teacher.imageUrl, 64, radius: 12),
                  ),
                ),

                Transform.translate(
                  offset: const Offset(0, -20),
                  child: Column(
                    children: [
                      Text(teacher.name,
                          style: const TextStyle(
                              fontSize: 18, fontWeight: FontWeight.w800)),
                      const SizedBox(height: 4),
                      Text(teacher.email ?? '-',
                          style: TextStyle(fontSize: 13, color: cs.outline)),
                      const SizedBox(height: 10),

                      // ID badge
                      Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 14, vertical: 6),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(30),
                          border: Border.all(color: _blue.withOpacity(0.3)),
                        ),
                        child: Text('ID: ${teacher.id}',
                            style: TextStyle(
                                fontSize: 12,
                                fontWeight: FontWeight.w700,
                                color: _blue)),
                      ),

                      const SizedBox(height: 12),

                      // Dashboard button
                      SizedBox(
                        width: double.infinity,
                        child: ElevatedButton.icon(
                          onPressed: () {},
                          icon: const Icon(Icons.arrow_right_alt,
                              size: 15, color: Colors.white),
                          iconAlignment: IconAlignment.end,
                          label: const Text('Go to Dashboard',
                              style:
                                  TextStyle(color: Colors.white, fontSize: 13)),
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
  //  FEEDBACK CARD
  // ══════════════════════════════════════════════════════════
  Widget feedbackCard(Map<String, dynamic> feedback, BuildContext context) {
    final cs = Theme.of(context).colorScheme;

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
              const SizedBox(width: 10),

              /// NAME + DATE
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      feedback['student_name'] ??
                          feedback['mentor_name'] ??
                          '-',
                      style: const TextStyle(
                        fontWeight: FontWeight.w700,
                        fontSize: 14,
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      feedback['date'] ?? '-',
                      style: TextStyle(
                        fontSize: 11,
                        color: cs.outline,
                      ),
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
                    const SizedBox(width: 4),
                    Text(
                      "${feedback['rating'] ?? 0}",
                      style: const TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Text(
            feedback['message'] ?? '-',
            style: TextStyle(
              fontSize: 13,
              color: cs.onSurface.withOpacity(.8),
              height: 1.4,
            ),
          ),
        ],
      ),
    );
  }
  // ══════════════════════════════════════════════════════════
  //  SMALL HELPERS
  // ══════════════════════════════════════════════════════════

  Widget _glassCard({required BuildContext context, required Widget child}) {
    final cs = Theme.of(context).colorScheme;
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
        const SizedBox(width: 10),
        Text(title,
            style: const TextStyle(fontSize: 15, fontWeight: FontWeight.w700)),
      ],
    );
  }

  Widget _divider(ColorScheme cs) => Padding(
        padding: const EdgeInsets.symmetric(vertical: 14),
        child: Divider(height: 1, color: cs.outline.withOpacity(0.15)),
      );

  Widget _contactRow(
      BuildContext context, IconData icon, String label, String value) {
    final cs = Theme.of(context).colorScheme;
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
        const SizedBox(width: 12),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(label, style: TextStyle(fontSize: 11, color: cs.outline)),
            Text(value,
                style:
                    const TextStyle(fontSize: 13, fontWeight: FontWeight.w600)),
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
          style: TextStyle(
              fontSize: 11, fontWeight: FontWeight.w600, color: color)),
    );
  }

  Widget _squareAvatar(String? imageUrl, double size, {double radius = 8}) {
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(radius),
        color: Colors.grey.shade200,
        image: imageUrl != null && imageUrl.isNotEmpty
            ? DecorationImage(image: NetworkImage(imageUrl), fit: BoxFit.cover)
            : null,
      ),
      child: imageUrl == null || imageUrl.isEmpty
          ? Icon(Icons.person, size: size * 0.4, color: Colors.white70)
          : null,
    );
  }

  Widget _studentsTab(BuildContext context, ColorScheme cs) {
    final students = teacher.student ?? [];

    if (students.isEmpty) {
      return Center(
        child: Text(
          'No students assigned',
          style: TextStyle(
            fontSize: 14,
            color: cs.outline,
          ),
        ),
      );
    }

    return Column(
      children: [
        CustomWidgets().premiumSearch(
          context,
          hint: 'Search students...',
          onChanged: (p0) {},
        ),
        const SizedBox(height: 10),
        ListView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemCount: students.length,
          itemBuilder: (context, index) {
            final student = students[index];

            final packageCount = student.packages?.length ?? 0;

            return InkWell(
              onTap: () {
                showModalBottomSheet(
                  context: context,
                  isScrollControlled: true,
                  backgroundColor: Colors.transparent,
                  builder: (_) {
                    final packages = student.packages ?? [];

                    return Container(
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: cs.surface,
                        borderRadius: const BorderRadius.vertical(
                          top: Radius.circular(24),
                        ),
                      ),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          /// Handle
                          Center(
                            child: Container(
                              width: 50,
                              height: 5,
                              decoration: BoxDecoration(
                                color: cs.outline.withOpacity(0.3),
                                borderRadius: BorderRadius.circular(20),
                              ),
                            ),
                          ),

                          const SizedBox(height: 18),

                          /// Title
                          Text(
                            student.name,
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.w700,
                              color: cs.onSurface,
                            ),
                          ),

                          const SizedBox(height: 16),

                          /// Package List
                          packages.isEmpty
                              ? Center(
                                  child: Text(
                                    'No packages available',
                                    style: TextStyle(
                                      color: cs.outline,
                                    ),
                                  ),
                                )
                              : ListView.separated(
                                  shrinkWrap: true,
                                  itemCount: packages.length,
                                  separatorBuilder: (_, __) =>
                                      const SizedBox(height: 12),
                                  itemBuilder: (context, i) {
                                    final package = packages[i];

                                    return InkWell(
                                      onTap: () =>
                                          Get.to(() => TrPackageSessionPage(
                                                package: package,
                                              )),
                                      child: Container(
                                        padding: const EdgeInsets.all(14),
                                        decoration: BoxDecoration(
                                          color: cs.onPrimary,
                                          borderRadius:
                                              BorderRadius.circular(16),
                                          border: Border.all(
                                            color: cs.outline.withOpacity(0.25),
                                          ),
                                        ),
                                        child: Row(
                                          children: [
                                            Container(
                                              width: 48,
                                              height: 48,
                                              decoration: BoxDecoration(
                                                borderRadius:
                                                    BorderRadius.circular(12),
                                                color:
                                                    cs.primary.withOpacity(0.1),
                                              ),
                                              child: Icon(
                                                Icons.menu_book_rounded,
                                                color: cs.primary,
                                              ),
                                            ),
                                            const SizedBox(width: 14),
                                            Expanded(
                                              child: Column(
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.start,
                                                children: [
                                                  Text(
                                                    package.name ?? '-',
                                                    style: TextStyle(
                                                      fontSize: 15,
                                                      fontWeight:
                                                          FontWeight.w700,
                                                      color: cs.onSurface,
                                                    ),
                                                  ),
                                                  const SizedBox(height: 6),
                                                  Row(
                                                    children: [
                                                      Icon(
                                                        Icons.school_outlined,
                                                        size: 16,
                                                        color: cs.outline,
                                                      ),
                                                      const SizedBox(width: 4),
                                                      Text(
                                                        package.standard ?? '-',
                                                        style: TextStyle(
                                                          fontSize: 12,
                                                          color: cs.outline,
                                                        ),
                                                      ),
                                                      const SizedBox(width: 12),
                                                      Icon(
                                                        Icons.language_outlined,
                                                        size: 16,
                                                        color: cs.outline,
                                                      ),
                                                      const SizedBox(width: 4),
                                                      Expanded(
                                                        child: Text(
                                                          package.syllabus ??
                                                              '-',
                                                          overflow: TextOverflow
                                                              .ellipsis,
                                                          style: TextStyle(
                                                            fontSize: 12,
                                                            color: cs.outline,
                                                          ),
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                ],
                                              ),
                                            ),
                                            Icon(
                                              Icons.arrow_forward_ios_rounded,
                                              size: 16,
                                              color: cs.outline,
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
                  },
                );
              },
              borderRadius: BorderRadius.circular(14),
              child: Container(
                margin: const EdgeInsets.only(bottom: 12),
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: cs.onPrimary,
                  borderRadius: BorderRadius.circular(14),
                  border: Border.all(
                    color: cs.outline.withOpacity(0.5),
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: cs.shadow.withOpacity(0.04),
                      blurRadius: 10,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
                child: Row(
                  children: [
                    /// 🔹 Profile Image
                    Container(
                      width: 50,
                      height: 50,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(12),
                        color: cs.primary.withOpacity(0.08),
                        image: student.imageUrl != null &&
                                student.imageUrl!.isNotEmpty
                            ? DecorationImage(
                                image: NetworkImage(student.imageUrl!),
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

                    const SizedBox(width: 12),

                    /// 🔹 Student Details
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            student.name,
                            style: TextStyle(
                              fontSize: 15,
                              fontWeight: FontWeight.w700,
                              color: cs.onSurface,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            student.studentId ?? '-',
                            style: TextStyle(
                              fontSize: 12,
                              color: cs.outline,
                            ),
                          ),
                        ],
                      ),
                    ),

                    /// 🔹 Package Count
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 12,
                        vertical: 6,
                      ),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(20),
                        color: cs.primary.withOpacity(0.12),
                      ),
                      child: Text(
                        '$packageCount Packages',
                        style: TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.w600,
                          color: cs.primary,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            );
          },
        ),
      ],
    );
  }

  Widget _unlockButton(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    final c = Get.find<TeacherController>();

    return SizedBox(
      width: double.infinity,
      child: ElevatedButton.icon(
        onPressed: () {
          c.showUnlockForm.value = true;
        },
        icon: const Icon(Icons.add, size: 15, color: Colors.white),
        label: const Text(
          'Add Unlock',
          style: TextStyle(color: Colors.white, fontSize: 13),
        ),
        style: ElevatedButton.styleFrom(
          backgroundColor: cs.secondary,
          elevation: 0,
          padding: const EdgeInsets.symmetric(vertical: 14),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
        ),
      ),
    );
  }

  Widget _unlockForm(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    final c = Get.find<TeacherController>();
    final items = [
      {"id": "all", "name": "All Students"},
      ...c.students,
    ];
    final RxList<Map<String, dynamic>> selectedItems =
        <Map<String, dynamic>>[].obs;
    selectedItems.add({"id": "all", "name": "All Students"});

    return Obx(() {
      if (!c.showUnlockForm.value) return const SizedBox();

      return Container(
        margin: const EdgeInsets.only(top: 12),
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(14),
          border: Border.all(color: cs.outline.withOpacity(0.5)),
          color: cs.onPrimary,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              "New Unlock Window",
              style: TextStyle(fontWeight: FontWeight.w700),
            ),
            const SizedBox(height: 12),
            CustomWidgets().labelWithAsterisk('Unlock from', required: true),
            const SizedBox(height: 10),
            CustomWidgets().customDatePickerField(
                controller: c.startDateController,
                context: context,
                selectedDate: c.selectedFromDate),
            const SizedBox(height: 10),
            CustomWidgets().labelWithAsterisk('Unlock until', required: true),
            const SizedBox(height: 10),
            CustomWidgets().customDatePickerField(
                controller: c.endDateController,
                context: context,
                selectedDate: c.selectedUntilDate),
            const SizedBox(height: 10),
            CustomWidgets()
                .labelWithAsterisk('Re-lock After (hours) - optional'),
            const SizedBox(height: 10),
            CustomWidgets().dropdownStyledTextField(
              context: context,
              hint: "e.g. 24",
              isNumber: true,
              controller: c.relockController,
            ),
            const SizedBox(height: 10),
            CustomWidgets().labelWithAsterisk('Target Students'),
            const SizedBox(height: 10),
            _studentMultiSelect(context),
            const SizedBox(height: 14),
            Row(
              children: [
                Expanded(
                  child: ElevatedButton(
                    onPressed: () {
                      // TODO: grant access logic
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: cs.secondary,
                      padding: const EdgeInsets.symmetric(vertical: 12),
                    ),
                    child: const Text(
                      "Grant Access",
                      style: TextStyle(color: Colors.white),
                    ),
                  ),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: OutlinedButton(
                    onPressed: () {
                      c.showUnlockForm.value = false;
                    },
                    child: const Text("Cancel"),
                  ),
                ),
              ],
            ),
          ],
        ),
      );
    });
  }

  Widget _studentMultiSelect(BuildContext context) {
    final c = Get.find<TeacherController>();
    final cs = Theme.of(context).colorScheme;

    final students = [
      {"id": "STU001", "name": "Amina"},
      {"id": "STU002", "name": "Rayan"},
      {"id": "STU003", "name": "Sara"},
    ];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Obx(
              () => Checkbox(
                value: c.selectAllStudents.value,
                onChanged: (value) {
                  if (value == null) return;

                  c.selectAllStudents.value = value;

                  if (value) {
                    c.selectedStudents.assignAll(students);
                  } else {
                    c.selectedStudents.clear();
                  }
                },
                fillColor: WidgetStateProperty.resolveWith((states) {
                  if (states.contains(WidgetState.selected)) {
                    return cs.secondary.withOpacity(0.8);
                  }
                  return Colors.transparent;
                }),
                side: BorderSide(
                  color: cs.outline.withOpacity(0.5),
                  width: 1.2,
                ),
                checkColor: cs.onSurface,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(4),
                ),
              ),
            ),
            const SizedBox(width: 8),
            Text(
              'Select All Students',
              style: Theme.of(context).textTheme.bodyMedium,
            ),
          ],
        ),
        CustomWidgets().customMultiDropdownField<Map<String, dynamic>>(
          context: context,
          hint: 'Select Students (${students.length} available)',
          items: students,
          selectedItems: c.selectedStudents,
          itemLabel: (item) => item['name'] ?? '',
        ),
        const SizedBox(height: 10),
      ],
    );
  }

  Widget _accessCard(Map<String, dynamic> data, BuildContext context) {
    final cs = Theme.of(context).colorScheme;

    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: cs.onPrimary,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: cs.outline.withOpacity(.15)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            data['title'] ?? 'Temporary Access',
            style: const TextStyle(
              fontWeight: FontWeight.w700,
              fontSize: 14,
            ),
          ),
          const SizedBox(height: 6),
          Text(
            "From: ${data['from']}  →  To: ${data['to']}",
            style: TextStyle(
              fontSize: 12,
              color: cs.outline,
            ),
          ),
        ],
      ),
    );
  }
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
                style: TextStyle(
                    fontSize: 18, fontWeight: FontWeight.w900, color: color)),
          ),
        ),
        const SizedBox(width: 14),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(title,
                style: TextStyle(fontSize: 11, color: color.withOpacity(0.8))),
            const SizedBox(height: 3),
            Text(value,
                style: TextStyle(
                    fontSize: 18, fontWeight: FontWeight.w800, color: color)),
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
  final cs = Theme.of(context).colorScheme;
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

        const SizedBox(width: 14),

        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(role,
                  style: TextStyle(
                      fontSize: 11, fontWeight: FontWeight.w600, color: _blue)),
              const SizedBox(height: 2),
              Text(name,
                  style: const TextStyle(
                      fontSize: 14, fontWeight: FontWeight.w800)),
              const SizedBox(height: 3),
              Text('$id  •  $date',
                  style: TextStyle(fontSize: 11, color: cs.outline)),
            ],
          ),
        ),
      ],
    ),
  );
}
