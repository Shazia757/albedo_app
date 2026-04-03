import 'package:flutter/material.dart';

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
