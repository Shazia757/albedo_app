import 'package:albedo_app/controller/settings_controller.dart';
import 'package:albedo_app/model/settings/hiring_ad_model.dart';
import 'package:albedo_app/modules/admin/view/settings/banner_ads_page.dart';
import 'package:albedo_app/widgets/responsive.dart';
import 'package:albedo_app/widgets/widgets.dart';
import 'package:albedo_app/widgets/custom_appbar.dart';
import 'package:albedo_app/widgets/drawer_menu.dart';
import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:get/get.dart';

class AssessmentsPage extends StatelessWidget {
  final c = Get.put(SettingsController());

  AssessmentsPage({super.key});

  @override
  Widget build(BuildContext context) {
    final isDesktop = Responsive.isDesktop(context);

    return Scaffold(
      appBar: const CustomAppBar(),
      backgroundColor: Theme.of(context).colorScheme.onPrimary,
      floatingActionButton: addAssessmentBtn(context),
      body: Row(
        children: [
          if (isDesktop) const DrawerMenu(),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Obx(() {
                final data = c.assessments;
                int crossAxisCount = 1;

                if (c.isLoading.value) {
                  return const Center(child: CircularProgressIndicator());
                }
                if (data.isEmpty) {
                  return const Center(child: Text("No assessments found"));
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
                              Text(item.title ?? ''),
                            ],
                          ),
                          actions: [
                            CustomWidgets().iconBtn(
                              icon: Icons.edit,
                              color: Theme.of(context).colorScheme.primary,
                              onTap: () {
                                c.loadAssessments(item);
                                editAssessment(context);
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

  void editAssessment(BuildContext context) {
    CustomWidgets().showCustomDialog(
      context: context,
      title: Text('Edit Assessment'),
      icon: Icons.edit,
      formKey: GlobalKey<FormState>(),
      sections: [
        CustomWidgets().labelWithAsterisk('Title'),
        const SizedBox(height: 10),
        CustomWidgets().dropdownStyledTextField(
          context: context,
          hint: 'Enter title',
          controller: c.titleController,
        ),
        const SizedBox(height: 10),
        CustomWidgets().labelWithAsterisk('Select Test Types'),
        const SizedBox(height: 10),
        MultiSelector<String>(
          items: c.testTypes,
          initial: List<String>.from(c.selectedTestType),
          onChanged: (p0) {},
          labelBuilder: (p0) => p0,
        ),
        const SizedBox(height: 10),
        CustomWidgets().labelWithAsterisk('Select Attention Questions'),
        const SizedBox(height: 10),
        MultiSelector<String>(
          items: c.assessmentAttentionQn,
          initial: List<String>.from(c.selectedAttentionQns),
          onChanged: (p0) {},
          labelBuilder: (p0) => p0,
        ),
      ],
      onSubmit: () {},
    );
  }

  FloatingActionButton addAssessmentBtn(BuildContext context) {
    return FloatingActionButton(
      onPressed: () {
        c.titleController.clear();
        c.messageController.clear();
        CustomWidgets().showCustomDialog(
          context: context,
          title: Text("Add Assessment"),
          formKey: GlobalKey<FormState>(),
          onSubmit: () {},
          sections: [
            CustomWidgets().labelWithAsterisk('Title'),
            const SizedBox(height: 10),
            CustomWidgets().dropdownStyledTextField(
              context: context,
              hint: 'Enter title',
              controller: c.titleController,
            ),
            const SizedBox(height: 10),
            const SizedBox(height: 10),
            CustomWidgets().labelWithAsterisk('Select Test Types'),
            const SizedBox(height: 10),
            MultiSelector<String>(
              items: c.testTypes,
              initial: [],
              onChanged: (p0) {},
              labelBuilder: (p0) => p0,
            ),
            const SizedBox(height: 10),
            CustomWidgets().labelWithAsterisk('Select Attention Questions'),
            const SizedBox(height: 10),
            MultiSelector<String>(
              items: c.assessmentAttentionQn,
              initial: [],
              onChanged: (p0) {},
              labelBuilder: (p0) => p0,
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
