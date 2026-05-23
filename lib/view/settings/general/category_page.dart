import 'package:albedo_app/widgets/crud_page.dart';
import 'package:albedo_app/widgets/widgets.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:albedo_app/controller/settings_controller.dart';

/// Clean, responsive, production-ready CRUD with inline edit
class CategoryPage extends StatelessWidget {
  CategoryPage({super.key});

  final SettingsController c = Get.find<SettingsController>();

  @override
  Widget build(BuildContext context) {
    return CrudPage(
      title: "Category",
      items: c.categories,
      itemBuilder: (item, i) {
        return EditableTile(
          icon: Icons.category,
          key: ValueKey(item.id),
          value: item.name,
          onSave: (val) async {
            final success = await c.updateCategory(
              id: item.id,
              category: val,
            );

            if (success) {
              c.categories[i] = c.categories[i].copyWith(name: val);
              c.categories.refresh();
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
              text: 'Delete this category permanently?',
              onConfirm: () async {
                final success = await c.deleteCategory(id: item.id);

                if (success) {
                  c.categories.removeWhere((e) => e.id == item.id);
                  Get.back();
                }
              },
            );
          },
        );
      },
      onAdd: (val) async {
        final newItem = await c.addCategory(val);

        if (newItem != null) {
          c.categories.add(newItem);
        }
      },
      onUpdate: (i, val) async {},
      onDelete: (i) async {},
    );
  }
}
