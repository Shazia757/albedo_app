// import 'package:albedo_app/controller/auth_controller.dart';
// import 'package:albedo_app/controller/permissions_controller.dart';
// import 'package:albedo_app/controller/session_controller.dart';
// import 'package:albedo_app/controller/student_controller.dart';
// import 'package:albedo_app/controller/teacher_controller.dart';
// import 'package:albedo_app/model/session_model.dart';
// import 'package:albedo_app/model/users/advisor_model.dart';
// import 'package:albedo_app/model/users/coordinator_model.dart';
// import 'package:albedo_app/model/users/mentor_model.dart';
// import 'package:albedo_app/model/users/other_users_model.dart';
// import 'package:albedo_app/model/users/student_model.dart';
// import 'package:albedo_app/model/users/teacher_model.dart';
// import 'package:albedo_app/view/students/student_detail_page.dart';
// import 'package:albedo_app/view/teacher/tr_detailed_page.dart';
// import 'package:albedo_app/widgets/custom_appbar.dart';
// import 'package:albedo_app/widgets/drawer_menu.dart';
// import 'package:albedo_app/widgets/responsive.dart';
// import 'package:albedo_app/widgets/session_widgets.dart';
// import 'package:albedo_app/widgets/widgets.dart';
// import 'package:flutter/material.dart';
// import 'package:get/get.dart';

// class SessionDetailsPage extends StatelessWidget {
//   final List<Session> sessions;
//   final int initialIndex;

//   SessionDetailsPage({
//     super.key,
//     required this.sessions,
//     required this.initialIndex,
//   });

//   final c = Get.find<SessionController>();

//   @override
//   Widget build(BuildContext context) {
//     final isDesktop = Responsive.isDesktop(context);
//     final auth = Get.find<AuthController>();
//     final isCoordinator = auth.activeUser?.role == "coordinator";

//     final role = auth.activeUser?.role;

//     final isCustom = ![
//       "admin",
//       "mentor",
//       "advisor",
//       "teacher",
//       "student",
//       "coordinator",
//       "finance",
//       "sales",
//       "hr"
//     ].contains(role);

//     c.currentSessionIndex.value = initialIndex;

//     final cs = Theme.of(context).colorScheme;

//     return Scaffold(
//       appBar: CustomAppBar(),
//       body: Row(
//         children: [
//           if (isDesktop) const DrawerMenu(),
//           Expanded(
//             child: ConstrainedBox(
//               constraints: const BoxConstraints(maxWidth: 800),
//               child: SingleChildScrollView(
//                 child: Padding(
//                   padding: const EdgeInsets.fromLTRB(24, 24, 24, 24),
//                   child: Column(
//                     crossAxisAlignment: CrossAxisAlignment.start,
//                     children: [
//                       Text(
//                         'Session Details',
//                         style: Theme.of(context).textTheme.titleLarge,
//                       ),
//                       const SizedBox(height: 10),
//                       Obx(() {
//                         final index = c.currentSessionIndex.value;
//                         final data = sessions[index];

//                         return Column(
//                           children: [
//                             // ───────── HEADER NAVIGATION ─────────
//                             Container(
//                               padding: const EdgeInsets.all(12),
//                               child: Row(
//                                 mainAxisAlignment:
//                                     MainAxisAlignment.spaceBetween,
//                                 children: [
//                                   IconButton(
//                                     onPressed: index > 0
//                                         ? () => c.currentSessionIndex.value--
//                                         : null,
//                                     icon: const Icon(Icons.arrow_back_ios),
//                                   ),
//                                   Column(
//                                     children: [
//                                       Text(
//                                         "Session ${index + 1} of ${sessions.length}",
//                                       ),
//                                       const SizedBox(height: 6),
//                                       Row(
//                                         mainAxisAlignment:
//                                             MainAxisAlignment.center,
//                                         children: List.generate(
//                                           sessions.length,
//                                           (i) => Container(
//                                             margin: const EdgeInsets.symmetric(
//                                                 horizontal: 2),
//                                             width: i == index ? 18 : 6,
//                                             height: 6,
//                                             decoration: BoxDecoration(
//                                               color: i == index
//                                                   ? cs.primary
//                                                   : cs.outlineVariant
//                                                       .withOpacity(0.4),
//                                               borderRadius:
//                                                   BorderRadius.circular(10),
//                                             ),
//                                           ),
//                                         ),
//                                       ),
//                                     ],
//                                   ),
//                                   IconButton(
//                                     onPressed: index < sessions.length - 1
//                                         ? () => c.currentSessionIndex.value++
//                                         : null,
//                                     icon: const Icon(Icons.arrow_forward_ios),
//                                   ),
//                                 ],
//                               ),
//                             ),

