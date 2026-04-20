import 'package:albedo_app/widgets/custom_appbar.dart';
import 'package:albedo_app/widgets/drawer_menu.dart';
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
      appBar: CustomAppBar(),
      backgroundColor: cs.surface,
      floatingActionButton: enableAdd
          ? FloatingActionButton.extended(
              onPressed: () => _openAdd(context),
              icon: const Icon(Icons.add),
              label: const Text('Add'),
            )
          : null,
      body: Row(
        children: [
          /// 🧭 Desktop Drawer
          if (MediaQuery.of(context).size.width > 900) const DrawerMenu(),

          /// 📦 Main Content
          Expanded(
            child: items.isEmpty
                ? _EmptyState(
                    onAdd: enableAdd ? () => _openAdd(context) : null,
                  )
                : ResponsiveMasonry(
                    children: List.generate(items.length, (i) {
                      return itemBuilder(items[i], i);
                    }),
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
        title: const Text('Add Item'),
        content: Form(
          key: formKey,
          child: TextFormField(
            controller: ctrl,
            decoration: const InputDecoration(
              labelText: 'Name',
              border: OutlineInputBorder(),
            ),
            validator: (v) =>
                (v == null || v.trim().isEmpty) ? 'Enter value' : null,
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () async {
              if (formKey.currentState?.validate() != true) return;
              await onAdd(ctrl.text.trim());
              Navigator.pop(context);
            },
            child: const Text('Add'),
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

    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Icon(Icons.inbox_outlined, size: 64, color: cs.outline),
        const SizedBox(height: 12),
        Text('No items yet', style: TextStyle(color: cs.onSurfaceVariant)),
        if (onAdd != null) ...[
          const SizedBox(height: 16),
          FilledButton.icon(
            onPressed: onAdd,
            icon: const Icon(Icons.add),
            label: const Text('Add Item'),
          )
        ]
      ],
    );
  }
}

/// ==============================
/// RESPONSIVE MASONRY
/// ==============================

class ResponsiveMasonry extends StatelessWidget {
  final List<Widget> children;

  const ResponsiveMasonry({super.key, required this.children});

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;

    // 📱 Mobile → list
    if (width < 600) {
      return ListView.separated(
        padding: const EdgeInsets.all(16),
        itemCount: children.length,
        separatorBuilder: (_, __) => const SizedBox(height: 10),
        itemBuilder: (_, i) => children[i],
      );
    }

    // 📟 Tablet → 2 columns
    if (width < 900) {
      return MasonryGridView.count(
        padding: const EdgeInsets.all(16),
        crossAxisCount: 2,
        mainAxisSpacing: 12,
        crossAxisSpacing: 12,
        itemCount: children.length,
        itemBuilder: (_, i) => children[i],
      );
    }

    // 💻 Desktop → responsive columns
    final crossAxisCount = (width ~/ 320).clamp(2, 5);

    return MasonryGridView.count(
      padding: const EdgeInsets.all(16),
      crossAxisCount: crossAxisCount,
      mainAxisSpacing: 16,
      crossAxisSpacing: 16,
      itemCount: children.length,
      itemBuilder: (_, i) => children[i],
    );
  }
}

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
      _ctrl.text = widget.value; // keep in sync with source
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

    return Container(
      decoration: BoxDecoration(
        color: cs.surface,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: cs.outlineVariant),
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: cs.primaryContainer,
                borderRadius: BorderRadius.circular(10),
              ),
              child: Icon(widget.icon, color: cs.onPrimaryContainer),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: _editing
                  ? TextField(
                      controller: _ctrl,
                      autofocus: true,
                      textInputAction: TextInputAction.done,
                      decoration: const InputDecoration(
                        isDense: true,
                        border: InputBorder.none,
                        hintText: 'Enter value',
                      ),
                      onSubmitted: (_) => _save(),
                    )
                  : Text(
                      widget.value,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
            ),
            const SizedBox(width: 8),
            if (_editing) ...[
              IconButton(
                tooltip: 'Save',
                icon: const Icon(Icons.check),
                onPressed: _save,
              ),
              IconButton(
                tooltip: 'Cancel',
                icon: const Icon(Icons.close),
                onPressed: _cancel,
              ),
            ] else ...[
              if (!_editing) ...[
                IconButton(
                  tooltip: 'Edit',
                  icon: const Icon(Icons.edit_outlined),
                  onPressed: () => setState(() => _editing = true),
                ),
                if (widget.onDelete != null)
                  IconButton(
                    tooltip: 'Delete',
                    icon: const Icon(Icons.delete_outline, color: Colors.red),
                    onPressed: widget.onDelete,
                  ),
              ]
            ]
          ],
        ),
      ),
    );
  }
}

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
      borderRadius: BorderRadius.circular(16),
      onTap: onTap,
      child: Container(
        decoration: BoxDecoration(
          color: cs.surface,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: cs.outlineVariant),
        ),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
          child: Row(
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: cs.primaryContainer,
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Icon(icon, color: cs.onPrimaryContainer),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Text(
                  value,
                  style: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
              IconButton(
                tooltip: 'Edit',
                icon: const Icon(Icons.edit_outlined),
                onPressed: onEdit,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
