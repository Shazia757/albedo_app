import 'package:albedo_app/controller/advisor_controller.dart';
import 'package:albedo_app/controller/auth_controller.dart';
import 'package:albedo_app/controller/coordinator_controller.dart';
import 'package:albedo_app/controller/mentor_controller.dart';
import 'package:albedo_app/controller/permissions_controller.dart';
import 'package:albedo_app/controller/session_controller.dart';
import 'package:albedo_app/controller/student_controller.dart';
import 'package:albedo_app/controller/teacher_controller.dart';
import 'package:albedo_app/model/meet_model.dart';
import 'package:albedo_app/model/session_model.dart';
import 'package:albedo_app/model/users/teacher_model.dart';
import 'package:albedo_app/view/advisor_detailed_page.dart';
import 'package:albedo_app/view/coordinator_detailed_page.dart';
import 'package:albedo_app/view/mentor_detailed_page.dart';
import 'package:albedo_app/view/sessions/add_session_page.dart';
import 'package:albedo_app/view/sessions/reschedule_request_page.dart';
import 'package:albedo_app/view/students/student_detail_page.dart';
import 'package:albedo_app/view/teacher/tr_detailed_page.dart';
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
import 'package:intl/intl.dart';

class SessionPage extends StatelessWidget {
  final c = Get.put(SessionController(), permanent: true);

  SessionPage({super.key});