//                             // ───────── BODY ─────────
//                             SingleChildScrollView(
//                               padding: const EdgeInsets.all(16),
//                               child: Column(
//                                 crossAxisAlignment: CrossAxisAlignment.start,
//                                 children: [
//                                   /// 👇 KEEP YOUR EXISTING UI BLOCKS (UNCHANGED)
//                                   detailCard(context,
//                                       title: "Student",
//                                       name: data.student?.name ?? '',
//                                       id: data.student?.studentId ?? '',
//                                       onTap: () => Get.to(
//                                             () => StudentDetailsPage(
//                                                 student: data.student!,
//                                                 initialIndex: initialIndex),
//                                             binding: BindingsBuilder(() {
//                                               Get.put(StudentController());
//                                             }),
//                                           )),

//                                   detailCard(context,
//                                       title: "Teacher",
//                                       name: data.teacher?.name ?? '',
//                                       id: data.teacher?.id ?? '',
//                                       onTap: () => Get.to(
//                                             () => TeacherDetailsPage(
//                                                 teacher: data.teacher!,
//                                                 initialIndex: initialIndex),
//                                             binding: BindingsBuilder(() {
//                                               Get.put(TeacherController());
//                                             }),
//                                           )),

//                                   buildRoleCard(
//                                     context: context,
//                                     title: "Mentor",
//                                     user: data.mentor,
//                                     onTap: (id) =>
//                                         _onUserTap(context, "mentor", id),
//                                   ),

//                                   buildRoleCard(
//                                     context: context,
//                                     title: "Coordinator",
//                                     user: data.coordinator,
//                                     onTap: (id) =>
//                                         _onUserTap(context, "coordinator", id),
//                                   ),

//                                   buildRoleCard(
//                                     context: context,
//                                     title: "Advisor",
//                                     user: data.advisor,
//                                     onTap: (id) =>
//                                         _onUserTap(context, "advisor", id),
//                                   ),

//                                   const SizedBox(height: 16),

//                                   DetailSectionLabel(
//                                     label: "Schedule & Info",
//                                     icon: Icons.event_outlined,
//                                   ),

//                                   const SizedBox(height: 8),

//                                   EditableInfoCard(
//                                     type: "schedule",
//                                     icon: Icons.schedule_outlined,
//                                     title: "Schedule",
//                                     date:
//                                         formatDate(data.date ?? DateTime.now()),
//                                     time:
//                                         formatTime(data.date ?? DateTime.now()),
//                                     duration: data.duration?.toString() ?? "-",
//                                     onSave: (date, time) {},
//                                   ),

//                                   infoCard(
//                                     context,
//                                     type: "session",
//                                     icon: Icons.menu_book_outlined,
//                                     title: "Session Info",
//                                     children: [
//                                       infoRow(
//                                         label: "Subject",
//                                         value: data.package?.subjectName ?? "-",
//                                       ),
//                                       infoRow(
//                                         label: "Syllabus",
//                                         value: data.syllabus ?? "-",
//                                       ),
//                                     ],
//                                   ),

//                                   const SizedBox(height: 16),

//                                   DetailSectionLabel(
//                                     label: "Status",
//                                     icon: Icons.flag_outlined,
//                                   ),

//                                   const SizedBox(height: 8),

//                                   infoCard(
//                                     context,
//                                     type: "status",
//                                     icon: Icons.flag_outlined,
//                                     title: "Status",
//                                     children: [
//                                       infoRow(
//                                         label: "Current Status",
//                                         value: data.status,
//                                       ),
//                                     ],
//                                   ),

//                                   const SizedBox(height: 10),

//                                   /// (KEEP REPORT SECTION EXACTLY AS YOU HAVE)
//                                 ],
//                               ),
//                             ),

