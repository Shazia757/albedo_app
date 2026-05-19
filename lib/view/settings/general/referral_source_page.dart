import 'package:albedo_app/model/settings/syllabus_model.dart';
import 'package:albedo_app/widgets/crud_page.dart';
import 'package:albedo_app/widgets/widgets.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:albedo_app/controller/settings_controller.dart';

class ReferralSourcePage extends StatelessWidget {
  ReferralSourcePage({super.key});

  final SettingsController c = Get.find<SettingsController>();

  @override
  Widget build(BuildContext context) {
    return CrudPage(
      title: "Referral Source",
      items: c.referralSources,
      itemBuilder: (item, i) {
        return EditableTile(
          icon: Icons.category,
          key: ValueKey(item.id),
          value: item.name,
          onSave: (val) async {
            final success = await c.updateReferralSource(
              id: item.id,
              referral: val,
            );

            if (success) {
              c.referralSources[i] = c.referralSources[i].copyWith(name: val);

              c.referralSources.refresh();
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
              text: 'Delete this referral source permanently?',
              onConfirm: () async {
                final success = await c.deleteReferralSource(id: item.id);

                if (success) {
                  c.referralSources.removeWhere((e) => e.id == item.id);
                  Get.back();
                }
              },
            );
          },
        );
      },
      onAdd: (val) async {
        final newItem = await c.addReferralSource(val);

        if (newItem != null) {
          c.referralSources.add(newItem);
        }
      },
      onUpdate: (i, val) async {},
      onDelete: (i) async {},
    );
  }
}
