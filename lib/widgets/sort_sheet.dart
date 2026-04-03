import 'package:albedo_app/controller/session_controller.dart';
import 'package:albedo_app/model/session_model.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

void showSortSheet({
  required List<SortOption> options,
  required SortType selectedValue,
  required Function(SortType) onSelected,
  String title = "Sort",
}) {
  SortType tempSelected = selectedValue;

  Get.bottomSheet(
    Container(
      padding: const EdgeInsets.fromLTRB(16, 10, 16, 20),
      decoration: BoxDecoration(
        color: Theme.of(Get.context!).colorScheme.onPrimary,
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
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
                  color: Colors.grey.shade300,
                  borderRadius: BorderRadius.circular(10),
                ),
              ),

              Text(
                title,
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
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
                          ? const Color(0xFF7F00FF).withOpacity(0.08)
                          : Colors.transparent,
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(
                        color: isSelected
                            ? const Color(0xFF7F00FF)
                            : Colors.grey.shade200,
                      ),
                    ),
                    child: Row(
                      children: [
                        Icon(
                          e.icon,
                          size: 18,
                          color: isSelected
                              ? const Color(0xFF7F00FF)
                              : Colors.grey,
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
                                  ? const Color(0xFF7F00FF)
                                  : Colors.black87,
                            ),
                          ),
                        ),
                        if (isSelected)
                          const Icon(
                            Icons.check_circle,
                            color: Color(0xFF7F00FF),
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
    ),
  );
}