//                             // ───────── ACTION BAR (NOW FIXED LIKE PAGE) ─────────
//                             if (data.status != 'completed')
//                               Container(
//                                 padding: const EdgeInsets.all(12),
//                                 decoration: BoxDecoration(
//                                   color: cs.surface,
//                                   border: Border(
//                                     top: BorderSide(
//                                       color: cs.outlineVariant.withOpacity(0.2),
//                                     ),
//                                   ),
//                                 ),
//                                 child: Row(
//                                   children: [
//                                     if ((!isCustom ||
//                                         PermissionService.can("edit_sessions")))
//                                       Expanded(
//                                         child: DetailActionButton(
//                                           label: "Edit",
//                                           icon: Icons.edit_outlined,
//                                           color: cs.secondary,
//                                           onTap: () {
//                                             c.loadSession(data);
//                                             editSession(context);
//                                           },
//                                         ),
//                                       ),
//                                     const SizedBox(width: 8),
//                                     Expanded(
//                                       child: DetailActionButton(
//                                         label: "Support",
//                                         icon: Icons.support_agent_outlined,
//                                         color: cs.tertiary,
//                                         onTap: () => _addSupport(context),
//                                       ),
//                                     ),
//                                     if (data.status == 'pending') ...[
//                                       const SizedBox(width: 8),
//                                       Expanded(
//                                         child: DetailActionButton(
//                                           label: "Complete",
//                                           icon: Icons.check_outlined,
//                                           color: cs.primary,
//                                           onTap: () => _markSessionCompleted(
//                                             context,
//                                             data.date ?? DateTime.now(),
//                                           ),
//                                         ),
//                                       ),
//                                     ],
//                                     if (!isCoordinator) ...[
//                                       const SizedBox(width: 8),
//                                       Expanded(
//                                         child: DetailActionButton(
//                                           label: "Delete",
//                                           icon: Icons.delete_outline,
//                                           color: cs.error,
//                                           onTap: () =>
//                                               CustomWidgets().showDeleteDialog(
//                                             text:
//                                                 'Are you sure you want to delete this session permanently?',
//                                             context: context,
//                                             onConfirm: () => c.delete(data.id),
//                                           ),
//                                         ),
//                                       ),
//                                     ],
//                                   ],
//                                 ),
//                               ),
//                           ],
//                         );
//                       }),
//                     ],
//                   ),
//                 ),
//               ),
//             ),
//           ),
//         ],
//       ),
//     );
//   }

//   Widget _buildTypeCard({
//     required BuildContext context,
//     required String title,
//     required IconData icon,
//     required String value,
//     required String selectedValue,
//     required VoidCallback onTap,
//   }) {
//     final isSelected = value == selectedValue;
//     final theme = Theme.of(context);
//     final textTheme = theme.textTheme;

//     return InkWell(
//       onTap: onTap,
//       borderRadius: BorderRadius.circular(12),
//       child: AnimatedContainer(
//         duration: const Duration(milliseconds: 200),
//         padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
//         decoration: BoxDecoration(
//           color: isSelected
//               ? theme.colorScheme.primary.withOpacity(0.1)
//               : theme.colorScheme.onPrimary.withOpacity(0.8),
//           borderRadius: BorderRadius.circular(12),
//           border: Border.all(
//             color: isSelected
//                 ? theme.colorScheme.primary
//                 : theme.colorScheme.outline.withOpacity(0.3),
//             width: isSelected ? 1.5 : 1,
//           ),
//         ),
//         child: Row(
//           children: [
//             Icon(
//               icon,
//               size: 24,
//               color: isSelected
//                   ? theme.colorScheme.primary
//                   : theme.colorScheme.onSurface.withOpacity(0.6),
//             ),
//             const SizedBox(width: 10),

//             /// TEXT
//             Expanded(
//               child: Text(
//                 title,
//                 style: textTheme.bodyMedium?.copyWith(
//                   fontWeight: FontWeight.w500,
//                   color: isSelected
//                       ? theme.colorScheme.primary
//                       : theme.colorScheme.onSurface,
//                 ),
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }

