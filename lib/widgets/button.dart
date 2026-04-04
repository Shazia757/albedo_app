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
