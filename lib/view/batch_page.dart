import 'package:albedo_app/controller/auth_controller.dart';
import 'package:albedo_app/controller/batch_controller.dart';
import 'package:albedo_app/controller/permissions_controller.dart';
import 'package:albedo_app/model/session_model.dart';
import 'package:albedo_app/widgets/custom_appbar.dart';
import 'package:albedo_app/widgets/custom_card.dart';
import 'package:albedo_app/widgets/custom_tab.dart';
import 'package:albedo_app/widgets/drawer_menu.dart';
import 'package:albedo_app/widgets/header_with_search.dart';
import 'package:albedo_app/widgets/responsive.dart';
import 'package:albedo_app/widgets/session_widgets.dart';
import 'package:albedo_app/widgets/widgets.dart';
import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:get/get.dart';

class BatchesPage extends StatelessWidget {
  final BatchController c = Get.put(BatchController());

  @override
  Widget build(BuildContext context) {
    final isDesktop = Responsive.isDesktop(context);
    final auth = Get.find<AuthController>();
    final role = auth.activeUser?.role;

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
    ].contains(role);

    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.surface,
      appBar: Responsive.isMobile(context) ? const CustomAppBar() : null,
      drawer: isDesktop ? null : const DrawerMenu(),
      floatingActionButton: addBatch(context),
      body: Row(
        children: [
          if (isDesktop) DrawerMenu(),
          Expanded(
            child: Column(
              children: [
                /// 🔍 Search + Sort
                HeaderWithSearch(
                  title: "Batches",
                  hint: "Search batches...",
                  isSearching: c.isSearching,
                  searchQuery: c.searchQuery,
                  onSearchChanged: () => c.applyFilters(),
                  onSortTap: () => CustomWidgets().showSortSheet<SortType>(
                    title: "Sort Batches",
                    options: [
                      SortOption(
                        label: "Newest",
                        value: SortType.newest,
                        icon: Icons.schedule,
                      ),
                      SortOption(
                        label: "Oldest",
                        value: SortType.oldest,
                        icon: Icons.history,
                      ),
                      SortOption(
                        label: "Name A-Z",
                        value: SortType.name,
                        icon: Icons.sort_by_alpha,
                      ),
                    ],
                    selectedValue: c.sortType.value,
                    onSelected: (val) {
                      c.sortType.value = val;
                      c.applyFilters();
                    },
                  ),
                ),

                /// 🧭 Tabs
                Padding(
                  padding: const EdgeInsets.fromLTRB(16, 12, 16, 0),
                  child: Tabs(
                    selectedIndex: c.selectedTab,
                    labels: ['Active', 'Inactive'],
                    onTap: (p0) {
                      c.selectedTab.value = p0;
                      c.applyFilters();
                    },
                  ),
                ),

                const SizedBox(height: 10),

                /// 📋 List
                Expanded(
                  child: Obx(() {
                    if (c.isLoading.value) {
                      return const Center(child: CircularProgressIndicator());
                    }
                    if (c.filteredBatches.isEmpty) {
                      return const Center(child: Text("No batches found"));
                    }

                    return LayoutBuilder(builder: (context, constraints) {
                      int crossAxisCount = 1;

                      if (constraints.maxWidth > 1200) {
                        crossAxisCount = 3;
                      } else if (constraints.maxWidth > 700) {
                        crossAxisCount = 2;
                      }
                      return MasonryGridView.count(
                          crossAxisCount: crossAxisCount,
                          padding: const EdgeInsets.symmetric(vertical: 6),
                          itemCount: c.filteredBatches.length,
                          itemBuilder: (context, index) {
                            final batch = c.filteredBatches[index];

                            return Padding(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 12),
                              child: Align(
                                alignment: Alignment.center,
                                child: ConstrainedBox(
                                  constraints:
                                      const BoxConstraints(maxWidth: 700),
                                  child: PremiumInfoCard(
                                    id: batch.id ?? "",
                                    title: batch?.batchName ?? "",
                                    subtitle: batch?.batchID ?? "",
                                    status: batch?.status,
                                    statusColor: getStatusColor(batch?.status),
                                    extraInfo: "",
                                    footerText: "",
                                    onTap: (!isCustom ||
                                            PermissionService.can("view_batch"))
                                        ? () => openBatchProfile(
                                              context,
                                              batch,
                                            )
                                        : null,
                                    actions: [
                                      if ((!isCustom ||
                                          PermissionService.can("edit_batch")))
                                        InfoAction(
                                          icon: Icons.edit,
                                          color: Theme.of(context)
                                              .colorScheme
                                              .secondary,
                                          onTap: () {
                                            if (batch != null) {
                                              c.loadBatches(batch);
                                              editBatch(context);
                                            }
                                          },
                                        ),
                                      if ((!isCustom ||
                                          PermissionService.can(
                                              "delete_batch")))
                                        InfoAction(
                                            icon: Icons.delete,
                                            color: Theme.of(context)
                                                .colorScheme
                                                .error,
                                            onTap: () =>
                                                c.handleDelete(context, batch)),
                                    ],
                                  ),
                                ),
                              ),
                            );
                          });
                    });
                  }),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  void editBatch(BuildContext context) {
    CustomWidgets().showCustomDialog(
      context: context,
      title: Text('Edit Batch'),
      icon: Icons.edit,
      formKey: GlobalKey<FormState>(),
      sections: [
        SizedBox(
            height: MediaQuery.of(context).size.height * 0.5,
            child: SingleChildScrollView(
              child: Column(
                children: [
                  Text('Profile Photo (Max: 50 MB)'),
                  const SizedBox(height: 10),
                  InkWell(
                    onTap: () {},
                    child: CircleAvatar(
                      radius: 35,
                      child: ClipOval(
                        child: SizedBox(
                          width: 60,
                          height: 60,
                          child: Image.asset(
                            'assets/images/logo.png',
                            fit: BoxFit.contain,
                          ),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 10),
                  CustomWidgets()
                      .labelWithAsterisk('Batch Name', required: true),
                  const SizedBox(height: 10),
                  CustomWidgets().dropdownStyledTextField(
                      context: context,
                      hint: '',
                      controller: c.batchNameController),
                  const SizedBox(height: 10),
                  CustomWidgets()
                      .labelWithAsterisk('Batch Code', required: true),
                  const SizedBox(height: 10),
                  CustomWidgets().dropdownStyledTextField(
                      context: context,
                      hint: '',
                      controller: c.batchCodeController),
                  const SizedBox(height: 10),
                  CustomWidgets().labelWithAsterisk('Mode', required: true),
                  const SizedBox(height: 10),
                  CustomWidgets().dropdownStyledTextField(
                      context: context,
                      hint: 'Select modes',
                      controller: c.batchModeController),
                  const SizedBox(height: 10),
                  CustomWidgets().labelWithAsterisk('Course', required: true),
                  const SizedBox(height: 10),
                  CustomWidgets().dropdownStyledTextField(
                      context: context,
                      hint: 'Select Course',
                      controller: c.courseController),
                  const SizedBox(height: 10),
                  CustomWidgets().labelWithAsterisk('Mentor', required: true),
                  const SizedBox(height: 10),
                  CustomWidgets().dropdownStyledTextField(
                      context: context,
                      hint: 'Select Mentor',
                      controller: c.mentorController),
                  const SizedBox(height: 10),
                ],
              ),
            ))
      ],
      onSubmit: () {},
    );
  }

  Widget addBatch(BuildContext context) {
    return AppFAB(
      label: "Add Batch",
      icon: Icons.add_rounded,
      onPressed: () => CustomWidgets().showCustomDialog(
        context: context,
        title: const Text('Add New Batch'),
        formKey: GlobalKey<FormState>(),
        sections: [
          SizedBox(
            height: MediaQuery.of(context).size.height * 0.6,
            child: SingleChildScrollView(
              child: Column(
                children: [
                  CustomWidgets()
                      .labelWithAsterisk('Batch Name', required: true),
                  const SizedBox(height: 10),
                  CustomWidgets().dropdownStyledTextField(
                    context: context,
                    hint: 'Enter batch name',
                    controller: c.batchNameController,
                  ),
                  const SizedBox(height: 10),
                  CustomWidgets().labelWithAsterisk('Mode', required: true),
                  const SizedBox(height: 10),
                  CustomWidgets().dropdownStyledTextField(
                    context: context,
                    hint: 'Select mode',
                    controller: c.batchModeController,
                  ),
                  const SizedBox(height: 10),
                  CustomWidgets().labelWithAsterisk('Course', required: true),
                  const SizedBox(height: 10),
                  CustomWidgets().dropdownStyledTextField(
                    context: context,
                    hint: 'Select course',
                    controller: c.courseController,
                  ),
                  const SizedBox(height: 10),
                  CustomWidgets().labelWithAsterisk('Mentor', required: true),
                  const SizedBox(height: 10),
                  CustomWidgets().dropdownStyledTextField(
                    context: context,
                    hint: 'Select mentor',
                    controller: c.mentorController,
                  ),
                  const SizedBox(height: 20),
                ],
              ),
            ),
          ),
        ],
        onSubmit: () {
          // TODO: implement submit
        },
      ),
    );
  }
}
