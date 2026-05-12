import 'package:albedo_app/controller/teacher_controller.dart';
import 'package:albedo_app/widgets/custom_appbar.dart';
import 'package:albedo_app/widgets/drawer_menu.dart';
import 'package:albedo_app/widgets/responsive.dart';
import 'package:albedo_app/widgets/widgets.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class AddTeacherPage extends StatelessWidget {
  const AddTeacherPage({
    super.key,
    required this.isEdit,
  });

  final bool isEdit;

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
                  padding: const EdgeInsets.all(24),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        isEdit ? 'Edit Teacher' : 'Add Teacher',
                        style: Theme.of(context).textTheme.titleLarge,
                      ),

                      SizedBox(height: 20),

                      /// PROFILE
                      Align(
                        alignment: Alignment.center,
                        child: Column(
                          children: [
                            Text('Profile Photo (Max: 50 MB)'),
                            SizedBox(height: 10),
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

                      SizedBox(height: 10),

                      /// NAME
                      CustomWidgets().labelWithAsterisk('Name', required: true),
                      SizedBox(height: 10),
                      CustomWidgets().dropdownStyledTextField(
                        context: context,
                        hint: 'Enter teacher name',
                        controller: c.nameController,
                      ),

                      SizedBox(height: 10),

                      /// EMAIL
                      CustomWidgets()
                          .labelWithAsterisk('Email', required: true),
                      SizedBox(height: 10),
                      CustomWidgets().dropdownStyledTextField(
                        context: context,
                        hint: 'Enter email address',
                        controller: c.emailController,
                      ),

                      SizedBox(height: 10),

                      /// PHONE
                      CustomWidgets()
                          .labelWithAsterisk('Phone Number', required: true),
                      CustomWidgets().dropdownStyledTextField(
                        context: context,
                        hint: '+1234567890',
                        controller: c.phoneController,
                        isNumber: true,
                      ),

                      SizedBox(height: 10),

                      /// WHATSAPP
                      CustomWidgets().labelWithAsterisk('WhatsApp Number'),
                      SizedBox(height: 10),
                      CustomWidgets().dropdownStyledTextField(
                        context: context,
                        hint: '+1234567890',
                        controller: c.whatsappController,
                        isNumber: true,
                      ),

                      SizedBox(height: 10),

                      /// GENDER
                      CustomWidgets().labelWithAsterisk('Gender'),
                      SizedBox(height: 10),
                      CustomWidgets().customDropdownField(
                        context: context,
                        hint: 'Select Gender',
                        items: const ['Male', 'Female'],
                        onChanged: (v) {},
                        itemLabel: (item) => item,
                      ),

                      SizedBox(height: 10),

                      /// PLACE
                      CustomWidgets().labelWithAsterisk('Place'),
                      CustomWidgets().dropdownStyledTextField(
                        context: context,
                        hint: 'Enter place',
                        controller: c.placeController,
                      ),

                      SizedBox(height: 10),

                      /// PINCODE
                      CustomWidgets().labelWithAsterisk('Pincode'),
                      CustomWidgets().dropdownStyledTextField(
                        context: context,
                        hint: 'Enter pincode',
                        controller: c.pincodeController,
                      ),

                      SizedBox(height: 10),

                      /// ADDRESS
                      CustomWidgets().labelWithAsterisk('Address'),
                      CustomWidgets().dropdownStyledTextField(
                        context: context,
                        hint: 'Enter address',
                        controller: c.addressController,
                      ),

                      SizedBox(height: 10),

                      /// TIMEZONE
                      CustomWidgets().labelWithAsterisk('Time Zone'),
                      SizedBox(height: 10),
                      CustomWidgets().customDropdownField(
                        context: context,
                        hint: 'Select Time Zone',
                        items: timezones,
                        itemLabel: (item) => item,
                        onChanged: (v) => c.selectedTimezone.value = v,
                      ),

                      SizedBox(height: 10),

                      /// DOB
                      CustomWidgets().labelWithAsterisk('Date of Birth'),
                      CustomWidgets().dropdownStyledTextField(
                        context: context,
                        hint: 'Select date',
                        controller: c.dobController,
                      ),

                      SizedBox(height: 10),

                      /// QUALIFICATION
                      CustomWidgets().labelWithAsterisk('Qualification'),
                      CustomWidgets().dropdownStyledTextField(
                        context: context,
                        hint: 'Enter qualification',
                        controller: c.qualificationController,
                      ),

                      SizedBox(height: 10),

                      /// LANG
                      CustomWidgets().labelWithAsterisk('Preferred Language'),
                      CustomWidgets().customDropdownField(
                        context: context,
                        hint: 'Select language',
                        items: const [
                          'English',
                          'Malayalam',
                          'Hindi',
                          'Tamil',
                          'Arabic'
                        ],
                        itemLabel: (item) => item,
                        onChanged: (value) {
                          c.tutionModeController.text = value;
                        },
                      ),
                      SizedBox(height: 10),
                      Align(
                        alignment: Alignment.centerLeft,
                        child: Text(
                          'Experience',
                          style: Theme.of(context).textTheme.titleSmall,
                        ),
                      ),
                      SizedBox(height: 10),
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
                                              style: Theme.of(context)
                                                  .textTheme
                                                  .titleMedium,
                                            ),

                                            SizedBox(height: 10),

                                            // Company
                                            CustomWidgets().labelWithAsterisk(
                                                'Company Name'),
                                            SizedBox(height: 8),
                                            CustomWidgets()
                                                .dropdownStyledTextField(
                                              context: context,
                                              hint: 'Enter company name',
                                              controller: exp.companyController,
                                            ),

                                            SizedBox(height: 10),

                                            // Years
                                            CustomWidgets()
                                                .labelWithAsterisk('Years'),
                                            SizedBox(height: 8),
                                            CustomWidgets()
                                                .dropdownStyledTextField(
                                              context: context,
                                              hint: 'Years',
                                              controller: exp.yearController,
                                            ),

                                            SizedBox(height: 10),

                                            // Months
                                            CustomWidgets()
                                                .labelWithAsterisk('Months'),
                                            SizedBox(height: 8),
                                            CustomWidgets()
                                                .dropdownStyledTextField(
                                              context: context,
                                              hint: 'Months',
                                              controller: exp.monthController,
                                            ),

                                            SizedBox(height: 10),
                                          ],
                                        ),
                                      ),
                                    );
                                  },
                                ),
                              ),

                              SizedBox(height: 16),

                              // ➕ Add Button at Bottom
                              SizedBox(
                                width: double.infinity,
                                child: ElevatedButton.icon(
                                    onPressed: () {
                                      c.addExperience();
                                    },
                                    icon: const Icon(
                                      Icons.add,
                                      color: Colors.white,
                                    ),
                                    label: Text(
                                      "Add Experience",
                                      style: Theme.of(context)
                                          .textTheme
                                          .bodySmall!
                                          .copyWith(color: Colors.white),
                                    ),
                                    style: ElevatedButton.styleFrom(
                                      backgroundColor: Theme.of(context)
                                          .colorScheme
                                          .primary
                                          .withOpacity(0.8),
                                      elevation: 0,
                                      padding: const EdgeInsets.symmetric(
                                        vertical: 16,
                                        horizontal: 16,
                                      ),
                                    )),
                              ),

                              SizedBox(height: 10),
                              CustomWidgets()
                                  .labelWithAsterisk('Account Number'),
                              SizedBox(height: 10),

                              CustomWidgets().dropdownStyledTextField(
                                  context: context,
                                  hint: 'Enter Account Number',
                                  controller: c.accountNumberController),
                              SizedBox(height: 10),
                              CustomWidgets()
                                  .labelWithAsterisk('Account Holder Name'),
                              SizedBox(height: 10),

                              CustomWidgets().dropdownStyledTextField(
                                  context: context,
                                  hint: 'Enter Account Holder Name',
                                  controller: c.accountHolderNameController),
                              SizedBox(height: 10),
                              CustomWidgets().labelWithAsterisk('UPI ID'),
                              SizedBox(height: 10),

                              CustomWidgets().dropdownStyledTextField(
                                  context: context,
                                  hint: 'Enter UPI ID',
                                  controller: c.upiIdController),
                              SizedBox(height: 10),
                              CustomWidgets().labelWithAsterisk('Account Type'),
                              SizedBox(height: 10),

                              CustomWidgets().customDropdownField(
                                context: context,
                                hint: 'Select Account Type',
                                itemLabel: (item) => item,
                                items: ['Savings', 'Current'],
                                onChanged: (p0) {},
                              ),
                              SizedBox(height: 10),
                              CustomWidgets().labelWithAsterisk('Bank Name'),
                              SizedBox(height: 10),
                              CustomWidgets().customDropdownField<String>(
                                context: context,
                                hint: 'Select bank',
                                items: c.bankBranches.keys.toList(),
                                onChanged: (value) {
                                  c.selectedBank.value = value;
                                },
                                itemLabel: (item) => item,
                              ),
                              SizedBox(height: 10),
                              CustomWidgets().labelWithAsterisk('Branch Name'),
                              SizedBox(height: 10),
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
                              SizedBox(height: 10),
                              CustomWidgets().labelWithAsterisk('IFSC Code'),
                              SizedBox(height: 10),
                              CustomWidgets().dropdownStyledTextField(
                                  context: context,
                                  hint: 'Auto-filled',
                                  controller: c.ifscController),
                              SizedBox(height: 10),
                              CustomWidgets().labelWithAsterisk('Resume'),
                              SizedBox(height: 10),
                              CustomWidgets().dropdownStyledTextField(
                                  context: context,
                                  hint: 'Enter Resume URL',
                                  controller: c.resumeController),
                              SizedBox(height: 10),
                              CustomWidgets()
                                  .labelWithAsterisk('Demo Video (Optional)'),
                              SizedBox(height: 10),
                              CustomWidgets().dropdownStyledTextField(
                                  context: context,
                                  hint: 'Enter Demo URL',
                                  controller: c.demoController),
                              SizedBox(height: 20),
                            ],
                          )),

                      SizedBox(height: 20),

                      /// BUTTONS
                      Row(
                        children: [
                          Expanded(
                            child: OutlinedButton.icon(
                              onPressed: () => Get.back(),
                              icon: const SizedBox.shrink(),
                              label: Text(
                                'Cancel',
                                style: Theme.of(context)
                                    .textTheme
                                    .bodySmall!
                                    .copyWith(
                                        color: Theme.of(context)
                                            .colorScheme
                                            .onSurface),
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
                          SizedBox(width: 10),
                          Expanded(
                            child: ElevatedButton.icon(
                              onPressed: () {
                                if (c.validateTeacher(context)) {
                                  isEdit ? c.updateTeacher() : c.addTeacher();
                                }
                              },
                              icon: const Icon(Icons.add,
                                  size: 15, color: Colors.white),
                              label: Text(
                                'Add',
                                style: Theme.of(context)
                                    .textTheme
                                    .bodySmall!
                                    .copyWith(color: Colors.white),
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
