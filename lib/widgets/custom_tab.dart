import 'package:albedo_app/controller/payment_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class Tabs extends StatelessWidget {
  final RxInt selectedIndex;
  final List<String> labels;
  final Function(int) onTap;

  const Tabs({
    super.key,
    required this.selectedIndex,
    required this.labels,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: List.generate(labels.length, (index) {
            return _TabItem(
              label: labels[index],
              index: index,
              selectedIndex: selectedIndex,
              onTap: onTap,
              cs: cs,
            );
          }),
        ),
        Divider(
          height: 1,
          thickness: 0.5,
          color: cs.outlineVariant.withOpacity(0.4),
        ),
      ],
    );
  }
}

class _TabItem extends StatelessWidget {
  final String label;
  final int index;
  final RxInt selectedIndex;
  final Function(int) onTap;
  final ColorScheme cs;

  const _TabItem({
    required this.label,
    required this.index,
    required this.selectedIndex,
    required this.onTap,
    required this.cs,
  });

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      final isOn = selectedIndex.value == index;

      return Expanded(
        child: GestureDetector(
          onTap: () => onTap(index),
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 180),
            padding: const EdgeInsets.symmetric(vertical: 10),
            decoration: BoxDecoration(
              border: Border(
                bottom: BorderSide(
                  color: isOn ? cs.primary : Colors.transparent,
                  width: 2,
                ),
              ),
            ),
            child: Text(
              label,
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 13,
                fontWeight: isOn ? FontWeight.w500 : FontWeight.w400,
                color: isOn ? cs.primary : cs.onSurface.withOpacity(0.45),
              ),
            ),
          ),
        ),
      );
    });
  }
}
