import 'package:albedo_app/config/root.dart';
import 'package:albedo_app/controller/auth_controller.dart';
import 'package:albedo_app/controller/coordinator_controller.dart';
import 'package:albedo_app/controller/mentor_controller.dart';
import 'package:albedo_app/controller/teacher_controller.dart';
import 'package:albedo_app/controller/teacher_wallet_controller.dart';
import 'package:albedo_app/model/batch_model.dart';
import 'package:albedo_app/model/package_model.dart';
import 'package:albedo_app/model/users/coordinator_model.dart';
import 'package:albedo_app/model/users/mentor_model.dart';
import 'package:albedo_app/model/users/teacher_model.dart';
import 'package:albedo_app/view/mentor_detailed_page.dart';
import 'package:albedo_app/view/teacher/add_wallet_page.dart';
import 'package:albedo_app/view/teacher/tr_package_session_page.dart';
import 'package:albedo_app/view/teacher/tr_wallet_tab.dart';
import 'package:albedo_app/widgets/custom_appbar.dart';
import 'package:albedo_app/widgets/session_widgets.dart';
import 'package:albedo_app/widgets/widgets.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

const _blue = Color(0xFF058DCE);

class CoordinatorDetailedPage extends StatelessWidget {
  final Coordinator coordinator;
  final int initialIndex;

  CoordinatorDetailedPage({
    super.key,
    required this.coordinator,
    required this.initialIndex,
  });

  final c = Get.find<CoordinatorController>();

