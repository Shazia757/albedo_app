import 'package:albedo_app/widgets/crud_page.dart';
import 'package:albedo_app/widgets/widgets.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:albedo_app/controller/settings_controller.dart';

class PackagePage extends StatelessWidget {
  PackagePage({super.key});

  final SettingsController c = Get.put(SettingsController());

  @override
  Widget build(BuildContext context) {
    return CrudPage(
      title: "Package",
      items: c.package,
      itemBuilder: (item, i) {
        return EditableTile(
          icon: Icons.inventory,
          key: ValueKey(i),
          value: item,
          onSave: (val) {
            c.package[i] = val;
            c.package.refresh();
          },
          onDelete: () {
            CustomWidgets().showDeleteDialog(
              context: context,
              text: 'Delete this package permanently?',
              onConfirm: () {
                c.course.removeAt(i);
                c.course.refresh();
              },
            );
          },
        );
      },
      onAdd: (val) async {
        c.package.add(val);
        c.package.refresh();
      },
      onUpdate: (i, val) async {},
      onDelete: (i) async {},
    );
  }
}
