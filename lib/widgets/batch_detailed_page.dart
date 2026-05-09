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

class BatchDetailsPage extends StatelessWidget {
  final Student student;
  final int initialIndex;

  BatchDetailsPage({
    super.key,
    required this.student,
    required this.initialIndex,
  });

  final c = Get.find<StudentController>();

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;

    return Scaffold(
      appBar: CustomAppBar(),
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
              onSubmit: (txn) {
                c.transactions.add(txn);
              },
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
                title: const Text('Create Certificate'),
                formKey: GlobalKey<FormState>(),
                sections: [
                  Obx(() {
                    if (c.step.value == 1) {
                      return Column(
                        children: [
                          CustomWidgets().labelWithAsterisk('Certificate Name',
                              required: true),
                          const SizedBox(height: 10),
                          CustomWidgets().dropdownStyledTextField(
                            context: context,
                            hint: 'Certificate of Completion',
                            controller: c.nameController,
                          ),
                          const SizedBox(height: 10),
                          CustomWidgets().labelWithAsterisk('Select Package',
                              required: true),
                          const SizedBox(height: 10),
                          CustomWidgets().customDropdownField<Package>(
                            context: context,
                            hint: 'Choose a package',
                            items: student.packages ?? [],
                            onChanged: (p0) {
                              c.selectedPackage.value = p0;
                            },
                            itemLabel: (item) => item.name ?? '',
                          ),
                        ],
                      );
                    }

                    return Column(
                      children: [
                        _optionCard(
                            title: 'Generate Certificate', onTap: () {}),
                        _optionCard(title: 'Upload Certificate', onTap: () {}),
                      ],
                    );
                  }),
                ],
                submitText: 'Continue',
                onSubmit: () {
                  final isValid = c.validate(context);
                  if (!isValid) return;

                  if (c.step.value == 1) {
                    Future.microtask(() {
                      c.step.value = 2;
                    });
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

        return const SizedBox();
      }),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Obx(
              () => CustomWidgets().customTabs(
                context,
                tabs: c.tabs,
                selectedIndex: c.selectedIndex.value,
                onTap: (index) {
                  c.selectedIndex.value = index;
                },
              ),
            ),
            const SizedBox(height: 16),
            Obx(() {
              final index = c.selectedIndex.value;
              final packages = student.packages ?? [];
              final assessments = student.assessment ?? [];

              if (c.tabs[index] == 'Profile') {
                return Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _profileCard(context),
                    const SizedBox(height: 16),
                    _sectionCard(
                      context: context,
                      title: 'Personal Information',
                      child: Column(
                        children: [
                          Divider(
                            height: 16,
                            thickness: 1,
                            color: cs.outline.withOpacity(0.15),
                          ),
                          _infoRow('Created By', student.createdBy ?? "-",
                              'Created At', 'Oct 10, 2024'),
                          const SizedBox(height: 12),
                          Row(
                            children: [
                              Icon(Icons.phone_outlined),
                              Column(
                                children: [
                                  Text('Mobile'),
                                  Text(student.phone ?? '-')
                                ],
                              )
                            ],
                          ),
                          const SizedBox(height: 12),
                          Row(
                            children: [
                              Icon(Icons.message_outlined),
                              Column(
                                children: [
                                  Text('Whatsapp'),
                                  Text(student.whatsapp ?? '-')
                                ],
                              )
                            ],
                          ),
                          Divider(
                            height: 16,
                            thickness: 0.8,
                            color: cs.outline.withOpacity(0.12),
                          ),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text('Parent Details'),
                              Text(student.parentName ?? '-'),
                              Text(student.parentOccupation ?? '-')
                            ],
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 16),
                    _sectionCard(
                      context: context,
                      title: 'Academic Details',
                      trailing: TextButton.icon(
                        onPressed: () {},
                        icon: const Icon(Icons.badge_outlined, size: 18),
                        label: const Text('View ID Card'),
                      ),
                      child: Column(
                        children: [
                          Divider(
                            height: 16,
                            thickness: 0.8,
                            color: cs.outline.withOpacity(0.12),
                          ),
                          _labelValue(
                              'Current Address', student.address ?? '-'),
                          const SizedBox(height: 12),
                          Divider(
                            height: 16,
                            thickness: 0.8,
                            color: cs.outline.withOpacity(0.12),
                          ),
                          Row(
                            children: [
                              Expanded(
                                  child: Column(children: [
                                Text('Category'),
                                Text(student.category ?? "-")
                              ])),
                              SizedBox(width: 12),
                              Expanded(
                                  child: Column(children: [
                                Text('Standard'),
                                Text(student.standard.toString())
                              ])),
                            ],
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 16),
                    Column(
                      children: [
                        _supportTile(
                          context,
                          'Coordinator',
                          student.coordinator?.name ?? '-',
                          student.coordinator?.id ?? '-',
                          'Oct 12, 2024',
                          imageUrl: student.coordinator?.imageUrl,
                        ),
                        SizedBox(height: 10),
                        _supportTile(
                          context,
                          'Mentor',
                          student.mentor?.name ?? "-",
                          student.mentor?.id ?? "-",
                          'Oct 15, 2024 - 02:30 PM',
                        ),
                        SizedBox(height: 10),
                        _supportTile(
                          context,
                          'Advisor',
                          student.advisorName ?? "-",
                          student.advisorId ?? "-",
                          'Oct 11, 2024 - 10:00 AM',
                        ),
                        SizedBox(height: 10),
                        _supportTile(
                          context,
                          'Referral',
                          student.referralName ?? "-",
                          '',
                          'Oct 05, 2024 - 09:00 AM',
                        ),
                      ],
                    )
                  ],
                );
              }

              if (c.tabs[index] == 'Packages') {
                if (packages.isEmpty) {
                  return const Center(
                    child: Text("No packages available"),
                  );
                }
                return Column(
                  children: [
                    CustomWidgets().premiumSearch(
                      context,
                      hint: 'Search by package name',
                      onChanged: (p0) {},
                    ),
                    const SizedBox(height: 10),
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton.icon(
                        onPressed: () {
                          final packages = student.packages ?? [];

                          double totalPackageAmount = 0;
                          double totalPaid = 0;
                          double totalHours = 0;
                          double totalTeacherSalary = 0;

                          for (var pkg in packages) {
                            totalPackageAmount += pkg.packageFee ?? 0;
                            totalPaid += pkg.takenFee ?? 0;
                            totalHours += pkg.sessionsCompleted ?? 0;
                            totalTeacherSalary += pkg.totalTeacherSalary;
                          }
                          CustomWidgets().showCustomDialog(
                            context: context,
                            title: Text(
                                'Package Summary (${packages.length} packages)'),
                            formKey: GlobalKey(),
                            isViewOnly: true,
                            onSubmit: () {},
                            sections: [
                              ListView.separated(
                                shrinkWrap: true,
                                physics: const NeverScrollableScrollPhysics(),
                                itemCount: 4,
                                separatorBuilder: (_, __) =>
                                    const SizedBox(height: 10),
                                itemBuilder: (context, index) {
                                  final items = [
                                    {
                                      "title": "Total Package",
                                      "value":
                                          "₹${totalPackageAmount.toStringAsFixed(0)}",
                                      "color": Colors.blue,
                                    },
                                    {
                                      "title": "Collected",
                                      "value":
                                          "₹${totalPaid.toStringAsFixed(0)}",
                                      "color": Colors.green,
                                    },
                                    {
                                      "title": "Total Hours",
                                      "value": totalHours.toStringAsFixed(0),
                                      "color": Colors.orange,
                                    },
                                    {
                                      "title": "Teacher Salary",
                                      "value":
                                          "₹${totalTeacherSalary.toStringAsFixed(0)}",
                                      "color": Colors.purple,
                                    },
                                  ];

                                  final item = items[index];

                                  return summaryCard(
                                    title: item["title"] as String,
                                    value: item["value"] as String,
                                    color: item["color"] as Color,
                                  );
                                },
                              ),
                            ],
                          );
                        },
                        iconAlignment: IconAlignment.end,
                        label: const Text(
                          'Package Summary',
                          style: TextStyle(color: Colors.white, fontSize: 13),
                        ),
                        style: ElevatedButton.styleFrom(
                          backgroundColor:
                              Theme.of(context).colorScheme.primary,
                          elevation: 0,
                          padding: const EdgeInsets.symmetric(vertical: 12),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 10),
                    ListView.builder(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      itemCount: packages.length,
                      itemBuilder: (context, index) {
                        final pkg = packages[index];
                        return studentPackageCard(context, pkg);
                      },
                    ),
                  ],
                );
              }

              if (c.tabs[index] == 'Batches') {
                return const Text("Batches UI here");
              }
              if (c.tabs[index] == 'Wallet') {
                return studentWalletTab(context, student, c);
              }
              if (c.tabs[index] == 'Batch Payments') {
                return const Text("Batches UI here");
              }
              if (c.tabs[index] == 'Assessments') {
                if (assessments.isEmpty) {
                  return const Center(
                    child: Text("No assessments available"),
                  );
                }
                return ListView.builder(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemCount: assessments.length,
                  itemBuilder: (context, index) {
                    final pkg = assessments[index];
                    return studentAssessmentCard(context, pkg);
                  },
                );
              }
              if (c.tabs[index] == 'Sessions') {
                if (packages.isEmpty) {
                  return const Center(
                    child: Text("No packages available"),
                  );
                }
                return Column(
                  children: [
                    CustomWidgets().premiumSearch(
                      context,
                      hint: 'Search by package name',
                      onChanged: (p0) {},
                    ),
                    const SizedBox(height: 10),
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton.icon(
                        onPressed: () {
                          final allSessions = student.packages
                                  ?.expand((pkg) => pkg.sessions ?? [])
                                  .toList() ??
                              [];

                          int totalActive = allSessions
                              .where((s) => s.status == 'active')
                              .length;

                          int totalUpcoming = allSessions
                              .where((s) => s.status == 'upcoming')
                              .length;

                          int totalPending = allSessions
                              .where((s) => s.status == 'pending')
                              .length;

                          int totalActionNeeded = allSessions
                              .where((s) => s.status == 'actionNeeded')
                              .length;

                          int totalCompleted = allSessions
                              .where((s) => s.status == 'completed')
                              .length;
                          CustomWidgets().showCustomDialog(
                            context: context,
                            title: Text(
                                'Session Summary (${allSessions.length} sessions)'),
                            formKey: GlobalKey(),
                            isViewOnly: true,
                            onSubmit: () {},
                            sections: [
                              ListView.separated(
                                shrinkWrap: true,
                                physics: const NeverScrollableScrollPhysics(),
                                itemCount: 5,
                                separatorBuilder: (_, __) =>
                                    const SizedBox(height: 10),
                                itemBuilder: (context, index) {
                                  final items = [
                                    {
                                      "title": "Active",
                                      "value": totalActive.toStringAsFixed(0),
                                      "color": Colors.blue,
                                    },
                                    {
                                      "title": "Upcoming",
                                      "value": totalUpcoming.toStringAsFixed(0),
                                      "color": Colors.green,
                                    },
                                    {
                                      "title": "Pending",
                                      "value": totalPending.toStringAsFixed(0),
                                      "color": Colors.orange,
                                    },
                                    {
                                      "title": "Action Needed",
                                      "value":
                                          totalActionNeeded.toStringAsFixed(0),
                                      "color": Colors.purple,
                                    },
                                    {
                                      "title": "Completed",
                                      "value":
                                          totalCompleted.toStringAsFixed(0),
                                      "color": Colors.grey,
                                    },
                                  ];

                                  final item = items[index];

                                  return summaryCard(
                                    title: item["title"] as String,
                                    value: item["value"] as String,
                                    color: item["color"] as Color,
                                  );
                                },
                              ),
                            ],
                          );
                        },
                        iconAlignment: IconAlignment.end,
                        label: const Text(
                          'Session Summary',
                          style: TextStyle(color: Colors.white, fontSize: 13),
                        ),
                        style: ElevatedButton.styleFrom(
                          backgroundColor:
                              Theme.of(context).colorScheme.primary,
                          elevation: 0,
                          padding: const EdgeInsets.symmetric(vertical: 12),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 10),
                    ListView.builder(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      itemCount: packages.length,
                      itemBuilder: (context, index) {
                        final pkg = packages[index];
                        return studentPackageSessionCard(context, pkg);
                      },
                    ),
                  ],
                );
              }
              if (c.tabs[index] == 'Feedbacks') {
                return Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    /// 🔹 Sub Tabs (Teacher / Mentor)
                    Obx(
                      () => CustomWidgets().customTabs(
                        context,
                        tabs: c.feedbackTabs,
                        selectedIndex: c.feedbackTabIndex.value,
                        onTap: (i) {
                          c.feedbackTabIndex.value = i;
                        },
                      ),
                    ),

                    const SizedBox(height: 12),

                    /// 🔹 Content
                    Obx(() {
                      final isTeacher = c.feedbackTabIndex.value == 0;

                      final feedbacks =
                          isTeacher ? c.teacherFeedbacks : c.mentorFeedbacks;

                      final label = isTeacher ? "teacher" : "mentor";

                      if (feedbacks.isEmpty) {
                        return EmptyState(
                          cs: Theme.of(context).colorScheme,
                          icon: Icons.feedback_outlined,
                          title: "No feedback from $label yet",
                          subtitle: "Feedback added by $label will appear here",
                        );
                      }

                      /// ✅ Feedback List
                      return ListView.separated(
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        itemCount: feedbacks.length,
                        separatorBuilder: (_, __) => const SizedBox(height: 10),
                        itemBuilder: (_, i) {
                          final f = feedbacks[i];

                          return feedbackCard(f, context);
                        },
                      );
                    }),
                  ],
                );
              }
              if (c.tabs[index] == 'Certificates') {
                final certificates = student.certificate ?? [];

                if (certificates.isEmpty) {
                  return Center(
                    child: Text(
                      'No certificates are available for this student',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 14,
                        color: Colors.grey,
                      ),
                    ),
                  );
                }

                return ListView.builder(
                  itemCount: certificates.length,
                  itemBuilder: (context, i) {
                    final cert = certificates[i];

                    return CertificateCard(cert: cert);
                  },
                );
              }

              return const SizedBox();
            }),
          ],
        ),
      ),
    );
  }

  Widget _optionCard({
    required String title,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          border: Border.all(color: Colors.grey.shade300),
          borderRadius: BorderRadius.circular(12),
        ),
        child: Row(
          children: [
            const Icon(Icons.description),
            const SizedBox(width: 12),
            Text(title),
          ],
        ),
      ),
    );
  }

  Widget buildCertificateSection(BuildContext context, Student student) {
    if (c.step.value == 1) {
      return Column(
        children: [
          CustomWidgets().labelWithAsterisk('Certificate Name', required: true),
          const SizedBox(height: 10),
          CustomWidgets().dropdownStyledTextField(
            context: context,
            hint: 'Certificate of Completion',
            controller: c.nameController,
          ),
          const SizedBox(height: 10),
          CustomWidgets().labelWithAsterisk('Select Package', required: true),
          const SizedBox(height: 10),
          CustomWidgets().customDropdownField<Package>(
            context: context,
            hint: 'Choose a package',
            items: student.packages ?? [],
            onChanged: (p0) => c.selectedPackage.value = p0,
            itemLabel: (item) => item.name ?? '',
          ),
        ],
      );
    }

    return Column(
      children: [
        _optionCard(title: 'Generate Certificate', onTap: () {}),
        _optionCard(title: 'Upload Certificate', onTap: () {}),
      ],
    );
  }

  Widget feedbackCard(Feedbacks f, BuildContext context) {
    final cs = Theme.of(context).colorScheme;

    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: cs.onPrimary,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: cs.outline.withOpacity(0.5)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // /// 👤 Name + Date
          // Row(
          //   mainAxisAlignment: MainAxisAlignment.spaceBetween,
          //   children: [
          //     Text(
          //       f. ?? '-',
          //       style: const TextStyle(fontWeight: FontWeight.w600),
          //     ),
          //     Text(
          //       formatDate(f.date),
          //       style: TextStyle(fontSize: 12, color: cs.outline),
          //     ),
          //   ],
          // ),

          // const SizedBox(height: 6),

          // /// 💬 Message
          // Text(
          //   f.message ?? '-',
          //   style: TextStyle(color: cs.onSurface),
          // ),
        ],
      ),
    );
  }

  Widget studentPackageCard(BuildContext context, Package package) {
    final cs = Theme.of(context).colorScheme;
    final totalSessions = student.totalSession ?? 0;
    final completedSessions = student.classesTaken ?? 0;

    final packageFee = package.packageFee ?? 0;
    final paidFee = package.takenFee ?? 0;
    final balance = package.balance ?? (packageFee - paidFee);
    final hourly = package.hourlyRate ?? 0;

    /// Teacher (fallback if not present)
    final teacherHourly = package.hourlyRate ?? 0;
    final expenseRatio = package.expenseRatio ?? 0;

    /// total teacher salary
    final totalTeacherSalary = (teacherHourly * (student.totalHour ?? 0));

    /// Avoid division by zero
    final sessionProgress =
        totalSessions == 0 ? 0.0 : completedSessions / totalSessions;

    final feeProgress = packageFee == 0 ? 0.0 : paidFee / packageFee;

    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: cs.outline.withOpacity(0.4)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          /// ================= HEADER =================
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              /// Package name + chip
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    package.name ?? '-',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 6),
                  Chip(
                    label: Text(
                      package?.status ?? '',
                      style: TextStyle(fontSize: 11),
                    ),
                    backgroundColor: (student.status == 'active')
                        ? Colors.green.withOpacity(0.12)
                        : cs.error.withOpacity(0.12),
                    visualDensity: VisualDensity.compact,
                  ),
                ],
              ),

              /// Menu
              PopupMenuButton<String>(
                icon: const Icon(Icons.more_vert),
                onSelected: (value) {},
                itemBuilder: (context) => [
                  const PopupMenuItem(
                    value: "edit",
                    child: Text("Edit"),
                  ),
                  const PopupMenuItem(
                    value: "delete",
                    child: Text("Delete"),
                  ),
                  const PopupMenuItem(
                    value: "refund",
                    child: Text("Request Refund"),
                  ),
                  const PopupMenuItem(
                    value: "deactivate",
                    child: Text("Deactivate"),
                  ),
                ],
              ),
            ],
          ),

          const SizedBox(height: 8),

          const Text(
            "Enrolled: 12 Oct 2024 • 10:30 AM",
            style: TextStyle(color: Colors.grey, fontSize: 12),
          ),

          const SizedBox(height: 12),
          Divider(
            height: 16,
            thickness: 1,
            color: cs.outline.withOpacity(0.15),
          ),

          /// ================= COURSE + TEACHER =================
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              /// Left: course info
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text("Standard: ${student.standard}"),
                    SizedBox(height: 4),
                    Text("Subject: ${package.subjectName ?? '-'}"),
                    SizedBox(height: 4),
                    Text("Course: ${student.course}"),
                  ],
                ),
              ),

              /// Right: teacher
              Row(
                children: [
                  CircleAvatar(
                    radius: 18,
                    backgroundImage: NetworkImage(
                      "https://i.pravatar.cc/150?img=3",
                    ),
                  ),
                  const SizedBox(width: 8),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        package.teacher?.name ?? '',
                        style: TextStyle(fontWeight: FontWeight.w600),
                      ),
                      Text(
                        package.teacher?.id ?? '',
                        style: TextStyle(fontSize: 12, color: Colors.grey),
                      ),
                    ],
                  ),
                ],
              ),
            ],
          ),

          const SizedBox(height: 12),
          Divider(
            height: 16,
            thickness: 1,
            color: cs.outline.withOpacity(0.15),
          ),

          /// ================= MODE / TIME / DURATION =================
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                children: [
                  Text("Mode"),
                  Text(package.mode ?? '-',
                      style: TextStyle(fontWeight: FontWeight.bold)),
                ],
              ),
              Column(
                children: [
                  Text("Time"),
                  Text(package.time ?? '-',
                      style: TextStyle(fontWeight: FontWeight.bold)),
                ],
              ),
              Column(
                children: [
                  Text("Duration"),
                  Text(package.duration ?? '-',
                      style: TextStyle(fontWeight: FontWeight.bold)),
                ],
              ),
            ],
          ),

          const SizedBox(height: 12),
          Divider(
            height: 16,
            thickness: 1,
            color: cs.outline.withOpacity(0.15),
          ),

          /// ================= PROGRESS =================
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                "Progress",
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 6),

              /// Progress bar (based on sessions)
              LinearProgressIndicator(
                value: sessionProgress.clamp(0.0, 1.0),
              ),

              const SizedBox(height: 8),

              /// Dynamic text
              Text(
                "Sessions: $completedSessions/$totalSessions • "
                "Hours: ${student.totalHour ?? 0} • "
                "Fee: ${(feeProgress * 100).toStringAsFixed(0)}%",
              ),
            ],
          ),
          const SizedBox(height: 12),

          /// Status toggle
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              /// 👇 Text can also react if status changes
              Obx(() => Text(
                    "Status: ${c.status.value}",
                  )),

              /// 👇 Switch must be inside Obx
              Obx(() => Switch(
                    value: c.isActive.value,
                    onChanged: (v) {
                      c.isActive.value = v;

                      // optional: update status text
                      c.status.value = v ? "Demo Completed" : "Demo Pending";
                    },
                  )),
            ],
          ),

          const SizedBox(height: 12),
          Divider(
            height: 16,
            thickness: 1,
            color: cs.outline.withOpacity(0.15),
          ),

          /// ================= TEACHER FEES =================
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                "Teacher Fees",
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 6),
              Text(
                  "Hourly Salary: ₹${(package.hourlyRate ?? 0).toStringAsFixed(0)}"),
              Text("Expense Ratio: ${(package.expenseRatio ?? 0)}%"),
              Text(
                  "Total Salary: ₹${package.totalTeacherSalary.toStringAsFixed(0)}"),
            ],
          ),

          const SizedBox(height: 12),
          Divider(
            height: 16,
            thickness: 1,
            color: cs.outline.withOpacity(0.15),
          ),

          /// ================= STUDENT FEES =================
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                "Student Fees",
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 6),
              Text("Hourly: ₹${hourly.toStringAsFixed(0)}"),
              Text("Package: ₹${packageFee.toStringAsFixed(0)}"),
              Text("Completed: ₹${paidFee.toStringAsFixed(0)}"),
              Text("Balance: ₹${balance.toStringAsFixed(0)}"),
            ],
          ),
        ],
      ),
    );
  }

  Widget studentPackageSessionCard(BuildContext context, Package package) {
    if ((package.name ?? '').trim().isEmpty) {
      return const SizedBox();
    }
    final cs = Theme.of(context).colorScheme;

    final totalSessions = package.sessions?.length ?? 0;

    return InkWell(
      onTap: () => Get.to(PackageSessionPage(), arguments: package),
      child: Container(
        margin: const EdgeInsets.only(bottom: 12),
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: cs.onPrimary,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: cs.outline.withOpacity(0.5)),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            /// 📦 Package Name
            Expanded(
              child: Text(
                package.name ?? '-',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  color: cs.onSurface,
                ),
              ),
            ),

            /// 🔢 Session Count
            Container(
              padding: const EdgeInsets.symmetric(
                horizontal: 10,
                vertical: 6,
              ),
              decoration: BoxDecoration(
                color: cs.primary.withOpacity(0.1),
                borderRadius: BorderRadius.circular(20),
              ),
              child: Text(
                '$totalSessions Sessions',
                style: TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.w500,
                  color: cs.primary,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget studentAssessmentCard(BuildContext context, Assessment assessment) {
    final cs = Theme.of(context).colorScheme;

    return InkWell(
      onTap: () {
        DialogUtils().showAssessmentDialog(context, assessment);
      },
      child: Container(
        margin: const EdgeInsets.only(bottom: 16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: cs.outline.withOpacity(0.4)),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            /// 🔷 HEADER
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 16, 8, 8),
              child: Row(
                children: [
                  Expanded(
                    child: Text(
                      assessment.type ?? "Assessment",
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  IconButton(
                    icon: const Icon(Icons.edit, size: 18),
                    onPressed: () {},
                  ),
                  IconButton(
                    icon: Icon(Icons.delete, size: 18, color: cs.error),
                    onPressed: () {},
                  ),
                ],
              ),
            ),

            /// 🔷 DATE & TIME STRIP (fills space nicely)
            Container(
              width: double.infinity,
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              decoration: BoxDecoration(
                color: cs.primary.withOpacity(0.05),
                borderRadius: const BorderRadius.vertical(
                  bottom: Radius.circular(16),
                ),
              ),
              child: Row(
                children: [
                  /// 📅 Date
                  Row(
                    children: [
                      Icon(Icons.calendar_today, size: 16, color: cs.primary),
                      const SizedBox(width: 6),
                      Text(
                        assessment.date ?? "-",
                        style: const TextStyle(
                          fontSize: 13,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(width: 20),

                  /// ⏰ Time
                  Row(
                    children: [
                      Icon(Icons.schedule, size: 16, color: cs.primary),
                      const SizedBox(width: 6),
                      const Text(
                        "10:30 AM",
                        style: TextStyle(
                          fontSize: 13,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _profileCard(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: cs.onPrimary,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: cs.outline.withOpacity(0.5),
          width: 1,
        ),
      ),
      child: Column(
        children: [
          Container(
            width: 60,
            height: 60,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(8),
              color: Colors.grey.shade300,
              image: student.imageUrl != null
                  ? DecorationImage(
                      image: NetworkImage(student.imageUrl ?? ''),
                      fit: BoxFit.cover,
                    )
                  : null,
            ),
            child: student.imageUrl == null
                ? const Icon(Icons.person, size: 30, color: Colors.white70)
                : null,
          ),
          const SizedBox(height: 10),
          Text(student.name,
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
          Text(student.email ?? '-', style: TextStyle(color: Colors.grey)),
          const SizedBox(height: 8),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
            decoration: BoxDecoration(
              color: Colors.blue.shade50,
              borderRadius: BorderRadius.circular(8),
            ),
            child: Text('ID:${student.studentId} '),
          ),
          const SizedBox(height: 8),
          Chip(
            avatar: Icon(
              student.isFeePaid ? Icons.task_alt : Icons.cancel_outlined,
              size: 18,
              color: student.isFeePaid ? Colors.green : cs.error,
            ),
            label: Text(
              student.isFeePaid ? 'Admission Fee Paid' : 'Admission Fee Unpaid',
              style: TextStyle(
                fontSize: 11,
                fontWeight: FontWeight.w500,
                color: student.isFeePaid ? Colors.green : cs.error,
              ),
            ),
            backgroundColor: student.isFeePaid
                ? Colors.green.withOpacity(0.12)
                : cs.error.withOpacity(0.12),
            shape: StadiumBorder(
              side: BorderSide(
                color: student.isFeePaid
                    ? Colors.green.withOpacity(0.8)
                    : cs.error.withOpacity(0.8),
                width: 0.5,
              ),
            ),
          ),
          const SizedBox(height: 10),
          SizedBox(
            width: double.infinity,
            child: ElevatedButton.icon(
              onPressed: () {},
              icon: const Icon(Icons.arrow_right_alt,
                  size: 15, color: Colors.white),
              iconAlignment: IconAlignment.end,
              label: const Text(
                'Go to Dashboard',
                style: TextStyle(color: Colors.white, fontSize: 13),
              ),
              style: ElevatedButton.styleFrom(
                backgroundColor: Theme.of(context).colorScheme.primary,
                elevation: 0,
                padding: const EdgeInsets.symmetric(vertical: 12),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _sectionCard(
      {required String title,
      required BuildContext context,
      required Widget child,
      Widget? trailing}) {
    final cs = Theme.of(context).colorScheme;
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: cs.outline.withOpacity(0.6))),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(title,
                  style: const TextStyle(
                      fontSize: 16, fontWeight: FontWeight.bold)),
              if (trailing != null) trailing,
            ],
          ),
          const SizedBox(height: 12),
          child,
        ],
      ),
    );
  }

  Widget _infoRow(String l1, String v1, String l2, String v2) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Text(l1),
          Text(v1, style: const TextStyle(fontWeight: FontWeight.bold))
        ]),
        Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Text(l2),
          Text(v2, style: const TextStyle(fontWeight: FontWeight.bold))
        ]),
      ],
    );
  }

  Widget CertificateCard({required cert}) {
    return SizedBox(); //TODO
  }
}

Widget _labelValue(String label, String value) {
  return Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      Text(label, style: const TextStyle(color: Colors.grey)),
      Text(value, style: const TextStyle(fontWeight: FontWeight.bold)),
    ],
  );
}

Widget summaryCard({
  required String title,
  required String value,
  required Color color,
}) {
  return Container(
    padding: const EdgeInsets.all(14),
    decoration: BoxDecoration(
      color: color.withOpacity(0.08),
      borderRadius: BorderRadius.circular(12),
      border: Border.all(
        color: color.withOpacity(0.4),
        width: 0.8,
      ),
    ),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: TextStyle(
            fontSize: 12,
            color: color,
          ),
        ),
        const SizedBox(height: 6),
        Text(
          value,
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
            color: color,
          ),
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
  return Container(
    padding: const EdgeInsets.all(12),
    decoration: BoxDecoration(
      color: Theme.of(context).colorScheme.onPrimary,
      border: Border.all(color: Colors.grey.shade200),
      borderRadius: BorderRadius.circular(12),
    ),
    child: Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Square profile image
        Container(
          width: 60,
          height: 60,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(8),
            color: Colors.grey.shade300,
            image: imageUrl != null
                ? DecorationImage(
                    image: NetworkImage(imageUrl),
                    fit: BoxFit.cover,
                  )
                : null,
          ),
          child: imageUrl == null
              ? const Icon(Icons.person, size: 30, color: Colors.white70)
              : null,
        ),

        const SizedBox(width: 12),

        // Text content
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Line 1: Role
              Text(
                role,
                style: const TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.w600,
                  color: Colors.grey,
                ),
              ),

              const SizedBox(height: 4),

              // Line 2: Name
              Text(
                name,
                style: const TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.bold,
                ),
              ),

              const SizedBox(height: 4),

              // Line 3: ID + Date
              Text(
                "$id • $date",
                style: TextStyle(
                  fontSize: 12,
                  color: Colors.grey.shade600,
                ),
              ),
            ],
          ),
        ),
      ],
    ),
  );
}
