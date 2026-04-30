import 'package:albedo_app/controller/settings_controller.dart';
import 'package:albedo_app/widgets/crud_page.dart';
import 'package:albedo_app/widgets/widgets.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class CoursePage extends StatelessWidget {
  final c = Get.put(SettingsController());

  CoursePage({super.key});

  @override
  Widget build(BuildContext context) {
    return CrudPage(
      title: "Course",
      items: c.course,
      itemBuilder: (item, i) {
        return EditableTile(
          key: ValueKey(item), // or i if duplicates possible
          value: item,
          icon: Icons.book,

          onSave: (val) {
            c.course[i] = val;
            c.course.refresh();
          },

          onDelete: () {
            CustomWidgets().showDeleteDialog(
              context: context,
              text: 'Delete this course permanently?',
              onConfirm: () {
                c.course.removeAt(i);
                c.course.refresh();
              },
            );
          },
        );
      },
      onAdd: (val) async {
        c.course.add(val);
        c.course.refresh();
      },
      onUpdate: (i, val) async {},
      onDelete: (i) async {},
    );
  }
}
