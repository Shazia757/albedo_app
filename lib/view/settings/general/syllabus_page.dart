import 'package:albedo_app/widgets/crud_page.dart';
import 'package:albedo_app/widgets/widgets.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:albedo_app/controller/settings_controller.dart';

class SyllabusPage extends StatelessWidget {
  SyllabusPage({super.key});

  final SettingsController c = Get.find<SettingsController>();

  @override
  Widget build(BuildContext context) {
    return CrudPage(
      title: "Syllabus",
      items: c.syllabus,
      itemBuilder: (item, i) {
        return EditableTile(
          icon: Icons.menu_book,
          key: ValueKey(item.id),
          value: item.name,
          onSave: (val) async {
            final success = await c.updateSyllabus(
              id: item.id,
              syllabus: val,
            );

            if (success) {
              c.syllabus[i] = c.syllabus[i].copyWith(name: val);
              c.syllabus.refresh();
            }

          },
          onDelete: () {
            CustomWidgets().showDeleteDialog(
              title: 'Are you sure?',
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
              context: context,
              text: 'Delete this syllabus permanently?',
              onConfirm: () async {
                final success = await c.deleteSyllabus(id: item.id);

                if (success) {
                  c.syllabus.removeWhere((e) => e.id == item.id);
                  Get.back();
                }
              },
            );
          },
        );
      },
      onAdd: (val) async {
        final newItem = await c.addSyllabus(val);

        if (newItem != null) {
          c.syllabus.add(newItem);
        }
      },
      onUpdate: (i, val) async {},
      onDelete: (i) async {},
    );
  }
}
