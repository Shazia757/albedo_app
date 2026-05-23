import 'package:albedo_app/config/urls.dart';
import 'package:albedo_app/controller/permissions_controller.dart';
import 'package:albedo_app/controller/settings_controller.dart';
import 'package:albedo_app/model/settings/banners_model.dart';
import 'package:albedo_app/widgets/home_widgets.dart';
import 'package:albedo_app/widgets/responsive.dart';
import 'package:albedo_app/widgets/video_widget.dart';
import 'package:albedo_app/widgets/widgets.dart';
import 'package:albedo_app/widgets/custom_appbar.dart';
import 'package:albedo_app/widgets/drawer_menu.dart';
import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:url_launcher/url_launcher.dart';

class BannerAdsPage extends StatelessWidget {
  BannerAdsPage({super.key});

  final SettingsController c = Get.find<SettingsController>();

  @override
  Widget build(BuildContext context) {
    final isDesktop = Responsive.isDesktop(context);

    return Scaffold(
      appBar: const CustomAppBar(),
      backgroundColor: Theme.of(context).colorScheme.surface,
      floatingActionButton: FloatingActionButton(
        onPressed: () => editBanner(context),
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
              padding: const EdgeInsets.fromLTRB(16, 16, 16, 24),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  /// ── PAGE TITLE ─────────────────────
                  Text(
                    "Banner Advertisements",
                    style: Theme.of(context).textTheme.titleLarge?.copyWith(
                        fontWeight: FontWeight.w700,
                        color: Theme.of(context).colorScheme.primary),
                  ),

                  SizedBox(height: 24),

                  /// ── CONTENT ────────────────────────
                  Expanded(
                    child: Obx(() {
                      final data = c.banners;

                      if (c.isLoading.value) {
                        return Center(
                          child: CircularProgressIndicator(),
                        );
                      }

                      if (data.isEmpty) {
                        return Center(
                          child: Text("No banners found"),
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
                            physics: const BouncingScrollPhysics(),
                            itemBuilder: (_, i) {
                              final item = data[i];

                              return CustomCard(
                                onTap: () => showBannerDetail(context, item),
                                title: item.url,
                                hasImage: true,
                                c: c,
                                visibleTo: item.dashboardTarget
                                    ?.map((e) => c.visibleToFromString(e))
                                    .toList(),
                                actions: [
                                  CustomWidgets().iconBtn(
                                    icon: Icons.edit,
                                    color:
                                        Theme.of(context).colorScheme.primary,
                                    onTap: () {
                                      editBanner(context, banner: item);
                                    },
                                  ),
                                  SizedBox(width: 10),
                                  CustomWidgets().iconBtn(
                                    icon: Icons.delete,
                                    color: Theme.of(context).colorScheme.error,
                                    onTap: () {
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
                                            'Are you sure you want to delete this action?',
                                        onConfirm: () =>
                                            c.deleteBanner(id: item.id!),
                                      );
                                    },
                                  ),
                                ],
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

  void editBanner(
    BuildContext context, {
    Banners? banner,
  }) {
    final isEdit = banner != null;

    final mediaUrl = isEdit ? getBannerMediaUrl(banner!.media) : '';

    if (isEdit) {
      c.urlController.text = banner!.url ?? '';

      c.startDateController.text = banner.fromDate != null
          ? DateFormat('yyyy-MM-dd').format(banner.fromDate!)
          : '';

      c.endDateController.text = banner.toDate != null
          ? DateFormat('yyyy-MM-dd').format(banner.toDate!)
          : '';

      c.selectedStartDate.value = banner.fromDate;
      c.selectedEndDate.value = banner.toDate;

      c.selected.assignAll(
        (banner.dashboardTarget ?? [])
            .map((e) => VisibleToExtension.fromString(e))
            .toList(),
      );
    } else {
      c.urlController.clear();
      c.startDateController.clear();
      c.endDateController.clear();
      c.selected.clear();
    }

    CustomWidgets().showCustomDialog(
      context: context,
      title: Text(isEdit ? 'Edit Banner' : 'Add Banner'),
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
      icon: isEdit ? Icons.edit : Icons.add,
      formKey: GlobalKey<FormState>(),
      sections: [
        isEdit && mediaUrl.isNotEmpty
            ? buildMedia(mediaUrl)
            : InkWell(
                borderRadius: BorderRadius.circular(12),
                onTap: () async {
                  await c.pickMedia();
                },
                child: Obx(
                  () => Container(
                    height: 180,
                    width: double.infinity,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(
                        color: Theme.of(context)
                            .colorScheme
                            .outline
                            .withOpacity(0.18),
                        width: 1.2,
                      ),
                      color: Theme.of(context)
                          .colorScheme
                          .onPrimary
                          .withOpacity(0.8),
                    ),
                    child: c.selectedMedia.value != null
                        ? ClipRRect(
                            borderRadius: BorderRadius.circular(12),
                            child: c.isVideoFile(c.selectedMedia.value!.path)
                                ? Stack(
                                    alignment: Alignment.center,
                                    children: [
                                      Container(
                                        color: Colors.black12,
                                      ),
                                      const Icon(
                                        Icons.video_file,
                                        size: 60,
                                      ),
                                    ],
                                  )
                                : Image.file(
                                    c.selectedMedia.value!,
                                    fit: BoxFit.cover,
                                    width: double.infinity,
                                  ),
                          )
                        : Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(
                                Icons.cloud_upload_outlined,
                                size: 50,
                                color: Theme.of(context).colorScheme.primary,
                              ),
                              const SizedBox(height: 10),
                              Text(
                                'Select Image / Video',
                                style: Theme.of(context).textTheme.bodyMedium,
                              ),
                            ],
                          ),
                  ),
                ),
              ),
        const SizedBox(height: 10),
        CustomWidgets().labelWithAsterisk('Redirect URL'),
        const SizedBox(height: 10),
        CustomWidgets().dropdownStyledTextField(
          context: context,
          hint: 'Enter URL',
          controller: c.urlController,
        ),
        const SizedBox(height: 10),
        CustomWidgets().labelWithAsterisk('From Date'),
        const SizedBox(height: 10),
        CustomWidgets().customStyledDatePickerField(
            firstDate: DateTime.now(),
            lastDate: DateTime.now().add(
              const Duration(days: 365 * 3),
            ),
            onDateSelected: (p0) {
              c.selectedStartDate.value = p0;
            },
            initialDate: c.selectedStartDate.value,
            context: context,
            controller: c.startDateController),
        const SizedBox(height: 10),
        CustomWidgets().labelWithAsterisk('To Date'),
        const SizedBox(height: 10),
        CustomWidgets().customStyledDatePickerField(
            firstDate: DateTime.now(),
            lastDate: DateTime.now().add(
              const Duration(days: 365 * 3),
            ),
            onDateSelected: (p0) {
              c.selectedEndDate.value = p0;
            },
            initialDate: c.selectedEndDate.value,
            context: context,
            controller: c.endDateController),
        const SizedBox(height: 10),
        CustomWidgets().labelWithAsterisk('Visible To:'),
        const SizedBox(height: 10),
        Obx(
          () => Wrap(
            spacing: 10,
            runSpacing: 6,
            children:
                VisibleTo.values.where((v) => v != VisibleTo.admin).map((v) {
              final isSelected = c.selected.contains(v);

              return InkWell(
                borderRadius: BorderRadius.circular(10),
                onTap: () {
                  /// CLICKED ALL
                  if (v == VisibleTo.all) {
                    if (isSelected) {
                      /// unselect all
                      c.selected.clear();
                    } else {
                      /// select all except admin
                      c.selected.assignAll(
                        VisibleTo.values.where(
                          (e) => e != VisibleTo.admin,
                        ),
                      );
                    }
                  } else {
                    /// NORMAL SELECTION
                    if (isSelected) {
                      c.selected.remove(v);

                      /// remove ALL if any item unchecked
                      c.selected.remove(VisibleTo.all);
                    } else {
                      c.selected.add(v);

                      /// check if all individual items selected
                      final allItems = VisibleTo.values.where(
                        (e) => e != VisibleTo.admin && e != VisibleTo.all,
                      );

                      final hasAll = allItems.every(
                        (e) => c.selected.contains(e),
                      );

                      if (hasAll) {
                        c.selected.add(VisibleTo.all);
                      }
                    }
                  }

                  c.selected.refresh();
                },
                child: Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 10,
                    vertical: 6,
                  ),
                  decoration: BoxDecoration(
                    color: isSelected
                        ? Theme.of(context).colorScheme.primaryContainer
                        : Theme.of(context).colorScheme.surfaceContainerHighest,
                    borderRadius: BorderRadius.circular(10),
                    border: Border.all(
                      color: isSelected
                          ? Theme.of(context).colorScheme.primary
                          : Theme.of(context)
                              .colorScheme
                              .outline
                              .withOpacity(0.3),
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
                        color: isSelected
                            ? Theme.of(context).colorScheme.primary
                            : Theme.of(context).colorScheme.onSurfaceVariant,
                      ),
                      const SizedBox(width: 6),
                      Text(
                        c.getLabel(v),
                        style: Theme.of(context).textTheme.bodySmall,
                      ),
                    ],
                  ),
                ),
              );
            }).toList(),
          ),
        )
      ],
      onSubmit: () async {
        /// VALIDATIONS
        if (c.urlController.text.trim().isEmpty) {
          Get.snackbar("Error", 'Please enter redirect URL');
          return;
        }

        if (c.startDateController.text.trim().isEmpty) {
          Get.snackbar(
            "Error",
            'Please select from date',
          );
          return;
        }

        if (c.endDateController.text.trim().isEmpty) {
          Get.snackbar(
            "Error",
            'Please select to date',
          );
          return;
        }

        if (c.selected.isEmpty) {
          Get.snackbar(
            "Error",
            'Please select visible users',
          );
          return;
        }

        /// DATE VALIDATION
        final startDate = c.selectedStartDate.value;
        final endDate = c.selectedEndDate.value;

        if (startDate == null) {
          Get.snackbar(
            "Error",
            'Please select from date',
          );
          return;
        }

        if (endDate == null) {
          Get.snackbar(
            "Error",
            'Please select to date',
          );
          return;
        }

        if (startDate != null &&
            endDate != null &&
            endDate.isBefore(startDate)) {
          Get.snackbar(
            "Error",
            'To date must be after from date',
          );
          return;
        }

        try {
          c.isLoading.value = true;

          final body = {
            "url": c.urlController.text.trim(),
            "from_date": DateFormat('yyyy-MM-dd').format(startDate),
            "to_date": DateFormat('yyyy-MM-dd').format(endDate),
            "dashboard_target": c.selected.contains(VisibleTo.all)
                ? VisibleTo.values
                    .where((e) => e != VisibleTo.all && e != VisibleTo.admin)
                    .map((e) => e.name)
                    .toList()
                : c.selected
                    .where((e) => e != VisibleTo.all)
                    .map((e) => e.name)
                    .toList(),
          };

          if (isEdit) {
            await c.updateBanner(
              bannerId: banner!.id ?? '',
              body: body,
            );
          } else {
            await c.addBanner(body: body);
          }

          if (context.mounted) {
            Navigator.pop(context);

            Get.snackbar(
              'Success',
              isEdit
                  ? 'Banner updated successfully'
                  : 'Banner added successfully',
            );
          }
        } catch (e) {
          if (context.mounted) {
            Get.snackbar(
              "Error",
              e.toString(),
            );
          }
        } finally {
          c.isLoading.value = false;
        }
      },
    );
  }

  String getBannerMediaUrl(String? media) {
    if (media == null || media.isEmpty) return '';
    if (media.startsWith('http')) return media;
    return "https://api.albedoedu.com$media";
  }

  void showBannerDetail(
    BuildContext context,
    Banners banner,
  ) {
    final controller = Get.find<SettingsController>();
    final cs = Theme.of(context).colorScheme;
    final target = banner.dashboardTarget ?? [];
    final targets =
        target.map((e) => controller.visibleToFromString(e)).toList();
    final updatedAt = banner.dateUpdated != null
        ? DateFormat('dd MMM yyyy • hh:mm a').format(banner.dateUpdated!)
        : '—';

    CustomWidgets().showCustomDialog(
      context: context,
      title: Text("Ad Banner"),
      formKey: GlobalKey<FormState>(),
      isViewOnly: true,
      onSubmit: () {},
      sections: [
        Container(
          padding: const EdgeInsets.all(16),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(14),
            child: GestureDetector(
              onTap: () {
                openVideo('');
              },
              child: Stack(
                alignment: Alignment.center,
                children: [
                  // 🔹 Thumbnail / fallback
                  Image.network(
                    '',
                    fit: BoxFit.contain,
                    width: double.infinity,
                    height: 200,
                    errorBuilder: (context, error, stackTrace) {
                      return Image.asset(
                        'assets/images/logo.png',
                        fit: BoxFit.contain,
                        width: double.infinity,
                        height: 200,
                      );
                    },
                  ),

                  // 🔹 Play button overlay
                  Container(
                    decoration: BoxDecoration(
                      color: Colors.black45,
                      shape: BoxShape.circle,
                    ),
                    padding: const EdgeInsets.all(14),
                    child: const Icon(
                      Icons.play_arrow,
                      color: Colors.white,
                      size: 36,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
        InkWell(
          onTap: () async {
            final uri = Uri.parse(banner.url ?? "");

            if (await canLaunchUrl(uri)) {
              await launchUrl(
                uri,
                mode: LaunchMode.externalApplication,
              );
            }
          },
          child: Align(
            alignment: Alignment.centerLeft,
            child: Text(
              banner.url ?? "",
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    color: Theme.of(context).colorScheme.primary,
                  ),
            ),
          ),
        ),
        Row(
          children: [
            Icon(
              Icons.schedule,
              size: 16,
              color: cs.onSurface.withOpacity(0.5),
            ),
            const SizedBox(width: 6),
            Text(
              'Duration: $updatedAt',
              style: Theme.of(context).textTheme.bodySmall!.copyWith(
                    color: cs.onSurface.withOpacity(0.6),
                  ),
            ),
          ],
        ),
        if (targets.isNotEmpty) ...[
          const SizedBox(height: 16),
          Align(
            alignment: Alignment.centerLeft,
            child: Text(
              'VISIBLE TO',
              style: Theme.of(context).textTheme.labelSmall!.copyWith(
                    letterSpacing: 1,
                    color: cs.outline,
                  ),
            ),
          ),
          const SizedBox(height: 10),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: targets.map((v) {
              return Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 10,
                  vertical: 6,
                ),
                decoration: BoxDecoration(
                  color: cs.primary.withOpacity(0.08),
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Text(
                  controller.getLabel(v),
                  style: Theme.of(context)
                      .textTheme
                      .labelSmall!
                      .copyWith(color: cs.primary),
                ),
              );
            }).toList(),
          ),
        ],
        const SizedBox(height: 20),
        SizedBox(
          width: double.infinity,
          child: ElevatedButton.icon(
            onPressed: () {
              Get.back();
              editBanner(context, banner: banner);
            },
            icon: const Icon(Icons.edit, size: 18),
            label: const Text('Edit'),
            style: ElevatedButton.styleFrom(
              backgroundColor: cs.primary,
              foregroundColor: cs.onPrimary,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget buildMedia(String mediaUrl) {
    final isVideo = mediaUrl.toLowerCase().endsWith('.mp4') ||
        mediaUrl.toLowerCase().endsWith('.mov') ||
        mediaUrl.toLowerCase().endsWith('.webm');

    if (mediaUrl.isEmpty) return const SizedBox();

    if (isVideo) {
      return ClipRRect(
        borderRadius: BorderRadius.circular(14),
        child: AutoPlayVideo(url: mediaUrl),
      );
    }

    return ClipRRect(
      borderRadius: BorderRadius.circular(14),
      child: Image.network(
        mediaUrl,
        height: 200,
        width: double.infinity,
        fit: BoxFit.cover,
        errorBuilder: (_, __, ___) => Container(
          height: 200,
          color: Colors.grey.shade200,
          child: const Icon(Icons.broken_image),
        ),
      ),
    );
  }
}

class CustomCard extends StatelessWidget {
  final String? title;
  final Widget? content;
  final bool isImportant;
  final bool hasImage;
  final List<Widget>? actions;
  final List<VisibleTo>? visibleTo;
  final SettingsController c;
  final VoidCallback? onTap;

  const CustomCard({
    super.key,
    this.title,
    this.content,
    required this.c,
    this.isImportant = false,
    this.hasImage = false,
    this.actions,
    this.visibleTo,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;

    final body = Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        (hasImage == true)
            ? Container(
                padding: const EdgeInsets.all(16),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(14),
                  child: GestureDetector(
                    onTap: () {
                      openVideo('');
                    },
                    child: Stack(
                      alignment: Alignment.center,
                      children: [
                        // 🔹 Thumbnail / fallback
                        Image.network(
                          '',
                          fit: BoxFit.contain,
                          width: double.infinity,
                          height: 200,
                          errorBuilder: (context, error, stackTrace) {
                            return Image.asset(
                              'assets/images/logo.png',
                              fit: BoxFit.contain,
                              width: double.infinity,
                              height: 200,
                            );
                          },
                        ),

                        // 🔹 Play button overlay
                        Container(
                          decoration: BoxDecoration(
                            color: Colors.black45,
                            shape: BoxShape.circle,
                          ),
                          padding: const EdgeInsets.all(14),
                          child: const Icon(
                            Icons.play_arrow,
                            color: Colors.white,
                            size: 36,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              )
            : SizedBox(),

        /// HEADER
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Expanded(
              child: Text(
                title ?? '',
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
                style: Theme.of(context)
                    .textTheme
                    .titleSmall!
                    .copyWith(color: cs.onSurface),
              ),
            ),
            if (isImportant) ...[
              SizedBox(height: 6),
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 8,
                  vertical: 4,
                ),
                decoration: BoxDecoration(
                  color: cs.error.withOpacity(.08),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Text(
                  "IMPORTANT",
                  style: Theme.of(context)
                      .textTheme
                      .labelSmall!
                      .copyWith(letterSpacing: 1, color: cs.error),
                ),
              ),
            ]
          ],
        ),

        if (content != null) ...[
          SizedBox(height: 14),
          content!,
        ],

        if ((visibleTo ?? []).isNotEmpty) ...[
          SizedBox(height: 14),
          Text(
            "VISIBLE TO",
            style: Theme.of(context)
                .textTheme
                .labelSmall!
                .copyWith(letterSpacing: 1, color: cs.outline),
          ),
          SizedBox(height: 10),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: (visibleTo ?? []).map((v) {
              return Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 10,
                  vertical: 6,
                ),
                decoration: BoxDecoration(
                  color: cs.primary.withOpacity(.08),
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Text(
                  c.getLabel(v),
                  style: Theme.of(context)
                      .textTheme
                      .labelSmall!
                      .copyWith(color: cs.primary),
                ),
              );
            }).toList(),
          ),
        ],
      ],
    );

    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: cs.onPrimary,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: cs.outline.withOpacity(.5),
        ),
        boxShadow: [
          BoxShadow(
            color: cs.shadow.withOpacity(.03),
            blurRadius: 14,
            offset: const Offset(0, 6),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (onTap != null)
            InkWell(
              onTap: onTap,
              borderRadius: BorderRadius.circular(12),
              child: body,
            )
          else
            body,
          if (actions != null && actions!.isNotEmpty) ...[
            SizedBox(height: 14),
            Divider(
              height: 1,
              color: cs.outline.withOpacity(.08),
            ),
            SizedBox(height: 10),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: actions!,
            ),
          ],
        ],
      ),
    );
  }
}

class MultiSelector<T> extends StatefulWidget {
  final RxList<T> items;
  final List<T> initial;
  final Function(List<T>) onChanged;

  /// Optional "All" item (can be enum OR string OR model)
  final T? allValue;

  /// Label builder (important for enums / objects)
  final String Function(T) labelBuilder;

  const MultiSelector({
    super.key,
    required this.items,
    required this.initial,
    required this.onChanged,
    required this.labelBuilder,
    this.allValue,
  });

  @override
  State<MultiSelector<T>> createState() => _MultiSelectorState<T>();
}

class _MultiSelectorState<T> extends State<MultiSelector<T>> {
  late List<T> selected;

  @override
  void initState() {
    super.initState();
    selected = List<T>.from(widget.initial);
  }

  void toggle(T value) {
    setState(() {
      final hasAll = widget.allValue != null;

      final allExceptAll = hasAll
          ? widget.items.where((e) => e != widget.allValue).toList()
          : widget.items;

      if (hasAll && value == widget.allValue) {
        final isAllSelected = selected.toSet().containsAll(allExceptAll);

        if (isAllSelected) {
          selected.clear(); // unselect all
        } else {
          selected = List<T>.from(allExceptAll);
        }
      } else {
        if (selected.contains(value)) {
          selected.remove(value);
        } else {
          selected.add(value);
        }

        // if all items selected manually → keep them all (NOT collapse to "All")
        if (hasAll && selected.toSet().containsAll(allExceptAll)) {
          selected = List<T>.from(allExceptAll);
        }
      }
    });

    widget.onChanged(List<T>.from(selected));
  }

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;

    final displayList = widget.allValue != null
        ? [widget.allValue as T, ...widget.items]
        : widget.items;

    return Wrap(
      spacing: 10,
      runSpacing: 6,
      children: displayList.map((v) {
        final isSelected = widget.allValue != null && v == widget.allValue
            ? selected.toSet().containsAll(widget.items)
            : selected.contains(v);
        return InkWell(
          borderRadius: BorderRadius.circular(10),
          onTap: () => toggle(v),
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
            decoration: BoxDecoration(
              color:
                  isSelected ? cs.primaryContainer : cs.surfaceContainerHighest,
              borderRadius: BorderRadius.circular(10),
              border: Border.all(
                color: cs.outline.withOpacity(0.2), // soft grey border
                width: 1,
              ),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(
                  isSelected ? Icons.check_box : Icons.check_box_outline_blank,
                  size: 18,
                  color: isSelected ? cs.primary : cs.onSurfaceVariant,
                ),
                SizedBox(width: 6),
                Text(
                  widget.labelBuilder(v),
                  style: Theme.of(context).textTheme.bodySmall,
                ),
              ],
            ),
          ),
        );
      }).toList(),
    );
  }
}
