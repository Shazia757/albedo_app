import 'package:albedo_app/controller/settings_controller.dart';
import 'package:albedo_app/view/settings/banner_ads_page.dart';

import 'package:albedo_app/widgets/responsive.dart';
import 'package:albedo_app/widgets/widgets.dart';
import 'package:albedo_app/widgets/custom_appbar.dart';
import 'package:albedo_app/widgets/drawer_menu.dart';
import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:get/get.dart';

class MaterialsPage extends StatelessWidget {
  final c = Get.put(SettingsController());

  MaterialsPage({super.key});

  @override
  Widget build(BuildContext context) {
    final isDesktop = Responsive.isDesktop(context);

    return Scaffold(
      appBar: const CustomAppBar(),
      backgroundColor: Theme.of(context).colorScheme.onPrimary,
      floatingActionButton: addMaterialBtn(context),
      body: Row(
        children: [
          if (isDesktop) const DrawerMenu(),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Obx(() {
                final data = c.materials;
                int crossAxisCount = 1;

                if (c.isLoading.value) {
                  return const Center(child: CircularProgressIndicator());
                }
                if (data.isEmpty) {
                  return const Center(child: Text("No materials found"));
                }

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
                      itemBuilder: (_, i) {
                        final item = data[i];

                        return CustomCard(
                          c: c,
                          content: Column(
                            children: [
                              Text(item.title ?? ''),
                            ],
                          ),
                          actions: [
                            CustomWidgets().iconBtn(
                              icon: Icons.edit,
                              color: Theme.of(context).colorScheme.primary,
                              onTap: () {
                                c.loadMaterials(item);
                                editMaterials(context);
                              },
                            ),
                            CustomWidgets().iconBtn(
                              icon: Icons.delete,
                              color: Theme.of(context).colorScheme.error,
                              onTap: () => CustomWidgets().showDeleteDialog(
                                context: context,
                                text:
                                    'Are you sure you want to delete this assessment?',
                                onConfirm: () => c.delete(item.id),
                              ),
                            ),
                          ],
                        );
                      },
                    );
                  },
                );
              }),
            ),
          ),
        ],
      ),
    );
  }

  void editMaterials(BuildContext context) {
    CustomWidgets().showCustomDialog(
      context: context,
      title: Text('Edit Material'),
      icon: Icons.edit,
      formKey: GlobalKey<FormState>(),
      sections: [
        SizedBox(
          height:
              MediaQuery.of(context).size.height * 0.7, // 🔥 full scroll area
          child: SingleChildScrollView(
            child: Column(
              children: [
                Obx(
                  () => Row(
                    children: [
                      Expanded(
                        child: RadioListTile(
                          dense: true,
                          title: Text('Batch'),
                          value: "batch",
                          groupValue: c.selectedUser.value,
                          onChanged: (value) => c.selectedUser.value = value!,
                        ),
                      ),
                      Expanded(
                        child: RadioListTile(
                          dense: true,
                          title: Text('Individual'),
                          value: "individual",
                          groupValue: c.selectedUser.value,
                          onChanged: (value) => c.selectedUser.value = value!,
                        ),
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 10),

                /// 🔥 Your dynamic section
                Obx(() {
                  if (c.selectedUser.value == 'batch') {
                    return Column(
                      children: [
                        CustomWidgets().labelWithAsterisk('Batches'),
                        const SizedBox(height: 10),
                        CustomWidgets().dropdownStyledTextField(
                          context: context,
                          hint: 'Select batches',
                          controller: c.batchController,
                        )
                      ],
                    );
                  }

                  if (c.selectedUser.value == 'individual') {
                    return Column(
                      children: [
                        CustomWidgets().labelWithAsterisk('Packages(Optional)'),
                        const SizedBox(height: 10),
                        CustomWidgets().dropdownStyledTextField(
                          context: context,
                          hint: 'Select Packages',
                          controller: c.packageController,
                        ),
                        const SizedBox(height: 10),
                        CustomWidgets().labelWithAsterisk('Categories'),
                        const SizedBox(height: 10),
                        CustomWidgets().dropdownStyledTextField(
                          context: context,
                          hint: 'Select Categories',
                          controller: c.categoryController,
                        ),
                        const SizedBox(height: 10),
                        CustomWidgets().labelWithAsterisk('Courses'),
                        const SizedBox(height: 10),
                        CustomWidgets().dropdownStyledTextField(
                          context: context,
                          hint: 'Select Courses',
                          controller: c.courseController,
                        ),
                        const SizedBox(height: 10),
                        CustomWidgets().labelWithAsterisk('Syllabus'),
                        const SizedBox(height: 10),
                        CustomWidgets().dropdownStyledTextField(
                          context: context,
                          hint: 'Select Syllabus',
                          controller: c.syllabusController,
                        ),
                        const SizedBox(height: 10),
                        CustomWidgets().labelWithAsterisk('Standards'),
                        const SizedBox(height: 10),
                        CustomWidgets().dropdownStyledTextField(
                          context: context,
                          hint: 'Select Standards',
                          controller: c.standardController,
                        ),
                      ],
                    );
                  }

                  return const SizedBox();
                }),

                const SizedBox(height: 10),

                CustomWidgets().labelWithAsterisk('Title'),
                const SizedBox(height: 10),
                CustomWidgets().dropdownStyledTextField(
                  context: context,
                  hint: 'Enter title',
                  controller: c.titleController,
                ),

                const SizedBox(height: 10),

                /// Material type
                Obx(
                  () => Column(
                    children: [
                      RadioListTile(
                        dense: true,
                        title: Text('Drive'),
                        value: "drive",
                        groupValue: c.selectedMaterialType.value,
                        onChanged: (value) =>
                            c.selectedMaterialType.value = value!,
                      ),
                      RadioListTile(
                        dense: true,
                        title: Text('Youtube'),
                        value: "youtube",
                        groupValue: c.selectedMaterialType.value,
                        onChanged: (value) =>
                            c.selectedMaterialType.value = value!,
                      ),
                      RadioListTile(
                        dense: true,
                        title: Text('File'),
                        value: "file",
                        groupValue: c.selectedMaterialType.value,
                        onChanged: (value) =>
                            c.selectedMaterialType.value = value!,
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 10),

                /// dynamic material fields
                Obx(() {
                  if (c.selectedMaterialType.value == 'drive') {
                    return Column(
                      children: [
                        CustomWidgets().labelWithAsterisk('Drive Link'),
                        const SizedBox(height: 10),
                        CustomWidgets().dropdownStyledTextField(
                          context: context,
                          hint: 'Paste Drive Link',
                          controller: c.urlController,
                        )
                      ],
                    );
                  }

                  if (c.selectedMaterialType.value == 'youtube') {
                    return Column(
                      children: [
                        CustomWidgets().labelWithAsterisk('YouTube Link'),
                        const SizedBox(height: 10),
                        CustomWidgets().dropdownStyledTextField(
                          controller: c.urlController,
                          context: context,
                          hint: 'Paste YouTube Link',
                        )
                      ],
                    );
                  }

                  if (c.selectedMaterialType.value == 'file') {
                    return Column(
                      children: [
                        CustomWidgets().labelWithAsterisk('Upload file'),
                        const SizedBox(height: 10),
                        CustomWidgets().dropdownStyledTextField(
                            controller: c.urlController,
                            context: context,
                            hint: 'Click to upload')
                      ],
                    );
                  }

                  return const SizedBox();
                }),

                const SizedBox(height: 10),

                CustomWidgets().labelWithAsterisk('Description'),
                const SizedBox(height: 10),
                CustomWidgets().dropdownStyledTextField(
                    context: context,
                    hint: 'Enter description',
                    controller: c.messageController,
                    isMultiline: true),
              ],
            ),
          ),
        ),
      ],
      onSubmit: () {},
    );
  }

  FloatingActionButton addMaterialBtn(BuildContext context) {
    return FloatingActionButton(
      onPressed: () {
        c.clearController();
        CustomWidgets().showCustomDialog(
          context: context,
          title: Text("Add Material"),
          formKey: GlobalKey<FormState>(),
          onSubmit: () {},
          sections: [
            SizedBox(
              height: MediaQuery.of(context).size.height *
                  0.7, // 🔥 full scroll area
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    Obx(
                      () => Row(
                        children: [
                          Expanded(
                            child: RadioListTile(
                              dense: true,
                              title: Text('Batch'),
                              value: "batch",
                              groupValue: c.selectedUser.value,
                              onChanged: (value) =>
                                  c.selectedUser.value = value!,
                            ),
                          ),
                          Expanded(
                            child: RadioListTile(
                              dense: true,
                              title: Text('Individual'),
                              value: "individual",
                              groupValue: c.selectedUser.value,
                              onChanged: (value) =>
                                  c.selectedUser.value = value!,
                            ),
                          ),
                        ],
                      ),
                    ),

                    const SizedBox(height: 10),

                    /// 🔥 Your dynamic section
                    Obx(() {
                      if (c.selectedUser.value == 'batch') {
                        return Column(
                          children: [
                            CustomWidgets().labelWithAsterisk('Batches'),
                            const SizedBox(height: 10),
                            CustomWidgets().dropdownStyledTextField(
                                context: context, hint: 'Select batches')
                          ],
                        );
                      }

                      if (c.selectedUser.value == 'individual') {
                        return Column(
                          children: [
                            CustomWidgets()
                                .labelWithAsterisk('Packages(Optional)'),
                            const SizedBox(height: 10),
                            CustomWidgets().dropdownStyledTextField(
                                context: context, hint: 'Select Packages'),
                            const SizedBox(height: 10),
                            CustomWidgets().labelWithAsterisk('Categories'),
                            const SizedBox(height: 10),
                            CustomWidgets().dropdownStyledTextField(
                                context: context, hint: 'Select Categories'),
                            const SizedBox(height: 10),
                            CustomWidgets().labelWithAsterisk('Courses'),
                            const SizedBox(height: 10),
                            CustomWidgets().dropdownStyledTextField(
                                context: context, hint: 'Select Courses'),
                            const SizedBox(height: 10),
                            CustomWidgets().labelWithAsterisk('Syllabus'),
                            const SizedBox(height: 10),
                            CustomWidgets().dropdownStyledTextField(
                                context: context, hint: 'Select Syllabus'),
                            const SizedBox(height: 10),
                            CustomWidgets().labelWithAsterisk('Standards'),
                            const SizedBox(height: 10),
                            CustomWidgets().dropdownStyledTextField(
                                context: context, hint: 'Select Standards'),
                          ],
                        );
                      }

                      return const SizedBox();
                    }),

                    const SizedBox(height: 10),

                    CustomWidgets().labelWithAsterisk('Title'),
                    const SizedBox(height: 10),
                    CustomWidgets().dropdownStyledTextField(
                        context: context, hint: 'Enter title'),

                    const SizedBox(height: 10),

                    /// Material type
                    Obx(
                      () => Column(
                        children: [
                          RadioListTile(
                            dense: true,
                            title: Text('Drive'),
                            value: "drive",
                            groupValue: c.selectedMaterialType.value,
                            onChanged: (value) =>
                                c.selectedMaterialType.value = value!,
                          ),
                          RadioListTile(
                            dense: true,
                            title: Text('Youtube'),
                            value: "youtube",
                            groupValue: c.selectedMaterialType.value,
                            onChanged: (value) =>
                                c.selectedMaterialType.value = value!,
                          ),
                          RadioListTile(
                            dense: true,
                            title: Text('File'),
                            value: "file",
                            groupValue: c.selectedMaterialType.value,
                            onChanged: (value) =>
                                c.selectedMaterialType.value = value!,
                          ),
                        ],
                      ),
                    ),

                    const SizedBox(height: 10),

                    /// dynamic material fields
                    Obx(() {
                      if (c.selectedMaterialType.value == 'drive') {
                        return Column(
                          children: [
                            CustomWidgets().labelWithAsterisk('Drive Link'),
                            const SizedBox(height: 10),
                            CustomWidgets().dropdownStyledTextField(
                                context: context, hint: 'Paste Drive Link')
                          ],
                        );
                      }

                      if (c.selectedMaterialType.value == 'youtube') {
                        return Column(
                          children: [
                            CustomWidgets().labelWithAsterisk('YouTube Link'),
                            const SizedBox(height: 10),
                            CustomWidgets().dropdownStyledTextField(
                                context: context, hint: 'Paste YouTube Link')
                          ],
                        );
                      }

                      if (c.selectedMaterialType.value == 'file') {
                        return Column(
                          children: [
                            CustomWidgets().labelWithAsterisk('Upload file'),
                            const SizedBox(height: 10),
                            CustomWidgets().dropdownStyledTextField(
                                context: context, hint: 'Click to upload')
                          ],
                        );
                      }

                      return const SizedBox();
                    }),

                    const SizedBox(height: 10),

                    CustomWidgets().labelWithAsterisk('Description'),
                    const SizedBox(height: 10),
                    CustomWidgets().dropdownStyledTextField(
                        context: context,
                        hint: 'Enter description',
                        isMultiline: true),
                  ],
                ),
              ),
            ),
          ],
        );
      },
      mini: true,
      backgroundColor: context.theme.colorScheme.primary,
      child: Icon(
        Icons.add,
        color: context.theme.colorScheme.onPrimary,
      ),
    );
  }
}
