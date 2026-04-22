import 'package:albedo_app/config/root.dart';
import 'package:albedo_app/controller/auth_controller.dart';
import 'package:albedo_app/controller/session_controller.dart';
import 'package:albedo_app/model/session_model.dart';
import 'package:albedo_app/model/users/mentor_model.dart';
import 'package:albedo_app/model/users/student_model.dart';
import 'package:albedo_app/model/users/teacher_model.dart';
import 'package:albedo_app/widgets/responsive.dart';
import 'package:albedo_app/widgets/widgets.dart';
import 'package:albedo_app/widgets/custom_appbar.dart';
import 'package:albedo_app/widgets/custom_card.dart';
import 'package:albedo_app/widgets/drawer_menu.dart';
import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:get/get.dart';

extension TextThemeExt on BuildContext {
  TextTheme get tt => Theme.of(this).textTheme;
}

class SessionPage extends StatelessWidget {
  final c = Get.put(SessionController());

  SessionPage({super.key});

  @override
  Widget build(BuildContext context) {
    final isDesktop = Responsive.isDesktop(context);

    return Scaffold(
      appBar: const CustomAppBar(),
      backgroundColor: Theme.of(context).colorScheme.onPrimary,
      drawer: isDesktop ? null : const DrawerMenu(),
      floatingActionButton: addSessionBtn(context),
      body: Row(
        children: [
          if (isDesktop) const DrawerMenu(),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                children: [
                  _topBar(context, c),
                  const SizedBox(height: 12),
                  Obx(
                    () => CustomWidgets().customTabs(context,
                        tabs: c.tabs,
                        selectedIndex: c.selectedTab.value,
                        getCount: (index) => c.sessions
                            .where((e) => e.status == c.statusMap[index])
                            .length,
                        onTap: (index) {
                          c.selectedTab.value = index;
                          c.applyFilters();
                        }),
                  ),
                  const SizedBox(height: 12),
                  Expanded(
                    child: Obx(() {
                      final data = c.filteredSessions;
                      int crossAxisCount = 1;

                      if (c.isLoading.value) {
                        return const Center(child: CircularProgressIndicator());
                      }
                      if (data.isEmpty) {
                        return Center(
                            child: Text(
                          "No sessions found",
                          style: context.tt.bodyMedium,
                        ));
                      }

                      if (Responsive.isTablet(context)) {
                        crossAxisCount = 2;
                      } else if (Responsive.isDesktop(context)) {
                        crossAxisCount = 3;
                      }

                      return LayoutBuilder(
                        builder: (context, constraints) {
                          int crossAxisCount = 1;

                          if (constraints.maxWidth > 1200) {
                            crossAxisCount = 3;
                          } else if (constraints.maxWidth > 700) {
                            crossAxisCount = 2;
                          }

                          return MasonryGridView.count(
                            padding: const EdgeInsets.all(12),
                            crossAxisCount: crossAxisCount,
                            mainAxisSpacing: 12,
                            crossAxisSpacing: 12,
                            itemCount: data.length,
                            itemBuilder: (_, i) => InkWell(
                              onTap: () =>
                                  _openSessionDetails(context, data[i]),
                              child: InfoCard(
                                id: data[i].id,
                                status: data[i].status,
                                statusColor:
                                    getStatusColor(context, data[i].status),
                                infoRows: [
                                  _buildPersonSection(context, data[i]),
                                  _buildDetailsSection(context, data[i]),
                                ],
                                actions: [
                                  if (data[i].status != 'completed' &&
                                      data[i].status != 'meet_done')
                                    CustomWidgets().iconBtn(
                                        icon: Icons.edit,
                                        color: Theme.of(context)
                                            .colorScheme
                                            .primary,
                                        onTap: () {
                                          final session = data[i];

                                          c.loadSession(session);

                                          editSession(context);
                                        }),
                                  if ((data[i].status != 'completed') &&
                                      (data[i].status != 'meet_done'))
                                    CustomWidgets().iconBtn(
                                      icon: Icons.delete,
                                      color:
                                          Theme.of(context).colorScheme.error,
                                      onTap: () =>
                                          CustomWidgets().showDeleteDialog(
                                        text:
                                            'Are you sure you want to delete this session permanently?',
                                        context: context,
                                        onConfirm: () => c.delete(data[i].id),
                                      ),
                                    ),
                                ],
                              ),
                            ),
                          );
                        },
                      );
                    }),
                  )
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _openSessionDetails(BuildContext context, Session data) {
    CustomWidgets().showCustomDialog(
      context: context,
      title: const Text("Session Details"),
      icon: Icons.visibility,
      formKey: GlobalKey<FormState>(),
      submitText: "Close",
      onSubmit: () {},
      sections: [
        SizedBox(
          height: MediaQuery.of(context).size.height * 0.5,
          child: SingleChildScrollView(
            child: Column(
              children: [
                _detailCard(
                  context,
                  title: "Student",
                  name: data.studentName,
                  id: data.studentId,
                  onTap: () => _onUserTap(context, "student", data.studentId),
                ),
                _detailCard(
                  context,
                  title: "Teacher",
                  name: data.teacherName,
                  id: data.teacherId,
                  onTap: () => _onUserTap(context, "teacher", data.teacherId),
                ),
                _detailCard(
                  context,
                  title: "Mentor",
                  name: data.mentorName ?? "-",
                  id: data.mentorId ?? "-",
                  onTap: () => _onUserTap(context, "mentor", data.mentorId),
                ),
                _detailCard(
                  context,
                  title: "Coordinator",
                  name: data.coordinatorName ?? "-",
                  id: data.coordinatorId ?? "-",
                  onTap: () =>
                      _onUserTap(context, "coordinator", data.coordinatorId),
                ),
                _detailCard(
                  context,
                  title: "Advisor",
                  name: data.advisorName ?? "-",
                  id: data.advisorId ?? "-",
                  onTap: () => _onUserTap(context, "advisor", data.advisorId),
                ),
                const SizedBox(height: 10),
                _infoCard(
                  context,
                  type: "schedule",
                  icon: Icons.schedule,
                  title: "Schedule",
                  children: [
                    _infoRow("Date", _formatDate(data.date)),
                    _infoRow("Time", _formatTime(data.time)),
                    _infoRow("Duration", data.duration?.toString() ?? "-"),
                  ],
                ),
                _infoCard(
                  context,
                  type: "session",
                  icon: Icons.menu_book,
                  title: "Session Info",
                  children: [
                    _infoRow("Subject", data.package ?? "-"),
                    _infoRow("Syllabus", data.syllabus ?? "-"),
                  ],
                ),
                _infoCard(
                  context,
                  type: "status",
                  icon: Icons.flag,
                  title: "Status",
                  children: [
                    _infoRow("Current Status", data.status),
                  ],
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _detailCard(
    BuildContext context, {
    required String title,
    required String name,
    required String id,
    required VoidCallback onTap,
    String? Function()? getImageUrl,
  }) {
    final color = _getRoleColor(context, title.toLowerCase());
    final imageUrl = getImageUrl?.call();

    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(14),
      child: Container(
        margin: const EdgeInsets.only(bottom: 10),
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
          color: color.withOpacity(0.08),
          borderRadius: BorderRadius.circular(14),
          border: Border.all(color: color.withOpacity(0.2)),
        ),
        child: Row(
          children: [
            CircleAvatar(
                radius: 18,
                // backgroundColor: color.withOpacity(0.15),
                child: imageUrl == null
                    ? Image.asset('assets/images/logo.png')
                    : null),
            const SizedBox(width: 10),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: context.tt.labelSmall?.copyWith(color: color),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    name,
                    style: context.tt.titleMedium,
                  ),
                  Text(
                    id,
                    style: context.tt.labelSmall?.copyWith(color: color),
                  ),
                ],
              ),
            ),
            Icon(Icons.arrow_forward_ios, size: 14, color: color),
          ],
        ),
      ),
    );
  }

  Widget _infoCard(
    BuildContext context, {
    required String type, // 🔥 NEW
    required IconData icon,
    required String title,
    required List<Widget> children,
  }) {
    final color = _getRoleColor(context, type);

    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: color.withOpacity(0.08),
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: color.withOpacity(0.2)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(icon, size: 16, color: color),
              const SizedBox(width: 6),
              Text(
                title,
                style: context.tt.titleSmall?.copyWith(
                  color: color,
                ),
              ),
            ],
          ),
          const SizedBox(height: 10),
          ...children,
        ],
      ),
    );
  }

  Color _getRoleColor(BuildContext context, String role) {
    final cs = Theme.of(context).colorScheme;

    switch (role) {
      case "student":
        return cs.primary;
      case "teacher":
        return cs.secondary;
      case "mentor":
        return Colors.indigo;
      case "coordinator":
        return Colors.orange;
      case "advisor":
        return Colors.teal;
      case "schedule":
        return Colors.blue;
      case "session":
        return Colors.deepPurple;
      case "status":
        return Colors.green;
      default:
        return cs.primary;
    }
  }

  Widget _infoRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 6),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label, style: const TextStyle(fontSize: 12)),
          Text(value,
              style:
                  const TextStyle(fontWeight: FontWeight.w500, fontSize: 12)),
        ],
      ),
    );
  }

  void _onUserTap(BuildContext context, String role, String? id) {
    if (id == null || id == "-") return;

    if (role == "student") {
      final student = c.getStudentById(id);

      if (student == null) {
        Get.snackbar("Error", "Student not found");
        return;
      }

      _openStudentProfile(context, student);
    } else if (role == 'teacher') {
      final teacher = c.getTeacherById(id);
      print("Searching for teacherId: $id");
      print("Available IDs: ${c.teacherList.map((e) => e.id).toList()}");

      if (teacher == null) {
        Get.snackbar("Error", "Teacher not found");
        return;
      }

      _openTeacherProfile(context, teacher);
    } else if (role == 'mentor') {
      final mentor = c.getMentorById(id);
      print("Searching for teacherId: $id");
      print("Available IDs: ${c.teacherList.map((e) => e.id).toList()}");

      if (mentor == null) {
        Get.snackbar("Error", "Teacher not found");
        return;
      }

      _openMentorProfile(context, mentor);
    }
  }

  void _openStudentProfile(BuildContext context, Student data) {
    final color = _getRoleColor(context, "student");

    CustomWidgets().showCustomDialog(
      context: context,
      title: Text("Student Profile", style: context.tt.titleMedium),
      icon: Icons.person,
      formKey: GlobalKey<FormState>(),
      submitText: "Close",
      onSubmit: () {},
      sections: [
        SizedBox(
          height: MediaQuery.of(context).size.height * 0.6,
          child: SingleChildScrollView(
            child: Column(
              children: [
                /// 🔥 PROFILE HEADER
                profileHeader(
                  context: context,
                  data: data,
                  color: color,
                  getName: (s) => s.name,
                  getEmail: (s) => s.email,
                  getId: (s) => s.studentId,
                  getImageUrl: (s) => s.imageUrl,
                  onDashboardTap: () {
                    final auth = Get.find<AuthController>();
                    final user = c.studentToUser(data);

                    auth.startImpersonation(user);
                    Get.offAll(() => const Root());
                  },
                ),
                const SizedBox(height: 10),
                _idCardCTA(context, data, color),
                const SizedBox(height: 10),

                /// 🔹 CONTACT (ONLY WHERE LABELS NEEDED)
                _profileCard(
                  context,
                  color: color,
                  title: "Contact",
                  children: [
                    _infoRow("Phone", data.phone ?? "-"),
                    _infoRow("WhatsApp", data.whatsapp ?? "-"),
                  ],
                ),

                /// 🔹 FAMILY (NO LABELS)
                _profileCard(
                  context,
                  color: Colors.orange,
                  title: "Parent Details",
                  children: [
                    _simpleText(data.parentName ?? "-"),
                    _simpleText(data.parentOccupation ?? "-"),
                  ],
                ),

                /// 🔹 ACADEMIC (LABELS REQUIRED)
                _profileCard(
                  context,
                  color: Colors.deepPurple,
                  title: "Academic",
                  children: [
                    _infoRow("Syllabus", data.syllabus ?? "-"),
                    _infoRow("Category", data.category ?? "-"),
                    _infoRow("Standard", data.standard?.toString() ?? "-"),
                  ],
                ),

                /// 🔹 COORDINATOR (NO LABELS)
                if (data.coordinatorName != null)
                  _profileCard(
                    context,
                    color: Colors.teal,
                    title: "Coordinator",
                    children: [
                      _simpleText(data.coordinatorName!),
                      _simpleText(data.coordinatorId ?? "-"),
                    ],
                  ),

                /// 🔹 MENTOR (NO LABELS)
                if (data.mentorName != null)
                  _profileCard(
                    context,
                    color: Colors.indigo,
                    title: "Mentor",
                    children: [
                      _simpleText(data.mentorName!),
                      _simpleText(data.mentorId ?? "-"),
                    ],
                  ),

                /// 🔹 ADVISOR (NO LABELS)
                if (data.advisorName != null)
                  _profileCard(
                    context,
                    color: Colors.green,
                    title: "Advisor",
                    children: [
                      _simpleText(data.advisorName!),
                      _simpleText(data.advisorId ?? "-"),
                    ],
                  ),

                /// 🔹 REFERRAL (NO LABELS)
                if (data.referralName != null)
                  _profileCard(
                    context,
                    color: Colors.lightGreen,
                    title: "Referral",
                    children: [
                      _simpleText(data.referralName!),
                      _simpleText(data.referralRole ?? "-"),
                    ],
                  ),

                /// 🔹 ADDRESS
                _profileCard(
                  context,
                  color: Colors.blueGrey,
                  title: "Address",
                  children: [
                    _simpleText(data.address ?? "-"),
                  ],
                ),
              ],
            ),
          ),
        )
      ],
    );
  }

  Widget _idCardCTA(BuildContext context, Student data, Color color) {
    return InkWell(
      onTap: () {
        print("Open ID Card");
        // 👉 Navigate / open ID card
      },
      borderRadius: BorderRadius.circular(14),
      child: Container(
        width: double.infinity,
        margin: const EdgeInsets.only(bottom: 10),
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
          color: color, // 🔥 SOLID COLOR
          borderRadius: BorderRadius.circular(14),
        ),
        child: Row(
          children: [
            /// 🪪 ICON
            Container(
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.15),
                borderRadius: BorderRadius.circular(10),
              ),
              child: const Icon(
                Icons.badge_outlined,
                color: Colors.white,
                size: 20,
              ),
            ),

            const SizedBox(width: 12),

            /// 🔹 TEXT
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "Student ID Card",
                    style: context.tt.titleSmall?.copyWith(
                      color: Colors.white,
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    "Tap to view or download",
                    style: context.tt.bodySmall?.copyWith(
                      color: Colors.white70,
                    ),
                  ),
                ],
              ),
            ),

            /// 👉 ARROW
            const Icon(
              Icons.arrow_forward_ios,
              color: Colors.white,
              size: 14,
            ),
          ],
        ),
      ),
    );
  }

  Widget profileHeader<T>({
    required BuildContext context,
    required T data,
    required Color color,

    /// 🔹 field resolvers (make it dynamic safely)
    required String Function(T) getName,
    required String? Function(T) getEmail,
    required String? Function(T) getId,
    String? Function(T)? getImageUrl,

    /// 🔹 optional action
    VoidCallback? onDashboardTap,
  }) {
    final imageUrl = getImageUrl?.call(data);

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: color.withOpacity(0.08),
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: color.withOpacity(0.2)),
      ),
      child: Row(
        children: [
          /// 🔥 PROFILE IMAGE
          CircleAvatar(
            radius: 28,
            backgroundColor: color.withOpacity(0.2),
            backgroundImage: imageUrl != null ? NetworkImage(imageUrl) : null,
            child:
                imageUrl == null ? Image.asset("assets/images/logo.png") : null,
          ),

          const SizedBox(width: 12),

          /// 🔹 INFO
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(getName(data), style: context.tt.titleMedium),

                const SizedBox(height: 4),

                Text(
                  getEmail(data) ?? "-",
                  style: context.tt.bodySmall,
                ),

                const SizedBox(height: 4),

                /// 🪪 ID CHIP
                Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                  decoration: BoxDecoration(
                    color: color.withOpacity(0.15),
                    borderRadius: BorderRadius.circular(6),
                  ),
                  child: Text(
                    getId(data) ?? "-",
                    style: context.tt.labelSmall?.copyWith(color: color),
                  ),
                ),
              ],
            ),
          ),

          /// 🔥 ACTION BUTTON
          if (onDashboardTap != null)
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: color,
                padding:
                    const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
              onPressed: onDashboardTap,
              child: Text(
                "Dashboard",
                style: context.tt.labelMedium?.copyWith(
                  color: Colors.white,
                ),
              ),
            ),
        ],
      ),
    );
  }

  Widget _simpleText(String text) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 6),
      child: Text(
        text,
        style: const TextStyle(
          fontSize: 13,
          fontWeight: FontWeight.w500,
        ),
      ),
    );
  }

  Widget _profileCard(
    BuildContext context, {
    required Color color,
    required String title,
    required List<Widget> children,
  }) {
    return Container(
      width: double.infinity,
      margin: const EdgeInsets.only(bottom: 10),
      padding: const EdgeInsets.all(14),
      constraints: const BoxConstraints(minHeight: 100), // 🔥 ADD THIS
      decoration: BoxDecoration(
        color: color.withOpacity(0.08),
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: color.withOpacity(0.2)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: context.tt.titleSmall?.copyWith(color: color),
          ),
          const SizedBox(height: 10),
          ...children,
        ],
      ),
    );
  }

  void _openTeacherProfile(BuildContext context, Teacher data) {
    final color = _getRoleColor(context, "teacher");

    CustomWidgets().showCustomDialog(
      context: context,
      title: Text("Teacher Profile", style: context.tt.titleMedium),
      icon: Icons.school,
      formKey: GlobalKey<FormState>(),
      isViewOnly: true,
      submitText: "Close",
      onSubmit: () {},
      sections: [
        SizedBox(
          height: MediaQuery.of(context).size.height * 0.6,
          child: SingleChildScrollView(
            child: Column(
              children: [
                /// 🔥 PROFILE HEADER (reuse same)
                profileHeader(
                  context: context, data: data, color: color,
                  getName: (t) => t.name,
                  getEmail: (t) => t.email,
                  getId: (t) => t.id,
                  getImageUrl: (t) => t.imageUrl,

                  // no image
                  onDashboardTap: () {
                    final auth = Get.find<AuthController>();
                    final user = c.teacherToUser(data);

                    auth.startImpersonation(user);
                    Get.offAll(() => const Root());
                  },
                ),

                const SizedBox(height: 10),

                /// 🔹 BASIC INFO (like student first card feel)
                _profileCard(
                  context,
                  color: color,
                  title: "Details",
                  children: [
                    _infoRow("Qualification", data.qualification ?? "-"),
                    _infoRow("Gender", data.gender ?? "-"),
                  ],
                ),

                const SizedBox(height: 10),

                /// 🔹 CONTACT (same as student)
                _profileCard(
                  context,
                  color: color,
                  title: "Contact",
                  children: [
                    _infoRow("Phone", data.phone ?? "-"),
                    _infoRow("WhatsApp", data.whatsapp ?? "-"),
                  ],
                ),

                /// 🔹 ADDRESS (same pattern)
                _profileCard(
                  context,
                  color: Colors.blueGrey,
                  title: "Address",
                  children: [
                    _simpleText(data.address ?? "-"),
                    _simpleText(data.place ?? "-"),
                    _simpleText(data.pincode ?? "-"),
                  ],
                ),

                /// 🔹 BANK DETAILS (NEW SECTION)
                _profileCard(
                  context,
                  color: Colors.green,
                  title: "Bank Details",
                  children: [
                    _infoRow("UPI ID", data.upiId ?? "-"),
                    _infoRow("Account No", data.accountNumber ?? "-"),
                    _infoRow("IFSC Code",
                        data.bankBranch ?? "-"), // if IFSC stored here
                    _infoRow("Bank", data.bankName ?? "-"),
                  ],
                ),
              ],
            ),
          ),
        )
      ],
    );
  }

  void _openMentorProfile(BuildContext context, Mentor data) {
    final color = _getRoleColor(context, "teacher");

    CustomWidgets().showCustomDialog(
      context: context,
      title: Text("Mentor Profile", style: context.tt.titleMedium),
      icon: Icons.school,
      formKey: GlobalKey<FormState>(),
      isViewOnly: true,
      submitText: "Close",
      onSubmit: () {},
      sections: [
        SizedBox(
          height: MediaQuery.of(context).size.height * 0.6,
          child: SingleChildScrollView(
            child: Column(
              children: [
                /// 🔥 PROFILE HEADER (reuse same)
                profileHeader(
                  context: context, data: data, color: color,
                  getName: (m) => m.name,
                  getEmail: (m) => m.email,
                  getId: (m) => m.id,
                  getImageUrl: (m) => m.imageUrl,

                  // no image
                  onDashboardTap: () {
                    final auth = Get.find<AuthController>();
                    final user = c.mentorToUser(data);

                    auth.startImpersonation(user);
                    Get.offAll(() => const Root());
                  },
                ),

                const SizedBox(height: 10),

                _profileCard(
                  context,
                  color: color,
                  title: "Contact",
                  children: [
                    _infoRow("Phone", data.phone ?? "-"),
                    _infoRow("WhatsApp", data.whatsapp ?? "-"),
                  ],
                ),

                /// 🔹 ADDRESS (same pattern)
                _profileCard(
                  context,
                  color: Colors.blueGrey,
                  title: "Address",
                  children: [
                    _simpleText(data.address ?? "-"),
                    _simpleText(data.place ?? "-"),
                    _simpleText(data.pincode ?? "-"),
                  ],
                ),

                /// 🔹 BANK DETAILS (NEW SECTION)
                _profileCard(
                  context,
                  color: Colors.green,
                  title: "Bank Details",
                  children: [
                    _infoRow("UPI ID", data.upiId ?? "-"),
                    _infoRow("Account No", data.accountNumber ?? "-"),
                    _infoRow("IFSC Code",
                        data.bankBranch ?? "-"), // if IFSC stored here
                    _infoRow("Bank", data.bankName ?? "-"),
                  ],
                ),
              ],
            ),
          ),
        )
      ],
    );
  }

  void editSession(BuildContext context) {
    CustomWidgets().showCustomDialog(
      context: context,
      title: Text('Edit Session'),
      icon: Icons.edit,
      formKey: GlobalKey<FormState>(),
      sections: [
        Column(
          children: [
            /// 🔹 SECTION: DATE & TIME
            _sectionCard(
              icon: Icons.schedule,
              title: "Schedule",
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      CustomWidgets()
                          .labelWithAsterisk('Session Date', required: true),
                      const SizedBox(height: 10),
                      SizedBox(
                          width: 150,
                          child: CustomWidgets().dropdownStyledTextField(
                            context: context,
                            hint: 'Date',
                            controller: c.dateController,
                          )),
                    ],
                  ),
                  const SizedBox(height: 10),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      CustomWidgets()
                          .labelWithAsterisk('Session Time', required: true),
                      const SizedBox(height: 10),
                      SizedBox(
                          width: 150,
                          child: CustomWidgets().dropdownStyledTextField(
                              context: context,
                              hint: 'Enter Time',
                              controller: c.timeController)),
                    ],
                  ),
                ],
              ),
            ),

            const SizedBox(height: 14),

            /// 🔹 SECTION: SESSION DETAILS
            _sectionCard(
              icon: Icons.school,
              title: "Session Details",
              child: Column(
                children: [
                  CustomWidgets().labelWithAsterisk('Duration', required: true),
                  const SizedBox(height: 10),
                  CustomWidgets().customDropdownField(
                      context: context,
                      hint: 'Select Duration',
                      value: c.selectedDuration.value,
                      items: [],
                      onChanged: (p0) => c.selectedDuration.value = p0),
                  const SizedBox(height: 12),
                  CustomWidgets().labelWithAsterisk('Teacher', required: true),
                  const SizedBox(height: 10),
                  CustomWidgets().customDropdownField(
                      context: context,
                      hint: 'Select Teacher',
                      items: [],
                      value: c.selectedTeacher.value,
                      onChanged: (p0) => c.selectedTeacher.value = p0),
                ],
              ),
            ),

            const SizedBox(height: 14),

            /// 🔹 SECTION: PAYMENT
            _sectionCard(
              icon: Icons.payments_outlined,
              title: "Payment",
              child: Column(
                children: [
                  CustomWidgets().labelWithAsterisk(
                    'Teacher Salary (per hour - optional)',
                  ),
                  const SizedBox(height: 10),
                  CustomWidgets().dropdownStyledTextField(
                      isNumber: true,
                      context: context,
                      hint: 'Enter Teacher Salary',
                      controller: c.salaryController),
                ],
              ),
            ),
          ],
        ),
      ],
      onSubmit: () {},
    );
  }

  FloatingActionButton addSessionBtn(BuildContext context) {
    return FloatingActionButton(
      onPressed: () => CustomWidgets().showCustomDialog(
        context: context,
        title: Obx(() {
          return Text(
            c.selectedType.value == "session"
                ? "Add Class Session"
                : "Add Meet Session",
          );
        }),
        formKey: GlobalKey<FormState>(),
        onSubmit: () {},
        sections: [
          SizedBox(
            height: MediaQuery.of(context).size.height * 0.75,
            child: SingleChildScrollView(
              child: Column(
                children: [
                  Obx(
                    () => Row(
                      children: [
                        Expanded(
                          child: RadioListTile(
                            dense: true,
                            title: Text('Class Session'),
                            value: "session",
                            groupValue: c.selectedType.value,
                            onChanged: (value) => c.selectedType.value = value!,
                          ),
                        ),
                        Expanded(
                          child: RadioListTile(
                            dense: true,
                            title: Text('Meet'),
                            value: "meet",
                            groupValue: c.selectedType.value,
                            onChanged: (value) => c.selectedType.value = value!,
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 10),
                  Obx(() {
                    if (c.selectedType.value == 'session') {
                      return Column(
                        children: [
                          CustomWidgets().labelWithAsterisk('Select Student',
                              required: true),
                          const SizedBox(height: 10),
                          CustomWidgets().customDropdownField(
                            context: context,
                            hint: 'Select Teacher',
                            items: c.teacherList,
                            onChanged: (p0) =>
                                c.selectedTeacher.value = p0.name,
                          ),
                          const SizedBox(height: 10),
                          CustomWidgets().labelWithAsterisk(
                            'Search and Select Teacher',
                            required: true,
                          ),
                          const SizedBox(height: 10),
                          CustomWidgets().customDropdownField(
                            context: context,
                            hint: 'Select Teacher',
                            items: c.teacherList,
                            onChanged: (p0) =>
                                c.selectedTeacher.value = p0.name,
                          ),
                          const SizedBox(height: 10),
                          CustomWidgets().labelWithAsterisk('Teacher Salary'),
                          const SizedBox(height: 10),
                          CustomWidgets().dropdownStyledTextField(
                              context: context,
                              hint: 'Teacher Salary',
                              controller: c.salaryController),
                          const SizedBox(height: 10),
                          CustomWidgets().labelWithAsterisk('Session Date',
                              required: true),
                          const SizedBox(height: 10),
                          CustomWidgets().customDatePickerField(
                            context: context,
                            controller: c.dateController,
                            selectedDate: c.selectedDate,
                          ),
                          const SizedBox(height: 10),
                          CustomWidgets().labelWithAsterisk('Session Time',
                              required: true),
                          const SizedBox(height: 10),
                          CustomWidgets().timePickerStyledField(
                              context: context,
                              controller: c.timeController,
                              selectedTime: c.selectedTime),
                          const SizedBox(height: 10),
                          CustomWidgets().labelWithAsterisk('Select Duration',
                              required: true),
                          const SizedBox(height: 20),
                          CustomWidgets().durationPickerStyledField(
                              context: context,
                              hint: 'Select Duration',
                              controller: c.durationController,
                              selectedDuration: c.selectedDuration),
                        ],
                      );
                    }
                    if (c.selectedType.value == 'meet') {
                      return Column(
                        children: [
                          CustomWidgets()
                              .labelWithAsterisk('Meet Title', required: true),
                          const SizedBox(height: 10),
                          CustomWidgets().dropdownStyledTextField(
                              context: context,
                              hint: 'Meet Title',
                              controller: c.meetTitleController),
                          const SizedBox(height: 10),
                          CustomWidgets().labelWithAsterisk(
                              'Select Participants',
                              required: true),
                          const SizedBox(height: 10),
                          Row(
                            children: [
                              Obx(
                                () => Checkbox(
                                  value: c.selectAllMentors.value,
                                  onChanged: (value) {
                                    if (value == null) return;

                                    c.selectAllMentors.value = value;

                                    if (value == true) {
                                      // select all
                                      c.selectedMentors
                                          .assignAll(c.mentorsList);
                                    } else {
                                      // clear all
                                      c.selectedMentors.clear();
                                    }
                                  },
                                ),
                              ),
                              Text('Select All Mentors'),
                            ],
                          ),
                          const SizedBox(height: 10),
                          CustomWidgets().customMultiDropdownField(
                              context: context,
                              hint:
                                  'Select Mentors (${c.mentorsList.length} available)',
                              items: c.mentorsList,
                              selectedItems: c.selectedMentors),
                          const SizedBox(height: 10),
                          Row(
                            children: [
                              Obx(
                                () => Checkbox(
                                  value: c.selectAllTeachers.value,
                                  onChanged: (value) {
                                    if (value == null) return;

                                    c.selectAllTeachers.value = value;

                                    if (value == true) {
                                      // select all
                                      c.selectedTeachers
                                          .assignAll(c.teacherList);
                                    } else {
                                      // clear all
                                      c.selectedTeachers.clear();
                                    }
                                  },
                                ),
                              ),
                              Text('Select All Teachers'),
                            ],
                          ),
                          const SizedBox(height: 10),
                          CustomWidgets().customMultiDropdownField(
                              context: context,
                              hint:
                                  'Select Teachers (${c.teacherList.length} available)',
                              items: c.teacherList,
                              selectedItems: c.selectedTeachers),
                          const SizedBox(height: 10),
                          Row(
                            children: [
                              Obx(
                                () => Checkbox(
                                  value: c.selectAllStudents.value,
                                  onChanged: (value) {
                                    if (value == null) return;

                                    c.selectAllStudents.value = value;

                                    if (value == true) {
                                      // select all
                                      c.selectedStudents
                                          .assignAll(c.studentsList);
                                    } else {
                                      // clear all
                                      c.selectedStudents.clear();
                                    }
                                  },
                                ),
                              ),
                              Text('Select All Students'),
                            ],
                          ),
                          const SizedBox(height: 10),
                          CustomWidgets().customMultiDropdownField(
                              context: context,
                              hint:
                                  'Select Students (${c.studentsList.length} available)',
                              items: c.studentsList,
                              selectedItems: c.selectedStudents),
                          const SizedBox(height: 10),
                          Row(
                            children: [
                              Obx(
                                () => Checkbox(
                                  value: c.selectAllCoordinators.value,
                                  onChanged: (value) {
                                    if (value == null) return;

                                    c.selectAllCoordinators.value = value;

                                    if (value == true) {
                                      // select all
                                      c.selectedCoordinators
                                          .assignAll(c.coordinatorsList);
                                    } else {
                                      // clear all
                                      c.selectedCoordinators.clear();
                                    }
                                  },
                                ),
                              ),
                              Text('Select All Coordinators'),
                            ],
                          ),
                          const SizedBox(height: 10),
                          CustomWidgets().customMultiDropdownField(
                              context: context,
                              hint:
                                  'Select Coordinators (${c.coordinatorsList.length} available)',
                              items: c.coordinatorsList,
                              selectedItems: c.selectedCoordinators),
                          const SizedBox(height: 10),
                          Row(
                            children: [
                              Obx(
                                () => Checkbox(
                                  value: c.selectAllAdvisors.value,
                                  onChanged: (value) {
                                    if (value == null) return;

                                    c.selectAllAdvisors.value = value;

                                    if (value == true) {
                                      // select all
                                      c.selectedAdvisors
                                          .assignAll(c.advisorsList);
                                    } else {
                                      // clear all
                                      c.selectedAdvisors.clear();
                                    }
                                  },
                                ),
                              ),
                              Text('Select All Advisors'),
                            ],
                          ),
                          const SizedBox(height: 10),
                          CustomWidgets().customMultiDropdownField(
                              context: context,
                              hint:
                                  'Select Advisors (${c.advisorsList.length} available)',
                              items: c.advisorsList,
                              selectedItems: c.selectedAdvisors),
                          const SizedBox(height: 10),
                          Row(
                            children: [
                              Obx(
                                () => Checkbox(
                                  value: c.selectAllOtherUsers.value,
                                  onChanged: (value) {
                                    if (value == null) return;

                                    c.selectAllOtherUsers.value = value;

                                    if (value == true) {
                                      // select all
                                      c.selectedOtherUsers
                                          .assignAll(c.otherUsersList);
                                    } else {
                                      // clear all
                                      c.selectedOtherUsers.clear();
                                    }
                                  },
                                ),
                              ),
                              Text('Select All Other Users'),
                            ],
                          ),
                          const SizedBox(height: 10),
                          CustomWidgets().customMultiDropdownField(
                              context: context,
                              hint:
                                  'Select Other Users (${c.otherUsersList.length} available)',
                              items: c.otherUsersList,
                              selectedItems: c.selectedOtherUsers),
                          const SizedBox(height: 10),
                          Align(
                            alignment: Alignment.centerLeft,
                            child: Text(
                              'Session Details',
                              style: TextStyle(fontWeight: FontWeight.bold),
                            ),
                          ),
                          const SizedBox(height: 10),
                          CustomWidgets().labelWithAsterisk('Session Date',
                              required: true),
                          const SizedBox(height: 10),
                          CustomWidgets().customDatePickerField(
                            context: context,
                            controller: c.dateController,
                            selectedDate: c.selectedDate,
                          ),
                          const SizedBox(height: 10),
                          CustomWidgets()
                              .labelWithAsterisk('Start Time', required: true),
                          const SizedBox(height: 10),
                          CustomWidgets().durationPickerStyledField(
                              context: context,
                              controller: c.timeController,
                              selectedDuration: c.selectedDuration),
                          const SizedBox(height: 10),
                          CustomWidgets()
                              .labelWithAsterisk('Description', required: true),
                          const SizedBox(height: 10),
                          CustomWidgets().dropdownStyledTextField(
                              context: context,
                              hint: 'Description',
                              controller: c.descriptionController)
                        ],
                      );
                    }
                    return const SizedBox();
                  })
                ],
              ),
            ),
          ),
        ],
      ),
      mini: true,
      backgroundColor: context.theme.colorScheme.primary,
      child: Icon(
        Icons.add,
        color: context.theme.colorScheme.onPrimary,
      ),
    );
  }

  Widget _buildPersonSection(BuildContext context, data) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final isSmall = constraints.maxWidth < 320;

        return isSmall
            ? Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  _personCompact(
                      context, "Student", data.studentName, data.studentId),
                  const SizedBox(height: 8),
                  _personCompact(
                      context, "Teacher", data.teacherName, data.teacherId),
                ],
              )
            : Row(
                children: [
                  Expanded(
                    child: _personCompact(
                        context, "Student", data.studentName, data.studentId),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: _personCompact(
                        context, "Teacher", data.teacherName, data.teacherId),
                  ),
                ],
              );
      },
    );
  }

  Widget _buildDetailsSection(BuildContext context, Session data) {
    final cs = Theme.of(context).colorScheme;

    return LayoutBuilder(
      builder: (context, constraints) {
        final isSmall = constraints.maxWidth < 320;

        return Container(
          padding: const EdgeInsets.all(10),
          decoration: BoxDecoration(
            color: cs.outlineVariant.withOpacity(0.03),
            borderRadius: BorderRadius.circular(12),
          ),
          child: isSmall

              /// 🔥 MOBILE → STACK EVERYTHING
              ? Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        _miniInfo(context, "Subject", data.package),
                        SizedBox(height: 10),
                        _miniInfo(context, "Class", data.className),
                      ],
                    ),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        _miniInfo(context, "Date", _formatDate(data.date)),
                        SizedBox(height: 10),
                        _miniInfo(context, "Time", _formatTime(data.time)),
                      ],
                    ),
                  ],
                )

              /// 🔥 TABLET / DESKTOP → PROPER 2 COLUMN LAYOUT
              : Row(
                  children: [
                    /// LEFT COLUMN
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          _miniInfo(context, "Subject", data.package),
                          const SizedBox(height: 6),
                          _miniInfo(context, "Class", data.className),
                        ],
                      ),
                    ),

                    const SizedBox(width: 12),

                    /// RIGHT COLUMN
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          _miniInfo(context, "Date", _formatDate(data.date)),
                          const SizedBox(height: 6),
                          _miniInfo(context, "Time", _formatTime(data.time)),
                        ],
                      ),
                    ),
                  ],
                ),
        );
      },
    );
  }

  String _formatDate(DateTime dateTime) {
    return "${dateTime.day.toString().padLeft(2, '0')}/"
        "${dateTime.month.toString().padLeft(2, '0')}/"
        "${dateTime.year}";
  }

  Widget _topBar(BuildContext context, SessionController c) {
    final isMobile = Responsive.isMobile(context);

    if (isMobile) {
      return Column(
        children: [
          CustomWidgets().premiumSearch(
            context,
            hint: "Search sessions...",
            onChanged: (val) => c.searchQuery.value = val,
          ),
          const SizedBox(height: 10),
          Row(
            children: [
              Expanded(child: _filterButton(context)),
              const SizedBox(width: 10),
              Expanded(child: _sortButton(context, c)),
            ],
          )
        ],
      );
    }

    return Row(
      children: [
        Expanded(
            flex: 3,
            child: CustomWidgets().premiumSearch(
              context,
              hint: "Search sessions...",
              onChanged: (val) => c.searchQuery.value = val,
            )),
        const SizedBox(width: 12),
        _filterButton(context),
        const SizedBox(width: 8),
        _sortButton(context, c),
      ],
    );
  }

  Widget _actionButton(BuildContext context, IconData icon, String label) {
    return Container(
      height: 44,
      padding: const EdgeInsets.symmetric(horizontal: 12),
      decoration: BoxDecoration(
        color: context.theme.colorScheme.onPrimary,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
            color: context.theme.colorScheme.outline.withOpacity(0.5)),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 18),
          const SizedBox(width: 6),
          Text(
            label,
            style: context.tt.labelMedium,
          ),
        ],
      ),
    );
  }

  Widget _sortButton(BuildContext context, SessionController c) {
    return GestureDetector(
      onTap: () => CustomWidgets().showSortSheet(
          title: "Sort Sessions",
          options: _sortOptions,
          selectedValue: c.sortType.value,
          onSelected: (val) => c.sortType.value = val),
      child: _actionButton(context, Icons.swap_vert, "Sort"),
    );
  }

  Widget _filterButton(BuildContext context) {
    return Container(
      height: 44,
      padding: const EdgeInsets.symmetric(horizontal: 12),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.onPrimary,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
            color: Theme.of(context).colorScheme.outline.withOpacity(0.5)),
      ),
      child: InkWell(
        onTap: () {
          // TODO: open filter bottom sheet
        },
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: const [
            Icon(Icons.filter_list, size: 18),
            SizedBox(width: 6),
            Text("Filter", style: TextStyle(fontSize: 13)),
          ],
        ),
      ),
    );
  }

  String _formatTime(DateTime dt) {
    final hour = dt.hour > 12 ? dt.hour - 12 : dt.hour;
    final ampm = dt.hour >= 12 ? "PM" : "AM";
    return "$hour:${dt.minute.toString().padLeft(2, '0')} $ampm";
  }

  Widget _miniInfo(BuildContext context, String label, String value) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: context.tt.labelSmall?.copyWith(
            color: Theme.of(context).colorScheme.outline,
          ),
        ),
        const SizedBox(height: 2),
        Text(
          value,
          style: context.tt.bodySmall?.copyWith(
            fontWeight: FontWeight.w500,
          ),
        ),
      ],
    );
  }

  Widget _personCompact(
      BuildContext context, String label, String name, String id) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label.toUpperCase(),
          style: context.tt.labelSmall?.copyWith(
            color: Theme.of(context).colorScheme.outline,
          ),
        ),
        const SizedBox(height: 2),
        Text(
          name,
          style: context.tt.bodyMedium?.copyWith(
            fontWeight: FontWeight.w600,
          ),
        ),
        const SizedBox(height: 2),
        Text(
          id,
          style: context.tt.labelSmall?.copyWith(
            color: Theme.of(context).colorScheme.outline,
          ),
        ),
      ],
    );
  }

  Color getStatusColor(BuildContext context, String status) {
    switch (status) {
      case "started":
        return Theme.of(context).colorScheme.onInverseSurface;
      case "no_balance":
        return Theme.of(context).colorScheme.tertiary;
      case "upcoming":
        return Theme.of(context).colorScheme.primary;
      case "pending":
        return Theme.of(context).colorScheme.tertiary;
      case "completed":
        return Theme.of(context).colorScheme.outline;
      case "meet_done":
        return Theme.of(context).colorScheme.secondary;
      default:
        return Theme.of(context).colorScheme.shadow;
    }
  }

  Widget _sectionCard({
    required IconData icon,
    required String title,
    required Widget child,
  }) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: Colors.transparent,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.transparent),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(icon, size: 18),
              const SizedBox(width: 6),
              Text(
                title,
                style: const TextStyle(fontWeight: FontWeight.w600),
              ),
            ],
          ),
          const SizedBox(height: 10),
          child,
        ],
      ),
    );
  }
}

final List<SortOption> _sortOptions = [
  SortOption(
      label: "Latest First", value: SortType.newest, icon: Icons.schedule),
  SortOption(
      label: "Oldest First", value: SortType.oldest, icon: Icons.history),
  SortOption(
      label: "Student Name", value: SortType.student, icon: Icons.person),
  SortOption(
      label: "Teacher Name", value: SortType.teacher, icon: Icons.school),
];
