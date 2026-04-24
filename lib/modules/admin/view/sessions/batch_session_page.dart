import 'package:albedo_app/controller/batch_list_controller.dart';
import 'package:albedo_app/model/batch_model.dart';
import 'package:albedo_app/widgets/responsive.dart';
import 'package:albedo_app/widgets/session_widgets.dart';
import 'package:albedo_app/widgets/widgets.dart';
import 'package:albedo_app/widgets/custom_appbar.dart';
import 'package:albedo_app/widgets/custom_card.dart';
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

    return Scaffold(
      appBar: const CustomAppBar(),
      backgroundColor: Theme.of(context).colorScheme.onPrimary,
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
                  _topBar(context, c),
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
                        return const Center(
                            child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(Icons.inbox, size: 40, color: Colors.grey),
                            SizedBox(height: 10),
                            Text("No batches found"),
                            Text("Try changing filters or search"),
                          ],
                        ));
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
                              borderRadius: BorderRadius.circular(16),
                              onTap: () => _openBatchDetails(context, data, i),
                              child: InfoCard(
                                id: data[i].id ?? '',
                                status: data[i].status ?? '',
                                statusColor: getStatusColor(
                                    context, data[i].status ?? ''),
                                infoRows: [
                                  _buildBatchPersonSection(context, data[i]),
                                  _buildBatchDetailsSection(context, data[i]),
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

  void _openBatchDetails(
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
                                infoRow("Syllabus", data.syllabus!),
                            ],
                          ),

                          /// 🚦 STATUS
                          infoCard(
                            context,
                            type: "status",
                            icon: Icons.flag,
                            title: "Status",
                            children: [
                              infoRow("Current Status", data.status ?? "-"),
                            ],
                          ),

                          const SizedBox(height: 10),

                          if (data.status != 'completed')
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                SizedBox(
                                  width: 110,
                                  child: ElevatedButton.icon(
                                    style: ElevatedButton.styleFrom(
                                      backgroundColor: Theme.of(context)
                                          .colorScheme
                                          .secondary,
                                    ),
                                    onPressed: () {
                                      c.loadBatch(data);
                                      editSession(context);
                                    },
                                    icon: const Icon(Icons.edit,
                                        size: 16, color: Colors.white),
                                    label: const Text(
                                      "Edit",
                                      style: TextStyle(color: Colors.white),
                                    ),
                                  ),
                                ),
                                const SizedBox(width: 8),
                                SizedBox(
                                  width: 110,
                                  child: ElevatedButton.icon(
                                    onPressed: () {
                                      CustomWidgets().showDeleteDialog(
                                        context: context,
                                        text: "Delete this batch permanently?",
                                        onConfirm: () =>
                                            c.delete(data.id ?? ''),
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
      "teacher": () {
        final t = c.getTeacherById(id);
        if (t != null)
          openTeacherProfile(
            context,
            t,
            toUser: (p0) => c.teacherToUser(t),
          );
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

  void openBatchProfile(BuildContext context, Batch data) {
    final primary = Theme.of(context).colorScheme.primary;
    openProfileDialog(
        context: context,
        title: 'Batch profile',
        icon: Icons.people,
        color: Theme.of(context).colorScheme.primary,
        content: SingleChildScrollView(
          child: Column(children: [
            profileHeader<Batch>(
              context: context,
              data: data,
              color: primary,
              getName: (b) => b.batchName ?? "-",
              getEmail: (_) => null,
              getId: (b) => b.batchID,
              getImageUrl: (b) => b.imageUrl,
              getStatus: (p0) => p0.status,
            ),
            const SizedBox(height: 10),
            infoCard(
              context,
              type: "schedule",
              icon: Icons.calendar_today,
              title: "Course Details",
              children: [
                infoRow("Course", data.course ?? ''),
                infoRow(
                  "Duration",
                  "${data.duration ?? 0} days",
                ),
              ],
            ),
            infoCard(
              context,
              type: "batch",
              icon: Icons.bar_chart,
              title: "Batch Statistics",
              children: [
                infoRow("Students", data.students.toString()),
                infoRow("Packages", data.package!.length.toString()),
              ],
            ),
            infoCard(
              context,
              type: "status",
              icon: Icons.account_balance_wallet,
              title: "Payment Summary",
              children: [
                infoRow("Total Fee", data.totalFee.toString()),
                infoRow("Total Paid", data.totalPaid.toString()),
                infoRow("Balance", data.balance.toString()),
                infoRow("Expense Ratio", data.expenseRatio.toString()),
              ],
            ),
            profileCard(
              context,
              color: Colors.indigo,
              title: "Assigned Personnel",
              children: [
                if (data.coordinatorName != null)
                  detailCard(
                    context,
                    title: "Coordinator",
                    name: data.coordinatorName ?? "-",
                    id: data.coordinatorId ?? "-",
                    onTap: () {},
                  ),
                if (data.coordinatorName == null)
                  simpleText("No coordinator assigned"),
                const SizedBox(height: 6),
                EditableDetailCard(
                  type: "mentor",
                  title: "Mentor",
                  name: data.mentorName ?? "",
                  id: data.mentorId ?? "",
                  field1Label: "Name",
                  field2Label: "ID",
                  onSave: (name, id) {
                    data.mentorName = name;
                    data.mentorId = id;
                  },
                ),
              ],
            ),
          ]),
        ));
  }

  FloatingActionButton addSessionBtn(BuildContext context) {
    return FloatingActionButton(
      onPressed: () => CustomWidgets().showCustomDialog(
        context: context,
        title: Text("Add Session"),
        formKey: GlobalKey<FormState>(),
        onSubmit: () {},
        sections: [
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
                  CustomWidgets()
                      .labelWithAsterisk('Class Date', required: true),
                  const SizedBox(height: 10),
                  CustomWidgets().customDatePickerField(
                    context: context,
                    controller: c.dateController,
                    selectedDate: c.selectedDate,
                  ),
                  const SizedBox(height: 10),
                  CustomWidgets()
                      .labelWithAsterisk('Class Time', required: true),
                  const SizedBox(height: 10),
                  CustomWidgets().timePickerStyledField(
                      context: context,
                      controller: c.timeController,
                      selectedTime: c.selectedTime),
                  const SizedBox(height: 10),
                  CustomWidgets()
                      .labelWithAsterisk('Select Duration', required: true),
                  const SizedBox(height: 20),
                  CustomWidgets().durationPickerStyledField(
                      context: context,
                      hint: 'Select Duration',
                      controller: c.durationController,
                      selectedDuration: c.selectedDuration)
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

  Widget _buildBatchPersonSection(BuildContext context, Batch data) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final isSmall = constraints.maxWidth < 320;

        return isSmall
            ? Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      _personCompact(
                        context,
                        "Batch",
                        data.batchName ?? '',
                        data.batchID ?? '',
                      ),
                      const SizedBox(height: 8),
                      _personCompact(
                        context,
                        "Teacher",
                        data.teacher?.name ?? '',
                        data.teacher?.id ?? '',
                      ),
                    ],
                  ),
                ],
              )
            : Row(
                children: [
                  Expanded(
                    child: _personCompact(
                      context,
                      "Batch",
                      data.batchName ?? '',
                      data.batchID ?? '',
                    ),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: _personCompact(
                      context,
                      "Teacher",
                      data.teacher?.name ?? '',
                      data.teacher?.id ?? '',
                    ),
                  ),
                ],
              );
      },
    );
  }

  Widget _buildBatchDetailsSection(BuildContext context, Batch data) {
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
              ? Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // _miniInfo(
                        //     context: context,
                        //     label: "package",
                        //     value: data.package ?? ''),
                        if (data.syllabus != null && data.syllabus != '')
                          _miniInfo(
                              context: context,
                              label: "Syllabus",
                              value: data.syllabus ?? ''),
                      ],
                    ),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        _miniInfo(
                            context: context,
                            label: "Date",
                            value: data.date.toString()),
                        _miniInfo(
                          context: context,
                          label: "Time",
                          value: "${data.startTime} - ${data.endTime}",
                        ),
                      ],
                    ),
                  ],
                )

              /// 🔥 DESKTOP/TABLET → 2 COLUMN STRUCTURE
              : Row(
                  children: [
                    /// LEFT COLUMN
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // _miniInfo(
                          //     context: context,
                          //     label: "Package",
                          //     value: data.package ?? ''),
                          const SizedBox(height: 6),
                          if (data.syllabus != null && data.syllabus != '')
                            _miniInfo(
                                context: context,
                                label: "Syllabus",
                                value: data.syllabus ?? ''),
                        ],
                      ),
                    ),

                    const SizedBox(width: 12),

                    /// RIGHT COLUMN
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          _miniInfo(
                              context: context,
                              label: "Date",
                              value: data.date.toString()),
                          const SizedBox(height: 6),
                          if (data.startTime != null)
                            _miniInfo(
                              context: context,
                              label: "Time",
                              value: "${data.startTime} - ${data.endTime}",
                            ),
                        ],
                      ),
                    ),
                  ],
                ),
        );
      },
    );
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

  Widget _topBar(BuildContext context, BatchListController c) {
    final isMobile = Responsive.isMobile(context);

    return Obx(() {
      final searching = c.isSearching.value;

      /// =========================
      /// MOBILE
      /// =========================
      if (isMobile) {
        return Row(
          children: [
            const SizedBox(width: 10),
            if (!searching)
              Expanded(
                child: Text(
                  "Batches",
                  style: Theme.of(context).textTheme.titleLarge,
                ),
              )
            else
              Expanded(
                child: CustomWidgets().premiumSearch(
                  context,
                  hint: "Search batches...",
                  onChanged: (val) {
                    c.searchQuery.value = val;
                    c.applyFilters();
                  },
                ),
              ),
            IconButton(
              icon: Icon(searching ? Icons.close : Icons.search),
              onPressed: () {
                c.isSearching.value = !searching;

                if (searching) {
                  c.searchQuery.value = "";
                  c.applyFilters();
                }
              },
            ),
          ],
        );
      }

      /// =========================
      /// DESKTOP
      /// =========================
      return Row(
        children: [
          /// TITLE / SEARCH (LEFT)
          if (!searching)
            Expanded(
              flex: 2,
              child: Text(
                "Batches",
                style: Theme.of(context).textTheme.titleLarge,
              ),
            )
          else
            Expanded(
              flex: 3,
              child: CustomWidgets().premiumSearch(
                context,
                hint: "Search batches...",
                onChanged: (val) {
                  c.searchQuery.value = val;
                  c.applyFilters();
                },
              ),
            ),

          /// SEARCH TOGGLE ICON
          IconButton(
            icon: Icon(searching ? Icons.close : Icons.search),
            onPressed: () {
              c.isSearching.value = !searching;

              if (searching) {
                c.searchQuery.value = "";
                c.applyFilters();
              }
            },
          ),
        ],
      );
    });
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
        return Theme.of(context).colorScheme.onTertiary;
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
