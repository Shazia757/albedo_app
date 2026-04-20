import 'package:albedo_app/controller/settings_controller.dart';
import 'package:albedo_app/model/banners_model.dart';
import 'package:albedo_app/widgets/responsive.dart';
import 'package:albedo_app/widgets/widgets.dart';
import 'package:albedo_app/widgets/custom_appbar.dart';
import 'package:albedo_app/widgets/drawer_menu.dart';
import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:get/get.dart';

class BannerAdsPage extends StatelessWidget {
  final c = Get.put(SettingsController());

  BannerAdsPage({super.key});

  @override
  Widget build(BuildContext context) {
    final isDesktop = Responsive.isDesktop(context);

    return Scaffold(
      appBar: const CustomAppBar(),
      backgroundColor: Theme.of(context).colorScheme.onPrimary,
      floatingActionButton: addBannerBtn(context),
      body: Row(
        children: [
          if (isDesktop) const DrawerMenu(),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Obx(() {
                final data = c.banners;
                int crossAxisCount = 1;

                if (c.isLoading.value) {
                  return const Center(child: CircularProgressIndicator());
                }
                if (data.isEmpty) {
                  return const Center(child: Text("No banners found"));
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
                          visibleTo: item.visibleTo,
                          actions: [
                            CustomWidgets().iconBtn(
                              icon: Icons.edit,
                              color: Theme.of(context).colorScheme.primary,
                              onTap: () {
                                c.loadBanners(item);
                                editBanner(context);
                              },
                            ),
                            CustomWidgets().iconBtn(
                              icon: Icons.delete,
                              color: Theme.of(context).colorScheme.error,
                              onTap: () => CustomWidgets().showDeleteDialog(
                                context: context,
                                text:
                                    'Are you sure you want to delete this action?',
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

  void editBanner(BuildContext context) {
    CustomWidgets().showCustomDialog(
      context: context,
      title: Text('Edit Banner'),
      icon: Icons.edit,
      formKey: GlobalKey<FormState>(),
      sections: [
        Container(),
        const SizedBox(height: 10),
        CustomWidgets().labelWithAsterisk('Redirect URL'),
        const SizedBox(height: 10),
        CustomWidgets().dropdownStyledTextField(
            context: context, hint: '', controller: c.urlController),
        const SizedBox(height: 10),
        CustomWidgets().labelWithAsterisk('From Date'),
        const SizedBox(height: 10),
        CustomWidgets().dropdownStyledTextField(
            context: context, hint: '', controller: c.startDateController),
        const SizedBox(height: 10),
        CustomWidgets().labelWithAsterisk('To Date'),
        const SizedBox(height: 10),
        CustomWidgets().dropdownStyledTextField(
            context: context, hint: '', controller: c.endDateController),
        const SizedBox(height: 10),
        CustomWidgets().labelWithAsterisk('Visible To:'),
        const SizedBox(height: 10),
        VisibleToSelector(
          c: c,
          initial: List<VisibleTo>.from(c.selected),
          onChanged: (val) {
            c.selected.assignAll(val);
          },
        ),
      ],
      onSubmit: () {},
    );
  }

  FloatingActionButton addBannerBtn(BuildContext context) {
    return FloatingActionButton(
      onPressed: () => CustomWidgets().showCustomDialog(
        context: context,
        title: Text("Add Banner"),
        formKey: GlobalKey<FormState>(),
        onSubmit: () {},
        sections: [
          SizedBox(
            height: MediaQuery.of(context).size.height * 0.75,
            child: SingleChildScrollView(
              child: Column(
                children: [
                  Obx(
                    () => Row(
                      children: [
                        Expanded(
                          child: RadioListTile(
                            dense: true,
                            title: Text('Regular Banner'),
                            value: BannerType.regularBanner,
                            groupValue: c.selectedType.value,
                            onChanged: (value) {
                              if (value != null) {
                                c.selectedType.value = value;
                              }
                            },
                          ),
                        ),
                        Expanded(
                          child: RadioListTile(
                            dense: true,
                            title: Text('Default Banner'),
                            value: BannerType.defaultBanner,
                            groupValue: c.selectedType.value,
                            onChanged: (value) {
                              if (value != null) {
                                c.selectedType.value = value;
                              }
                            },
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 10),
                  Obx(() {
                    if (c.selectedType.value == BannerType.regularBanner) {
                      return Column(
                        children: [
                          Container(),
                          const SizedBox(height: 10),
                          CustomWidgets().labelWithAsterisk('Redirect URL'),
                          const SizedBox(height: 10),
                          CustomWidgets().dropdownStyledTextField(
                              context: context,
                              hint: '',
                              controller: c.urlController),
                          const SizedBox(height: 10),
                          CustomWidgets().labelWithAsterisk('From Date'),
                          const SizedBox(height: 10),
                          CustomWidgets().dropdownStyledTextField(
                              context: context,
                              hint: '',
                              controller: c.startDateController),
                          const SizedBox(height: 10),
                          CustomWidgets().labelWithAsterisk('To Date'),
                          const SizedBox(height: 10),
                          CustomWidgets().dropdownStyledTextField(
                              context: context,
                              hint: '',
                              controller: c.endDateController),
                          const SizedBox(height: 10),
                          CustomWidgets().labelWithAsterisk('Visible To:'),
                          const SizedBox(height: 10),
                          VisibleToSelector(
                            c: c,
                            initial: List<VisibleTo>.from(c.selected),
                            onChanged: (val) {
                              c.selected.assignAll(val);
                            },
                          ),
                        ],
                      );
                    }
                    if (c.selectedType.value == BannerType.defaultBanner) {
                      return Column(
                        children: [
                          Container(),
                          const SizedBox(height: 10),
                          CustomWidgets().labelWithAsterisk('Redirect URL'),
                          const SizedBox(height: 10),
                          CustomWidgets().dropdownStyledTextField(
                              context: context,
                              hint: '',
                              controller: c.urlController),
                          const SizedBox(height: 10),
                          CustomWidgets().labelWithAsterisk('Visible To:'),
                          const SizedBox(height: 10),
                          VisibleToSelector(
                            c: c,
                            initial: List<VisibleTo>.from(c.selected),
                            onChanged: (val) {
                              c.selected.assignAll(val);
                            },
                          ),
                        ],
                      );
                    }
                    return const SizedBox();
                  })
                ],
              ),
            ),
          ),
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

class CustomCard extends StatelessWidget {
  final String? title;
  final String? description;
  final bool isImportant;
  final List<Widget>? actions;
  final List<VisibleTo> visibleTo;
  final SettingsController c;

  const CustomCard({
    super.key,
    this.title,
    this.description,
    required this.c,
    this.isImportant = false,
    this.actions,
    required this.visibleTo,
  });

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: cs.surface,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: cs.outlineVariant),
        boxShadow: [
          BoxShadow(
            color: cs.shadow.withOpacity(0.05),
            blurRadius: 20,
            offset: const Offset(0, 10),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          /// 🔥 Header
          Row(
            children: [
              if (isImportant)
                Container(
                  margin: const EdgeInsets.only(right: 8),
                  padding: const EdgeInsets.all(6),
                  decoration: BoxDecoration(
                    color: cs.errorContainer,
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Icon(Icons.priority_high,
                      size: 16, color: cs.onErrorContainer),
                ),
              Expanded(
                child: Text(
                  title ?? '',
                  style: const TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ],
          ),

          const SizedBox(height: 8),

          Text(
            description ?? '',
            maxLines: 3,
            overflow: TextOverflow.ellipsis,
            style: TextStyle(
              fontSize: 13,
              color: cs.onSurface.withOpacity(0.7),
            ),
          ),
          const SizedBox(height: 10),
          Text(
            'Shown in:',
            style: TextStyle(
              fontSize: 11,
              color: cs.onSurface.withOpacity(0.9),
            ),
          ),

          /// 🔥 Visible To Chips
          if ((visibleTo ?? []).isNotEmpty) ...[
            const SizedBox(height: 10),
            Wrap(
              spacing: 6,
              runSpacing: 6,
              children: (visibleTo ?? []).map((v) {
                return Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                  decoration: BoxDecoration(
                    color: cs.primaryContainer.withOpacity(0.6),
                    borderRadius:
                        BorderRadius.circular(50), // 🔥 fully rounded pill
                  ),
                  child: Text(
                    c.getLabel(v),
                    style: TextStyle(
                      fontSize: 10, // 🔥 smaller text
                      fontWeight: FontWeight.w500,
                      color: cs.onPrimaryContainer,
                    ),
                  ),
                );
              }).toList(),
            ),
          ],
          const SizedBox(height: 12),

          /// 🔥 Actions
          if (actions != null && actions!.isNotEmpty)
            Align(
              alignment: Alignment.centerRight,
              child: Wrap(
                spacing: 6,
                children: actions!,
              ),
            ),
        ],
      ),
    );
  }
}

class VisibleToSelector extends StatefulWidget {
  final SettingsController c;
  final List<VisibleTo> initial;
  final Function(List<VisibleTo>) onChanged;

  const VisibleToSelector({
    super.key,
    required this.c,
    required this.initial,
    required this.onChanged,
  });

  @override
  State<VisibleToSelector> createState() => _VisibleToSelectorState();
}

class _VisibleToSelectorState extends State<VisibleToSelector> {
  late List<VisibleTo> selected;

  @override
  void initState() {
    super.initState();
    selected = List<VisibleTo>.from(widget.initial);
  }

  void toggle(VisibleTo value) {
    setState(() {
      final allExceptAll =
          VisibleTo.values.where((e) => e != VisibleTo.all).toList();

      if (value == VisibleTo.all) {
        if (selected.contains(VisibleTo.all)) {
          selected.clear();
        } else {
          selected = List<VisibleTo>.from(VisibleTo.values);
        }
      } else {
        selected.remove(VisibleTo.all);

        if (selected.contains(value)) {
          selected.remove(value);
        } else {
          selected.add(value);
        }

        // auto select ALL if everything selected
        if (selected.toSet().containsAll(allExceptAll)) {
          selected = [VisibleTo.all];
        }
      }
    });

    widget.onChanged(List<VisibleTo>.from(selected));
  }

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Wrap(
          spacing: 10,
          runSpacing: 6,
          children: VisibleTo.values.map((v) {
            final isSelected = selected.contains(v);

            return InkWell(
              borderRadius: BorderRadius.circular(10),
              onTap: () => toggle(v),
              child: Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                decoration: BoxDecoration(
                  color: isSelected ? cs.primaryContainer : cs.surfaceVariant,
                  borderRadius: BorderRadius.circular(10),
                  border: Border.all(
                    color: isSelected ? cs.primary : cs.outlineVariant,
                  ),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(
                      isSelected
                          ? Icons.check_box
                          : Icons.check_box_outline_blank,
                      size: 18,
                      color: isSelected ? cs.primary : cs.onSurfaceVariant,
                    ),
                    const SizedBox(width: 6),
                    Text(
                      widget.c.getLabel(v),
                      style: const TextStyle(fontSize: 13),
                    ),
                  ],
                ),
              ),
            );
          }).toList(),
        ),
      ],
    );
  }
}
