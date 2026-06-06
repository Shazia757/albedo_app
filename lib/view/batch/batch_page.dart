import 'package:albedo_app/controller/auth_controller.dart';
import 'package:albedo_app/controller/batch_controller.dart';
import 'package:albedo_app/controller/permissions_controller.dart';
import 'package:albedo_app/model/session_model.dart';
import 'package:albedo_app/view/batch/batch_detailed_page.dart';
import 'package:albedo_app/widgets/custom_appbar.dart';
import 'package:albedo_app/widgets/custom_card.dart';
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

  BatchesPage({super.key});

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
      appBar: Responsive.isMobile(context) ? const CustomAppBar() : null,
      drawer: isDesktop ? null : const DrawerMenu(),
      floatingActionButton: addBatch(context),
      body: Row(
        children: [
          if (isDesktop) DrawerMenu(),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(16, 16, 16, 0),
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
                  Obx(
                    () => CustomWidgets().customTabs(
                      context,
                      tabs: c.tabs,
                      selectedIndex: c.selectedTab.value,
                      onTap: (index) async {
                        c.selectedTab.value = index;
                        c.currentPage.value = 0;

                        await c.fetchBatches();
                      },
                      getCount: (index) => c.tabData[index]['count'],
                    ),
                  ),

                  SizedBox(height: 10),

                  /// 📋 List
                  Expanded(
                    child: Obx(() {
                      if (c.isLoading.value) {
                        return Center(child: CircularProgressIndicator());
                      }
                      if (c.filteredBatches.isEmpty) {
                        return Center(child: Text("No batches found"));
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
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 4, vertical: 4),
                                child: Align(
                                  alignment: Alignment.center,
                                  child: ConstrainedBox(
                                    constraints:
                                        const BoxConstraints(maxWidth: 700),
                                    child: PremiumInfoCard(
                                      id: batch.id ?? "",
                                      title: batch.name ?? "",
                                      subtitle: batch.code ?? "",
                                      status:
                                          // (batch.isLive == true)
                                          //     ?  'Active' :
                                          "Inactive",
                                      statusColor: getStatusColor(
                                          // (batch.isLive == true)
                                          //     ? 'Active' :
                                          "Inactive"),
                                      footerText: "",
                                      onTap: (!isCustom ||
                                              PermissionService.can(
                                                  "view_batch"))
                                          ? () {
                                              // Get.to(
                                              //     () => BatchDetailedPage(
                                              //         batch: batch,
                                              //         initialIndex: index),
                                              //     binding: BindingsBuilder(() {
                                              //       Get.put(BatchController());
                                              //     }),
                                              //   );
                                            }
                                          : null,
                                      actions: [
                                        if ((!isCustom ||
                                            PermissionService.can(
                                                "edit_batch")))
                                          InfoAction(
                                            icon: Icons.edit,
                                            color: Theme.of(context)
                                                .colorScheme
                                                .secondary,
                                            onTap: () {
                                              c.loadBatches(batch);
                                              editBatch(context);
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
                                              onTap: () => c.handleDelete(
                                                  context, batch)),
                                      ],
                                    ),
                                  ),
                                ),
                              );
                            });
                      });
                    }),
                  ),
                  Obx(() {
                    if (c.totalPages <= 1) return const SizedBox();

                    return Padding(
                      padding: const EdgeInsets.only(bottom: 14, top: 6),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          IconButton(
                            onPressed: c.currentPage.value > 0
                                ? () async {
                                    c.currentPage.value--;
                                    await c.fetchBatches();
                                  }
                                : null,
                            icon: const Icon(Icons.chevron_left_rounded),
                          ),
                          Text(
                            "Page ${c.currentPage.value + 1} of ${c.totalPages}",
                            style: Theme.of(context).textTheme.bodyMedium,
                          ),
                          IconButton(
                            onPressed: c.currentPage.value < c.totalPages - 1
                                ? () async {
                                    c.currentPage.value++;
                                    await c.fetchBatches();
                                  }
                                : null,
                            icon: const Icon(Icons.chevron_right_rounded),
                          ),
                        ],
                      ),
                    );
                  }),
                ],
              ),
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
                  SizedBox(height: 10),
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
                  SizedBox(height: 10),
                  CustomWidgets()
                      .labelWithAsterisk('Batch Name', required: true),
                  SizedBox(height: 10),
                  CustomWidgets().dropdownStyledTextField(
                      context: context,
                      hint: '',
                      controller: c.batchNameController),
                  SizedBox(height: 10),
                  CustomWidgets()
                      .labelWithAsterisk('Batch Code', required: true),
                  SizedBox(height: 10),
                  CustomWidgets().dropdownStyledTextField(
                      context: context,
                      hint: '',
                      controller: c.batchCodeController),
                  SizedBox(height: 10),
                  CustomWidgets().labelWithAsterisk('Mode', required: true),
                  SizedBox(height: 10),
                  CustomWidgets().dropdownStyledTextField(
                      context: context,
                      hint: 'Select modes',
                      controller: c.batchModeController),
                  SizedBox(height: 10),
                  CustomWidgets().labelWithAsterisk('Course', required: true),
                  SizedBox(height: 10),
                  CustomWidgets().dropdownStyledTextField(
                      context: context,
                      hint: 'Select Course',
                      controller: c.courseController),
                  SizedBox(height: 10),
                  CustomWidgets().labelWithAsterisk('Mentor', required: true),
                  SizedBox(height: 10),
                  CustomWidgets().dropdownStyledTextField(
                      context: context,
                      hint: 'Select Mentor',
                      controller: c.mentorController),
                  SizedBox(height: 10),
                ],
              ),
            ))
      ],
      onSubmit: () {},
    );
  }

  FloatingActionButton addBatch(BuildContext context) {
    return FloatingActionButton(
      onPressed: () => CustomWidgets().showCustomDialog(
        context: context,
        title: Text('Add New Batch'),
        formKey: GlobalKey<FormState>(),
        sections: [
          SizedBox(
              height: MediaQuery.of(context).size.height * 0.5,
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    CustomWidgets()
                        .labelWithAsterisk('Batch Name', required: true),
                    SizedBox(height: 10),
                    CustomWidgets().dropdownStyledTextField(
                        context: context,
                        hint: 'Enter batch name',
                        controller: c.batchNameController),
                    SizedBox(height: 10),
                    CustomWidgets().labelWithAsterisk('Mode', required: true),
                    SizedBox(height: 10),
                    CustomWidgets().dropdownStyledTextField(
                        context: context,
                        hint: 'Select modes',
                        controller: c.batchModeController),
                    SizedBox(height: 10),
                    CustomWidgets().labelWithAsterisk('Course', required: true),
                    SizedBox(height: 10),
                    CustomWidgets().dropdownStyledTextField(
                        context: context,
                        hint: 'Select Course',
                        controller: c.courseController),
                    SizedBox(height: 10),
                    CustomWidgets().labelWithAsterisk('Mentor', required: true),
                    SizedBox(height: 10),
                    CustomWidgets().dropdownStyledTextField(
                        context: context,
                        hint: 'Select Mentor',
                        controller: c.mentorController),
                    SizedBox(height: 10),
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
