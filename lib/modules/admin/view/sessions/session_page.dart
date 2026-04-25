import 'package:albedo_app/controller/session_controller.dart';
import 'package:albedo_app/model/session_model.dart';
import 'package:albedo_app/model/users/advisor_model.dart';
import 'package:albedo_app/model/users/coordinator_model.dart';
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
                            padding: const EdgeInsets.symmetric(vertical: 6),
                            crossAxisCount: crossAxisCount,
                            itemCount: data.length,
                            itemBuilder: (_, i) => InkWell(
                              onTap: () =>
                                  _openSessionDetails(context, data, i),
                              child: InfoCard(
                                id: data[i].id,
                                status: data[i].status,
                                statusColor:
                                    getStatusColor(context, data[i].status),
                                infoRows: [
                                  _buildPersonSection(context, data[i]),
                                  _buildDetailsSection(context, data[i]),
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

  void _openSessionDetails(
    BuildContext context,
    List<Session> sessions,
    int currentIndex,
  ) {
    int index = currentIndex;
    CustomWidgets().showCustomDialog(
      context: context,
      title: const Text("Session Details"),
      icon: Icons.visibility,
      formKey: GlobalKey<FormState>(),
      submitText: "Close",
      onSubmit: () {},
      sections: [
        StatefulBuilder(
          builder: (context, setState) {
            final data = sessions[index];

            return SizedBox(
              height: MediaQuery.of(context).size.height * 0.75,
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      IconButton(
                        onPressed:
                            index > 0 ? () => setState(() => index--) : null,
                        icon: const Icon(Icons.arrow_back_ios),
                      ),
                      Text(
                        "Session ${index + 1}/${sessions.length}",
                        style: Theme.of(context).textTheme.labelMedium,
                      ),
                      IconButton(
                        onPressed: index < sessions.length - 1
                            ? () => setState(() => index++)
                            : null,
                        icon: const Icon(Icons.arrow_forward_ios),
                      ),
                    ],
                  ),
                  const SizedBox(height: 6),
                  Expanded(
                    child: SingleChildScrollView(
                      child: Column(
                        children: [
                          detailCard(
                            context,
                            title: "Student",
                            name: data.student?.name ?? '',
                            id: data.student?.studentId ?? '',
                            onTap: () => _onUserTap(
                                context, "student", data.student?.studentId),
                          ),
                          detailCard(
                            context,
                            title: "Teacher",
                            name: data.teacher?.name ?? '',
                            id: data.teacher?.id ?? '',
                            onTap: () => _onUserTap(
                                context, "teacher", data.teacher?.id),
                          ),
                          detailCard(
                            context,
                            title: "Mentor",
                            name: data.mentor?.name ?? "-",
                            id: data.mentor?.id ?? "-",
                            onTap: () =>
                                _onUserTap(context, "mentor", data.mentor?.id),
                          ),
                          detailCard(
                            context,
                            title: "Coordinator",
                            name: data.coordinator?.name ?? "-",
                            id: data.coordinator?.id ?? "-",
                            onTap: () => _onUserTap(
                                context, "coordinator", data.coordinator?.id),
                          ),
                          detailCard(
                            context,
                            title: "Advisor",
                            name: data.advisor?.name ?? "-",
                            id: data.advisor?.id ?? "-",
                            onTap: () => _onUserTap(
                                context, "advisor", data.advisor?.id),
                          ),
                          const SizedBox(height: 10),
                          EditableInfoCard(
                            type: "schedule",
                            icon: Icons.schedule,
                            title: "Schedule",
                            date: formatDate(data.date),
                            time: formatTime(data.time),
                            duration: data.duration?.toString() ?? "-",
                            onSave: (date, time) {
                              // update
                            },
                          ),
                          infoCard(
                            context,
                            type: "session",
                            icon: Icons.menu_book,
                            title: "Session Info",
                            children: [
                              infoRow(label: "Subject",value: data.package ?? "-"),
                              infoRow(label: "Syllabus",value: data.syllabus ?? "-"),
                            ],
                          ),
                          infoCard(
                            context,
                            type: "status",
                            icon: Icons.flag,
                            title: "Status",
                            children: [
                              infoRow(label: "Current Status",value:  data.status),
                            ],
                          ),
                          const SizedBox(height: 10),
                          if (data.status != 'completed' &&
                              data.status != 'meet_done')
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                SizedBox(
                                  width: 110,
                                  child: ElevatedButton.icon(
                                    onPressed: () {
                                      c.loadSession(data);
                                      editSession(context);
                                    },
                                    icon: const Icon(Icons.edit,
                                        size: 16, color: Colors.white),
                                    label: const Text("Edit",
                                        style: TextStyle(color: Colors.white)),
                                    style: ElevatedButton.styleFrom(
                                      backgroundColor: Theme.of(context)
                                          .colorScheme
                                          .secondary,
                                    ),
                                  ),
                                ),
                                const SizedBox(width: 8),
                                SizedBox(
                                  width: 110,
                                  child: ElevatedButton.icon(
                                    onPressed: () {
                                      CustomWidgets().showDeleteDialog(
                                        text:
                                            'Are you sure you want to delete this session permanently?',
                                        context: context,
                                        onConfirm: () => c.delete(data.id),
                                      );
                                    },
                                    icon: const Icon(Icons.delete,
                                        size: 16, color: Colors.white),
                                    label: const Text("Delete",
                                        style: TextStyle(color: Colors.white)),
                                    style: ElevatedButton.styleFrom(
                                      backgroundColor: Theme.of(context)
                                          .colorScheme
                                          .errorContainer,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                        ],
                      ),
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
          openTeacherProfile(
            context,
            t,
            toUser: (p0) => teacherToUser(t),
          );
        } else {
          Get.snackbar("Error", "Teacher not found for ID: $id");
        }
      },
      "mentor": () {
        final m = c.getMentorById(id);
        if (m != null) {
          openMentorProfile(
            context,
            m,
            (p0) => c.mentorToUser(m),
          );
        }
      },
      "coordinator": () {
        final c1 = c.getCoordinatorById(id);
        if (c1 != null) {
          openCoordinatorProfile(
            context,
            c1,
            (p0) => coordinatorToUser(c1),
          );
        }
      },
      "advisor": () {
        final a = c.getAdvisorById(id);
        if (a != null) {
          openAdvisorProfile(
            context,
            a,
            (p0) => advisorToUser(a),
          );
        }
      },
    };

    if (handlers.containsKey(role)) {
      handlers[role]!();
    } else {
      Get.snackbar("Error", "$role not found");
    }
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

  Widget _buildPersonSection(BuildContext context, Session data) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final isSmall = constraints.maxWidth < 320;

        return isSmall
            ? Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  _personCompact(context, "Student", data.student?.name ?? '',
                      data.student?.studentId ?? ''),
                  const SizedBox(height: 8),
                  _personCompact(context, "Teacher", data.teacher?.name ?? '',
                      data.teacher?.id ?? ''),
                ],
              )
            : Row(
                children: [
                  Expanded(
                    child: _personCompact(
                        context,
                        "Student",
                        data.student?.name ?? '',
                        data.student?.studentId ?? ''),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: _personCompact(context, "Teacher",
                        data.teacher?.name ?? '', data.teacher?.id ?? ''),
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
                        _miniInfo(context, "Date", formatDate(data.date)),
                        SizedBox(height: 10),
                        _miniInfo(context, "Time", formatTime(data.time)),
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
                          _miniInfo(context, "Date", formatDate(data.date)),
                          const SizedBox(height: 6),
                          _miniInfo(context, "Time", formatTime(data.time)),
                        ],
                      ),
                    ),
                  ],
                ),
        );
      },
    );
  }

  Widget _topBar(BuildContext context, SessionController c) {
    final isMobile = Responsive.isMobile(context);

    return Obx(() {
      final searching = c.isSearching.value;

      if (isMobile) {
        return Column(
          children: [
            Row(
              children: [
                const SizedBox(width: 10),
                if (!searching)
                  Expanded(
                    child: Text(
                      "Sessions",
                      style: Theme.of(context).textTheme.titleLarge,
                    ),
                  )
                else
                  Expanded(
                    child: CustomWidgets().premiumSearch(
                      context,
                      hint: "Search sessions...",
                      onChanged: (val) => c.searchQuery.value = val,
                    ),
                  ),
                IconButton(
                  icon: Icon(searching ? Icons.close : Icons.search),
                  onPressed: () {
                    c.isSearching.value = !searching;
                    if (!searching == false) {
                      c.searchQuery.value = "";
                    }
                  },
                ),
              ],
            ),
            const SizedBox(height: 10),
            if (!searching)
              Row(
                children: [
                  Expanded(child: _filterButton(context, c)),
                  const SizedBox(width: 10),
                  Expanded(child: _sortButton(context, c)),
                ],
              ),
          ],
        );
      }

      return Row(
        children: [
          if (!searching)
            Expanded(
              flex: 2,
              child: Text(
                "Sessions",
                style: Theme.of(context).textTheme.titleLarge,
              ),
            )
          else
            Expanded(
              flex: 3,
              child: CustomWidgets().premiumSearch(
                context,
                hint: "Search sessions...",
                onChanged: (val) => c.searchQuery.value = val,
              ),
            ),
          IconButton(
            icon: Icon(searching ? Icons.close : Icons.search),
            onPressed: () {
              c.isSearching.value = !searching;
              if (!searching == false) {
                c.searchQuery.value = "";
              }
            },
          ),
          if (!searching) ...[
            const SizedBox(width: 12),
            _filterButton(context, c),
            const SizedBox(width: 8),
            _sortButton(context, c),
          ],
        ],
      );
    });
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

  Widget _filterButton(BuildContext context, SessionController c) {
    return GestureDetector(
      onTap: () => CustomWidgets().showFilterSheet(
        title: "Filter Sessions",
        options: _filterOptions,
        selectedValue: c.filterType.value,
        onSelected: (val) => c.filterType.value = val,
      ),
      child: _actionButton(context, Icons.filter_list, "Filter"),
    );
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

final List<FilterOption> _filterOptions = [
  FilterOption(label: "All", value: FilterType.all, icon: Icons.schedule),
  FilterOption(
      label: "Class Session",
      value: FilterType.classSession,
      icon: Icons.class_),
  FilterOption(
      label: "Meet Session",
      value: FilterType.meetSession,
      icon: Icons.handshake),
];