  @override
  Widget build(BuildContext context) {
    final cs = Get.theme.colorScheme;
    final isDesktop = Responsive.isDesktop(context);
    final auth = Get.find<AuthController>();
    final role = auth.activeUser?.role;

    final isCustom = ![
      "admin",
      "mentor",
      "advisor",
      "teacher",
      "student",
      "coordinator",
      "finance",
      "sales",
      "hr"
    ].contains(role);

    return Scaffold(
      appBar: const CustomAppBar(),
      backgroundColor: Get.theme.colorScheme.surface,
      drawer: isDesktop ? null : const DrawerMenu(),
      floatingActionButton: (!isCustom || PermissionService.can("add_sessions"))
          ? FloatingActionButton(
              onPressed: () {
                Get.to(() => const AddSessionPage());
              },
              mini: true,
              backgroundColor: context.theme.colorScheme.primary,
              child: Icon(
                Icons.add,
                color: context.theme.colorScheme.onPrimary,
              ),
            )
          : null,
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
                  SizedBox(height: 5),

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

                  SizedBox(height: 14),

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

                          return ClipRect(
                            child: ScrollConfiguration(
                              behavior: const ScrollBehavior()
                                  .copyWith(scrollbars: false),
                              child: MasonryGridView.count(
                                padding: const EdgeInsets.only(bottom: 80),
                                crossAxisCount: crossAxisCount,
                                mainAxisSpacing: 8,
                                crossAxisSpacing: 8,
                                itemCount:
                                    isMeetTab ? meets.length : sessions.length,
                                itemBuilder: (_, i) {
                                  if (isMeetTab) {
                                    final meet = meets[i];

                                    return PremiumInfoCard(
                                      id: meet.id ?? "-",
                                      title: meet.title ?? "Untitled Meet",

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
                                        // Get.to(() => SessionDetailsPage(
                                        //     sessions: sessions, initialIndex: i))
                                        _openSessionDetails(
                                            context, sessions, i),
                                  );
                                },
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

  String _formatDate(DateTime? date) {
    if (date == null) return "-";
    return "${date.day}/${date.month}/${date.year}";
  }

  Widget _buildMembersChips(Meet meet, BuildContext context) {
    final cs = Get.theme.colorScheme;

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
            style: Get.textTheme.labelSmall!.copyWith(color: cs.secondary),
          ),
        );
      }).toList(),
    );
  }

  // 🎨 STATUS COLOR
  Color _getStatusColor(String? status, BuildContext context) {
    final cs = Get.theme.colorScheme;

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
    final role = auth.activeUser?.role;

    final isCustom = ![
      "admin",
      "mentor",
      "advisor",
      "teacher",
      "student",
      "coordinator",
      "finance",
      "sales",
      "hr"
    ].contains(role);

    final c = Get.find<SessionController>();

    // set initial index once
    c.currentSessionIndex.value = initialIndex;

    CustomWidgets().showCustomDialog(
      isViewOnly: true,
      context: context,
      title: Text("Session Details"),
      formKey: GlobalKey<FormState>(),
      onSubmit: () {},
      sections: [
        Obx(() {
          if (sessions.isEmpty) {
            return const Center(
              child: Text("No sessions available"),
            );
          }

          final index = c.currentSessionIndex.value.clamp(
            0,
            sessions.length - 1,
          );

          final data = sessions[index];
          final cs = Get.theme.colorScheme;

          return SizedBox(
            height: MediaQuery.of(context).size.height * 0.70,
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
                          style: Get.textTheme.labelMedium,
                        ),
                        SizedBox(height: 6),
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
                                    : cs.outline.withOpacity(0.5),
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
                        detailCard(context,
                            title: "Student",
                            name: data.student?.name ?? '',
                            id: data.student?.studentId ?? '',
                            onTap: () => Get.to(
                                  () => StudentDetailsPage(
                                      student: data.student!,
                                      initialIndex: initialIndex),
                                  binding: BindingsBuilder(() {
                                    Get.put(StudentController());
                                  }),
                                )),

                        detailCard(context,
                            title: "Teacher",
                            name: data.teacher?.name ?? '',
                            id: data.teacher?.id ?? '',
                            onTap: () => Get.to(
                                  () => TeacherDetailsPage(
                                      teacher: data.teacher!,
                                      initialIndex: initialIndex),
                                  binding: BindingsBuilder(() {
                                    Get.put(TeacherController());
                                  }),
                                )),

                        buildRoleCard(
                          context: context,
                          title: "Mentor",
                          user: data.mentor,
                          onTap: (id) => Get.to(
                            () => MentorDetailsPage(
                                mentor: data.mentor!,
                                initialIndex: initialIndex),
                            binding: BindingsBuilder(() {
                              Get.put(MentorController());
                            }),
                          ),
                        ),

                        buildRoleCard(
                          context: context,
                          title: "Coordinator",
                          user: data.coordinator,
                          onTap: (id) => Get.to(
                            () => CoordinatorDetailedPage(
                                coordinator: data.coordinator!,
                                initialIndex: initialIndex),
                            binding: BindingsBuilder(() {
                              Get.put(CoordinatorController());
                            }),
                          ),
                        ),

                        buildRoleCard(
                          context: context,
                          title: "Advisor",
                          user: data.advisor,
                          onTap: (id) => Get.to(
                            () => AdvisorDetailedPage(
                                advisor: data.advisor!,
                                initialIndex: initialIndex),
                            binding: BindingsBuilder(() {
                              Get.put(AdvisorController());
                            }),
                          ),
                        ),

                        SizedBox(height: 16),

                        DetailSectionLabel(
                          label: "Schedule & Info",
                          icon: Icons.event_outlined,
                        ),

                        SizedBox(height: 8),

                        EditableInfoCard(
                          type: "schedule",
                          icon: Icons.schedule_outlined,
                          title: "Schedule",
                          date: formatDate(data.date ?? DateTime.now()),
                          time: formatTime(
                            TimeOfDay.fromDateTime(data.date ?? DateTime.now()),
                          ),
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
                              value: data.package?.subjectName ?? "-",
                            ),
                            infoRow(
                              label: "Syllabus",
                              value: data.syllabus ?? "-",
                            ),
                          ],
                        ),

                        SizedBox(height: 16),

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

                        SizedBox(height: 10),

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
                                      Text("No session report available yet."),
                                      SizedBox(height: 8),
                                      ElevatedButton.icon(
                                        onPressed: () {
                                          c.openSessionReportDialog(data);
                                        },
                                        icon: const Icon(Icons.add,
                                            color: Colors.white),
                                        label: Text(
                                          "Add Report",
                                          style: Get.textTheme.bodySmall!
                                              .copyWith(color: Colors.white),
                                        ),
                                        style: ElevatedButton.styleFrom(
                                          backgroundColor:
                                              cs.primary.withOpacity(0.8),
                                          elevation: 0,
                                          padding: const EdgeInsets.symmetric(
                                            vertical: 16,
                                            horizontal: 16,
                                          ),
                                          shape: RoundedRectangleBorder(
                                            borderRadius:
                                                BorderRadius.circular(12),
                                          ),
                                        ),
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
                                        label: Text("Edit"),
                                      ),
                                    ),

                                    SizedBox(height: 8),

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
                                          style: Get.textTheme.bodyMedium!
                                              .copyWith(color: Colors.red),
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
                                  return Text("No report available");
                                }

                                return Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    // 📦 HEADER
                                    ListTile(
                                      contentPadding: EdgeInsets.zero,
                                      title: Text(report.studentName),
                                      subtitle: Text("Session Report"),
                                      trailing: TextButton.icon(
                                        onPressed: () =>
                                            c.openSessionReportDialog(data),
                                        icon: const Icon(Icons.edit, size: 18),
                                        label: Text("Edit Report"),
                                      ),
                                    ),

                                    SizedBox(height: 8),

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
                if (data.status != 'completed')
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
                        if ((!isCustom ||
                            PermissionService.can("edit_sessions")))
                          Expanded(
                            child: DetailActionButton(
                              label: "Edit",
                              icon: Icons.edit_outlined,
                              color: cs.secondary,
                              onTap: () => editSession(context, data),
                            ),
                          ),
                        SizedBox(width: 8),
                        Expanded(
                          child: DetailActionButton(
                            label: "Support",
                            icon: Icons.support_agent_outlined,
                            color: cs.tertiary,
                            onTap: () => _addSupport(context),
                          ),
                        ),
                        if (data.status == 'pending') ...[
                          SizedBox(width: 8),
                          Expanded(
                            child: DetailActionButton(
                              label: "Complete",
                              icon: Icons.check_outlined,
                              color: cs.primary,
                              onTap: () => _markSessionCompleted(
                                context,
                                data.date ?? DateTime.now(),
                              ),
                            ),
                          ),
                        ],
                        if (!isCoordinator) ...[
                          SizedBox(width: 8),
                          Expanded(
                            child: DetailActionButton(
                              label: "Delete",
                              icon: Icons.delete_outline,
                              color: cs.error,
                              onTap: () => CustomWidgets().showDeleteDialog(
                                title: 'Are you sure?',
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

                SizedBox(height: 10),

                if (data.status == 'started')
                  Row(
                    children: [
                      Expanded(
                        child: DetailActionButton(
                          onTap: () {},
                          icon: Icons.arrow_forward_rounded,
                          label: "Join",
                          color: cs.primary,
                        ),
                      ),
                      SizedBox(width: 10),
                      Expanded(
                        child: DetailActionButton(
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
              style: Get.textTheme.bodySmall!.copyWith(
                  color: Get.theme.colorScheme.onSurface.withOpacity(0.6)),
            ),
          ),
          Expanded(
            child: Text(
              value ?? "-",
              style: Get.textTheme.titleSmall,
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
        SizedBox(width: 6),
        Text(
          text,
          style: Get.textTheme.titleSmall,
        ),
      ],
    );
  }

  // ── SUPPORT TICKET DIALOG ─────────────────────────────────────────────
  void _addSupport(BuildContext context) {
    CustomWidgets().showCustomDialog(
      context: context,
      title: Text('Add New Ticket'),
     submitWidget: Text(
      "Add",
      style:
          Theme.of(context).textTheme.bodyMedium!.copyWith(color: Colors.white),
    ),
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
                SizedBox(height: 8),
                CustomWidgets().dropdownStyledTextField(
                    context: context,
                    hint: 'Enter ticket title',
                    controller: c.titleController),
                SizedBox(height: 12),
                CustomWidgets().labelWithAsterisk('Category', required: true),
                SizedBox(height: 8),
                CustomWidgets().customDropdownField(
                  context: context,
                  hint: 'Select category',
                  itemLabel: (item) => item,
                  items: c.categoryList,
                  onChanged: (p0) {},
                ),
                SizedBox(height: 12),
                CustomWidgets().labelWithAsterisk('Priority', required: true),
                SizedBox(height: 8),
                CustomWidgets().customDropdownField(
                  context: context,
                  hint: 'Select priority',
                  itemLabel: (item) => item,
                  items: ['High', 'Medium', 'Low'],
                  onChanged: (p0) {},
                ),
                SizedBox(height: 12),
                CustomWidgets().labelWithAsterisk('User', required: true),
                SizedBox(height: 8),
                Obx(() => Row(
                      children: [
                        Expanded(
                          child: RadioListTile(
                            dense: true,
                            title: Text('Student'),
                            value: "student",
                            groupValue: c.selectedType.value,
                            onChanged: (value) {
                              if (value != null) {
                                c.selectedType.value = value;
                              }
                            },
                          ),
                        ),
                        Expanded(
                          child: RadioListTile(
                            dense: true,
                            title: Text('Teacher'),
                            value: "teacher",
                            groupValue: c.selectedType.value,
                            onChanged: (value) => c.selectedType.value = value!,
                          ),
                        ),
                      ],
                    )),
                SizedBox(height: 8),
                Obx(() {
                  if (c.selectedType.value == 'student') {
                    return CustomWidgets().customDropdownField(
                        items: c.studentsList,
                        onChanged: (p0) {},
                        context: context,
                        itemLabel: (item) => item.name,
                        hint: 'Select student');
                  }
                  if (c.selectedType.value == 'teacher') {
                    return CustomWidgets().customDropdownField<Teacher>(
                        items: c.teacherList,
                        onChanged: (p0) {},
                        context: context,
                        itemLabel: (item) => item.name,
                        hint: 'Select teacher');
                  }
                  return SizedBox();
                }),
                SizedBox(height: 12),
                CustomWidgets().labelWithAsterisk('Attachment'),
                SizedBox(height: 8),
                CustomWidgets().attachmentStyledField(
                  context: context,
                  label: "Attachment",
                  hint: "Choose a file",
                  fileName: c.selectedFile,
                  onTap: () {},
                  onClear: () {},
                ),
                SizedBox(height: 12),
                CustomWidgets()
                    .labelWithAsterisk('Description', required: true),
                SizedBox(height: 8),
                CustomWidgets().dropdownStyledTextField(
                  context: context,
                  hint: 'Describe the issue...',
                  controller: c.descriptionController,
                  isMultiline: true,
                ),
                SizedBox(height: 16),
              ],
            ),
          ),
        ),
      ],
      onSubmit: () {},
    );
  }

  // ── EDIT SESSION DIALOG ───────────────────────────────────────────────
  void editSession(BuildContext context, Session data) {
    // Local values for edit form only
    final selectedTeacher = Rxn<Teacher>(data.teacher);
    final selectedDate = Rxn<DateTime>(data.date);
    final selectedTime = Rxn<TimeOfDay>();
    final selectedDuration = RxInt(data.duration ?? 0);

    // Controllers
    c.dateController.text = DateFormat('dd/MM/yyyy').format(data.date!);

    c.salaryController.text = data.teacherSalary?.toString() ?? '';

    CustomWidgets().showCustomDialog(
      context: context,
      title: Text('Edit Session'),
      icon: Icons.edit_outlined,
      submitWidget: Text(
      "Update",
      style:
          Theme.of(context).textTheme.bodyMedium!.copyWith(color: Colors.white),
    ),
      formKey: GlobalKey<FormState>(),
      sections: [
        DialogSectionCard(
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
                    SizedBox(height: 8),
                    CustomWidgets().customStyledDatePickerField(
                      context: context,
                      controller: c.dateController,
                      firstDate: DateTime.now(),
                      lastDate: DateTime(2030),
                      onDateSelected: (date) {
                        selectedDate.value = date;
                      },
                    ),
                  ],
                ),
              ),
              SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    CustomWidgets()
                        .labelWithAsterisk('Session Time', required: true),
                    SizedBox(height: 8),
                    CustomWidgets().timePickerStyledField(
                      selectedTime: selectedTime,
                      context: context,
                      hint: 'Time',
                      controller: c.timeController,
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
        SizedBox(height: 12),
        DialogSectionCard(
          icon: Icons.school_outlined,
          title: "Session Details",
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              CustomWidgets().labelWithAsterisk('Duration', required: true),
              SizedBox(height: 8),
              CustomWidgets().customDropdownField<String>(
                context: context,
                hint: 'Select Duration',
                itemLabel: (item) => item,
                items: c.durationOptions.map((e) => "$e minutes").toList(),
                value: "${data.duration} minutes",
                onChanged: (p0) {
                  selectedDuration.value = int.tryParse(
                        p0.split(" ").first ?? "0",
                      ) ??
                      0;
                },
              ),
              SizedBox(height: 12),
              CustomWidgets().labelWithAsterisk('Teacher', required: true),
              SizedBox(height: 8),
              Obx(
                () => CustomWidgets().customDropdownField<Teacher>(
                  context: context,
                  hint: 'Select Teacher',
                  itemLabel: (item) => item.name,
                  items: c.teacherList,
                  value: selectedTeacher.value,
                  onChanged: (p0) {
                    selectedTeacher.value = p0;
                  },
                ),
              ),
            ],
          ),
        ),
        SizedBox(height: 12),
        DialogSectionCard(
          icon: Icons.payments_outlined,
          title: "Payment",
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              CustomWidgets().labelWithAsterisk(
                'Teacher Salary (per hour — optional)',
              ),
              SizedBox(height: 8),
              CustomWidgets().dropdownStyledTextField(
                isNumber: true,
                context: context,
                hint: 'Enter teacher salary',
                controller: c.salaryController,
              ),
            ],
          ),
        ),
      ],
      onSubmit: () {
        // use selectedTeacher.value
        // use selectedDate.value
        // use selectedDuration.value
      },
    );
  }

  Color getStatusColor(BuildContext context, String status) {
    final cs = Get.theme.colorScheme;
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
      title: Text('Mark Session as Completed'),
      formKey: GlobalKey<FormState>(),
      sections: [
        Column(
          children: [
            CustomWidgets().labelWithAsterisk('Session Date', required: true),
            SizedBox(height: 8),
            CustomWidgets().customDatePickerField(
                context: context,
                selectedDate: c.selectedDate,
                controller: c.dateController),
            SizedBox(width: 12),
            CustomWidgets().labelWithAsterisk('Start Time', required: true),
            SizedBox(height: 8),
            CustomWidgets().timePickerStyledField(
                selectedTime: c.selectedTime,
                context: context,
                hint: 'Time',
                controller: c.timeController),
            SizedBox(height: 12),
            CustomWidgets().labelWithAsterisk('Duration', required: true),
            SizedBox(height: 8),
            CustomWidgets().customDropdownField(
              itemLabel: (item) => item,
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
      submitWidget: Text(
      "Close",
      style:
          Theme.of(Get.context!).textTheme.bodyMedium!.copyWith(color: Colors.white),
    ),

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

        SizedBox(height: 14),

        // 👥 MEMBERS HEADER
        _sectionLabel("Members", Icons.group_outlined),

        SizedBox(height: 8),

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
                SizedBox(width: 10),

                // NAME + EMAIL
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        m.name ?? "-",
                        style: Get.textTheme.titleSmall,
                      ),
                      Text(
                        m.email ?? "-",
                        style: Get.textTheme.bodySmall!.copyWith(
                            color: Get.theme.colorScheme.onSurface
                                .withOpacity(0.6)),
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
                    style: Get.textTheme.labelSmall!
                        .copyWith(color: Get.theme.colorScheme.secondary),
                  ),
                ),
              ],
            ),
          );
        }),
      ],
    );
  }
}

