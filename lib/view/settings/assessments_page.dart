import 'package:albedo_app/controller/settings_controller.dart';
import 'package:albedo_app/model/settings/assessment_model.dart';
import 'package:albedo_app/model/settings/syllabus_model.dart';
import 'package:albedo_app/view/settings/banner_ads_page.dart';
import 'package:albedo_app/widgets/responsive.dart';
import 'package:albedo_app/widgets/widgets.dart';
import 'package:albedo_app/widgets/custom_appbar.dart';
import 'package:albedo_app/widgets/drawer_menu.dart';
import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

class AssessmentsPage extends StatelessWidget {
  AssessmentsPage({super.key});

  final SettingsController c = Get.find<SettingsController>();

  @override
  Widget build(BuildContext context) {
    final isDesktop = Responsive.isDesktop(context);
    final cs = Theme.of(context).colorScheme;

    return Scaffold(
      appBar: const CustomAppBar(),
      backgroundColor: cs.surface,
      floatingActionButton: FloatingActionButton(
        onPressed: () => editAssessment(context),
        mini: true,
        backgroundColor: cs.primary,
        child: Icon(Icons.add, color: cs.onPrimary),
      ),
      body: Row(
        children: [
          if (isDesktop) const DrawerMenu(),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Obx(() {
                final data = c.assessmentReportTypes;
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
                                title: DateFormat('dd MMM yyyy')
                                    .format(item.dateAdded ?? DateTime.now()),
                                c: c,
                                onTap: () => showAssessmentDetail(context, item),
                                content: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      "Title",
                                      style: Theme.of(context)
                                          .textTheme
                                          .labelSmall!
                                          .copyWith(
                                              color: cs.onSurface
                                                  .withOpacity(0.6)),
                                    ),
                                    SizedBox(height: 4),
                                    Text(
                                      item.title ?? 'Title not provided',
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
                                    onTap: () async {
                                      editAssessment(context, assessment: item);
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

  void showAssessmentDetail(
    BuildContext context,
    Assessment assessment,
  ) {
    final controller = Get.find<SettingsController>();
    final cs = Theme.of(context).colorScheme;
    final testTypes = assessment.testTypes!.map((e) => e.name ?? '').toList();

    CustomWidgets().showCustomDialog(
      context: context,
      title: Text("Assessment Details"),
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
              assessment.title ?? "",
              textAlign: TextAlign.left,
              style: Theme.of(context).textTheme.bodyMedium!.copyWith(
                    height: 1.5,
                  ),
            ),

            const SizedBox(height: 18),

            /// DATE LABEL
            Text(
              "Date Added",
              style: Theme.of(context).textTheme.titleSmall!.copyWith(
                    fontWeight: FontWeight.w700,
                    color: cs.onSurface,
                  ),
            ),

            const SizedBox(height: 6),

            /// DATE VALUE
            Text(
              DateFormat('dd MMM yyyy').format(
                assessment.dateAdded ?? DateTime.now(),
              ),
              textAlign: TextAlign.left,
              style: Theme.of(context).textTheme.bodyMedium!.copyWith(
                    color: cs.onSurface.withOpacity(0.85),
                    height: 1.5,
                  ),
            ),

            const SizedBox(height: 18),

            /// TEST TYPES LABEL
            Text(
              "Test Types",
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
              children: testTypes.map((v) {
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

            Text(
              "Attention Questions",
              style: Theme.of(context).textTheme.titleSmall!.copyWith(
                    fontWeight: FontWeight.w700,
                    color: cs.onSurface,
                  ),
            ),

            const SizedBox(height: 10),

            Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: List.generate(
                    assessment.attentionQuestions?.length ?? 0, (index) {
                  final question =
                      assessment.attentionQuestions?[index].value ?? '';

                  return Padding(
                    padding: const EdgeInsets.only(bottom: 8),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "${index + 1}. ",
                          style: Theme.of(context)
                              .textTheme
                              .bodyMedium!
                              .copyWith(fontWeight: FontWeight.w600),
                        ),
                        Expanded(
                          child: Text(
                            question,
                            style: Theme.of(context)
                                .textTheme
                                .bodyMedium!
                                .copyWith(
                                  height: 1.4,
                                ),
                          ),
                        ),
                      ],
                    ),
                  );
                })),

            const SizedBox(height: 24),

            /// EDIT BUTTON
            SizedBox(
              width: double.infinity,
              child: ElevatedButton.icon(
                onPressed: () async {
                  editAssessment(
                    context,
                    assessment: assessment,
                  );
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

  /// ================= ADD / EDIT =================
  void editAssessment(
    BuildContext context, {
    Assessment? assessment,
  }) {
    final isEdit = assessment != null;
    final cs = Theme.of(context).colorScheme;

    /// LOAD DATA
    if (isEdit) {
      c.titleController.text = assessment.title ?? '';

      /// TEST TYPES
      /// TEST TYPES
      c.selectedTestType.assignAll(
        c.testTypes.where((testType) {
          return assessment.testTypes?.any(
                (e) => e.id == testType.id,
              ) ??
              false;
        }).toList(),
      );

      /// ATTENTION QUESTIONS
      c.selectedAttentionQns.assignAll(
        c.assessmentAttentionQns.where((q) {
          return assessment.attentionQuestions?.any(
                (e) => e.id == q.id,
              ) ??
              false;
        }).toList(),
      );
    } else {
      /// CLEAR DATA
      c.titleController.clear();

      c.selectedTestType.clear();
      c.selectedAttentionQns.clear();
    }

    CustomWidgets().showCustomDialog(
      context: context,
      title: Text(
        isEdit ? 'Edit Assessment' : 'Add Assessment',
      ),
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
      icon: isEdit ? Icons.edit : Icons.add,
      formKey: GlobalKey<FormState>(),
      sections: [
        /// TITLE
        CustomWidgets().labelWithAsterisk('Title'),
        const SizedBox(height: 10),

        CustomWidgets().dropdownStyledTextField(
          context: context,
          hint: 'Enter title',
          controller: c.titleController,
        ),

        const SizedBox(height: 16),

        CustomWidgets().labelWithAsterisk('Select Test Types'),
        SizedBox(height: 10),
        MultiSelector<TestType>(
          items: c.testTypes,
          initial: c.selectedTestType.toList(),
          onChanged: (val) => c.selectedTestType.assignAll(val),
          labelBuilder: (v) => v.name ?? '',
        ),
        SizedBox(height: 16),
        CustomWidgets().labelWithAsterisk('Select Attention Questions'),
        SizedBox(height: 10),
        MultiSelector<AssessmentAttentionQns>(
          items: c.assessmentAttentionQns,
          initial: c.selectedAttentionQns.toList(),
          onChanged: (val) => c.selectedAttentionQns.assignAll(val),
          labelBuilder: (v) => v.value ?? '',
        ),
      ],
      onSubmit: () async {
        /// VALIDATION
        if (c.titleController.text.trim().isEmpty) {
          Get.snackbar(
            "Error",
            "Please enter title",
          );
          return;
        }

        if (c.selectedTestType.isEmpty) {
          Get.snackbar(
            "Error",
            "Please select test types",
          );
          return;
        }

        if (c.selectedAttentionQns.isEmpty) {
          Get.snackbar(
            "Error",
            "Please select attention questions",
          );
          return;
        }

        try {
          c.isLoading.value = true;

          final body = {
            "title": c.titleController.text.trim(),

            /// TEST TYPE IDS
            "test_types": c.selectedTestType.map((e) => e.id).toList(),

            /// ATTENTION QUESTION VALUES
            "attention_questions": c.selectedAttentionQns,
          };

          if (isEdit) {
            await c.updateAssessment(
              id: assessment.id ?? '',
              body: body,
            );
          } else {
            await c.addAssessment(body: body);
          }

          await c.fetchTestTypes();

          if (context.mounted) {
            Navigator.pop(context);

            Get.snackbar(
              "Success",
              isEdit
                  ? "Assessment updated successfully"
                  : "Assessment added successfully",
            );
          }
        } catch (e) {
          Get.snackbar(
            "Error",
            e.toString(),
          );
        } finally {
          c.isLoading.value = false;
        }
      },
    );
  }
}
