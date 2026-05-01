import 'package:albedo_app/controller/support_controller.dart';
import 'package:albedo_app/model/session_model.dart';
import 'package:albedo_app/model/support_model.dart';
import 'package:albedo_app/widgets/custom_tab.dart';
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

    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.surface,
      appBar: const CustomAppBar(),
      floatingActionButton: addTicket(context),
      drawer: isDesktop ? null : const DrawerMenu(),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            _topBar(context, c),
            const SizedBox(height: 10),
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 12, 16, 0),
              child: Tabs(
                selectedIndex: c.selectedTab,
                labels: ['Open', 'Closed'],
                onTap: (p0) {
                  c.selectedTab.value = p0;
                  c.applyFilters();
                },
              ),
            ),
            const SizedBox(height: 10),
            Expanded(child: _list(context)),
          ],
        ),
      ),
    );
  }

  // 📊 Tabs
  Widget _tabs(BuildContext context) {
    final cs = Theme.of(context).colorScheme;

    return Obx(() => Padding(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
          child: Row(
            children: List.generate(2, (index) {
              final isSelected = c.selectedTab.value == index;
              final title = index == 0 ? "Open" : "Closed";

              return Expanded(
                child: GestureDetector(
                  onTap: () {
                    c.selectedTab.value = index;
                    c.applyFilters();
                  },
                  child: Container(
                    margin: const EdgeInsets.only(right: 8),
                    padding: const EdgeInsets.symmetric(vertical: 10),
                    decoration: BoxDecoration(
                      color: isSelected
                          ? cs.primary
                          : cs.primaryContainer.withOpacity(0.4),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Center(
                      child: Text(
                        "$title (${c.getCount(index)})",
                        style: TextStyle(
                          color: isSelected
                              ? cs.onPrimary
                              : cs.onSurface.withOpacity(0.7),
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ),
                ),
              );
            }),
          ),
        ));
  }

  // 📋 List
  Widget _list(BuildContext context) {
    return Obx(() {
      final data = c.filteredTickets;

      if (c.isLoading.value) {
        return const Center(child: CircularProgressIndicator());
      }
      if (data.isEmpty) {
        return const Center(child: Text("No tickets found"));
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
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
            itemCount: data.length,
            itemBuilder: (_, i) {
              final s = data[i];
              final isOpen = s.status == "open";

              return PremiumInfoCard(
                id: s.id,

                /// 🔹 Main content
                title: s.title ?? "No Title",
                subtitle: s.description ?? "",

                /// 🔹 Status
                status: isOpen ? "Open" : "Closed",
                statusColor: isOpen
                    ? Theme.of(context).colorScheme.primary
                    : Theme.of(context).colorScheme.error,

                /// 🔹 Extra + Footer
                extraInfo: null, // you can move something here later if needed
                footerText: "", // or add created date like: "Created • ..."

                /// 🔹 Actions
                actions: [
                  InfoAction(
                    icon: Icons.edit,
                    color: Theme.of(context).colorScheme.primary,
                    onTap: () {
                      c.loadTicket(s);
                      editTicket(context);
                    },
                  ),
                  InfoAction(
                    icon: Icons.delete,
                    color: Theme.of(context).colorScheme.error,
                    onTap: () => CustomWidgets().showDeleteDialog(
                      text:
                          'Are you sure you want to delete this ticket permanently?',
                      context: context,
                      onConfirm: () => c.delete(s.id),
                    ),
                  ),
                ],

                /// 🔹 Tap
                onTap: () => _openTicketDialog(context, s),
              );
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
              hint: "Search tickets...",
              onChanged: (val) => c.searchQuery.value = val,
            )),
        const SizedBox(width: 12),
        _filterButton(context),
        const SizedBox(width: 8),
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
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: Theme.of(context).colorScheme.outline.withOpacity(0.5),
          ),
        ),
        child: const Row(
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
          children: const [
            Icon(Icons.filter_list, size: 18),
            SizedBox(width: 6),
            Text("Filter", style: TextStyle(fontSize: 13)),
          ],
        ),
      ),
    );
  }

  void editTicket(BuildContext context) {
    CustomWidgets().showCustomDialog(
      context: context,
      title: Text('Edit Ticket'),
      icon: Icons.edit,
      formKey: GlobalKey<FormState>(),
      sections: [
        SizedBox(
            height: MediaQuery.of(context).size.height * 0.5,
            child: SingleChildScrollView(
              child: Column(
                children: [
                  CustomWidgets().labelWithAsterisk('Title', required: true),
                  const SizedBox(height: 10),
                  CustomWidgets().dropdownStyledTextField(
                      context: context,
                      hint: '',
                      controller: c.titleController),
                  const SizedBox(height: 10),
                  CustomWidgets().labelWithAsterisk('Category', required: true),
                  const SizedBox(height: 10),
                  CustomWidgets().dropdownStyledTextField(
                      context: context,
                      hint: '',
                      controller: c.categoryController),
                  const SizedBox(height: 10),
                  CustomWidgets().labelWithAsterisk('Priority', required: true),
                  const SizedBox(height: 10),
                  CustomWidgets().dropdownStyledTextField(
                      context: context,
                      hint: '',
                      controller: c.priorityController),
                  const SizedBox(height: 10),
                  CustomWidgets().labelWithAsterisk('User', required: true),
                  const SizedBox(height: 10),
                  Obx(
                    () => Row(
                      children: [
                        Expanded(
                          child: RadioListTile(
                            dense: true,
                            title: Text('Student'),
                            value: "student",
                            groupValue: c.selectedType.value,
                            onChanged: (value) => c.selectedType.value = value!,
                          ),
                        ),
                        Expanded(
                          child: RadioListTile(
                            title: Text('Teacher'),
                            value: "teacher",
                            groupValue: c.selectedType.value,
                            onChanged: (value) => c.selectedType.value = value!,
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 10),
                  Obx(() {
                    if (c.selectedType.value == 'student') {
                      return CustomWidgets().dropdownStyledTextField(
                          context: context, hint: 'Select Student');
                    }
                    if (c.selectedType.value == 'teacher') {
                      return CustomWidgets().dropdownStyledTextField(
                          context: context, hint: 'Select Teacher');
                    }
                    return const SizedBox();
                  }),
                  const SizedBox(height: 10),
                  CustomWidgets()
                      .labelWithAsterisk('Description', required: true),
                  const SizedBox(height: 10),
                  CustomWidgets().dropdownStyledTextField(
                    context: context,
                    hint: '',
                    controller: c.descriptionController,
                    isMultiline: true,
                  ),
                ],
              ),
            ))
      ],
      onSubmit: () {},
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
            style: const TextStyle(
              fontWeight: FontWeight.w600,
              fontSize: 13,
            ),
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
            style: const TextStyle(
              fontWeight: FontWeight.w600,
              fontSize: 13,
            ),
          ),
          children: [
            Text(
              s.description ?? "-",
              style: TextStyle(
                fontSize: 13,
                color: Theme.of(context).colorScheme.onSurface.withOpacity(0.7),
              ),
            ),
          ],
        ),

        /// 📎 ATTACHMENT
        if (s.attachmentUrl != null)
          _sectionCard(
            context,
            title: Text(
              "Attachment",
              style: const TextStyle(
                fontWeight: FontWeight.w600,
                fontSize: 13,
              ),
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
            style: const TextStyle(
              fontWeight: FontWeight.w600,
              fontSize: 13,
            ),
          ),
          children: s.replies.isEmpty
              ? [const Text("No replies yet")]
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

            const SizedBox(height: 8),

            CustomWidgets()
                .labelWithAsterisk('Quick Response Templates (Optional)'),

            /// ⚡ Quick Templates
            Obx(() => DropdownButtonFormField<String>(
                  value: selectedTemplate.value.isEmpty
                      ? null
                      : selectedTemplate.value,
                  hint: const Text("Quick response"),
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

            const SizedBox(height: 10),

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
            const SizedBox(height: 8),

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

                    const SizedBox(width: 12),

                    /// 🔹 TEXT
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            "Upload File",
                            style: Theme.of(context).textTheme.titleSmall,
                          ),
                          const SizedBox(height: 2),
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

      submitText: "Post Reply",
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
            style: const TextStyle(
              fontWeight: FontWeight.w600,
              fontSize: 13,
            ),
            child: title,
          ),

          const SizedBox(height: 8),

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
          const SizedBox(height: 2),
          Text(
            r.createdAt.toString(),
            style: const TextStyle(fontSize: 10),
          ),
        ],
      ),
    );
  }

  Widget addTicket(BuildContext context) {
    return AppFAB(
      label: "Add Ticket",
      icon: Icons.add_rounded,
      onPressed: () => CustomWidgets().showCustomDialog(
        context: context,
        title: const Text('Add New Ticket'),
        formKey: GlobalKey<FormState>(),
        sections: [
          SizedBox(
            height: MediaQuery.of(context).size.height * 0.7,
            child: SingleChildScrollView(
              child: Column(
                children: [
                  CustomWidgets().labelWithAsterisk('Title', required: true),
                  const SizedBox(height: 10),
                  CustomWidgets().dropdownStyledTextField(
                    context: context,
                    hint: 'Ticket Title',
                    controller: c.titleController,
                  ),
                  const SizedBox(height: 10),
                  CustomWidgets().labelWithAsterisk('Category', required: true),
                  const SizedBox(height: 10),
                  CustomWidgets().customDropdownField(
                    context: context,
                    hint: 'Select Category',
                    items: c.categoryList,
                    onChanged: (p0) {},
                  ),
                  const SizedBox(height: 10),
                  CustomWidgets().labelWithAsterisk('Priority', required: true),
                  const SizedBox(height: 10),
                  CustomWidgets().customDropdownField(
                    context: context,
                    hint: 'Select Priority',
                    items: const ['High', 'Medium', 'Low'],
                    onChanged: (p0) {},
                  ),
                  const SizedBox(height: 10),
                  CustomWidgets().labelWithAsterisk('User', required: true),
                  const SizedBox(height: 10),
                  Obx(
                    () => Row(
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
                    ),
                  ),
                  const SizedBox(height: 10),
                  Obx(() {
                    if (c.selectedType.value == 'student') {
                      return CustomWidgets().dropdownStyledTextField(
                        context: context,
                        hint: 'Select Student',
                      );
                    }
                    if (c.selectedType.value == 'teacher') {
                      return CustomWidgets().dropdownStyledTextField(
                        context: context,
                        hint: 'Select Teacher',
                      );
                    }
                    return const SizedBox();
                  }),
                  const SizedBox(height: 10),
                  CustomWidgets()
                      .labelWithAsterisk('Description', required: true),
                  const SizedBox(height: 10),
                  CustomWidgets().dropdownStyledTextField(
                    context: context,
                    hint: '',
                    controller: c.descriptionController,
                    isMultiline: true,
                  ),
                  const SizedBox(height: 20),
                ],
              ),
            ),
          ),
        ],
        onSubmit: () {
          // TODO: submit ticket
        },
      ),
    );
  }
}
