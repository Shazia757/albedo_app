import 'package:albedo_app/controller/session_controller.dart';
import 'package:albedo_app/model/session_model.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

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
}
