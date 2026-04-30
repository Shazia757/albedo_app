import 'package:albedo_app/widgets/crud_page.dart';
import 'package:albedo_app/widgets/widgets.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:albedo_app/controller/settings_controller.dart';

/// Clean, responsive, production-ready CRUD with inline edit
class ReferralSourcePage extends StatelessWidget {
  ReferralSourcePage({super.key});

  final SettingsController c = Get.put(SettingsController());

  @override
  Widget build(BuildContext context) {
    return CrudPage(
      title: "Referral Source",
      items: c.referralSource,
      itemBuilder: (item, i) {
        return EditableTile(
          icon: Icons.category,
          key: ValueKey(i),
          value: item,
          onSave: (val) {
            c.referralSource[i] = val;
            c.referralSource.refresh();
          },
          onDelete: () {
           CustomWidgets().showDeleteDialog(
              context: context,
              text: 'Delete this referral source permanently?',
              onConfirm: () {
                c.referralSource.removeAt(i);
                c.referralSource.refresh();
              },
            );
          },
        );
      },
      onAdd: (val) async {
        c.referralSource.add(val);
        c.referralSource.refresh();
      },
      onUpdate: (i, val) async {},
      onDelete: (i) async {},
    );
  }
}
