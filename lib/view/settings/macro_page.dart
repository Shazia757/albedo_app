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

    return Scaffold(
      appBar: const CustomAppBar(),
      backgroundColor: Theme.of(context).colorScheme.onPrimary,
      floatingActionButton: addSupportBtn(context),
      body: Row(
        children: [
          if (isDesktop) const DrawerMenu(),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Obx(() {
                final data = c.supports;
                int crossAxisCount = 1;

                if (c.isLoading.value) {
                  return const Center(child: CircularProgressIndicator());
                }
                if (data.isEmpty) {
                  return const Center(child: Text("No hiring ads found"));
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
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Title',
                                style: TextStyle(
                                  fontSize: 11,
                                  color: Theme.of(context)
                                      .colorScheme
                                      .onSurface
                                      .withOpacity(0.7),
                                ),
                              ),
                              Text(item.title),
                              const SizedBox(height: 10),
                              Text(
                                'Description',
                                style: TextStyle(
                                  fontSize: 11,
                                  color: Theme.of(context)
                                      .colorScheme
                                      .onSurface
                                      .withOpacity(0.7),
                                ),
                              ),
                              Text(item.description)
                            ],
                          ),
                          actions: [
                            CustomWidgets().iconBtn(
                              icon: Icons.edit,
                              color: Theme.of(context).colorScheme.primary,
                              onTap: () {
                                c.loadSupports(item);
                                editMacro(context);
                              },
                            ),
                            CustomWidgets().iconBtn(
                              icon: Icons.delete,
                              color: Theme.of(context).colorScheme.error,
                              onTap: () => CustomWidgets().showDeleteDialog(
                                context: context,
                                text:
                                    'Are you sure you want to delete this hiring ad?',
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

  void editMacro(BuildContext context) {
    CustomWidgets().showCustomDialog(
      context: context,
      title: Text('Edit Support'),
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
        ),
        const SizedBox(height: 10),
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
          title: Text("Add Support"),
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
            ),
            const SizedBox(height: 10),
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
