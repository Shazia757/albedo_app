import 'package:flutter/material.dart';

Widget customTabs({
  required List<String> tabs,
  required int selectedIndex,
  required Function(int) onTap,
  required int Function(int index) getCount,
}) {
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
            child: Container(
              margin: const EdgeInsets.only(right: 8),
              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
              decoration: BoxDecoration(
                color:
                    isActive ? const Color(0xFF7F00FF) : Colors.grey.shade200,
                borderRadius: BorderRadius.circular(20),
              ),
              child: Text(
                "${tabs[index]} ($count)",
                style: TextStyle(
                  color: isActive ? Colors.white : Colors.black87,
                  fontSize: 12,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
          );
        }),
      ),
    ),
  );
}
