import 'package:albedo_app/controller/teacher_wallet_controller.dart';
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
    this.showAdjustment = true,
  });

  final Teacher? teacher;
  final Mentor? mentor;

  /// false for mentors
  final bool showAdjustment;

  final c = Get.put(TeacherWalletController());

  @override
  Widget build(BuildContext context) {
    final isDesktop = Responsive.isDesktop(context);

    /// reusable balance
    final double currentBalance =
        teacher?.balance ?? mentor?.balance ?? 0;

    final bool isMentor = mentor != null;

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
                      Obx(
                        () => Text(
                          showAdjustment
                              ? (c.selectedType.value == 'adjustment'
                                  ? 'Salary Adjustment'
                                  : 'Withdraw Funds')
                              : 'Withdraw Funds',
                          style: Theme.of(context).textTheme.titleLarge,
                        ),
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

                      if (showAdjustment)
                        const SizedBox(height: 16),

                      /// CONTENT
                      Obx(() {
                        /// Mentor → always withdraw
                        if (!showAdjustment) {
                          return _buildWithdrawForm(
                            context,
                            c,
                            currentBalance,
                            isMentor,
                          );
                        }

                        /// Teacher
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
                        );
                      }),
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

        /// your existing adjustment form

        Row(
          children: [
            Expanded(
              child: OutlinedButton(
                onPressed: () => Get.back(),
                child: const Text('Cancel'),
              ),
            ),

            const SizedBox(width: 10),

            Expanded(
              child: ElevatedButton(
                onPressed: () {
                  if (c.validateAdjustment(context)) {

                    /// TEACHER
                    if (!isMentor) {
                      c.adjustSalary();
                    }
                  }
                },
                child: const Text('Adjust Salary'),
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

        CustomWidgets().dropdownStyledTextField(
          context: context,
          hint: 'Enter amount',
          controller: c.salaryController,
          isNumber: true,
        ),

        const SizedBox(height: 20),

        Row(
          children: [
            Expanded(
              child: OutlinedButton(
                onPressed: () => Get.back(),
                child: const Text('Cancel'),
              ),
            ),

            const SizedBox(width: 10),

            Expanded(
              child: ElevatedButton(
                onPressed: () {

                  if (c.validateWithdrawal(context)) {

                    /// mentor api
                    if (isMentor) {
                      c.finalizeMentorWithdrawal();
                    }

                    /// teacher api
                    else {
                      c.finalizeWithdrawal();
                    }
                  }
                },
                child: Text(
                  isMentor
                      ? 'Withdraw'
                      : 'Finalize Withdrawal',
                ),
              ),
            ),
          ],
        ),
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