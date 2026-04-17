import 'package:albedo_app/controller/batch_controller.dart';
import 'package:albedo_app/model/batch_model.dart';
import 'package:albedo_app/model/session_model.dart';
import 'package:albedo_app/widgets/custom_appbar.dart';
import 'package:albedo_app/widgets/drawer_menu.dart';
import 'package:albedo_app/widgets/responsive.dart';
import 'package:albedo_app/widgets/widgets.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class BatchesPage extends StatelessWidget {
  final BatchController c = Get.put(BatchController());

  @override
  Widget build(BuildContext context) {
    final isDesktop = Responsive.isDesktop(context);

    return Scaffold(
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
                Padding(
                  padding: const EdgeInsets.all(12),
                  child: Row(
                    children: [
                      Expanded(
                          child: CustomWidgets().premiumSearch(context,
                              hint: "Search batches...", onChanged: (value) {
                        c.searchQuery.value = value;
                        c.applyFilters();
                      })),

                      const SizedBox(width: 10),

                      /// Sort
                      InkWell(
                        borderRadius: BorderRadius.circular(8),
                        onTap: () => CustomWidgets().showSortSheet<SortType>(
                          title: "Sort Batches",
                          options: [
                            SortOption(
                                label: "Newest",
                                value: SortType.newest,
                                icon: Icons.schedule),
                            SortOption(
                                label: "Oldest",
                                value: SortType.oldest,
                                icon: Icons.history),
                            SortOption(
                                label: "Name A-Z",
                                value: SortType.name,
                                icon: Icons.sort_by_alpha),
                          ],
                          selectedValue: c.sortType.value,
                          onSelected: (val) {
                            c.sortType.value = val;
                            c.applyFilters();
                          },
                        ),
                        child: const Padding(
                          padding: EdgeInsets.all(8),
                          child: Icon(Icons.sort, size: 20),
                        ),
                      )
                    ],
                  ),
                ),

                /// 🧭 Tabs
                Obx(
                  () => CustomWidgets().customTabs(
                    context,
                    tabs: c.tabs,
                    selectedIndex: c.selectedTab.value,
                    onTap: (index) {
                      c.selectedTab.value = index;
                      c.applyFilters();
                    },
                    getCount: (index) {
                      switch (index) {
                        case 0:
                          return c.activeCount;
                        case 2:
                          return c.inactiveCount;
                        default:
                          return 0;
                      }
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

                    return ListView.builder(
                        padding: const EdgeInsets.symmetric(vertical: 6),
                        itemCount: c.filteredBatches.length,
                        itemBuilder: (context, index) {
                          final batch = c.filteredBatches[index];

                          return Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 12),
                            child: Align(
                              alignment: Alignment.center,
                              child: ConstrainedBox(
                                constraints:
                                    const BoxConstraints(maxWidth: 700),
                                child: _card(context, batch),
                              ),
                            ),
                          );
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

  Widget _card(BuildContext context, Batch? b) {
    final cs = Theme.of(context).colorScheme;

    final isActive = b?.status == "Active";

    final statusColor = isActive ? cs.primary : cs.error;
    final data = c.filteredBatches;

    return Container(
      margin: const EdgeInsets.symmetric(vertical: 6),
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16),
        color: cs.surface,
        boxShadow: [
          BoxShadow(
            color: cs.shadow.withOpacity(0.08),
            blurRadius: 12,
            offset: const Offset(0, 6),
          ),
        ],
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          /// 🔥 Left Accent Bar
          Container(
            width: 4,
            height: 70,
            decoration: BoxDecoration(
              color: statusColor,
              borderRadius: BorderRadius.circular(10),
            ),
          ),

          const SizedBox(width: 10),

          /// Content
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                /// Top Row
                Row(
                  children: [
                    Text(
                      b?.batchID ?? 'NULL',
                      style: TextStyle(
                        fontSize: 11,
                        fontWeight: FontWeight.w600,
                        color: cs.onSurface.withOpacity(0.6),
                      ),
                    ),
                    const Spacer(),

                    /// Status Badge
                    Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 10, vertical: 4),
                      decoration: BoxDecoration(
                        color: statusColor.withOpacity(0.12),
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Text(
                        b?.status ?? 'NULL',
                        style: TextStyle(
                          color: statusColor,
                          fontSize: 11,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: 6),

                /// Name
                Text(
                  b?.batchName ?? 'NULL',
                  style: TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.w600,
                    color: cs.onSurface,
                  ),
                ),

                const SizedBox(height: 10),

                /// 🔘 Actions
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    if (b?.status != 'Inactive')
                      CustomWidgets().iconBtn(
                        icon: Icons.edit,
                        color: cs.secondary,
                        onTap: () {
                          if (b != null) {
                            c.loadBatches(b);
                            editBatch(context);
                          }
                        },
                      ),
                    const SizedBox(width: 8),
                    CustomWidgets().iconBtn(
                      icon: Icons.delete,
                      color: cs.error,
                      onTap: () => CustomWidgets().showDeleteDialog(
                        text:
                            'Are you sure you want to delete this batch permanently?',
                        context: context,
                        onConfirm: () => c.delete(b!.batchID!),
                      ),
                    ),
                  ],
                )
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
                    const SizedBox(height: 10),
                    CustomWidgets().dropdownStyledTextField(
                        context: context,
                        hint: 'Enter batch name',
                        controller: c.batchNameController),
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
