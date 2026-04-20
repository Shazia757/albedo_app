import 'package:albedo_app/widgets/crud_page.dart';
import 'package:albedo_app/widgets/widgets.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:albedo_app/controller/settings_controller.dart';

/// Clean, responsive, production-ready CRUD with inline edit
class SupportCategoryPage extends StatelessWidget {
  SupportCategoryPage({super.key});

  final SettingsController c = Get.put(SettingsController());

  @override
  Widget build(BuildContext context) {
    return CrudPage(
      title: "Support Category",
      items: c.supportCategory,
      itemBuilder: (item, i) {
        return EditableTile(
          icon: Icons.headset_mic,
          key: ValueKey(i),
          value: item,
          onSave: (val) {
            c.supportCategory[i] = val;
            c.supportCategory.refresh();
          },
          onDelete: () {
            CustomWidgets().showDeleteDialog(
              context: context,
              text: 'Delete this support category permanently?',
              onConfirm: () {
                c.supportCategory.removeAt(i);
                c.supportCategory.refresh();
              },
            );
          },
        );
      },
      onAdd: (val) async {
        c.supportCategory.add(val);
        c.supportCategory.refresh();
      },
      onUpdate: (i, val) async {},
      onDelete: (i) async {},
    );
  }
}
