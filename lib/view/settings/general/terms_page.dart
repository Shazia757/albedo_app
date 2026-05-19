import 'package:albedo_app/controller/settings_controller.dart';
import 'package:albedo_app/widgets/crud_page.dart';
import 'package:albedo_app/widgets/widgets.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class TermsPage extends StatelessWidget {
  TermsPage({super.key});

  final SettingsController c = Get.find<SettingsController>();

  @override
  Widget build(BuildContext context) {
    final termsList = <TermsItem>[
      TermsItem('Student', 'STUDENT', c.studentTermsController),
      TermsItem('Teacher', 'TEACHER', c.teacherTermsController),
      TermsItem('Mentor', 'MENTOR', c.mentorTermsController),
      TermsItem('Coordinator', 'COORDINATOR', c.coordinatorTermsController),
      TermsItem('Other', 'OTHER', c.otherTermsController),
    ].obs;

    return CrudPage(
      title: 'Terms & Conditions',
      items: termsList,
      enableAdd: false,
      itemBuilder: (item, i) {
        return ViewEditTile(
          value: item.title,
          icon: Icons.policy,
          onEdit: () => _openEditDialog(context, item),
        );
      },
      onAdd: (_) async {},
      onUpdate: (_, __) async {},
      onDelete: (_) async {},
    );
  }

  Future<void> _openEditDialog(BuildContext context, TermsItem item) async {
    await c.getTerms(item.userType, item.id, item.controller);

  

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
          hint: 'Edit Terms',
          isMultiline: true,
          controller: item.controller,
        ),
      ],
      onSubmit: () {
        c.updateTerms(
          id: item.id.value,
          content: item.controller.text,
          userType: item.userType,
        );
      },
    );
  }
}

class TermsItem {
  final RxString id = ''.obs;
  final String title;
  final String userType;
  final TextEditingController controller;

  TermsItem(this.title, this.userType, this.controller);
}
