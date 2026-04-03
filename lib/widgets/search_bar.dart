import 'package:flutter/material.dart';

Widget premiumSearch(
  BuildContext context, {
  required String hint,
  required Function(String) onChanged,
  TextEditingController? controller,
}) {
  return Container(
    height: 44,
    decoration: BoxDecoration(
      color: Theme.of(context).colorScheme.onPrimary,
      borderRadius: BorderRadius.circular(12),
      boxShadow: [
        BoxShadow(
          color: Colors.black.withOpacity(0.05),
          blurRadius: 8,
        )
      ],
    ),
    child: TextField(
      controller: controller,
      onChanged: onChanged,
      style: const TextStyle(fontSize: 14),
      decoration: InputDecoration(
        hintText: hint,
        prefixIcon: const Icon(Icons.search, size: 20),
        border: InputBorder.none,
        contentPadding: const EdgeInsets.symmetric(vertical: 12),
      ),
    ),
  );
}
