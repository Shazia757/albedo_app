import 'package:albedo_app/controller/auth_controller.dart';
import 'package:albedo_app/controller/permissions_controller.dart';
import 'package:albedo_app/controller/settings_controller.dart';
import 'package:albedo_app/view/settings/assessments_page.dart';
import 'package:albedo_app/view/settings/backup_page.dart';
import 'package:albedo_app/view/settings/banner_ads_page.dart';
import 'package:albedo_app/view/settings/bulk_upload_page.dart';
import 'package:albedo_app/view/settings/coupons_page.dart';
import 'package:albedo_app/view/settings/general/general_page.dart';
import 'package:albedo_app/view/settings/hiring_page.dart';
import 'package:albedo_app/view/settings/macro_page.dart';
import 'package:albedo_app/view/settings/materials_page.dart';
import 'package:albedo_app/view/settings/notifications_page.dart';
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

  @override
  Widget build(BuildContext context) {
    final isDesktop = Responsive.isDesktop(context);
    final cs = Theme.of(context).colorScheme;

    return Scaffold(
      appBar: const CustomAppBar(),
      backgroundColor: cs.surface,
      drawer: isDesktop ? null : const DrawerMenu(),
      body: Row(
        children: [
          if (isDesktop) const DrawerMenu(),
          Expanded(
            child: Obx(
              () {
                final auth = Get.find<AuthController>();
                final role = auth.activeUser?.position;
                final normalizedRole = role?.trim().toLowerCase();

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
                ].contains(normalizedRole);

                bool canShow(String title) {
                  if (!isCustom) return true;

                  final perm = c.settingsPermissions[title];
                  return perm != null && PermissionService.can(perm);
                }

                return SingleChildScrollView(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "Settings",
                        style: Theme.of(context)
                            .textTheme
                            .headlineMedium
                            ?.copyWith(
                                fontWeight: FontWeight.bold,
                                color: Theme.of(context).colorScheme.primary),
                      ),

                      SizedBox(height: 24),

                      /// CORE SETTINGS
                      _sectionTitle(context, "CORE SETTINGS"),

                      SizedBox(height: 12),

                      _groupCard(
                        context,
                        cs: cs,
                        items: [
                          if (canShow("General"))
                            _TileData(
                              title: "General",
                              subtitle: "Manage application preferences",
                              icon: Icons.settings,
                              page: GeneralPage(),
                            ),
                          // if (canShow("Notifications"))
                          //   _TileData(
                          //     title: "Notifications",
                          //     subtitle: "Configure alerts & notifications",
                          //     icon: Icons.notifications,
                          //     page: NotificationsPage(),
                          //   ),
                          if (canShow("Backup"))
                            _TileData(
                              title: "Backup",
                              subtitle: "Backup and restore system data",
                              icon: Icons.backup,
                              page: BackupPage(),
                            ),
                        ],
                      ),
                      SizedBox(height: 28),

                      /// MARKETING & ENGAGEMENT
                      _sectionTitle(
                        context,
                        "MARKETING & ENGAGEMENT",
                      ),

                      SizedBox(height: 12),

                      _groupCard(
                        cs: cs,
                        context,
                        items: [
                          if (canShow("Banner Ads"))
                            // _TileData(
                            //   title: "Banner Ads",
                            //   subtitle: "Manage promotional banners",
                            //   icon: Icons.campaign,
                            //   page: BannerAdsPage(),
                            // ),
                          // if (canShow("Coupons"))
                          //   _TileData(
                          //     title: "Coupons",
                          //     subtitle: "Create and manage coupons",
                          //     icon: Icons.confirmation_number,
                          //     page: CouponsPage(),
                          //   ),
                          if (canShow("Star of Month"))
                            _TileData(
                              title: "Star of Month",
                              subtitle: "Manage monthly recognitions",
                              icon: Icons.star,
                              page: StarOfMonthPage(),
                            ),
                        ],
                      ),

                      SizedBox(height: 28),

                      /// LEARNING OPERATIONS
                      _sectionTitle(
                        context,
                        "LEARNING OPERATIONS",
                      ),

                      SizedBox(height: 12),

                      _groupCard(
                        cs: cs,
                        context,
                        items: [
                          // if (canShow("Assessments"))
                          //   _TileData(
                          //     title: "Assessments",
                          //     subtitle: "Manage tests and evaluations",
                          //     icon: Icons.assignment,
                          //     page: AssessmentsPage(),
                          //   ),
                          // if (canShow("Materials"))
                          //   _TileData(
                          //     title: "Materials",
                          //     subtitle: "Learning resources & materials",
                          //     icon: Icons.menu_book,
                          //     page: MaterialsPage(),
                          //   ),
                          // if (canShow("Recommendation"))
                          //   _TileData(
                          //     title: "Recommendation",
                          //     subtitle: "Recommendation settings",
                          //     icon: Icons.thumb_up,
                          //     page: RecommendationPage(),
                          //   ),
                        ],
                      ),

                      SizedBox(height: 28),

                      /// ADVANCED & RECRUITMENT
                      _sectionTitle(
                        context,
                        "ADVANCED & RECRUITMENT",
                      ),

                      SizedBox(height: 12),

                      _groupCard(
                        cs: cs,
                        context,
                        items: [
                          // if (canShow("Hiring"))
                          //   _TileData(
                          //     title: "Hiring",
                          //     subtitle: "Manage recruitment settings",
                          //     icon: Icons.work,
                          //     page: HiringPage(),
                          //   ),
                          // if (canShow("Automation"))
                          //   _TileData(
                          //     title: "Automation",
                          //     subtitle: "Macros and automation tools",
                          //     icon: Icons.auto_mode,
                          //     page: MacroPage(),
                          //   ),
                          // if (canShow("Bulk Upload"))
                          //   _TileData(
                          //     title: "Bulk Upload",
                          //     subtitle: "Upload large datasets easily",
                          //     icon: Icons.upload_file,
                          //     page: BulkUploadPage(),
                          //   ),
                        ],
                      ),
                    ],
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _sectionTitle(BuildContext context, String title) {
    return Text(
      title,
      style: Theme.of(context).textTheme.titleSmall!.copyWith(
          color: Theme.of(context).colorScheme.primary, letterSpacing: 1.2),
    );
  }

  Widget _groupCard(
    BuildContext context, {
    required List<_TileData> items,
    required ColorScheme cs,
  }) {
    final filtered = items.toList();

    return Card(
      elevation: 1,
      color: cs.onPrimary,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(18),
        side: BorderSide(
          color: cs.outline.withOpacity(0.5),
          width: 1,
        ),
      ),
      child: Column(
        children: List.generate(filtered.length, (index) {
          final item = filtered[index];

          return Column(
            children: [
              _settingsTile(
                context,
                title: item.title,
                subtitle: item.subtitle,
                icon: item.icon,
                page: item.page,
              ),
              if (index != filtered.length - 1)
                Divider(
                  height: 1,
                  color: Theme.of(context).colorScheme.outline.withOpacity(0.5),
                ),
            ],
          );
        }),
      ),
    );
  }

  Widget _settingsTile(
    BuildContext context, {
    required String title,
    required String subtitle,
    required IconData icon,
    required Widget page,
  }) {
    final cs = Theme.of(context).colorScheme;

    return InkWell(
      borderRadius: BorderRadius.circular(18),
      onTap: () => Get.to(() => page),
      child: Padding(
        padding: const EdgeInsets.symmetric(
          horizontal: 16,
          vertical: 14,
        ),
        child: Row(
          children: [
            Container(
              height: 48,
              width: 48,
              decoration: BoxDecoration(
                color: cs.primary.withOpacity(.12),
                borderRadius: BorderRadius.circular(14),
              ),
              child: Icon(
                icon,
                color: cs.primary,
                size: 24,
              ),
            ),
            SizedBox(width: 14),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: Theme.of(context).textTheme.titleMedium,
                  ),
                  SizedBox(height: 3),
                  Text(
                    subtitle,
                    style: Theme.of(context)
                        .textTheme
                        .bodySmall!
                        .copyWith(color: cs.onSurface.withOpacity(.65)),
                  ),
                ],
              ),
            ),
            Icon(
              Icons.chevron_right_rounded,
              color: cs.onSurface.withOpacity(.5),
            ),
          ],
        ),
      ),
    );
  }
}

class _TileData {
  final String title;
  final String subtitle;
  final IconData icon;
  final Widget page;

  _TileData({
    required this.title,
    required this.subtitle,
    required this.icon,
    required this.page,
  });
}
