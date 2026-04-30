import 'package:albedo_app/widgets/crud_page.dart';
import 'package:albedo_app/widgets/widgets.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:albedo_app/controller/settings_controller.dart';

/// Clean, responsive, production-ready CRUD with inline edit
class StandardPage extends StatelessWidget {
  StandardPage({super.key});

  final SettingsController c = Get.put(SettingsController());

  @override
  Widget build(BuildContext context) {
    return CrudPage(
      title: "Standard",
      items: c.standard,
      itemBuilder: (item, i) {
        return EditableTile(
          icon: Icons.class_,
          key: ValueKey(i),
          value: item,
          onSave: (val) {
            c.standard[i] = val;
            c.standard.refresh();
          },
          onDelete: () {
            CustomWidgets().showDeleteDialog(
              context: context,
              text: 'Delete this course permanently?',
              onConfirm: () {
                c.course.removeAt(i);
                c.course.refresh();
              },
            ); },
        );
      },
      onAdd: (val) async {
        c.standard.add(val);
        c.standard.refresh();
      },
      onUpdate: (i, val) async {},
      onDelete: (i) async {},
    );
  }
}
