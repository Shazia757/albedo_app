import 'package:albedo_app/controller/notifications_controller.dart';
import 'package:albedo_app/controller/settings_controller.dart';
import 'package:albedo_app/model/settings/notification_model.dart';
import 'package:albedo_app/view/settings/banner_ads_page.dart';
import 'package:albedo_app/widgets/responsive.dart';
import 'package:albedo_app/widgets/widgets.dart';
import 'package:albedo_app/widgets/custom_appbar.dart';
import 'package:albedo_app/widgets/drawer_menu.dart';
import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

class NotificationsPage extends StatelessWidget {
  final c = Get.put(NotificationsController());

  NotificationsPage({super.key});

  @override
  Widget build(BuildContext context) {
    final isDesktop = Responsive.isDesktop(context);

    return Scaffold(
      appBar: const CustomAppBar(),
      backgroundColor: Theme.of(context).colorScheme.surface,
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          editNotification(context);
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
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.fromLTRB(
                    16,
                    16,
                    16,
                    8,
                  ),
                  child: Text(
                    'Notifications',
                    style: Theme.of(context).textTheme.titleLarge?.copyWith(
                        fontWeight: FontWeight.w700,
                        color: Theme.of(context).colorScheme.primary),
                  ),
                ),
                Expanded(
                  child: Obx(() {
                    final data = c.msgs.where((msg) {
                      final targets = msg.dashboardTarget ?? [];

                      return !targets.contains('ADMIN');
                    }).toList();

                    if (c.isLoading.value) {
                      return Center(child: CircularProgressIndicator());
                    }
                    if (data.isEmpty) {
                      return Center(child: Text("No notifications found"));
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
                            final controller = Get.find<SettingsController>();

                            return CustomCard(
                              c: controller,
                              onTap: () =>
                                  showNotificationDetail(context, item),
                              title: item.title,
                              visibleTo: item.dashboardTarget
                                  .map((e) => c.visibleToFromString(e))
                                  .toList(),
                              content: Text(
                                item.message,
                                maxLines: 3,
                                overflow: TextOverflow.ellipsis,
                                style: Theme.of(context)
                                    .textTheme
                                    .bodySmall!
                                    .copyWith(
                                        color: Theme.of(context)
                                            .colorScheme
                                            .onSurface
                                            .withOpacity(0.7)),
                              ),
                              isImportant: item.isImportant,
                              actions: [
                                CustomWidgets().iconBtn(
                                  icon: Icons.edit,
                                  color: Theme.of(context).colorScheme.primary,
                                  onTap: () {
                                    editNotification(context,
                                        notification: item);
                                  },
                                ),
                                const SizedBox(width: 10),
                                CustomWidgets().iconBtn(
                                  icon: Icons.delete,
                                  color: Theme.of(context).colorScheme.error,
                                  onTap: () {
                                    final textstyle = Theme.of(context)
                                        .textTheme
                                        .titleSmall!
                                        .copyWith(color: Colors.white);
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
                                            : Text("Yes", style: textstyle),
                                      ),
                                      title: 'Are you sure?',
                                      context: context,
                                      text:
                                          'Are you sure you want to delete this notification?',
                                      onConfirm: () =>
                                          c.deleteNotification(item.id),
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
        ],
      ),
    );
  }

  void showNotificationDetail(
    BuildContext context,
    Notifications notification,
  ) {
    final controller = Get.find<SettingsController>();
    final cs = Theme.of(context).colorScheme;
    final targets = notification.dashboardTarget
        .map((e) => controller.visibleToFromString(e))
        .toList();
    final updatedAt = notification.dateUpdated.isNotEmpty
        ? DateFormat('dd MMM yyyy • hh:mm a').format(
            DateTime.tryParse(notification.dateUpdated) ?? DateTime.now(),
          )
        : '—';

    CustomWidgets().showCustomDialog(
      context: context,
      title: Text(notification.title),
      icon: Icons.notifications_outlined,
      formKey: GlobalKey<FormState>(),
      isViewOnly: true,
      onSubmit: () {},
      sections: [
        if (notification.isImportant)
          Container(
            margin: const EdgeInsets.only(bottom: 12),
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
            decoration: BoxDecoration(
              color: cs.error.withOpacity(0.1),
              borderRadius: BorderRadius.circular(6),
            ),
            child: Text(
              'IMPORTANT',
              style: Theme.of(context)
                  .textTheme
                  .labelLarge!
                  .copyWith(color: cs.error),
            ),
          ),
        Text(
          notification.message,
          style: Theme.of(context).textTheme.bodyMedium!.copyWith(
                color: cs.onSurface.withOpacity(0.85),
                height: 1.5,
              ),
        ),
        const SizedBox(height: 16),
        Row(
          children: [
            Icon(
              Icons.schedule,
              size: 16,
              color: cs.onSurface.withOpacity(0.5),
            ),
            const SizedBox(width: 6),
            Text(
              'Updated: $updatedAt',
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
              return Align(
                alignment: Alignment.centerLeft,
                child: Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
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
              editNotification(context, notification: notification);
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

  void editNotification(
    BuildContext context, {
    Notifications? notification,
  }) {
    final controller = Get.find<SettingsController>();
    final isEdit = notification != null;
    if (isEdit) {
      c.titleController.text = notification.title;
      c.messageController.text = notification.message;

      c.isImportant.value = notification.isImportant ?? false;

      c.selected.assignAll(
        notification.dashboardTarget
            .map((e) => VisibleToExtension.fromString(e))
            .toList(),
      );
    } else {
      // Reset fields for add mode
      c.titleController.clear();
      c.messageController.clear();

      c.isImportant.value = false;

      c.selected.clear();
    }
    CustomWidgets().showCustomDialog(
      context: context,
      title: Text(
        isEdit ? 'Edit Notification' : 'Add Notification',
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
        CustomWidgets().labelWithAsterisk('Title'),
        SizedBox(height: 10),
        CustomWidgets().dropdownStyledTextField(
            context: context,
            hint: 'Enter notification title',
            controller: c.titleController),
        SizedBox(height: 10),
        CustomWidgets().labelWithAsterisk('Message'),
        SizedBox(height: 10),
        CustomWidgets().dropdownStyledTextField(
            context: context,
            hint: 'Enter notification message',
            controller: c.messageController),
        SizedBox(height: 10),
        Obx(
          () => Align(
            alignment: Alignment.centerLeft,
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Checkbox(
                  value: c.isImportant.value,
                  onChanged: (val) {
                    c.isImportant.value = val ?? false;
                  },
                ),
                Text(
                  "Mark as important",
                  style: Theme.of(context).textTheme.bodyMedium,
                ),
              ],
            ),
          ),
        ),
        CustomWidgets().labelWithAsterisk('Visible to:'),
        SizedBox(height: 10),
        VisibleToSelector(
          c: controller,
          initial: List<VisibleTo>.from(c.selected),
          onChanged: (val) {
            c.selected.assignAll(val);
          },
        ),
      ],
      onSubmit: () async {
        final title = c.titleController.text.trim();
        final message = c.messageController.text.trim();

        if (title.isEmpty) {
          Get.snackbar(
            "Error",
            "Title is required",
          );
          return;
        }

        if (message.isEmpty) {
          Get.snackbar(
            "Error",
            "Message is required",
          );
          return;
        }

        if (c.selected.isEmpty) {
          Get.snackbar(
            "Validation",
            "Select at least one visible target",
          );
          return;
        }

        if (isEdit) {
          await c.updateNotification(
            id: notification.id ?? '',
          );
        } else {
          await c.addNotification();
        }
      },
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
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 180),
                padding:
                    const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                decoration: BoxDecoration(
                  color: isSelected
                      ? cs.primaryContainer
                      : cs.surfaceContainerHighest,
                  borderRadius: BorderRadius.circular(10),
                  border: Border.all(
                    color:
                        isSelected ? cs.primary : cs.outline.withOpacity(0.35),
                    width: isSelected ? 1.5 : 1,
                  ),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(
                      isSelected
                          ? Icons.check_box_rounded
                          : Icons.check_box_outline_blank_rounded,
                      size: 18,
                      color: isSelected ? cs.primary : cs.onSurfaceVariant,
                    ),
                    const SizedBox(width: 6),
                    Text(
                      widget.c.getLabel(v),
                      style: Theme.of(context).textTheme.bodySmall?.copyWith(
                            fontWeight:
                                isSelected ? FontWeight.w600 : FontWeight.w500,
                          ),
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
