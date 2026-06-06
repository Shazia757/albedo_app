import 'package:albedo_app/controller/batch_list_controller.dart';
import 'package:albedo_app/model/batch_model.dart';
import 'package:albedo_app/model/session_model.dart';
import 'package:albedo_app/model/users/student_model.dart';
import 'package:albedo_app/model/users/teacher_model.dart';
import 'package:albedo_app/widgets/responsive.dart';
import 'package:albedo_app/widgets/session_widgets.dart';
import 'package:albedo_app/widgets/widgets.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class BatchTopBar extends StatelessWidget {
  final BatchListController c;

  const BatchTopBar({super.key, required this.c});

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    final isMobile = Responsive.isMobile(context);

    return Obx(() {
      final searching = c.isSearching.value;

      Widget searchField = CustomWidgets().premiumSearch(
        context,
        hint: "Search batches...",
        onChanged: (val) {
          c.searchQuery.value = val;
          c.applyFilters();
        },
      );

      Widget pageTitle = Text(
        "Batches",
        style: Theme.of(context).textTheme.titleLarge?.copyWith(
              fontWeight: FontWeight.w700,
            ),
      );

      Widget searchToggle = IconChip(
        icon: searching ? Icons.close : Icons.search_rounded,
        cs: cs,
        onTap: () {
          c.isSearching.value = !searching;
          if (!searching) return;
          c.searchQuery.value = "";
        },
      );

      if (isMobile) {
        return Row(
          children: [
            Expanded(child: searching ? searchField : pageTitle),
            SizedBox(width: 8),
            searchToggle,
          ],
        );
      }

      return Row(
        children: [
          if (!searching) ...[
            pageTitle,
            const Spacer(),
          ] else ...[
            Expanded(child: searchField),
          ],
          SizedBox(width: 10),
          searchToggle,
        ],
      );
    });
  }
}

class BatchCard extends StatelessWidget {
  final BatchSession batch;
  final Color statusColor;
  final VoidCallback onTap;

