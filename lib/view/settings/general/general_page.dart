import 'package:albedo_app/controller/settings_controller.dart';
import 'package:albedo_app/view/settings/general/assessment_attention_question_page.dart';
import 'package:albedo_app/view/settings/general/category_page.dart';
import 'package:albedo_app/view/settings/general/course_page.dart';
import 'package:albedo_app/view/settings/general/deadline_page.dart';
import 'package:albedo_app/view/settings/general/package_page.dart';
import 'package:albedo_app/view/settings/general/privacy_page.dart';
import 'package:albedo_app/view/settings/general/referral_source_page.dart';
import 'package:albedo_app/view/settings/general/refund_page.dart';
import 'package:albedo_app/view/settings/general/standard_page.dart';
import 'package:albedo_app/view/settings/general/support_category_page.dart';
import 'package:albedo_app/view/settings/general/syllabus_page.dart';
import 'package:albedo_app/view/settings/general/terms_page.dart';
import 'package:albedo_app/widgets/custom_appbar.dart';
import 'package:albedo_app/widgets/drawer_menu.dart';
import 'package:albedo_app/widgets/widgets.dart';
import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:get/get.dart';

class GeneralPage extends StatelessWidget {
  final c = Get.put(SettingsController());

  GeneralPage({super.key});

  final sections = [
    _Section(
      title: "Financial & Pricing",
      icon: Icons.attach_money,
      items: [
        _Item("Registration Fee", Icons.payments, (ctx) {
          final _formKey = GlobalKey<FormState>();
          final c = Get.put(SettingsController());

          CustomWidgets().showCustomDialog(
            context: ctx,
            title: Text('Update Registration Fee'),
            formKey: _formKey,
            submitText: 'Update',
            sections: [
              Column(
                children: [
                  Text('Please click update button after changing the amount'),
                  const SizedBox(height: 10),
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 150),
                    child: CustomWidgets().dropdownStyledTextField(
                        context: ctx,
                        hint: '0.0',
                        controller: c.regFeeController),
                  ),
                  const SizedBox(height: 10),
                  Text('Last updated: ')
                ],
              )
            ],
            onSubmit: () {},
          );
        }),
        _Item("Factor Value", Icons.tune, (ctx) {
          final _formKey = GlobalKey<FormState>();
          final c = Get.put(SettingsController());

          CustomWidgets().showCustomDialog(
            context: ctx,
            title: Text('Update Factor Value'),
            formKey: _formKey,
            submitText: 'Update',
            sections: [
              Column(
                children: [
                  Text('Please click update button after changing the value'),
                  const SizedBox(height: 10),
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 150),
                    child: CustomWidgets().dropdownStyledTextField(
                        context: ctx,
                        hint: '0.0',
                        controller: c.factorValueController),
                  ),
                  const SizedBox(height: 10),
                ],
              )
            ],
            onSubmit: () {},
          );
        }),
        _Item("Tax", Icons.receipt_long, (ctx) {
          final _formKey = GlobalKey<FormState>();
          final c = Get.put(SettingsController());

          CustomWidgets().showCustomDialog(
            context: ctx,
            title: Text('Update Salary Invoice Tax'),
            formKey: _formKey,
            submitText: 'Update',
            sections: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text('Please click update button after changing'),

                  const SizedBox(height: 12),

                  /// 🔘 TYPE SELECTION
                  Obx(() => Row(
                        children: [
                          Expanded(
                            child: RadioListTile<String>(
                              title: const Text("Percentage"),
                              value: "percentage",
                              groupValue: c.feeType.value,
                              onChanged: (val) => c.feeType.value = val!,
                              contentPadding: EdgeInsets.zero,
                              dense: true,
                            ),
                          ),
                          Expanded(
                            child: RadioListTile<String>(
                              title: const Text("Amount"),
                              value: "amount",
                              groupValue: c.feeType.value,
                              onChanged: (val) => c.feeType.value = val!,
                              contentPadding: EdgeInsets.zero,
                              dense: true,
                            ),
                          ),
                        ],
                      )),

                  const SizedBox(height: 8),

                  /// 💰 INPUT FIELD
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 150),
                    child: Obx(
                      () => CustomWidgets().dropdownStyledTextField(
                        context: ctx,
                        hint: c.feeType.value == "percentage" ? '0%' : '₹0.0',
                        controller: c.regFeeController,
                      ),
                    ),
                  ),

                  const SizedBox(height: 14),

                  /// 🔁 STATUS TOGGLE
                  Obx(() => Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const Text(
                            "Status",
                            style: TextStyle(fontWeight: FontWeight.w500),
                          ),
                          Row(
                            children: [
                              ChoiceChip(
                                label: const Text("Active"),
                                selected: c.status.value == "active",
                                onSelected: (_) => c.status.value = "active",
                              ),
                              const SizedBox(width: 8),
                              ChoiceChip(
                                label: const Text("Inactive"),
                                selected: c.status.value == "inactive",
                                onSelected: (_) => c.status.value = "inactive",
                              ),
                            ],
                          ),
                        ],
                      )),
                ],
              )
            ],
            onSubmit: () {},
          );
        }),
      ],
    ),
    _Section(
      title: "Academic Setup",
      icon: Icons.school,
      items: [
        _Item(
            "Syllabus", Icons.menu_book, (ctx) => Get.to(() => SyllabusPage())),
        _Item("Course", Icons.book, (ctx) => Get.to(() => CoursePage())),
        _Item("Package", Icons.inventory, (ctx) => Get.to(() => PackagePage())),
        _Item(
            "Category", Icons.category, (ctx) => Get.to(() => CategoryPage())),
        _Item("Standard", Icons.class_, (ctx) => Get.to(() => StandardPage())),
      ],
    ),
    _Section(
      title: "User & Support",
      icon: Icons.support_agent,
      items: [
        _Item("Support Category", Icons.headset_mic,
            (ctx) => Get.to(SupportCategoryPage())),
        _Item("Referral", Icons.share, (ctx) => Get.to(ReferralSourcePage())),
      ],
    ),
    _Section(
      title: "System Rules",
      icon: Icons.rule,
      items: [
        _Item("Completion Deadline", Icons.timer, (ctx) => Get.to(() => DeadlinePage())),
        _Item("Assessment Questions", Icons.help_outline,
            (ctx) => Get.to(() => AssessmentAttentionQuestionPage())),
      ],
    ),
    _Section(
      title: "Policies & Legal",
      icon: Icons.policy,
      items: [
        _Item("Terms of Users", Icons.description,
            (ctx) => Get.to(() => TermsPage())),
        _Item("Privacy Policy", Icons.privacy_tip,
            (ctx) => Get.to(() => PrivacyPage())),
        _Item("Refund Policy", Icons.assignment_return,
            (ctx) => Get.to(() => RefundPage())),
      ],
    ),
  ];

  @override
  Widget build(BuildContext context) {
    final isDesktop = MediaQuery.of(context).size.width > 900;

    return Scaffold(
      appBar: CustomAppBar(),
      backgroundColor: Theme.of(context).colorScheme.onPrimary,
      body: Row(
        children: [
          /// 🧭 Desktop Drawer
          if (isDesktop) const DrawerMenu(),

          /// 📦 Main Content
          Expanded(
            child: isDesktop
                ? Padding(
                    padding: const EdgeInsets.all(16),
                    child: MasonryGridView.count(
                      crossAxisCount:
                          MediaQuery.of(context).size.width > 1400 ? 4 : 3,
                      mainAxisSpacing: 16,
                      crossAxisSpacing: 16,
                      itemCount: sections.length,
                      itemBuilder: (context, index) {
                        return _sectionCard(context, sections[index]);
                      },
                    ),
                  )
                : SingleChildScrollView(
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      children: sections
                          .map((s) => Padding(
                                padding: const EdgeInsets.only(bottom: 16),
                                child: _sectionCard(context, s),
                              ))
                          .toList(),
                    ),
                  ),
          ),
        ],
      ),
    );
  }

  Widget _sectionCard(BuildContext context, _Section section) {
    return Container(
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surface,
        border: Border.all(
          color: Theme.of(context).colorScheme.outline,
        ),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    color: Colors.blue.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Icon(section.icon, color: Colors.blue),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: Text(
                    section.title,
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            const Divider(),
            const SizedBox(height: 8),
            Column(
              children: section.items
                  .map((item) => Padding(
                        padding: const EdgeInsets.only(bottom: 8),
                        child: _tile(context, item),
                      ))
                  .toList(),
            )
          ],
        ),
      ),
    );
  }

  Widget _tile(BuildContext context, _Item item) {
    return InkWell(
      onTap: () => item.onTap(context),
      borderRadius: BorderRadius.circular(12),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: Colors.grey.shade200),
        ),
        child: Row(
          children: [
            Icon(item.icon, size: 20, color: Colors.grey[700]),
            const SizedBox(width: 10),
            Expanded(
              child: Text(
                item.title,
                style: const TextStyle(fontSize: 14),
              ),
            ),
            const Icon(Icons.arrow_forward_ios, size: 14)
          ],
        ),
      ),
    );
  }
}

class _Section {
  final String title;
  final IconData icon;
  final List<_Item> items;

  _Section({
    required this.title,
    required this.icon,
    required this.items,
  });
}

class _Item {
  final String title;
  final IconData icon;
  final Function(BuildContext) onTap;

  _Item(this.title, this.icon, this.onTap);
}
