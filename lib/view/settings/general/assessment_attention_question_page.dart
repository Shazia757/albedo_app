import 'package:albedo_app/model/settings/syllabus_model.dart';
import 'package:albedo_app/widgets/crud_page.dart';
import 'package:albedo_app/widgets/widgets.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:albedo_app/controller/settings_controller.dart';

class AssessmentAttentionQuestionPage extends StatelessWidget {
  AssessmentAttentionQuestionPage({super.key});

  final SettingsController c = Get.find<SettingsController>();

  @override
  Widget build(BuildContext context) {
    return CrudPage(
      title: "Assessment Attention Question",
      items: c.assessmentAttentionQns,
      itemBuilder: (item, i) {
        return EditableTile(
          icon: Icons.help_outline,
          key: ValueKey(item.id),
          value: item.value.toString(),
          onSave: (val) async {
            final success = await c.updateAssessmentAttentionQn(
              id: item.id ?? '',
              question: val,
            );

            if (success) {
              c.assessmentAttentionQns[i] =
                  c.assessmentAttentionQns[i].copyWith(value: val);
              c.assessmentAttentionQns.refresh();
            }
          },
          onDelete: () {
            CustomWidgets().showDeleteDialog(
              dltText: Obx(
                () => c.isLoading.value
                    ? const SizedBox(
                        width: 18,
                        height: 18,
                        child: CircularProgressIndicator(
                          strokeWidth: 2,
                          color: Colors.white,
                        ),
                      )
                    : Text(
                        "Yes",
                        style: Theme.of(context)
                            .textTheme
                            .titleSmall!
                            .copyWith(color: Colors.white),
                      ),
              ),
              title: 'Are you sure?',
              context: context,
              text: 'Delete this question permanently?',
              onConfirm: () async {
                final success =
                    await c.deleteAssessmentAttentionQn(id: item.id ?? '');

                if (success) {
                  c.assessmentAttentionQns.removeWhere((e) => e.id == item.id);
                  Get.back();
                }
              },
            );
          },
        );
      },
      onAdd: (val) async {
        final newItem = await c.addAssessmentAttentionQn(val);

        if (newItem != null) {
          c.assessmentAttentionQns.add(newItem);
        }
      },
      onUpdate: (i, val) async {},
      onDelete: (i) async {},
    );
  }
}