// ═══════════════════════════════════════════════════════════════════════
// SESSION CARD
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
    final cs = Get.theme.colorScheme;
    final textPrimary = cs.onSurface;
    final textSecondary = cs.onSurface.withOpacity(0.5);
    final auth = Get.find<AuthController>();
    final user = auth.activeUser;

    final isStudent = user?.role == 'student';
    final isTeacher = user?.role == 'teacher';

    return Material(
      color: cs.onPrimary,
      borderRadius: BorderRadius.circular(16),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(10),
        hoverColor: cs.onSurface.withOpacity(0.03),
        splashColor: Colors.transparent,
        highlightColor: Colors.transparent,
        child: Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10),
            border: Border.all(
              color: cs.outline.withOpacity(0.5),
              width: 1,
            ),
          ),
          child: Padding(
            padding: const EdgeInsets.all(14.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
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
                              style: Get.textTheme.labelSmall!.copyWith(
                                  fontFamily: 'monospace',
                                  color: textSecondary,
                                  letterSpacing: 0.3),
                            ),
                          ),
                          StatusBadge(
                              status: session.status, color: statusColor),
                        ],
                      ),

                      SizedBox(height: 8),

                      Divider(
                        height: 16,
                        thickness: 0.8,
                        color: cs.outline.withOpacity(0.12),
                      ),

                      SizedBox(height: 10),

                      // ── Row 2: Student / Teacher with profile pictures ────────────
                      Row(
                        children: [
                          // ── Student ─────────────────────────────
                          Expanded(
                            child: Row(
                              children: [
                                ClipRRect(
                                  borderRadius: BorderRadius.circular(6),
                                  child: Image.asset(
                                    "assets/images/logo.png",
                                    width: 34,
                                    height: 34,
                                    fit: BoxFit.contain,
                                  ),
                                ),
                                SizedBox(width: 8),
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        session.student?.name ?? "—",
                                        style: Get.textTheme.titleSmall!
                                            .copyWith(color: textPrimary),
                                        overflow: TextOverflow.ellipsis,
                                      ),
                                      SizedBox(height: 2),
                                      Text(
                                        "ID: ${session.student?.studentId ?? '—'}",
                                        style: Get.textTheme.labelSmall!
                                            .copyWith(
                                                color: textSecondary,
                                                fontFamily: 'monospace'),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),

                          SizedBox(width: 12),

                          // ── Teacher ─────────────────────────────
                          Expanded(
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.end,
                              children: [
                                ClipRRect(
                                  borderRadius: BorderRadius.circular(6),
                                  child: Image.asset(
                                    "assets/images/logo.png",
                                    width: 34,
                                    height: 34,
                                    fit: BoxFit.contain,
                                  ),
                                ),
                                SizedBox(width: 8),
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        session.teacher?.name ?? "—",
                                        style: Get.textTheme.titleSmall!
                                            .copyWith(color: textPrimary),
                                        overflow: TextOverflow.ellipsis,
                                        textAlign: TextAlign.right,
                                      ),
                                      SizedBox(height: 2),
                                      Text(
                                        "ID: ${session.teacher?.id ?? '—'}",
                                        style: Get.textTheme.labelSmall!
                                            .copyWith(
                                                color: textSecondary,
                                                fontFamily: 'monospace'),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(vertical: 10),
                        child: Divider(
                          height: 16,
                          thickness: 0.8,
                          color: cs.outline.withOpacity(0.12),
                        ),
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
                                    value: session.package?.subjectName ?? "—",
                                    textSecondary: textSecondary),
                                SizedBox(height: 4),
                                MetaItem(
                                    label: "Class",
                                    value: session.className ?? "—",
                                    textSecondary: textSecondary),
                              ],
                            ),
                          ),
                          SizedBox(width: 12),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                MetaItem(
                                    label: "Date",
                                    value: formatDate(
                                        session.date ?? DateTime.now()),
                                    textSecondary: textSecondary),
                                SizedBox(height: 4),
                                MetaItem(
                                    label: "Time",
                                    value: formatTime(
                                      TimeOfDay.fromDateTime(
                                          session.date ?? DateTime.now()),
                                    ),
                                    textSecondary: textSecondary),
                              ],
                            ),
                          ),
                        ],
                      ),
                      if (isStudent || isTeacher) ...[
                        SizedBox(height: 10),
                        TextButton.icon(
                          onPressed: () =>
                              _openRescheduleDialog(context, session),
                          icon: const Icon(
                            Icons.schedule,
                            size: 18,
                            color: Colors.white,
                          ),
                          label: Text(
                            "Reschedule",
                            style: Get.textTheme.bodySmall!
                                .copyWith(color: Colors.white),
                          ),
                          style: TextButton.styleFrom(
                            backgroundColor: cs.primary.withOpacity(0.8),
                            elevation: 0,
                            padding: const EdgeInsets.symmetric(
                              vertical: 16,
                              horizontal: 16,
                            ),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
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
      title: Text("Reschedule Session"),
     submitWidget: Text(
      "Reschedule",
      style:
          Theme.of(context).textTheme.bodyMedium!.copyWith(color: Colors.white),
    ),
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

            SizedBox(height: 6),
            CustomWidgets().dropdownStyledTextField(
                context: context,
                hint: 'Enter reason...',
                controller: reasonController,
                isMultiline: true),

            SizedBox(height: 12),

            // 📅 New Date
            CustomWidgets().labelWithAsterisk("New Date", required: true),

            SizedBox(height: 6),
            CustomWidgets().dropdownStyledTextField(
              context: context,
              hint: "Select date",
              controller: dateController,
            ),
            SizedBox(height: 12),

            // ⏰ New Time
            CustomWidgets().labelWithAsterisk("New Time", required: true),

            SizedBox(height: 6),
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
    final auth = Get.find<AuthController>();
    final role = auth.activeUser?.role;
    final isStudent = role == 'student';

    final isCustom = ![
      "admin",
      "mentor",
      "advisor",
      "teacher",
      "student",
      "coordinator",
      "finance",
      "sales",
      "hr"
    ].contains(role);
    return HeaderWithSearch(
      title: "Sessions",
      hint: "Search sessions...",
      isSearching: c.isSearching,
      searchQuery: c.searchQuery,
      onSearchChanged: () => c.applyFilters(),
      onSortTap: () => CustomWidgets().showSortSheet<SessionSortType>(
        title: "Sort Sessions",
        options: [
          SortOption(
            label: "Latest First",
            value: SessionSortType.newest,
            icon: Icons.schedule,
          ),
          SortOption(
            label: "Oldest First",
            value: SessionSortType.oldest,
            icon: Icons.history,
          ),
          SortOption(
            label: "Student Name",
            value: SessionSortType.student,
            icon: Icons.person_outline,
          ),
          SortOption(
            label: "Teacher Name",
            value: SessionSortType.teacher,
            icon: Icons.school_outlined,
          ),
        ],
        selectedValue: c.sortType.value,
        onSelected: (val) {
          c.sortType.value = val;
          c.applyFilters();
        },
      ),
      requestCount: 15,
      onRequestTap: (!isStudent &&
              (!isCustom || PermissionService.can("reschedule_requests")))
          ? () => Get.to(() => RescheduleRequestsPage())
          : null,
    );
  }
}

