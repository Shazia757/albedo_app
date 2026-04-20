import 'package:albedo_app/widgets/crud_page.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:albedo_app/controller/settings_controller.dart';

/// Clean, responsive, production-ready CRUD with inline edit
class CategoryPage extends StatelessWidget {
  CategoryPage({super.key});

  final SettingsController c = Get.put(SettingsController());

  @override
  Widget build(BuildContext context) {
    return CrudPage(
      title: "Category",
      items: c.category,
      itemBuilder: (item, i) {
        return EditableTile(
          icon: Icons.category,
          key: ValueKey(i),
          value: item,
          onSave: (val) {
            c.category[i] = val;
            c.category.refresh();
          },
          onDelete: () {
            c.category.removeAt(i);
            c.category.refresh();
          },
        );
      },
      onAdd: (val) async {
        c.category.add(val);
        c.category.refresh();
      },
      onUpdate: (i, val) async {},
      onDelete: (i) async {},
    );
  }
}
