import 'package:albedo_app/controller/mentor_controller.dart';
import 'package:albedo_app/widgets/custom_appbar.dart';
import 'package:albedo_app/widgets/drawer_menu.dart';
import 'package:albedo_app/widgets/responsive.dart';
import 'package:albedo_app/widgets/widgets.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class AddMentorPage extends StatelessWidget {
  const AddMentorPage({super.key});

  @override
  Widget build(BuildContext context) {
    final c = Get.find<MentorController>();
    final isDesktop = Responsive.isDesktop(context);

    return Scaffold(
      appBar: CustomAppBar(),
      body: Row(
        children: [
          if (isDesktop) const DrawerMenu(),
          Expanded(
            child: Center(
              child: ConstrainedBox(
                constraints: const BoxConstraints(maxWidth: 800),
                child: SingleChildScrollView(
                  padding: const EdgeInsets.all(24),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      /// TITLE
                      Text(
                        'Add Mentor',
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

                      const SizedBox(height: 24),

                      /// BASIC INFO
                      CustomWidgets().labelWithAsterisk('Name', required: true),

                      const SizedBox(height: 8),

                      CustomWidgets().dropdownStyledTextField(
                        context: context,
                        hint: 'Enter mentor name',
                        controller: c.nameController,
                      ),

                      const SizedBox(height: 14),

                      CustomWidgets()
                          .labelWithAsterisk('Email', required: true),

                      const SizedBox(height: 8),

                      CustomWidgets().dropdownStyledTextField(
                        context: context,
                        hint: 'Enter email',
                        controller: c.emailController,
                      ),

                      const SizedBox(height: 14),

                      CustomWidgets()
                          .labelWithAsterisk('Phone Number', required: true),

                      const SizedBox(height: 8),

                      CustomWidgets().dropdownStyledTextField(
                        context: context,
                        hint: '+1234567890',
                        controller: c.phoneController,
                        isNumber: true,
                      ),

                      const SizedBox(height: 14),

                      CustomWidgets().labelWithAsterisk('WhatsApp Number'),

                      const SizedBox(height: 8),

                      CustomWidgets().dropdownStyledTextField(
                        context: context,
                        hint: '+1234567890',
                        controller: c.whatsappController,
                        isNumber: true,
                      ),

                      const SizedBox(height: 14),

                      CustomWidgets().labelWithAsterisk('Place'),

                      const SizedBox(height: 8),

                      CustomWidgets().dropdownStyledTextField(
                        context: context,
                        hint: 'Enter place',
                        controller: c.placeController,
                      ),

                      const SizedBox(height: 14),

                      CustomWidgets().labelWithAsterisk('Pincode'),

                      const SizedBox(height: 8),

                      CustomWidgets().dropdownStyledTextField(
                        context: context,
                        hint: 'Enter pincode',
                        controller: c.pincodeController,
                        isNumber: true,
                      ),

                      const SizedBox(height: 14),

                      CustomWidgets().labelWithAsterisk('Address'),

                      const SizedBox(height: 8),

                      CustomWidgets().dropdownStyledTextField(
                        context: context,
                        hint: 'Enter address',
                        controller: c.addressController,
                        isMultiline: true,
                      ),

                      const SizedBox(height: 14),

                      CustomWidgets().labelWithAsterisk('Qualification'),

                      const SizedBox(height: 8),

                      CustomWidgets().dropdownStyledTextField(
                        context: context,
                        hint: 'Enter qualification',
                        controller: c.qualificationController,
                      ),

                      const SizedBox(height: 24),

                      /// EXPERIENCE
                      const Text(
                        'Experience',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                        ),
                      ),

                      const SizedBox(height: 12),

                      Obx(
                        () => Column(
                          children: [
                            ListView.builder(
                              shrinkWrap: true,
                              physics: const NeverScrollableScrollPhysics(),
                              itemCount: c.experiences.length,
                              itemBuilder: (context, index) {
                                final exp = c.experiences[index];

                                return Card(
                                  margin:
                                      const EdgeInsets.symmetric(vertical: 6),
                                  child: Padding(
                                    padding: const EdgeInsets.all(14),
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
                                          children: [
                                            Text(
                                              "Experience ${index + 1}",
                                              style: const TextStyle(
                                                fontWeight: FontWeight.bold,
                                                fontSize: 15,
                                              ),
                                            ),
                                            if (c.experiences.length > 1)
                                              IconButton(
                                                onPressed: () {
                                                  c.removeExperience(index);
                                                },
                                                icon: const Icon(
                                                  Icons.delete_outline,
                                                  color: Colors.red,
                                                ),
                                              ),
                                          ],
                                        ),

                                        const SizedBox(height: 10),

                                        /// COMPANY
                                        CustomWidgets().labelWithAsterisk(
                                          'Company Name',
                                        ),

                                        const SizedBox(height: 6),

                                        CustomWidgets().dropdownStyledTextField(
                                          context: context,
                                          hint: 'Enter company name',
                                          controller: exp.companyController,
                                        ),

                                        const SizedBox(height: 12),

                                        /// YEARS
                                        CustomWidgets()
                                            .labelWithAsterisk('Years'),

                                        const SizedBox(height: 6),

                                        CustomWidgets().dropdownStyledTextField(
                                          context: context,
                                          hint: 'Years',
                                          controller: exp.yearController,
                                          isNumber: true,
                                        ),

                                        const SizedBox(height: 12),

                                        /// MONTHS
                                        CustomWidgets()
                                            .labelWithAsterisk('Months'),

                                        const SizedBox(height: 6),

                                        CustomWidgets().dropdownStyledTextField(
                                          context: context,
                                          hint: 'Months',
                                          controller: exp.monthController,
                                          isNumber: true,
                                        ),
                                      ],
                                    ),
                                  ),
                                );
                              },
                            ),

                            const SizedBox(height: 14),

                            /// ADD EXPERIENCE BUTTON
                            SizedBox(
                              width: double.infinity,
                              child: ElevatedButton.icon(
                                onPressed: () {
                                  c.addExperience();
                                },
                                icon: const Icon(Icons.add),
                                label: const Text('Add Experience'),
                              ),
                            ),
                          ],
                        ),
                      ),

                      const SizedBox(height: 24),

                      /// BANK DETAILS
                      const Text(
                        'Bank Details',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                        ),
                      ),

                      const SizedBox(height: 14),

                      CustomWidgets().labelWithAsterisk('Account Number'),

                      const SizedBox(height: 8),

                      CustomWidgets().dropdownStyledTextField(
                        context: context,
                        hint: 'Enter account number',
                        controller: c.accountNumberController,
                        isNumber: true,
                      ),

                      const SizedBox(height: 14),

                      CustomWidgets().labelWithAsterisk('Account Holder Name'),

                      const SizedBox(height: 8),

                      CustomWidgets().dropdownStyledTextField(
                        context: context,
                        hint: 'Enter account holder name',
                        controller: c.accountHolderNameController,
                      ),

                      const SizedBox(height: 14),

                      CustomWidgets().labelWithAsterisk('UPI ID'),

                      const SizedBox(height: 8),

                      CustomWidgets().dropdownStyledTextField(
                        context: context,
                        hint: 'Enter UPI ID',
                        controller: c.upiIdController,
                      ),

                      const SizedBox(height: 14),

                      CustomWidgets().labelWithAsterisk('Account Type'),

                      const SizedBox(height: 8),

                      CustomWidgets().customDropdownField<String>(
                        context: context,
                        hint: 'Select account type',
                        items: const [
                          'Savings',
                          'Current',
                        ],
                        itemLabel: (item) => item,
                        onChanged: (value) {
                          c.selectedAccountType.value = value;
                        },
                      ),

                      const SizedBox(height: 14),

                      CustomWidgets().labelWithAsterisk('IFSC Code'),

                      const SizedBox(height: 8),

                      CustomWidgets().dropdownStyledTextField(
                        context: context,
                        hint: 'Enter IFSC code',
                        controller: c.ifscController,
                      ),

                      const SizedBox(height: 14),

                      CustomWidgets().labelWithAsterisk('Resume'),

                      const SizedBox(height: 8),

                      CustomWidgets().dropdownStyledTextField(
                        context: context,
                        hint: 'Enter resume URL',
                        controller: c.resumeController,
                      ),

                      const SizedBox(height: 30),

                      /// BUTTONS
                      Row(
                        children: [
                          Expanded(
                            child: OutlinedButton(
                              onPressed: () {
                                Get.back();
                              },
                              child: const Text('Cancel'),
                            ),
                          ),
                          const SizedBox(width: 12),
                           Expanded(
                            child: ElevatedButton.icon(
                              onPressed: () {
                                if (c.validateMentor(context)) {
                                  c.addMentor();
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
                      ),

                      const SizedBox(height: 30),
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
