import 'package:albedo_app/controller/session_controller.dart';
import 'package:albedo_app/controller/teacher_controller.dart';
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

class AddTeacherPage extends StatelessWidget {
  const AddTeacherPage({super.key});

  @override
  Widget build(BuildContext context) {
    final c = Get.find<TeacherController>();
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
                        'Add Teacher',
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
                          hint: 'Enter teacher name',
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
                      const SizedBox(height: 10),
                      CustomWidgets().labelWithAsterisk('Gender'),
                      const SizedBox(height: 10),
                      CustomWidgets().customDropdownField(
                        context: context,
                        hint: 'Select Gender',
                        items: ['Male', 'Female'],
                        onChanged: (p0) {},
                        itemLabel: (item) => item,
                      ),
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
                        itemLabel: (item) => item,
                        hint: 'Select Time Zone',
                        items: timezones,
                        onChanged: (p0) {
                          c.selectedTimezone.value = p0;
                        },
                      ),
                      const SizedBox(height: 10),
                      CustomWidgets().labelWithAsterisk('Date of Birth'),
                      CustomWidgets().dropdownStyledTextField(
                          context: context,
                          hint: 'Select date',
                          controller: c.dobController),
                      const SizedBox(height: 10),
                      CustomWidgets().labelWithAsterisk('Qualification'),
                      CustomWidgets().dropdownStyledTextField(
                          context: context,
                          hint: 'Enter qualification',
                          controller: c.qualificationController),
                      const SizedBox(height: 10),
                      CustomWidgets().labelWithAsterisk('Preferred Language',
                          required: true),
                      CustomWidgets().customDropdownField(
                        context: context,
                        hint: 'Select Languages',
                        items: const [
                          'English',
                          'Malayalam',
                          'Hindi',
                          'Tamil',
                          'Arabic',
                        ],
                        itemLabel: (item) => item,
                        onChanged: (value) {
                          c.prefLangController.text = value;
                        },
                      ),

