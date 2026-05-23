import 'package:albedo_app/controller/settings_controller.dart';
import 'package:albedo_app/model/settings/hiring_ad_model.dart';
import 'package:albedo_app/view/settings/banner_ads_page.dart';
import 'package:albedo_app/widgets/responsive.dart';
import 'package:albedo_app/widgets/widgets.dart';
import 'package:albedo_app/widgets/custom_appbar.dart';
import 'package:albedo_app/widgets/drawer_menu.dart';
import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

class HiringPage extends StatelessWidget {
  final c = Get.find<SettingsController>();

  HiringPage({super.key});

  @override
  Widget build(BuildContext context) {
    final isDesktop = Responsive.isDesktop(context);
    final cs = Get.theme.colorScheme;

    return Scaffold(
      appBar: const CustomAppBar(),
      backgroundColor: cs.surface,
      floatingActionButton: FloatingActionButton(
        onPressed: () => editHiringAd(context),
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
              child: Obx(() {
                final data = c.hiringAd;

                if (c.isLoading.value) {
                  return Center(child: CircularProgressIndicator());
                }

                if (data.isEmpty) {
                  return Center(child: Text("No hiring ads found"));
                }

                return Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    /// TITLE (outside cards)
                    Text(
                      "Hiring Ads",
                      style: Theme.of(context).textTheme.titleLarge!.copyWith(
                          fontWeight: FontWeight.bold,
                          color: Theme.of(context).colorScheme.primary),
                    ),

                    SizedBox(height: 12),

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

                              return CustomCard(
                                c: c,

                                /// CONTENT
                                content: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    ClipRRect(
                                      borderRadius: BorderRadius.circular(14),
                                      child: Image.network(
                                        'https://api.albedoedu.com${item.image}',
                                        height: 160,
                                        width: double.infinity,
                                        fit: BoxFit.cover,
                                        errorBuilder: (context, error, stack) {
                                          debugPrint(
                                              "IMAGE LOAD ERROR: $error");
                                          return Container(
                                            height: 160,
                                            width: double.infinity,
                                            color: cs.surfaceContainerHighest,
                                            child: Icon(
                                              Icons.image_outlined,
                                              size: 40,
                                              color:
                                                  cs.onSurface.withOpacity(.4),
                                            ),
                                          );
                                        },
                                      ),
                                    ),
                                    SizedBox(height: 14),
                                    _info(cs, "Package", item.package),
                                    SizedBox(height: 10),
                                    _info(cs, "Time", item.time),
                                    SizedBox(height: 10),
                                    Row(
                                      children: [
                                        Expanded(
                                          child: _dateBox(
                                              context,
                                              "From",
                                              item.fromDate != null
                                                  ? DateFormat('dd MMM yyyy')
                                                      .format(item.fromDate!)
                                                  : '-'),
                                        ),
                                        SizedBox(width: 10),
                                        Expanded(
                                          child: _dateBox(
                                              context,
                                              "To",
                                              item.toDate != null
                                                  ? DateFormat('dd MMM yyyy')
                                                      .format(item.toDate!)
                                                  : '-'),
                                        ),
                                      ],
                                    ),
                                    SizedBox(height: 12),
                                    Text(
                                      "Regular Days",
                                      style: Get.textTheme.labelSmall!.copyWith(
                                          color: cs.onSurface.withOpacity(0.6)),
                                    ),
                                    SizedBox(height: 6),
                                    Wrap(
                                      spacing: 6,
                                      runSpacing: 6,
                                      children:
                                          (item.regularDays ?? []).map((v) {
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
                                            v.isNotEmpty
                                                ? v[0].toUpperCase() +
                                                    v.substring(1)
                                                : v,
                                            style: Get.textTheme.labelSmall!
                                                .copyWith(
                                                    color:
                                                        cs.onPrimaryContainer),
                                          ),
                                        );
                                      }).toList(),
                                    ),
                                  ],
                                ),

                                /// ACTIONS
                                actions: [
                                  CustomWidgets().iconBtn(
                                    icon: Icons.edit,
                                    color: cs.primary,
                                    onTap: () {
                                      // c.loadHiringAds(item);
                                      editHiringAd(context, ad: item);
                                    },
                                  ),
                                  SizedBox(width: 10),
                                  CustomWidgets().iconBtn(
                                    icon: Icons.delete,
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
                                                        color: Colors.white),
                                              ),
                                      ),
                                      title: 'Are you sure?',
                                      context: context,
                                      text:
                                          'Are you sure you want to delete this hiring ad?',
                                      onConfirm: () =>
                                          c.deleteHiringAd(item.id!),
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

  /// clean key-value row (replaces labelValue)
  Widget _info(ColorScheme cs, String label, String? value) {
    return Text(
      "$label: ${value ?? '-'}",
      style: Get.textTheme.labelMedium!
          .copyWith(color: cs.onSurface.withOpacity(0.7)),
    );
  }

  Widget _dateBox(BuildContext context, String label, String? value) {
    final cs = Get.theme.colorScheme;

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
            style: Get.textTheme.labelSmall!
                .copyWith(color: cs.onSurface.withOpacity(0.6)),
          ),
          SizedBox(height: 4),
          Text(
            value ?? '-',
            style: Get.textTheme.titleSmall,
          ),
        ],
      ),
    );
  }

  void editHiringAd(
    BuildContext context, {
    HiringAd? ad,
  }) {
    final isEdit = ad != null;
    final formKey = GlobalKey<FormState>();

    c.availableDays.assignAll(
      Days.values.where((e) => e != Days.all),
    );

    if (!isEdit) {
      c.nameController.clear();
      c.timeController.clear();
      c.startDateController.clear();
      c.endDateController.clear();
      c.selectedDays.clear();
    }

    if (isEdit) {
      c.nameController.text = ad.package ?? '';
      c.timeController.text = ad.time ?? '';
      c.startDateController.text = ad.fromDate != null
          ? DateFormat('yyyy-MM-dd').format(ad.fromDate!)
          : '';

      c.endDateController.text =
          ad.toDate != null ? DateFormat('yyyy-MM-dd').format(ad.toDate!) : '';

      c.selectedDays.assignAll(
        (ad.regularDays ?? []).map((e) {
          return Days.values.firstWhere(
            (d) => d.name == e.toLowerCase(),
            orElse: () => Days.monday,
          );
        }).toList(),
      );
    }

    CustomWidgets().showCustomDialog(
      context: context,
      title: Text(isEdit ? 'Edit Hiring Ad' : 'Add Hiring Ad'),
      icon: isEdit ? Icons.edit : Icons.add,
      formKey: formKey,
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
                    isEdit ? "Update" : "Add",
                    style: TextStyle(color: Colors.white),
                  ),
          ),
        ),
      ),

      sections: [
        Obx(
          () => InkWell(
            borderRadius: BorderRadius.circular(14),
            onTap: () async {
              await c.pickHiringAdImage();
            },
            child: ClipRRect(
              borderRadius: BorderRadius.circular(14),
              child: Stack(
                alignment: Alignment.center,
                children: [
                  /// IMAGE
                  Container(
                    height: 180,
                    width: double.infinity,
                    color:
                        Theme.of(context).colorScheme.surfaceContainerHighest,
                    child: c.selectedHiringAdImage.value != null

                        /// NEWLY PICKED IMAGE
                        ? Image.memory(
                            c.selectedHiringAdImage.value!,
                            fit: BoxFit.cover,
                          )

                        /// EXISTING IMAGE (EDIT)
                        : ad?.image != null
                            ? Image.network(
                                ad!.image!,
                                fit: BoxFit.cover,
                                errorBuilder: (_, __, ___) => const SizedBox(),
                              )

                            /// EMPTY STATE
                            : null,
                  ),

                  /// DARK OVERLAY
                  Positioned.fill(
                    child: Container(
                      color: Colors.black.withOpacity(.28),
                    ),
                  ),

                  /// CONTENT
                  Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        Icons.cloud_upload_outlined,
                        color: Colors.white,
                        size: 34,
                      ),
                      SizedBox(height: 8),
                      Text(
                        c.selectedHiringAdImage.value != null
                            ? 'Change Image'
                            : ad != null
                                ? 'Tap to Change Image'
                                : 'Upload Image',
                        style: Theme.of(context).textTheme.titleSmall!.copyWith(
                              color: Colors.white,
                              fontWeight: FontWeight.w600,
                            ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
        SizedBox(height: 10),
        CustomWidgets().labelWithAsterisk('Package', required: true),
        SizedBox(height: 10),
        CustomWidgets().dropdownStyledTextField(
          context: context,
          hint: '',
          controller: c.nameController,
        ),
        SizedBox(height: 10),
        CustomWidgets().labelWithAsterisk('Time', required: true),
        SizedBox(height: 10),
        CustomWidgets().dropdownStyledTextField(
          context: context,
          hint: '',
          controller: c.timeController,
        ),
        SizedBox(height: 10),
        CustomWidgets().labelWithAsterisk('From Date', required: true),
        SizedBox(height: 10),
        CustomWidgets().dropdownStyledTextField(
          context: context,
          hint: '',
          controller: c.startDateController,
        ),
        SizedBox(height: 10),
        CustomWidgets().labelWithAsterisk('To Date', required: true),
        SizedBox(height: 10),
        CustomWidgets().dropdownStyledTextField(
          context: context,
          hint: '',
          controller: c.endDateController,
        ),
        SizedBox(height: 10),
        CustomWidgets().labelWithAsterisk('Regular Days', required: true),
        SizedBox(height: 10),
        Obx(() => MultiSelector<Days>(
              items: c.availableDays,
              allValue: Days.all,
              initial: List<Days>.from(c.selectedDays),
              labelBuilder: (v) => v.name.isNotEmpty
                  ? v.name[0].toUpperCase() + v.name.substring(1)
                  : v.name,
              onChanged: (val) {
                c.selectedDays.assignAll(val);
              },
            )),
      ],

      /// =========================
      /// SUBMIT
      /// =========================
      onSubmit: () {
        final body = {
          "package": c.nameController.text.trim(),
          "time": c.timeController.text.trim(),
          "from_date": c.startDateController.text.trim(),
          "to_date": c.endDateController.text.trim(),
          "regular_days": c.selectedDays.map((e) => e.name).toList(),
        };

        if (isEdit) {
          c.updateHiringAd(id: ad.id!, body: body);
        } else {
          c.addHiringAd(body: body);
        }
      },
    );
  }
}
