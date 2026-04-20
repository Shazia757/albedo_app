import 'package:albedo_app/widgets/crud_page.dart';
import 'package:albedo_app/widgets/widgets.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:albedo_app/controller/settings_controller.dart';

/// Clean, responsive, production-ready CRUD with inline edit
class AssessmentAttentionQuestionPage extends StatelessWidget {
  AssessmentAttentionQuestionPage({super.key});

  final SettingsController c = Get.put(SettingsController());

  @override
  Widget build(BuildContext context) {
    return CrudPage(
      title: "Assessment Attention Question",
      items: c.assessmentAttentionQn,
      itemBuilder: (item, i) {
        return EditableTile(
          icon: Icons.help_outline,
          key: ValueKey(i),
          value: item,
          onSave: (val) {
            c.assessmentAttentionQn[i] = val;
            c.assessmentAttentionQn.refresh();
          },
          onDelete: () {
            CustomWidgets().showDeleteDialog(
              context: context,
              text: 'Delete this question permanently?',
              onConfirm: () {
                c.assessmentAttentionQn.removeAt(i);
                c.assessmentAttentionQn.refresh();
              },
            ); },
        );
      },
      onAdd: (val) async {
        c.assessmentAttentionQn.add(val);
        c.assessmentAttentionQn.refresh();
      },
      onUpdate: (i, val) async {},
      onDelete: (i) async {},
    );
  }
}