//   /// ---------------- SESSION FORM ----------------
//   Widget _buildSessionForm(BuildContext context, SessionController c) {
//     return Column(
//       crossAxisAlignment: CrossAxisAlignment.start,
//       children: [
//         CustomWidgets().labelWithAsterisk('Select Student', required: true),
//         const SizedBox(height: 10),
//         CustomWidgets().customDropdownField<Student>(
//           context: context,
//           hint: 'Select Student',
//           items: c.studentsList,
//           value: c.selectedStudent.value,
//           itemLabel: (s) => s.name,
//           onChanged: (student) => c.onStudentSelected(student),
//         ),
//         const SizedBox(height: 10),
//         CustomWidgets().labelWithAsterisk('Select Package', required: true),
//         const SizedBox(height: 10),
//         CustomWidgets().customDropdownField(
//           context: context,
//           hint: 'Select Package',
//           items: c.packagesList,
//           value: c.selectedPackage.value,
//           itemLabel: (p) => p.subjectName ?? '',
//           onChanged: (p0) => c.selectedPackage.value = p0,
//         ),
//         const SizedBox(height: 10),
//         CustomWidgets().labelWithAsterisk('Select Teacher', required: true),
//         const SizedBox(height: 10),
//         CustomWidgets().customDropdownField(
//           context: context,
//           hint: 'Select Teacher',
//           items: c.teacherList,
//           onChanged: (p0) => c.selectedTeacher.value = p0,
//           value: c.selectedTeacher.value,
//           itemLabel: (item) => item.name,
//         ),
//         const SizedBox(height: 10),
//         CustomWidgets().labelWithAsterisk('Teacher Salary'),
//         const SizedBox(height: 10),
//         CustomWidgets().dropdownStyledTextField(
//             context: context,
//             hint: 'Teacher Salary',
//             controller: c.salaryController,
//             isNumber: true),
//         const SizedBox(height: 10),
//         CustomWidgets().labelWithAsterisk('Session Date', required: true),
//         const SizedBox(height: 10),
//         CustomWidgets().customDatePickerField(
//           context: context,
//           controller: c.dateController,
//           selectedDate: c.selectedDate,
//         ),
//         const SizedBox(height: 10),
//         CustomWidgets().labelWithAsterisk('Session Time', required: true),
//         const SizedBox(height: 10),
//         CustomWidgets().timePickerStyledField(
//           context: context,
//           controller: c.timeController,
//           selectedTime: c.selectedTime,
//         ),
//         const SizedBox(height: 10),
//         CustomWidgets().labelWithAsterisk('Select Duration', required: true),
//         const SizedBox(height: 10),
//         CustomWidgets().customDropdownField(
//           context: context,
//           hint: 'Select Duration',
//           items: c.durationOptions,
//           value: c.selectedDuration.value,
//           onChanged: (p0) => c.selectedDuration.value = p0,
//           itemLabel: (item) => "$item minutes",
//         ),
//       ],
//     );
//   }

//   /// ---------------- MEET FORM ----------------
//   Widget _buildMeetForm(BuildContext context, dynamic c) {
//     final textTheme = Theme.of(context).textTheme;
//     return Column(
//       crossAxisAlignment: CrossAxisAlignment.start,
//       children: [
//         CustomWidgets().labelWithAsterisk('Meet Title', required: true),
//         const SizedBox(height: 10),
//         CustomWidgets().dropdownStyledTextField(
//           context: context,
//           hint: 'Meet Title',
//           controller: c.meetTitleController,
//         ),
//         const SizedBox(height: 10),
//         _buildMultiSelect<Mentor>(
//           context: context,
//           title: "Mentors",
//           list: c.mentorsList,
//           selectedList: c.selectedMentors,
//           selectAll: c.selectAllMentors,
//           itemLabel: (m) => m.name,
//         ),
//         _buildMultiSelect<Teacher>(
//           context: context,
//           title: "Teachers",
//           list: c.teacherList,
//           selectedList: c.selectedTeachers,
//           selectAll: c.selectAllTeachers,
//           itemLabel: (t) => t.name,
//         ),
//         _buildMultiSelect<Student>(
//           context: context,
//           title: "Students",
//           list: c.studentsList,
//           selectedList: c.selectedStudents,
//           selectAll: c.selectAllStudents,
//           itemLabel: (t) => t.name,
//         ),
//         _buildMultiSelect<Coordinator>(
//           context: context,
//           title: "Coordinators",
//           list: c.coordinatorsList,
//           selectedList: c.selectedCoordinators,
//           selectAll: c.selectAllCoordinators,
//           itemLabel: (t) => t.name,
//         ),
//         _buildMultiSelect<Advisor>(
//           context: context,
//           title: "Advisors",
//           list: c.advisorsList,
//           selectedList: c.selectedAdvisors,
//           selectAll: c.selectAllAdvisors,
//           itemLabel: (item) => item.name,
//         ),
//         _buildMultiSelect<OtherUsers>(
//           context: context,
//           title: "Other Users",
//           list: c.otherUsersList,
//           selectedList: c.selectedOtherUsers,
//           selectAll: c.selectAllOtherUsers,
//           itemLabel: (item) => item.name,
//         ),
//         const SizedBox(height: 10),
//         Text('Session Details',
//             style:
//                 textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold)),
//         const SizedBox(height: 10),
//         CustomWidgets().labelWithAsterisk('Session Date', required: true),
//         const SizedBox(height: 10),
//         CustomWidgets().customDatePickerField(
//           context: context,
//           controller: c.dateController,
//           selectedDate: c.selectedDate,
//         ),
//         const SizedBox(height: 10),
//         CustomWidgets().labelWithAsterisk('Session Time', required: true),
//         const SizedBox(height: 10),
//         CustomWidgets().timePickerStyledField(
//           context: context,
//           controller: c.timeController,
//           selectedTime: c.selectedTime,
//         ),
//         const SizedBox(height: 10),
//         CustomWidgets().labelWithAsterisk('Select Duration', required: true),
//         const SizedBox(height: 10),
//         CustomWidgets().customDropdownField(
//             context: context,
//             hint: 'Select Duration',
//             items: c.durationOptions,
//             value: c.selectedDuration.value,
//             onChanged: (p0) => c.selectedDuration.value = p0,
//             itemLabel: (item) => "$item minutes"),
//         const SizedBox(height: 10),
//         CustomWidgets().labelWithAsterisk('Description', required: true),
//         const SizedBox(height: 10),
//         CustomWidgets().dropdownStyledTextField(
//           context: context,
//           hint: 'Description',
//           controller: c.descriptionController,
//         ),
//       ],
//     );
//   }

