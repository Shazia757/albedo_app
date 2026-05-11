import 'package:albedo_app/widgets/custom_appbar.dart';
import 'package:albedo_app/widgets/drawer_menu.dart';
import 'package:albedo_app/widgets/widgets.dart';
import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';

/// ==============================
/// GENERIC CRUD PAGE
/// ==============================
class CrudPage<T> extends StatelessWidget {
  final String title;
  final List<T> items;
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
                          fontWeight: FontWeight.w700,
                        ),
                  ),
                ),

                /// ── CONTENT ────────────────────────
                Expanded(
                  child: items.isEmpty
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
                ),
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

    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(24),
        ),
        title: const Text(
          'Add Item',
          style: TextStyle(
            fontWeight: FontWeight.w700,
          ),
        ),
        content: Form(
          key: formKey,
          child: CustomWidgets().dropdownStyledTextField(
            context: context,
            controller: ctrl,
            hint: 'Enter value',
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          FilledButton.icon(
            onPressed: () async {
              if (formKey.currentState?.validate() != true) return;

              await onAdd(ctrl.text.trim());

              Navigator.pop(context);
            },
            label: const Text('Add'),
          )
        ],
      ),
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
            const SizedBox(height: 18),
            Text(
              'No items yet',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w700,
                color: cs.onSurface,
              ),
            ),
            const SizedBox(height: 6),
            Text(
              'Create your first item to get started',
              textAlign: TextAlign.center,
              style: TextStyle(
                color: cs.outline,
              ),
            ),
            if (onAdd != null) ...[
              const SizedBox(height: 22),
              FilledButton.icon(
                onPressed: onAdd,
                icon: const Icon(Icons.add_rounded),
                label: const Text('Add Item'),
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
class EditableTile extends StatefulWidget {
  final String value;
  final ValueChanged<String> onSave;
  final VoidCallback? onDelete;
  final IconData icon;

  const EditableTile({
    super.key,
    required this.value,
    required this.onSave,
    this.onDelete,
    required this.icon,
  });

  @override
  State<EditableTile> createState() => _EditableTileState();
}

class _EditableTileState extends State<EditableTile> {
  late TextEditingController _ctrl;

  bool _editing = false;

  @override
  void initState() {
    super.initState();
    _ctrl = TextEditingController(text: widget.value);
  }

  @override
  void didUpdateWidget(covariant EditableTile oldWidget) {
    super.didUpdateWidget(oldWidget);

    if (!_editing && oldWidget.value != widget.value) {
      _ctrl.text = widget.value;
    }
  }

  @override
  void dispose() {
    _ctrl.dispose();
    super.dispose();
  }

  void _save() {
    final v = _ctrl.text.trim();

    if (v.isEmpty) return;

    widget.onSave(v);

    setState(() => _editing = false);
  }

  void _cancel() {
    _ctrl.text = widget.value;

    setState(() => _editing = false);
  }

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;

    return AnimatedContainer(
      duration: const Duration(milliseconds: 220),
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
              widget.icon,
              color: cs.primary,
            ),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: _editing
                ? TextField(
                    controller: _ctrl,
                    autofocus: true,
                    decoration: InputDecoration(
                      hintText: 'Enter value',
                      filled: true,
                      isDense: true,
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(14),
                      ),
                    ),
                    onSubmitted: (_) => _save(),
                  )
                : Text(
                    widget.value,
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w700,
                      color: cs.onSurface,
                    ),
                  ),
          ),
          const SizedBox(width: 8),
          if (_editing) ...[
            IconButton(
              tooltip: 'Save',
              icon: Icon(
                Icons.check_circle_rounded,
                color: Colors.green.shade600,
              ),
              onPressed: _save,
            ),
            IconButton(
              tooltip: 'Cancel',
              icon: Icon(
                Icons.cancel_rounded,
                color: cs.outline,
              ),
              onPressed: _cancel,
            ),
          ] else ...[
            IconButton(
              tooltip: 'Edit',
              icon: Icon(
                Icons.edit_rounded,
                color: cs.primary,
              ),
              onPressed: () {
                setState(() => _editing = true);
              },
            ),
            if (widget.onDelete != null)
              IconButton(
                tooltip: 'Delete',
                icon: const Icon(
                  Icons.delete_rounded,
                  color: Colors.red,
                ),
                onPressed: widget.onDelete,
              ),
          ]
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
            const SizedBox(width: 14),
            Expanded(
              child: Text(
                value,
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w700,
                  color: cs.onSurface,
                ),
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
