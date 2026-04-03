import 'package:flutter/material.dart';

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
              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
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
