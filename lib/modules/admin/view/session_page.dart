import 'package:albedo_app/controller/session_controller.dart';
import 'package:albedo_app/model/session_model.dart';
import 'package:albedo_app/widgets/responsive.dart';
import 'package:albedo_app/widgets/widgets.dart';
import 'package:albedo_app/widgets/custom_appbar.dart';
import 'package:albedo_app/widgets/custom_card.dart';
import 'package:albedo_app/widgets/drawer_menu.dart';
import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:get/get.dart';

class SessionPage extends StatelessWidget {
  final c = Get.put(SessionController());

  SessionPage({super.key});

  @override
  Widget build(BuildContext context) {
    final isDesktop = Responsive.isDesktop(context);

    return Scaffold(
      appBar: Responsive.isMobile(context) ? const CustomAppBar() : null,
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
                        return const Center(child: Text("No sessions found"));
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
                            itemBuilder: (_, i) => InfoCard(
                              id: data[i].id,
                              status: data[i].status,
                              statusColor:
                                  getStatusColor(context, data[i].status),
                              infoRows: [
                                _buildPersonSection(context, data[i]),
                                _buildDetailsSection(context, data[i]),
                              ],
                              actions: [
                                CustomWidgets().iconBtn(
                                    icon: Icons.edit,
                                    color:
                                        Theme.of(context).colorScheme.primary,
                                    onTap: () {
                                      final session = data[i];

                                      c.loadSession(session);

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
                                                  children: [
                                                    Expanded(
                                                        child: CustomWidgets()
                                                            .dropdownStyledTextField(
                                                      context: context,
                                                      hint: 'Date',
                                                      controller:
                                                          c.dateController,
                                                    )),
                                                    const SizedBox(width: 10),
                                                    Expanded(
                                                        child: CustomWidgets()
                                                            .dropdownStyledTextField(
                                                                context:
                                                                    context,
                                                                hint:
                                                                    'Enter Time',
                                                                controller: c
                                                                    .timeController)),
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
                                                    /// Duration
                                                    CustomWidgets()
                                                        .customDropdownField(
                                                            context: context,
                                                            hint:
                                                                'Select Duration',
                                                            value: c
                                                                .selectedDuration
                                                                .value,
                                                            items: [],
                                                            onChanged: (p0) => c
                                                                .selectedDuration
                                                                .value = p0),

                                                    const SizedBox(height: 12),

                                                    /// Teacher
                                                    CustomWidgets()
                                                        .customDropdownField(
                                                            context: context,
                                                            hint:
                                                                'Select Teacher',
                                                            items: [],
                                                            value: c
                                                                .selectedTeacher
                                                                .value,
                                                            onChanged: (p0) => c
                                                                .selectedTeacher
                                                                .value = p0),
                                                  ],
                                                ),
                                              ),

                                              const SizedBox(height: 14),

                                              /// 🔹 SECTION: PAYMENT
                                              _sectionCard(
                                                icon: Icons.payments_outlined,
                                                title: "Payment",
                                                child: CustomWidgets()
                                                    .dropdownStyledTextField(
                                                        context: context,
                                                        hint:
                                                            'Enter Teacher Salary',
                                                        controller:
                                                            c.salaryController),
                                              ),
                                            ],
                                          ),
                                        ],
                                        onSubmit: () {},
                                      );
                                    }),
                                CustomWidgets().iconBtn(
                                  icon: Icons.delete,
                                  color: Theme.of(context).colorScheme.error,
                                  onTap: () => CustomWidgets().showDeleteDialog(
                                    onConfirm: () {},
                                  ),
                                ),
                              ],
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
                            hint: 'Select Student',
                            items: c.studentList,
                            onChanged: (p0) => c.selectedStudent.value = p0,
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
                            onChanged: (p0) => c.selectedTeacher.value = p0,
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
                          CustomWidgets().customDropdownField(
                            context: context,
                            hint: 'Select Duration',
                            items: [],
                            onChanged: (p0) {},
                          ),
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
                                          .assignAll(c.studentList);
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
                                  'Select Students (${c.studentList.length} available)',
                              items: c.studentList,
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

  Widget _buildDetailsSection(BuildContext context, data) {
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
                        _miniInfo(context, "Subject", data.subject),
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
                          _miniInfo(context, "Subject", data.subject),
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
            style: const TextStyle(fontSize: 13),
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
          style: TextStyle(
              fontSize: 10, color: Theme.of(context).colorScheme.outline),
        ),
        const SizedBox(height: 2),
        Text(
          value,
          style: const TextStyle(
            fontSize: 12,
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
          style: TextStyle(
              fontSize: 10, color: Theme.of(context).colorScheme.outline),
        ),
        const SizedBox(height: 2),
        Text(
          name,
          style: const TextStyle(
            fontSize: 13,
            fontWeight: FontWeight.w600,
          ),
          overflow: TextOverflow.ellipsis,
        ),
        Text(
          id,
          style: TextStyle(
              fontSize: 11, color: Theme.of(context).colorScheme.outline),
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
