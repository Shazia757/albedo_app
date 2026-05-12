import 'package:albedo_app/controller/advisor_controller.dart';
import 'package:albedo_app/widgets/custom_appbar.dart';
import 'package:albedo_app/widgets/drawer_menu.dart';
import 'package:albedo_app/widgets/responsive.dart';
import 'package:albedo_app/widgets/widgets.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class AddAdvisorPage extends StatelessWidget {
  const AddAdvisorPage({super.key, this.isEdit = false});

  final bool isEdit;

  @override
  Widget build(BuildContext context) {
    final c = Get.find<AdvisorController>();
    final isDesktop = Responsive.isDesktop(context);

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
                        isEdit ? 'Edit Advisor' : 'Add Advisor',
                        style: Theme.of(context).textTheme.titleLarge,
                      ),

                      SizedBox(height: 20),

                      /// PROFILE PHOTO
                      Align(
                        alignment: Alignment.center,
                        child: Column(
                          children: [
                            Text('Profile Photo (Max: 50 MB)'),
                            SizedBox(height: 10),
                            InkWell(
                              onTap: () {},
                              child: CircleAvatar(
                                radius: 35,
                                child: ClipOval(
                                  child: SizedBox(
                                    width: 70,
                                    height: 70,
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

                      SizedBox(height: 20),

                      /// NAME
                      CustomWidgets().labelWithAsterisk('Name', required: true),
                      SizedBox(height: 10),
                      CustomWidgets().dropdownStyledTextField(
                        context: context,
                        hint: 'Enter advisor name',
                        controller: c.nameController,
                      ),

                      SizedBox(height: 10),

                      /// EMAIL
                      CustomWidgets()
                          .labelWithAsterisk('Email', required: true),
                      SizedBox(height: 10),
                      CustomWidgets().dropdownStyledTextField(
                        context: context,
                        hint: 'Enter email',
                        controller: c.emailController,
                      ),

                      SizedBox(height: 10),

                      /// PHONE
                      CustomWidgets()
                          .labelWithAsterisk('Phone Number', required: true),
                      SizedBox(height: 10),
                      CustomWidgets().dropdownStyledTextField(
                        context: context,
                        hint: 'Enter phone number',
                        controller: c.phoneController,
                        isNumber: true,
                      ),

                      SizedBox(height: 10),

                      /// WHATSAPP
                      CustomWidgets().labelWithAsterisk('WhatsApp Number'),
                      SizedBox(height: 10),
                      CustomWidgets().dropdownStyledTextField(
                        context: context,
                        hint: 'Enter WhatsApp Number',
                        controller: c.whatsappController,
                        isNumber: true,
                      ),

                      SizedBox(height: 10),

                      /// JOINING DATE
                      CustomWidgets().labelWithAsterisk('Joining Date'),
                      SizedBox(height: 10),
                      CustomWidgets().dropdownStyledTextField(
                        context: context,
                        hint: 'Select Date',
                        controller: c.dobController,
                      ),

                      SizedBox(height: 10),

                      /// QUALIFICATION
                      CustomWidgets().labelWithAsterisk('Qualification'),
                      SizedBox(height: 10),
                      CustomWidgets().dropdownStyledTextField(
                        context: context,
                        hint: 'Qualification',
                        controller: c.qualificationController,
                      ),

                      SizedBox(height: 10),

                      /// ADDRESS
                      CustomWidgets().labelWithAsterisk('Address'),
                      SizedBox(height: 10),
                      CustomWidgets().dropdownStyledTextField(
                        context: context,
                        hint: 'Address',
                        controller: c.addressController,
                        isMultiline: true,
                      ),

                      SizedBox(height: 20),

                      /// EXPERIENCE
                      Text(
                        'Experience',
                        style: Theme.of(context).textTheme.titleMedium,
                      ),

                      SizedBox(height: 10),

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
                                  color:
                                      Theme.of(context).colorScheme.onPrimary,
                                  margin:
                                      const EdgeInsets.symmetric(vertical: 8),
                                  elevation: 2,
                                  child: Padding(
                                    padding: const EdgeInsets.all(12),
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
                                                  .titleMedium,
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
                                        SizedBox(height: 10),
                                        CustomWidgets()
                                            .labelWithAsterisk('Company Name'),
                                        SizedBox(height: 8),
                                        CustomWidgets().dropdownStyledTextField(
                                          context: context,
                                          hint: 'Enter company name',
                                          controller: exp.companyController,
                                        ),
                                        SizedBox(height: 10),
                                        CustomWidgets()
                                            .labelWithAsterisk('Years'),
                                        SizedBox(height: 8),
                                        CustomWidgets().dropdownStyledTextField(
                                          context: context,
                                          hint: 'Years',
                                          controller: exp.yearController,
                                          isNumber: true,
                                        ),
                                        SizedBox(height: 10),
                                        CustomWidgets()
                                            .labelWithAsterisk('Months'),
                                        SizedBox(height: 8),
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
                            SizedBox(height: 10),
                            SizedBox(
                              width: double.infinity,
                              child: ElevatedButton.icon(
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
                            ),
                          ],
                        ),
                      ),

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
                                if (c.validateAdvisor(context)) {
                                  isEdit ? c.updateAdvisor() : c.addAdvisor();
                                }
                              },
                              icon: Icon(
                                isEdit ? Icons.save : Icons.add,
                                size: 15,
                                color: Colors.white,
                              ),
                              label: Text(
                                isEdit ? 'Update' : 'Add',
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
