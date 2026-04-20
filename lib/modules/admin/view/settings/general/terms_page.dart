import 'package:albedo_app/controller/settings_controller.dart';
import 'package:albedo_app/widgets/crud_page.dart';
import 'package:albedo_app/widgets/widgets.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class TermsPage extends StatelessWidget {
  final c = Get.put(SettingsController());

  TermsPage({super.key});

  @override
  Widget build(BuildContext context) {
    final termsList = [
      TermsItem("Student", c.studentTermsController),
      TermsItem("Teacher", c.teacherTermsController),
      TermsItem("Mentor", c.mentorTermsController),
      TermsItem("Coordinator", c.coordinatorTermsController),
      TermsItem("Other", c.otherTermsController),
    ];

    return CrudPage<TermsItem>(
      title: "Terms & Conditions",
      items: termsList,
      enableAdd: false, // 🚫 no add

      itemBuilder: (item, i) {
        return ViewEditTile(
          value: item.title,
          icon: Icons.policy,
          onEdit: () {
            CustomWidgets().showCustomDialog(
              context: context,
              title: Text('Edit ${item.title}'),
              formKey: GlobalKey<FormState>(),
              sections: [
                CustomWidgets().dropdownStyledTextField(
                  context: context,
                  hint: 'Edit Terms',
                  isMultiline: true,
                  controller: item.controller,
                )
              ],
              onSubmit: () {
                // optional save logic
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
                Text(item.controller.text.isEmpty
                    ? "No content"
                    : item.controller.text)
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

class TermsItem {
  final String title;
  final TextEditingController controller;

  TermsItem(this.title, this.controller);
}