//   /// ---------------- REUSABLE MULTI SELECT ----------------
//   Widget _buildMultiSelect<T>({
//     required BuildContext context,
//     required String title,
//     required List<T> list,
//     required RxList<T> selectedList,
//     required RxBool selectAll,
//     required String Function(T item) itemLabel,
//   }) {
//     final theme = Theme.of(context);

//     return Column(
//       children: [
//         Row(
//           children: [
//             Obx(() => Checkbox(
//                   value: selectAll.value,
//                   onChanged: (value) {
//                     if (value == null) return;

//                     selectAll.value = value;

//                     if (value) {
//                       selectedList.assignAll(list);
//                     } else {
//                       selectedList.clear();
//                     }
//                   },
//                   fillColor: WidgetStateProperty.resolveWith((states) {
//                     if (states.contains(WidgetState.selected)) {
//                       return theme.colorScheme.primary.withOpacity(0.8);
//                     }
//                     return Colors.transparent;
//                   }),
//                   side: BorderSide(
//                     color: theme.colorScheme.outline.withOpacity(0.5),
//                     width: 1.2,
//                   ),
//                   checkColor: theme.colorScheme.onSurface,
//                   shape: RoundedRectangleBorder(
//                     borderRadius: BorderRadius.circular(4),
//                   ),
//                 )),
//             const SizedBox(width: 8),
//             Text(
//               'Select All $title',
//               style: theme.textTheme.bodyMedium,
//             ),
//           ],
//         ),
//         CustomWidgets().customMultiDropdownField<T>(
//             context: context,
//             hint: 'Select $title (${list.length} available)',
//             items: list,
//             selectedItems: selectedList,
//             itemLabel: itemLabel),
//         const SizedBox(height: 10),
//       ],
//     );
//   }

//   void _onUserTap(BuildContext context, String role, String? id) {
//     if (id == null || id == "-") return;

//     final handlers = {
//       "student": () {
//         final s = c.getStudentById(id);
//         if (s != null) openStudentProfile(context, s);
//       },
//       "teacher": () {
//         final t = c.getTeacherById(id);
//         if (t != null) {
//           openTeacherProfile(context, t, toUser: (p0) => teacherToUser(t));
//         } else {
//           Get.snackbar("Error", "Teacher not found for ID: $id");
//         }
//       },
//       "mentor": () {
//         final m = c.getMentorById(id);
//         if (m != null) openMentorProfile(context, m, (p0) => c.mentorToUser(m));
//       },
//       "coordinator": () {
//         final c1 = c.getCoordinatorById(id);
//         if (c1 != null)
//           openCoordinatorProfile(context, c1, (p0) => coordinatorToUser(c1));
//       },
//       "advisor": () {
//         final a = c.getAdvisorById(id);
//         if (a != null) openAdvisorProfile(context, a, (p0) => advisorToUser(a));
//       },
//     };

