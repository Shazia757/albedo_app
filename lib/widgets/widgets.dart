import 'package:albedo_app/controller/session_controller.dart';
import 'package:albedo_app/model/session_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_typeahead/flutter_typeahead.dart';
import 'package:get/get.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';

typedef StringValueOf<T> = String Function(T item);

class CustomWidgets {
  Widget iconBtn({
    IconData? icon,
    Color? color,
    VoidCallback? onTap,
    String? title,
    BuildContext? context,
  }) {
    final cs = context != null ? Theme.of(context).colorScheme : null;

    // fallback to theme if color not provided
    final effectiveColor = color ?? cs?.primary ?? Colors.blue;

    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(10),
        splashColor: effectiveColor.withOpacity(0.2),
        highlightColor: effectiveColor.withOpacity(0.08),
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
          decoration: BoxDecoration(
            color: effectiveColor.withOpacity(0.12),
            borderRadius: BorderRadius.circular(10),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              if (icon != null)
                Icon(
                  icon,
                  size: 18,
                  color: effectiveColor,
                ),
              if (title != null) ...[
                if (icon != null) const SizedBox(width: 6),
                Text(
                  title,
                  style: TextStyle(
                    color: effectiveColor,
                    fontSize: 13,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }

  Widget buildActionButton({
    IconData? icon,
    required BuildContext context,
    required String text,
    String? loadingText,
    Color? color,
    required VoidCallback onPressed,
    EdgeInsetsGeometry padding = EdgeInsets.zero,
    Color foregroundColor = Colors.white,
    bool isLoading = false,
  }) {
    return Padding(
      padding: padding,
      child: ElevatedButton(
        onPressed: () {
          if (!isLoading) {
            onPressed();
          }
        },
        style: ElevatedButton.styleFrom(
          foregroundColor: foregroundColor,
          backgroundColor: color ?? Theme.of(context).colorScheme.secondary,
          minimumSize: const Size(double.infinity, 48),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            if (isLoading) ...[
              const SizedBox(
                height: 18,
                width: 18,
                child: CircularProgressIndicator(
                  strokeWidth: 2,
                  color: Colors.white,
                ),
              ),
              const SizedBox(width: 10),
              Text(
                isLoading ? loadingText ?? '' : text,
                style: const TextStyle(fontSize: 16),
              ),
            ] else ...[
              if (icon != null) ...[
                Icon(icon, color: Colors.white),
                const SizedBox(width: 8),
              ],
              Text(text, style: const TextStyle(fontSize: 16)),
            ]
          ],
        ),
      ),
    );
  }

  Widget premiumSearch(
    BuildContext context, {
    required String hint,
    required Function(String) onChanged,
    TextEditingController? controller,
  }) {
    final cs = Theme.of(context).colorScheme;

    return Container(
      height: 44,
      decoration: BoxDecoration(
        color: cs.surface,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: cs.outline.withOpacity(0.4),
        ),
        boxShadow: [
          BoxShadow(
            color: cs.shadow.withOpacity(0.05),
            blurRadius: 8,
          )
        ],
      ),
      child: TextField(
        controller: controller,
        onChanged: onChanged,
        style: TextStyle(
          fontSize: 14,
          color: cs.onSurface,
        ),
        decoration: InputDecoration(
          hintText: hint,
          hintStyle: TextStyle(
            color: cs.onSurface.withOpacity(0.5),
          ),
          prefixIcon: Icon(
            Icons.search,
            size: 20,
            color: cs.onSurface.withOpacity(0.6),
          ),
          border: InputBorder.none,
          contentPadding: const EdgeInsets.symmetric(vertical: 12),
        ),
      ),
    );
  }

  void showSortSheet<T>({
    required List<SortOption<T>> options,
    required T selectedValue,
    required Function(T) onSelected,
    String title = "Sort",
  }) {
    T tempSelected = selectedValue;

    Get.bottomSheet(
      Builder(
        builder: (context) {
          final cs = Theme.of(context).colorScheme;

          return Container(
            padding: const EdgeInsets.fromLTRB(16, 10, 16, 20),
            decoration: BoxDecoration(
              color: cs.surface,
              borderRadius: const BorderRadius.vertical(
                top: Radius.circular(24),
              ),
            ),
            child: StatefulBuilder(
              builder: (context, setState) {
                return Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    /// Handle
                    Container(
                      width: 40,
                      height: 4,
                      margin: const EdgeInsets.only(bottom: 12),
                      decoration: BoxDecoration(
                        color: cs.outline.withOpacity(0.4),
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),

                    /// Title
                    Text(
                      title,
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                        color: cs.onSurface,
                      ),
                    ),

                    const SizedBox(height: 16),

                    /// Options
                    ...options.map((e) {
                      final isSelected = tempSelected == e.value;

                      return GestureDetector(
                        onTap: () {
                          setState(() => tempSelected = e.value);
                          onSelected(e.value);
                          Get.back();
                        },
                        child: Container(
                          margin: const EdgeInsets.only(bottom: 8),
                          padding: const EdgeInsets.symmetric(
                              horizontal: 12, vertical: 12),
                          decoration: BoxDecoration(
                            color: isSelected
                                ? cs.primary.withOpacity(0.08)
                                : Colors.transparent,
                            borderRadius: BorderRadius.circular(12),
                            border: Border.all(
                              color: isSelected
                                  ? cs.primary
                                  : cs.outline.withOpacity(0.3),
                            ),
                          ),
                          child: Row(
                            children: [
                              Icon(
                                e.icon,
                                size: 18,
                                color: isSelected
                                    ? cs.primary
                                    : cs.onSurface.withOpacity(0.6),
                              ),
                              const SizedBox(width: 10),

                              /// Label
                              Expanded(
                                child: Text(
                                  e.label,
                                  style: TextStyle(
                                    fontSize: 14,
                                    fontWeight: isSelected
                                        ? FontWeight.w600
                                        : FontWeight.w400,
                                    color:
                                        isSelected ? cs.primary : cs.onSurface,
                                  ),
                                ),
                              ),

                              /// Check
                              if (isSelected)
                                Icon(
                                  Icons.check_circle,
                                  color: cs.primary,
                                  size: 18,
                                )
                            ],
                          ),
                        ),
                      );
                    }),
                  ],
                );
              },
            ),
          );
        },
      ),
    );
  }

