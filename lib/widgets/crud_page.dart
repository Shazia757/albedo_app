import 'package:albedo_app/controller/settings_controller.dart';
import 'package:albedo_app/widgets/custom_appbar.dart';
import 'package:albedo_app/widgets/drawer_menu.dart';
import 'package:albedo_app/widgets/widgets.dart';
import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:get/get.dart';

/// ==============================
/// GENERIC CRUD PAGE
/// ==============================
class CrudPage<T> extends StatelessWidget {
  final String title;
  final RxList<T> items;
  final Widget Function(T item, int index) itemBuilder;
  final Future<void> Function(String value) onAdd;
  final Future<void> Function(int index, String value) onUpdate;
  final Future<void> Function(int index) onDelete;
  final bool enableAdd;
  final bool enableDelete;

  const CrudPage({
    super.key,
    required this.title,
    required this.items,
    required this.itemBuilder,
    required this.onAdd,
    required this.onUpdate,
    required this.onDelete,
    this.enableAdd = true,
    this.enableDelete = true,
  });

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;

    return Scaffold(
      appBar: const CustomAppBar(),
      backgroundColor: cs.surface,
      floatingActionButton: enableAdd
          ? FloatingActionButton(
              mini: true,
              onPressed: () => _openAdd(context),
              backgroundColor: cs.primary,
              child: Icon(
                Icons.add,
                color: cs.onPrimary,
              ),
            )
          : null,
      body: Row(
        children: [
          if (MediaQuery.of(context).size.width > 900) const DrawerMenu(),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                /// ── PAGE TITLE ─────────────────────
                Padding(
                  padding: const EdgeInsets.fromLTRB(
                    16,
                    16,
                    16,
                    8,
                  ),
                  child: Text(
                    title,
                    style: Theme.of(context).textTheme.titleLarge?.copyWith(
                        fontWeight: FontWeight.w700, color: cs.primary),
                  ),
                ),

                /// ── CONTENT ────────────────────────
                Expanded(
                    child: Obx(
                  () => items.isEmpty
                      ? _EmptyState(
                          onAdd: enableAdd ? () => _openAdd(context) : null,
                        )
                      : LayoutBuilder(
                          builder: (context, constraints) {
                            int crossAxisCount = 1;

                            if (constraints.maxWidth > 1200) {
                              crossAxisCount = 4;
                            } else if (constraints.maxWidth > 900) {
                              crossAxisCount = 3;
                            } else if (constraints.maxWidth > 600) {
                              crossAxisCount = 2;
                            }

                            return MasonryGridView.count(
                              crossAxisCount: crossAxisCount,
                              padding: const EdgeInsets.fromLTRB(
                                16,
                                8,
                                16,
                                24,
                              ),
                              mainAxisSpacing: 12,
                              crossAxisSpacing: 12,
                              physics: const BouncingScrollPhysics(),
                              itemCount: items.length,
                              itemBuilder: (_, i) {
                                return itemBuilder(
                                  items[i],
                                  i,
                                );
                              },
                            );
                          },
                        ),
                )),
              ],
            ),
          ),
        ],
      ),
    );
  }

  void _openAdd(BuildContext context) {
    final formKey = GlobalKey<FormState>();
    final ctrl = TextEditingController();
    final controller = Get.find<SettingsController>();

    CustomWidgets().showCustomDialog(
      context: context,
      title: const Text('Add Item'),
      icon: Icons.add_rounded,
      formKey: formKey,
      submitWidget: Obx(
        () => controller.isLoading.value
            ? const SizedBox(
                width: 18,
                height: 18,
                child: CircularProgressIndicator(
                  strokeWidth: 2,
                  color: Colors.white,
                ),
              )
            : const Text(
                'Add',
                style: TextStyle(color: Colors.white),
              ),
      ),
      sections: [
        CustomWidgets().dropdownStyledTextField(
          context: context,
          controller: ctrl,
          hint: 'Enter value',
        ),
      ],
      onSubmit: () async {
        final value = ctrl.text.trim();

        if (value.isEmpty) return;

        await onAdd(value);

        if (Get.isDialogOpen ?? false) {
          Get.back();
        }
      },
    );
  }
}

/// ==============================
/// EMPTY STATE
/// ==============================
class _EmptyState extends StatelessWidget {
  final VoidCallback? onAdd;

