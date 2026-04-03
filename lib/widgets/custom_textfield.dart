import 'package:flutter/material.dart';
import 'package:get/get.dart';

class CustomTextField extends StatelessWidget {
  final String hint;
  final TextEditingController controller;
  final bool isPassword;
  final RxBool obscure; // 👈 reactive
  final IconData prefixIcon;

  CustomTextField({
    super.key,
    required this.hint,
    required this.controller,
    this.isPassword = false,
    RxBool? obscure,
    required this.prefixIcon,
  }) : obscure = obscure ?? false.obs;

  final RxBool isFocused = false.obs;

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;

    return Focus(
      onFocusChange: (value) => isFocused.value = value,
      child: Obx(
        () => AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(14),

            /// 🔥 BACKGROUND
            color: cs.primaryContainer.withOpacity(0.25),

            /// 🔥 BORDER
            border: Border.all(
              color: isFocused.value ? cs.primary : cs.outline.withOpacity(0.5),
              width: 1.2,
            ),

            /// 🔥 SHADOW
            boxShadow: [
              if (isFocused.value)
                BoxShadow(
                  color: cs.primary.withOpacity(0.2),
                  blurRadius: 12,
                  offset: const Offset(0, 4),
                )
              else
                BoxShadow(
                  color: cs.shadow.withOpacity(0.05),
                  blurRadius: 8,
                  offset: const Offset(0, 3),
                ),
            ],
          ),
          child: TextField(
            controller: controller,
            obscureText: isPassword ? obscure.value : false,
            style: TextStyle(
              color: cs.onSurface,
              fontSize: 15,
              fontWeight: FontWeight.w500,
            ),
            decoration: InputDecoration(
              prefixIcon: Icon(
                prefixIcon,
                color: isFocused.value
                    ? cs.primary
                    : cs.onSurface.withOpacity(0.6),
              ),
              hintText: hint,
              hintStyle: TextStyle(
                color: cs.onSurface.withOpacity(0.5),
                fontSize: 14,
              ),
              border: InputBorder.none,
              contentPadding: const EdgeInsets.symmetric(
                horizontal: 18,
                vertical: 16,
              ),

              /// 🔥 PASSWORD TOGGLE
              suffixIcon: isPassword
                  ? IconButton(
                      icon: Icon(
                        obscure.value
                            ? Icons.visibility_outlined
                            : Icons.visibility_off_outlined,
                        color: cs.onSurface.withOpacity(0.6),
                      ),
                      onPressed: () => obscure.value = !obscure.value,
                    )
                  : null,
            ),
          ),
        ),
      ),
    );
  }
}
