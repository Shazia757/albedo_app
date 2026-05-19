import 'package:albedo_app/controller/settings_controller.dart';
import 'package:albedo_app/widgets/crud_page.dart';
import 'package:albedo_app/widgets/widgets.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class RefundPage extends StatelessWidget {
  RefundPage({super.key});

  final SettingsController c = Get.find<SettingsController>();

  @override
  Widget build(BuildContext context) {
    final refundList = <RefundItem>[
      RefundItem('Student', 'STUDENT', c.studentRefundController),
      RefundItem('Teacher', 'TEACHER', c.teacherRefundController),
      RefundItem('Mentor', 'MENTOR', c.mentorRefundController),
      RefundItem('Coordinator', 'COORDINATOR', c.coordinatorRefundController),
      RefundItem('Other', 'OTHER', c.otherRefundController),
    ].obs;

    return CrudPage(
      title: 'Refund Policy',
      items: refundList,
      enableAdd: false,
      itemBuilder: (item, i) {
        return ViewEditTile(
          value: item.title,
          icon: Icons.assignment_return,
      
          onEdit: () => _openEditDialog(context, item),
        );
      },
      onAdd: (_) async {},
      onUpdate: (_, __) async {},
      onDelete: (_) async {},
    );
  }

  Future<void> _openEditDialog(BuildContext context, RefundItem item) async {
    await c.getRefundPolicies(item.userType, item.id, item.controller);

  

    CustomWidgets().showCustomDialog(
      context: context,
      title: Text('Edit ${item.title}'),
      icon: Icons.edit_rounded,
      formKey: GlobalKey<FormState>(),
      submitWidget: Obx(
        () => c.isLoading.value
            ? const SizedBox(
                width: 18,
                height: 18,
                child: CircularProgressIndicator(
                  strokeWidth: 2,
                  color: Colors.white,
                ),
              )
            : const Text(
                'Update',
                style: TextStyle(color: Colors.white),
              ),
      ),
      sections: [
        CustomWidgets().dropdownStyledTextField(
          context: context,
          hint: 'Edit Refund Policy',
          isMultiline: true,
          controller: item.controller,
        ),
      ],
      onSubmit: () {
        c.updateRefundPolicies(
          id: item.id.value,
          content: item.controller.text,
          userType: item.userType,
        );
      },
    );
  }
}

class RefundItem {
  final RxString id = ''.obs;
  final String title;
  final String userType;
  final TextEditingController controller;

  RefundItem(this.title, this.userType, this.controller);
}
