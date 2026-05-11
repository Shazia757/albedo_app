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

class HiringPage extends StatelessWidget {
  final c = Get.put(SettingsController());

  HiringPage({super.key});

  @override
  Widget build(BuildContext context) {
    final isDesktop = Responsive.isDesktop(context);
    final cs = Theme.of(context).colorScheme;

    return Scaffold(
      appBar: const CustomAppBar(),
      backgroundColor: cs.surface,
      floatingActionButton: addHiringAdBtn(context),
      body: Row(
        children: [
          if (isDesktop) const DrawerMenu(),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Obx(() {
                final data = c.hiringAd;

                if (c.isLoading.value) {
                  return const Center(child: CircularProgressIndicator());
                }

                if (data.isEmpty) {
                  return const Center(child: Text("No hiring ads found"));
                }

                return Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    /// TITLE (outside cards)
                    Text(
                      "Hiring Ads",
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

                              return CustomCard(
                                c: c,

                                /// CONTENT
                                content: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    _info(cs, "Package", item.package),
                                    const SizedBox(height: 10),
                                    _info(cs, "Time", item.time),
                                    const SizedBox(height: 10),
                                    Row(
                                      children: [
                                        Expanded(
                                          child: _dateBox(
                                            context,
                                            "From",
                                            item.startDate,
                                          ),
                                        ),
                                        const SizedBox(width: 10),
                                        Expanded(
                                          child: _dateBox(
                                            context,
                                            "To",
                                            item.endDate,
                                          ),
                                        ),
                                      ],
                                    ),
                                    const SizedBox(height: 12),
                                    Text(
                                      "Regular Days",
                                      style: TextStyle(
                                        fontSize: 11,
                                        color: cs.onSurface.withOpacity(0.6),
                                      ),
                                    ),
                                    const SizedBox(height: 6),
                                    Wrap(
                                      spacing: 6,
                                      runSpacing: 6,
                                      children: (item.days ?? []).map((v) {
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
                                            v.name.isNotEmpty
                                                ? v.name[0].toUpperCase() +
                                                    v.name.substring(1)
                                                : v.name,
                                            style: TextStyle(
                                              fontSize: 11,
                                              color: cs.onPrimaryContainer,
                                            ),
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
                                      c.loadHiringAds(item);
                                      editHiringAd(context);
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
                                          'Are you sure you want to delete this hiring ad?',
                                      onConfirm: () => c.delete(item.adId),
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
      style: TextStyle(
        fontSize: 12,
        color: cs.onSurface.withOpacity(0.7),
        fontWeight: FontWeight.w500,
      ),
    );
  }

  Widget _dateBox(BuildContext context, String label, String? value) {
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
            value ?? '-',
            style: const TextStyle(fontWeight: FontWeight.w600),
          ),
        ],
      ),
    );
  }

  void editHiringAd(BuildContext context) {
    CustomWidgets().showCustomDialog(
      context: context,
      title: Text('Edit Hiring Ad'),
      icon: Icons.edit,
      formKey: GlobalKey<FormState>(),
      sections: [
        Container(),
        const SizedBox(height: 10),
        CustomWidgets().labelWithAsterisk('Package', required: true),
        const SizedBox(height: 10),
        CustomWidgets().dropdownStyledTextField(
          context: context,
          hint: '',
          controller: c.nameController,
        ),
        const SizedBox(height: 10),
        CustomWidgets().labelWithAsterisk('Time', required: true),
        const SizedBox(height: 10),
        CustomWidgets().dropdownStyledTextField(
          context: context,
          hint: '',
          controller: c.timeController,
        ),
        const SizedBox(height: 10),
        CustomWidgets().labelWithAsterisk('From Date', required: true),
        const SizedBox(height: 10),
        CustomWidgets().dropdownStyledTextField(
          context: context,
          hint: '',
          controller: c.startDateController,
        ),
        const SizedBox(height: 10),
        CustomWidgets().labelWithAsterisk('To Date', required: true),
        const SizedBox(height: 10),
        CustomWidgets().dropdownStyledTextField(
          context: context,
          hint: '',
          controller: c.endDateController,
        ),
        const SizedBox(height: 10),
        CustomWidgets().labelWithAsterisk('Regular Days', required: true),
        const SizedBox(height: 10),
        MultiSelector<Days>(
          items: Days.values.where((e) => e != Days.all).toList(),
          allValue: Days.all,
          initial: List<Days>.from(c.selectedDays),
          labelBuilder: (v) => v.name.isNotEmpty
              ? v.name[0].toUpperCase() + v.name.substring(1)
              : v.name,
          onChanged: (val) {
            c.selectedDays.assignAll(val);
          },
        )
      ],
      onSubmit: () {},
    );
  }

  FloatingActionButton addHiringAdBtn(BuildContext context) {
    return FloatingActionButton(
      onPressed: () => CustomWidgets().showCustomDialog(
        context: context,
        title: Text("Add Hiring Ad"),
        formKey: GlobalKey<FormState>(),
        onSubmit: () {},
        sections: [
          Container(),
          const SizedBox(height: 10),
          CustomWidgets().labelWithAsterisk('Package', required: true),
          const SizedBox(height: 10),
          CustomWidgets().dropdownStyledTextField(context: context, hint: ''),
          const SizedBox(height: 10),
          CustomWidgets().labelWithAsterisk('Time', required: true),
          const SizedBox(height: 10),
          CustomWidgets().dropdownStyledTextField(context: context, hint: ''),
          const SizedBox(height: 10),
          CustomWidgets().labelWithAsterisk('From Date', required: true),
          const SizedBox(height: 10),
          CustomWidgets().dropdownStyledTextField(context: context, hint: ''),
          const SizedBox(height: 10),
          CustomWidgets().labelWithAsterisk('To Date', required: true),
          const SizedBox(height: 10),
          CustomWidgets().dropdownStyledTextField(context: context, hint: ''),
          const SizedBox(height: 10),
          CustomWidgets().labelWithAsterisk('Regular Days', required: true),
          const SizedBox(height: 10),
          MultiSelector<Days>(
            items: Days.values.where((e) => e != Days.all).toList(),
            allValue: Days.all,
            initial: [],
            labelBuilder: (v) => v.name.isNotEmpty
                ? v.name[0].toUpperCase() + v.name.substring(1)
                : v.name,
            onChanged: (val) {
              c.selectedDays.assignAll(val);
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
