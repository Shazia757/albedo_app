import 'package:albedo_app/controller/settings_controller.dart';
import 'package:albedo_app/view/settings/banner_ads_page.dart';
import 'package:albedo_app/widgets/custom_appbar.dart';
import 'package:albedo_app/widgets/drawer_menu.dart';
import 'package:albedo_app/widgets/responsive.dart';
import 'package:albedo_app/widgets/widgets.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class BulkUploadPage extends StatelessWidget {
  BulkUploadPage({super.key});

  final SettingsController c = Get.find<SettingsController>();

  @override
  Widget build(BuildContext context) {
    final cs = Get.theme.colorScheme;
    final isDesktop = Responsive.isDesktop(context);

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
                      style:
                          Get.textTheme.titleLarge!.copyWith(color: cs.primary),
                    ),
                    SizedBox(height: 12),

                    /// MAIN CARD
                    CustomCard(
                      c: c,
                      content: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            "Download sample CSV templates or upload bulk data for students, teachers, and mentors.",
                            style: Get.textTheme.bodySmall!.copyWith(
                                color: cs.onSurface.withOpacity(0.6),
                                height: 1.4),
                          ),

                          SizedBox(height: 20),

                          /// TEMPLATE BUTTONS
                          _actionButton(
                            context,
                            label: "Sample CSV - Students",
                            icon: Icons.download,
                            color: cs.primary,
                            onTap: () {},
                          ),
                          SizedBox(height: 12),

                          _actionButton(
                            context,
                            label: "Sample CSV - Teachers",
                            icon: Icons.download,
                            color: Colors.green,
                            onTap: () {},
                          ),
                          SizedBox(height: 12),

                          _actionButton(
                            context,
                            label: "Sample CSV - Mentors",
                            icon: Icons.download,
                            color: Colors.orange,
                            onTap: () {},
                          ),

                          SizedBox(height: 16),
                          Divider(color: cs.outline.withOpacity(0.2)),
                          SizedBox(height: 16),

                          /// PRIMARY UPLOAD BUTTON
                          SizedBox(
                            width: double.infinity,
                            height: 48,
                            child: ElevatedButton.icon(
                              onPressed: () => bulkUploadDialog(context),
                              icon: const Icon(Icons.cloud_upload),
                              label: Text("Bulk Upload"),
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

  void bulkUploadDialog(BuildContext context) {
    final formKey = GlobalKey<FormState>();

    final RxString selectedType = 'student'.obs;
    final RxnString selectedFileName = RxnString();
    final Rxn<String> selectedFilePath = Rxn<String>();

    CustomWidgets().showCustomDialog(
      context: context,
      title: const Text('Bulk Upload'),
      icon: Icons.upload_file,
      formKey: formKey,
      submitWidget: Obx(
        () => SizedBox(
          width: 80,
          child: Center(
            child: c.isLoading.value
                ? const SizedBox(
                    width: 18,
                    height: 18,
                    child: CircularProgressIndicator(
                      strokeWidth: 2,
                      color: Colors.white,
                    ),
                  )
                : const Text(
                    "Upload",
                    style: TextStyle(color: Colors.white),
                  ),
          ),
        ),
      ),
      sections: [
        /// TYPE SELECTION
        CustomWidgets().labelWithAsterisk('Select Type'),
        const SizedBox(height: 10),

        Obx(
          () => Column(
            children: [
              RadioListTile(
                dense: true,
                title: const Text("Student"),
                value: "student",
                groupValue: selectedType.value,
                onChanged: (val) => selectedType.value = val.toString(),
              ),
              RadioListTile(
                dense: true,
                title: const Text("Teacher"),
                value: "teacher",
                groupValue: selectedType.value,
                onChanged: (val) => selectedType.value = val.toString(),
              ),
              RadioListTile(
                dense: true,
                title: const Text("Mentor"),
                value: "mentor",
                groupValue: selectedType.value,
                onChanged: (val) => selectedType.value = val.toString(),
              ),
            ],
          ),
        ),

        const SizedBox(height: 10),

        /// FILE PICKER
        CustomWidgets().labelWithAsterisk('Upload File (CSV only)'),
        const SizedBox(height: 10),

        Obx(
          () => InkWell(
            onTap: () async {
              final file = await c.pickCsvFile();
              // return File or path

              if (file != null) {
                selectedFilePath.value = file.path;
                selectedFileName.value = file.path.split('/').last;
              }
            },
            borderRadius: BorderRadius.circular(12),
            child: Container(
              height: 120,
              width: double.infinity,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: Colors.grey.shade400),
              ),
              child: Center(
                child: selectedFileName.value == null
                    ? Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: const [
                          Icon(Icons.upload_file, size: 32),
                          SizedBox(height: 8),
                          Text("Tap to upload CSV file"),
                        ],
                      )
                    : Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Icon(Icons.insert_drive_file, size: 32),
                          const SizedBox(height: 8),
                          Text(selectedFileName.value!),
                        ],
                      ),
              ),
            ),
          ),
        ),
      ],

      /// SUBMIT
      onSubmit: () async {
        if (selectedFilePath.value == null) {
          Get.snackbar("Error", "Please upload a CSV file");
          return;
        }

        await c.bulkUpload();
      },
    );
  }

  Widget _actionButton(
    BuildContext context, {
    required String label,
    required IconData icon,
    required Color color,
    required VoidCallback onTap,
  }) {
    final cs = Get.theme.colorScheme;

    return SizedBox(
      width: double.infinity,
      height: 48,
      child: OutlinedButton.icon(
        onPressed: onTap,
        icon: Icon(icon, size: 18, color: color),
        label: Text(
          label,
          style: Get.textTheme.titleSmall!.copyWith(color: cs.onSurface),
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
