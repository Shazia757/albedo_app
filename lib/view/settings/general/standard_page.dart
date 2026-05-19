import 'package:albedo_app/model/settings/syllabus_model.dart';
import 'package:albedo_app/widgets/crud_page.dart';
import 'package:albedo_app/widgets/widgets.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:albedo_app/controller/settings_controller.dart';

class StandardPage extends StatelessWidget {
  StandardPage({super.key});

  final SettingsController c = Get.find<SettingsController>();

  @override
  Widget build(BuildContext context) {
    return CrudPage(
      title: "Standard",
      items: c.standards,
      itemBuilder: (item, i) {
        return EditableTile(
          icon: Icons.class_,
          key: ValueKey(item.id),
          value: item.name,
          onSave: (val) async {
            final success = await c.updateStandard(
              id: item.id,
              standard: val,
            );

            if (success) {
              c.standards[i] = c.standards[i].copyWith(name: val);
              c.standards.refresh();
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
              text: 'Delete this standard permanently?',
              onConfirm: () async {
                final success = await c.deleteStandard(id: item.id);

                if (success) {
                  c.standards.removeWhere((e) => e.id == item.id);
                  Get.back();
                }
              },
            );
          },
        );
      },
      onAdd: (val) async {
        final newItem = await c.addStandard(val);

        if (newItem != null) {
          c.standards.add(newItem);
        }
      },
      onUpdate: (i, val) async {},
      onDelete: (i) async {},
    );
  }
}
