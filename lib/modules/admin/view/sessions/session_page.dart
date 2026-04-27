import 'package:albedo_app/controller/auth_controller.dart';
import 'package:albedo_app/controller/session_controller.dart';
import 'package:albedo_app/model/session_model.dart';
import 'package:albedo_app/widgets/responsive.dart';
import 'package:albedo_app/widgets/session_widgets.dart';
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
                      getCount: (index) => c.sessions
                          .where((e) => e.status == c.statusMap[index])
                          .length,
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
                      final data = c.filteredSessions;

                      if (c.isLoading.value) {
                        return Center(
                          child: CircularProgressIndicator(
                            color: cs.primary,
                            strokeWidth: 2.5,
                          ),
                        );
                      }

                      if (data.isEmpty) {
                        return EmptyState(
                          cs: cs,
                          icon: Icons.event_busy_outlined,
                          title: 'No sessions found',
                          subtitle: 'Try adjusting filters or add a session',
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
                            itemCount: data.length,
                            itemBuilder: (_, i) => _SessionCard(
                              session: data[i],
                              statusColor:
                                  getStatusColor(context, data[i].status),
                              onTap: () =>
                                  _openSessionDetails(context, data, i),
                            ),
                          );
                        },
                      );
                    }),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  // ── SESSION DETAIL DIALOG ────────────────────────────────────────────
  void _openSessionDetails(
    BuildContext context,
    List<Session> sessions,
    int currentIndex,
  ) {
    final auth = Get.find<AuthController>();
    final isCoordinator = auth.activeUser?.role == "coordinator";

    CustomWidgets().showCustomDialog(
      isViewOnly: true,
      context: context,
      title: const Text("Session Details"),
      icon: Icons.visibility_outlined,
      formKey: GlobalKey<FormState>(),
      submitText: "Close",
      onSubmit: () {},
      sections: [
        StatefulBuilder(
          builder: (context, setState) {
            final data = sessions[currentIndex];
            final cs = Theme.of(context).colorScheme;

            return SizedBox(
              height: MediaQuery.of(context).size.height * 0.75,
              child: Column(
                children: [
                  Expanded(
                    child: SingleChildScrollView(
                      padding: const EdgeInsets.fromLTRB(0, 4, 0, 16),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // People section label
                          _DetailSectionLabel(
                              label: "Participants",
                              icon: Icons.people_outline),
                          const SizedBox(height: 8),

                          detailCard(context,
                              title: "Student",
                              name: data.student?.name ?? '',
                              id: data.student?.studentId ?? '',
                              onTap: () => _onUserTap(
                                  context, "student", data.student?.studentId)),
                          detailCard(context,
                              title: "Teacher",
                              name: data.teacher?.name ?? '',
                              id: data.teacher?.id ?? '',
                              onTap: () => _onUserTap(
                                  context, "teacher", data.teacher?.id)),
                          detailCard(context,
                              title: "Mentor",
                              name: data.mentor?.name ?? "-",
                              id: data.mentor?.id ?? "-",
                              onTap: () => _onUserTap(
                                  context, "mentor", data.mentor?.id)),
                          detailCard(context,
                              title: "Coordinator",
                              name: data.coordinator?.name ?? "-",
                              id: data.coordinator?.id ?? "-",
                              onTap: () => _onUserTap(context, "coordinator",
                                  data.coordinator?.id)),
                          detailCard(context,
                              title: "Advisor",
                              name: data.advisor?.name ?? "-",
                              id: data.advisor?.id ?? "-",
                              onTap: () => _onUserTap(
                                  context, "advisor", data.advisor?.id)),

                          const SizedBox(height: 16),
                          _DetailSectionLabel(
                              label: "Schedule & Info",
                              icon: Icons.event_outlined),
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
                                  label: "Subject", value: data.package ?? "-"),
                              infoRow(
                                  label: "Syllabus",
                                  value: data.syllabus ?? "-"),
                            ],
                          ),

                          const SizedBox(height: 16),
                          _DetailSectionLabel(
                              label: "Status", icon: Icons.flag_outlined),
                          const SizedBox(height: 8),

                          infoCard(
                            context,
                            type: "status",
                            icon: Icons.flag_outlined,
                            title: "Status",
                            children: [
                              infoRow(
                                  label: "Current Status", value: data.status),
                            ],
                          ),
                          const SizedBox(height: 8),
                        ],
                      ),
                    ),
                  ),

                  // ── ACTION BUTTONS ──────────────────────────────────
                  if (data.status != 'completed' && data.status != 'meet_done')
                    Container(
                      padding: const EdgeInsets.fromLTRB(0, 12, 0, 4),
                      decoration: BoxDecoration(
                        border: Border(
                          top: BorderSide(
                            color: cs.outlineVariant.withOpacity(0.4),
                            width: 1,
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
                ],
              ),
            );
          },
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
                CustomWidgets().dropdownStyledTextField(
                    context: context,
                    hint: 'Select category',
                    controller: c.categoryController),
                const SizedBox(height: 12),
                CustomWidgets().labelWithAsterisk('Priority', required: true),
                const SizedBox(height: 8),
                CustomWidgets().dropdownStyledTextField(
                    context: context,
                    hint: 'Select priority',
                    controller: c.priorityController),
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
                    return CustomWidgets().dropdownStyledTextField(
                        context: context, hint: 'Select student');
                  }
                  if (c.selectedType.value == 'teacher') {
                    return CustomWidgets().dropdownStyledTextField(
                        context: context, hint: 'Select teacher');
                  }
                  return const SizedBox();
                }),
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
                        CustomWidgets().dropdownStyledTextField(
                            context: context,
                            hint: 'Date',
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
                        CustomWidgets().dropdownStyledTextField(
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
                      value: c.selectedDuration.value,
                      items: [],
                      onChanged: (p0) => c.selectedDuration.value = p0),
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
        return cs.error; // red — needs attention
      case "completed":
        return cs.outline; // neutral grey
      case "meet_done":
        return cs.secondary; // purple
      default:
        return cs.outline;
    }
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
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
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
    final cs = Theme.of(context).colorScheme;
    final isMobile = Responsive.isMobile(context);

    return Obx(() {
      final searching = c.isSearching.value;

      Widget searchField = CustomWidgets().premiumSearch(
        context,
        hint: "Search sessions...",
        onChanged: (val) => c.searchQuery.value = val,
      );

      Widget pageTitle = Text(
        "Sessions",
        style: Theme.of(context).textTheme.titleLarge?.copyWith(
              fontWeight: FontWeight.w700,
              letterSpacing: -0.3,
            ),
      );

      Widget searchToggle = IconChip(
        icon: searching ? Icons.close : Icons.search_rounded,
        cs: cs,
        onTap: () {
          c.isSearching.value = !searching;
          if (!searching == false) c.searchQuery.value = "";
        },
      );

      Widget filterBtn = _ChipButton(
        icon: Icons.tune_rounded,
        label: "Filter",
        cs: cs,
        onTap: () => CustomWidgets().showFilterSheet(
          title: "Filter Sessions",
          options: _filterOptions,
          selectedValue: c.filterType.value,
          onSelected: (val) => c.filterType.value = val,
        ),
      );

      Widget sortBtn = _ChipButton(
        icon: Icons.swap_vert_rounded,
        label: "Sort",
        cs: cs,
        onTap: () => CustomWidgets().showSortSheet(
          title: "Sort Sessions",
          options: _sortOptions,
          selectedValue: c.sortType.value,
          onSelected: (val) => c.sortType.value = val,
        ),
      );

      if (isMobile) {
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                if (!searching) ...[
                  Expanded(child: pageTitle),
                ] else ...[
                  Expanded(child: searchField),
                ],
                const SizedBox(width: 8),
                searchToggle,
              ],
            ),
            if (!searching) ...[
              const SizedBox(height: 10),
              Row(
                children: [
                  Expanded(child: filterBtn),
                  const SizedBox(width: 8),
                  Expanded(child: sortBtn),
                ],
              ),
            ],
          ],
        );
      }

      return Row(
        children: [
          if (!searching) ...[
            pageTitle,
            const Spacer(),
          ] else ...[
            Expanded(flex: 3, child: searchField),
          ],
          const SizedBox(width: 10),
          searchToggle,
          if (!searching) ...[
            const SizedBox(width: 8),
            filterBtn,
            const SizedBox(width: 8),
            sortBtn,
          ],
        ],
      );
    });
  }
}

