import 'package:flutter/material.dart';
import 'package:get/get.dart';

class CustomTextField extends StatelessWidget {
  final String hint;
  final String? errorText;
  final String? helperText;

  final TextEditingController controller;

  final bool isPassword;
  final RxBool obscure;

  final IconData prefixIcon;

  final TextInputType keyboardType;
  final TextInputAction textInputAction;
  final Iterable<String>? autofillHints;

  CustomTextField({
    super.key,
    required this.hint,
    required this.controller,
    required this.prefixIcon,
    this.errorText,
    this.helperText,
    this.isPassword = false,
    RxBool? obscure,
    this.keyboardType = TextInputType.text,
    this.textInputAction = TextInputAction.next,
    this.autofillHints,
  }) : obscure = obscure ?? false.obs;

  final RxBool isFocused = false.obs;

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;

    return Focus(
      onFocusChange: (value) => isFocused.value = value,
      child: Obx(
        () {
          final hasError = errorText != null && errorText!.isNotEmpty;

          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
           

              /// 🧊 INPUT FIELD
              AnimatedContainer(
                duration: const Duration(milliseconds: 150),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(14),
                  border: Border.all(
                    color: hasError
                        ? cs.error
                        : isFocused.value
                            ? cs.primary
                            : cs.outline.withOpacity(0.6),
                    width: 1.2,
                  ),
                ),
                child: TextField(
                  controller: controller,
                  obscureText: isPassword ? obscure.value : false,
                  keyboardType: keyboardType,
                  textInputAction: textInputAction,
                  autofillHints: autofillHints,
                  cursorColor: cs.primary,
                  style: textTheme.bodyMedium?.copyWith(
                    color: Colors.white,
                  ),
                  decoration: InputDecoration(
                    prefixIcon: Icon(
                      prefixIcon,
                      color: isFocused.value
                          ? cs.primary
                          : cs.onPrimary.withOpacity(0.6),
                    ),
                    hintText: hint,
                    hintStyle: textTheme.bodyMedium?.copyWith(
                      color: cs.onPrimary.withOpacity(0.5),
                    ),
                    border: InputBorder.none,
                    contentPadding: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 14,
                    ),

                    /// 🔐 PASSWORD TOGGLE
                    suffixIcon: isPassword
                        ? IconButton(
                            tooltip: obscure.value
                                ? "Show password"
                                : "Hide password",
                            icon: AnimatedSwitcher(
                              duration: const Duration(milliseconds: 200),
                              child: Icon(
                                obscure.value
                                    ? Icons.visibility_outlined
                                    : Icons.visibility_off_outlined,
                                key: ValueKey(obscure.value),
                                color: cs.onPrimary.withOpacity(0.6),
                              ),
                            ),
                            onPressed: () => obscure.value = !obscure.value,
                          )
                        : null,
                  ),
                ),
              ),

              const SizedBox(height: 8),

              /// ❌ ERROR TEXT
              if (hasError)
                Text(
                  errorText!,
                  style: textTheme.bodySmall?.copyWith(
                    color: cs.error,
                  ),
                )
              else if (helperText != null)
                Text(
                  helperText!,
                  style: textTheme.bodySmall?.copyWith(
                    color: cs.onSurface.withOpacity(0.6),
                  ),
                ),
            ],
          );
        },
      ),
    );
  }
}
