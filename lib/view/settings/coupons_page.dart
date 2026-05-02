import 'package:albedo_app/controller/settings_controller.dart';
import 'package:albedo_app/view/settings/banner_ads_page.dart';
import 'package:albedo_app/widgets/responsive.dart';
import 'package:albedo_app/widgets/widgets.dart';
import 'package:albedo_app/widgets/custom_appbar.dart';
import 'package:albedo_app/widgets/drawer_menu.dart';
import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:get/get.dart';

class CouponsPage extends StatelessWidget {
  final c = Get.put(SettingsController());

  CouponsPage({super.key});

  @override
  Widget build(BuildContext context) {
    final isDesktop = Responsive.isDesktop(context);

    return Scaffold(
      appBar: const CustomAppBar(),
       backgroundColor: Theme.of(context).colorScheme.surface,

      floatingActionButton: addCouponBtn(context),
      body: Row(
        children: [
          if (isDesktop) const DrawerMenu(),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Obx(() {
                final data = c.coupons;
                int crossAxisCount = 1;

                if (c.isLoading.value) {
                  return const Center(child: CircularProgressIndicator());
                }
                if (data.isEmpty) {
                  return const Center(child: Text("No notifications found"));
                }

                if (Responsive.isTablet(context)) {
                  crossAxisCount = 2;
                } else if (Responsive.isDesktop(context)) {
                  crossAxisCount = 3;
                }

                return LayoutBuilder(
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

                        return CustomCard(
                          c: c,
                          title: item.name ?? '',
                          content: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text('Code: ${item.code} '),
                              Text('Discount: ${item.discount ?? ''} '),
                              Text('Valid From: ${item.startDate} '),
                              Text('Valid To: ${item.endDate} '),
                            ],
                          ),
                          actions: [
                            CustomWidgets().iconBtn(
                              icon: Icons.edit,
                              color: Theme.of(context).colorScheme.primary,
                              onTap: () {
                                c.loadCoupons(item);
                                editCoupon(context);
                              },
                            ),
                            CustomWidgets().iconBtn(
                              icon: Icons.delete,
                              color: Theme.of(context).colorScheme.error,
                              onTap: () => CustomWidgets().showDeleteDialog(
                                context: context,
                                text:
                                    'Are you sure you want to delete this coupon?',
                                onConfirm: () => c.delete(item.id),
                              ),
                            ),
                          ],
                        );
                      },
                    );
                  },
                );
              }),
            ),
          ),
        ],
      ),
    );
  }

  void editCoupon(BuildContext context) {
    CustomWidgets().showCustomDialog(
      context: context,
      title: Text('Edit Coupon'),
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

  FloatingActionButton addCouponBtn(BuildContext context) {
    return FloatingActionButton(
      onPressed: () => CustomWidgets().showCustomDialog(
        context: context,
        title: Text("Add Coupon"),
        formKey: GlobalKey<FormState>(),
        onSubmit: () {},
        sections: [
          CustomWidgets().labelWithAsterisk('Coupon Name', required: true),
          const SizedBox(height: 10),
          CustomWidgets().dropdownStyledTextField(
              context: context, hint: 'Enter coupon name'),
          const SizedBox(height: 10),
          CustomWidgets().labelWithAsterisk('Coupon Code'),
          const SizedBox(height: 10),
          CustomWidgets().dropdownStyledTextField(
              context: context, hint: 'Enter coupon code'),
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
                    dense: true,
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
                      context: context, hint: 'Enter discount percentage'),
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
          CustomWidgets().dropdownStyledTextField(context: context, hint: ''),
          const SizedBox(height: 10),
          CustomWidgets().labelWithAsterisk('End Date'),
          const SizedBox(height: 10),
          CustomWidgets().dropdownStyledTextField(context: context, hint: ''),
          const SizedBox(height: 10),
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
