import 'package:flutter/material.dart';

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
