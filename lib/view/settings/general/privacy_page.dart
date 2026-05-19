import 'package:albedo_app/controller/settings_controller.dart';
import 'package:albedo_app/widgets/crud_page.dart';
import 'package:albedo_app/widgets/widgets.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class PrivacyPage extends StatelessWidget {
  PrivacyPage({super.key});

  final SettingsController c = Get.find<SettingsController>();

  @override
  Widget build(BuildContext context) {
    final privacyList = <PrivacyItem>[
      PrivacyItem('Student', 'STUDENT', c.studentPrivacyController),
      PrivacyItem('Teacher', 'TEACHER', c.teacherPrivacyController),
      PrivacyItem('Mentor', 'MENTOR', c.mentorPrivacyController),
      PrivacyItem('Coordinator', 'COORDINATOR', c.coordinatorPrivacyController),
      PrivacyItem('Other', 'OTHER', c.otherPrivacyController),
    ].obs;

    return CrudPage(
      title: 'Privacy Policy',
      items: privacyList,
      enableAdd: false,
      itemBuilder: (item, i) {
        return ViewEditTile(
          value: item.title,
          icon: Icons.privacy_tip,
      
          onEdit: () => _openEditDialog(context, item),
        );
      },
      onAdd: (_) async {},
      onUpdate: (_, __) async {},
      onDelete: (_) async {},
    );
  }

  Future<void> _openEditDialog(BuildContext context, PrivacyItem item) async {
    await c.getPrivacyPolicies(item.userType, item.id, item.controller);


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
          hint: 'Edit Privacy Policy',
          isMultiline: true,
          controller: item.controller,
        ),
      ],
      onSubmit: () {
        c.updatePrivacyPolicies(
          id: item.id.value,
          content: item.controller.text,
          userType: item.userType,
        );
      },
    );
  }
}

class PrivacyItem {
  final RxString id = ''.obs;
  final String title;
  final String userType;
  final TextEditingController controller;

  PrivacyItem(this.title, this.userType, this.controller);
}
