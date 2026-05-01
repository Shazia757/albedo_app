import 'package:albedo_app/controller/auth_controller.dart';
import 'package:albedo_app/controller/session_controller.dart';
import 'package:albedo_app/controller/session_report_controller.dart';
import 'package:albedo_app/model/meet_model.dart';
import 'package:albedo_app/model/session_model.dart';
import 'package:albedo_app/view/sessions/session_report_dialog.dart';
import 'package:albedo_app/widgets/custom_card.dart';
import 'package:albedo_app/widgets/header_with_search.dart';
import 'package:albedo_app/widgets/responsive.dart';
import 'package:albedo_app/widgets/session_widgets.dart';
import 'package:albedo_app/widgets/widgets.dart';
import 'package:albedo_app/widgets/custom_appbar.dart';
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
    final cs = Theme.of(context).colorScheme;
    final isDesktop = Responsive.isDesktop(context);

    return Scaffold(
      appBar: const CustomAppBar(),
      backgroundColor: cs.surfaceContainerLowest,
      drawer: isDesktop ? null : const DrawerMenu(),
      floatingActionButton: AddSessionFAB(c: c),
      body: Row(
        children: [
          if (isDesktop) const DrawerMenu(),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(16, 16, 16, 0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _TopBar(c: c),
                  const SizedBox(height: 14),

                  // ── STATUS TABS ─────────────────────────────────────
                  Obx(
                    () => CustomWidgets().customTabs(
                      context,
                      tabs: c.tabs,
                      selectedIndex: c.selectedTab.value,
                      getCount: (index) {
                        final tab = c.statusMap[index];

                        if (tab == "meet_done") {
                          return c.meets
                              .where((m) => m.status == "finished")
                              .length;
                        }

                        return c.sessions.where((s) => s.status == tab).length;
                      },
                      onTap: (index) {
                        c.selectedTab.value = index;
                        c.applyFilters();
                      },
                    ),
                  ),

                  const SizedBox(height: 14),

                  // ── SESSION GRID ────────────────────────────────────
                  Expanded(
                    child: Obx(() {
                      bool isMeetTab =
                          c.statusMap[c.selectedTab.value] == "meet_done";

                      final sessions = c.filteredSessions;
                      final meets = c.filteredMeets;

                      if (c.isLoading.value) {
                        return Center(
                          child: CircularProgressIndicator(
                            color: cs.primary,
                            strokeWidth: 2.5,
                          ),
                        );
                      }

                      // ✅ EMPTY STATE BASED ON TAB
                      if (isMeetTab ? meets.isEmpty : sessions.isEmpty) {
                        return EmptyState(
                          cs: cs,
                          icon: Icons.event_busy_outlined,
                          title: isMeetTab
                              ? 'No meets found'
                              : 'No sessions found',
                          subtitle: 'Try adjusting filters or add one',
                        );
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
                            padding: const EdgeInsets.only(bottom: 80),
                            crossAxisCount: crossAxisCount,
                            mainAxisSpacing: 8,
                            crossAxisSpacing: 8,

                            // ✅ SWITCH COUNT
                            itemCount:
                                isMeetTab ? meets.length : sessions.length,

                            itemBuilder: (_, i) {
                              // ✅ SWITCH DATA SOURCE
                              if (isMeetTab) {
                                final meet = meets[i];

                                return PremiumInfoCard(
                                  id: meet.id ?? "-",
                                  title: meet.title ?? "Untitled Meet",

                                  // 👉 Subtitle = date
                                  subtitle: _formatDate(meet.date),

                                  // 👉 Status
                                  status: meet.status,
                                  statusColor:
                                      _getStatusColor(meet.status, context),

                                  // 👉 Extra Info (time + members)
                                  extraInfo:
                                      "${meet.startTime} - ${meet.endTime}",
                                  extraWidget:
                                      _buildMembersChips(meet, context),

                                  footerText: "",

                                  onTap: () => showMeetDetails(meet),

                                  actions: [],
                                );
                              }

                              final session = sessions[i];

                              return _SessionCard(
                                session: session,
                                statusColor:
                                    getStatusColor(context, session.status),
                                onTap: () =>
                                    _openSessionDetails(context, sessions, i),
                              );
                            },
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

  String _formatDate(DateTime? date) {
    if (date == null) return "-";
    return "${date.day}/${date.month}/${date.year}";
  }

  Widget _buildMembersChips(Meet meet, BuildContext context) {
    final cs = Theme.of(context).colorScheme;

    final roles = meet.members.map((m) => m.role).toSet().toList();

    return Wrap(
      spacing: 6,
      runSpacing: 6,
      children: roles.map((role) {
        return Container(
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
          decoration: BoxDecoration(
            color: cs.secondary.withOpacity(0.1),
            borderRadius: BorderRadius.circular(20),
          ),
          child: Text(
            role ?? "-",
            style: TextStyle(
              fontSize: 11,
              color: cs.secondary,
              fontWeight: FontWeight.w500,
            ),
          ),
        );
      }).toList(),
    );
  }

  // 🎨 STATUS COLOR
  Color _getStatusColor(String? status, BuildContext context) {
    final cs = Theme.of(context).colorScheme;

    switch (status) {
      case "finished":
        return Colors.green;
      case "ongoing":
        return Colors.orange;
      case "upcoming":
        return cs.primary;
      default:
        return cs.outline;
    }
  }

  // ── SESSION DETAIL DIALOG ────────────────────────────────────────────
  void _openSessionDetails(
    BuildContext context,
    List<Session> sessions,
    int initialIndex,
  ) {
    final auth = Get.find<AuthController>();
    final isCoordinator = auth.activeUser?.role == "coordinator";

    final c = Get.find<SessionController>();

    // set initial index once
    c.currentSessionIndex.value = initialIndex;

    CustomWidgets().showCustomDialog(
      isViewOnly: true,
      context: context,
      title: const Text("Session Details"),
      icon: Icons.visibility_outlined,
      formKey: GlobalKey<FormState>(),
      submitText: "Close",
      onSubmit: () {},
      sections: [
        Obx(() {
          final index = c.currentSessionIndex.value;
          final data = sessions[index];
          final cs = Theme.of(context).colorScheme;

          return SizedBox(
            height: MediaQuery.of(context).size.height * 0.75,
            child: Column(
              children: [
                // ───────── HEADER NAVIGATION ─────────
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    IconButton(
                      onPressed: index > 0
                          ? () => c.currentSessionIndex.value--
                          : null,
                      icon: const Icon(Icons.arrow_back_ios),
                    ),
                    Column(
                      children: [
                        Text(
                          "Session ${index + 1} of ${sessions.length}",
                          style: Theme.of(context).textTheme.labelMedium,
                        ),
                        const SizedBox(height: 6),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: List.generate(
                            sessions.length,
                            (i) => Container(
                              margin: const EdgeInsets.symmetric(horizontal: 2),
                              width: i == index ? 18 : 6,
                              height: 6,
                              decoration: BoxDecoration(
                                color: i == index
                                    ? cs.primary
                                    : cs.outlineVariant.withOpacity(0.4),
                                borderRadius: BorderRadius.circular(10),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                    IconButton(
                      onPressed: index < sessions.length - 1
                          ? () => c.currentSessionIndex.value++
                          : null,
                      icon: const Icon(Icons.arrow_forward_ios),
                    ),
                  ],
                ),

                // ───────── BODY ─────────
                Expanded(
                  child: SingleChildScrollView(
                    padding: const EdgeInsets.fromLTRB(0, 4, 0, 16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        detailCard(
                          context,
                          title: "Student",
                          name: data.student?.name ?? '',
                          id: data.student?.studentId ?? '',
                          onTap: () => _onUserTap(
                            context,
                            "student",
                            data.student?.studentId,
                          ),
                        ),

                        detailCard(
                          context,
                          title: "Teacher",
                          name: data.teacher?.name ?? '',
                          id: data.teacher?.id ?? '',
                          onTap: () => _onUserTap(
                            context,
                            "teacher",
                            data.teacher?.id,
                          ),
                        ),

                        buildRoleCard(
                          context: context,
                          title: "Mentor",
                          user: data.mentor,
                          onTap: (id) => _onUserTap(context, "mentor", id),
                        ),

                        buildRoleCard(
                          context: context,
                          title: "Coordinator",
                          user: data.coordinator,
                          onTap: (id) => _onUserTap(context, "coordinator", id),
                        ),

                        buildRoleCard(
                          context: context,
                          title: "Advisor",
                          user: data.advisor,
                          onTap: (id) => _onUserTap(context, "advisor", id),
                        ),

                        const SizedBox(height: 16),

                        _DetailSectionLabel(
                          label: "Schedule & Info",
                          icon: Icons.event_outlined,
                        ),

                        const SizedBox(height: 8),

                        EditableInfoCard(
                          type: "schedule",
                          icon: Icons.schedule_outlined,
                          title: "Schedule",
                          date: formatDate(data.date),
                          time: formatTime(data.time),
                          duration: data.duration?.toString() ?? "-",
                          onSave: (date, time) {},
                        ),

                        infoCard(
                          context,
                          type: "session",
                          icon: Icons.menu_book_outlined,
                          title: "Session Info",
                          children: [
                            infoRow(
                              label: "Subject",
                              value: data.package ?? "-",
                            ),
                            infoRow(
                              label: "Syllabus",
                              value: data.syllabus ?? "-",
                            ),
                          ],
                        ),

                        const SizedBox(height: 16),

                        _DetailSectionLabel(
                          label: "Status",
                          icon: Icons.flag_outlined,
                        ),

                        const SizedBox(height: 8),

                        infoCard(
                          context,
                          type: "status",
                          icon: Icons.flag_outlined,
                          title: "Status",
                          children: [
                            infoRow(
                              label: "Current Status",
                              value: data.status,
                            ),
                          ],
                        ),

                        const SizedBox(height: 10),

                        // ───────── REPORT SECTION ─────────
                        if (data.status == 'pending')
                          infoCard(
                            context,
                            type: "report",
                            icon: Icons.description,
                            title: "Session Report",
                            children: [
                              Obx(() {
                                final report = c.reportRx.value;

                                if (report == null) {
                                  return Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      const Text(
                                          "No session report available yet."),
                                      const SizedBox(height: 8),
                                      ElevatedButton.icon(
                                        onPressed: () {
                                          c.openSessionReportDialog(data);
                                        },
                                        icon: const Icon(Icons.add),
                                        label: const Text("Add Report"),
                                      ),
                                    ],
                                  );
                                }

                                return Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    // 📦 Report summary
                                    ListTile(
                                      contentPadding: EdgeInsets.zero,
                                      title: Text(report.studentName),
                                      subtitle: Text(
                                        report.isCompleted
                                            ? "Completed"
                                            : "Not Completed",
                                      ),
                                      trailing: TextButton.icon(
                                        onPressed: () =>
                                            c.openSessionReportDialog(data),
                                        icon: const Icon(Icons.edit, size: 18),
                                        label: const Text("Edit"),
                                      ),
                                    ),

                                    const SizedBox(height: 8),

                                    if (!report.isCompleted &&
                                        report.reason != null)
                                      Container(
                                        padding: const EdgeInsets.all(10),
                                        decoration: BoxDecoration(
                                          color: Colors.red.withOpacity(0.05),
                                          borderRadius:
                                              BorderRadius.circular(10),
                                        ),
                                        child: Text(
                                          "Reason: ${report.reason}",
                                          style: const TextStyle(
                                              color: Colors.red),
                                        ),
                                      ),

                                    if (report.isCompleted) ...[
                                      Text(
                                          "Topics: ${report.topicsCovered ?? '-'}"),
                                      Text(
                                          "Notes: ${report.teacherNotes ?? '-'}"),
                                    ],
                                  ],
                                );
                              })
                            ],
                          ),

                        if (data.status == 'completed')
                          infoCard(
                            context,
                            type: "report",
                            icon: Icons.description,
                            title: "Session Report",
                            children: [
                              Obx(() {
                                final report = c.reportRx.value;

                                if (report == null) {
                                  return const Text("No report available");
                                }

                                return Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    // 📦 HEADER
                                    ListTile(
                                      contentPadding: EdgeInsets.zero,
                                      title: Text(report.studentName),
                                      subtitle: const Text("Session Report"),
                                      trailing: TextButton.icon(
                                        onPressed: () =>
                                            c.openSessionReportDialog(data),
                                        icon: const Icon(Icons.edit, size: 18),
                                        label: const Text("Edit Report"),
                                      ),
                                    ),

                                    const SizedBox(height: 8),

                                    // 🎯 ALWAYS SHOW FOR COMPLETED
                                    _infoRow(
                                      "Topics Covered",
                                      report.topicsCovered ?? "-",
                                    ),

                                    _infoRow(
                                      "Teacher Notes",
                                      report.teacherNotes ?? "-",
                                    ),
                                  ],
                                );
                              }),
                            ],
                          ),
                      ],
                    ),
                  ),
                ),

                // ───────── ACTION BUTTONS ─────────
                if (data.status != 'completed' && data.status != 'meet_done')
                  Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: cs.surface,
                      border: Border(
                        top: BorderSide(
                          color: cs.outlineVariant.withOpacity(0.2),
                        ),
                      ),
                    ),
                    child: Row(
                      children: [
                        Expanded(
                          child: _DetailActionButton(
                            label: "Edit",
                            icon: Icons.edit_outlined,
                            color: cs.secondary,
                            onTap: () {
                              c.loadSession(data);
                              editSession(context);
                            },
                          ),
                        ),
                        const SizedBox(width: 8),
                        Expanded(
                          child: _DetailActionButton(
                            label: "Support",
                            icon: Icons.support_agent_outlined,
                            color: cs.tertiary,
                            onTap: () => _addSupport(context),
                          ),
                        ),
                        if (data.status == 'pending') ...[
                          const SizedBox(width: 8),
                          Expanded(
                            child: _DetailActionButton(
                              label: "Complete",
                              icon: Icons.check_outlined,
                              color: cs.primary,
                              onTap: () => _markSessionCompleted(
                                context,
                                data.date,
                              ),
                            ),
                          ),
                        ],
                        if (!isCoordinator) ...[
                          const SizedBox(width: 8),
                          Expanded(
                            child: _DetailActionButton(
                              label: "Delete",
                              icon: Icons.delete_outline,
                              color: cs.error,
                              onTap: () => CustomWidgets().showDeleteDialog(
                                text:
                                    'Are you sure you want to delete this session permanently?',
                                context: context,
                                onConfirm: () => c.delete(data.id),
                              ),
                            ),
                          ),
                        ],
                      ],
                    ),
                  ),

                const SizedBox(height: 10),

                if (data.status == 'started')
                  Row(
                    children: [
                      Expanded(
                        child: _DetailActionButton(
                          onTap: () {},
                          icon: Icons.arrow_forward_rounded,
                          label: "Join",
                          color: cs.primary,
                        ),
                      ),
                      const SizedBox(width: 10),
                      Expanded(
                        child: _DetailActionButton(
                          color: cs.secondary,
                          onTap: () {},
                          icon: Icons.share,
                          label: "Share",
                        ),
                      ),
                    ],
                  ),
              ],
            ),
          );
        }),
      ],
    );
  }

  Widget _infoRow(String label, String? value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        children: [
          SizedBox(
            width: 90,
            child: Text(
              label,
              style: TextStyle(
                fontSize: 12,
                color: Get.theme.colorScheme.onSurface.withOpacity(0.6),
              ),
            ),
          ),
          Expanded(
            child: Text(
              value ?? "-",
              style: const TextStyle(fontWeight: FontWeight.w500),
            ),
          ),
        ],
      ),
    );
  }

  Widget _sectionLabel(String text, IconData icon) {
    return Row(
      children: [
        Icon(icon, size: 16),
        const SizedBox(width: 6),
        Text(
          text,
          style: const TextStyle(fontWeight: FontWeight.w600),
        ),
      ],
    );
  }

  // ── SUPPORT TICKET DIALOG ─────────────────────────────────────────────
  void _addSupport(BuildContext context) {
    CustomWidgets().showCustomDialog(
      context: context,
      title: const Text('Add New Ticket'),
      icon: Icons.support_agent_outlined,
      formKey: GlobalKey<FormState>(),
      sections: [
        SizedBox(
          height: MediaQuery.of(context).size.height * 0.5,
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                CustomWidgets().labelWithAsterisk('Title', required: true),
                const SizedBox(height: 8),
                CustomWidgets().dropdownStyledTextField(
                    context: context,
                    hint: 'Enter ticket title',
                    controller: c.titleController),
                const SizedBox(height: 12),
                CustomWidgets().labelWithAsterisk('Category', required: true),
                const SizedBox(height: 8),
                CustomWidgets().customDropdownField(
                  context: context,
                  hint: 'Select category',
                  items: c.categoryList,
                  onChanged: (p0) {},
                ),
                const SizedBox(height: 12),
                CustomWidgets().labelWithAsterisk('Priority', required: true),
                const SizedBox(height: 8),
                CustomWidgets().customDropdownField(
                  context: context,
                  hint: 'Select priority',
                  items: ['High', 'Medium', 'Low'],
                  onChanged: (p0) {},
                ),
                const SizedBox(height: 12),
                CustomWidgets().labelWithAsterisk('User', required: true),
                const SizedBox(height: 8),
                Obx(() => Row(
                      children: [
                        Expanded(
                          child: RadioListTile(
                            dense: true,
                            title: const Text('Student'),
                            value: "student",
                            groupValue: c.selectedType.value,
                            onChanged: (value) => c.selectedType.value = value!,
                          ),
                        ),
                        Expanded(
                          child: RadioListTile(
                            dense: true,
                            title: const Text('Teacher'),
                            value: "teacher",
                            groupValue: c.selectedType.value,
                            onChanged: (value) => c.selectedType.value = value!,
                          ),
                        ),
                      ],
                    )),
                const SizedBox(height: 8),
                Obx(() {
                  if (c.selectedType.value == 'student') {
                    return CustomWidgets().customDropdownField(
                        items: c.studentsList,
                        onChanged: (p0) {},
                        context: context,
                        hint: 'Select student');
                  }
                  if (c.selectedType.value == 'teacher') {
                    return CustomWidgets().customDropdownField(
                        items: c.teacherList,
                        onChanged: (p0) {},
                        context: context,
                        hint: 'Select teacher');
                  }
                  return const SizedBox();
                }),
                const SizedBox(height: 12),
                CustomWidgets().labelWithAsterisk('Attachment'),
                const SizedBox(height: 8),
                CustomWidgets().attachmentStyledField(
                  context: context,
                  label: "Attachment",
                  hint: "Choose a file",
                  fileName: c.selectedFile,
                  onTap: () {},
                  onClear: () {},
                ),
                const SizedBox(height: 12),
                CustomWidgets()
                    .labelWithAsterisk('Description', required: true),
                const SizedBox(height: 8),
                CustomWidgets().dropdownStyledTextField(
                  context: context,
                  hint: 'Describe the issue...',
                  controller: c.descriptionController,
                  isMultiline: true,
                ),
                const SizedBox(height: 16),
              ],
            ),
          ),
        ),
      ],
      onSubmit: () {},
    );
  }

  void _onUserTap(BuildContext context, String role, String? id) {
    if (id == null || id == "-") return;

    final handlers = {
      "student": () {
        final s = c.getStudentById(id);
        if (s != null) openStudentProfile(context, s);
      },
      "teacher": () {
        final t = c.getTeacherById(id);
        if (t != null) {
          openTeacherProfile(context, t, toUser: (p0) => teacherToUser(t));
        } else {
          Get.snackbar("Error", "Teacher not found for ID: $id");
        }
      },
      "mentor": () {
        final m = c.getMentorById(id);
        if (m != null) openMentorProfile(context, m, (p0) => c.mentorToUser(m));
      },
      "coordinator": () {
        final c1 = c.getCoordinatorById(id);
        if (c1 != null)
          openCoordinatorProfile(context, c1, (p0) => coordinatorToUser(c1));
      },
      "advisor": () {
        final a = c.getAdvisorById(id);
        if (a != null) openAdvisorProfile(context, a, (p0) => advisorToUser(a));
      },
    };

    handlers[role]?.call() ?? Get.snackbar("Error", "$role not found");
  }

  // ── EDIT SESSION DIALOG ───────────────────────────────────────────────
  void editSession(BuildContext context) {
    CustomWidgets().showCustomDialog(
      context: context,
      title: const Text('Edit Session'),
      icon: Icons.edit_outlined,
      formKey: GlobalKey<FormState>(),
      sections: [
        Column(
          children: [
            _DialogSectionCard(
              icon: Icons.schedule_outlined,
              title: "Schedule",
              child: Row(
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        CustomWidgets()
                            .labelWithAsterisk('Session Date', required: true),
                        const SizedBox(height: 8),
                        CustomWidgets().customDatePickerField(
                            context: context,
                            selectedDate: c.selectedDate,
                            controller: c.dateController),
                      ],
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        CustomWidgets()
                            .labelWithAsterisk('Session Time', required: true),
                        const SizedBox(height: 8),
                        CustomWidgets().timePickerStyledField(
                            selectedTime: c.selectedTime,
                            context: context,
                            hint: 'Time',
                            controller: c.timeController),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 12),
            _DialogSectionCard(
              icon: Icons.school_outlined,
              title: "Session Details",
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  CustomWidgets().labelWithAsterisk('Duration', required: true),
                  const SizedBox(height: 8),
                  CustomWidgets().customDropdownField(
                    context: context,
                    hint: 'Select Duration',
                    items:
                        c.durationOptions.map((e) => "${(e)} minutes").toList(),
                    onChanged: (p0) {},
                  ),
                  const SizedBox(height: 12),
                  CustomWidgets().labelWithAsterisk('Teacher', required: true),
                  const SizedBox(height: 8),
                  CustomWidgets().customDropdownField(
                      context: context,
                      hint: 'Select Teacher',
                      items: [],
                      value: c.selectedTeacher.value,
                      onChanged: (p0) => c.selectedTeacher.value = p0),
                ],
              ),
            ),
            const SizedBox(height: 12),
            _DialogSectionCard(
              icon: Icons.payments_outlined,
              title: "Payment",
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  CustomWidgets().labelWithAsterisk(
                      'Teacher Salary (per hour — optional)'),
                  const SizedBox(height: 8),
                  CustomWidgets().dropdownStyledTextField(
                      isNumber: true,
                      context: context,
                      hint: 'Enter teacher salary',
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

  Color getStatusColor(BuildContext context, String status) {
    final cs = Theme.of(context).colorScheme;
    switch (status) {
      case "started":
        return const Color(0xFF1D9E75); // teal — active/live
      case "upcoming":
        return cs.primary; // brand blue
      case "pending":
        return cs.tertiary; // orange
      case "no_balance":
        return cs.tertiary; // red — needs attention
      case "no_link":
        return cs.error;
      case "completed":
        return cs.outline; // neutral grey
      case "meet_done":
        return cs.secondary; // purple
      default:
        return cs.outline;
    }
  }

  void _markSessionCompleted(BuildContext context, DateTime date) {
    CustomWidgets().showCustomDialog(
      context: context,
      title: const Text('Mark Session as Completed'),
      formKey: GlobalKey<FormState>(),
      sections: [
        Column(
          children: [
            CustomWidgets().labelWithAsterisk('Session Date', required: true),
            const SizedBox(height: 8),
            CustomWidgets().customDatePickerField(
                context: context,
                selectedDate: c.selectedDate,
                controller: c.dateController),
            const SizedBox(width: 12),
            CustomWidgets().labelWithAsterisk('Start Time', required: true),
            const SizedBox(height: 8),
            CustomWidgets().timePickerStyledField(
                selectedTime: c.selectedTime,
                context: context,
                hint: 'Time',
                controller: c.timeController),
            const SizedBox(height: 12),
            CustomWidgets().labelWithAsterisk('Duration', required: true),
            const SizedBox(height: 8),
            CustomWidgets().customDropdownField(
              context: context,
              hint: 'Select Duration',
              items: c.durationOptions.map((e) => "${(e)} minutes").toList(),
              onChanged: (p0) {},
            ),
          ],
        ),
      ],
      onSubmit: () {},
    );
  }

  void showMeetDetails(Meet meet) {
    final formKey = GlobalKey<FormState>();

    CustomWidgets().showCustomDialog(
      context: Get.context!,
      title: Text(meet.title ?? "Meet Details"),
      icon: Icons.video_call_outlined,
      formKey: formKey,
      isViewOnly: true, // 👈 no save button
      submitText: "Close",

      onSubmit: () {},

      sections: [
        // 🆔 BASIC INFO CARD
        Card(
          elevation: 0,
          color: Get.theme.colorScheme.surfaceContainerLowest,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(14),
          ),
          child: Padding(
            padding: const EdgeInsets.all(12),
            child: Column(
              children: [
                _infoRow("Meet ID", meet.id),
                _infoRow("Date", _formatDate(meet.date)),
                _infoRow("Time", "${meet.startTime} - ${meet.endTime}"),
                _infoRow("Status", meet.status),
              ],
            ),
          ),
        ),

        const SizedBox(height: 14),

        // 👥 MEMBERS HEADER
        _sectionLabel("Members", Icons.group_outlined),

        const SizedBox(height: 8),

        // 👥 MEMBERS LIST
        ...meet.members.map((m) {
          return Container(
            margin: const EdgeInsets.only(bottom: 8),
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(12),
              color: Get.theme.colorScheme.surface,
              border: Border.all(
                color: Get.theme.colorScheme.outline.withOpacity(0.2),
              ),
            ),
            child: Row(
              children: [
                CircleAvatar(
                  radius: 18,
                  child: Text(
                    (m.name ?? "-").substring(0, 1).toUpperCase(),
                  ),
                ),
                const SizedBox(width: 10),

                // NAME + EMAIL
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        m.name ?? "-",
                        style: const TextStyle(
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      Text(
                        m.email ?? "-",
                        style: TextStyle(
                          fontSize: 12,
                          color:
                              Get.theme.colorScheme.onSurface.withOpacity(0.6),
                        ),
                      ),
                    ],
                  ),
                ),

                // ROLE BADGE
                Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                  decoration: BoxDecoration(
                    color: Get.theme.colorScheme.secondary.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Text(
                    m.role ?? "-",
                    style: TextStyle(
                      fontSize: 11,
                      color: Get.theme.colorScheme.secondary,
                    ),
                  ),
                ),
              ],
            ),
          );
        }).toList(),
      ],
    );
  }
}

