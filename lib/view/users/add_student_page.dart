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
  const AddStudentPage({super.key});

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
                  padding: const EdgeInsets.fromLTRB(24, 24, 24, 24),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Add Student',
                        style: Theme.of(context).textTheme.titleLarge,
                      ),
                      const SizedBox(height: 10),
                      Align(
                        alignment: Alignment.center,

                        child: Column(
                          children: [
                            Text('Profile Photo (Max: 50 MB)'),
                            const SizedBox(height: 10),
                            InkWell(
                              onTap: () {},
                              child: CircleAvatar(
                                radius: 35,
                                child: ClipOval(
                                  child: SizedBox(
                                    width: 60,
                                    height: 60,
                                    child: Image.asset(
                                      'assets/images/logo.png',
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
                      CustomWidgets().labelWithAsterisk('Name', required: true),
                      const SizedBox(height: 10),
                      CustomWidgets().dropdownStyledTextField(
                          context: context,
                          hint: 'Enter student name',
                          controller: c.nameController),
                      const SizedBox(height: 10),
                      CustomWidgets()
                          .labelWithAsterisk('Email', required: true),
                      const SizedBox(height: 10),
                      CustomWidgets().dropdownStyledTextField(
                          context: context,
                          hint: 'Enter email address',
                          controller: c.emailController),
                      const SizedBox(height: 10),
                      CustomWidgets()
                          .labelWithAsterisk('Phone Number', required: true),
                      CustomWidgets().dropdownStyledTextField(
                          context: context,
                          hint: '+1234567890',
                          controller: c.phoneController,
                          isNumber: true),
                      const SizedBox(height: 10),
                      CustomWidgets().labelWithAsterisk('WhatsApp Number'),
                      const SizedBox(height: 10),
                      CustomWidgets().dropdownStyledTextField(
                          context: context,
                          hint: '+1234567890',
                          controller: c.whatsappController,
                          isNumber: true),
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
                          controller: c.placeController),
                      const SizedBox(height: 10),
                      CustomWidgets().labelWithAsterisk('Pincode'),
                      const SizedBox(height: 10),
                      CustomWidgets().dropdownStyledTextField(
                          context: context,
                          hint: 'Enter pincode/postal code',
                          controller: c.pincodeController),
                      const SizedBox(height: 10),
                      CustomWidgets().labelWithAsterisk('Address'),
                      const SizedBox(height: 10),
                      CustomWidgets().dropdownStyledTextField(
                          context: context,
                          hint: 'Enter address',
                          controller: c.addressController),
                      const SizedBox(height: 10),
                      CustomWidgets().labelWithAsterisk('Time Zone'),
                      const SizedBox(height: 10),
                      CustomWidgets().customDropdownField(
                        context: context,
                        hint: 'Select Time Zone',
                        items: timezones,
                        onChanged: (p0) {
                          c.selectedTimezone.value = p0;
                        },
                        itemLabel: (item) => item,
                      ),
                      const SizedBox(height: 10),
                      CustomWidgets().labelWithAsterisk('Mentor'),
                      const SizedBox(height: 10),
                      CustomWidgets().customDropdownField(
                        context: context,
                        hint: 'Select Mentor',
                        items: c.mentorsList,
                        onChanged: (p0) {
                          c.selectedMentor.value = p0;
                        },
                        itemLabel: (item) => item,
                      ),
                      const SizedBox(height: 10),
                      CustomWidgets().labelWithAsterisk('Advisor'),
                      const SizedBox(height: 10),
                      CustomWidgets().customDropdownField(
                        context: context,
                        hint: 'Select Advisor',
                        items: c.advisorsList,
                        onChanged: (p0) {
                          c.selectedAdvisor.value = p0;
                        },
                        itemLabel: (item) => item,
                      ),
                      const SizedBox(height: 10),
                      Row(
                        children: [
                          Obx(
                            () => Checkbox(
                              value: c.isAdmissionFeePaid.value,
                              onChanged: (value) => c.isAdmissionFeePaid.value =
                                  !c.isAdmissionFeePaid.value,
                            ),
                          ),
                          Text('Admission Fee Paid'),
                        ],
                      ),
                      const SizedBox(height: 10),
                      CustomWidgets().labelWithAsterisk('Comment'),
                      const SizedBox(height: 10),
                      CustomWidgets().dropdownStyledTextField(
                          context: context,
                          hint: 'Enter any additional comments',
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

                      /// SUBMIT BUTTON
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
                          Expanded(
                            child: ElevatedButton.icon(
                              onPressed: () {
                                if (c.validateStudent(context)) {
                                  c.addStudent();
                                }
                              },
                              icon: const Icon(Icons.add,
                                  size: 15, color: Colors.white),
                              label: const Text(
                                'Add',
                                style: TextStyle(
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
                      )
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