// ── Chip button (filter / sort) ───────────────────────────────────────
class _ChipButton extends StatelessWidget {
  final IconData icon;
  final String label;
  final ColorScheme cs;
  final VoidCallback onTap;

  const _ChipButton({
    required this.icon,
    required this.label,
    required this.cs,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        height: 40,
        padding: const EdgeInsets.symmetric(horizontal: 14),
        decoration: BoxDecoration(
          color: cs.surfaceContainerHighest.withOpacity(0.5),
          borderRadius: BorderRadius.circular(12),
          border:
              Border.all(color: cs.outlineVariant.withOpacity(0.5), width: 1),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, size: 16, color: cs.onSurface.withOpacity(0.75)),
            const SizedBox(width: 6),
            Text(
              label,
              style: TextStyle(
                fontSize: 13,
                fontWeight: FontWeight.w500,
                color: cs.onSurface.withOpacity(0.85),
              ),
            ),
          ],
        ),
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

// ─────────────────────────────────────────────────────────────
// SORT / FILTER OPTIONS
// ─────────────────────────────────────────────────────────────
final List<SortOption> _sortOptions = [
  SortOption(
      label: "Latest First", value: SortType.newest, icon: Icons.schedule),
  SortOption(
      label: "Oldest First", value: SortType.oldest, icon: Icons.history),
  SortOption(
      label: "Student Name",
      value: SortType.student,
      icon: Icons.person_outline),
  SortOption(
      label: "Teacher Name",
      value: SortType.teacher,
      icon: Icons.school_outlined),
];

final List<FilterOption> _filterOptions = [
  FilterOption(label: "All", value: FilterType.all, icon: Icons.all_inclusive),
  FilterOption(
      label: "Class Session",
      value: FilterType.classSession,
      icon: Icons.class_outlined),
  FilterOption(
      label: "Meet Session",
      value: FilterType.meetSession,
      icon: Icons.handshake_outlined),
];