  const _EmptyState({this.onAdd});

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;

    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              width: 90,
              height: 90,
              decoration: BoxDecoration(
                color: cs.primary.withOpacity(.08),
                borderRadius: BorderRadius.circular(28),
              ),
              child: Icon(
                Icons.inbox_rounded,
                size: 42,
                color: cs.primary,
              ),
            ),
            SizedBox(height: 18),
            Text(
              'No items yet',
              style: Theme.of(context)
                  .textTheme
                  .titleLarge!
                  .copyWith(color: cs.onSurface),
            ),
            SizedBox(height: 6),
            Text(
              'Create your first item to get started',
              textAlign: TextAlign.center,
              style: Theme.of(context)
                  .textTheme
                  .bodyMedium!
                  .copyWith(color: cs.outline),
            ),
            if (onAdd != null) ...[
              SizedBox(height: 22),
              FilledButton.icon(
                onPressed: onAdd,
                icon: const Icon(Icons.add_rounded),
                label: Text('Add Item'),
              ),
            ]
          ],
        ),
      ),
    );
  }
}

/// ==============================
/// EDITABLE TILE
/// ==============================
class EditableTile extends StatelessWidget {
  final String value;
  final Future<void> Function(String value) onSave;
  final VoidCallback? onDelete;
  final IconData icon;
  final String editTitle;

  const EditableTile({
    super.key,
    required this.value,
    required this.onSave,
    this.onDelete,
    required this.icon,
    this.editTitle = 'Edit Item',
  });

  void _openEdit(BuildContext context) {
    final formKey = GlobalKey<FormState>();
    final ctrl = TextEditingController(text: value);
    final controller = Get.find<SettingsController>();

    CustomWidgets().showCustomDialog(
      context: context,
      title: Text(editTitle),
      icon: Icons.edit_rounded,
      formKey: formKey,
      submitWidget: Obx(
        () => controller.isLoading.value
            ? const SizedBox(
                width: 18,
                height: 18,
                child: CircularProgressIndicator(
                  strokeWidth: 2,
                  color: Colors.white,
                ),
              )
            : const Text(
                'Save',
                style: TextStyle(color: Colors.white),
              ),
      ),
      sections: [
        CustomWidgets().dropdownStyledTextField(
          context: context,
          controller: ctrl,
          hint: 'Enter value',
        ),
      ],
      onSubmit: () {
        final v = ctrl.text.trim();

        if (v.isEmpty) return;

        onSave(v);
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;

    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: cs.onPrimary,
        borderRadius: BorderRadius.circular(22),
        border: Border.all(
          color: cs.outline.withOpacity(.5),
        ),
        boxShadow: [
          BoxShadow(
            color: cs.shadow.withOpacity(.04),
            blurRadius: 14,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: Row(
        children: [
          Container(
            width: 48,
            height: 48,
            decoration: BoxDecoration(
              color: cs.primary.withOpacity(.08),
              borderRadius: BorderRadius.circular(16),
            ),
            child: Icon(
              icon,
              color: cs.primary,
            ),
          ),
          SizedBox(width: 14),
          Expanded(
            child: Text(
              value,
              style: Theme.of(context)
                  .textTheme
                  .titleSmall!
                  .copyWith(color: cs.onSurface),
            ),
          ),
          SizedBox(width: 8),
          IconButton(
            tooltip: 'Edit',
            icon: Icon(
              Icons.edit_rounded,
              color: cs.primary,
            ),
            onPressed: () => _openEdit(context),
          ),
          if (onDelete != null)
            IconButton(
              tooltip: 'Delete',
              icon: const Icon(
                Icons.delete_rounded,
                color: Colors.red,
              ),
              onPressed: onDelete,
            ),
        ],
      ),
    );
  }
}

/// ==============================
/// VIEW EDIT TILE
/// ==============================
class ViewEditTile extends StatelessWidget {
  final String value;
  final IconData icon;
  final VoidCallback onEdit;
  final VoidCallback? onTap;

  const ViewEditTile({
    super.key,
    required this.value,
    required this.icon,
    required this.onEdit,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;

    return InkWell(
      borderRadius: BorderRadius.circular(22),
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
          color: cs.onPrimary,
          borderRadius: BorderRadius.circular(22),
          border: Border.all(
            color: cs.outline.withOpacity(.12),
          ),
          boxShadow: [
            BoxShadow(
              color: cs.shadow.withOpacity(.04),
              blurRadius: 14,
              offset: const Offset(0, 5),
            ),
          ],
        ),
        child: Row(
          children: [
            Container(
              width: 48,
              height: 48,
              decoration: BoxDecoration(
                color: cs.primary.withOpacity(.08),
                borderRadius: BorderRadius.circular(16),
              ),
              child: Icon(
                icon,
                color: cs.primary,
              ),
            ),
            SizedBox(width: 14),
            Expanded(
              child: Text(
                value,
                style: Theme.of(context)
                    .textTheme
                    .titleSmall!
                    .copyWith(color: cs.onSurface),
              ),
            ),
            IconButton(
              tooltip: 'Edit',
              icon: Icon(
                Icons.edit_rounded,
                color: cs.primary,
              ),
              onPressed: onEdit,
            ),
          ],
        ),
      ),
    );
  }
}
