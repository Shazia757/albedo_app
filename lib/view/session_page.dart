import 'package:albedo_app/controller/session_controller.dart';
import 'package:albedo_app/model/session_model.dart';
import 'package:albedo_app/widgets/custom_textfield.dart';
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
      floatingActionButton: FloatingActionButton(
        onPressed: () => CustomWidgets().showCustomDialog(
          context: context,
          title: 'Add Session',
          formKey: GlobalKey<FormState>(),
          onSubmit: () {},
          sections: [
            SingleChildScrollView(
              child: Column(
                children: [
                  Obx(
                    () => Row(
                      children: [
                        Expanded(
                          child: RadioListTile(
                            dense: true,
                            title: Text('Class Session'),
                            value: SessionType.classSession,
                            groupValue: c.selectedSessionType.value,
                            onChanged: (value) =>
                                c.selectedSessionType.value = value!,
                          ),
                        ),
                        Expanded(
                          child: RadioListTile(
                            title: Text('Meet'),
                            value: SessionType.meet,
                            groupValue: c.selectedSessionType.value,
                            onChanged: (value) =>
                                c.selectedSessionType.value = value!,
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 20),
                  CustomWidgets()
                      .labelWithAsterisk('Select Student', required: true),
                  const SizedBox(height: 20),
                  CustomWidgets().customDropdownField(
                    context: context,
                    hint: 'Select Student',
                    items: c.studentOptions,
                    onChanged: (p0) => c.selectedStudent.value = p0,
                  ),
                  const SizedBox(height: 20),
                  CustomWidgets().labelWithAsterisk('Search and Select Teacher',
                      required: true),
                  const SizedBox(height: 20),
                  CustomWidgets().customDropdownField(
                    context: context,
                    hint: 'Select Teacher',
                    items: c.teacherList,
                    onChanged: (p0) => c.selectedTeacher.value = p0,
                  ),
                  const SizedBox(height: 20),
                  CustomWidgets().labelWithAsterisk('Teacher Salary'),
                  const SizedBox(height: 20),
                  dropdownStyledTextField(
                      context: context, hint: 'Teacher Salary'),
                  const SizedBox(height: 20),
                  CustomWidgets()
                      .labelWithAsterisk('Session Date', required: true),
                  const SizedBox(height: 20),
                  CustomWidgets()
                      .labelWithAsterisk('Select Duration', required: true),
                  const SizedBox(height: 20),
                  Obx(() => DropdownButtonFormField<int>(
                        hint: Text('Select Duration'),
                        style: TextStyle(fontSize: 13),
                        value:
                            c.durationOptions.contains(c.selectedDuration.value)
                                ? c.selectedDuration.value
                                : null,
                        items: c.durationOptions
                            .toSet()
                            .map((e) => DropdownMenuItem(
                                  value: e,
                                  child: Text("$e mins",
                                      style: TextStyle(
                                        fontSize: 13,
                                        color: Get.theme.colorScheme.onSurface,
                                      )),
                                ))
                            .toList(),
                        onChanged: (val) => c.selectedDuration.value = val,
                        decoration:
                            _dropdownDecoration(context: context, "Duration"),
                        validator: (v) => v == null ? "Required" : null,
                      )),
                ],
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
      ),
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
                      if (c.isLoading.value) {
                        return const Center(child: CircularProgressIndicator());
                      }
                      if (data.isEmpty) {
                        return const Center(child: Text("No sessions found"));
                      }

                      int crossAxisCount = 1;

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
                                  color: Theme.of(context).colorScheme.primary,
                                  onTap: () => showEditDialog(context, data[i]),
                                ),
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
                        _miniInfo(context, "Date", _formatDate(data.dateTime)),
                        SizedBox(height: 10),
                        _miniInfo(context, "Time", _formatTime(data.dateTime)),
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
                          _miniInfo(
                              context, "Date", _formatDate(data.dateTime)),
                          const SizedBox(height: 6),
                          _miniInfo(
                              context, "Time", _formatTime(data.dateTime)),
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
          onSelected: (val) {
            c.sortType.value = val;
          }),
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

  void showEditDialog(BuildContext context, Session data) {
    c.initEdit(data);

    Get.dialog(
      Dialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(28),
        ),
        insetPadding: const EdgeInsets.symmetric(horizontal: 16),
        child: Form(
          key: c.formKey,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              /// 🔷 HEADER
              Container(
                width: double.infinity,
                padding: const EdgeInsets.fromLTRB(20, 20, 20, 18),
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [
                      Get.theme.colorScheme.secondary,
                      Get.theme.colorScheme.secondary.withOpacity(0.8),
                    ],
                  ),
                  borderRadius: const BorderRadius.vertical(
                    top: Radius.circular(28),
                  ),
                ),
                child: Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(10),
                      decoration: BoxDecoration(
                        color: context.theme.colorScheme.onPrimary
                            .withOpacity(0.15),
                        shape: BoxShape.circle,
                      ),
                      child: Icon(Icons.edit,
                          color: context.theme.colorScheme.onPrimary),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Text(
                        "Edit Session",
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.w600,
                          color: context.theme.colorScheme.onPrimary,
                        ),
                      ),
                    ),
                    IconButton(
                      onPressed: () => Get.back(),
                      icon: Icon(Icons.close,
                          color: context.theme.colorScheme.onPrimary),
                    )
                  ],
                ),
              ),

              /// 🔷 BODY
              Padding(
                padding: const EdgeInsets.fromLTRB(16, 18, 16, 10),
                child: Column(
                  children: [
                    /// 🔹 SECTION: DATE & TIME
                    _sectionCard(
                      icon: Icons.schedule,
                      title: "Schedule",
                      child: Row(
                        children: [
                          Expanded(
                            child: _inputField(
                              context: context,
                              controller: c.dateController,
                              label: "Date",
                              icon: Icons.calendar_today_outlined,
                              readOnly: true,
                              onTap: () async {
                                final picked = await showDatePicker(
                                  context: Get.context!,
                                  initialDate: DateTime.now(),
                                  firstDate: DateTime(2000),
                                  lastDate: DateTime(2100),
                                );
                                if (picked != null) {
                                  c.dateController.text =
                                      "${picked.day}/${picked.month}/${picked.year}";
                                }
                              },
                            ),
                          ),
                          const SizedBox(width: 10),
                          Expanded(
                            child: _inputField(
                              context: context,
                              controller: c.timeController,
                              label: "Time",
                              icon: Icons.access_time_outlined,
                              readOnly: true,
                              onTap: () async {
                                final picked = await showTimePicker(
                                  context: Get.context!,
                                  initialTime: TimeOfDay.now(),
                                );
                                if (picked != null) {
                                  c.timeController.text =
                                      "${picked.hour}:${picked.minute}";
                                }
                              },
                            ),
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
                          /// Duration
                          Obx(() => DropdownButtonFormField<int>(
                                style: TextStyle(fontSize: 13),
                                value: c.durationOptions
                                        .contains(c.selectedDuration.value)
                                    ? c.selectedDuration.value
                                    : null,
                                items: c.durationOptions
                                    .map((e) => DropdownMenuItem(
                                          value: e,
                                          child: Text("$e mins",
                                              style: TextStyle(
                                                fontSize: 13,
                                                color: Get.theme.colorScheme
                                                    .onSurface,
                                              )),
                                        ))
                                    .toList(),
                                onChanged: (val) =>
                                    c.selectedDuration.value = val,
                                decoration: _dropdownDecoration(
                                    context: context, "Duration"),
                                validator: (v) => v == null ? "Required" : null,
                              )),

                          const SizedBox(height: 12),

                          /// Teacher
                          Obx(() => DropdownButtonFormField<String>(
                                style: TextStyle(
                                  fontSize: 13,
                                  color: Get.theme.colorScheme.onSurface,
                                ),
                                value: c.teacherList
                                        .contains(c.selectedTeacher.value)
                                    ? c.selectedTeacher.value
                                    : null,
                                items: c.teacherList
                                    .toSet()
                                    .map((e) => DropdownMenuItem(
                                          value: e,
                                          child: Text(e),
                                        ))
                                    .toList(),
                                onChanged: (val) =>
                                    c.selectedTeacher.value = val,
                                decoration: _dropdownDecoration(
                                    context: context, "Teacher"),
                                validator: (v) =>
                                    v == null || v.isEmpty ? "Required" : null,
                              )),
                        ],
                      ),
                    ),

                    const SizedBox(height: 14),

                    /// 🔹 SECTION: PAYMENT
                    _sectionCard(
                      icon: Icons.payments_outlined,
                      title: "Payment",
                      child: _inputField(
                        context: context,
                        controller: c.salaryController,
                        label: "Teacher Salary (Optional)",
                        icon: Icons.currency_rupee,
                        keyboardType: TextInputType.number,
                      ),
                    ),
                  ],
                ),
              ),

              /// 🔷 ACTIONS
              Container(
                padding: const EdgeInsets.fromLTRB(16, 10, 16, 16),
                decoration: BoxDecoration(
                  color: Colors.grey.withOpacity(0.03),
                  borderRadius: const BorderRadius.vertical(
                    bottom: Radius.circular(28),
                  ),
                ),
                child: Row(
                  children: [
                    Expanded(
                      child: OutlinedButton(
                        onPressed: () => Get.back(),
                        style: OutlinedButton.styleFrom(
                          padding: const EdgeInsets.symmetric(vertical: 14),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(14),
                          ),
                        ),
                        child: const Text("Cancel"),
                      ),
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                      child: ElevatedButton(
                        onPressed: () {
                          if (!c.formKey.currentState!.validate()) return;

                          Get.back();
                        },
                        style: ElevatedButton.styleFrom(
                          padding: const EdgeInsets.symmetric(vertical: 14),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(14),
                          ),
                        ),
                        child: const Text("Save Changes"),
                      ),
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

  Widget _sectionCard({
    required IconData icon,
    required String title,
    required Widget child,
  }) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: Colors.grey.withOpacity(0.04),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.grey.withOpacity(0.1)),
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

  Widget _inputField({
    required BuildContext context,
    required TextEditingController controller,
    required String label,
    required IconData icon,
    bool readOnly = false,
    VoidCallback? onTap,
    TextInputType? keyboardType,
  }) {
    return TextFormField(
      style: TextStyle(fontSize: 13),
      controller: controller,
      readOnly: readOnly,
      onTap: onTap,
      keyboardType: keyboardType,
      validator: (v) => (v == null || v.isEmpty) ? "Required" : null,
      decoration: InputDecoration(
        labelStyle: TextStyle(fontSize: 12),
        hintStyle: TextStyle(fontSize: 12),
        labelText: label,
        prefixIcon: Icon(icon),
        filled: true,
        fillColor: context.theme.colorScheme.onPrimary,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
        ),
      ),
    );
  }

  Widget dropdownStyledTextField({
    required BuildContext context,
    required String hint,
    TextEditingController? controller,
    bool readOnly = false,
    VoidCallback? onTap,
  }) {
    final cs = Theme.of(context).colorScheme;

    return TextFormField(
      controller: controller,
      readOnly: readOnly,
      onTap: onTap,
      decoration: InputDecoration(
        hintText: hint,
        hintStyle: TextStyle(
          fontSize: 12,
          color: context.theme.colorScheme.shadow.withOpacity(0.6),
        ),
        isDense: true,
        filled: true,
        fillColor: cs.onPrimary,
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 12,
          vertical: 11,
        ),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(
            color: cs.onPrimary,
          ),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(
            color: cs.tertiaryContainer,
          ),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(
            color: cs.onPrimary,
            width: 1.5,
          ),
        ),
      ),
    );
  }

  InputDecoration _dropdownDecoration(String label,
      {required BuildContext context}) {
    return InputDecoration(
      isDense: true,
      labelText: label,
      labelStyle: TextStyle(fontSize: 12),
      filled: true,
      fillColor: context.theme.colorScheme.onPrimary,
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
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