// ═══════════════════════════════════════════════════════════════════════
// SESSION CARD  — clean, professional, data-dense
// ═══════════════════════════════════════════════════════════════════════
class _SessionCard extends StatelessWidget {
  final Session session;
  final Color statusColor;
  final VoidCallback onTap;

  const _SessionCard({
    required this.session,
    required this.statusColor,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    final textPrimary = cs.onSurface;
    final textSecondary = cs.onSurface.withOpacity(0.5);
    final dividerColor = cs.outlineVariant.withOpacity(0.35);
    final auth = Get.find<AuthController>();
    final user = auth.activeUser;

    final isStudent = user?.role == 'student';
    final isTeacher = user?.role == 'teacher';

    return Material(
      color: cs.surface,
      borderRadius: BorderRadius.circular(10),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(10),
        hoverColor: cs.onSurface.withOpacity(0.03),
        splashColor: Colors.transparent,
        highlightColor: Colors.transparent,
        child: Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10),
            border: Border.all(color: dividerColor, width: 0.8),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // ── Status accent bar ─────────────────────────────────
              Container(
                height: 3,
                decoration: BoxDecoration(
                  color: statusColor,
                  borderRadius: const BorderRadius.vertical(
                    top: Radius.circular(10),
                  ),
                ),
              ),

              Padding(
                padding: const EdgeInsets.all(14),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // ── Row 1: ID  +  status badge ────────────────────────
                    Row(
                      children: [
                        Expanded(
                          child: Text(
                            session.id ?? "—",
                            style: TextStyle(
                              fontSize: 11,
                              fontFamily: 'monospace',
                              color: textSecondary,
                              letterSpacing: 0.3,
                            ),
                          ),
                        ),
                        StatusBadge(status: session.status, color: statusColor),
                      ],
                    ),

                    const SizedBox(height: 10),

                    // ── Row 2: Student / Teacher names ────────────────────
                    Row(
                      children: [
                        Expanded(
                          child: NameCell(
                            label: "Student",
                            name: session.student?.name ?? "—",
                            textPrimary: textPrimary,
                            textSecondary: textSecondary,
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: NameCell(
                            label: "Teacher",
                            name: session.teacher?.name ?? "—",
                            textPrimary: textPrimary,
                            textSecondary: textSecondary,
                          ),
                        ),
                      ],
                    ),

                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 10),
                      child: Divider(
                          height: 1, thickness: 0.8, color: dividerColor),
                    ),

                    // ── Row 3: Subject / Date / Class / Time ──────────────
                    Row(
                      children: [
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              MetaItem(
                                  label: "Subject",
                                  value: session.package ?? "—",
                                  textSecondary: textSecondary),
                              const SizedBox(height: 4),
                              MetaItem(
                                  label: "Class",
                                  value: session.className ?? "—",
                                  textSecondary: textSecondary),
                            ],
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              MetaItem(
                                  label: "Date",
                                  value: formatDate(session.date),
                                  textSecondary: textSecondary),
                              const SizedBox(height: 4),
                              MetaItem(
                                  label: "Time",
                                  value: formatTime(session.time),
                                  textSecondary: textSecondary),
                            ],
                          ),
                        ),
                      ],
                    ),
                    if (isStudent || isTeacher) ...[
                      const SizedBox(height: 10),
                      TextButton.icon(
                        onPressed: () =>
                            _openRescheduleDialog(context, session),
                        icon: const Icon(Icons.schedule, size: 18),
                        label: const Text("Reschedule"),
                        style: TextButton.styleFrom(
                          foregroundColor: cs.primary,
                          padding: const EdgeInsets.symmetric(
                              horizontal: 12, vertical: 6),
                        ),
                      ),
                    ],
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _openRescheduleDialog(BuildContext context, Session session) {
    final reasonController = TextEditingController();
    final dateController = TextEditingController();
    final timeController = TextEditingController();

    CustomWidgets().showCustomDialog(
      context: context,
      formKey: GlobalKey<FormState>(),
      title: const Text("Reschedule Session"),
      isViewOnly: false,
      onSubmit: () {
        // TODO: submit logic
        Get.back();

        Get.snackbar(
          "Request Sent",
          "Reschedule request submitted successfully",
          snackPosition: SnackPosition.BOTTOM,
        );
      },
      sections: [
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // 📝 Reason
            CustomWidgets()
                .labelWithAsterisk("Reason for Rescheduling", required: true),

            const SizedBox(height: 6),
            CustomWidgets().dropdownStyledTextField(
                context: context,
                hint: 'Enter reason...',
                controller: reasonController,
                isMultiline: true),

            const SizedBox(height: 12),

            // 📅 New Date
            CustomWidgets().labelWithAsterisk("New Date", required: true),

            const SizedBox(height: 6),
            CustomWidgets().dropdownStyledTextField(
              context: context,
              hint: "Select date",
              controller: dateController,
            ),
            const SizedBox(height: 12),

            // ⏰ New Time
            CustomWidgets().labelWithAsterisk("New Time", required: true),

            const SizedBox(height: 6),
            CustomWidgets().dropdownStyledTextField(
                context: context,
                hint: "Select time",
                controller: timeController)
          ],
        ),
      ],
    );
  }
}

