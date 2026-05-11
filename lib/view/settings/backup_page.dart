import 'package:albedo_app/widgets/custom_appbar.dart';
import 'package:albedo_app/widgets/widgets.dart';
import 'package:flutter/material.dart';

class BackupPage extends StatelessWidget {
  BackupPage({super.key});

  final emailCtrl = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;

    return Scaffold(
      appBar: const CustomAppBar(),
      backgroundColor: cs.surface,
      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Container(
            constraints: const BoxConstraints(
              maxWidth: 420,
            ),
            padding: const EdgeInsets.all(22),
            decoration: BoxDecoration(
              color: cs.onPrimary,
              borderRadius: BorderRadius.circular(28),
              border: Border.all(
                color: cs.outline.withOpacity(.12),
              ),
              boxShadow: [
                BoxShadow(
                  color: cs.shadow.withOpacity(.04),
                  blurRadius: 18,
                  offset: const Offset(0, 6),
                ),
              ],
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                /// ── ICON ─────────────────────────
                Container(
                  width: 68,
                  height: 68,
                  decoration: BoxDecoration(
                    color: cs.primary.withOpacity(.08),
                    borderRadius: BorderRadius.circular(22),
                  ),
                  child: Icon(
                    Icons.backup_rounded,
                    size: 34,
                    color: cs.primary,
                  ),
                ),

                const SizedBox(height: 20),

                /// ── TITLE ────────────────────────
                Text(
                  "Get Backup",
                  style: TextStyle(
                    fontSize: 28,
                    fontWeight: FontWeight.w800,
                    color: cs.onSurface,
                    height: 1.1,
                  ),
                ),

                const SizedBox(height: 10),

                Text(
                  "Receive your latest backup securely through email.",
                  style: TextStyle(
                    fontSize: 14,
                    color: cs.outline,
                    height: 1.5,
                  ),
                ),

                const SizedBox(height: 24),

                /// ── EMAIL FIELD ─────────────────
                CustomWidgets().dropdownStyledTextField(
                  context: context,
                  controller: emailCtrl,
                  hint: "Enter your email",
                ),

                const SizedBox(height: 24),

                /// ── BUTTON ──────────────────────
                SizedBox(
                  width: double.infinity,
                  height: 54,
                  child: ElevatedButton.icon(
                    onPressed: () {
                      /// backup logic
                    },
                    style: ElevatedButton.styleFrom(
                      elevation: 0,
                      backgroundColor: cs.primary,
                      foregroundColor: cs.onPrimary,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(18),
                      ),
                    ),
                    icon: const Icon(
                      Icons.cloud_upload_rounded,
                      color: Colors.white,
                    ),
                    label: const Text(
                      "Backup Now",
                      style: TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.w700,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
