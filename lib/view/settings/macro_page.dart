import 'package:albedo_app/controller/settings_controller.dart';
import 'package:albedo_app/model/support_model.dart';
import 'package:albedo_app/view/settings/banner_ads_page.dart';

import 'package:albedo_app/widgets/responsive.dart';
import 'package:albedo_app/widgets/widgets.dart';
import 'package:albedo_app/widgets/custom_appbar.dart';
import 'package:albedo_app/widgets/drawer_menu.dart';
import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

class MacroPage extends StatelessWidget {
  MacroPage({super.key});

  final SettingsController c = Get.find<SettingsController>();

  @override
  Widget build(BuildContext context) {
    final isDesktop = Responsive.isDesktop(context);
    final cs = Get.theme.colorScheme;

    return Scaffold(
      appBar: const CustomAppBar(),
      backgroundColor: cs.surface,
      floatingActionButton: FloatingActionButton(
        onPressed: () => editMacro(context),
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
                final data = c.supportMacros;

                if (c.isLoading.value) {
                  return Center(child: CircularProgressIndicator());
                }

                if (data.isEmpty) {
                  return Center(child: Text("No supports found"));
                }

                return Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    /// TITLE (outside grid)
                    Text(
                      " Macro",
                      style: Theme.of(context).textTheme.titleLarge!.copyWith(
                          fontWeight: FontWeight.bold,
                          color: Theme.of(context).colorScheme.primary),
                    ),
                    SizedBox(height: 12),

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
                                title: item.dateAdded != null
                                    ? DateFormat('dd MMM yyyy')
                                        .format(item.dateAdded!)
                                    : '',

                                /// CONTENT (modern style)
                                content: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    _label(cs, "Title"),
                                    SizedBox(height: 4),
                                    Text(
                                      item.title ?? '',
                                      style: Get.textTheme.titleMedium,
                                    ),
                                    SizedBox(height: 12),
                                    _label(cs, "Description"),
                                    SizedBox(height: 4),
                                    Text(
                                      item.description ?? '-',
                                      style: Get.textTheme.bodySmall!
                                          .copyWith(height: 1.4),
                                    ),
                                  ],
                                ),

                                actions: [
                                  CustomWidgets().iconBtn(
                                    icon: Icons.edit,
                                    color: cs.primary,
                                    onTap: () => editMacro(context, item: item),
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
                                          'Are you sure you want to delete this support item?',
                                      onConfirm: () => c.delete(item.id),
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

  Widget _label(ColorScheme cs, String text) {
    return Text(
      text,
      style: Get.textTheme.labelSmall!
          .copyWith(color: cs.onSurface.withOpacity(0.6)),
    );
  }

  void editMacro(BuildContext context, {Macro? item}) {
    final isEdit = item != null;

    /// preload values
    if (isEdit) {
      c.titleController.text = item.title ?? '';
      c.messageController.text = item.description ?? '';
    } else {
      c.titleController.clear();
      c.messageController.clear();
    }

    CustomWidgets().showCustomDialog(
      context: context,
      title: Text(isEdit ? 'Edit Support' : 'Add Support'),
      icon: isEdit ? Icons.edit : Icons.add,
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
      formKey: GlobalKey<FormState>(),
      sections: [
        CustomWidgets().labelWithAsterisk('Title'),
        SizedBox(height: 10),
        CustomWidgets().dropdownStyledTextField(
          context: context,
          hint: 'Enter support title',
          controller: c.titleController,
        ),
        SizedBox(height: 10),
        CustomWidgets().labelWithAsterisk('Description'),
        SizedBox(height: 10),
        CustomWidgets().dropdownStyledTextField(
          context: context,
          hint: 'Enter description',
          controller: c.messageController,
          isMultiline: true,
        ),
      ],
      onSubmit: () async {
        final body = {
          "title": c.titleController.text.trim(),
          "description": c.messageController.text.trim(),
        };

        if (isEdit) {
          await c.updateMacro(id: item!.id!, body: body);
        } else {
          await c.addMacro(body: body);
        }
      },
    );
  }
}