// ═══════════════════════════════════════════════════════════════════════
// TOP BAR
// ═══════════════════════════════════════════════════════════════════════
class _TopBar extends StatelessWidget {
  final SessionController c;
  const _TopBar({required this.c});

  @override
  Widget build(BuildContext context) {
    return HeaderWithSearch(
      title: "Sessions",
      hint: "Search sessions...",
      isSearching: c.isSearching,
      searchQuery: c.searchQuery,
      onSearchChanged: () => c.applyFilters(),
      onSortTap: () => CustomWidgets().showSortSheet<SortType>(
        title: "Sort Sessions",
        options: [
          SortOption(
            label: "Latest First",
            value: SortType.newest,
            icon: Icons.schedule,
          ),
          SortOption(
            label: "Oldest First",
            value: SortType.oldest,
            icon: Icons.history,
          ),
          SortOption(
            label: "Student Name",
            value: SortType.student,
            icon: Icons.person_outline,
          ),
          SortOption(
            label: "Teacher Name",
            value: SortType.teacher,
            icon: Icons.school_outlined,
          ),
        ],
        selectedValue: c.sortType.value,
        onSelected: (val) {
          c.sortType.value = val;
          c.applyFilters();
        },
      ),
    );
  }
}

// ═══════════════════════════════════════════════════════════════════════
// DIALOG HELPERS
// ═══════════════════════════════════════════════════════════════════════

