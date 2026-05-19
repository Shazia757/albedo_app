import 'package:albedo_app/controller/settings_controller.dart';
import 'package:albedo_app/widgets/crud_page.dart';
import 'package:albedo_app/widgets/widgets.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class CoursePage extends StatelessWidget {
  CoursePage({super.key});

  final SettingsController c = Get.find<SettingsController>();

  @override
  Widget build(BuildContext context) {
    return CrudPage(
      title: "Course",
      items: c.course,
      itemBuilder: (item, i) {
        return EditableTile(
          key: ValueKey(item.id),
          value: item.name,
          icon: Icons.book,
          onSave: (val) async {
            final success = await c.updateCourse(
              id: item.id,
              course: val,
            );

            if (success) {
              c.course[i] = c.course[i].copyWith(name: val);
              c.course.refresh();
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
              text: 'Delete this course permanently?',
              onConfirm: () async {
                final success = await c.deleteCourse(id: item.id);

                if (success) {
                  c.course.removeWhere((e) => e.id == item.id);
                  Get.back();
                }
              },
            );
          },
        );
      },
      onAdd: (val) async {
        final newItem = await c.addCourse(val);

        if (newItem != null) {
          c.course.add(newItem);
        }
      },
      onUpdate: (i, val) async {},
      onDelete: (i) async {},
    );
  }
}
