import 'package:albedo_app/controller/teacher_wallet_controller.dart';
import 'package:albedo_app/model/users/teacher_model.dart';
import 'package:albedo_app/model/wallet_model.dart';
import 'package:albedo_app/widgets/custom_appbar.dart';
import 'package:albedo_app/widgets/drawer_menu.dart';
import 'package:albedo_app/widgets/responsive.dart';
import 'package:albedo_app/widgets/widgets.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class AddWalletPage extends StatelessWidget {
  AddWalletPage({
    super.key,
    required this.teacher,
  });

  final Teacher teacher;

  final c = Get.put(TeacherWalletController());

  @override
  Widget build(BuildContext context) {
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
                      Obx(
                        () => Text(
                          c.selectedType.value == 'adjustment'
                              ? 'Salary Adjustment'
                              : 'Withdraw Funds',
                          style: Theme.of(context).textTheme.titleLarge,
                        ),
                      ),
                      const SizedBox(height: 20),

                      /// TYPE SWITCH
                      Obx(
                        () => Row(
                          children: [
                            Expanded(
                              child: _buildTypeCard(
                                context: context,
                                title: "Adjustment",
                                icon: Icons.class_,
                                value: "adjustment",
                                selectedValue: c.selectedType.value,
                                onTap: () =>
                                    c.selectedType.value = "adjustment",
                              ),
                            ),
                            const SizedBox(width: 12),
                            Expanded(
                              child: _buildTypeCard(
                                context: context,
                                title: "Withdraw",
                                icon: Icons.video_call,
                                value: "withdraw",
                                selectedValue: c.selectedType.value,
                                onTap: () => c.selectedType.value = "withdraw",
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 16),

                      /// CONTENT
                      Obx(() {
                        if (c.selectedType.value == 'adjustment') {
                          return _buildSalaryAdjustmentForm(context, c);
                        } else {
                          return _buildWithdrawForm(context, c);
                        }
                      }),

                      const SizedBox(height: 20),

                      /// SUBMIT BUTTON
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

  /// ---------------- SALARY ADJUSTMENT FORM ----------------
  Widget _buildSalaryAdjustmentForm(
      BuildContext context, TeacherWalletController c) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        CustomWidgets().labelWithAsterisk('Component Type', required: true),
        const SizedBox(height: 10),
        CustomWidgets().customDropdownField(
          context: context,
          hint: 'Select Type',
          items: c.componentType,
          value: c.selectedComponent.value,
          itemLabel: (s) => s,
          onChanged: (student) {},
        ),
        const SizedBox(height: 10),
        CustomWidgets().labelWithAsterisk('Month', required: true),
        const SizedBox(height: 10),
        CustomWidgets().customDropdownField<String>(
          context: context,
          hint: 'Select Month',
          items: TeacherWalletController.months,
          value: c.adjSelectedMonth.value,
          initialValue: c.initialMonth.value,
          itemLabel: (month) => month,
          onChanged: (value) {
            if (value != null) {
              c.adjSelectedMonth.value = value;
            }
          },
        ),
        const SizedBox(height: 10),
        CustomWidgets().labelWithAsterisk('Year', required: true),
        const SizedBox(height: 10),
        CustomWidgets().customDropdownField<String>(
          context: context,
          hint: 'Select Year',
          items: c.years,
          value: c.adjSelectedYear.value,
          initialValue: c.initialYear.value,
          itemLabel: (year) => year,
          onChanged: (value) {
            if (value != null) {
              c.adjSelectedYear.value = value;
            }
          },
        ),
        const SizedBox(height: 10),
        CustomWidgets().labelWithAsterisk('Amount (₹)', required: true),
        const SizedBox(height: 10),
        CustomWidgets().dropdownStyledTextField(
            context: context,
            hint: 'Enter adjustment amount',
            controller: c.salaryController,
            isNumber: true),
        const SizedBox(height: 10),
        CustomWidgets().labelWithAsterisk('Description (optional)'),
        const SizedBox(height: 10),
        CustomWidgets().dropdownStyledTextField(
          context: context,
          hint: 'Performance bonus, commission, etc.',
          controller: c.descriptionController,
        ),
        const SizedBox(height: 10),
        Row(
          children: [
            Expanded(
              child: OutlinedButton.icon(
                onPressed: () => Get.back(),
                icon: const SizedBox.shrink(),
                label: Text(
                  'Cancel',
                  style: TextStyle(
                      color: Theme.of(context).colorScheme.onSurface,
                      fontSize: 13),
                ),
                style: OutlinedButton.styleFrom(
                  backgroundColor: Theme.of(context).colorScheme.surface,
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
                  if (c.validateAdjustment(context)) {
                    c.adjustSalary();
                  }
                },
                label: const Text(
                  'Adjust Salary',
                  style: TextStyle(color: Colors.white, fontSize: 13),
                ),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Theme.of(context).colorScheme.primary,
                  elevation: 0,
                  padding: const EdgeInsets.symmetric(vertical: 12),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
              ),
            ),
          ],
        )
      ],
    );
  }

  /// ---------------- MEET FORM ----------------
  Widget _buildWithdrawForm(
    BuildContext context,
    TeacherWalletController c,
  ) {
    final cs = Theme.of(context).colorScheme;

    final double currentBalance = teacher.balance ?? 0;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        /// BALANCE CARD
        Container(
          width: double.infinity,
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: cs.primary.withOpacity(.08),
            borderRadius: BorderRadius.circular(14),
            border: Border.all(
              color: cs.primary.withOpacity(.2),
            ),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Current Balance',
                style: TextStyle(
                  fontSize: 13,
                  color: cs.onSurface.withOpacity(.7),
                ),
              ),
              const SizedBox(height: 6),
              Text(
                '₹${currentBalance.toStringAsFixed(0)}',
                style: const TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
        ),

        const SizedBox(height: 16),

        CustomWidgets().labelWithAsterisk(
          'Amount (₹)',
          required: true,
        ),

        const SizedBox(height: 10),

        CustomWidgets().dropdownStyledTextField(
          context: context,
          hint: 'Enter amount (max. ₹${currentBalance.toStringAsFixed(0)})',
          controller: c.salaryController,
          isNumber: true,
          onTap: () {
            final enteredAmount = double.tryParse(c.salaryController.text) ?? 0;

            if (enteredAmount > currentBalance) {
              c.salaryController.text = currentBalance.toStringAsFixed(0);

              c.salaryController.selection = TextSelection.fromPosition(
                TextPosition(
                  offset: c.salaryController.text.length,
                ),
              );
            }
          },
        ),
        const SizedBox(height: 10),

        CustomWidgets().labelWithAsterisk(
          'Description (optional)',
        ),

        const SizedBox(height: 10),

        CustomWidgets().dropdownStyledTextField(
          context: context,
          hint: 'Performance bonus, commission, etc.',
          controller: c.descriptionController,
        ),

        const SizedBox(height: 10),

        CustomWidgets().labelWithAsterisk('Attachment'),

        const SizedBox(height: 8),

        CustomWidgets().attachmentStyledField(
          context: context,
          label: "Attachment",
          hint: "Choose a file",
          fileName: c.selectedFile,
          onTap: () {},
          onClear: () {},
        ),

        const SizedBox(height: 10),

        Row(
          children: [
            Expanded(
              child: OutlinedButton.icon(
                onPressed: () => Get.back(),
                icon: const SizedBox.shrink(),
                label: Text(
                  'Cancel',
                  style: TextStyle(
                    color: cs.onSurface,
                    fontSize: 13,
                  ),
                ),
                style: OutlinedButton.styleFrom(
                  backgroundColor: cs.surface,
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
                  if (c.validateWithdrawal(context)) {
                    c.finalizeWithdrawal();
                  }
                },
                label: const Text(
                  'Finalize Withdrawal',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 13,
                  ),
                ),
                style: ElevatedButton.styleFrom(
                  backgroundColor: cs.primary,
                  elevation: 0,
                  padding: const EdgeInsets.symmetric(
                    vertical: 12,
                  ),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
              ),
            ),
          ],
        )
      ],
    );
  }

  Widget _buildTypeCard({
    required BuildContext context,
    required String title,
    required IconData icon,
    required String value,
    required String selectedValue,
    required VoidCallback onTap,
  }) {
    final isSelected = value == selectedValue;
    final theme = Theme.of(context);
    final textTheme = theme.textTheme;

    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(12),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        decoration: BoxDecoration(
          color: isSelected
              ? theme.colorScheme.primary.withOpacity(0.1)
              : theme.colorScheme.onPrimary.withOpacity(0.8),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: isSelected
                ? theme.colorScheme.primary
                : theme.colorScheme.outline.withOpacity(0.3),
            width: isSelected ? 1.5 : 1,
          ),
        ),
        child: Row(
          children: [
            Icon(
              icon,
              size: 24,
              color: isSelected
                  ? theme.colorScheme.primary
                  : theme.colorScheme.onSurface.withOpacity(0.6),
            ),
            const SizedBox(width: 10),

            /// TEXT
            Expanded(
              child: Text(
                title,
                style: textTheme.bodyMedium?.copyWith(
                  fontWeight: FontWeight.w500,
                  color: isSelected
                      ? theme.colorScheme.primary
                      : theme.colorScheme.onSurface,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
