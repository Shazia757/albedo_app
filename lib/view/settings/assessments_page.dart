import 'package:albedo_app/controller/settings_controller.dart';
import 'package:albedo_app/view/settings/banner_ads_page.dart';
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
    final cs = Theme.of(context).colorScheme;

    return Scaffold(
      appBar: const CustomAppBar(),
      backgroundColor: cs.surface,
      floatingActionButton: addAssessmentBtn(context),
      body: Row(
        children: [
          if (isDesktop) const DrawerMenu(),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Obx(() {
                final data = c.assessments;
                final cs = Theme.of(context).colorScheme;

                if (c.isLoading.value) {
                  return Center(child: CircularProgressIndicator());
                }

                if (data.isEmpty) {
                  return Center(child: Text("No assessments found"));
                }

                return Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    /// 🔥 PAGE TITLE (same style as before)
                    Text(
                      "Assessments",
                      style: Theme.of(context).textTheme.titleLarge,
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
                                content: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      "Assessment Type",
                                      style: Theme.of(context)
                                          .textTheme
                                          .labelSmall!
                                          .copyWith(
                                              color: cs.onSurface
                                                  .withOpacity(0.6)),
                                    ),
                                    SizedBox(height: 4),
                                    Text(
                                      item.type ?? '-',
                                      style: Theme.of(context)
                                          .textTheme
                                          .titleMedium,
                                    ),
                                  ],
                                ),
                                actions: [
                                  CustomWidgets().iconBtn(
                                    icon: Icons.edit,
                                    color: cs.primary,
                                    onTap: () {
                                      c.loadAssessments(item);
                                      editAssessment(context);
                                    },
                                  ),
                                  SizedBox(width: 10),
                                  CustomWidgets().iconBtn(
                                    icon: Icons.delete,
                                    color: cs.error,
                                    onTap: () =>
                                        CustomWidgets().showDeleteDialog(
                                      title: 'Are you sure?',
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

  /// ================= EDIT =================
  void editAssessment(BuildContext context) {
    CustomWidgets().showCustomDialog(
      context: context,
      title: Text('Edit Assessment'),
      icon: Icons.edit,
      formKey: GlobalKey<FormState>(),
      sections: [
        CustomWidgets().labelWithAsterisk('Title'),
        SizedBox(height: 10),
        CustomWidgets().dropdownStyledTextField(
          context: context,
          hint: 'Enter title',
          controller: c.titleController,
        ),
        SizedBox(height: 16),
        CustomWidgets().labelWithAsterisk('Select Test Types'),
        SizedBox(height: 10),
        MultiSelector<String>(
          items: c.testTypes,
          initial: List<String>.from(c.selectedTestType),
          onChanged: (val) => c.selectedTestType.assignAll(val),
          labelBuilder: (v) => v,
        ),
        SizedBox(height: 16),
        CustomWidgets().labelWithAsterisk('Select Attention Questions'),
        SizedBox(height: 10),
        MultiSelector<String>(
          items: c.assessmentAttentionQn,
          initial: List<String>.from(c.selectedAttentionQns),
          onChanged: (val) => c.selectedAttentionQns.assignAll(val),
          labelBuilder: (v) => v,
        ),
      ],
      onSubmit: () {},
    );
  }

  /// ================= ADD =================
  FloatingActionButton addAssessmentBtn(BuildContext context) {
    final cs = Theme.of(context).colorScheme;

    return FloatingActionButton(
      onPressed: () {
        c.titleController.clear();

        CustomWidgets().showCustomDialog(
          context: context,
          title: Text("Add Assessment"),
          formKey: GlobalKey<FormState>(),
          onSubmit: () {},
          sections: [
            CustomWidgets().labelWithAsterisk('Title'),
            SizedBox(height: 10),
            CustomWidgets().dropdownStyledTextField(
              context: context,
              hint: 'Enter title',
              controller: c.titleController,
            ),
            SizedBox(height: 16),
            CustomWidgets().labelWithAsterisk('Select Test Types'),
            SizedBox(height: 10),
            MultiSelector<String>(
              items: c.testTypes,
              initial: const [],
              onChanged: (val) => c.selectedTestType.assignAll(val),
              labelBuilder: (v) => v,
            ),
            SizedBox(height: 16),
            CustomWidgets().labelWithAsterisk('Select Attention Questions'),
            SizedBox(height: 10),
            MultiSelector<String>(
              items: c.assessmentAttentionQn,
              initial: const [],
              onChanged: (val) => c.selectedAttentionQns.assignAll(val),
              labelBuilder: (v) => v,
            ),
          ],
        );
      },
      mini: true,
      backgroundColor: cs.primary,
      child: Icon(Icons.add, color: cs.onPrimary),
    );
  }
}
