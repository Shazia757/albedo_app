import 'package:albedo_app/controller/settings_controller.dart';
import 'package:albedo_app/widgets/crud_page.dart';
import 'package:albedo_app/widgets/widgets.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class RefundPage extends StatelessWidget {
  final c = Get.put(SettingsController());

  RefundPage({super.key});

  @override
  Widget build(BuildContext context) {
    final refundList = [
      RefundItem("Student", c.studentRefundController),
      RefundItem("Teacher", c.teacherRefundController),
      RefundItem("Mentor", c.mentorRefundController),
      RefundItem("Coordinator", c.coordinatorRefundController),
      RefundItem("Other", c.otherRefundController),
    ];

    return CrudPage(
      title: "Refund Policy",
      items: refundList,
      enableAdd: false, // 🚫 no add button

      itemBuilder: (item, i) {
        return ViewEditTile(
          value: item.title,
          icon: Icons.assignment_return,

          /// ✏️ Edit dialog
          onEdit: () {
            CustomWidgets().showCustomDialog(
              context: context,
              title: Text('Edit ${item.title}'),
              formKey: GlobalKey<FormState>(),
              sections: [
                CustomWidgets().dropdownStyledTextField(
                  context: context,
                  hint: 'Edit Refund',
                  isMultiline: true,
                  controller: item.controller,
                )
              ],
              onSubmit: () {
                Get.back();
              },
            );
          },

          /// 👁️ View dialog
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

class RefundItem {
  final String title;
  final TextEditingController controller;

  RefundItem(this.title, this.controller);
}