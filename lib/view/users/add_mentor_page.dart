import 'package:albedo_app/controller/mentor_controller.dart';
import 'package:albedo_app/widgets/custom_appbar.dart';
import 'package:albedo_app/widgets/drawer_menu.dart';
import 'package:albedo_app/widgets/responsive.dart';
import 'package:albedo_app/widgets/widgets.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class AddMentorPage extends StatelessWidget {
  const AddMentorPage({
    super.key,
    this.isEdit = false,
  });

  final bool isEdit;

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
                        isEdit ? 'Edit Mentor' : 'Add Mentor',
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

                      SizedBox(height: 24),

                      /// NAME
                      CustomWidgets().labelWithAsterisk('Name', required: true),
                      SizedBox(height: 8),
                      CustomWidgets().dropdownStyledTextField(
                        context: context,
                        hint: 'Enter mentor name',
                        controller: c.nameController,
                      ),

                      SizedBox(height: 14),

                      CustomWidgets()
                          .labelWithAsterisk('Email', required: true),
                      SizedBox(height: 8),
                      CustomWidgets().dropdownStyledTextField(
                        context: context,
                        hint: 'Enter email',
                        controller: c.emailController,
                      ),

                      SizedBox(height: 14),

                      CustomWidgets()
                          .labelWithAsterisk('Phone Number', required: true),
                      SizedBox(height: 8),
                      CustomWidgets().dropdownStyledTextField(
                        context: context,
                        hint: '+1234567890',
                        controller: c.phoneController,
                        isNumber: true,
                      ),

                      SizedBox(height: 14),

                      CustomWidgets().labelWithAsterisk('WhatsApp Number'),
                      SizedBox(height: 8),
                      CustomWidgets().dropdownStyledTextField(
                        context: context,
                        hint: '+1234567890',
                        controller: c.whatsappController,
                        isNumber: true,
                      ),

                      SizedBox(height: 14),

                      CustomWidgets().labelWithAsterisk('Place'),
                      SizedBox(height: 8),
                      CustomWidgets().dropdownStyledTextField(
                        context: context,
                        hint: 'Enter place',
                        controller: c.placeController,
                      ),

                      SizedBox(height: 14),

                      CustomWidgets().labelWithAsterisk('Pincode'),
                      SizedBox(height: 8),
                      CustomWidgets().dropdownStyledTextField(
                        context: context,
                        hint: 'Enter pincode',
                        controller: c.pincodeController,
                        isNumber: true,
                      ),

                      SizedBox(height: 14),

                      CustomWidgets().labelWithAsterisk('Address'),
                      SizedBox(height: 8),
                      CustomWidgets().dropdownStyledTextField(
                        context: context,
                        hint: 'Enter address',
                        controller: c.addressController,
                        isMultiline: true,
                      ),

                      SizedBox(height: 14),

                      CustomWidgets().labelWithAsterisk('Qualification'),
                      SizedBox(height: 8),
                      CustomWidgets().dropdownStyledTextField(
                        context: context,
                        hint: 'Enter qualification',
                        controller: c.qualificationController,
                      ),

                      SizedBox(height: 24),

                      /// EXPERIENCE
                      Text(
                        'Experience',
                        style: Theme.of(context).textTheme.titleMedium,
                      ),

                      SizedBox(height: 12),

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
                                              style: Theme.of(context)
                                                  .textTheme
                                                  .titleSmall,
                                            ),
                                            if (c.experiences.length > 1)
                                              IconButton(
                                                onPressed: () =>
                                                    c.removeExperience(index),
                                                icon: const Icon(
                                                  Icons.delete_outline,
                                                  color: Colors.red,
                                                ),
                                              ),
                                          ],
                                        ),
                                        SizedBox(height: 10),
                                        CustomWidgets()
                                            .labelWithAsterisk('Company Name'),
                                        SizedBox(height: 6),
                                        CustomWidgets().dropdownStyledTextField(
                                          context: context,
                                          hint: 'Enter company name',
                                          controller: exp.companyController,
                                        ),
                                        SizedBox(height: 12),
                                        CustomWidgets()
                                            .labelWithAsterisk('Years'),
                                        SizedBox(height: 6),
                                        CustomWidgets().dropdownStyledTextField(
                                          context: context,
                                          hint: 'Years',
                                          controller: exp.yearController,
                                          isNumber: true,
                                        ),
                                        SizedBox(height: 12),
                                        CustomWidgets()
                                            .labelWithAsterisk('Months'),
                                        SizedBox(height: 6),
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
                            SizedBox(height: 14),
                            ElevatedButton.icon(
                                onPressed: c.addExperience,
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
                          ],
                        ),
                      ),

                      SizedBox(height: 24),

                      /// BANK DETAILS
                      Text(
                        'Bank Details',
                        style: Theme.of(context).textTheme.titleMedium,
                      ),

                      SizedBox(height: 14),

                      CustomWidgets().labelWithAsterisk('Account Number'),
                      SizedBox(height: 8),
                      CustomWidgets().dropdownStyledTextField(
                        context: context,
                        hint: 'Enter account number',
                        controller: c.accountNumberController,
                        isNumber: true,
                      ),

                      SizedBox(height: 14),

                      CustomWidgets().labelWithAsterisk('Account Holder Name'),
                      SizedBox(height: 8),
                      CustomWidgets().dropdownStyledTextField(
                        context: context,
                        hint: 'Enter name',
                        controller: c.accountHolderNameController,
                      ),

                      SizedBox(height: 14),

                      CustomWidgets().labelWithAsterisk('UPI ID'),
                      SizedBox(height: 8),
                      CustomWidgets().dropdownStyledTextField(
                        context: context,
                        hint: 'Enter UPI ID',
                        controller: c.upiIdController,
                      ),

                      SizedBox(height: 14),

                      CustomWidgets().labelWithAsterisk('Account Type'),
                      SizedBox(height: 8),
                      CustomWidgets().customDropdownField<String>(
                        context: context,
                        hint: 'Select account type',
                        items: const ['Savings', 'Current'],
                        itemLabel: (item) => item,
                        onChanged: (v) => c.selectedAccountType.value = v,
                      ),

                      SizedBox(height: 14),

                      CustomWidgets().labelWithAsterisk('IFSC Code'),
                      SizedBox(height: 8),
                      CustomWidgets().dropdownStyledTextField(
                        context: context,
                        hint: 'Enter IFSC',
                        controller: c.ifscController,
                      ),

                      SizedBox(height: 14),

                      CustomWidgets().labelWithAsterisk('Resume'),
                      SizedBox(height: 8),
                      CustomWidgets().dropdownStyledTextField(
                        context: context,
                        hint: 'Enter resume URL',
                        controller: c.resumeController,
                      ),

                      SizedBox(height: 30),

                      /// BUTTONS
                      Row(
                        children: [
                          Expanded(
                            child: OutlinedButton(
                              onPressed: () => Get.back(),
                              child: Text('Cancel'),
                            ),
                          ),
                          SizedBox(width: 12),
                          Expanded(
                            child: ElevatedButton.icon(
                              onPressed: () {
                                if (c.validateMentor(context)) {
                                  isEdit ? c.updateMentor() : c.addMentor();
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

                      SizedBox(height: 30),
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
