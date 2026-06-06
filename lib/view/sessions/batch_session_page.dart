import 'dart:developer';

import 'package:albedo_app/api.dart';
import 'package:albedo_app/controller/batch_controller.dart';
import 'package:albedo_app/controller/batch_list_controller.dart';
import 'package:albedo_app/controller/teacher_controller.dart';
import 'package:albedo_app/model/batch_model.dart';
import 'package:albedo_app/model/session_model.dart';
import 'package:albedo_app/model/settings/syllabus_model.dart';
import 'package:albedo_app/model/users/student_model.dart';
import 'package:albedo_app/model/users/teacher_model.dart';
import 'package:albedo_app/view/batch/batch_detailed_page.dart';
import 'package:albedo_app/view/sessions/add_batch_session_page.dart';
import 'package:albedo_app/view/teacher/tr_detailed_page.dart';
import 'package:albedo_app/widgets/batch_widgets.dart';
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

class BatchesListPage extends StatelessWidget {
  final c = Get.put(BatchListController(), permanent: true);

  BatchesListPage({super.key});

  @override
  Widget build(BuildContext context) {
    final isDesktop = Responsive.isDesktop(context);
    final cs = Theme.of(context).colorScheme;

    return Scaffold(
      appBar: const CustomAppBar(),
      backgroundColor: Theme.of(context).colorScheme.surface,
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Get.to(() => const AddBatchSessionPage());
        },
        mini: true,
        backgroundColor: context.theme.colorScheme.primary,
        child: Icon(
          Icons.add,
          color: context.theme.colorScheme.onPrimary,
        ),
      ),
      drawer: isDesktop ? null : const DrawerMenu(),
      body: Row(
        children: [
          if (isDesktop) const DrawerMenu(),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                children: [
                  HeaderWithSearch(
                    title: "Batches",
                    hint: "Search batches...",
                    isSearching: c.isSearching,
                    searchQuery: c.searchQuery,
                    onSearchChanged: () => c.applyFilters(),
                  ),
                  SizedBox(height: 12),
                  Obx(
                    () => CustomWidgets().customTabs(context,
                        tabs: c.tabs,
                        selectedIndex: c.selectedTab.value, getCount: (index) {
                      switch (index) {
                        case 0:
                          return c.activeCount.value;

                        case 1:
                          return c.upcomingCount.value;

                        case 2:
                          return c.pendingCount.value;

                        case 3:
                          return c.completedCount.value;

                        default:
                          return 0;
                      }
                    }, onTap: (index) async {
                      c.selectedTab.value = index;
                      c.currentPage.value = 0;

                      await c.fetchData();
                    }),
                  ),
                  SizedBox(height: 12),
                  Expanded(
                    child: Obx(() {
                      log("filteredBatchSessions: ${c.filteredBatchSessions.length}");
                      log("all sessions: ${c.batchList.length}");
                      final data = c.filteredBatchSessions;

                      if (c.isLoading.value) {
                        return Center(child: CircularProgressIndicator());
                      }
                      if (data.isEmpty) {
                        return EmptyState(
                          cs: cs,
                          title: "No batches found",
                          subtitle: "Try adjusting filters or add a batch",
                          icon: Icons.groups_outlined,
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
                            padding: const EdgeInsets.fromLTRB(0, 0, 0, 80),
                            crossAxisCount: crossAxisCount,
                            mainAxisSpacing: 8,
                            crossAxisSpacing: 8,
                            itemCount: data.length,
                            itemBuilder: (_, i) {
                              return BatchCard(
                                batch: data[i],
                                statusColor: getStatusColor(context, ""),
                                onTap: () =>
                                    openSessionDetails(context, data, i),
                              );
                            },
                          );
                        },
                      );
                    }),
                  ),
                  Obx(() {
                    if (c.totalPages <= 1) {
                      return const SizedBox();
                    }

                    return Padding(
                      padding: const EdgeInsets.only(
                        bottom: 14,
                        top: 6,
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          IconButton(
                            onPressed: c.currentPage.value > 0
                                ? () async {
                                    c.currentPage.value--;
                                    await c.fetchData();
                                  }
                                : null,
                            icon: const Icon(
                              Icons.chevron_left_rounded,
                            ),
                          ),
                          Text(
                            "Page ${c.currentPage.value + 1} of ${c.totalPages}",
                          ),
                          IconButton(
                            onPressed: c.currentPage.value < c.totalPages - 1
                                ? () async {
                                    c.currentPage.value++;
                                    await c.fetchData();
                                  }
                                : null,
                            icon: const Icon(
                              Icons.chevron_right_rounded,
                            ),
                          ),
                        ],
                      ),
                    );
                  })
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  void openSessionDetails(
    BuildContext context,
    List<BatchSession> sessions,
    int currentIndex,
  ) async {
    int index = currentIndex;
    c.currentSessionIndex.value = currentIndex;

    final session = sessions[currentIndex];
    final detail = await c.fetchSessionDetail(session.id ?? '');

    if (detail == null) return;

    CustomWidgets().showCustomDialog(
      context: context,
      title: Text(
        "Session Details",
        style: Theme.of(context)
            .textTheme
            .bodyMedium!
            .copyWith(color: Colors.white),
      ),
      icon: Icons.schedule,
      formKey: GlobalKey<FormState>(),
      submitWidget: Text(
        "Close",
        style: Theme.of(context)
            .textTheme
            .bodyMedium!
            .copyWith(color: Colors.white),
      ),
      onSubmit: () {},
      isViewOnly: true,
      sections: [
        StatefulBuilder(
          builder: (context, setState) {
            final session = sessions[index];

            final teacher = session.teachers;

            final cs = Theme.of(context).colorScheme;

            return SizedBox(
              height: MediaQuery.of(context).size.height * 0.70,
              child: Column(
                children: [
                  /// NAVIGATION
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

                  SizedBox(height: 8),

                  Expanded(
                    child: SingleChildScrollView(
                      child: Column(
                        children: [
                          /// BATCH
                          detailCard(
                            context,
                            title: "Batch",
                            name: session.batchName ?? "-",
                            getImageUrl: () => session.imageUrl,
                            id: session.batchID ?? "-",
                            onTap: () {
                              //   Get.to(
                              //   () => BatchDetailedPage(
                              //     batch: ,
                              //     initialIndex: index,
                              //   ),
                              //   binding: BindingsBuilder(() {
                              //     Get.put(BatchController());
                              //   }),
                              // );
                            },
                          ),

                          /// TEACHER
                          detailCard(
                            context,
                            title: "Teacher",
                            name: teacher?.name ?? "-",
                            id: teacher?.teacherId ?? "-",
                            getImageUrl: () {
                              return "https://api.albedoedu.com${teacher?.imageUrl}";
                            },
                            onTap: () {
                            //   Get.to(
                            //   () => TeacherDetailsPage(
                            //     teacher: teacher!,
                            //     initialIndex: index,
                            //   ),
                            //   binding: BindingsBuilder(() {
                            //     Get.put(TeacherController());
                            //   }),
                            // );
                            },
                          ),

                          SizedBox(height: 10),

                          /// SCHEDULE
                          EditableInfoCard(
                            type: "schedule",
                            icon: Icons.schedule,
                            title: "Schedule",
                            date: formatDate(session.date ?? DateTime.now()),
                            time:
                                "${formatTime(session.startTime)} - ${formatTime(session.endTime)}",
                            duration: session.duration != null
                                ? "${session.duration!.inHours} hr ${session.duration!.inMinutes.remainder(60)} min"
                                : "-",
                            onSave: (date, time) {},
                          ),

                          /// SESSION INFO
                          infoCard(
                            context,
                            type: "session",
                            icon: Icons.menu_book,
                            title: "Session Info",
                            children: [
                              infoRow(
                                label: "Package",
                                value: session.packageName ?? "-",
                              ),
                              // infoRow(
                              //   label: "Standard",
                              //   value: package?.standard ?? "-",
                              // ),
                              infoRow(
                                label: "Syllabus",
                                value: session.syllabus ?? "-",
                              ),
                              // infoRow(
                              //   label: "Topic",
                              //   value: session.topic ?? "-",
                              // ),
                            ],
                          ),

                          /// STATUS
                          infoCard(
                            context,
                            type: "status",
                            icon: Icons.flag,
                            title: "Status",
                            children: [
                              // infoRow(
                              //   label: "Current Status",
                              //   value: session.status,
                              // ),
                              infoRow(
                                label: "Completed",
                                value:
                                    session.isCompleted == true ? "Yes" : "No",
                              ),
                            ],
                          ),

                          SizedBox(height: 10),

                          /// REPORT
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
                                      Text(
                                        "No session report available yet.",
                                      ),
                                      SizedBox(height: 8),
                                      ElevatedButton.icon(
                                        onPressed: () {
                                          c.openSessionReportDialog(
                                            session,
                                          );
                                        },
                                        icon: const Icon(Icons.add,
                                            color: Colors.white),
                                        label: Text(
                                          "Add Report",
                                          style: Theme.of(context)
                                              .textTheme
                                              .bodySmall!
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
                                    ListTile(
                                      contentPadding: EdgeInsets.zero,
                                      title: Text(
                                        report.studentName,
                                      ),
                                      subtitle: Text(
                                        report.isCompleted
                                            ? "Completed"
                                            : "Not Completed",
                                      ),
                                      trailing: TextButton.icon(
                                        onPressed: () {
                                          c.openSessionReportDialog(
                                            session,
                                          );
                                        },
                                        icon: const Icon(
                                          Icons.edit,
                                          size: 18,
                                        ),
                                        label: Text("Edit"),
                                      ),
                                    ),
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
                                          style: Theme.of(context)
                                              .textTheme
                                              .bodyMedium!
                                              .copyWith(color: Colors.red),
                                        ),
                                      ),
                                    if (report.isCompleted) ...[
                                      infoRow(
                                        label: "Topics Covered",
                                        value: report.topicsCovered ?? "-",
                                      ),
                                      infoRow(
                                        label: "Teacher Notes",
                                        value: report.teacherNotes ?? "-",
                                      ),
                                    ],
                                  ],
                                );
                              }),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                  SizedBox(height: 12),

                  /// ACTIONS
                  if (session.isCompleted == false)
                    Row(
                      children: [
                        Expanded(
                          child: _DetailActionButton(
                            label: "Edit",
                            icon: Icons.edit_outlined,
                            color: cs.secondary,
                            onTap: () {
                              // c.loadSession(
                              //   session,
                              // );

                              editSession(context, session);
                            },
                          ),
                        ),
                        SizedBox(width: 8),
                        Expanded(
                          child: _DetailActionButton(
                            label: "Delete",
                            icon: Icons.delete_outline,
                            color: cs.error,
                            onTap: () {
                              CustomWidgets().showDeleteDialog(
                                dltText: Obx(
                                  () => c.isLoading.value
                                      ? const SizedBox(
                                          width: 18,
                                          height: 18,
                                          child: CircularProgressIndicator(
                                            strokeWidth: 2,
                                            color: Colors.white,
                                          ),
                                        )
                                      : Text(
                                          "Yes",
                                          style: Theme.of(context)
                                              .textTheme
                                              .titleSmall!
                                              .copyWith(color: Colors.white),
                                        ),
                                ),
                                title: 'Are you sure?',
                                text:
                                    'Are you sure you want to delete this session permanently?',
                                context: context,
                                onConfirm: () {
                                  c.delete(
                                    session.id ?? '',
                                  );
                                },
                              );
                            },
                          ),
                        ),
                        SizedBox(width: 8),
                        Expanded(
                          child: DetailActionButton(
                            label: "Support",
                            icon: Icons.support_agent_outlined,
                            color: cs.tertiary,
                            onTap: () async {
                              try {
                                // Show loading if needed

                                final results = await Future.wait([
                                  Api().getStudentList(),
                                  Api().getTeacherList(),
                                  Api().getSupportCategories(),
                                ]);

                                c.studentsList
                                    .assignAll(results[0] as List<Student>);
                                c.teacherList
                                    .assignAll(results[1] as List<Teacher>);
                                c.categoryList
                                    .assignAll(results[2] as List<Syllabus>);

                                showSupportDialog(
                                    context: context,
                                    titleController: c.titleController,
                                    descriptionController:
                                        c.descriptionController,
                                    categoryList: c.categoryList,
                                    studentsList: c.studentsList,
                                    teacherList: c.teacherList,
                                    selectedType: c.selectedType,
                                    categoryLabel: (item) => item.name,
                                    onCategoryChanged: (category) {
                                      // c.selectedCategory.value = category;
                                    },
                                    onStudentChanged: (student) {
                                      // c.selectedStudent.value = student;
                                    },
                                    onTeacherChanged: (teacher) {
                                      c.selectedTeacher.value = teacher;
                                    },
                                    onSubmit: () {
                                      // c.createTicket();
                                    });
                              } catch (e) {
                                Get.snackbar(
                                  'Error',
                                  'Failed to load support data',
                                );
                              }
                            },
                          ),
                        ),
                      ],
                    ),
                ],
              ),
            );
          },
        ),
      ],
    );
  }

  // void addSupport(BuildContext context) {
  //   CustomWidgets().showCustomDialog(
  //     context: context,
  //     title: Text('Add New Ticket'),
  //     submitWidget: Text(
  //       "Add",
  //       style: Theme.of(context)
  //           .textTheme
  //           .bodyMedium!
  //           .copyWith(color: Colors.white),
  //     ),
  //     icon: Icons.support_agent_outlined,
  //     formKey: GlobalKey<FormState>(),
  //     sections: [
  //       SizedBox(
  //         height: MediaQuery.of(context).size.height * 0.5,
  //         child: SingleChildScrollView(
  //           child: Column(
  //             crossAxisAlignment: CrossAxisAlignment.start,
  //             children: [
  //               CustomWidgets().labelWithAsterisk('Title', required: true),
  //               SizedBox(height: 8),
  //               CustomWidgets().dropdownStyledTextField(
  //                   context: context,
  //                   hint: 'Enter ticket title',
  //                   controller: c.titleController),
  //               SizedBox(height: 12),
  //               CustomWidgets().labelWithAsterisk('Category', required: true),
  //               SizedBox(height: 8),
  //               CustomWidgets().customDropdownField(
  //                 context: context,
  //                 hint: 'Select category',
  //                 itemLabel: (item) => item.name,
  //                 items: c.categoryList,
  //                 onChanged: (p0) {},
  //               ),
  //               SizedBox(height: 12),
  //               CustomWidgets().labelWithAsterisk('Priority', required: true),
  //               SizedBox(height: 8),
  //               CustomWidgets().customDropdownField(
  //                 context: context,
  //                 hint: 'Select priority',
  //                 itemLabel: (item) => item,
  //                 items: ['High', 'Medium', 'Low'],
  //                 onChanged: (p0) {},
  //               ),
  //               SizedBox(height: 12),
  //               CustomWidgets().labelWithAsterisk('User', required: true),
  //               SizedBox(height: 8),
  //               Obx(() => Row(
  //                     children: [
  //                       Expanded(
  //                         child: RadioListTile(
  //                           dense: true,
  //                           title: Text('Student'),
  //                           value: "student",
  //                           groupValue: c.selectedType.value,
  //                           onChanged: (value) {
  //                             if (value != null) {
  //                               c.selectedType.value = value;
  //                             }
  //                           },
  //                         ),
  //                       ),
  //                       Expanded(
  //                         child: RadioListTile(
  //                           dense: true,
  //                           title: Text('Teacher'),
  //                           value: "teacher",
  //                           groupValue: c.selectedType.value,
  //                           onChanged: (value) => c.selectedType.value = value!,
  //                         ),
  //                       ),
  //                     ],
  //                   )),
  //               SizedBox(height: 8),
  //               Obx(() {
  //                 if (c.selectedType.value == 'student') {
  //                   return CustomWidgets().customDropdownField(
  //                       items: c.studentsList,
  //                       onChanged: (p0) {},
  //                       context: context,
  //                       itemLabel: (item) =>
  //                           "${item.name} (${item.studentId})" ?? '',
  //                       hint: 'Select student');
  //                 }
  //                 if (c.selectedType.value == 'teacher') {
  //                   return CustomWidgets().customDropdownField<Teacher>(
  //                       items: c.teacherList,
  //                       onChanged: (p0) {},
  //                       context: context,
  //                       itemLabel: (item) =>
  //                           "${item.name} (${item.teacherId})" ?? '',
  //                       hint: 'Select teacher');
  //                 }
  //                 return SizedBox();
  //               }),
  //               SizedBox(height: 12),
  //               CustomWidgets().labelWithAsterisk('Attachment'),
  //               SizedBox(height: 8),
  //               CustomWidgets().mediaPickerField(
  //                 context: context,
  //                 // fileName: c.selectedFile.value?.path.split('/').last,
  //                 onTap: () async {
  //                   // await c.pickMedia();
  //                 },
  //                 onClear: () {
  //                   // c.selectedMedia.value = null;
  //                 },
  //               ),
  //               SizedBox(height: 12),
  //               CustomWidgets()
  //                   .labelWithAsterisk('Description', required: true),
  //               SizedBox(height: 8),
  //               CustomWidgets().dropdownStyledTextField(
  //                 context: context,
  //                 hint: 'Describe the issue...',
  //                 controller: c.descriptionController,
  //                 isMultiline: true,
  //               ),
  //               SizedBox(height: 16),
  //             ],
  //           ),
  //         ),
  //       ),
  //     ],
  //     onSubmit: () {},
  //   );
  // }

  void editSession(BuildContext context, BatchSession data) {
    final selectedTeacher = Rxn<Teacher>(data.teachers);
    final selectedDate = Rxn<DateTime>(data.date);
    final selectedTime = Rxn<TimeOfDay>(data.startTime);
    if (data.startTime != null) {
      c.timeController.text = formatTime(data.startTime!);
    }

    // Controllers
    c.dateController.text =
        DateFormat('dd/MM/yyyy').format(data.date ?? DateTime.now());

    c.salaryController.text = data.salaryPerHour?.toString() ?? '';

    CustomWidgets().showCustomDialog(
      context: context,
      title: Text('Edit Batch Session'),
      icon: Icons.edit_outlined,
      submitWidget: Text(
        "Update",
        style: Theme.of(context)
            .textTheme
            .bodyMedium!
            .copyWith(color: Colors.white),
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
                        // selectedDate.value = date;
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
                value: data.duration != null
                    ? "${data.duration!.inMinutes} minutes"
                    : null,
                onChanged: (p0) {
                  // selectedDuration.value = int.tryParse(
                  //       p0.split(" ").first ?? "0",
                  //     ) ??
                  //     0;
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
    switch (status) {
      case "started":
        return Theme.of(context).colorScheme.onInverseSurface;
      case "no_balance":
        return Theme.of(context).colorScheme.tertiary;
      case "no_link":
        return Theme.of(context).colorScheme.error;
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
}

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
          style: Theme.of(context)
              .textTheme
              .bodySmall!
              .copyWith(color: Colors.white)),
      style: ElevatedButton.styleFrom(
        backgroundColor: color,
        elevation: 0,
        padding: const EdgeInsets.symmetric(vertical: 12),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      ),
    );
  }
}
