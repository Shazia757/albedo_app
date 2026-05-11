import 'package:albedo_app/controller/settings_controller.dart';
import 'package:albedo_app/view/settings/banner_ads_page.dart';
import 'package:albedo_app/widgets/custom_appbar.dart';
import 'package:albedo_app/widgets/drawer_menu.dart';
import 'package:albedo_app/widgets/responsive.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class BulkUploadPage extends StatelessWidget {
  const BulkUploadPage({super.key});

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    final isDesktop = Responsive.isDesktop(context);
    final c = Get.put(SettingsController());

    return Scaffold(
      backgroundColor: cs.surface,
      appBar: const CustomAppBar(),
      body: Row(
        children: [
          if (isDesktop) const DrawerMenu(),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    /// TITLE (outside card)
                    Text(
                      "Bulk Upload",
                      style: Theme.of(context).textTheme.titleLarge,
                    ),
                    const SizedBox(height: 12),

                    /// MAIN CARD
                    CustomCard(
                      c: c,
                      content: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            "Download sample CSV templates or upload bulk data for students, teachers, and mentors.",
                            style: TextStyle(
                              fontSize: 13,
                              color: cs.onSurface.withOpacity(0.6),
                              height: 1.4,
                            ),
                          ),

                          const SizedBox(height: 20),

                          /// TEMPLATE BUTTONS
                          _actionButton(
                            context,
                            label: "Sample CSV - Students",
                            icon: Icons.download,
                            color: cs.primary,
                            onTap: () {},
                          ),
                          const SizedBox(height: 12),

                          _actionButton(
                            context,
                            label: "Sample CSV - Teachers",
                            icon: Icons.download,
                            color: Colors.green,
                            onTap: () {},
                          ),
                          const SizedBox(height: 12),

                          _actionButton(
                            context,
                            label: "Sample CSV - Mentors",
                            icon: Icons.download,
                            color: Colors.orange,
                            onTap: () {},
                          ),

                          const SizedBox(height: 16),
                          Divider(color: cs.outline.withOpacity(0.2)),
                          const SizedBox(height: 16),

                          /// PRIMARY UPLOAD BUTTON
                          SizedBox(
                            width: double.infinity,
                            height: 48,
                            child: ElevatedButton.icon(
                              onPressed: () {},
                              icon: const Icon(Icons.cloud_upload),
                              label: const Text("Bulk Upload"),
                              style: ElevatedButton.styleFrom(
                                backgroundColor: cs.primary,
                                foregroundColor: cs.onPrimary,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(12),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _label(ColorScheme cs, String text) {
    return Text(
      text,
      style: TextStyle(
        fontSize: 11,
        fontWeight: FontWeight.w600,
        color: cs.onSurface.withOpacity(0.6),
      ),
    );
  }

  Widget _actionButton(
    BuildContext context, {
    required String label,
    required IconData icon,
    required Color color,
    required VoidCallback onTap,
  }) {
    final cs = Theme.of(context).colorScheme;

    return SizedBox(
      width: double.infinity,
      height: 48,
      child: OutlinedButton.icon(
        onPressed: onTap,
        icon: Icon(icon, size: 18, color: color),
        label: Text(
          label,
          style: TextStyle(
            color: cs.onSurface,
            fontWeight: FontWeight.w500,
          ),
        ),
        style: OutlinedButton.styleFrom(
          side: BorderSide(color: cs.outline.withOpacity(0.3)),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          alignment: Alignment.centerLeft,
        ),
      ),
    );
  }
}
