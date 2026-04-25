import 'package:albedo_app/controller/support_controller.dart';
import 'package:albedo_app/model/session_model.dart';
import 'package:albedo_app/widgets/header_with_search.dart';
import 'package:albedo_app/widgets/widgets.dart';
import 'package:albedo_app/widgets/custom_appbar.dart';
import 'package:albedo_app/widgets/custom_card.dart';
import 'package:albedo_app/widgets/drawer_menu.dart';
import 'package:albedo_app/widgets/responsive.dart';
import 'package:flutter/material.dart';
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
            _tabs(context),
            const SizedBox(height: 10),
            Expanded(child: _list(context)),
          ],
        ),
      ),
    );
  }

  // 🔍 Custom Search Bar

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
      int crossAxisCount = 1;

      if (c.isLoading.value) {
        return const Center(child: CircularProgressIndicator());
      }
      if (data.isEmpty) {
        return const Center(child: Text("No tickets found"));
      }
      return ListView.builder(
        padding: const EdgeInsets.symmetric(horizontal: 12),
        itemCount: data.length,
        itemBuilder: (_, i) {
          final s = data[i];
          final isOpen = s.status == "open";
          return Padding(
            padding: const EdgeInsets.all(8.0),
            child: InfoCard(
              id: s.id,
              status: isOpen ? "Open" : "Closed",
              statusColor: isOpen
                  ? Theme.of(context).colorScheme.primary
                  : Theme.of(context).colorScheme.error,

              /// ✅ Use infoColumns for structured data
              infoColumns: [
                {"label": "Title", "value": s.title},
              ],

              /// ✅ Use infoRows for full-width content (description)
              infoRows: [
                Text(
                  s.description,
                  style: TextStyle(
                    fontSize: 12,
                    color: Theme.of(context)
                        .colorScheme
                        .onSurface
                        .withOpacity(0.7),
                  ),
                ),
              ],

              /// ✅ Actions
              actions: [
                CustomWidgets().iconBtn(
                  icon: Icons.edit,
                  onTap: () {
                    if (s != null) {
                      c.loadTicket(s);
                      editTicket(context);
                    }
                  },
                  color: Theme.of(context).colorScheme.primary,
                ),
                CustomWidgets().iconBtn(
                  icon: Icons.delete,
                  onTap: () => CustomWidgets().showDeleteDialog(
                    text:
                        'Are you sure you want to delete this ticket permanently?',
                    context: context,
                    onConfirm: () => c.delete(c.filteredTickets[i].id),
                  ),
                  color: Theme.of(context).colorScheme.error,
                ),
              ],
            ),
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

  FloatingActionButton addTicket(BuildContext context) {
    return FloatingActionButton(
      onPressed: () => CustomWidgets().showCustomDialog(
        context: context,
        title: Text('Add New Ticket'),
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
                    CustomWidgets()
                        .labelWithAsterisk('Category', required: true),
                    const SizedBox(height: 10),
                    CustomWidgets().dropdownStyledTextField(
                        context: context,
                        hint: '',
                        controller: c.categoryController),
                    const SizedBox(height: 10),
                    CustomWidgets()
                        .labelWithAsterisk('Priority', required: true),
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
                              onChanged: (value) =>
                                  c.selectedType.value = value!,
                            ),
                          ),
                          Expanded(
                            child: RadioListTile(
                              title: Text('Teacher'),
                              value: "teacher",
                              groupValue: c.selectedType.value,
                              onChanged: (value) =>
                                  c.selectedType.value = value!,
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
                    const SizedBox(height: 20),
                  ],
                ),
              ))
        ],
        onSubmit: () {},
      ),
      mini: true,
      backgroundColor: context.theme.colorScheme.primary,
      child: Icon(
        Icons.add,
        color: context.theme.colorScheme.onPrimary,
      ),
    );
  }
}
