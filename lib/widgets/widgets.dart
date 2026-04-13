import 'package:albedo_app/controller/session_controller.dart';
import 'package:albedo_app/model/session_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_typeahead/flutter_typeahead.dart';
import 'package:get/get.dart';

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

  void showSortSheet({
    required List<SortOption> options,
    required SortType selectedValue,
    required Function(SortType) onSelected,
    String title = "Sort",
  }) {
    SortType tempSelected = selectedValue;

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
    required VoidCallback onConfirm,
  }) {
    Get.dialog(
      Dialog(
        backgroundColor: Colors.transparent,
        insetPadding: const EdgeInsets.symmetric(horizontal: 40),
        child: Stack(
          children: [
            /// 🔷 MAIN CARD
            Container(
              padding: const EdgeInsets.fromLTRB(20, 24, 20, 20),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(26),
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  // /// 🗑️ ICON
                  // Image.asset(
                  //   "assets/icons/delete.png", // 👈 use your asset
                  //   height: 70,
                  // ),

                  // const SizedBox(height: 16),

                  /// 🔹 TITLE
                  const Text(
                    "Are you sure?",
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.w700,
                      color: Color(0xFF1F2937),
                    ),
                  ),

                  const SizedBox(height: 10),

                  /// 🔹 MESSAGE
                  const Text(
                    "Are you sure you want to delete this session permanently?",
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 14,
                      color: Color(0xFF6B7280),
                      height: 1.5,
                    ),
                  ),

                  const SizedBox(height: 22),

                  /// 🔹 BUTTONS
                  Row(
                    children: [
                      /// NO BUTTON
                      Expanded(
                        child: Container(
                          height: 48,
                          decoration: BoxDecoration(
                            color: const Color(0xFFE5E7EB),
                            borderRadius: BorderRadius.circular(30),
                          ),
                          child: TextButton(
                            onPressed: () => Get.back(),
                            child: const Text(
                              "No",
                              style: TextStyle(
                                fontSize: 15,
                                color: Color(0xFF111827),
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ),
                        ),
                      ),

                      const SizedBox(width: 12),

                      /// YES BUTTON
                      Expanded(
                        child: Container(
                          height: 48,
                          decoration: BoxDecoration(
                            color: const Color(0xFFEF4444),
                            borderRadius: BorderRadius.circular(30),
                          ),
                          child: TextButton(
                            onPressed: () {
                              onConfirm();
                              Get.back();
                            },
                            child: const Text(
                              "Yes",
                              style: TextStyle(
                                fontSize: 15,
                                color: Colors.white,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),

            /// ❌ CLOSE BUTTON (TOP RIGHT)
            Positioned(
              right: 8,
              top: 8,
              child: GestureDetector(
                onTap: () => Get.back(),
                child: Container(
                  height: 36,
                  width: 36,
                  decoration: const BoxDecoration(
                    color: Color(0xFFE5E7EB),
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(
                    Icons.close,
                    size: 20,
                    color: Color(0xFF374151),
                  ),
                ),
              ),
            ),
          ],
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

    final LayerLink layerLink = LayerLink();

    OverlayEntry? overlayEntry;
    final textController = TextEditingController(
      text: value?.toString() ?? "",
    );

    return StatefulBuilder(
      builder: (context, setState) {
        bool isOpen = overlayEntry != null;

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
                            child: ListView.builder(
                              padding: EdgeInsets.zero,
                              shrinkWrap: true,
                              itemCount: items.length,
                              itemBuilder: (_, index) {
                                final item = items[index];

                                return InkWell(
                                  onTap: () {
                                    onChanged(item);

                                    textController.text = item.toString();

                                    closeDropdown();
                                  },
                                  child: Container(
                                    color: cs.outline.withOpacity(0.1),
                                    padding: const EdgeInsets.symmetric(
                                      horizontal: 16,
                                      vertical: 12,
                                    ),
                                    alignment: Alignment.centerLeft,
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
                  child: TextFormField(
                    controller: textController,
                    style: TextStyle(
                      fontSize: 13,
                      color: cs.onSurface,
                    ),
                    readOnly: true,
                    decoration: InputDecoration(
                      hintText: hint,
                      hintStyle: TextStyle(
                        fontSize: 12,
                        color: cs.onSurface,
                      ),
                      isDense: true,
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
                        borderSide: BorderSide(color: Colors.transparent),
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: BorderSide(color: Colors.transparent),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: BorderSide(
                          color: Colors.transparent,
                          width: 1.5,
                        ),
                      ),
                    ),
                  ),
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
    required String title,
    IconData? icon,
    required GlobalKey<FormState> formKey,
    required List<Widget> sections,
    required VoidCallback onSubmit,
    String submitText = "Save",
  }) {
    Get.dialog(
      Dialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(28),
        ),
        insetPadding: const EdgeInsets.symmetric(horizontal: 16),
        child: Form(
          key: formKey,
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
                      Get.theme.colorScheme.primary,
                      Get.theme.colorScheme.secondary.withOpacity(0.4),
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
                        child: Icon(icon,
                            color: context.theme.colorScheme.inverseSurface),
                      ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Text(
                        title,
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.w600,
                          color: context.theme.colorScheme.inverseSurface,
                        ),
                      ),
                    ),
                    IconButton(
                      onPressed: () => Get.back(),
                      icon: Icon(Icons.close,
                          color: context.theme.colorScheme.onPrimary),
                    )
                  ],
                ),
              ),

              /// 🔷 BODY
              Padding(
                padding: const EdgeInsets.fromLTRB(16, 18, 16, 10),
                child: Column(children: sections),
              ),

              /// 🔷 ACTIONS
              Container(
                padding: const EdgeInsets.fromLTRB(16, 10, 16, 16),
                decoration: BoxDecoration(
                  color: context.theme.colorScheme.outline.withOpacity(0.03),
                  borderRadius: const BorderRadius.vertical(
                    bottom: Radius.circular(28),
                  ),
                ),
                child: Row(
                  children: [
                    Expanded(
                      child: OutlinedButton(
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
                                context.theme.colorScheme.secondary),
                        onPressed: () {
                          if (!formKey.currentState!.validate()) return;
                          onSubmit();
                          Get.back();
                        },
                        child: Text(
                          submitText,
                          style: TextStyle(
                              color: context.theme.colorScheme.inverseSurface),
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

  static searchableDropDown<T>({
    required TextEditingController controller,
    required StringValueOf<T> stringValueOf,
    required void Function(T) onSelected,
    void Function(String)? onChanged,
    required List<T> selectionList,
    TextInputType? keyboardType,
    required String label,
    bool show = true,
    EdgeInsets margin = const EdgeInsets.symmetric(vertical: 5),
    double elevation = 2,
    EdgeInsets padding = const EdgeInsets.symmetric(horizontal: 10),
  }) {
    return Visibility(
      visible: show,
      child: TypeAheadField<T>(
        hideKeyboardOnDrag: true,
        debounceDuration: const Duration(milliseconds: 500),
        builder: (context, controller, focusNode) {
          return CustomWidgets()
              .dropdownStyledTextField(context: context, hint: label);
          // return TextField(
          //   keyboardType: keyboardType,
          //   controller: controller,
          //   focusNode: focusNode,
          //   onChanged: (value) {
          //     if (onChanged != null) {
          //       onChanged(value);
          //     }
          //   },
          //   decoration: InputDecoration(
          //     labelText: label,
          //     border: InputBorder.none,
          //   ),
          // );
        },
        suggestionsCallback: (search) => selectionList
            .where((element) => stringValueOf(element).toLowerCase().contains(
                  search.trim().toLowerCase(),
                ))
            .toList(),
        itemBuilder: (context, itemData) =>
            ListTile(title: Text(stringValueOf(itemData))),
        controller: controller,
        onSelected: (value) => onSelected(value),
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
    bool readOnly = false,
    VoidCallback? onTap,
  }) {
    final cs = Theme.of(context).colorScheme;

    return TextFormField(
      controller: controller,
      style: TextStyle(fontSize: 12),
      readOnly: readOnly,
      onTap: onTap,
      minLines: isMultiline ? 3 : 1,
      maxLines: isMultiline ? null : 1,
      keyboardType: isMultiline ? TextInputType.multiline : TextInputType.text,
      textInputAction:
          isMultiline ? TextInputAction.newline : TextInputAction.done,
      decoration: InputDecoration(
        labelText: label,
        hintText: hint,
        hintStyle: TextStyle(
          fontSize: 12,
          color: context.theme.colorScheme.onSurface,
        ),
        isDense: true,
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

  // Widget inputField({
  //   required TextEditingController controller,
  //   required String label,
  //   bool required = false,
  // }) {
  //   return TextFormField(
  //     controller: controller,
  //     decoration: InputDecoration(
  //       label: RichText(
  //         text: TextSpan(
  //           text: label,
  //           style: TextStyle(color: Colors.black),
  //           children: required
  //               ? [
  //                   const TextSpan(
  //                     text: " *",
  //                     style: TextStyle(color: Colors.red),
  //                   )
  //                 ]
  //               : [],
  //         ),
  //       ),
  //     ),
  //     validator: (val) {
  //       if (required && (val == null || val.isEmpty)) {
  //         return "Required";
  //       }
  //       return null;
  //     },
  //   );
  // }

  Widget dropdownDecoration(String label) {
    return TextFormField(
        decoration: InputDecoration(
      isDense: true,
      labelText: label,
      labelStyle: TextStyle(fontSize: 12),
      filled: true,
      fillColor: Colors.white,
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
      ),
    ));
  }
}
