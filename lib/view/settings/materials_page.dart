import 'package:albedo_app/controller/settings_controller.dart';
import 'package:albedo_app/model/batch_model.dart';
import 'package:albedo_app/model/settings/material_model.dart';
import 'package:albedo_app/model/settings/syllabus_model.dart';
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
      backgroundColor: Theme.of(context).colorScheme.surface,
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          await c.fetchBatches();
          await c.getPackageNames();
          await c.getCategories();
          await c.getCourses();
          await c.getSyllabuses();
          await c.getStandards();
          Future.delayed(Duration.zero, () {
            editMaterials(
              Get.context!,
            );
          });
        },
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
              child: Obx(() {
                final data = c.materials;
                final cs = Theme.of(context).colorScheme;

                if (c.isLoading.value) {
                  return Center(child: CircularProgressIndicator());
                }

                if (data.isEmpty) {
                  return Center(child: Text("No materials found"));
                }

                return Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "Materials",
                      style: Theme.of(context).textTheme.titleLarge!.copyWith(
                          fontWeight: FontWeight.bold,
                          color: Theme.of(context).colorScheme.primary),
                    ),

                    SizedBox(height: 12),

                    /// GRID
                    Expanded(
                      child: LayoutBuilder(
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
                                onTap: () => showMaterialDetail(context, item),
                                content: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      item.title ?? '-',
                                      style: Theme.of(context)
                                          .textTheme
                                          .titleMedium,
                                    ),
                                    SizedBox(height: 10),
                                    Row(
                                      children: [
                                        Text("Category: ",
                                            style: Theme.of(context)
                                                .textTheme
                                                .labelLarge),
                                        Expanded(
                                          child: Text(
                                              (item.categoryNames?.isNotEmpty ??
                                                      false)
                                                  ? item.categoryNames!
                                                      .join(', ')
                                                  : '-',
                                              style: Theme.of(context)
                                                  .textTheme
                                                  .labelLarge),
                                        ),
                                      ],
                                    ),
                                    Row(
                                      children: [
                                        Text("Course: ",
                                            style: Theme.of(context)
                                                .textTheme
                                                .labelLarge),
                                        Expanded(
                                          child: Text(
                                              (item.courseNames?.isNotEmpty ??
                                                      false)
                                                  ? item.courseNames!.join(', ')
                                                  : '-',
                                              style: Theme.of(context)
                                                  .textTheme
                                                  .labelLarge),
                                        ),
                                      ],
                                    ),
                                    Row(
                                      children: [
                                        Text("Type: ",
                                            style: Theme.of(context)
                                                .textTheme
                                                .labelLarge),
                                        Text(item.materialType ?? '-',
                                            style: Theme.of(context)
                                                .textTheme
                                                .labelLarge),
                                      ],
                                    ),
                                    Row(
                                      children: [
                                        Text(
                                          "Content: ",
                                          style: Theme.of(context)
                                              .textTheme
                                              .labelLarge,
                                        ),
                                        Text(
                                          item.contentType ?? '-',
                                          style: Theme.of(context)
                                              .textTheme
                                              .labelLarge,
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                                actions: [
                                  CustomWidgets().iconBtn(
                                    icon: Icons.edit,
                                    color: cs.primary,
                                    onTap: () async {
                                      await c.fetchBatches();
                                      await c.getPackageNames();
                                      await c.getCategories();
                                      await c.getCourses();
                                      await c.getSyllabuses();
                                      await c.getStandards();

                                      Future.delayed(Duration.zero, () {
                                        editMaterials(
                                          Get.context!,
                                          material: item,
                                        );
                                      });
                                    },
                                  ),
                                  SizedBox(width: 10),
                                  CustomWidgets().iconBtn(
                                    icon: Icons.delete,
                                    color: cs.error,
                                    onTap: () =>
                                        CustomWidgets().showDeleteDialog(
                                      dltText: Obx(
                                        () => c.isLoading.value
                                            ? const SizedBox(
                                                width: 18,
                                                height: 18,
                                                child:
                                                    CircularProgressIndicator(
                                                  strokeWidth: 2,
                                                  color: Colors.white,
                                                ),
                                              )
                                            : Text(
                                                "Yes",
                                                style: Theme.of(context)
                                                    .textTheme
                                                    .titleSmall!
                                                    .copyWith(
                                                        color: Colors.white),
                                              ),
                                      ),
                                      title: 'Are you sure?',
                                      context: context,
                                      text:
                                          'Are you sure you want to delete this material?',
                                      onConfirm: () =>
                                          c.deleteMaterial(item.id ?? ''),
                                    ),
                                  ),
                                ],
                              );
                            },
                          );
                        },
                      ),
                    ),
                  ],
                );
              }),
            ),
          ),
        ],
      ),
    );
  }

  void showMaterialDetail(
    BuildContext context,
    Materials material,
  ) {
    final cs = Theme.of(context).colorScheme;
    final batches = material.batchNames!.map((e) => e ?? '').toList();

    CustomWidgets().showCustomDialog(
      context: context,
      title: Text("Material Details"),
      icon: Icons.assignment_outlined,
      formKey: GlobalKey<FormState>(),
      isViewOnly: true,
      onSubmit: () {},
      sections: [
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            /// TITLE LABEL
            Text(
              "Title",
              style: Theme.of(context).textTheme.titleSmall!.copyWith(
                    fontWeight: FontWeight.w700,
                  ),
            ),

            const SizedBox(height: 6),

            /// TITLE VALUE
            Text(
              material.title ?? "",
              textAlign: TextAlign.left,
              style: Theme.of(context).textTheme.bodyMedium!.copyWith(
                    height: 1.5,
                  ),
            ),

            const SizedBox(height: 18),

            /// DATE LABEL
            Text(
              "Material Type",
              style: Theme.of(context).textTheme.titleSmall!.copyWith(
                    fontWeight: FontWeight.w700,
                    color: cs.onSurface,
                  ),
            ),

            const SizedBox(height: 6),

            /// DATE VALUE
            Text(
              material.materialType ?? "",
              textAlign: TextAlign.left,
              style: Theme.of(context).textTheme.bodyMedium!.copyWith(
                    height: 1.5,
                  ),
            ),

            const SizedBox(height: 18),
            Text(
              "Content Type",
              style: Theme.of(context).textTheme.titleSmall!.copyWith(
                    fontWeight: FontWeight.w700,
                    color: cs.onSurface,
                  ),
            ),

            const SizedBox(height: 6),

            /// DATE VALUE
            Text(
              material.contentType ?? "",
              textAlign: TextAlign.left,
              style: Theme.of(context).textTheme.bodyMedium!.copyWith(
                    height: 1.5,
                  ),
            ),

            const SizedBox(height: 18),

            /// TEST TYPES LABEL
            Text(
              "Batches",
              style: Theme.of(context).textTheme.titleSmall!.copyWith(
                    fontWeight: FontWeight.w700,
                    color: cs.onSurface,
                  ),
            ),

            const SizedBox(height: 10),

            /// TEST TYPES
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: batches.map((v) {
                return Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 10,
                    vertical: 6,
                  ),
                  decoration: BoxDecoration(
                    color: cs.primary.withOpacity(0.08),
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: Text(
                    v,
                    style: Theme.of(context).textTheme.labelSmall!.copyWith(
                          color: cs.primary,
                          fontWeight: FontWeight.w600,
                        ),
                  ),
                );
              }).toList(),
            ),

            const SizedBox(height: 18),
            const SizedBox(height: 18),
            Text(
              "Description",
              style: Theme.of(context).textTheme.titleSmall!.copyWith(
                    fontWeight: FontWeight.w700,
                    color: cs.onSurface,
                  ),
            ),

            const SizedBox(height: 6),

            /// DATE VALUE
            Text(
              material.description ?? "",
              textAlign: TextAlign.left,
              style: Theme.of(context).textTheme.bodyMedium!.copyWith(
                    height: 1.5,
                  ),
            ),

            const SizedBox(height: 24),

            /// EDIT BUTTON
            SizedBox(
              width: double.infinity,
              child: ElevatedButton.icon(
                onPressed: () async {
                  editMaterials(context, material: material);
                },
                icon: const Icon(Icons.edit, size: 18),
                label: const Text('Edit'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: cs.primary,
                  foregroundColor: cs.onPrimary,
                  padding: const EdgeInsets.symmetric(
                    vertical: 14,
                  ),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }

  void editMaterials(
    BuildContext context, {
    Materials? material,
  }) {
    final isEdit = material != null;
    final formKey = GlobalKey<FormState>();

    /// ---------------- PRELOAD DATA ----------------
    if (isEdit) {
      /// title & description
      c.titleController.text = material.title ?? '';
      c.messageController.text = material.description ?? '';

      /// detect user type
      final hasBatch = material.batches != null && material.batches!.isNotEmpty;

      c.selectedUser.value = hasBatch ? 'batch' : 'individual';

      /// material type
      c.selectedMaterialType.value = material.contentType ?? 'drive';

      /// preload batch
      c.batchController.text = material.batchNames?.join(', ') ?? '';

      /// preload package
      c.packageController.text = material.packageNames?.join(', ') ?? '';

      /// preload category
      c.categoryController.text = material.categoryNames?.join(', ') ?? '';

      /// preload course
      c.courseController.text = material.courseNames?.join(', ') ?? '';

      /// preload syllabus
      c.syllabusController.text = material.syllabusNames?.join(', ') ?? '';

      /// preload standard
      c.standardController.text = material.standardNames?.join(', ') ?? '';

      c.selectedCategories.assignAll(
        c.categories.where(
          (e) => material.categories?.contains(e.id) ?? false,
        ),
      );
      c.selectedCourses.assignAll(
        c.course.where(
          (e) => material.courses?.contains(e.id) ?? false,
        ),
      );

      c.selectedPackages.assignAll(
        c.packageNames.where(
          (e) => material.packages?.contains(e.id) ?? false,
        ),
      );

      c.selectedStandards.assignAll(
        c.standards.where(
          (e) => material.standards?.contains(e.id) ?? false,
        ),
      );

      c.selectedSyllabi.assignAll(
        c.syllabus.where(
          (e) => material.syllabi?.contains(e.id) ?? false,
        ),
      );

      c.selectedBatches.assignAll(
        c.batches.where(
          (e) => material.batches?.contains(e.id) ?? false,
        ),
      );

      /// preload links
      if (c.selectedMaterialType.value == 'drive') {
        c.driveUrlController.text = material.driveLink ?? '';
      } else if (c.selectedMaterialType.value == 'youtube') {
        c.youtubeUrlController.text = material.youtubeLink ?? '';
      } else {
        c.urlController.clear();
      }

      /// existing file
      c.selectedMedia.value = null;
    } else {
      c.clearMaterialForm();
    }

    CustomWidgets().showCustomDialog(
      context: context,
      title: Text(isEdit ? 'Edit Material' : 'Add Material'),
      icon: isEdit ? Icons.edit : Icons.add,
      formKey: formKey,

      submitWidget: Obx(
        () => SizedBox(
          width: 100,
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
                    isEdit ? "Update" : "Submit",
                    style: const TextStyle(color: Colors.white),
                  ),
          ),
        ),
      ),

      sections: [
        SizedBox(
          height: MediaQuery.of(context).size.height * 0.7,
          child: SingleChildScrollView(
            child: Column(
              children: [
                /// ---------------- USER TYPE ----------------
                Obx(
                  () => Row(
                    children: [
                      Expanded(
                        child: RadioListTile(
                          dense: true,
                          title: const Text('Batch'),
                          value: "batch",
                          groupValue: c.selectedUser.value,
                          onChanged: (value) {
                            c.selectedUser.value = value!;
                          },
                        ),
                      ),
                      Expanded(
                        child: RadioListTile(
                          dense: true,
                          title: const Text('Individual'),
                          value: "individual",
                          groupValue: c.selectedUser.value,
                          onChanged: (value) {
                            c.selectedUser.value = value!;
                          },
                        ),
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 10),

                /// ---------------- DYNAMIC USER FIELDS ----------------
                Obx(() {
                  if (c.selectedUser.value == 'batch') {
                    return Column(
                      children: [
                        CustomWidgets().labelWithAsterisk('Batches'),
                        const SizedBox(height: 10),
                        CustomWidgets().customMultiDropdownField<BatchDetail>(
                          context: context,
                          hint: 'Select batch',
                          items: c.batches,
                          itemLabel: (item) => item.name ?? '',
                          selectedItems: c.selectedBatches,
                        ),
                      ],
                    );
                  }

                  return Column(
                    children: [
                      /// PACKAGE
                      CustomWidgets().labelWithAsterisk('Package (Optional)'),

                      const SizedBox(height: 10),

                      CustomWidgets().customMultiDropdownField<Syllabus>(
                        context: context,
                        hint: 'Select Package',
                        items: c.packageNames,
                        itemLabel: (item) => item.name ?? '',
                        selectedItems: c.selectedPackages,
                      ),

                      const SizedBox(height: 10),

                      /// CATEGORY
                      CustomWidgets().labelWithAsterisk('Category'),

                      const SizedBox(height: 10),

                      CustomWidgets().customMultiDropdownField<Syllabus>(
                        context: context,
                        hint: 'Select Category',
                        items: c.categories,
                        itemLabel: (item) => item.name ?? '',
                        selectedItems: c.selectedCategories,
                      ),

                      const SizedBox(height: 10),

                      /// COURSE
                      CustomWidgets().labelWithAsterisk('Courses'),

                      const SizedBox(height: 10),

                      CustomWidgets().customMultiDropdownField<Syllabus>(
                        context: context,
                        hint: 'Select Course',
                        items: c.course,
                        itemLabel: (item) => item.name ?? '',
                        selectedItems: c.selectedCourses,
                      ),

                      const SizedBox(height: 10),

                      /// SYLLABUS
                      CustomWidgets().labelWithAsterisk('Syllabus'),

                      const SizedBox(height: 10),

                      CustomWidgets().customMultiDropdownField<Syllabus>(
                        context: context,
                        hint: 'Select Syllabus',
                        items: c.syllabus,
                        itemLabel: (item) => item.name ?? '',
                        selectedItems: c.selectedSyllabi,
                      ),

                      const SizedBox(height: 10),

                      /// STANDARD
                      CustomWidgets().labelWithAsterisk('Standard'),

                      const SizedBox(height: 10),

                      CustomWidgets().customMultiDropdownField<Syllabus>(
                        context: context,
                        hint: 'Select Standard',
                        items: c.standards,
                        itemLabel: (item) => item.name ?? '',
                        selectedItems: c.selectedStandards,
                      ),
                    ],
                  );
                }),

                const SizedBox(height: 10),

                /// ---------------- TITLE ----------------
                CustomWidgets().labelWithAsterisk('Title'),

                const SizedBox(height: 10),

                CustomWidgets().dropdownStyledTextField(
                  context: context,
                  hint: 'Enter title',
                  controller: c.titleController,
                ),

                const SizedBox(height: 10),

                /// ---------------- MATERIAL TYPE ----------------
                Obx(
                  () => Column(
                    children: [
                      RadioListTile(
                        dense: true,
                        title: const Text('Drive'),
                        value: "drive",
                        groupValue: c.selectedMaterialType.value,
                        onChanged: (value) {
                          c.selectedMaterialType.value = value!;
                        },
                      ),
                      RadioListTile(
                        dense: true,
                        title: const Text('Youtube'),
                        value: "youtube",
                        groupValue: c.selectedMaterialType.value,
                        onChanged: (value) {
                          c.selectedMaterialType.value = value!;
                        },
                      ),
                      RadioListTile(
                        dense: true,
                        title: const Text('File'),
                        value: "file",
                        groupValue: c.selectedMaterialType.value,
                        onChanged: (value) {
                          c.selectedMaterialType.value = value!;
                        },
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 10),

                /// ---------------- MATERIAL FIELDS ----------------
                Obx(() {
                  if (c.selectedMaterialType.value == 'drive') {
                    return Column(
                      children: [
                        CustomWidgets().labelWithAsterisk('Drive Link'),
                        const SizedBox(height: 10),
                        CustomWidgets().dropdownStyledTextField(
                          context: context,
                          hint: 'Paste Drive Link',
                          controller: c.driveUrlController,
                        ),
                      ],
                    );
                  }

                  if (c.selectedMaterialType.value == 'youtube') {
                    return Column(
                      children: [
                        CustomWidgets().labelWithAsterisk('YouTube Link'),
                        const SizedBox(height: 10),
                        CustomWidgets().dropdownStyledTextField(
                          context: context,
                          hint: 'Paste YouTube Link',
                          controller: c.youtubeUrlController,
                        ),
                      ],
                    );
                  }
                  if (c.selectedMaterialType.value == 'file') {
                    return Column(
                      children: [
                        CustomWidgets().labelWithAsterisk('Upload file'),
                        const SizedBox(height: 10),
                        CustomWidgets().mediaPickerField(
                          context: context,
                          fileName: c.selectedMedia.value?.path.split('/').last,
                          onTap: () async {
                            await c.pickMedia();
                          },
                          onClear: () {
                            c.selectedMedia.value = null;
                          },
                        ),
                      ],
                    );
                  } else {
                    return SizedBox();
                  }
                }),

                const SizedBox(height: 10),

                /// ---------------- DESCRIPTION ----------------
                CustomWidgets().labelWithAsterisk('Description'),

                const SizedBox(height: 10),

                CustomWidgets().dropdownStyledTextField(
                  context: context,
                  hint: 'Enter description',
                  controller: c.messageController,
                  isMultiline: true,
                ),
                const SizedBox(height: 20),
              ],
            ),
          ),
        ),
      ],

      /// ---------------- SUBMIT ----------------
      onSubmit: () async {
        if (c.selectedUser.value == 'individual') {
          if (c.selectedBatches.isEmpty) {
            Get.snackbar('Error', 'Please select atleast one batch');
            return;
          }
          if (c.titleController.text.isEmpty) {
            Get.snackbar('Error', 'Please enter title');
            return;
          }
        }

        /// individual validation
        if (c.selectedUser.value == 'individual') {
          if (c.selectedCategories.isEmpty) {
            Get.snackbar(
              'Error',
              'Please select category',
            );
            return;
          }

          if (c.selectedCourses.isEmpty) {
            Get.snackbar(
              'Error',
              'Please select course',
            );
            return;
          }

          if (c.selectedSyllabi.isEmpty) {
            Get.snackbar(
              'Error',
              'Please select syllabus',
            );
            return;
          }

          if (c.selectedStandards.isEmpty) {
            Get.snackbar(
              'Error',
              'Please select standard',
            );
            return;
          }
        }

        /// content validation
        if (c.selectedMaterialType.value == 'drive' &&
            c.driveUrlController.text.trim().isEmpty) {
          Get.snackbar(
            'Error',
            'Please enter drive link',
          );
          return;
        }

        if (c.selectedMaterialType.value == 'youtube' &&
            c.youtubeUrlController.text.trim().isEmpty) {
          Get.snackbar(
            'Error',
            'Please enter YouTube link',
          );
          return;
        }

        if (c.selectedMaterialType.value == 'file' &&
            c.selectedMedia.value == null &&
            !isEdit) {
          Get.snackbar(
            'Error',
            'Please upload file',
          );
          return;
        }

        final body = {
          "title": c.titleController.text.trim(),
          "description": c.messageController.text.trim(),
          "content_type": c.selectedMaterialType.value,
          "material_type": c.selectedUser.value,
          "batches":
              c.selectedBatches.map((e) => e.id).whereType<String>().toList(),
          "categories": c.selectedCategories
              .map((e) => e.id)
              .whereType<String>()
              .toList(),
          "courses":
              c.selectedCourses.map((e) => e.id).whereType<String>().toList(),
          "packages":
              c.selectedPackages.map((e) => e.id).whereType<String>().toList(),
          "standards":
              c.selectedStandards.map((e) => e.id).whereType<String>().toList(),
          "syllabi":
              c.selectedSyllabi.map((e) => e.id).whereType<String>().toList(),
          "drive_link": c.selectedMaterialType.value == "drive"
              ? c.driveUrlController.text.trim()
              : "",
          "youtube_link": c.selectedMaterialType.value == "youtube"
              ? c.youtubeUrlController.text.trim()
              : "",
          "uploaded_file": c.selectedMaterialType.value == "file"
              ? c.selectedMedia.value
              : null,
        };

        if (isEdit) {
          await c.updateMaterial(
            id: material.id ?? '',
            body: body,
          );
        } else {
          await c.addMaterial(body: body);
        }
      },
    );
  }
}
