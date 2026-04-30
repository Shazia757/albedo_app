import 'package:albedo_app/widgets/crud_page.dart';
import 'package:albedo_app/widgets/widgets.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:albedo_app/controller/settings_controller.dart';

/// Clean, responsive, production-ready CRUD with inline edit
class SyllabusPage extends StatelessWidget {
  SyllabusPage({super.key});

  final SettingsController c = Get.put(SettingsController());

  @override
  Widget build(BuildContext context) {
    return CrudPage(
      title: "Syllabus",
      items: c.syllabus,
      itemBuilder: (item, i) {
        return EditableTile(
          icon: Icons.menu_book,
          key: ValueKey(i),
          value: item,
          onSave: (val) {
            c.syllabus[i] = val;
            c.syllabus.refresh();
          },
          onDelete: () {
            CustomWidgets().showDeleteDialog(
              context: context,
              text: 'Delete this syllabus permanently?',
              onConfirm: () {
                c.syllabus.removeAt(i);
                c.syllabus.refresh();
              },
            );
          },
        );
      },
      onAdd: (val) async {
        c.syllabus.add(val);
        c.syllabus.refresh();
      },
      onUpdate: (i, val) async {},
      onDelete: (i) async {},
    );
  }
}

class AddItemTile extends StatelessWidget {
  final String title;
  // final IconData icon;
  final VoidCallback onTap;
  final Color? color;

  const AddItemTile({
    super.key,
    required this.title,
    // required this.icon,
    required this.onTap,
    this.color,
  });

  @override
  Widget build(BuildContext context) {
    final accent = color ?? Theme.of(context).colorScheme.primary;

    return InkWell(
      borderRadius: BorderRadius.circular(14),
      onTap: onTap,
      child: Ink(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(14),
          border: Border.all(
            color: accent.withOpacity(0.4),
          ),
          color: accent.withOpacity(0.05),
        ),
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 10),
          child: Row(
            children: [
              Icon(Icons.add, color: accent),
              const SizedBox(width: 10),
              Text(
                title,
                style: TextStyle(
                  fontWeight: FontWeight.w600,
                  color: accent,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class CrudItemTile extends StatelessWidget {
  final String title;
  final IconData icon;
  final VoidCallback? onEdit;
  final VoidCallback? onDelete;
  final VoidCallback? onTap; // optional (if clickable)
  final Color? color;

  const CrudItemTile({
    super.key,
    required this.title,
    required this.icon,
    this.onEdit,
    this.onDelete,
    this.onTap,
    this.color,
  });

  @override
  Widget build(BuildContext context) {
    final accent = color ?? Theme.of(context).colorScheme.primary;

    return InkWell(
      borderRadius: BorderRadius.circular(14),
      onTap: onTap,
      child: Ink(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(14),
          gradient: LinearGradient(
            colors: [
              Colors.white,
              accent.withOpacity(0.05),
            ],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          border: Border.all(color: accent.withOpacity(0.15)),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.04),
              blurRadius: 6,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 10),
          child: Row(
            children: [
              // Leading icon
              Container(
                padding: const EdgeInsets.all(6),
                decoration: BoxDecoration(
                  color: accent.withOpacity(0.15),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Icon(icon, size: 18, color: accent),
              ),

              const SizedBox(width: 10),

              // Title
              Expanded(
                child: Text(
                  title,
                  style: const TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),

              // Actions
              Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  if (onEdit != null)
                    InkWell(
                      borderRadius: BorderRadius.circular(8),
                      onTap: onEdit,
                      child: Padding(
                        padding: const EdgeInsets.all(6),
                        child: Icon(Icons.edit, size: 18, color: accent),
                      ),
                    ),
                  if (onDelete != null)
                    InkWell(
                      borderRadius: BorderRadius.circular(8),
                      onTap: onDelete,
                      child: const Padding(
                        padding: EdgeInsets.all(6),
                        child: Icon(Icons.delete, size: 18, color: Colors.red),
                      ),
                    ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