  const BatchCard({
    super.key,
    required this.batch,
    required this.statusColor,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    final textPrimary = cs.onSurface;
    final textSecondary = cs.onSurface.withOpacity(0.5);
    final dividerColor = cs.outline.withOpacity(0.12);
    final teacher = batch.teachers;

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
            padding: const EdgeInsets.all(14),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // ── Row 1: ID + Status ───────────────────────────────
                Row(
                  children: [
                    Expanded(
                      child: Text(
                        batch.id != null && batch.id!.length >= 4
                            ? batch.id!.substring(batch.id!.length - 4)
                            : "—",
                        style: Theme.of(context)
                            .textTheme
                            .labelSmall!
                            .copyWith(color: textSecondary, letterSpacing: 0.3),
                      ),
                    ),
                    // StatusBadge(
                    //   status: batch.status ?? "",
                    //   color: statusColor,
                    // ),
                  ],
                ),

                SizedBox(height: 8),

                Divider(
                  height: 16,
                  thickness: 0.8,
                  color: dividerColor,
                ),

                SizedBox(height: 10),

                // ── Row 2: Batch + Teacher (profile style) ───────────
                Row(
                  children: [
                    // ── Batch ─────────────────────────────
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
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  batch.batchName ?? "—",
                                  style: Theme.of(context)
                                      .textTheme
                                      .titleSmall!
                                      .copyWith(color: textPrimary),
                                  overflow: TextOverflow.ellipsis,
                                ),
                                SizedBox(height: 2),
                                Text(
                                  batch.batchID ?? '—',
                                  style: Theme.of(context)
                                      .textTheme
                                      .labelSmall!
                                      .copyWith(color: textSecondary),
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
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  teacher?.name ?? "—",
                                  style: Theme.of(context)
                                      .textTheme
                                      .titleSmall!
                                      .copyWith(color: textPrimary),
                                  overflow: TextOverflow.ellipsis,
                                ),
                                SizedBox(height: 2),
                                Text(
                                  teacher?.teacherId ?? '—',
                                  style: Theme.of(context)
                                      .textTheme
                                      .labelSmall!
                                      .copyWith(
                                        color: textSecondary,
                                      ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),

                SizedBox(height: 10),

                Divider(
                  height: 16,
                  thickness: 0.8,
                  color: dividerColor,
                ),

                SizedBox(height: 10),

                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    /// SUBJECT
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            "Subject",
                            style: Get.textTheme.labelSmall!.copyWith(
                              color: textSecondary,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            batch.packageName ?? "-",
                            style: Get.textTheme.labelMedium,
                          ),
                          const SizedBox(height: 2),
                          Text(
                            batch.syllabus ?? "-",
                            style: Get.textTheme.bodySmall!.copyWith(
                              color: textSecondary,
                            ),
                          ),
                        ],
                      ),
                    ),

                    const SizedBox(width: 16),

                    /// TIME
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            "Schedule",
                            style: Get.textTheme.labelSmall!.copyWith(
                              color: textSecondary,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            formatDate(batch.date ?? DateTime.now()),
                            style: Get.textTheme.labelMedium,
                          ),
                          const SizedBox(height: 2),
                          Text(
                            "${formatTime(batch.startTime)} - ${formatTime(batch.endTime)}",
                            style: Get.textTheme.bodySmall!.copyWith(
                              color: textSecondary,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}

void showSupportDialog({
  required BuildContext context,
  required TextEditingController titleController,
  required TextEditingController descriptionController,

  required List<dynamic> categoryList,
  required List<Student> studentsList,
  required List<Teacher> teacherList,

  required RxString selectedType,

  required String Function(dynamic) categoryLabel,
  required VoidCallback onSubmit,

  Function(dynamic)? onCategoryChanged,
  Function(String?)? onPriorityChanged,
  Function(Student?)? onStudentChanged,
  Function(Teacher?)? onTeacherChanged,

  Future<void> Function()? onAttachmentTap,
  VoidCallback? onAttachmentClear,
}) {
  CustomWidgets().showCustomDialog(
    context: context,
    title: const Text('Add New Ticket'),
    submitWidget: Text(
      "Add",
      style: Theme.of(context)
          .textTheme
          .bodyMedium!
          .copyWith(color: Colors.white),
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
              CustomWidgets().labelWithAsterisk(
                'Title',
                required: true,
              ),
              const SizedBox(height: 8),
              CustomWidgets().dropdownStyledTextField(
                context: context,
                hint: 'Enter ticket title',
                controller: titleController,
              ),

              const SizedBox(height: 12),

              CustomWidgets().labelWithAsterisk(
                'Category',
                required: true,
              ),
              const SizedBox(height: 8),

              CustomWidgets().customDropdownField(
                context: context,
                hint: 'Select category',
                itemLabel: categoryLabel,
                items: categoryList,
                onChanged:(p0) {
                  onCategoryChanged?.call(p0);
                } 
              ),

              const SizedBox(height: 12),

              CustomWidgets().labelWithAsterisk(
                'Priority',
                required: true,
              ),
              const SizedBox(height: 8),

              CustomWidgets().customDropdownField<String>(
                context: context,
                hint: 'Select priority',
                itemLabel: (item) => item,
                items: const ['High', 'Medium', 'Low'],
            onChanged: (value) {
  onPriorityChanged?.call(value);
},
              ),

              const SizedBox(height: 12),

              CustomWidgets().labelWithAsterisk(
                'User',
                required: true,
              ),
              const SizedBox(height: 8),

              Obx(
                () => Row(
                  children: [
                    Expanded(
                      child: RadioListTile<String>(
                        dense: true,
                        title: const Text('Student'),
                        value: "student",
                        groupValue: selectedType.value,
                        onChanged: (value) {
                          if (value != null) {
                            selectedType.value = value;
                          }
                        },
                      ),
                    ),
                    Expanded(
                      child: RadioListTile<String>(
                        dense: true,
                        title: const Text('Teacher'),
                        value: "teacher",
                        groupValue: selectedType.value,
                        onChanged: (value) {
                          if (value != null) {
                            selectedType.value = value;
                          }
                        },
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 8),

              Obx(() {
                if (selectedType.value == 'student') {
                  return CustomWidgets().customDropdownField<Student>(
                    context: context,
                    hint: 'Select student',
                    items: studentsList,
                    itemLabel: (item) =>
                        '${item.name} (${item.studentId})',
                 onChanged: (value) {
  onStudentChanged?.call(value);
},
                  );
                }

                return CustomWidgets().customDropdownField<Teacher>(
                  context: context,
                  hint: 'Select teacher',
                  items: teacherList,
                  itemLabel: (item) =>
                      '${item.name} (${item.teacherId})',
                 onChanged: (value) {
  onTeacherChanged?.call(value);
},
                );
              }),

              const SizedBox(height: 12),

              CustomWidgets().labelWithAsterisk('Attachment'),
              const SizedBox(height: 8),

              CustomWidgets().mediaPickerField(
                context: context,
                onTap: onAttachmentTap,
                onClear: onAttachmentClear,
              ),

              const SizedBox(height: 12),

              CustomWidgets().labelWithAsterisk(
                'Description',
                required: true,
              ),
              const SizedBox(height: 8),

              CustomWidgets().dropdownStyledTextField(
                context: context,
                hint: 'Describe the issue...',
                controller: descriptionController,
                isMultiline: true,
              ),
            ],
          ),
        ),
      ),
    ],
    onSubmit: onSubmit,
  );
}