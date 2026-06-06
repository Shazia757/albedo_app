import 'package:albedo_app/controller/auth_controller.dart';
import 'package:albedo_app/controller/permissions_controller.dart';
import 'package:albedo_app/controller/support_controller.dart';
import 'package:albedo_app/model/session_model.dart';
import 'package:albedo_app/model/settings/syllabus_model.dart';
import 'package:albedo_app/model/support_model.dart';
import 'package:albedo_app/model/users/student_model.dart';
import 'package:albedo_app/model/users/teacher_model.dart';
import 'package:albedo_app/widgets/header_with_search.dart';
import 'package:albedo_app/widgets/session_widgets.dart';
import 'package:albedo_app/widgets/widgets.dart';
import 'package:albedo_app/widgets/custom_appbar.dart';
import 'package:albedo_app/widgets/custom_card.dart';
import 'package:albedo_app/widgets/drawer_menu.dart';
import 'package:albedo_app/widgets/responsive.dart';
import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:get/get.dart';

class SupportsPage extends StatelessWidget {
  SupportsPage({super.key});

  final c = Get.put(SupportController());

  @override
  Widget build(BuildContext context) {
    final isDesktop = Responsive.isDesktop(context);
    final auth = Get.find<AuthController>();
    final role = auth.activeUser?.role;
    final normalizedRole = role?.trim().toLowerCase();

    final isCustom = ![
      "admin",
      "mentor",
      "advisor",
      "teacher",
      "student",
      "coordinator",
      "finance",
      "sales",
      "hr"
    ].contains(normalizedRole);

    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.surface,
      appBar: const CustomAppBar(),
      floatingActionButton: (!isCustom || PermissionService.can("add_tickets"))
          ? FloatingActionButton(
              onPressed: () => editTicket(context),
              mini: true,
              backgroundColor: context.theme.colorScheme.primary,
              child: Icon(
                Icons.add,
                color: context.theme.colorScheme.onPrimary,
              ),
            )
          : null,
      drawer: isDesktop ? null : const DrawerMenu(),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            _topBar(context, c),
            SizedBox(height: 10),
            Obx(
              () => CustomWidgets().customTabs(
                context,
                tabs: c.tabs,
                selectedIndex: c.selectedTab.value,
                onTap: (index) {
                  c.selectedTab.value = index;
                  c.applyFilters();
                },
                getCount: c.getCount,
              ),
            ),
            SizedBox(height: 10),
            Expanded(child: _list(context)),
          ],
        ),
      ),
    );
  }

  // 📋 List
  Widget _list(BuildContext context) {
    return Obx(() {
      final data = c.filteredTickets;

      if (c.isLoading.value) {
        return Center(child: CircularProgressIndicator());
      }
      if (data.isEmpty) {
        return Center(child: Text("No tickets found"));
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
            crossAxisCount: crossAxisCount,
            mainAxisSpacing: 12,
            crossAxisSpacing: 12,
            padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 4),
            itemCount: data.length,
            itemBuilder: (_, i) {
              final s = data[i];
              final isOpen = s.status == "OPEN";
              final auth = Get.find<AuthController>();
              final role = auth.activeUser?.role;
              final normalizedRole = role?.trim().toLowerCase();

              final isCustom = ![
                "admin",
                "mentor",
                "advisor",
                "teacher",
                "student",
                "coordinator",
                "finance",
                "sales",
                "hr"
              ].contains(normalizedRole);

              return PremiumInfoCard(
                  id: s.ticketId,

                  /// 🔹 Main content
                  title: s.title ?? "No Title",
                  subtitle: s.category ?? "",

                  /// 🔹 Status
                  status: isOpen ? "Open" : "Closed",
                  statusColor: isOpen
                      ? Theme.of(context).colorScheme.primary
                      : Theme.of(context).colorScheme.error,

                  /// 🔹 Extra + Footer

                  footerText:
                      'By: ${s.student?.name ?? s.teacher?.name ?? "-"}',

                  /// 🔹 Actions
                  actions: [
                    if ((!isCustom || PermissionService.can("edit_tickets")))
                      InfoAction(
                        icon: Icons.edit,
                        label: "Edit",
                        color: Theme.of(context).colorScheme.primary,
                        onTap: () {
                          editTicket(context, ticket: s);
                        },
                      ),
                    if ((!isCustom || PermissionService.can("delete_tickets")))
                      InfoAction(
                        icon: Icons.delete,
                        label: 'Delete',
                        color: Theme.of(context).colorScheme.error,
                        onTap: () => CustomWidgets().showDeleteDialog(
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
                              'Are you sure you want to delete this ticket permanently?',
                          context: context,
                          onConfirm: () => c.deleteTicket(s.id),
                        ),
                      ),
                  ],

                  /// 🔹 Tap
                  onTap: (!isCustom || PermissionService.can("view_tickets"))
                      ? () => _openTicketDialog(context, s)
                      : null);
            },
          );
        },
      );
    });
  }

  Widget _topBar(BuildContext context, SupportController c) {
    final isMobile = Responsive.isMobile(context);

    if (isMobile) {
      return Column(
        children: [
          HeaderWithSearch(
            title: 'Supports',
            hint: 'Search tickets...',
            isSearching: c.isSearching,
            searchQuery: c.searchQuery,
            onSearchChanged: () {},
          ),
          Row(
            children: [
              Expanded(child: _filterButton(context)),
              SizedBox(width: 10),
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
              hint: "Search tickets...",
              onChanged: (val) => c.searchQuery.value = val,
            )),
        SizedBox(width: 12),
        _filterButton(context),
        SizedBox(width: 8),
        _sortButton(context, c),
      ],
    );
  }

  Widget _sortButton(BuildContext context, SupportController c) {
    return GestureDetector(
      onTap: () => CustomWidgets().showSortSheet(
          title: "Sort Tickets",
          options: [
            SortOption(
                label: "Newest", value: SortType.newest, icon: Icons.schedule),
            SortOption(
                label: "Oldest", value: SortType.oldest, icon: Icons.history),
            SortOption(
                label: "Name A-Z",
                value: SortType.name,
                icon: Icons.sort_by_alpha),
          ],
          selectedValue: c.sortType.value,
          onSelected: (val) {
            c.sortType.value = val;
            c.applyFilters();
          }),
      child: Container(
        height: 44,
        padding: const EdgeInsets.symmetric(horizontal: 12),
        decoration: BoxDecoration(
          color: Theme.of(context).colorScheme.onPrimary,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: Theme.of(context).colorScheme.outline.withOpacity(0.5),
          ),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(Icons.sort, size: 18),
            SizedBox(width: 6),
            Text("Sort"),
          ],
        ),
      ),
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
          color: Theme.of(context).colorScheme.outline.withOpacity(0.5),
        ),
      ),
      child: InkWell(
        onTap: () => CustomWidgets().showFilterSheet<PriorityFilter>(
          title: "Filter by Priority",
          options: c.priorityOptions,
          selectedValue: c.selectedPriority.value,
          onSelected: (val) {
            c.selectedPriority.value = val;
            c.applyFilters();
          },
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(Icons.filter_list, size: 18),
            SizedBox(width: 6),
            Text("Filter", style: Theme.of(context).textTheme.bodySmall),
          ],
        ),
      ),
    );
  }

  void editTicket(BuildContext context, {Ticket? ticket}) {
    final isEdit = ticket != null;
    if (isEdit) {
      c.titleController.text = ticket.title ?? '';
      c.categoryController.text = ticket.category ?? '';
      c.priorityController.text = ticket.priority ?? '';
      c.descriptionController.text = ticket.description ?? '';

      c.selectedType.value = ticket.userType ?? 'student';

      // optional selected user preload
      // c.selectedStudentController.text = ticket.studentName ?? '';
      // c.selectedTeacherController.text = ticket.teacherName ?? '';
    } else {
      c.titleController.clear();
      c.categoryController.clear();
      c.priorityController.clear();
      c.descriptionController.clear();

      c.selectedType.value = 'student';

      // optional clear
      // c.selectedStudentController.clear();
      // c.selectedTeacherController.clear();
    }

    CustomWidgets().showCustomDialog(
      context: context,
      title: Text(ticket != null ? 'Edit Ticket' : 'Add Ticket'),
      icon: ticket != null ? Icons.edit : Icons.add,
      formKey: GlobalKey<FormState>(),
      submitWidget: Obx(
        () => SizedBox(
          width: 80,
          child: Center(
            child: c.isLoading.value
                ? const SizedBox(
                    width: 18,
                    height: 18,
                    child: CircularProgressIndicator(
                      strokeWidth: 2,
                      color: Colors.white,
                    ),
                  )
                : Text(
                    isEdit ? "Update" : "Add",
                    style: TextStyle(color: Colors.white),
                  ),
          ),
        ),
      ),
      sections: [
        SizedBox(
          height: MediaQuery.of(context).size.height * 0.5,
          child: SingleChildScrollView(
            child: Column(
              children: [
                CustomWidgets().labelWithAsterisk(
                  'Title',
                  required: true,
                ),
                SizedBox(height: 10),
                CustomWidgets().dropdownStyledTextField(
                  context: context,
                  hint: 'Title',
                  controller: c.titleController,
                ),
                SizedBox(height: 10),
                CustomWidgets().labelWithAsterisk(
                  'Category',
                  required: true,
                ),
                SizedBox(height: 10),
                CustomWidgets().customDropdownField<Syllabus>(
                    context: context,
                    hint: 'Select Category',
                    items: c.categories,
                    itemLabel: (item) => item.name ?? '',
                    onChanged: (p0) {},
                    initialValue: c.selectedCategory.value),
                SizedBox(height: 10),
                CustomWidgets().labelWithAsterisk(
                  'Priority',
                  required: true,
                ),
                SizedBox(height: 10),
                CustomWidgets().customDropdownField<String>(
                    context: context,
                    hint: 'Select Priority',
                    items: ['High', 'Medium', 'Low'],
                    itemLabel: (item) => item ?? '',
                    onChanged: (p0) {},
                    initialValue: c.selectedPriorityList.value),
                SizedBox(height: 10),
                CustomWidgets().labelWithAsterisk(
                  'User',
                  required: true,
                ),
                SizedBox(height: 10),
                Obx(
                  () => Row(
                    children: [
                      Expanded(
                        child: RadioListTile(
                          dense: true,
                          title: Text('Student'),
                          value: "student",
                          groupValue: c.selectedType.value,
                          onChanged: (value) {
                            c.selectedType.value = value!;
                          },
                        ),
                      ),
                      Expanded(
                        child: RadioListTile(
                          dense: true,
                          title: Text('Teacher'),
                          value: "teacher",
                          groupValue: c.selectedType.value,
                          onChanged: (value) {
                            c.selectedType.value = value!;
                          },
                        ),
                      ),
                    ],
                  ),
                ),
                SizedBox(height: 10),
                Obx(() {
                  if (c.selectedType.value == 'student') {
                    return CustomWidgets().customDropdownField<Student>(
                        context: context,
                        hint: 'Select Student',
                        items: c.students,
                        itemLabel: (item) =>
                            "${item.name} (${item.studentId})" ?? '',
                        onChanged: (p0) {},
                        initialValue: c.selectedStudent.value);
                  }

                  if (c.selectedType.value == 'teacher') {
                    return CustomWidgets().customDropdownField<Teacher>(
                        context: context,
                        hint: 'Select Teacher',
                        items: c.teachers,
                        itemLabel: (item) =>
                            "${item.name} (${item.teacherId})" ?? '',
                        onChanged: (p0) {},
                        initialValue: c.selectedTeacher.value);
                  }

                  return SizedBox();
                }),
                SizedBox(height: 10),
                CustomWidgets().labelWithAsterisk(
                  'Description',
                  required: true,
                ),
                SizedBox(height: 10),
                CustomWidgets().dropdownStyledTextField(
                  context: context,
                  hint: '',
                  controller: c.descriptionController,
                  isMultiline: true,
                ),
              ],
            ),
          ),
        )
      ],
      onSubmit: () {
        if (ticket != null) {
          c.updateTicket(id: ticket.id, ticket: ticket.title);
        } else {
          c.addTicket(ticket?.title ?? '');
        }
      },
    );
  }

  void _openTicketDialog(BuildContext context, Ticket s) {
    final formKey = GlobalKey<FormState>();
    final messageController = TextEditingController();

    final RxString selectedTemplate = "".obs;
    final RxBool canSubmit = false.obs;

    messageController.addListener(() {
      canSubmit.value = messageController.text.trim().isNotEmpty;
    });

    CustomWidgets().showCustomDialog(
      context: context,
      icon: Icons.confirmation_number,
      title: Text("Ticket #${s.id}"),
      formKey: formKey,

      /// 🔹 SECTIONS
      sections: [
        /// 📌 BASIC INFO
        _sectionCard(
          context,
          title: Text(
            "Ticket Info",
            style: Theme.of(context).textTheme.titleSmall,
          ),
          children: [
            infoRow(label: "Status", value: s.status),
            infoRow(label: "Date", value: s.createdAt.toString()),
          ],
        ),

        /// 📝 DESCRIPTION
        _sectionCard(
          context,
          title: Text(
            'Description',
            style: Theme.of(context).textTheme.titleSmall,
          ),
          children: [
            Text(
              s.description ?? "-",
              style: Theme.of(context).textTheme.bodySmall!.copyWith(
                  color:
                      Theme.of(context).colorScheme.onSurface.withOpacity(0.7)),
            ),
          ],
        ),

        /// 📎 ATTACHMENT
        if (s.attachmentUrl != null)
          _sectionCard(
            context,
            title: Text(
              "Attachment",
              style: Theme.of(context).textTheme.titleSmall,
            ),
            children: [
              InkWell(
                onTap: () {
                  // open file
                },
                child: Row(
                  children: const [
                    Icon(Icons.attach_file, size: 18),
                    SizedBox(width: 6),
                    Text("View Attachment"),
                  ],
                ),
              ),
            ],
          ),

        /// 💬 REPLIES
        _sectionCard(
          context,
          title: Text(
            "Replies (${s.replies.length})",
            style: Theme.of(context).textTheme.titleSmall,
          ),
          children: s.replies.isEmpty
              ? [Text("No replies yet")]
              : s.replies.map<Widget>((r) => _replyItem(r)).toList(),
        ),

        /// ✍️ REPLY FORM
        _sectionCard(
          context,
          title:
              CustomWidgets().labelWithAsterisk('Your Message', required: true),
          children: [
            /// ✍️ Message
            TextFormField(
              controller: messageController,
              maxLength: 1000,
              maxLines: 4,
              decoration: const InputDecoration(
                hintText: "Your message...",
                border: OutlineInputBorder(),
              ),
              validator: (val) =>
                  val == null || val.trim().isEmpty ? "Required" : null,
            ),

            SizedBox(height: 8),

            CustomWidgets()
                .labelWithAsterisk('Quick Response Templates (Optional)'),

            /// ⚡ Quick Templates
            Obx(() => DropdownButtonFormField<String>(
                  value: selectedTemplate.value.isEmpty
                      ? null
                      : selectedTemplate.value,
                  hint: Text("Quick response"),
                  items: [
                    "We are checking this",
                    "Resolved. Please confirm",
                    "Need more details"
                  ]
                      .map((e) => DropdownMenuItem(value: e, child: Text(e)))
                      .toList(),
                  onChanged: (val) {
                    if (val != null) {
                      selectedTemplate.value = val;
                      messageController.text = val;
                    }
                  },
                )),

            SizedBox(height: 10),

            /// 📎 Attach
            Row(
              children: [
                IconButton(
                  icon: const Icon(Icons.attach_file),
                  onPressed: () {
                    // pick file
                  },
                ),
                CustomWidgets().labelWithAsterisk('Attach File (optional)')
              ],
            ),
            SizedBox(height: 8),

            InkWell(
              borderRadius: BorderRadius.circular(12),
              onTap: () async {
                // TODO: open file picker
                // final file = await pickFile();
                // if (file != null) { ... }
              },
              child: Container(
                width: double.infinity,
                padding: const EdgeInsets.all(14),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(
                    color:
                        Theme.of(context).colorScheme.outline.withOpacity(0.3),
                  ),
                  color: Theme.of(context).colorScheme.surface,
                ),
                child: Row(
                  children: [
                    /// 📎 ICON
                    Container(
                      padding: const EdgeInsets.all(10),
                      decoration: BoxDecoration(
                        color: Theme.of(context)
                            .colorScheme
                            .primary
                            .withOpacity(0.1),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Icon(
                        Icons.upload_file,
                        color: Theme.of(context).colorScheme.primary,
                        size: 20,
                      ),
                    ),

                    SizedBox(width: 12),

                    /// 🔹 TEXT
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            "Upload File",
                            style: Theme.of(context).textTheme.titleSmall,
                          ),
                          SizedBox(height: 2),
                          Text(
                            "PDF, DOC, Images (max 10MB)",
                            style:
                                Theme.of(context).textTheme.bodySmall?.copyWith(
                                      color: Theme.of(context)
                                          .colorScheme
                                          .onSurface
                                          .withOpacity(0.6),
                                    ),
                          ),
                        ],
                      ),
                    ),

                    /// ➡️ ICON
                    const Icon(Icons.arrow_forward_ios, size: 14),
                  ],
                ),
              ),
            ),
          ],
        ),
      ],

      /// 🔹 SUBMIT
      onSubmit: () {
        c.postReply(
          ticketId: s.id,
          message: messageController.text,
          template: selectedTemplate.value,
        );
      },

      submitWidget: Text(
        "Post Reply",
        style: Theme.of(context)
            .textTheme
            .bodyMedium!
            .copyWith(color: Colors.white),
      ),
    );
  }

  Widget _sectionCard(
    BuildContext context, {
    required Widget title,
    required List<Widget> children,
  }) {
    final cs = Theme.of(context).colorScheme;

    return Container(
      width: double.infinity,
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: cs.surface,
        borderRadius: BorderRadius.circular(14),
        boxShadow: [
          BoxShadow(
            color: cs.shadow.withOpacity(0.05),
            blurRadius: 8,
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          /// 🔹 TITLE
          DefaultTextStyle(
              style: Theme.of(context).textTheme.titleSmall!, child: title),

          SizedBox(height: 8),

          /// 🔹 CONTENT (force vertical)
          ...children.map(
            (child) => Padding(
              padding: const EdgeInsets.only(bottom: 6),
              child: child,
            ),
          ),
        ],
      ),
    );
  }

  Widget _replyItem(Reply r) {
    return Container(
      margin: const EdgeInsets.only(bottom: 6),
      padding: const EdgeInsets.all(8),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(8),
        color: Colors.grey.withOpacity(0.05),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(r.message),
          SizedBox(height: 2),
          Text(
            r.createdAt.toString(),
            style: Get.textTheme.labelSmall,
          ),
        ],
      ),
    );
  }
}
