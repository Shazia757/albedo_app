import 'package:albedo_app/controller/settings_controller.dart';
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
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  /// ── PAGE TITLE ─────────────────────
                  Text(
                    "Coupons",
                    style: Theme.of(context).textTheme.titleLarge?.copyWith(
                          fontWeight: FontWeight.w700,
                        ),
                  ),

                  SizedBox(height: 16),

                  /// ── CONTENT ───────────────────────
                  Expanded(
                    child: Obx(() {
                      final data = c.coupons;

                      if (c.isLoading.value) {
                        return Center(
                          child: CircularProgressIndicator(),
                        );
                      }

                      if (data.isEmpty) {
                        return Center(
                          child: Text("No coupons found"),
                        );
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
                            padding: EdgeInsets.zero,
                            crossAxisCount: crossAxisCount,
                            mainAxisSpacing: 12,
                            crossAxisSpacing: 12,
                            itemCount: data.length,
                            itemBuilder: (_, i) {
                              final item = data[i];
                              final cs = Theme.of(context).colorScheme;

                              return Container(
                                padding: const EdgeInsets.all(16),
                                decoration: BoxDecoration(
                                  color: cs.onPrimary,
                                  borderRadius: BorderRadius.circular(20),
                                  border: Border.all(
                                    color: cs.outline.withOpacity(.5),
                                  ),
                                  boxShadow: [
                                    BoxShadow(
                                      color: cs.shadow.withOpacity(.04),
                                      blurRadius: 12,
                                      offset: const Offset(0, 4),
                                    ),
                                  ],
                                ),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    /// ── HEADER ─────────────────────────────
                                    Row(
                                      children: [
                                        Container(
                                          width: 42,
                                          height: 42,
                                          decoration: BoxDecoration(
                                            color: cs.primary.withOpacity(.08),
                                            borderRadius:
                                                BorderRadius.circular(14),
                                          ),
                                          child: Icon(
                                            Icons.discount_rounded,
                                            color: cs.primary,
                                          ),
                                        ),
                                        SizedBox(width: 12),
                                        Expanded(
                                          child: Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              Text(
                                                item.name ?? '',
                                                maxLines: 1,
                                                overflow: TextOverflow.ellipsis,
                                                style: Theme.of(context)
                                                    .textTheme
                                                    .titleMedium!
                                                    .copyWith(
                                                        color: cs.onSurface),
                                              ),
                                              SizedBox(height: 4),
                                              Text(
                                                item.code ?? '',
                                                style: Theme.of(context)
                                                    .textTheme
                                                    .bodySmall!
                                                    .copyWith(
                                                        color: cs.outline),
                                              ),
                                            ],
                                          ),
                                        ),
                                        Container(
                                          padding: const EdgeInsets.symmetric(
                                            horizontal: 10,
                                            vertical: 6,
                                          ),
                                          decoration: BoxDecoration(
                                            color: cs.primaryContainer
                                                .withOpacity(.45),
                                            borderRadius:
                                                BorderRadius.circular(30),
                                          ),
                                          child: Text(
                                            "${item.discount ?? 0}% OFF",
                                            style: Theme.of(context)
                                                .textTheme
                                                .titleSmall!
                                                .copyWith(color: cs.primary),
                                          ),
                                        ),
                                      ],
                                    ),

                                    SizedBox(height: 14),

                                    Divider(
                                      height: 1,
                                      color: cs.outline.withOpacity(.12),
                                    ),

                                    SizedBox(height: 14),

                                    /// ── DATE SECTION ──────────────────────
                                    Container(
                                      padding: const EdgeInsets.all(12),
                                      decoration: BoxDecoration(
                                        color: cs.surfaceContainerHighest
                                            .withOpacity(.22),
                                        borderRadius: BorderRadius.circular(16),
                                      ),
                                      child: Row(
                                        children: [
                                          Expanded(
                                            child: _infoTile(
                                              context,
                                              icon:
                                                  Icons.calendar_month_outlined,
                                              title: "Valid From",
                                              value: item.startDate ?? "-",
                                            ),
                                          ),
                                          Container(
                                            width: 1,
                                            height: 42,
                                            margin: const EdgeInsets.symmetric(
                                                horizontal: 12),
                                            color: cs.outline.withOpacity(.12),
                                          ),
                                          Expanded(
                                            child: _infoTile(
                                              context,
                                              icon:
                                                  Icons.event_available_rounded,
                                              title: "Valid To",
                                              value: item.endDate ?? "-",
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                    SizedBox(height: 14),

                                    /// ── ACTIONS ───────────────────────────
                                    Row(
                                      mainAxisAlignment: MainAxisAlignment.end,
                                      children: [
                                        CustomWidgets().iconBtn(
                                          icon: Icons.edit_rounded,
                                          color: cs.primary,
                                          onTap: () {
                                            c.loadCoupons(item);
                                            editCoupon(context);
                                          },
                                        ),
                                        SizedBox(width: 10),
                                        CustomWidgets().iconBtn(
                                          icon: Icons.delete_outline_rounded,
                                          color: cs.error,
                                          onTap: () =>
                                              CustomWidgets().showDeleteDialog(
                                            title: 'Are you sure?',
                                            context: context,
                                            text:
                                                'Are you sure you want to delete this coupon?',
                                            onConfirm: () => c.delete(item.id),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                              );
                            },
                          );
                        },
                      );
                    }),
                  ),
                ],
              ),
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
        SizedBox(height: 10),
        CustomWidgets().dropdownStyledTextField(
            context: context, hint: '', controller: c.nameController),
        SizedBox(height: 10),
        CustomWidgets().labelWithAsterisk('Coupon Code'),
        SizedBox(height: 10),
        CustomWidgets().dropdownStyledTextField(
            context: context, hint: '', controller: c.codeController),
        SizedBox(height: 10),
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
        SizedBox(height: 10),
        Obx(() {
          if (c.selectedDiscountType.value == 'percentage') {
            return Column(
              children: [
                CustomWidgets()
                    .labelWithAsterisk('Discount Percentage', required: true),
                SizedBox(height: 10),
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
                SizedBox(height: 10),
                CustomWidgets().dropdownStyledTextField(
                    context: context, hint: 'Enter discount amount'),
              ],
            );
          }
          return SizedBox();
        }),
        SizedBox(height: 10),
        CustomWidgets().labelWithAsterisk('Start Date'),
        SizedBox(height: 10),
        CustomWidgets().customDatePickerField(
            context: context,
            controller: c.startDateController,
            selectedDate: c.selectedStartDate),
        SizedBox(height: 10),
        CustomWidgets().labelWithAsterisk('End Date'),
        SizedBox(height: 10),
        CustomWidgets().customDatePickerField(
            context: context,
            controller: c.endDateController,
            selectedDate: c.selectedEndDate),
        SizedBox(height: 10),
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
          SizedBox(height: 10),
          CustomWidgets().dropdownStyledTextField(
              context: context, hint: 'Enter coupon name'),
          SizedBox(height: 10),
          CustomWidgets().labelWithAsterisk('Coupon Code'),
          SizedBox(height: 10),
          CustomWidgets().dropdownStyledTextField(
              context: context, hint: 'Enter coupon code'),
          SizedBox(height: 10),
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
          SizedBox(height: 10),
          Obx(() {
            if (c.selectedDiscountType.value == 'percentage') {
              return Column(
                children: [
                  CustomWidgets()
                      .labelWithAsterisk('Discount Percentage', required: true),
                  SizedBox(height: 10),
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
                  SizedBox(height: 10),
                  CustomWidgets().dropdownStyledTextField(
                      context: context, hint: 'Enter discount amount'),
                ],
              );
            }
            return SizedBox();
          }),
          SizedBox(height: 10),
          CustomWidgets().labelWithAsterisk('Start Date'),
          SizedBox(height: 10),
          CustomWidgets().dropdownStyledTextField(context: context, hint: ''),
          SizedBox(height: 10),
          CustomWidgets().labelWithAsterisk('End Date'),
          SizedBox(height: 10),
          CustomWidgets().dropdownStyledTextField(context: context, hint: ''),
          SizedBox(height: 10),
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

  Widget _infoTile(
    BuildContext context, {
    required IconData icon,
    required String title,
    required String value,
  }) {
    final cs = Theme.of(context).colorScheme;

    return Row(
      children: [
        Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: cs.primary.withOpacity(.08),
            borderRadius: BorderRadius.circular(10),
          ),
          child: Icon(
            icon,
            size: 18,
            color: cs.primary,
          ),
        ),
        SizedBox(width: 10),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: Theme.of(context)
                    .textTheme
                    .labelSmall!
                    .copyWith(color: cs.outline),
              ),
              SizedBox(height: 3),
              Text(
                value,
                style: Theme.of(context)
                    .textTheme
                    .titleSmall!
                    .copyWith(color: cs.onSurface),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
