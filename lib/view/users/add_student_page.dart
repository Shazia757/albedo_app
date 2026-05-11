import 'package:albedo_app/controller/session_controller.dart';
import 'package:albedo_app/controller/student_controller.dart';
import 'package:albedo_app/model/users/advisor_model.dart';
import 'package:albedo_app/model/users/coordinator_model.dart';
import 'package:albedo_app/model/users/mentor_model.dart';
import 'package:albedo_app/model/users/other_users_model.dart';
import 'package:albedo_app/model/users/student_model.dart';
import 'package:albedo_app/model/users/teacher_model.dart';
import 'package:albedo_app/widgets/custom_appbar.dart';
import 'package:albedo_app/widgets/drawer_menu.dart';
import 'package:albedo_app/widgets/responsive.dart';
import 'package:albedo_app/widgets/widgets.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class AddStudentPage extends StatelessWidget {
  const AddStudentPage({
    super.key,
    required this.isEdit,
  });

  final bool isEdit;

  @override
  Widget build(BuildContext context) {
    final c = Get.find<StudentController>();
    final isDesktop = Responsive.isDesktop(context);

    final timezones = [
      'Asia/Kolkata',
      'Asia/Dubai',
      'Asia/Riyadh',
      'Asia/Singapore',
      'Europe/London',
      'America/New_York',
      'America/Los_Angeles',
      'Australia/Sydney',
    ];

    return Scaffold(
      appBar: CustomAppBar(),
      body: Row(
        children: [
          if (isDesktop) const DrawerMenu(),
          Expanded(
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 800),
              child: SingleChildScrollView(
                child: Padding(
                  padding: const EdgeInsets.all(24),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      /// TITLE
                      Text(
                        isEdit ? 'Edit Student' : 'Add Student',
                        style: Theme.of(context).textTheme.titleLarge,
                      ),

                      const SizedBox(height: 20),

                      /// PROFILE
                      Align(
                        alignment: Alignment.center,
                        child: Column(
                          children: [
                            const Text('Profile Photo (Max: 50 MB)'),
                            const SizedBox(height: 10),
                            InkWell(
                              onTap: () {},
                              child: const CircleAvatar(
                                radius: 35,
                                child: ClipOval(
                                  child: SizedBox(
                                    width: 70,
                                    height: 70,
                                    child: Image(
                                      image:
                                          AssetImage('assets/images/logo.png'),
                                      fit: BoxFit.contain,
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),

                      const SizedBox(height: 10),

                      /// NAME
                      CustomWidgets().labelWithAsterisk('Name', required: true),
                      const SizedBox(height: 10),
                      CustomWidgets().dropdownStyledTextField(
                        context: context,
                        hint: 'Enter student name',
                        controller: c.nameController,
                      ),

                      const SizedBox(height: 10),

                      /// EMAIL
                      CustomWidgets()
                          .labelWithAsterisk('Email', required: true),
                      const SizedBox(height: 10),
                      CustomWidgets().dropdownStyledTextField(
                        context: context,
                        hint: 'Enter email address',
                        controller: c.emailController,
                      ),

                      const SizedBox(height: 10),

                      /// PHONE
                      CustomWidgets()
                          .labelWithAsterisk('Phone Number', required: true),
                      CustomWidgets().dropdownStyledTextField(
                        context: context,
                        hint: '+1234567890',
                        controller: c.phoneController,
                        isNumber: true,
                      ),

                      const SizedBox(height: 10),

                      CustomWidgets().labelWithAsterisk('WhatsApp Number'),
                      const SizedBox(height: 10),
                      CustomWidgets().dropdownStyledTextField(
                        context: context,
                        hint: '+1234567890',
                        controller: c.whatsappController,
                        isNumber: true,
                      ),

                      const SizedBox(height: 10),
                      CustomWidgets().labelWithAsterisk('Parent Name'),
                      const SizedBox(height: 10),
                      CustomWidgets().dropdownStyledTextField(
                          context: context,
                          hint: 'Enter parent name',
                          controller: c.parentNameController),
                      const SizedBox(height: 10),
                      CustomWidgets().labelWithAsterisk('Parent Occupation'),
                      const SizedBox(height: 10),
                      CustomWidgets().dropdownStyledTextField(
                          context: context,
                          hint: 'Enter parent occupation',
                          controller: c.parentOccupationController),
                      const SizedBox(height: 10),
                      CustomWidgets().labelWithAsterisk('Gender'),
                      const SizedBox(height: 10),
                      // CustomWidgets().customDropdownField(
                      //   context: context,
                      //   hint: 'Select Gender',
                      //   items: ['Male', 'Female'],
                      //   onChanged: (p0) {},
                      // ),
                      const SizedBox(height: 10),
                      CustomWidgets().labelWithAsterisk('Place'),
                      CustomWidgets().dropdownStyledTextField(
                        context: context,
                        hint: 'Enter place',
                        controller: c.placeController,
                      ),

                      const SizedBox(height: 10),

                      CustomWidgets().labelWithAsterisk('Pincode'),
                      const SizedBox(height: 10),
                      CustomWidgets().dropdownStyledTextField(
                        context: context,
                        hint: 'Enter pincode',
                        controller: c.pincodeController,
                      ),

                      const SizedBox(height: 10),

                      CustomWidgets().labelWithAsterisk('Address'),
                      const SizedBox(height: 10),
                      CustomWidgets().dropdownStyledTextField(
                        context: context,
                        hint: 'Enter address',
                        controller: c.addressController,
                      ),

                      const SizedBox(height: 10),

                      CustomWidgets().labelWithAsterisk('Time Zone'),
                      const SizedBox(height: 10),
                      CustomWidgets().customDropdownField(
                        context: context,
                        hint: 'Select Time Zone',
                        items: timezones,
                        onChanged: (value) => c.selectedTimezone.value = value,
                        itemLabel: (item) => item,
                      ),

                      const SizedBox(height: 10),

                      CustomWidgets().labelWithAsterisk('Mentor'),
                      const SizedBox(height: 10),
                      CustomWidgets().customDropdownField(
                        context: context,
                        hint: 'Select Mentor',
                        items: c.mentorsList,
                        onChanged: (value) => c.selectedMentor.value = value,
                        itemLabel: (item) => item,
                      ),

                      const SizedBox(height: 10),

                      CustomWidgets().labelWithAsterisk('Advisor'),
                      const SizedBox(height: 10),
                      CustomWidgets().customDropdownField(
                        context: context,
                        hint: 'Select Advisor',
                        items: c.advisorsList,
                        onChanged: (value) => c.selectedAdvisor.value = value,
                        itemLabel: (item) => item,
                      ),

                      const SizedBox(height: 10),

                      /// CHECKBOX
                      Row(
                        children: [
                          Obx(
                            () => Checkbox(
                              value: c.isAdmissionFeePaid.value,
                              onChanged: (value) =>
                                  c.isAdmissionFeePaid.value = value ?? false,
                            ),
                          ),
                          const Text('Admission Fee Paid'),
                        ],
                      ),

                      const SizedBox(height: 10),

                      CustomWidgets().labelWithAsterisk('Comment'),
                      const SizedBox(height: 10),
                      CustomWidgets().dropdownStyledTextField(
                        context: context,
                        hint: 'Enter comments',
                        controller: c.commentController,
                          isMultiline: true),
                      const SizedBox(height: 10),
                      CustomWidgets().labelWithAsterisk('Referred By'),
                      Obx(() {
                        final role = c.selectedRole.value;

                        return Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                Expanded(
                                  child: RadioListTile<String>(
                                    title: const Text("Mentor"),
                                    value: "mentor",
                                    groupValue: role,
                                    onChanged: (value) =>
                                        c.selectedRole.value = value!,
                                    dense: true,
                                    contentPadding: EdgeInsets.zero,
                                  ),
                                ),
                                Expanded(
                                  child: RadioListTile<String>(
                                    title: const Text("Advisor"),
                                    value: "advisor",
                                    groupValue: role,
                                    onChanged: (value) =>
                                        c.selectedRole.value = value!,
                                    dense: true,
                                    contentPadding: EdgeInsets.zero,
                                  ),
                                ),
                                Expanded(
                                  child: RadioListTile<String>(
                                    title: const Text("Others"),
                                    value: "others",
                                    groupValue: role,
                                    onChanged: (value) =>
                                        c.selectedRole.value = value!,
                                    dense: true,
                                    contentPadding: EdgeInsets.zero,
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 10),
                            if (role.isNotEmpty) ...[
                              CustomWidgets().labelWithAsterisk(
                                  role[0].toUpperCase() + role.substring(1)),
                              const SizedBox(height: 10),
                              CustomWidgets().customDropdownField<String>(
                                context: context,
                                hint: 'Select referral source',
                                items: const [
                                  'Marketing Team',
                                ],
                                onChanged: (value) {
                                  c.selectedReferralSource.value = value;
                                },
                                itemLabel: (item) => item,
                              ),
                            ]
                          ],
                        );
                      }),
                      const SizedBox(height: 20),

                      /// BUTTONS
                      Row(
                        children: [
                          Expanded(
                            child: OutlinedButton.icon(
                              onPressed: () => Get.back(),
                              icon: const SizedBox.shrink(),
                              label: Text(
                                'Cancel',
                                style: TextStyle(
                                    color:
                                        Theme.of(context).colorScheme.onSurface,
                                    fontSize: 13),
                              ),
                              style: OutlinedButton.styleFrom(
                                backgroundColor:
                                    Theme.of(context).colorScheme.surface,
                                elevation: 0,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(12),
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(width: 10),

                          /// ADD / UPDATE BUTTON
                          Expanded(
                            child: ElevatedButton.icon(
                              onPressed: () {
                                if (c.validateStudent(context)) {
                                  isEdit ? c.updateStudent() : c.addStudent();
                                }
                              },
                              icon: Icon(
                                isEdit ? Icons.save : Icons.add,
                                size: 15,
                                color: Colors.white,
                              ),
                              label: Text(
                                isEdit ? 'Update' : 'Add',
                                style: const TextStyle(
                                    color: Colors.white, fontSize: 13),
                              ),
                              style: ElevatedButton.styleFrom(
                                backgroundColor:
                                    Theme.of(context).colorScheme.primary,
                                elevation: 0,
                                padding:
                                    const EdgeInsets.symmetric(vertical: 12),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(12),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