                      const SizedBox(height: 10),
                      CustomWidgets()
                          .labelWithAsterisk('Tuition Mode', required: true),
                      CustomWidgets().customDropdownField(
                        context: context,
                        hint: 'Select Mode',
                        items: const [
                          'Online Tution',
                          'Home Tution',
                        ],
                        itemLabel: (item) => item,
                        onChanged: (value) {
                          c.tutionModeController.text = value;
                        },
                      ),
                      const SizedBox(height: 10),
                      Align(
                        alignment: Alignment.centerLeft,
                        child: Text(
                          'Experience',
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                      ),
                      const SizedBox(height: 10),
                      Obx(() => Column(
                            children: [
                              Column(
                                children: List.generate(
                                  c.experiences.length,
                                  (index) {
                                    final exp = c.experiences[index];

                                    return Card(
                                      margin: const EdgeInsets.symmetric(
                                          vertical: 8),
                                      elevation: 2,
                                      child: Padding(
                                        padding: const EdgeInsets.all(12),
                                        child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            // Title
                                            Text(
                                              "Experience ${index + 1}",
                                              style: TextStyle(
                                                fontWeight: FontWeight.bold,
                                                fontSize: 16,
                                              ),
                                            ),

                                            const SizedBox(height: 10),

                                            // Company
                                            CustomWidgets().labelWithAsterisk(
                                                'Company Name'),
                                            const SizedBox(height: 8),
                                            CustomWidgets()
                                                .dropdownStyledTextField(
                                              context: context,
                                              hint: 'Enter company name',
                                              controller: exp.companyController,
                                            ),

                                            const SizedBox(height: 10),

                                            // Years
                                            CustomWidgets()
                                                .labelWithAsterisk('Years'),
                                            const SizedBox(height: 8),
                                            CustomWidgets()
                                                .dropdownStyledTextField(
                                              context: context,
                                              hint: 'Years',
                                              controller: exp.yearController,
                                            ),

                                            const SizedBox(height: 10),

                                            // Months
                                            CustomWidgets()
                                                .labelWithAsterisk('Months'),
                                            const SizedBox(height: 8),
                                            CustomWidgets()
                                                .dropdownStyledTextField(
                                              context: context,
                                              hint: 'Months',
                                              controller: exp.monthController,
                                            ),

                                            const SizedBox(height: 10),
                                          ],
                                        ),
                                      ),
                                    );
                                  },
                                ),
                              ),

                              const SizedBox(height: 16),

                              // ➕ Add Button at Bottom
                              SizedBox(
                                width: double.infinity,
                                child: ElevatedButton.icon(
                                  onPressed: () {
                                    c.addExperience();
                                  },
                                  icon: Icon(Icons.add),
                                  label: Text("Add Experience"),
                                ),
                              ),

                              const SizedBox(height: 10),
                              CustomWidgets()
                                  .labelWithAsterisk('Account Number'),
                              const SizedBox(height: 10),

                              CustomWidgets().dropdownStyledTextField(
                                  context: context,
                                  hint: 'Enter Account Number',
                                  controller: c.accountNumberController),
                              const SizedBox(height: 10),
                              CustomWidgets()
                                  .labelWithAsterisk('Account Holder Name'),
                              const SizedBox(height: 10),

                              CustomWidgets().dropdownStyledTextField(
                                  context: context,
                                  hint: 'Enter Account Holder Name',
                                  controller: c.accountHolderNameController),
                              const SizedBox(height: 10),
                              CustomWidgets().labelWithAsterisk('UPI ID'),
                              const SizedBox(height: 10),

                              CustomWidgets().dropdownStyledTextField(
                                  context: context,
                                  hint: 'Enter UPI ID',
                                  controller: c.upiIdController),
                              const SizedBox(height: 10),
                              CustomWidgets().labelWithAsterisk('Account Type'),
                              const SizedBox(height: 10),

                              CustomWidgets().customDropdownField(
                                context: context,
                                hint: 'Select Account Type',
                                itemLabel: (item) => item,
                                items: ['Savings', 'Current'],
                                onChanged: (p0) {},
                              ),
                              const SizedBox(height: 10),
                              CustomWidgets().labelWithAsterisk('Bank Name'),
                              const SizedBox(height: 10),
                              CustomWidgets().customDropdownField<String>(
                                context: context,
                                hint: 'Select bank',
                                items: c.bankBranches.keys.toList(),
                                onChanged: (value) {
                                  c.selectedBank.value = value;
                                },
                                itemLabel: (item) => item,
                              ),
                              const SizedBox(height: 10),
                              CustomWidgets().labelWithAsterisk('Branch Name'),
                              const SizedBox(height: 10),
                              Obx(
                                () =>
                                    CustomWidgets().customDropdownField<String>(
                                  context: context,
                                  hint: 'Select branch',
                                  items: c.bankBranches[c.selectedBank.value] ??
                                      [],
                                  onChanged: (value) {
                                    c.selectedBranch.value = value;
                                  },
                                  itemLabel: (item) => item,
                                ),
                              ),
                              const SizedBox(height: 10),
                              CustomWidgets().labelWithAsterisk('IFSC Code'),
                              const SizedBox(height: 10),
                              CustomWidgets().dropdownStyledTextField(
                                  context: context,
                                  hint: 'Auto-filled',
                                  controller: c.ifscController),
                              const SizedBox(height: 10),
                              CustomWidgets().labelWithAsterisk('Resume'),
                              const SizedBox(height: 10),
                              CustomWidgets().dropdownStyledTextField(
                                  context: context,
                                  hint: 'Enter Resume URL',
                                  controller: c.resumeController),
                              const SizedBox(height: 10),
                              CustomWidgets()
                                  .labelWithAsterisk('Demo Video (Optional)'),
                              const SizedBox(height: 10),
                              CustomWidgets().dropdownStyledTextField(
                                  context: context,
                                  hint: 'Enter Demo URL',
                                  controller: c.demoController),
                              const SizedBox(height: 20),
                            ],
                          )),

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
                                if (c.validateTeacher(context)) {
                                  c.addTeacher();
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

class ExperienceFormData {
  final companyController = TextEditingController();
  final yearController = TextEditingController();
  final monthController = TextEditingController();

  void dispose() {
    companyController.dispose();
    yearController.dispose();
    monthController.dispose();
  }
}