//     handlers[role]?.call() ?? Get.snackbar("Error", "$role not found");
//   }

//   void editSession(BuildContext context) {
//     CustomWidgets().showCustomDialog(
//       context: context,
//       title: const Text('Edit Session'),
//       icon: Icons.edit_outlined,
//       formKey: GlobalKey<FormState>(),
//       sections: [
//         Column(
//           children: [
//             DialogSectionCard(
//               icon: Icons.schedule_outlined,
//               title: "Schedule",
//               child: Row(
//                 children: [
//                   Expanded(
//                     child: Column(
//                       crossAxisAlignment: CrossAxisAlignment.start,
//                       children: [
//                         CustomWidgets()
//                             .labelWithAsterisk('Session Date', required: true),
//                         const SizedBox(height: 8),
//                         CustomWidgets().customDatePickerField(
//                             context: context,
//                             selectedDate: c.selectedDate,
//                             controller: c.dateController),
//                       ],
//                     ),
//                   ),
//                   const SizedBox(width: 12),
//                   Expanded(
//                     child: Column(
//                       crossAxisAlignment: CrossAxisAlignment.start,
//                       children: [
//                         CustomWidgets()
//                             .labelWithAsterisk('Session Time', required: true),
//                         const SizedBox(height: 8),
//                         CustomWidgets().timePickerStyledField(
//                             selectedTime: c.selectedTime,
//                             context: context,
//                             hint: 'Time',
//                             controller: c.timeController),
//                       ],
//                     ),
//                   ),
//                 ],
//               ),
//             ),
//             const SizedBox(height: 12),
//             DialogSectionCard(
//               icon: Icons.school_outlined,
//               title: "Session Details",
//               child: Column(
//                 crossAxisAlignment: CrossAxisAlignment.start,
//                 children: [
//                   CustomWidgets().labelWithAsterisk('Duration', required: true),
//                   const SizedBox(height: 8),
//                   // CustomWidgets().customDropdownField(
//                   //   context: context,
//                   //   hint: 'Select Duration',
//                   //   items:
//                   //       c.durationOptions.map((e) => "${(e)} minutes").toList(),
//                   //   onChanged: (p0) {},
//                   // ),
//                   const SizedBox(height: 12),
//                   CustomWidgets().labelWithAsterisk('Teacher', required: true),
//                   const SizedBox(height: 8),
//                   // CustomWidgets().customDropdownField(
//                   //     context: context,
//                   //     hint: 'Select Teacher',
//                   //     items: [],
//                   //     value: c.selectedTeacher.value,
//                   //     onChanged: (p0) => c.selectedTeacher.value = p0),
//                 ],
//               ),
//             ),
//             const SizedBox(height: 12),
//             DialogSectionCard(
//               icon: Icons.payments_outlined,
//               title: "Payment",
//               child: Column(
//                 crossAxisAlignment: CrossAxisAlignment.start,
//                 children: [
//                   CustomWidgets().labelWithAsterisk(
//                       'Teacher Salary (per hour — optional)'),
//                   const SizedBox(height: 8),
//                   CustomWidgets().dropdownStyledTextField(
//                       isNumber: true,
//                       context: context,
//                       hint: 'Enter teacher salary',
//                       controller: c.salaryController),
//                 ],
//               ),
//             ),
//           ],
//         ),
//       ],
//       onSubmit: () {},
//     );
//   }