  void showFilterSheet<T>({
    required List<FilterOption<T>> options,
    required T selectedValue,
    required Function(T) onSelected,
    String title = "Filter",
  }) {
    T tempSelected = selectedValue;

    Get.bottomSheet(
      Builder(
        builder: (context) {
          final cs = Theme.of(context).colorScheme;

          return Container(
            padding: const EdgeInsets.fromLTRB(16, 10, 16, 20),
            decoration: BoxDecoration(
              color: cs.surface,
              borderRadius: const BorderRadius.vertical(
                top: Radius.circular(24),
              ),
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                /// Handle
                Container(
                  width: 40,
                  height: 4,
                  margin: const EdgeInsets.only(bottom: 12),
                  decoration: BoxDecoration(
                    color: cs.outline.withOpacity(0.4),
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),

                /// Title
                Text(
                  title,
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    color: cs.onSurface,
                  ),
                ),

                const SizedBox(height: 16),

                /// 🔥 FIX: scrollable options
                Flexible(
                  child: SingleChildScrollView(
                    child: Column(
                      children: options.map((e) {
                        final isSelected = tempSelected == e.value;

                        return GestureDetector(
                          onTap: () {
                            onSelected(e.value);
                            Get.back();
                          },
                          child: Container(
                            margin: const EdgeInsets.only(bottom: 8),
                            padding: const EdgeInsets.symmetric(
                              horizontal: 12,
                              vertical: 12,
                            ),
                            decoration: BoxDecoration(
                              color: isSelected
                                  ? cs.primary.withOpacity(0.08)
                                  : Colors.transparent,
                              borderRadius: BorderRadius.circular(12),
                              border: Border.all(
                                color: isSelected
                                    ? cs.primary
                                    : cs.outline.withOpacity(0.3),
                              ),
                            ),
                            child: Row(
                              children: [
                                Icon(
                                  e.icon,
                                  size: 18,
                                  color: isSelected
                                      ? cs.primary
                                      : cs.onSurface.withOpacity(0.6),
                                ),
                                const SizedBox(width: 10),
                                Expanded(
                                  child: Text(
                                    e.label,
                                    style: TextStyle(
                                      fontSize: 14,
                                      fontWeight: isSelected
                                          ? FontWeight.w600
                                          : FontWeight.w400,
                                      color: isSelected
                                          ? cs.primary
                                          : cs.onSurface,
                                    ),
                                  ),
                                ),
                                if (isSelected)
                                  Icon(
                                    Icons.check_circle,
                                    color: cs.primary,
                                    size: 18,
                                  ),
                              ],
                            ),
                          ),
                        );
                      }).toList(),
                    ),
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget customTabs(
    BuildContext context, {
    required List<String> tabs,
    required int selectedIndex,
    required Function(int) onTap,
    required int Function(int index) getCount,
  }) {
    final cs = Theme.of(context).colorScheme;

    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 8.0),
        child: Row(
          children: List.generate(tabs.length, (index) {
            final isActive = selectedIndex == index;
            final count = getCount(index);

            return GestureDetector(
              onTap: () => onTap(index),
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 200),
                margin: const EdgeInsets.only(right: 8),
                padding:
                    const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
                decoration: BoxDecoration(
                  color: isActive ? cs.primary : cs.surface,
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(
                    color: isActive ? cs.primary : cs.outline.withOpacity(0.4),
                  ),
                  boxShadow: [
                    if (isActive)
                      BoxShadow(
                        color: cs.primary.withOpacity(0.25),
                        blurRadius: 8,
                        offset: const Offset(0, 3),
                      )
                  ],
                ),
                child: Text(
                  "${tabs[index]} ($count)",
                  style: TextStyle(
                    color: isActive ? cs.onPrimary : cs.onSurface,
                    fontSize: 12,
                    fontWeight: isActive ? FontWeight.w600 : FontWeight.w500,
                  ),
                ),
              ),
            );
          }),
        ),
      ),
    );
  }

  void showDeleteDialog({
    required BuildContext context,
    required String text,
    required VoidCallback onConfirm,
  }) {
    final cs = Theme.of(context).colorScheme;

    Get.dialog(
      Dialog(
        backgroundColor: Colors.transparent,
        insetPadding: const EdgeInsets.symmetric(horizontal: 24),
        child: Container(
          padding: const EdgeInsets.fromLTRB(20, 24, 20, 20),
          decoration: BoxDecoration(
            color: cs.surface,
            borderRadius: BorderRadius.circular(20),
            border: Border.all(
              color: cs.error.withOpacity(0.2),
            ),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.08),
                blurRadius: 20,
                offset: const Offset(0, 10),
              ),
            ],
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              /// 🔥 ICON (danger cue)
              Container(
                width: 56,
                height: 56,
                decoration: BoxDecoration(
                  color: cs.error.withOpacity(0.12),
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  Icons.delete_outline,
                  color: cs.error,
                  size: 28,
                ),
              ),

              const SizedBox(height: 14),

              /// 🔹 TITLE
              Text(
                "Delete Session?",
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w700,
                  color: cs.onSurface,
                ),
              ),

              const SizedBox(height: 8),

              /// 🔹 MESSAGE
              Text(
                text,
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 13.5,
                  height: 1.5,
                  color: cs.onSurface.withOpacity(0.6),
                ),
              ),

              const SizedBox(height: 22),

              /// 🔹 ACTIONS
              Row(
                children: [
                  /// CANCEL
                  Expanded(
                    child: OutlinedButton(
                      onPressed: () => Get.back(),
                      style: OutlinedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(vertical: 12),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        side: BorderSide(
                          color: cs.outline.withOpacity(0.4),
                        ),
                      ),
                      child: Text(
                        "Cancel",
                        style: TextStyle(
                          color: cs.onSurface,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ),

                  const SizedBox(width: 10),

                  /// DELETE
                  Expanded(
                    child: ElevatedButton(
                      onPressed: () {
                        onConfirm();
                        Get.back();
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: cs.error,
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(vertical: 12),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        elevation: 0,
                      ),
                      child: const Text(
                        "Yes",
                        style: TextStyle(fontWeight: FontWeight.w600),
                      ),
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

  void showDeactivateDialog({
    required BuildContext context,
    required VoidCallback onConfirm,
    required String text,
  }) {
    final cs = Theme.of(context).colorScheme;

    Get.dialog(
      Dialog(
        backgroundColor: Colors.transparent,
        insetPadding: const EdgeInsets.symmetric(horizontal: 24),
        child: Container(
          padding: const EdgeInsets.fromLTRB(20, 24, 20, 20),
          decoration: BoxDecoration(
            color: cs.surface,
            borderRadius: BorderRadius.circular(20),
            border: Border.all(
              color: cs.secondary.withOpacity(0.2),
            ),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.08),
                blurRadius: 20,
                offset: const Offset(0, 10),
              ),
            ],
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              /// 🟡 WARNING ICON (not error)
              Container(
                width: 56,
                height: 56,
                decoration: BoxDecoration(
                  color: cs.secondary.withOpacity(0.12),
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  Icons.pause_circle_outline,
                  color: cs.secondary,
                  size: 28,
                ),
              ),

              const SizedBox(height: 14),

              /// 🔹 TITLE (specific intent)
              Text(
                "Deactivate Account?",
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w700,
                  color: cs.onSurface,
                ),
              ),

              const SizedBox(height: 8),

              /// 🔹 MESSAGE
              Text(
                text,
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 13.5,
                  height: 1.5,
                  color: cs.onSurface.withOpacity(0.6),
                ),
              ),

              const SizedBox(height: 22),

              /// 🔹 ACTIONS
              Row(
                children: [
                  /// CANCEL
                  Expanded(
                    child: OutlinedButton(
                      onPressed: () => Get.back(),
                      style: OutlinedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(vertical: 12),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        side: BorderSide(
                          color: cs.outline.withOpacity(0.4),
                        ),
                      ),
                      child: Text(
                        "Cancel",
                        style: TextStyle(
                          color: cs.onSurface,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ),

                  const SizedBox(width: 10),

                  /// DEACTIVATE
                  Expanded(
                    child: ElevatedButton(
                      onPressed: () {
                        onConfirm();
                        Get.back();
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: cs.secondary,
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(vertical: 12),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        elevation: 0,
                      ),
                      child: const Text(
                        "Deactivate",
                        style: TextStyle(fontWeight: FontWeight.w600),
                      ),
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

  Widget customDropdownField<T>({
    required BuildContext context,
    required String hint,
    required List<T> items,
    T? value,
    required Function(T) onChanged,
  }) {
    final cs = Theme.of(context).colorScheme;
    final textController = TextEditingController();

    final LayerLink layerLink = LayerLink();
    OverlayEntry? overlayEntry;

    textController.text = value?.toString() ?? "";

    List<T> filteredItems = List.from(items);

    return StatefulBuilder(
      builder: (context, setState) {
        void closeDropdown() {
          overlayEntry?.remove();
          overlayEntry = null;
          setState(() {});
        }

        void openDropdown(BuildContext fieldContext) {
          final renderBox = fieldContext.findRenderObject() as RenderBox;
          final size = renderBox.size;
          final offset = renderBox.localToGlobal(Offset.zero);

          final screenHeight = MediaQuery.of(fieldContext).size.height;

          final spaceBelow = screenHeight - (offset.dy + size.height);
          final spaceAbove = offset.dy;

          final shouldOpenUp = spaceBelow < 250 && spaceAbove > spaceBelow;

          final maxHeight = (shouldOpenUp ? spaceAbove : spaceBelow) - 20;
          final itemHeight = 48.0;
          final listHeight = filteredItems.length * itemHeight;
          final finalHeight = listHeight.clamp(0, maxHeight).toDouble();
          overlayEntry = OverlayEntry(
            builder: (_) {
              return GestureDetector(
                onTap: closeDropdown,
                behavior: HitTestBehavior.translucent,
                child: Stack(
                  children: [
                    Positioned(
                      width: size.width,
                      child: CompositedTransformFollower(
                        link: layerLink,
                        offset: shouldOpenUp
                            ? Offset(0, -finalHeight - 4) // 👈 open upward
                            : Offset(0, size.height + 4), // 👈 open downward
                        child: Material(
                          elevation: 4,
                          borderRadius: BorderRadius.circular(8),
                          child: Container(
                            constraints: BoxConstraints(
                              maxHeight: finalHeight,
                            ),
                            decoration: BoxDecoration(
                              color: cs.outline.withOpacity(0.1),
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: filteredItems.isEmpty
                                ? Padding(
                                    padding: const EdgeInsets.all(16),
                                    child: Text(
                                      "No results found",
                                      style: TextStyle(
                                        fontSize: 13,
                                        color: cs.onSurface.withOpacity(0.6),
                                      ),
                                    ),
                                  )
                                : ListView.builder(
                                    padding: EdgeInsets.zero,
                                    itemCount: filteredItems.length,
                                    itemBuilder: (_, index) {
                                      final item = filteredItems[index];

                                      return InkWell(
                                        onTap: () {
                                          onChanged(item);
                                          textController.text = item.toString();
                                          closeDropdown();
                                        },
                                        child: Padding(
                                          padding: const EdgeInsets.symmetric(
                                            horizontal: 16,
                                            vertical: 12,
                                          ),
                                          child: Text(
                                            item.toString(),
                                            style: TextStyle(
                                              fontSize: 13,
                                              color: cs.onSurface,
                                            ),
                                          ),
                                        ),
                                      );
                                    },
                                  ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              );
            },
          );

          Overlay.of(fieldContext).insert(overlayEntry!);
          setState(() {});
        }

        void filterItems(String query) {
          filteredItems = items
              .where((item) =>
                  item.toString().toLowerCase().contains(query.toLowerCase()))
              .toList();

          overlayEntry?.markNeedsBuild();
        }

        return Builder(
          builder: (fieldContext) {
            return CompositedTransformTarget(
              link: layerLink,
              child: TextFormField(
                controller: textController,
                readOnly: false,
                style: TextStyle(fontSize: 13, color: cs.onSurface),
                onTap: () {
                  if (overlayEntry == null) {
                    filteredItems = List.from(items); // reset
                    openDropdown(fieldContext);
                  }
                },
                onChanged: (value) {
                  if (overlayEntry == null) {
                    openDropdown(fieldContext);
                  }
                  filterItems(value);
                },
                decoration: InputDecoration(
                  hintText: hint,
                  hintStyle: TextStyle(fontSize: 12),
                  filled: true,
                  fillColor: cs.outline.withOpacity(0.1),
                  contentPadding: const EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 11,
                  ),
                  suffixIcon: Icon(
                    overlayEntry != null
                        ? Icons.keyboard_arrow_up
                        : Icons.keyboard_arrow_down,
                    size: 20,
                  ),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: BorderSide.none,
                  ),
                ),
              ),
            );
          },
        );
      },
    );
  }

  Widget customMultiDropdownField<T>({
    required BuildContext context,
    required String hint,
    required List<T> items,
    required RxList<T> selectedItems,
  }) {
    final cs = Theme.of(context).colorScheme;

    final LayerLink layerLink = LayerLink();
    OverlayEntry? overlayEntry;

    final textController = TextEditingController();

    return StatefulBuilder(
      builder: (context, setState) {
        bool isOpen = overlayEntry != null;

        void updateText() {
          textController.text =
              selectedItems.isEmpty ? "" : "${selectedItems.length} selected";
        }

        void toggleItem(T item) {
          if (selectedItems.contains(item)) {
            selectedItems.remove(item);
          } else {
            selectedItems.add(item);
          }
          updateText();
          setState(() {});
        }

        void closeDropdown() {
          overlayEntry?.remove();
          overlayEntry = null;
          setState(() {});
        }

        void openDropdown(BuildContext fieldContext) {
          final renderBox = fieldContext.findRenderObject() as RenderBox;
          final size = renderBox.size;

          overlayEntry = OverlayEntry(
            builder: (_) {
              return GestureDetector(
                onTap: closeDropdown,
                behavior: HitTestBehavior.translucent,
                child: Stack(
                  children: [
                    Positioned(
                      width: size.width,
                      child: CompositedTransformFollower(
                        link: layerLink,
                        offset: Offset(0, size.height + 4),
                        child: Material(
                          elevation: 4,
                          borderRadius: BorderRadius.circular(8),
                          child: Container(
                            constraints: BoxConstraints(
                              maxHeight:
                                  items.length > 5 ? 240 : items.length * 48.0,
                            ),
                            decoration: BoxDecoration(
                              color: cs.outline.withOpacity(0.1),
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: Obx(() {
                              updateText(); // 🔥 keep text synced

                              return ListView.builder(
                                padding: EdgeInsets.zero,
                                shrinkWrap: true,
                                itemCount: items.length,
                                itemBuilder: (_, index) {
                                  final item = items[index];
                                  final isSelected =
                                      selectedItems.contains(item);

                                  return InkWell(
                                    onTap: () => toggleItem(item),
                                    child: Container(
                                      padding: const EdgeInsets.symmetric(
                                        horizontal: 12,
                                        vertical: 10,
                                      ),
                                      child: Row(
                                        children: [
                                          Checkbox(
                                            value: isSelected,
                                            onChanged: (_) => toggleItem(item),
                                          ),
                                          Expanded(
                                            child: Text(
                                              item.toString(),
                                              style: TextStyle(
                                                fontSize: 13,
                                                color: cs.onSurface,
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  );
                                },
                              );
                            }),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              );
            },
          );

          Overlay.of(fieldContext).insert(overlayEntry!);
          setState(() {});
        }

        return Builder(
          builder: (fieldContext) {
            return CompositedTransformTarget(
              link: layerLink,
              child: GestureDetector(
                onTap: () {
                  if (overlayEntry == null) {
                    openDropdown(fieldContext);
                  } else {
                    closeDropdown();
                  }
                },
                child: AbsorbPointer(
                  child: Obx(() {
                    updateText(); // 🔥 update UI

                    return TextFormField(
                      controller: textController,
                      readOnly: true,
                      style: TextStyle(
                        fontSize: 13,
                        color: cs.onSurface,
                      ),
                      decoration: InputDecoration(
                        hintText: hint,
                        hintStyle: TextStyle(
                          fontSize: 12,
                          color: cs.onSurface,
                        ),
                        filled: true,
                        fillColor: cs.outline.withOpacity(0.1),
                        contentPadding: const EdgeInsets.symmetric(
                          horizontal: 12,
                          vertical: 11,
                        ),
                        suffixIcon: Icon(
                          isOpen
                              ? Icons.keyboard_arrow_up
                              : Icons.keyboard_arrow_down,
                          size: 20,
                        ),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide:
                              const BorderSide(color: Colors.transparent),
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide:
                              const BorderSide(color: Colors.transparent),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide: const BorderSide(
                            color: Colors.transparent,
                            width: 1.5,
                          ),
                        ),
                      ),
                    );
                  }),
                ),
              ),
            );
          },
        );
      },
    );
  }

  void showCustomDialog({
    required BuildContext context,
    required Widget title,
    IconData? icon,
    required GlobalKey<FormState> formKey,
    required List<Widget> sections,
    required VoidCallback onSubmit,
    bool isViewOnly = false,
    String submitText = "Save",
  }) {
    final cs = Theme.of(context).colorScheme;
    Get.dialog(
      Dialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(28),
        ),
        insetPadding: const EdgeInsets.symmetric(horizontal: 16),
        child: Form(
          key: formKey,
          child: ConstrainedBox(
            constraints: BoxConstraints(
              maxHeight: MediaQuery.of(context).size.height * 0.85,
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                /// 🔷 HEADER
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.fromLTRB(20, 20, 20, 18),
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [
                        cs.primary,
                        cs.secondary.withOpacity(0.4),
                      ],
                    ),
                    borderRadius: const BorderRadius.vertical(
                      top: Radius.circular(28),
                    ),
                  ),
                  child: Row(
                    children: [
                      if (icon != null)
                        Container(
                          padding: const EdgeInsets.all(10),
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                          ),
                          child: Icon(icon, color: Colors.white),
                        ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: DefaultTextStyle(
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.w600,
                            color: Colors.white,
                          ),
                          child: title,
                        ),
                      ),
                      IconButton(
                        onPressed: () => Get.back(),
                        icon: Icon(Icons.close, color: Colors.white),
                      )
                    ],
                  ),
                ),

                /// 🔷 BODY
                Flexible(
                  child: SingleChildScrollView(
                    child: Padding(
                      padding: const EdgeInsets.fromLTRB(16, 18, 16, 10),
                      child: Column(children: sections),
                    ),
                  ),
                ),

                /// 🔷 ACTIONS
                if (isViewOnly == false)
                  Container(
                    padding: const EdgeInsets.fromLTRB(16, 10, 16, 16),
                    decoration: BoxDecoration(
                      color:
                          context.theme.colorScheme.outline.withOpacity(0.03),
                      borderRadius: const BorderRadius.vertical(
                        bottom: Radius.circular(28),
                      ),
                    ),
                    child: Row(
                      children: [
                        Expanded(
                          child: OutlinedButton(
                            style: OutlinedButton.styleFrom(
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10),
                              ),
                            ),
                            onPressed: () => Get.back(),
                            child: Text(
                              "Cancel",
                              style: TextStyle(
                                  color: context.theme.colorScheme.onSurface),
                            ),
                          ),
                        ),
                        const SizedBox(width: 10),
                        Expanded(
                          child: ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              backgroundColor:
                                  context.theme.colorScheme.secondary,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10),
                              ),
                            ),
                            onPressed: () {
                              if (!formKey.currentState!.validate()) return;
                              onSubmit();
                              Get.back();
                            },
                            child: Text(
                              submitText,
                              style: TextStyle(color: Colors.white),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget labelWithAsterisk(String text, {bool required = false}) {
    return Align(
      alignment: Alignment.centerLeft,
      child: RichText(
        text: TextSpan(
          text: text,
          style: TextStyle(
            color: Get.theme.colorScheme.onSurface,
            fontSize: 13,
          ),
          children: required
              ? [
                  const TextSpan(
                    text: " *",
                    style: TextStyle(color: Colors.red),
                  )
                ]
              : [],
        ),
      ),
    );
  }

  Widget sectionCard({
    required IconData icon,
    required String title,
    required Widget child,
  }) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: Colors.grey.withOpacity(0.04),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.grey.withOpacity(0.1)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(icon, size: 18),
              const SizedBox(width: 6),
              Text(
                title,
                style: const TextStyle(fontWeight: FontWeight.w600),
              ),
            ],
          ),
          const SizedBox(height: 10),
          child,
        ],
      ),
    );
  }

  Widget attachmentStyledField({
    required BuildContext context,
    required String hint,
    String? label,
    String? fileName,
    VoidCallback? onTap,
    VoidCallback? onClear,
  }) {
    final cs = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;

    final hasFile = fileName != null && fileName.isNotEmpty;

    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(12),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 11),
        decoration: BoxDecoration(
          color: cs.outline.withOpacity(0.1),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: Colors.transparent),
        ),
        child: Row(
          children: [
            Icon(
              Icons.attach_file,
              size: 18,
              color: cs.onSurface.withOpacity(0.7),
            ),
            const SizedBox(width: 10),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  if (label != null)
                    Text(
                      label,
                      style: textTheme.labelSmall?.copyWith(
                        color: cs.onSurface.withOpacity(0.6),
                      ),
                    ),
                  Text(
                    hasFile ? fileName : hint,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: textTheme.bodySmall?.copyWith(
                      color: hasFile
                          ? cs.onSurface
                          : cs.onSurface.withOpacity(0.5),
                    ),
                  ),
                ],
              ),
            ),
            if (hasFile && onClear != null)
              IconButton(
                icon: Icon(
                  Icons.close,
                  size: 16,
                  color: cs.error,
                ),
                onPressed: onClear,
                splashRadius: 18,
              )
            else
              Icon(
                Icons.upload_file,
                size: 18,
                color: cs.onSurface.withOpacity(0.5),
              ),
          ],
        ),
      ),
    );
  }

  Widget dropdownStyledTextField({
    required BuildContext context,
    required String hint,
    String? label,
    TextEditingController? controller,
    int? minlines,
    bool isMultiline = false,
    bool isNumber = false,
    bool readOnly = false,
    VoidCallback? onTap,
  }) {
    final cs = Theme.of(context).colorScheme;

    return TextFormField(
      controller: controller,
      style: TextStyle(fontSize: 12),
      inputFormatters: isNumber
          ? [FilteringTextInputFormatter.allow(RegExp(r'[0-9]'))]
          : null,
      readOnly: readOnly,
      onTap: onTap,
      minLines: isMultiline ? 3 : 1,
      maxLines: isMultiline ? null : 1,
      keyboardType: isMultiline
          ? TextInputType.multiline
          : isNumber
              ? TextInputType.number
              : TextInputType.text,
      textInputAction:
          isMultiline ? TextInputAction.newline : TextInputAction.done,
      decoration: InputDecoration(
        labelText: label,
        hintText: hint,
        hintStyle: TextStyle(
          fontSize: 12,
          color: context.theme.colorScheme.onSurface,
        ),
        // isDense: true,
        filled: true,
        fillColor: cs.outline.withOpacity(0.1),
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 12,
          vertical: 11,
        ),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(
            color: Colors.transparent,
          ),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(
            color: Colors.transparent,
          ),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(
            color: Colors.transparent,
            width: 1.5,
          ),
        ),
      ),
    );
  }

  Widget customDatePickerField({
    required BuildContext context,
    required TextEditingController controller,
    required Rxn<DateTime> selectedDate,
  }) {
    final LayerLink layerLink = LayerLink();
    OverlayEntry? overlayEntry;

    void showOverlay() {
      final renderBox = context.findRenderObject() as RenderBox;
      final size = renderBox.size;
      final offset = renderBox.localToGlobal(Offset.zero);

      final screenHeight = MediaQuery.of(context).size.height;
      const popupHeight = 320;

      final showAbove = (offset.dy + size.height + popupHeight > screenHeight);

      overlayEntry = OverlayEntry(
        builder: (context) => Stack(
          children: [
            /// 🔴 Background
            Positioned.fill(
              child: GestureDetector(
                onTap: () => overlayEntry?.remove(),
                behavior: HitTestBehavior.translucent,
                child: const SizedBox(),
              ),
            ),

            /// 🟢 Calendar
            Positioned(
              width: 280,
              child: CompositedTransformFollower(
                link: layerLink,
                offset: Offset(
                  0,
                  showAbove ? -popupHeight - 10 : 55, // 👈 dynamic position
                ),
                child: Material(
                  elevation: 8,
                  borderRadius: BorderRadius.circular(12),
                  child: calendarPopupWidget(
                    context: context,
                    selectedDate: selectedDate.value,
                    onDateSelected: (date) {
                      controller.text = DateFormat('dd MMM yyyy').format(date);
                      selectedDate.value = date;
                      overlayEntry?.remove();
                    },
                  ),
                ),
              ),
            ),
          ],
        ),
      );

      Overlay.of(context).insert(overlayEntry!);
    }

    return CompositedTransformTarget(
      link: layerLink,
      child: TextFormField(
        controller: controller,
        readOnly: true,
        onTap: showOverlay,
        style: const TextStyle(fontSize: 12),
        decoration: InputDecoration(
          hintText: "Select Date",
          hintStyle: TextStyle(
            fontSize: 12,
            color: context.theme.colorScheme.onSurface,
          ),
          filled: true,
          fillColor: Theme.of(context).colorScheme.outline.withOpacity(0.1),
          contentPadding:
              const EdgeInsets.symmetric(horizontal: 12, vertical: 11),
          suffixIcon: const Icon(Icons.calendar_today, size: 18),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: BorderSide.none,
          ),
        ),
      ),
    );
  }

  Widget calendarPopupWidget({
    required BuildContext context,
    required Function(DateTime) onDateSelected,
    DateTime? selectedDate,
  }) {
    DateTime currentMonth = selectedDate ?? DateTime.now();

    bool showMonthPicker = false;
    bool showYearPicker = false;

    return StatefulBuilder(
      builder: (context, setState) {
        final firstDay = DateTime(currentMonth.year, currentMonth.month, 1);

        final daysInMonth =
            DateUtils.getDaysInMonth(currentMonth.year, currentMonth.month);

        final startWeekday = firstDay.weekday % 7;

        /// 🔷 MONTH PICKER
        if (showMonthPicker) {
          return _monthPicker(
            context,
            currentMonth,
            (month) {
              setState(() {
                currentMonth = DateTime(currentMonth.year, month, 1);
                showMonthPicker = false;
              });
            },
          );
        }

        /// 🔷 YEAR PICKER
        if (showYearPicker) {
          return _yearPicker(
            context,
            currentMonth,
            (year) {
              setState(() {
                currentMonth = DateTime(year, currentMonth.month, 1);
                showYearPicker = false;
              });
            },
          );
        }

        /// 🔷 MAIN CALENDAR
        return Container(
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: context.theme.colorScheme.surface,
            borderRadius: BorderRadius.circular(12),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              /// 🔷 HEADER (clickable)
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  IconButton(
                    icon: const Icon(Icons.chevron_left, size: 18),
                    onPressed: () {
                      setState(() {
                        currentMonth =
                            DateTime(currentMonth.year, currentMonth.month - 1);
                      });
                    },
                  ),

                  /// 🔥 MONTH CLICK
                  GestureDetector(
                    onTap: () {
                      setState(() {
                        showMonthPicker = true;
                      });
                    },
                    child: Text(
                      monthName(currentMonth.month),
                      style: const TextStyle(
                          fontWeight: FontWeight.w600, fontSize: 13),
                    ),
                  ),

                  /// 🔥 YEAR CLICK
                  GestureDetector(
                    onTap: () {
                      setState(() {
                        showYearPicker = true;
                      });
                    },
                    child: Text(
                      "${currentMonth.year}",
                      style: const TextStyle(
                          fontWeight: FontWeight.w600, fontSize: 13),
                    ),
                  ),

                  IconButton(
                    icon: const Icon(Icons.chevron_right, size: 18),
                    onPressed: () {
                      setState(() {
                        currentMonth =
                            DateTime(currentMonth.year, currentMonth.month + 1);
                      });
                    },
                  ),
                ],
              ),

              const SizedBox(height: 6),

              /// WEEKDAYS
              Row(
                children: ["S", "M", "T", "W", "T", "F", "S"]
                    .map((d) => Expanded(
                          child: Center(
                            child: Text(
                              d,
                              style: TextStyle(
                                fontSize: 10,
                                color: context.theme.colorScheme.onSurface
                                    .withOpacity(0.5),
                              ),
                            ),
                          ),
                        ))
                    .toList(),
              ),

              const SizedBox(height: 6),

              /// GRID
              GridView.builder(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemCount: daysInMonth + startWeekday,
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 7,
                  ),
                  itemBuilder: (context, index) {
                    if (index < startWeekday) return const SizedBox();

                    final day = index - startWeekday + 1;
                    final date =
                        DateTime(currentMonth.year, currentMonth.month, day);

                    final now = DateTime.now();
                    final today = DateTime(now.year, now.month, now.day);

                    final isPast = date.isBefore(today);
                    final isToday = date.year == today.year &&
                        date.month == today.month &&
                        date.day == today.day;

                    final isSelected = selectedDate != null &&
                        selectedDate.day == day &&
                        selectedDate.month == currentMonth.month &&
                        selectedDate.year == currentMonth.year;

                    return GestureDetector(
                      onTap: isPast
                          ? null // ❌ disable past
                          : () => onDateSelected(date),
                      child: Center(
                        child: Container(
                          width: 28,
                          height: 28,
                          alignment: Alignment.center,

                          /// 🎯 DECORATION LOGIC
                          decoration: isSelected
                              ? BoxDecoration(
                                  shape: BoxShape.circle,
                                  color: context.theme.colorScheme.primary,
                                )
                              : isToday
                                  ? BoxDecoration(
                                      shape: BoxShape.circle,
                                      border: Border.all(
                                        color:
                                            context.theme.colorScheme.primary,
                                      ),
                                    )
                                  : null,

                          child: Text(
                            "$day",
                            style: TextStyle(
                              fontSize: 11,

                              /// 🎨 TEXT COLOR LOGIC
                              color: isPast
                                  ? context.theme.colorScheme.onSurface
                                      .withOpacity(0.3) // faded
                                  : isSelected
                                      ? context.theme.colorScheme.onPrimary
                                      : context.theme.colorScheme.onSurface,

                              fontWeight: isSelected
                                  ? FontWeight.w600
                                  : FontWeight.w400,
                            ),
                          ),
                        ),
                      ),
                    );
                  }),
            ],
          ),
        );
      },
    );
  }

  Widget _monthPicker(
      BuildContext context, DateTime current, Function(int) onSelect) {
    return Container(
      padding: const EdgeInsets.all(12),
      child: GridView.count(
        shrinkWrap: true,
        crossAxisCount: 3,
        children: List.generate(12, (i) {
          return InkWell(
            onTap: () => onSelect(i + 1),
            child: Center(
              child: Text(
                monthName(i + 1),
                style: const TextStyle(fontSize: 12),
              ),
            ),
          );
        }),
      ),
    );
  }

  Widget _yearPicker(
      BuildContext context, DateTime current, Function(int) onSelect) {
    final startYear = DateTime.now().year;

    return Container(
      padding: const EdgeInsets.all(12),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: List.generate(3, (i) {
          final year = startYear + i;
          return ListTile(
            title: Center(child: Text("$year")),
            onTap: () => onSelect(year),
          );
        }),
      ),
    );
  }

  String monthName(int month) {
    const months = [
      "January",
      "February",
      "March",
      "April",
      "May",
      "June",
      "July",
      "August",
      "September",
      "October",
      "November",
      "December"
    ];
    return months[month - 1];
  }

  Widget timePickerStyledField({
    required BuildContext context,
    required TextEditingController controller,
    required Rxn<TimeOfDay> selectedTime,
    String hint = "Select Time",
    String? label,
  }) {
    final cs = Theme.of(context).colorScheme;

    Future<void> pickTime() async {
      final TimeOfDay? picked = await showTimePicker(
        context: context,
        initialTime: selectedTime.value ?? TimeOfDay.now(),
        initialEntryMode: TimePickerEntryMode.input,
        builder: (context, child) {
          return Theme(
            data: Theme.of(context).copyWith(
              timePickerTheme: TimePickerThemeData(
                dayPeriodColor: cs.primary,
              ),
            ),
            child: child!,
          );
        },
      );

      if (picked != null) {
        selectedTime.value = picked;
        final now = DateTime.now();
        final dt = DateTime(
          now.year,
          now.month,
          now.day,
          picked.hour,
          picked.minute,
        );

        controller.text = DateFormat('hh:mm a').format(dt);
      }
    }

    return TextFormField(
      controller: controller,
      readOnly: true,
      onTap: pickTime,
      style: const TextStyle(fontSize: 12),
      decoration: InputDecoration(
        labelText: label,
        hintText: hint,
        hintStyle: TextStyle(
          fontSize: 12,
          color: context.theme.colorScheme.onSurface,
        ),
        filled: true,
        fillColor: cs.outline.withOpacity(0.1),
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 12,
          vertical: 11,
        ),
        suffixIcon: const Icon(Icons.access_time),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: Colors.transparent),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: Colors.transparent),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: Colors.transparent, width: 1.5),
        ),
      ),
    );
  }
}

class AppFAB extends StatelessWidget {
  final String label;
  final IconData icon;
  final VoidCallback onPressed;

  const AppFAB({
    super.key,
    required this.label,
    required this.onPressed,
    this.icon = Icons.add_rounded,
  });

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;

    return FloatingActionButton.extended(
      onPressed: onPressed,
      backgroundColor: cs.primary,
      foregroundColor: cs.onPrimary,
      elevation: 3,
      icon: Icon(icon, size: 20),
      label: Text(
        label,
        style: const TextStyle(
          fontWeight: FontWeight.w600,
          fontSize: 14,
        ),
      ),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
    );
  }
}

class AppFormDialog {
  static void show({
    required BuildContext context,
    required Widget title,
    required List<Widget> children,
    required VoidCallback onSubmit,
    GlobalKey<FormState>? formKey,
    bool isViewOnly = false,
    String submitText = "Save",
  }) {
    final textTheme = Theme.of(context).textTheme;

    CustomWidgets().showCustomDialog(
      context: context,
      title: DefaultTextStyle(
        style: Theme.of(context)
            .textTheme
            .titleLarge!
            .copyWith(color: Colors.white),
        child: title,
      ),
      formKey: formKey ?? GlobalKey<FormState>(),
      onSubmit: onSubmit,
      isViewOnly: isViewOnly,
      submitText: submitText,
      sections: [
        DefaultTextStyle(
          style: textTheme.bodyMedium!,
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: children,
            ),
          ),
        ),
      ],
    );
  }
}
