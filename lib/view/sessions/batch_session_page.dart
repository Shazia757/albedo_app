import 'package:albedo_app/controller/batch_list_controller.dart';
import 'package:albedo_app/model/batch_model.dart';
import 'package:albedo_app/widgets/batch_widgets.dart';
import 'package:albedo_app/widgets/responsive.dart';
import 'package:albedo_app/widgets/session_widgets.dart';
import 'package:albedo_app/widgets/widgets.dart';
import 'package:albedo_app/widgets/custom_appbar.dart';
import 'package:albedo_app/widgets/drawer_menu.dart';
import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:get/get.dart';

class BatchesListPage extends StatelessWidget {
  final c = Get.put(BatchListController());

  BatchesListPage({super.key});

  @override
  Widget build(BuildContext context) {
    final isDesktop = Responsive.isDesktop(context);
    final cs = Theme.of(context).colorScheme;

    return Scaffold(
      appBar: const CustomAppBar(),
      backgroundColor: Theme.of(context).colorScheme.surface,
      floatingActionButton: addSessionBtn(context),
      drawer: isDesktop ? null : const DrawerMenu(),
      body: Row(
        children: [
          if (isDesktop) const DrawerMenu(),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                children: [
                  BatchTopBar(c: c),
                  const SizedBox(height: 12),
                  Obx(
                    () => CustomWidgets().customTabs(context,
                        tabs: c.tabs,
                        selectedIndex: c.selectedTab.value,
                        getCount: (index) => c.batchList
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
                      final data = c.filteredBatches;

                      if (c.isLoading.value) {
                        return const Center(child: CircularProgressIndicator());
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
                            itemBuilder: (_, i) => BatchCard(
                              batch: data[i],
                              statusColor:
                                  getStatusColor(context, data[i].status ?? ""),
                              onTap: () => openBatchDetails(context, data, i),
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

  void openBatchDetails(
    BuildContext context,
    List<Batch> batches,
    int currentIndex,
  ) {
    int index = currentIndex;

    CustomWidgets().showCustomDialog(
      context: context,
      title: const Text(
        "Batch Details",
        style: TextStyle(color: Colors.white),
      ),
      icon: Icons.groups,
      formKey: GlobalKey<FormState>(),
      submitText: "Close",
      onSubmit: () {},
      isViewOnly: true,
      sections: [
        StatefulBuilder(
          builder: (context, setState) {
            final data = batches[index];
            final cs = Theme.of(context).colorScheme;

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
                        "Batch ${index + 1}/${batches.length}",
                        style: Theme.of(context).textTheme.labelMedium,
                      ),
                      IconButton(
                        onPressed: index < batches.length - 1
                            ? () => setState(() => index++)
                            : null,
                        icon: const Icon(Icons.arrow_forward_ios),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  Expanded(
                    child: SingleChildScrollView(
                      child: Column(
                        children: [
                          detailCard(
                            context,
                            title: "Batch",
                            name: data.batchName ?? "-",
                            id: data.batchID ?? "-",
                            onTap: () =>
                                _onUserTap(context, "batch", data.batchID),
                          ),

                          detailCard(
                            context,
                            title: "Teacher",
                            name: data.teacher?.name ?? "-",
                            id: data.teacher?.id ?? "-",
                            onTap: () => _onUserTap(
                                context, "teacher", data.teacher?.id),
                          ),

                          const SizedBox(height: 10),

                          /// 📅 SCHEDULE
                          EditableInfoCard(
                            type: "schedule",
                            icon: Icons.schedule,
                            title: "Schedule",
                            date: formatDate(data.date ?? DateTime.now()),
                            time: data.startTime ?? '',
                            duration: data.duration?.toString() ?? "-",
                            onSave: (date, time) {
                              // update
                            },
                          ),

                          /// 📘 DETAILS
                          infoCard(
                            context,
                            type: "batch",
                            icon: Icons.menu_book,
                            title: "Batch Info",
                            children: [
                              // infoRow("Package", data.package ?? "-"),
                              if (data.syllabus != null &&
                                  data.syllabus!.isNotEmpty)
                                infoRow(
                                    label: "Syllabus", value: data.syllabus!),
                            ],
                          ),

                          /// 🚦 STATUS
                          infoCard(
                            context,
                            type: "status",
                            icon: Icons.flag,
                            title: "Status",
                            children: [
                              infoRow(
                                  label: "Current Status",
                                  value: data.status ?? "-"),
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
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
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
                                          icon:
                                              const Icon(Icons.edit, size: 18),
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
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      // 📦 HEADER
                                      ListTile(
                                        contentPadding: EdgeInsets.zero,
                                        title: Text(report.studentName),
                                        subtitle: const Text("Session Report"),
                                        trailing: TextButton.icon(
                                          onPressed: () =>
                                              c.openSessionReportDialog(data),
                                          icon:
                                              const Icon(Icons.edit, size: 18),
                                          label: const Text("Edit Report"),
                                        ),
                                      ),

                                      const SizedBox(height: 8),

                                      // 🎯 ALWAYS SHOW FOR COMPLETED
                                      infoRow(
                                        label: "Topics Covered",
                                        value: report.topicsCovered ?? "-",
                                      ),

                                      infoRow(
                                        label: "Teacher Notes",
                                        value: report.teacherNotes ?? "-",
                                      ),
                                    ],
                                  );
                                }),
                              ],
                            ),

                          if (data.status != 'completed')
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Expanded(
                                  child: _DetailActionButton(
                                    label: "Edit",
                                    icon: Icons.edit_outlined,
                                    color: cs.secondary,
                                    onTap: () {
                                      c.loadBatch(data);
                                      editSession(context);
                                    },
                                  ),
                                ),
                                const SizedBox(width: 8),
                                Expanded(
                                  child: _DetailActionButton(
                                    label: "Delete",
                                    icon: Icons.delete_outline,
                                    color: cs.error,
                                    onTap: () =>
                                        CustomWidgets().showDeleteDialog(
                                      text:
                                          'Are you sure you want to delete this batch permanently?',
                                      context: context,
                                      onConfirm: () => c.delete(data.id ?? ''),
                                    ),
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
                                        data.date ?? DateTime.now(),
                                      ),
                                    ),
                                  ),
                                ],
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

  FloatingActionButton addSessionBtn(BuildContext context) {
    return FloatingActionButton(
      onPressed: () => CustomWidgets().showCustomDialog(
        context: context,
        title: Text("Add Session"),
        formKey: GlobalKey<FormState>(),
        onSubmit: () {},
        sections: [],
      ),
      mini: true,
      backgroundColor: context.theme.colorScheme.primary,
      child: Icon(
        Icons.add,
        color: context.theme.colorScheme.onPrimary,
      ),
    );
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
            // CustomWidgets().customDropdownField(
            //   context: context,
            //   hint: 'Select Duration',
            //   items: c.durationOptions.map((e) => "${(e)} minutes").toList(),
            //   onChanged: (p0) {},
            // ),
          ],
        ),
      ],
      onSubmit: () {},
    );
  }

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
                // CustomWidgets().customDropdownField(
                //   context: context,
                //   hint: 'Select category',
                //   items: c.categoryList,
                //   onChanged: (p0) {},
                // ),
                const SizedBox(height: 12),
                CustomWidgets().labelWithAsterisk('Priority', required: true),
                const SizedBox(height: 8),
                // CustomWidgets().customDropdownField(
                //   context: context,
                //   hint: 'Select priority',
                //   items: ['High', 'Medium', 'Low'],
                //   onChanged: (p0) {},
                // ),
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
                  // if (c.selectedType.value == 'student') {
                  //   return CustomWidgets().customDropdownField(
                  //       items: c.studentsList,
                  //       onChanged: (p0) {},
                  //       context: context,
                  //       hint: 'Select student');
                  // }
                  // if (c.selectedType.value == 'teacher') {
                  //   return CustomWidgets().customDropdownField(
                  //       items: c.teacherList,
                  //       onChanged: (p0) {},
                  //       context: context,
                  //       hint: 'Select teacher');
                  // }
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
      "teacher": () {
        final t = c.getTeacherById(id);
        if (t != null) {
          openTeacherProfile(
            context,
            t,
            toUser: (p0) => teacherToUser(t),
          );
        }
      },
      "batch": () {
        final b = c.getBatchById(id);
        if (b != null) openBatchProfile(context, b);
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
      title: Text('Edit Batch Session'),
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
          itemLabel: (item) => "$item mins",

                      onChanged: (p0) => c.selectedDuration.value = p0),
                  const SizedBox(height: 12),
                  CustomWidgets().labelWithAsterisk('Teacher', required: true),
                  const SizedBox(height: 10),
          //         CustomWidgets().customDropdownField(

          //             context: context,
          //             hint: 'Select Teacher',
          //             items: c.teacherList,
          //             value: c.selectedTeacher.value,
          //             onChanged: (p0) => c.selectedTeacher.value = p0,
          // itemLabel: (item) => item.toString()
          //             ),
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

  Widget _miniInfo(
      {required BuildContext context, String? label, required String value}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label ?? '',
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
