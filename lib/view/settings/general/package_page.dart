import 'package:albedo_app/widgets/crud_page.dart';
import 'package:albedo_app/widgets/widgets.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:albedo_app/controller/settings_controller.dart';

class PackagePage extends StatelessWidget {
  PackagePage({super.key});

  final SettingsController c = Get.find<SettingsController>();

  @override
  Widget build(BuildContext context) {
    return CrudPage(
      title: "Package",
      items: c.packageNames,
      itemBuilder: (item, i) {
        return EditableTile(
          icon: Icons.inventory,
          key: ValueKey(item.id),
          value: item.name,
          onSave: (val) async {
            final success = await c.updatePackage(
              id: item.id,
              package: val,
            );

            if (success) {
              c.packageNames[i] = c.packageNames[i].copyWith(name: val);
              c.packageNames.refresh();
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
              text: 'Delete this package permanently?',
              onConfirm: () async {
                final success = await c.deletePackage(id: item.id);

                if (success) {
                  c.packageNames.removeWhere((e) => e.id == item.id);
                  Get.back();
                }
              },
            );
          },
        );
      },
      onAdd: (val) async {
        final newItem = await c.addPackage(val);

        if (newItem != null) {
          c.packageNames.add(newItem);
        }
      },
      onUpdate: (i, val) async {},
      onDelete: (i) async {},
    );
  }
}
