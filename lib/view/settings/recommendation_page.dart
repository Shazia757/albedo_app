import 'package:albedo_app/controller/settings_controller.dart';
import 'package:albedo_app/view/settings/banner_ads_page.dart';
import 'package:albedo_app/widgets/responsive.dart';
import 'package:albedo_app/widgets/widgets.dart';
import 'package:albedo_app/widgets/custom_appbar.dart';
import 'package:albedo_app/widgets/drawer_menu.dart';
import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:get/get.dart';

class RecommendationPage extends StatelessWidget {
  final c = Get.put(SettingsController());

  RecommendationPage({super.key});

  @override
  Widget build(BuildContext context) {
    final isDesktop = Responsive.isDesktop(context);
    final cs = Theme.of(context).colorScheme;

    return Scaffold(
      appBar: const CustomAppBar(),
      backgroundColor: cs.surface,
      floatingActionButton: addRecommendationBtn(context),
      body: Row(
        children: [
          if (isDesktop) const DrawerMenu(),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Obx(() {
                final data = c.recommendations;

                if (c.isLoading.value) {
                  return const Center(child: CircularProgressIndicator());
                }

                if (data.isEmpty) {
                  return const Center(child: Text("No recommendations found"));
                }

                return Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    /// TITLE (outside card)
                    Text(
                      "Recommendations",
                      style: Theme.of(context).textTheme.titleLarge,
                    ),

                    const SizedBox(height: 12),

                    /// GRID
                    Expanded(
                      child: LayoutBuilder(
                        builder: (context, constraints) {
                          int crossAxisCount = 1;

                          if (constraints.maxWidth > 1200) {
                            crossAxisCount = 3;
                          } else if (constraints.maxWidth > 700) {
                            crossAxisCount = 2;
                          }

                          return MasonryGridView.count(
                            padding: const EdgeInsets.all(12),
                            crossAxisCount: crossAxisCount,
                            mainAxisSpacing: 12,
                            crossAxisSpacing: 12,
                            itemCount: data.length,
                            itemBuilder: (_, i) {
                              final item = data[i];
                              final isPackage = (item.package ?? "").isNotEmpty;

                              return CustomCard(
                                c: c,

                                /// CONTENT
                                content: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      isPackage ? "Package" : "Batch",
                                      style: TextStyle(
                                        fontSize: 11,
                                        color: cs.onSurface.withOpacity(0.6),
                                      ),
                                    ),
                                    const SizedBox(height: 4),

                                    Text(
                                      isPackage
                                          ? (item.package ?? "-")
                                          : (item.batch ?? "-"),
                                      style: const TextStyle(
                                        fontSize: 15,
                                        fontWeight: FontWeight.w700,
                                      ),
                                    ),

                                    const SizedBox(height: 12),

                                    Text(
                                      "Syllabuses",
                                      style: TextStyle(
                                        fontSize: 11,
                                        color: cs.onSurface.withOpacity(0.6),
                                      ),
                                    ),
                                    const SizedBox(height: 6),

                                    Wrap(
                                      spacing: 6,
                                      runSpacing: 6,
                                      children: (item.visibleTo ?? []).map((v) {
                                        return Container(
                                          padding: const EdgeInsets.symmetric(
                                              horizontal: 10, vertical: 4),
                                          decoration: BoxDecoration(
                                            color: cs.primaryContainer
                                                .withOpacity(0.7),
                                            borderRadius:
                                                BorderRadius.circular(50),
                                          ),
                                          child: Text(
                                            v,
                                            style: TextStyle(
                                              fontSize: 11,
                                              color: cs.onPrimaryContainer,
                                            ),
                                          ),
                                        );
                                      }).toList(),
                                    ),

                                    const SizedBox(height: 12),

                                    /// DATES (clean unified style)
                                    Row(
                                      children: [
                                        Expanded(
                                          child: _dateBox(
                                            context,
                                            "From",
                                            item.startDate ?? "-",
                                          ),
                                        ),
                                        const SizedBox(width: 10),
                                        Expanded(
                                          child: _dateBox(
                                            context,
                                            "To",
                                            item.endDate ?? "-",
                                          ),
                                        ),
                                      ],
                                    ),
                                  ],
                                ),

                                /// ACTIONS
                                actions: [
                                  CustomWidgets().iconBtn(
                                    icon: Icons.edit,
                                    color: cs.primary,
                                    onTap: () {
                                      c.loadRecommendations(item);
                                      editRecommendation(context);
                                    },
                                  ),
                                  const SizedBox(width: 10),
                                  CustomWidgets().iconBtn(
                                    icon: Icons.delete,
                                    color: cs.error,
                                    onTap: () =>
                                        CustomWidgets().showDeleteDialog(
                                      title: 'Are you sure?',
                                      context: context,
                                      text:
                                          'Are you sure you want to delete this recommendation?',
                                      onConfirm: () => c.delete(item.id),
                                    ),
                                  ),
                                ],
                              );
                            },
                          );
                        },
                      ),
                    ),
                  ],
                );
              }),
            ),
          ),
        ],
      ),
    );
  }

  Widget _dateBox(BuildContext context, String label, String value) {
    final cs = Theme.of(context).colorScheme;

    return Container(
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        color: cs.surfaceContainerHighest.withOpacity(.2),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style: TextStyle(
              fontSize: 11,
              color: cs.onSurface.withOpacity(0.6),
            ),
          ),
          const SizedBox(height: 4),
          Text(
            value,
            style: const TextStyle(fontWeight: FontWeight.w600),
          ),
        ],
      ),
    );
  }

  void editRecommendation(BuildContext context) {
    CustomWidgets().showCustomDialog(
      context: context,
      title: Text('Edit Recommendation'),
      icon: Icons.edit,
      formKey: GlobalKey<FormState>(),
      sections: [
        CustomWidgets().labelWithAsterisk('Coupon Name'),
        const SizedBox(height: 10),
        CustomWidgets().dropdownStyledTextField(
            context: context, hint: '', controller: c.nameController),
        const SizedBox(height: 10),
        CustomWidgets().labelWithAsterisk('Coupon Code'),
        const SizedBox(height: 10),
        CustomWidgets().dropdownStyledTextField(
            context: context, hint: '', controller: c.codeController),
        const SizedBox(height: 10),
        CustomWidgets().labelWithAsterisk('Discount Type', required: true),
        Obx(
          () => Row(
            children: [
              Expanded(
                child: RadioListTile(
                  dense: true,
                  title: Text('Percentage'),
                  value: "percentage",
                  groupValue: c.selectedDiscountType.value,
                  onChanged: (value) => c.selectedDiscountType.value = value!,
                ),
              ),
              Expanded(
                child: RadioListTile(
                  title: Text('Fixed Amount'),
                  value: "fixedAmount",
                  groupValue: c.selectedDiscountType.value,
                  onChanged: (value) => c.selectedDiscountType.value = value!,
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 10),
        Obx(() {
          if (c.selectedDiscountType.value == 'percentage') {
            return Column(
              children: [
                CustomWidgets()
                    .labelWithAsterisk('Discount Percentage', required: true),
                const SizedBox(height: 10),
                CustomWidgets().dropdownStyledTextField(
                    context: context,
                    hint: 'Enter discount percentage',
                    controller: c.discountController),
              ],
            );
          }
          if (c.selectedDiscountType.value == 'fixedAmount') {
            return Column(
              children: [
                CustomWidgets()
                    .labelWithAsterisk('Discount Amount', required: true),
                const SizedBox(height: 10),
                CustomWidgets().dropdownStyledTextField(
                    context: context, hint: 'Enter discount amount'),
              ],
            );
          }
          return const SizedBox();
        }),
        const SizedBox(height: 10),
        CustomWidgets().labelWithAsterisk('Start Date'),
        const SizedBox(height: 10),
        CustomWidgets().dropdownStyledTextField(
            context: context, hint: '', controller: c.startDateController),
        const SizedBox(height: 10),
        CustomWidgets().labelWithAsterisk('End Date'),
        const SizedBox(height: 10),
        CustomWidgets().dropdownStyledTextField(
            context: context, hint: '', controller: c.endDateController),
        const SizedBox(height: 10),
      ],
      onSubmit: () {},
    );
  }

  FloatingActionButton addRecommendationBtn(BuildContext context) {
    return FloatingActionButton(
      onPressed: () => CustomWidgets().showCustomDialog(
        context: context,
        title: Text("Add Recommendation"),
        formKey: GlobalKey<FormState>(),
        onSubmit: () {},
        sections: [
          CustomWidgets()
              .labelWithAsterisk('Select recommendation Type', required: true),
          const SizedBox(height: 10),
          Obx(
            () => Row(
              children: [
                Expanded(
                  child: RadioListTile(
                    dense: true,
                    title: Text('Package'),
                    value: "package",
                    groupValue: c.selectedRecommendationType.value,
                    onChanged: (value) =>
                        c.selectedRecommendationType.value = value!,
                  ),
                ),
                Expanded(
                  child: RadioListTile(
                    dense: true,
                    title: Text('Batch'),
                    value: "batch",
                    groupValue: c.selectedRecommendationType.value,
                    onChanged: (value) =>
                        c.selectedRecommendationType.value = value!,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 10),
          Obx(() {
            if (c.selectedRecommendationType.value == 'package') {
              return Column(
                children: [
                  CustomWidgets()
                      .labelWithAsterisk('Recommended Package', required: true),
                  const SizedBox(height: 10),
                  CustomWidgets().dropdownStyledTextField(
                      context: context, hint: 'Select Package'),
                ],
              );
            }
            if (c.selectedRecommendationType.value == 'batch') {
              return Column(
                children: [
                  CustomWidgets()
                      .labelWithAsterisk('Recommended Batch', required: true),
                  const SizedBox(height: 10),
                  CustomWidgets().dropdownStyledTextField(
                      context: context, hint: 'Select batch'),
                ],
              );
            }
            return const SizedBox();
          }),
          const SizedBox(height: 10),
          CustomWidgets().labelWithAsterisk('Start Date'),
          const SizedBox(height: 10),
          CustomWidgets().customDatePickerField(
              context: context,
              controller: c.startDateController,
              selectedDate: c.selectedStartDate),
          const SizedBox(height: 10),
          CustomWidgets().labelWithAsterisk('End Date'),
          const SizedBox(height: 10),
          CustomWidgets().customDatePickerField(
              context: context,
              controller: c.endDateController,
              selectedDate: c.selectedEndDate),
          const SizedBox(height: 10),
          CustomWidgets().labelWithAsterisk('Visible To:'),
          const SizedBox(height: 10),
          MultiSelector(
            items: c.syllabus,
            allValue: "All",
            initial: List.from(c.selectedSyllabus),
            labelBuilder: (v) => v,
            onChanged: (val) {
              c.selectedSyllabus.assignAll(val);
            },
          )
        ],
      ),
      mini: true,
      backgroundColor: context.theme.colorScheme.primary,
      child: Icon(
        Icons.add,
        color: context.theme.colorScheme.onPrimary,
      ),
    );
  }
}
