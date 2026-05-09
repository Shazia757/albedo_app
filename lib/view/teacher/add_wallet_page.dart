import 'package:albedo_app/controller/teacher_wallet_controller.dart';
import 'package:albedo_app/model/users/coordinator_model.dart';
import 'package:albedo_app/model/users/mentor_model.dart';
import 'package:albedo_app/model/users/teacher_model.dart';
import 'package:albedo_app/widgets/custom_appbar.dart';
import 'package:albedo_app/widgets/drawer_menu.dart';
import 'package:albedo_app/widgets/responsive.dart';
import 'package:albedo_app/widgets/widgets.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class AddWalletPage extends StatelessWidget {
  AddWalletPage({
    super.key,
    this.teacher,
    this.mentor,
    this.coordinator,
    this.showAdjustment = true,
  });

  final Teacher? teacher;
  final Mentor? mentor;
  final Coordinator? coordinator;

  final bool showAdjustment;

  final c = Get.put(TeacherWalletController());

  @override
  Widget build(BuildContext context) {
    final isDesktop = Responsive.isDesktop(context);

    /// reusable balance
    final double currentBalance =
        teacher?.balance ?? mentor?.balance ?? coordinator?.balance ?? 0;

    final bool isMentor = mentor != null;
    final bool isCoordinator = coordinator != null;

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
                      showAdjustment
                          ? Obx(
                              () => Text(
                                c.selectedType.value == 'adjustment'
                                    ? 'Salary Adjustment'
                                    : 'Withdraw Funds',
                                style: Theme.of(context).textTheme.titleLarge,
                              ),
                            )
                          : Text(
                              'Withdraw Funds',
                              style: Theme.of(context).textTheme.titleLarge,
                            ),

                      const SizedBox(height: 20),

                      /// SHOW SWITCH ONLY FOR TEACHERS
                      if (showAdjustment)
                        Obx(
                          () => Row(
                            children: [
                              Expanded(
                                child: _buildTypeCard(
                                  context: context,
                                  title: "Adjustment",
                                  icon: Icons.tune,
                                  value: "adjustment",
                                  selectedValue: c.selectedType.value,
                                  onTap: () {
                                    c.selectedType.value = "adjustment";
                                  },
                                ),
                              ),
                              const SizedBox(width: 12),
                              Expanded(
                                child: _buildTypeCard(
                                  context: context,
                                  title: "Withdraw",
                                  icon: Icons.account_balance_wallet,
                                  value: "withdraw",
                                  selectedValue: c.selectedType.value,
                                  onTap: () {
                                    c.selectedType.value = "withdraw";
                                  },
                                ),
                              ),
                            ],
                          ),
                        ),

                      if (showAdjustment) const SizedBox(height: 16),

                      /// CONTENT
                      showAdjustment
                          ? Obx(() {
                              if (c.selectedType.value == 'adjustment') {
                                return _buildSalaryAdjustmentForm(
                                  context,
                                  c,
                                  isMentor,
                                );
                              }

                              return _buildWithdrawForm(
                                context,
                                c,
                                currentBalance,
                                isMentor,
                                isCoordinator,
                              );
                            })
                          : _buildWithdrawForm(
                              context,
                              c,
                              currentBalance,
                              isMentor,
                              isCoordinator,
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

  /// ---------------- ADJUSTMENT FORM ----------------

  Widget _buildSalaryAdjustmentForm(
    BuildContext context,
    TeacherWalletController c,
    bool isMentor,
  ) {
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
        ),
      ],
    );
  }

  /// ---------------- WITHDRAW FORM ----------------

  Widget _buildWithdrawForm(
    BuildContext context,
    TeacherWalletController c,
    double currentBalance,
    bool isMentor,
    bool isCoordinator,
  ) {
    final cs = Theme.of(context).colorScheme;

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
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Current Balance',
                style: TextStyle(
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

        /// amount field
        CustomWidgets().labelWithAsterisk(
          'Amount (₹)',
          required: true,
        ),

        const SizedBox(height: 10),

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
          hint: 'Need cash, personal expense, etc.',
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

        const SizedBox(height: 20),

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

    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(12),
      child: Container(
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: isSelected
                ? theme.colorScheme.primary
                : theme.colorScheme.outline,
          ),
        ),
        child: Row(
          children: [
            Icon(icon),
            const SizedBox(width: 10),
            Expanded(
              child: Text(title),
            ),
          ],
        ),
      ),
    );
  }
}
