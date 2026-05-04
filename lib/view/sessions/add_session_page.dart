import 'package:albedo_app/controller/session_controller.dart';
import 'package:albedo_app/model/users/advisor_model.dart';
import 'package:albedo_app/model/users/coordinator_model.dart';
import 'package:albedo_app/model/users/mentor_model.dart';
import 'package:albedo_app/model/users/other_users_model.dart';
import 'package:albedo_app/model/users/student_model.dart';
import 'package:albedo_app/model/users/teacher_model.dart';
import 'package:albedo_app/widgets/custom_appbar.dart';
import 'package:albedo_app/widgets/drawer_menu.dart';
import 'package:albedo_app/widgets/responsive.dart';
import 'package:albedo_app/widgets/widgets.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class AddSessionPage extends StatelessWidget {
  const AddSessionPage({super.key});

  @override
  Widget build(BuildContext context) {
    final c = Get.find<SessionController>();
    final isDesktop = Responsive.isDesktop(context);

    return Scaffold(
      appBar: CustomAppBar(),
      body: Row(
        children: [
          if (isDesktop) const DrawerMenu(),
          Expanded(
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 800),
              child: SingleChildScrollView(
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(24, 24, 24, 24),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Add Session',
                        style: Theme.of(context).textTheme.titleLarge,
                      ),
                      const SizedBox(height: 10),
                      CustomWidgets()
                          .labelWithAsterisk('Session Type', required: true),
                      const SizedBox(height: 10),

                      /// TYPE SWITCH
                      Obx(
                        () => Row(
                          children: [
                            Expanded(
                              child: _buildTypeCard(
                                context: context,
                                title: "Class Session",
                                icon: Icons.class_,
                                value: "session",
                                selectedValue: c.selectedType.value,
                                onTap: () => c.selectedType.value = "session",
                              ),
                            ),
                            const SizedBox(width: 12),
                            Expanded(
                              child: _buildTypeCard(
                                context: context,
                                title: "Meet",
                                icon: Icons.video_call,
                                value: "meet",
                                selectedValue: c.selectedType.value,
                                onTap: () => c.selectedType.value = "meet",
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 16),

                      /// CONTENT
                      Obx(() {
                        if (c.selectedType.value == 'session') {
                          return _buildSessionForm(context, c);
                        } else {
                          return _buildMeetForm(context, c);
                        }
                      }),

                      const SizedBox(height: 20),

                      /// SUBMIT BUTTON
                      Row(
                        children: [
                          Expanded(
                            child: OutlinedButton.icon(
                              onPressed: () => Get.back(),
                              icon: const SizedBox.shrink(),
                              label: Text(
                                'Cancel',
                                style: TextStyle(
                                    color:
                                        Theme.of(context).colorScheme.onSurface,
                                    fontSize: 13),
                              ),
                              style: OutlinedButton.styleFrom(
                                backgroundColor:
                                    Theme.of(context).colorScheme.surface,
                                elevation: 0,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(12),
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(width: 10),
                          Expanded(
                            child: ElevatedButton.icon(
                              onPressed: () {
                                if (c.validateSession(context)) {
                                  c.addSession();
                                }
                              },
                              icon: const Icon(Icons.add,
                                  size: 15, color: Colors.white),
                              label: const Text(
                                'Add',
                                style: TextStyle(
                                    color: Colors.white, fontSize: 13),
                              ),
                              style: ElevatedButton.styleFrom(
                                backgroundColor:
                                    Theme.of(context).colorScheme.primary,
                                elevation: 0,
                                padding:
                                    const EdgeInsets.symmetric(vertical: 12),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(12),
                                ),
                              ),
                            ),
                          ),
                        ],
                      )
                    ],
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTypeCard({
    required BuildContext context,
    required String title,
    required IconData icon,
    required String value,
    required String selectedValue,
    required VoidCallback onTap,
  }) {
    final isSelected = value == selectedValue;
    final theme = Theme.of(context);
    final textTheme = theme.textTheme;

    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(12),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        decoration: BoxDecoration(
          color: isSelected
              ? theme.colorScheme.primary.withOpacity(0.1)
              : theme.colorScheme.onPrimary.withOpacity(0.8),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: isSelected
                ? theme.colorScheme.primary
                : theme.colorScheme.outline.withOpacity(0.3),
            width: isSelected ? 1.5 : 1,
          ),
        ),
        child: Row(
          children: [
            Icon(
              icon,
              size: 24,
              color: isSelected
                  ? theme.colorScheme.primary
                  : theme.colorScheme.onSurface.withOpacity(0.6),
            ),
            const SizedBox(width: 10),

            /// TEXT
            Expanded(
              child: Text(
                title,
                style: textTheme.bodyMedium?.copyWith(
                  fontWeight: FontWeight.w500,
                  color: isSelected
                      ? theme.colorScheme.primary
                      : theme.colorScheme.onSurface,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  /// ---------------- SESSION FORM ----------------
  Widget _buildSessionForm(BuildContext context, SessionController c) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        CustomWidgets().labelWithAsterisk('Select Student', required: true),
        const SizedBox(height: 10),
        CustomWidgets().customDropdownField<Student>(
          context: context,
          hint: 'Select Student',
          items: c.studentsList,
          value: c.selectedStudent.value,
          itemLabel: (s) => s.name,
          onChanged: (student) => c.onStudentSelected(student),
        ),
        const SizedBox(height: 10),
        CustomWidgets().labelWithAsterisk('Select Package', required: true),
        const SizedBox(height: 10),
        CustomWidgets().customDropdownField(
          context: context,
          hint: 'Select Package',
          items: c.packagesList,
          value: c.selectedPackage.value,
          itemLabel: (p) => p.subjectName,
          onChanged: (p0) => c.selectedPackage.value = p0,
        ),
        const SizedBox(height: 10),
        CustomWidgets().labelWithAsterisk('Select Teacher', required: true),
        const SizedBox(height: 10),
        CustomWidgets().customDropdownField(
          context: context,
          hint: 'Select Teacher',
          items: c.teacherList,
          onChanged: (p0) => c.selectedTeacher.value = p0,
          value: c.selectedTeacher.value,
          itemLabel: (item) => item.name,
        ),
        const SizedBox(height: 10),
        CustomWidgets().labelWithAsterisk('Teacher Salary'),
        const SizedBox(height: 10),
        CustomWidgets().dropdownStyledTextField(
            context: context,
            hint: 'Teacher Salary',
            controller: c.salaryController,
            isNumber: true),
        const SizedBox(height: 10),
        CustomWidgets().labelWithAsterisk('Session Date', required: true),
        const SizedBox(height: 10),
        CustomWidgets().customDatePickerField(
          context: context,
          controller: c.dateController,
          selectedDate: c.selectedDate,
        ),
        const SizedBox(height: 10),
        CustomWidgets().labelWithAsterisk('Session Time', required: true),
        const SizedBox(height: 10),
        CustomWidgets().timePickerStyledField(
          context: context,
          controller: c.timeController,
          selectedTime: c.selectedTime,
        ),
        const SizedBox(height: 10),
        CustomWidgets().labelWithAsterisk('Select Duration', required: true),
        const SizedBox(height: 10),
        CustomWidgets().customDropdownField(
          context: context,
          hint: 'Select Duration',
          items: c.durationOptions,
          value: c.selectedDuration.value,
          onChanged: (p0) => c.selectedDuration.value = p0,
          itemLabel: (item) => "$item minutes",
        ),
      ],
    );
  }

  /// ---------------- MEET FORM ----------------
  Widget _buildMeetForm(BuildContext context, dynamic c) {
    final textTheme = Theme.of(context).textTheme;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        CustomWidgets().labelWithAsterisk('Meet Title', required: true),
        const SizedBox(height: 10),
        CustomWidgets().dropdownStyledTextField(
          context: context,
          hint: 'Meet Title',
          controller: c.meetTitleController,
        ),
        const SizedBox(height: 10),
        _buildMultiSelect<Mentor>(
          context: context,
          title: "Mentors",
          list: c.mentorsList,
          selectedList: c.selectedMentors,
          selectAll: c.selectAllMentors,
          itemLabel: (m) => m.name,
        ),
        _buildMultiSelect<Teacher>(
          context: context,
          title: "Teachers",
          list: c.teacherList,
          selectedList: c.selectedTeachers,
          selectAll: c.selectAllTeachers,
          itemLabel: (t) => t.name,
        ),
        _buildMultiSelect<Student>(
          context: context,
          title: "Students",
          list: c.studentsList,
          selectedList: c.selectedStudents,
          selectAll: c.selectAllStudents,
          itemLabel: (t) => t.name,
        ),
        _buildMultiSelect<Coordinator>(
          context: context,
          title: "Coordinators",
          list: c.coordinatorsList,
          selectedList: c.selectedCoordinators,
          selectAll: c.selectAllCoordinators,
          itemLabel: (t) => t.name,
        ),
        _buildMultiSelect<Advisor>(
          context: context,
          title: "Advisors",
          list: c.advisorsList,
          selectedList: c.selectedAdvisors,
          selectAll: c.selectAllAdvisors,
          itemLabel: (item) => item.name,
        ),
        _buildMultiSelect<OtherUsers>(
          context: context,
          title: "Other Users",
          list: c.otherUsersList,
          selectedList: c.selectedOtherUsers,
          selectAll: c.selectAllOtherUsers,
          itemLabel: (item) => item.name,
        ),
        const SizedBox(height: 10),
        Text('Session Details',
            style:
                textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold)),
        const SizedBox(height: 10),
        CustomWidgets().labelWithAsterisk('Session Date', required: true),
        const SizedBox(height: 10),
        CustomWidgets().customDatePickerField(
          context: context,
          controller: c.dateController,
          selectedDate: c.selectedDate,
        ),
        const SizedBox(height: 10),
        CustomWidgets().labelWithAsterisk('Session Time', required: true),
        const SizedBox(height: 10),
        CustomWidgets().timePickerStyledField(
          context: context,
          controller: c.timeController,
          selectedTime: c.selectedTime,
        ),
        const SizedBox(height: 10),
        CustomWidgets().labelWithAsterisk('Select Duration', required: true),
        const SizedBox(height: 10),
        CustomWidgets().customDropdownField(
            context: context,
            hint: 'Select Duration',
            items: c.durationOptions,
            value: c.selectedDuration.value,
            onChanged: (p0) => c.selectedDuration.value = p0,
            itemLabel: (item) => "$item minutes"),
        const SizedBox(height: 10),
        CustomWidgets().labelWithAsterisk('Description', required: true),
        const SizedBox(height: 10),
        CustomWidgets().dropdownStyledTextField(
          context: context,
          hint: 'Description',
          controller: c.descriptionController,
        ),
      ],
    );
  }

  /// ---------------- REUSABLE MULTI SELECT ----------------
  Widget _buildMultiSelect<T>({
    required BuildContext context,
    required String title,
    required List<T> list,
    required RxList<T> selectedList,
    required RxBool selectAll,
    required String Function(T item) itemLabel,
  }) {
    final theme = Theme.of(context);

    return Column(
      children: [
        Row(
          children: [
            Obx(() => Checkbox(
                  value: selectAll.value,
                  onChanged: (value) {
                    if (value == null) return;

                    selectAll.value = value;

                    if (value) {
                      selectedList.assignAll(list);
                    } else {
                      selectedList.clear();
                    }
                  },
                  fillColor: WidgetStateProperty.resolveWith((states) {
                    if (states.contains(WidgetState.selected)) {
                      return theme.colorScheme.primary.withOpacity(0.8);
                    }
                    return Colors.transparent;
                  }),
                  side: BorderSide(
                    color: theme.colorScheme.outline.withOpacity(0.5),
                    width: 1.2,
                  ),
                  checkColor: theme.colorScheme.onSurface,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(4),
                  ),
                )),
            const SizedBox(width: 8),
            Text(
              'Select All $title',
              style: theme.textTheme.bodyMedium,
            ),
          ],
        ),
        CustomWidgets().customMultiDropdownField<T>(
            context: context,
            hint: 'Select $title (${list.length} available)',
            items: list,
            selectedItems: selectedList,
            itemLabel: itemLabel),
        const SizedBox(height: 10),
      ],
    );
  }
}

class DropdownItem<T> {
  final T value;
  final String label;

  DropdownItem({
    required this.value,
    required this.label,
  });
}