  @override
  Widget build(BuildContext context) {
    final cs = Get.theme.colorScheme;

    return Scaffold(
      appBar: CustomAppBar(),
      // ── FAB ────────────────────────────────────
      floatingActionButton: Obx(() {
        final index = c.selectedIndex.value;

        if (c.detailedTabs[index] == 'Mentors') {
          return FloatingActionButton(
            mini: true,
            onPressed: () {},
            backgroundColor: context.theme.colorScheme.primary,
            child: Icon(
              Icons.add,
              color: context.theme.colorScheme.onPrimary,
            ),
          );
        }
        if (c.detailedTabs[index] == 'Wallet') {
          return FloatingActionButton(
            mini: true,
            onPressed: () => Get.to(() => AddWalletPage(
                  coordinator: coordinator,
                  showAdjustment: false,
                )),
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
            // ── Tabs ───────────────────────────────
            Obx(() => CustomWidgets().customTabs(
                  context,
                  tabs: c.detailedTabs,
                  selectedIndex: c.selectedIndex.value,
                  onTap: (index) => c.selectedIndex.value = index,
                )),
            SizedBox(height: 16),

            // ── Tab bodies  ──────────────────────────
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
              // ─── MENTORS  ───────────────────────────────────
              if (c.detailedTabs[index] == 'Mentors') {
                return _mentorsTab(context, cs);
              }

              // ─── WALLET ────────────────────────────────────
              if (c.detailedTabs[index] == 'Wallet') {
                return walletTab(context,
                    coordinator: coordinator,
                    coordinatorController: c,
                    wallet: walletController);
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
                    SizedBox(height: 12),
                    _unlockButton(context),
                    _unlockForm(context),
                  ],
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
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  _contactRow(context, Icons.phone_outlined, 'Mobile',
                      coordinator.phone ?? '-'),
                  SizedBox(height: 10),
                  _contactRow(context, Icons.chat_bubble_outline, 'WhatsApp',
                      coordinator.whatsapp ?? '-'),
                ],
              ),
              _divider(cs),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  _contactRow(
                      context, Icons.place, 'Place', coordinator.place ?? "-"),
                  SizedBox(height: 10),
                  _contactRow(context, Icons.calendar_today_outlined,
                      'Date Of Birth', coordinator.dob ?? "-"),
                ],
              ),
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
              _cardHeader(context, 'Payment Details', icon: Icons.payment),
              _divider(cs),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('UPI ID',
                      style: Get.textTheme
                          .titleSmall!
                          .copyWith(color: cs.outline)),
                  SizedBox(height: 4),
                  Text(coordinator.upiId ?? '-',
                      style: Get.textTheme.titleSmall),
                  SizedBox(height: 8),
                  Text('Account No.',
                      style: Get.textTheme
                          .titleSmall!
                          .copyWith(color: cs.outline)),
                  SizedBox(height: 4),
                  Text(coordinator.accountNumber ?? '-',
                      style: Get.textTheme.titleSmall),
                  SizedBox(height: 8),
                  Text('IFSC Code',
                      style: Get.textTheme
                          .titleSmall!
                          .copyWith(color: cs.outline)),
                  SizedBox(height: 4),
                  Text(coordinator.ifscCode ?? '-',
                      style: Get.textTheme.titleSmall),
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
    final experiences = coordinator.experience ?? [];

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
    final experienceText = '$totalYears Years $totalMonths Months';

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

              SizedBox(height: 14),

              /// Qualification + Experience
              Row(
                children: [
                  Expanded(
                    child: _infoTile(
                      context,
                      title: 'Qualification',
                      value: coordinator.qualification ?? '-',
                      icon: Icons.school_outlined,
                    ),
                  ),
                  SizedBox(width: 12),
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

              SizedBox(height: 14),

              /// Preferred Language
              _infoTile(
                context,
                title: 'Preferred Language',
                value: coordinator.prefLanguage ?? '-',
                icon: Icons.language_outlined,
              ),

              SizedBox(height: 14),

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
                      style: Get.textTheme
                          .titleSmall!
                          .copyWith(color: cs.onSurface),
                    ),
                    SizedBox(height: 10),
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        if ((coordinator.experience ?? []).isEmpty)
                          Text(
                            'No work experience added',
                            style: Get.textTheme
                                .bodySmall!
                                .copyWith(color: cs.outline),
                          )
                        else
                          Column(
                            children: (coordinator.experience ?? []).map((exp) {
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
                                    SizedBox(width: 10),
                                    SizedBox(
                                      width: MediaQuery.of(context).size.width *
                                          0.6,
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            exp.companyName ?? '-',
                                            style: Get.textTheme
                                                .titleSmall!
                                                .copyWith(color: cs.onSurface),
                                          ),
                                          SizedBox(height: 2),
                                          Text(
                                            '${exp.years ?? 0} Years ${exp.months ?? 0} Months',
                                            style: Get.textTheme
                                                .labelSmall!
                                                .copyWith(color: cs.outline),
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
        SizedBox(height: 10),
        SizedBox(
          width: double.infinity,
          child: ElevatedButton.icon(
            onPressed: () {},
            icon: const Icon(Icons.perm_identity_rounded,
                size: 15, color: Colors.white),
            label: Text('ID Card',
                style: Get.textTheme
                    .bodySmall!
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
    );
  }

  Widget _infoTile(
    BuildContext context, {
    required String title,
    required String value,
    required IconData icon,
  }) {
    final cs = Get.theme.colorScheme;

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
          SizedBox(width: 10),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: Get.textTheme
                      .titleSmall!
                      .copyWith(color: cs.outline),
                ),
                SizedBox(height: 2),
                Text(
                  value,
                  style: Get.textTheme
                      .titleSmall!
                      .copyWith(color: cs.onSurface),
                ),
              ],
            ),
          ),
        ],
      ),
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
                    child: _squareAvatar(coordinator.imageUrl, 64, radius: 12),
                  ),
                ),

                Transform.translate(
                  offset: const Offset(0, -20),
                  child: Column(
                    children: [
                      Text(coordinator.name,
                          style: Get.textTheme.titleLarge),
                      SizedBox(height: 4),
                      Text(coordinator.email ?? '-',
                          style: Get.textTheme
                              .bodySmall!
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
                        child: Text('ID: ${coordinator.id}',
                            style: Get.textTheme
                                .titleSmall!
                                .copyWith(color: _blue)),
                      ),

                      SizedBox(height: 12),

                      // Dashboard button
                      SizedBox(
                        width: double.infinity,
                        child: ElevatedButton.icon(
                          onPressed: () {
                            final auth = Get.find<AuthController>();
                            final user = coordinatorToUser(coordinator);

                            auth.startImpersonation(user);
                            Get.offAll(() => const Root());
                          },
                          icon: const Icon(Icons.arrow_right_alt,
                              size: 15, color: Colors.white),
                          iconAlignment: IconAlignment.end,
                          label: Text('Go to Dashboard',
                              style: Get.textTheme
                                  .bodySmall!
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

  Widget _mentorsTab(BuildContext context, ColorScheme cs) {
    final mentors = coordinator.mentor ?? [];

    if (mentors.isEmpty) {
      return EmptyState(
          cs: cs,
          title: 'No mentors assigned',
          subtitle: '',
          icon: Icons.group);
    }

    return Column(
      children: [
        CustomWidgets().premiumSearch(
          context,
          hint: 'Search mentors...',
          onChanged: (p0) {},
        ),
        SizedBox(height: 10),
        ListView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemCount: mentors.length,
          itemBuilder: (context, index) {
            final mentor = mentors[index];

            return InkWell(
              onTap: () => Get.to(
                  () => MentorDetailsPage(mentor: mentor, initialIndex: index)),
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
                        image: mentor.imageUrl != null &&
                                mentor.imageUrl!.isNotEmpty
                            ? DecorationImage(
                                image: NetworkImage(mentor.imageUrl!),
                                fit: BoxFit.cover,
                              )
                            : null,
                      ),
                      child:
                          (mentor.imageUrl == null || mentor.imageUrl!.isEmpty)
                              ? Icon(
                                  Icons.person_outline,
                                  color: cs.primary,
                                  size: 24,
                                )
                              : null,
                    ),

                    SizedBox(width: 12),

                    /// 🔹 Student Details
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            mentor.name,
                            style: Get.textTheme
                                .titleMedium!
                                .copyWith(color: cs.onSurface),
                          ),
                          SizedBox(height: 4),
                          Text(
                            mentor.empId ?? '-',
                            style: Get.textTheme
                                .bodySmall!
                                .copyWith(color: cs.outline),
                          ),
                        ],
                      ),
                    ),
                    Align(
                      alignment: Alignment.centerRight,
                      child: IconButton(
                        onPressed: () => CustomWidgets().showDeleteDialog(
                          title: 'Confirm Action',
                          context: context,
                          text:
                              'Are you sure you want to unassign this mentor?',
                          onConfirm: () {},
                        ),
                        icon: Icon(
                          Icons.delete_outline,
                          color: Colors.red,
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
    final cs = Get.theme.colorScheme;
    final c = Get.find<MentorController>();

    return SizedBox(
      width: double.infinity,
      child: ElevatedButton.icon(
        onPressed: () {
          c.showUnlockForm.value = true;
        },
        icon: const Icon(Icons.add, size: 15, color: Colors.white),
        label: Text(
          'Add Unlock',
          style: Get.textTheme
              .bodySmall!
              .copyWith(color: Colors.white),
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
    final cs = Get.theme.colorScheme;
    final c = Get.find<MentorController>();
    final RxList<Map<String, dynamic>> selectedItems =
        <Map<String, dynamic>>[].obs;
    selectedItems.add({"id": "all", "name": "All Students"});

    return Obx(() {
      if (!c.showUnlockForm.value) return SizedBox();

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
            Text(
              "New Unlock Window",
              style: Get.textTheme.titleSmall,
            ),
            SizedBox(height: 12),
            CustomWidgets().labelWithAsterisk('Unlock from', required: true),
            SizedBox(height: 10),
            CustomWidgets().customDatePickerField(
                controller: c.startDateController,
                context: context,
                selectedDate: c.selectedFromDate),
            SizedBox(height: 10),
            CustomWidgets().labelWithAsterisk('Unlock until', required: true),
            SizedBox(height: 10),
            CustomWidgets().customDatePickerField(
                controller: c.endDateController,
                context: context,
                selectedDate: c.selectedUntilDate),
            SizedBox(height: 10),
            CustomWidgets()
                .labelWithAsterisk('Re-lock After (hours) - optional'),
            SizedBox(height: 10),
            CustomWidgets().dropdownStyledTextField(
              context: context,
              hint: "e.g. 24",
              isNumber: true,
              controller: c.relockController,
            ),
            SizedBox(height: 10),
            CustomWidgets().labelWithAsterisk('Target Students'),
            SizedBox(height: 10),
            _studentMultiSelect(context),
            SizedBox(height: 14),
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
                    child: Text(
                      "Grant Access",
                      style: Get.textTheme
                          .bodyMedium!
                          .copyWith(color: Colors.white),
                    ),
                  ),
                ),
                SizedBox(width: 10),
                Expanded(
                  child: OutlinedButton(
                    onPressed: () {
                      c.showUnlockForm.value = false;
                    },
                    child: Text("Cancel"),
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
    final c = Get.find<MentorController>();
    final cs = Get.theme.colorScheme;

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
            SizedBox(width: 8),
            Text(
              'Select All Students',
              style: Get.textTheme.bodyMedium,
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
        SizedBox(height: 10),
      ],
    );
  }

  Widget _accessCard(Map<String, dynamic> data, BuildContext context) {
    final cs = Get.theme.colorScheme;

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
            style: Get.textTheme.titleSmall,
          ),
          SizedBox(height: 6),
          Text(
            "From: ${data['from']}  →  To: ${data['to']}",
            style: Get.textTheme
                .bodySmall!
                .copyWith(color: cs.outline),
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