//   // ── SUPPORT TICKET DIALOG ─────────────────────────────────────────────
//   void _addSupport(BuildContext context) {
//     CustomWidgets().showCustomDialog(
//       context: context,
//       title: const Text('Add New Ticket'),
//       icon: Icons.support_agent_outlined,
//       formKey: GlobalKey<FormState>(),
//       sections: [
//         SizedBox(
//           height: MediaQuery.of(context).size.height * 0.5,
//           child: SingleChildScrollView(
//             child: Column(
//               crossAxisAlignment: CrossAxisAlignment.start,
//               children: [
//                 CustomWidgets().labelWithAsterisk('Title', required: true),
//                 const SizedBox(height: 8),
//                 CustomWidgets().dropdownStyledTextField(
//                     context: context,
//                     hint: 'Enter ticket title',
//                     controller: c.titleController),
//                 const SizedBox(height: 12),
//                 CustomWidgets().labelWithAsterisk('Category', required: true),
//                 const SizedBox(height: 8),
//                 // CustomWidgets().customDropdownField(
//                 //   context: context,
//                 //   hint: 'Select category',
//                 //   items: c.categoryList,
//                 //   onChanged: (p0) {},
//                 // ),
//                 const SizedBox(height: 12),
//                 CustomWidgets().labelWithAsterisk('Priority', required: true),
//                 const SizedBox(height: 8),
//                 // CustomWidgets().customDropdownField(
//                 //   context: context,
//                 //   hint: 'Select priority',
//                 //   items: ['High', 'Medium', 'Low'],
//                 //   onChanged: (p0) {},
//                 // ),
//                 const SizedBox(height: 12),
//                 CustomWidgets().labelWithAsterisk('User', required: true),
//                 const SizedBox(height: 8),
//                 Obx(() => Row(
//                       children: [
//                         Expanded(
//                           child: RadioListTile(
//                             dense: true,
//                             title: const Text('Student'),
//                             value: "student",
//                             groupValue: c.selectedType.value,
//                             onChanged: (value) => c.selectedType.value = value!,
//                           ),
//                         ),
//                         Expanded(
//                           child: RadioListTile(
//                             dense: true,
//                             title: const Text('Teacher'),
//                             value: "teacher",
//                             groupValue: c.selectedType.value,
//                             onChanged: (value) => c.selectedType.value = value!,
//                           ),
//                         ),
//                       ],
//                     )),
//                 const SizedBox(height: 8),
//                 Obx(() {
//                   // if (c.selectedType.value == 'student') {
//                   //   return CustomWidgets().customDropdownField(
//                   //       items: c.studentsList,
//                   //       onChanged: (p0) {},
//                   //       context: context,
//                   //       hint: 'Select student');
//                   // }
//                   // if (c.selectedType.value == 'teacher') {
//                   //   return CustomWidgets().customDropdownField(
//                   //       items: c.teacherList,
//                   //       onChanged: (p0) {},
//                   //       context: context,
//                   //       hint: 'Select teacher');
//                   // }
//                   return const SizedBox();
//                 }),
//                 const SizedBox(height: 12),
//                 CustomWidgets().labelWithAsterisk('Attachment'),
//                 const SizedBox(height: 8),
//                 CustomWidgets().attachmentStyledField(
//                   context: context,
//                   label: "Attachment",
//                   hint: "Choose a file",
//                   fileName: c.selectedFile,
//                   onTap: () {},
//                   onClear: () {},
//                 ),
//                 const SizedBox(height: 12),
//                 CustomWidgets()
//                     .labelWithAsterisk('Description', required: true),
//                 const SizedBox(height: 8),
//                 CustomWidgets().dropdownStyledTextField(
//                   context: context,
//                   hint: 'Describe the issue...',
//                   controller: c.descriptionController,
//                   isMultiline: true,
//                 ),
//                 const SizedBox(height: 16),
//               ],
//             ),
//           ),
//         ),
//       ],
//       onSubmit: () {},
//     );
//   }

//   void _markSessionCompleted(BuildContext context, DateTime date) {
//     CustomWidgets().showCustomDialog(
//       context: context,
//       title: const Text('Mark Session as Completed'),
//       formKey: GlobalKey<FormState>(),
//       sections: [
//         Column(
//           children: [
//             CustomWidgets().labelWithAsterisk('Session Date', required: true),
//             const SizedBox(height: 8),
//             CustomWidgets().customDatePickerField(
//                 context: context,
//                 selectedDate: c.selectedDate,
//                 controller: c.dateController),
//             const SizedBox(width: 12),
//             CustomWidgets().labelWithAsterisk('Start Time', required: true),
//             const SizedBox(height: 8),
//             CustomWidgets().timePickerStyledField(
//                 selectedTime: c.selectedTime,
//                 context: context,
//                 hint: 'Time',
//                 controller: c.timeController),
//             const SizedBox(height: 12),
//             CustomWidgets().labelWithAsterisk('Duration', required: true),
//             const SizedBox(height: 8),
//             // CustomWidgets().customDropdownField(
//             //   context: context,
//             //   hint: 'Select Duration',
//             //   items: c.durationOptions.map((e) => "${(e)} minutes").toList(),
//             //   onChanged: (p0) {},
//             // ),
//           ],
//         ),
//       ],
//       onSubmit: () {},
//     );
//   }
// }
