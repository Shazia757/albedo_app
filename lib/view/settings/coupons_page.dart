import 'package:albedo_app/controller/settings_controller.dart';
import 'package:albedo_app/model/settings/coupons_model.dart';
import 'package:albedo_app/widgets/responsive.dart';
import 'package:albedo_app/widgets/widgets.dart';
import 'package:albedo_app/widgets/custom_appbar.dart';
import 'package:albedo_app/widgets/drawer_menu.dart';
import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

class CouponsPage extends StatelessWidget {

  CouponsPage({super.key});

  final c = Get.find<SettingsController>();


  @override
  Widget build(BuildContext context) {
    final isDesktop = Responsive.isDesktop(context);

    return Scaffold(
      appBar: const CustomAppBar(),
      backgroundColor: Theme.of(context).colorScheme.surface,
      floatingActionButton: FloatingActionButton(
        onPressed: () => editCoupon(context),
        mini: true,
        backgroundColor: context.theme.colorScheme.primary,
        child: Icon(
          Icons.add,
          color: context.theme.colorScheme.onPrimary,
        ),
      ),
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
                        color: Theme.of(context).colorScheme.primary),
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
                                            child: (item.discountType ==
                                                    'PERCENTAGE')
                                                ? Text(
                                                    "${item.discountPercentage ?? 0}% OFF",
                                                    style: Theme.of(context)
                                                        .textTheme
                                                        .titleSmall!
                                                        .copyWith(
                                                            color: cs.primary),
                                                  )
                                                : Text(
                                                    "₹${item.discountAmount ?? 0}",
                                                    style: Theme.of(context)
                                                        .textTheme
                                                        .titleSmall!
                                                        .copyWith(
                                                            color: cs.primary),
                                                  )),
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
                                            editCoupon(context, coupon: item);
                                          },
                                        ),
                                        SizedBox(width: 10),
                                        CustomWidgets().iconBtn(
                                          icon: Icons.delete_outline_rounded,
                                          color: cs.error,
                                          onTap: () =>
                                              CustomWidgets().showDeleteDialog(
                                            dltText: Obx(
                                              () => c.isLoading.value
                                                  ? const SizedBox(
                                                      width: 18,
                                                      height: 18,
                                                      child:
                                                          CircularProgressIndicator(
                                                        strokeWidth: 2,
                                                        color: Colors.white,
                                                      ),
                                                    )
                                                  : Text(
                                                      "Yes",
                                                      style: Theme.of(context)
                                                          .textTheme
                                                          .titleSmall!
                                                          .copyWith(
                                                              color:
                                                                  Colors.white),
                                                    ),
                                            ),
                                            title: 'Are you sure?',
                                            context: context,
                                            text:
                                                'Are you sure you want to delete this coupon?',
                                            onConfirm: () =>
                                                c.deleteCouponCode(id: item.id),
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

  void editCoupon(
    BuildContext context, {
    Coupons? coupon,
  }) {
    final isEdit = coupon != null;

    /// LOAD DATA
    if (isEdit) {
      c.nameController.text = coupon.name;
      c.codeController.text = coupon.code;

      c.selectedDiscountType.value =
          coupon.discountType == "PERCENTAGE" ? "percentage" : "amount";

      c.discountController.text = coupon.discountType == "PERCENTAGE"
          ? (coupon.discountPercentage ?? '')
          : (coupon.discountAmount ?? '');

      c.startDateController.text = coupon.startDate ?? '';

      c.endDateController.text = coupon.endDate ?? '';

      c.selectedStartDate.value = coupon.startDate != null
          ? DateTime.tryParse(coupon.startDate!)
          : null;

      c.selectedEndDate.value =
          coupon.endDate != null ? DateTime.tryParse(coupon.endDate!) : null;
    } else {
      /// CLEAR DATA
      c.nameController.clear();
      c.codeController.clear();
      c.discountController.clear();
      c.startDateController.clear();
      c.endDateController.clear();

      c.selectedDiscountType.value = '';

      c.selectedStartDate.value = null;
      c.selectedEndDate.value = null;
    }

    CustomWidgets().showCustomDialog(
      context: context,
      title: Text(
        isEdit ? 'Edit Coupon' : 'Add Coupon',
      ),
      submitWidget: Obx(
        () => SizedBox(
          width: 80,
          child: Center(
            child: c.isLoading.value
                ? const SizedBox(
                    width: 18,
                    height: 18,
                    child: CircularProgressIndicator(
                      strokeWidth: 2,
                      color: Colors.white,
                    ),
                  )
                : Text(
                    isEdit ? "Update" : "Create",
                    style: TextStyle(color: Colors.white),
                  ),
          ),
        ),
      ),
      icon: isEdit ? Icons.edit : Icons.add,
      formKey: GlobalKey<FormState>(),
      sections: [
        /// COUPON NAME
        CustomWidgets().labelWithAsterisk(
          'Coupon Name',
        ),
        const SizedBox(height: 10),

        CustomWidgets().dropdownStyledTextField(
          context: context,
          hint: 'Enter coupon name',
          controller: c.nameController,
        ),

        const SizedBox(height: 10),

        /// COUPON CODE
        CustomWidgets().labelWithAsterisk(
          'Coupon Code',
        ),
        const SizedBox(height: 10),

        CustomWidgets().dropdownStyledTextField(
          context: context,
          hint: 'Enter code',
          controller: c.codeController,
        ),

        const SizedBox(height: 10),

        /// DISCOUNT TYPE
        CustomWidgets().labelWithAsterisk(
          'Discount Type',
          required: true,
        ),

        Obx(
          () => Row(
            children: [
              Expanded(
                child: RadioListTile(
                  dense: true,
                  title: const Text('Percentage'),
                  value: "percentage",
                  groupValue: c.selectedDiscountType.value,
                  onChanged: (value) {
                    c.selectedDiscountType.value = value!;
                  },
                ),
              ),
              Expanded(
                child: RadioListTile(
                  dense: true,
                  title: const Text('Fixed Amount'),
                  value: "amount",
                  groupValue: c.selectedDiscountType.value,
                  onChanged: (value) {
                    c.selectedDiscountType.value = value!;
                  },
                ),
              ),
            ],
          ),
        ),

        const SizedBox(height: 10),

        /// DISCOUNT FIELD
        Obx(() {
          if (c.selectedDiscountType.value == 'percentage') {
            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                CustomWidgets().labelWithAsterisk(
                  'Discount Percentage',
                  required: true,
                ),
                const SizedBox(height: 10),
                CustomWidgets().dropdownStyledTextField(
                  context: context,
                  hint: 'Enter discount percentage',
                  controller: c.discountController,
                ),
              ],
            );
          }

          if (c.selectedDiscountType.value == 'amount') {
            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                CustomWidgets().labelWithAsterisk(
                  'Discount Amount',
                  required: true,
                ),
                const SizedBox(height: 10),
                CustomWidgets().dropdownStyledTextField(
                  context: context,
                  hint: 'Enter discount amount',
                  controller: c.discountController,
                ),
              ],
            );
          }

          return const SizedBox();
        }),

        const SizedBox(height: 10),

        /// START DATE
        CustomWidgets().labelWithAsterisk(
          'Start Date',
        ),

        const SizedBox(height: 10),

        CustomWidgets().customStyledDatePickerField(
          context: context,
          controller: c.startDateController,
          firstDate: DateTime.now(),
          lastDate: DateTime.now().add(
            const Duration(days: 365 * 3),
          ),
          onDateSelected: (p0) {
            c.selectedStartDate.value = p0;
          },
          initialDate: c.selectedStartDate.value,
        ),

        const SizedBox(height: 10),

        /// END DATE
        CustomWidgets().labelWithAsterisk(
          'End Date',
        ),

        const SizedBox(height: 10),

        CustomWidgets().customStyledDatePickerField(
          context: context,
          controller: c.endDateController,
          initialDate: c.selectedEndDate.value,
          firstDate: DateTime.now(),
          lastDate: DateTime.now().add(
            const Duration(days: 365 * 3),
          ),
          onDateSelected: (p0) {
            c.selectedEndDate.value = p0;
          },
        ),

        const SizedBox(height: 10),
      ],
      onSubmit: () async {
        /// VALIDATIONS
        if (c.nameController.text.trim().isEmpty) {
          Get.snackbar(
            'Error',
            'Please enter coupon name',
          );
          return;
        }

        if (c.codeController.text.trim().isEmpty) {
          Get.snackbar(
            'Error',
            'Please enter coupon code',
          );
          return;
        }

        if (c.selectedDiscountType.value.isEmpty) {
          Get.snackbar(
            'Error',
            'Please select discount type',
          );
          return;
        }

        if (c.discountController.text.trim().isEmpty) {
          Get.snackbar(
            'Error',
            c.selectedDiscountType.value == 'percentage'
                ? 'Please enter discount percentage'
                : 'Please enter discount amount',
          );
          return;
        }

        if (c.selectedStartDate.value == null) {
          Get.snackbar(
            'Error',
            'Please select start date',
          );
          return;
        }

        if (c.selectedEndDate.value == null) {
          Get.snackbar(
            'Error',
            'Please select end date',
          );
          return;
        }

        if (c.selectedEndDate.value!.isBefore(
          c.selectedStartDate.value!,
        )) {
          Get.snackbar(
            'Error',
            'End date must be after start date',
          );
          return;
        }

        try {
          c.isLoading.value = true;
          final isPercentage = c.selectedDiscountType.value == 'percentage';

          final body = {
            "coupon_name": c.nameController.text.trim(),
            "coupon_code": c.codeController.text.trim(),
            "discount_type": isPercentage ? "PERCENTAGE" : "AMOUNT",
            "discount_percentage":
                isPercentage ? c.discountController.text.trim() : null,
            "discount_amount":
                !isPercentage ? c.discountController.text.trim() : null,
            "valid_from": DateFormat(
              'yyyy-MM-dd',
            ).format(
              c.selectedStartDate.value!,
            ),
            "valid_to": DateFormat(
              'yyyy-MM-dd',
            ).format(
              c.selectedEndDate.value!,
            ),
          };
          Coupons? result;

          if (isEdit) {
            result = await c.updateCouponCode(
              couponId: coupon.id,
              body: body,
            );
          } else {
            result = await c.addCouponCode(body: body);
          }

          if (result == null) {
            return;
          }

          await c.getCoupons();

          if (context.mounted) {
            Navigator.pop(context);

            Get.snackbar(
              'Success',
              isEdit
                  ? 'Coupon updated successfully'
                  : 'Coupon added successfully',
            );
          }
        } catch (e) {
          Get.snackbar(
            'Error',
            e.toString(),
          );
        } finally {
          c.isLoading.value = false;
        }
      },
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
