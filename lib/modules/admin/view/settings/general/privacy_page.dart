import 'package:albedo_app/controller/settings_controller.dart';
import 'package:albedo_app/widgets/crud_page.dart';
import 'package:albedo_app/widgets/widgets.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class PrivacyPage extends StatelessWidget {
  final c = Get.put(SettingsController());

  PrivacyPage({super.key});

  @override
  Widget build(BuildContext context) {
    final privacyList = [
      PrivacyItem("Student", c.studentRefundController),
      PrivacyItem("Teacher", c.teacherRefundController),
      PrivacyItem("Mentor", c.mentorRefundController),
      PrivacyItem("Coordinator", c.coordinatorRefundController),
      PrivacyItem("Other", c.otherRefundController),
    ];
    return CrudPage(
      title: "Privacy Policy",
      items: privacyList,
      enableAdd: false,
      itemBuilder: (item, i) {
        return ViewEditTile(
          value: item.title,
          icon: Icons.privacy_tip,
          onEdit: () {
            CustomWidgets().showCustomDialog(
              context: context,
              formKey: GlobalKey<FormState>(),
              title: const Text('Edit Privacy Policy'),
              sections: [
                CustomWidgets().dropdownStyledTextField(
                  context: context,
                  hint: 'Edit Privacy Policy',
                  isMultiline: true,
                  controller: item.controller,
                )
              ],
              onSubmit: () {
                Get.back();
              },
            );
          },
          onTap: () {
            CustomWidgets().showCustomDialog(
              context: context,
              title: Text(item.title),
              formKey: GlobalKey<FormState>(),
              sections: [
                Text(
                  item.controller.text.isEmpty
                      ? "No content"
                      : item.controller.text,
                )
              ],
              onSubmit: () {},
            );
          },
        );
      },
      onAdd: (_) async {},
      onUpdate: (_, __) async {},
      onDelete: (_) async {},
    );
  }
}

class PrivacyItem {
  final String title;
  final TextEditingController controller;

  PrivacyItem(this.title, this.controller);
}
