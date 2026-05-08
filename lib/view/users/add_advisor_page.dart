import 'package:albedo_app/controller/advisor_controller.dart';
import 'package:albedo_app/widgets/custom_appbar.dart';
import 'package:albedo_app/widgets/drawer_menu.dart';
import 'package:albedo_app/widgets/responsive.dart';
import 'package:albedo_app/widgets/widgets.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class AddAdvisorPage extends StatelessWidget {
  const AddAdvisorPage({super.key});

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
                  padding: const EdgeInsets.fromLTRB(24, 24, 24, 24),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Add Advisor',
                        style: Theme.of(context).textTheme.titleLarge,
                      ),

                      const SizedBox(height: 20),
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
                          hint: 'Enter advisor name',
                          controller: c.nameController),
                      const SizedBox(height: 10),
                      CustomWidgets()
                          .labelWithAsterisk('Email', required: true),
                      const SizedBox(height: 10),
                      CustomWidgets().dropdownStyledTextField(
                          context: context,
                          hint: 'Enter email',
                          controller: c.emailController),
                      const SizedBox(height: 10),
                      CustomWidgets()
                          .labelWithAsterisk('Phone Number', required: true),
                      CustomWidgets().dropdownStyledTextField(
                          context: context,
                          hint: 'Enter phone number',
                          controller: c.phoneController),
                      const SizedBox(height: 10),
                      CustomWidgets().labelWithAsterisk('WhatsApp Number'),
                      const SizedBox(height: 10),
                      CustomWidgets().dropdownStyledTextField(
                          context: context,
                          hint: 'Enter WhatsApp Number',
                          controller: c.whatsappController),
                      const SizedBox(height: 10),
                      CustomWidgets().labelWithAsterisk('Joining Date'),
                      CustomWidgets().dropdownStyledTextField(
                          context: context,
                          hint: 'Select Date',
                          controller: c.dobController),
                      const SizedBox(height: 10),
                      CustomWidgets().labelWithAsterisk('Qualification'),
                      const SizedBox(height: 10),
                      CustomWidgets().dropdownStyledTextField(
                          context: context,
                          hint: 'Qualification',
                          controller: c.qualificationController),
                      const SizedBox(height: 10),
                      CustomWidgets().labelWithAsterisk('Address'),
                      const SizedBox(height: 10),
                      CustomWidgets().dropdownStyledTextField(
                          context: context,
                          hint: 'Address',
                          controller: c.addressController),
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
                              const SizedBox(height: 20),
                            ],
                          )),

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
                                if (c.validateAdvisor(context)) {
                                  c.addAdvisor();
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
