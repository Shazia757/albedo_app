import 'package:albedo_app/controller/auth_controller.dart';
import 'package:albedo_app/controller/permissions_controller.dart';
import 'package:albedo_app/controller/settings_controller.dart';
import 'package:albedo_app/view/notifications_page.dart';
import 'package:albedo_app/view/settings/assessments_page.dart';
import 'package:albedo_app/view/settings/backup_page.dart';
import 'package:albedo_app/view/settings/banner_ads_page.dart';
import 'package:albedo_app/view/settings/bulk_upload_page.dart';
import 'package:albedo_app/view/settings/coupons_page.dart';
import 'package:albedo_app/view/settings/general/general_page.dart';
import 'package:albedo_app/view/settings/hiring_page.dart';
import 'package:albedo_app/view/settings/macro_page.dart';
import 'package:albedo_app/view/settings/materials_page.dart';
import 'package:albedo_app/view/settings/recommendation_page.dart';
import 'package:albedo_app/view/settings/star_page.dart';

import 'package:albedo_app/widgets/custom_appbar.dart';
import 'package:albedo_app/widgets/drawer_menu.dart';
import 'package:albedo_app/widgets/responsive.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class SettingsPage extends StatelessWidget {
  final c = Get.put(SettingsController());

  SettingsPage({super.key});

  final List<_SettingsItem> items = [
    _SettingsItem("General", Icons.settings, GeneralPage()),
    _SettingsItem("Notifications", Icons.notifications, NotificationsPage()),
    _SettingsItem("Banner Ads", Icons.campaign, BannerAdsPage()),
    _SettingsItem("Coupons", Icons.confirmation_number, CouponsPage()),
    _SettingsItem("Recommendation", Icons.thumb_up, RecommendationPage()),
    _SettingsItem("Hiring", Icons.work, HiringPage()),
    _SettingsItem("Star of Month", Icons.star, StarOfMonthPage()),
    _SettingsItem("Automation", Icons.auto_mode, MacroPage()),
    _SettingsItem("Assessments", Icons.assignment, AssessmentsPage()),
    _SettingsItem("Materials", Icons.menu_book, MaterialsPage()),
    _SettingsItem("Bulk Upload", Icons.upload_file, BulkUploadPage()),
    _SettingsItem("Backup", Icons.backup, BackupPage()),
  ];

  @override
  Widget build(BuildContext context) {
    final isDesktop = Responsive.isDesktop(context);

    int crossAxisCount = isDesktop ? 4 : 2;

    return Scaffold(
      appBar: const CustomAppBar(),
      backgroundColor: Theme.of(context).colorScheme.surface,
      drawer: isDesktop ? null : const DrawerMenu(),
      body: Row(
        children: [
          if (isDesktop) const DrawerMenu(),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Obx(
                () {
                  final auth = Get.find<AuthController>();
                  final role = auth.activeUser?.role;

                  final isCustom = ![
                    "admin",
                    "mentor",
                    "advisor",
                    "teacher",
                    "student",
                    "coordinator",
                    "finance",
                    "sales",
                    "hr"
                  ].contains(role);

                  final visibleItems = !isCustom
                      ? items
                      : items.where((item) {
                          final perm = c.settingsPermissions[item.title];
                          return perm != null && PermissionService.can(perm);
                        }).toList();
                  return GridView.builder(
                    itemCount: visibleItems.length,
                    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: crossAxisCount,
                      crossAxisSpacing: 12,
                      mainAxisSpacing: 12,
                      childAspectRatio: 1, // makes it square
                    ),
                    itemBuilder: (context, index) {
                      final item = visibleItems[index];

                      return InkWell(
                        borderRadius: BorderRadius.circular(16),
                        onTap: () {
                          Get.to(() => item.page);
                        },
                        child: Card(
                          elevation: 2,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(16),
                          ),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(
                                item.icon,
                                size: 32,
                                color: Theme.of(context).colorScheme.primary,
                              ),
                              const SizedBox(height: 10),
                              Padding(
                                padding:
                                    const EdgeInsets.symmetric(horizontal: 8),
                                child: Text(
                                  item.title,
                                  textAlign: TextAlign.center,
                                  style: const TextStyle(
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  );
                },
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _SettingsItem {
  final String title;
  final IconData icon;
  final Widget page;

  _SettingsItem(this.title, this.icon, this.page);
}