/// Styled section card used inside dialogs
class _DialogSectionCard extends StatelessWidget {
  final IconData icon;
  final String title;
  final Widget child;

  const _DialogSectionCard({
    required this.icon,
    required this.title,
    required this.child,
  });

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;

    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: cs.surfaceContainerHighest.withOpacity(0.3),
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: cs.outlineVariant.withOpacity(0.4), width: 1),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(icon, size: 16, color: cs.primary),
              const SizedBox(width: 6),
              Text(
                title,
                style: TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.w600,
                  color: cs.onSurface,
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          child,
        ],
      ),
    );
  }
}

/// Section label used inside the detail dialog scroll
class _DetailSectionLabel extends StatelessWidget {
  final String label;
  final IconData icon;

  const _DetailSectionLabel({required this.label, required this.icon});

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;

    return Row(
      children: [
        Icon(icon, size: 14, color: cs.primary.withOpacity(0.7)),
        const SizedBox(width: 6),
        Text(
          label.toUpperCase(),
          style: TextStyle(
            fontSize: 11,
            fontWeight: FontWeight.w700,
            color: cs.onSurface.withOpacity(0.45),
            letterSpacing: 0.8,
          ),
        ),
      ],
    );
  }
}

/// Action button row inside the detail dialog
class _DetailActionButton extends StatelessWidget {
  final String label;
  final IconData icon;
  final Color color;
  final VoidCallback onTap;

  const _DetailActionButton({
    required this.label,
    required this.icon,
    required this.color,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return ElevatedButton.icon(
      onPressed: onTap,
      icon: Icon(icon, size: 15, color: Colors.white),
      label: Text(label,
          style: const TextStyle(color: Colors.white, fontSize: 13)),
      style: ElevatedButton.styleFrom(
        backgroundColor: color,
        elevation: 0,
        padding: const EdgeInsets.symmetric(vertical: 12),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      ),
    );
  }
}
