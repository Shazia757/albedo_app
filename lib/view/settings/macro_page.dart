import 'package:albedo_app/controller/settings_controller.dart';
import 'package:albedo_app/view/settings/banner_ads_page.dart';

import 'package:albedo_app/widgets/responsive.dart';
import 'package:albedo_app/widgets/widgets.dart';
import 'package:albedo_app/widgets/custom_appbar.dart';
import 'package:albedo_app/widgets/drawer_menu.dart';
import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:get/get.dart';

class MacroPage extends StatelessWidget {
  final c = Get.put(SettingsController());

  MacroPage({super.key});

  @override
  Widget build(BuildContext context) {
    final isDesktop = Responsive.isDesktop(context);
    final cs = Theme.of(context).colorScheme;

    return Scaffold(
      appBar: const CustomAppBar(),
      backgroundColor: cs.surface,
      floatingActionButton: addSupportBtn(context),
      body: Row(
        children: [
          if (isDesktop) const DrawerMenu(),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Obx(() {
                final data = c.supports;

                if (c.isLoading.value) {
                  return const Center(child: CircularProgressIndicator());
                }

                if (data.isEmpty) {
                  return const Center(child: Text("No supports found"));
                }

                return Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    /// TITLE (outside grid)
                    Text(
                      " Macro",
                      style: Theme.of(context).textTheme.titleLarge,
                    ),
                    const SizedBox(height: 12),

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

                                /// CONTENT (modern style)
                                content: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    _label(cs, "Title"),
                                    const SizedBox(height: 4),
                                    Text(
                                      item.title ?? '-',
                                      style: const TextStyle(
                                        fontSize: 15,
                                        fontWeight: FontWeight.w700,
                                      ),
                                    ),
                                    const SizedBox(height: 12),
                                    _label(cs, "Description"),
                                    const SizedBox(height: 4),
                                    Text(
                                      item.description ?? '-',
                                      style: const TextStyle(
                                        fontSize: 13,
                                        height: 1.4,
                                      ),
                                    ),
                                  ],
                                ),

                                actions: [
                                  CustomWidgets().iconBtn(
                                    icon: Icons.edit,
                                    color: cs.primary,
                                    onTap: () {
                                      c.loadSupports(item);
                                      editMacro(context);
                                    },
                                  ),
                                  const SizedBox(width: 10),
                                  CustomWidgets().iconBtn(
                                    icon: Icons.delete,
                                    color: cs.error,
                                    onTap: () =>
                                        CustomWidgets().showDeleteDialog(
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
      style: TextStyle(
        fontSize: 11,
        color: cs.onSurface.withOpacity(0.6),
        fontWeight: FontWeight.w500,
      ),
    );
  }

  void editMacro(BuildContext context) {
    CustomWidgets().showCustomDialog(
      context: context,
      title: const Text('Edit Support'),
      icon: Icons.edit,
      formKey: GlobalKey<FormState>(),
      sections: [
        CustomWidgets().labelWithAsterisk('Title'),
        const SizedBox(height: 10),
        CustomWidgets().dropdownStyledTextField(
          context: context,
          hint: 'Enter support title',
          controller: c.titleController,
        ),
        const SizedBox(height: 10),
        CustomWidgets().labelWithAsterisk('Description'),
        const SizedBox(height: 10),
        CustomWidgets().dropdownStyledTextField(
          context: context,
          hint: 'Enter description',
          controller: c.messageController,
          isMultiline: true,
        ),
      ],
      onSubmit: () {},
    );
  }

  FloatingActionButton addSupportBtn(BuildContext context) {
    return FloatingActionButton(
      onPressed: () {
        c.titleController.clear();
        c.messageController.clear();

        CustomWidgets().showCustomDialog(
          context: context,
          title: const Text("Add Support"),
          formKey: GlobalKey<FormState>(),
          onSubmit: () {},
          sections: [
            CustomWidgets().labelWithAsterisk('Title'),
            const SizedBox(height: 10),
            CustomWidgets().dropdownStyledTextField(
              context: context,
              hint: 'Enter support title',
              controller: c.titleController,
            ),
            const SizedBox(height: 10),
            CustomWidgets().labelWithAsterisk('Description'),
            const SizedBox(height: 10),
            CustomWidgets().dropdownStyledTextField(
              context: context,
              hint: 'Enter description',
              controller: c.messageController,
              isMultiline: true,
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
