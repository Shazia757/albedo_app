import 'package:albedo_app/controller/batch_list_controller.dart';
import 'package:albedo_app/model/batch_model.dart';
import 'package:albedo_app/widgets/custom_card.dart';
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
            const SizedBox(width: 8),
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
          const SizedBox(width: 10),
          searchToggle,
        ],
      );
    });
  }
}

class BatchCard extends StatelessWidget {
  final Batch batch;
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
                        batch.id ?? "—",
                        style: TextStyle(
                          fontSize: 11,
                          fontFamily: 'monospace',
                          color: textSecondary,
                          letterSpacing: 0.3,
                        ),
                      ),
                    ),
                    StatusBadge(
                      status: batch.status ?? "",
                      color: statusColor,
                    ),
                  ],
                ),

                const SizedBox(height: 8),

                Divider(
                  height: 16,
                  thickness: 0.8,
                  color: dividerColor,
                ),

                const SizedBox(height: 10),

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
                          const SizedBox(width: 8),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  batch.batchName ?? "—",
                                  style: TextStyle(
                                    fontSize: 13,
                                    fontWeight: FontWeight.w500,
                                    color: textPrimary,
                                  ),
                                  overflow: TextOverflow.ellipsis,
                                ),
                                const SizedBox(height: 2),
                                Text(
                                  "Batch ID: ${batch.id ?? '—'}",
                                  style: TextStyle(
                                    fontSize: 10,
                                    color: textSecondary,
                                    fontFamily: 'monospace',
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),

                    const SizedBox(width: 12),

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
                          const SizedBox(width: 8),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  batch.teacher?.name ?? "—",
                                  style: TextStyle(
                                    fontSize: 13,
                                    fontWeight: FontWeight.w500,
                                    color: textPrimary,
                                  ),
                                  overflow: TextOverflow.ellipsis,
                                ),
                                const SizedBox(height: 2),
                                Text(
                                  "ID: ${batch.teacher?.id ?? '—'}",
                                  style: TextStyle(
                                    fontSize: 10,
                                    color: textSecondary,
                                    fontFamily: 'monospace',
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

                const SizedBox(height: 10),

                Divider(
                  height: 16,
                  thickness: 0.8,
                  color: dividerColor,
                ),

                const SizedBox(height: 10),

                // ── Row 3: Meta ───────────────────────────────
                Row(
                  children: [
                    Expanded(
                      child: MetaItem(
                        label: "Date",
                        value: formatDate(
                          batch.date ?? DateTime.now(),
                        ),
                        textSecondary: textSecondary,
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: MetaItem(
                        label: "Time",
                        value:
                            "${batch.startTime ?? "-"} - ${batch.endTime ?? "-"}",
                        textSecondary: textSecondary,
                      ),
                    ),
                  ],
                ),

                if (batch.syllabus != null && batch.syllabus!.isNotEmpty) ...[
                  const SizedBox(height: 10),
                  MetaItem(
                    label: "Syllabus",
                    value: batch.syllabus!,
                    textSecondary: textSecondary,
                  ),
                ],
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class AddBatchSessionFAB extends StatelessWidget {
  final BatchListController c;

  const AddBatchSessionFAB({super.key, required this.c});

  @override
  Widget build(BuildContext context) {
    return AppFAB(
      label: "Add Session",
      onPressed: () => _openDialog(context),
    );
  }

  void _openDialog(BuildContext context) {
    AppFormDialog.show(
      context: context,
      title: const Text("Add Session"),
      onSubmit: () {},
      children: [
        SizedBox(
          height: MediaQuery.of(context).size.height * 0.75,
          child: SingleChildScrollView(
            child: Column(
              children: [
                CustomWidgets()
                    .labelWithAsterisk('Select Batch', required: true),
                const SizedBox(height: 10),
                CustomWidgets().customDropdownField(
                  context: context,
                  hint: 'Select Batch',
                  items: c.batches,
                  onChanged: (p0) => c.selectedBatch.value = p0,
                ),
                const SizedBox(height: 10),
                CustomWidgets()
                    .labelWithAsterisk('Select Teacher', required: true),
                const SizedBox(height: 10),
                CustomWidgets().customDropdownField(
                  context: context,
                  hint: 'Select Teacher',
                  items: c.teachersList,
                  onChanged: (p0) => c.selectedTeacher.value = p0,
                ),
                const SizedBox(height: 10),
                CustomWidgets().labelWithAsterisk(
                    'Teacher Salary (per hour - optional)',
                    required: true),
                const SizedBox(height: 10),
                CustomWidgets().dropdownStyledTextField(
                    context: context,
                    hint: 'Teacher Salary',
                    controller: c.salaryController,
                    isNumber: true),
                const SizedBox(height: 10),
                CustomWidgets().labelWithAsterisk('Class Date', required: true),
                const SizedBox(height: 10),
                CustomWidgets().customDatePickerField(
                  context: context,
                  controller: c.dateController,
                  selectedDate: c.selectedDate,
                ),
                const SizedBox(height: 10),
                CustomWidgets().labelWithAsterisk('Class Time', required: true),
                const SizedBox(height: 10),
                CustomWidgets().timePickerStyledField(
                    context: context,
                    controller: c.timeController,
                    selectedTime: c.selectedTime),
                const SizedBox(height: 10),
                CustomWidgets()
                    .labelWithAsterisk('Select Duration', required: true),
                const SizedBox(height: 20),
                CustomWidgets().customDropdownField(
                  context: context,
                  hint: 'Select Duration',
                  items:
                      c.durationOptions.map((e) => "${(e)} minutes").toList(),
                  onChanged: (p0) {},
                )
              ],
            ),
          ),
        ),
      ],
    );
  }
}
