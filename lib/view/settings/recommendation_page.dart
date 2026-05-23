import 'package:albedo_app/controller/settings_controller.dart';
import 'package:albedo_app/model/batch_model.dart';
import 'package:albedo_app/model/package_model.dart';
import 'package:albedo_app/model/settings/recommendations_model.dart';
import 'package:albedo_app/model/settings/syllabus_model.dart';
import 'package:albedo_app/view/settings/banner_ads_page.dart';
import 'package:albedo_app/widgets/responsive.dart';
import 'package:albedo_app/widgets/widgets.dart';
import 'package:albedo_app/widgets/custom_appbar.dart';
import 'package:albedo_app/widgets/drawer_menu.dart';
import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

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
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          await c.getSyllabuses();
          await c.getPackageNames();
          await c.fetchBatches();
          editRecommendation(context);
        },
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
                final data = c.recommendations;

                if (c.isLoading.value) {
                  return Center(child: CircularProgressIndicator());
                }

                if (data.isEmpty) {
                  return Center(child: Text("No recommendations found"));
                }

                return Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "Recommendations",
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

                              final isPackage = item.type == "package";

                              final title = item.title ?? "-";

                              final visibleTo = item.syllabuses;

                              final startDate = item.fromDate != null
                                  ? DateFormat('dd MMM yyyy')
                                      .format(item.fromDate!)
                                  : "-";

                              final endDate = item.toDate != null
                                  ? DateFormat('dd MMM yyyy')
                                      .format(item.toDate!)
                                  : "-";
                              return CustomCard(
                                c: c,

                                /// CONTENT
                                content: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    ClipRRect(
                                      borderRadius: BorderRadius.circular(14),
                                      child: Image.network(
                                        item.image ?? '',
                                        height: 160,
                                        width: double.infinity,
                                        fit: BoxFit.cover,
                                        errorBuilder: (_, __, ___) {
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
                                    Text(
                                      isPackage ? 'Package Name' : 'Batch Name',
                                      style: Theme.of(context)
                                          .textTheme
                                          .labelSmall!
                                          .copyWith(
                                            color:
                                                cs.onSurface.withOpacity(0.6),
                                          ),
                                    ),
                                    SizedBox(height: 4),

                                    Text(
                                      title,
                                      style: Theme.of(context)
                                          .textTheme
                                          .titleMedium!
                                          .copyWith(
                                              fontWeight: FontWeight.w600),
                                    ),

                                    SizedBox(height: 12),

                                    Text(
                                      "Syllabuses",
                                      style: Theme.of(context)
                                          .textTheme
                                          .labelSmall!
                                          .copyWith(
                                              color: cs.onSurface
                                                  .withOpacity(0.6)),
                                    ),
                                    SizedBox(height: 6),

                                    Wrap(
                                      spacing: 6,
                                      runSpacing: 6,
                                      children: visibleTo.map((v) {
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
                                            style: Theme.of(context)
                                                .textTheme
                                                .labelSmall!
                                                .copyWith(
                                                    color:
                                                        cs.onPrimaryContainer),
                                          ),
                                        );
                                      }).toList(),
                                    ),

                                    SizedBox(height: 12),

                                    /// DATES (clean unified style)
                                    Row(
                                      children: [
                                        Expanded(
                                          child: _dateBox(
                                            context,
                                            "From",
                                            startDate ?? "-",
                                          ),
                                        ),
                                        SizedBox(width: 10),
                                        Expanded(
                                          child: _dateBox(
                                            context,
                                            "To",
                                            endDate ?? "-",
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
                                    onTap: () async {
                                      await c.getSyllabuses();
                                      await c.getPackageNames();
                                      await c.fetchBatches();

                                      editRecommendation(Get.context!,
                                          recommendation: item);
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
                                          'Are you sure you want to delete this recommendation?',
                                      onConfirm: () =>
                                          c.deleteRecommendation(item.id ?? ''),
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
            style: Theme.of(context)
                .textTheme
                .labelSmall!
                .copyWith(color: cs.onSurface.withOpacity(0.6)),
          ),
          SizedBox(height: 4),
          Text(
            value,
            style: Theme.of(context).textTheme.titleSmall,
          ),
        ],
      ),
    );
  }

  void editRecommendation(BuildContext context,
      {RecommendationItem? recommendation}) {
    final isEdit = recommendation != null;
    final formKey = GlobalKey<FormState>();

    /// preload
    if (isEdit) {
      /// recommendation type
      c.selectedRecommendationType.value = recommendation.type ?? 'package';

      c.selectedPackage.value = c.packageNames.firstWhereOrNull(
        (e) =>
            (e.name ?? '').trim().toLowerCase() ==
            (recommendation.recommendedPackage ?? '').trim().toLowerCase(),
      );

      c.selectedBatch.value = c.batches.firstWhereOrNull(
        (e) =>
            (e.name ?? '').trim().toLowerCase() ==
            (recommendation.recommendedBatch ?? '').trim().toLowerCase(),
      );

      /// dates
      c.startDateController.text = recommendation.fromDate != null
          ? DateFormat('yyyy-MM-dd').format(recommendation.fromDate!)
          : '';

      c.endDateController.text = recommendation.toDate != null
          ? DateFormat('yyyy-MM-dd').format(recommendation.toDate!)
          : '';

      /// selected syllabuses
      c.selectedSyllabus.assignAll(
        c.syllabus.where((e) => recommendation.syllabuses.contains(e.name)),
      );

      /// image
      c.selectedRecommendationImage.value = null;
      c.selectedRecommendationFile = null;
    } else {
      /// recommendation type
      c.selectedRecommendationType.value = 'package';

      /// dates
      c.startDateController.clear();
      c.endDateController.clear();

      /// syllabuses
      c.selectedSyllabus.clear();

      /// image
      c.selectedRecommendationImage.value = null;
      c.selectedRecommendationFile = null;
    }

    final allItem = Syllabus(
      id: 'all',
      name: 'All',
    );

    CustomWidgets().showCustomDialog(
      context: context,
      title: Text(
        isEdit ? 'Edit Recommendation' : 'Add Recommendation',
      ),
      icon: isEdit ? Icons.edit : Icons.add,
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
      formKey: formKey,
      sections: [
        Obx(
          () => InkWell(
            borderRadius: BorderRadius.circular(14),
            onTap: () async {
              await c.pickRecommendationImage();
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
                    child: c.selectedRecommendationImage.value != null

                        /// NEWLY PICKED IMAGE
                        ? Image.memory(
                            c.selectedRecommendationImage.value!,
                            fit: BoxFit.cover,
                          )

                        /// EXISTING IMAGE (EDIT)
                        : recommendation?.image != null
                            ? Image.network(
                                recommendation!.image!,
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
                        c.selectedRecommendationImage.value != null
                            ? 'Change Image'
                            : recommendation != null
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
        CustomWidgets()
            .labelWithAsterisk('Select recommendation Type', required: true),
        SizedBox(height: 10),
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
        SizedBox(height: 10),
        Obx(() {
          if (c.selectedRecommendationType.value == 'package') {
            return Column(
              children: [
                CustomWidgets()
                    .labelWithAsterisk('Recommended Package', required: true),
                SizedBox(height: 10),
                Obx(
                  () => CustomWidgets().customDropdownField<Syllabus>(
                    context: context,
                    hint: 'Select Package',
                    items: c.packageNames,
                    value: c.selectedPackage.value,
                    initialValue: c.selectedPackage.value,
                    itemLabel: (p) => p.name ?? "",
                    onChanged: (p0) => c.selectedPackage.value = p0,
                  ),
                ),
              ],
            );
          }
          if (c.selectedRecommendationType.value == 'batch') {
            return Column(
              children: [
                CustomWidgets()
                    .labelWithAsterisk('Recommended Batch', required: true),
                SizedBox(height: 10),
                Obx(
                  () => CustomWidgets().customDropdownField<BatchDetail>(
                    context: context,
                    hint: 'Select Batch',
                    items: c.batches,
                    value: c.selectedBatch.value,
                    itemLabel: (s) => s.name ?? '',
                    onChanged: (batch) => c.selectedBatch.value = batch,
                  ),
                ),
              ],
            );
          }
          return SizedBox();
        }),
        SizedBox(height: 10),
        CustomWidgets().labelWithAsterisk('Start Date'),
        SizedBox(height: 10),
        CustomWidgets().customStyledDatePickerField(
            context: context,
            controller: c.startDateController,
            firstDate: DateTime.now(),
            lastDate: DateTime.now().add(
              const Duration(days: 365 * 3),
            ),
            onDateSelected: (date) {
              c.selectedStartDate.value = date;
            },
            initialDate: c.selectedStartDate.value),
        SizedBox(height: 10),
        CustomWidgets().labelWithAsterisk('End Date'),
        SizedBox(height: 10),
        CustomWidgets().customStyledDatePickerField(
            context: context,
            controller: c.endDateController,
            firstDate: DateTime.now(),
            lastDate: DateTime.now().add(
              const Duration(days: 365 * 3),
            ),
            onDateSelected: (date) {
              c.selectedEndDate.value = date;
            },
            initialDate: c.selectedEndDate.value),
        SizedBox(height: 10),
        CustomWidgets().labelWithAsterisk('Visible To Syllabuses'),
        SizedBox(height: 10),
        MultiSelector(
          items: c.syllabus,
          initial: List.from(c.selectedSyllabus),
          allValue: allItem,
          labelBuilder: (v) => v.name ?? '',
          onChanged: (val) {
            final hasAll = val.any((e) => e.id == 'all');

            if (hasAll) {
              c.selectedSyllabus.assignAll(c.syllabus);
            } else {
              c.selectedSyllabus.assignAll(val);
            }
          },
        )
      ],
      onSubmit: () async {
        /// image validation (only for add)
        if (!isEdit && c.selectedRecommendationFile == null) {
          Get.snackbar('Error', 'Please upload an image');
          return;
        }

        /// package / batch validation
        if (c.selectedRecommendationType.value == 'package' &&
            c.selectedPackage.value == null) {
          Get.snackbar('Error', 'Please select a package');
          return;
        }

        if (c.selectedRecommendationType.value == 'batch' &&
            c.selectedBatch.value == null) {
          Get.snackbar(
            'Error',
            'Please select a batch',
          );
          return;
        }

        /// syllabus validation
        if (c.selectedSyllabus.isEmpty) {
          Get.snackbar(
            'Error',
            'Please select at least one syllabus',
          );
          return;
        }

        /// date validation
        if (c.selectedEndDate.value != null &&
            c.selectedStartDate.value != null &&
            c.selectedEndDate.value!.isBefore(c.selectedStartDate.value!)) {
          Get.snackbar('Error', 'End date must be after start date');
          return;
        }

        final body = {
          "type": c.selectedRecommendationType.value,

          /// package/batch
          if (c.selectedRecommendationType.value == 'package')
            "recommended_package": c.selectedPackage.value?.id,

          if (c.selectedRecommendationType.value == 'batch')
            "recommended_batch": c.selectedBatch.value?.id,

          /// dates
          "from_date": c.startDateController.text.trim(),
          "to_date": c.endDateController.text.trim(),

          /// syllabuses
          "show_to_syllabuses": c.selectedSyllabus.map((e) => e.id).toList(),
        };

        if (isEdit) {
          await c.updateRecommendation(
            id: recommendation.id ?? '',
            body: body,
          );
        } else {
          await c.addRecommendation(
            body: body,
          );
        }
      },
    );
  }
}
