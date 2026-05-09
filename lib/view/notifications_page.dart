import 'package:albedo_app/controller/auth_controller.dart';
import 'package:albedo_app/controller/notifications_controller.dart';
import 'package:albedo_app/model/settings/notification_model.dart';
import 'package:albedo_app/widgets/custom_appbar.dart';
import 'package:albedo_app/widgets/custom_tab.dart';
import 'package:albedo_app/widgets/drawer_menu.dart';
import 'package:albedo_app/widgets/responsive.dart';
import 'package:albedo_app/widgets/widgets.dart';
import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

class NotificationsPage extends StatelessWidget {
  final c = Get.put(NotificationsController());

  @override
  Widget build(BuildContext context) {
    final isDesktop = Responsive.isDesktop(context);

    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.surface,
      appBar: Responsive.isMobile(context) ? const CustomAppBar() : null,
      drawer: isDesktop ? null : const DrawerMenu(),
      body: Row(
        children: [
          if (isDesktop) DrawerMenu(),
          Expanded(
            child: Column(
              children: [
                const SizedBox(height: 10),
                Align(
                  alignment: Alignment.centerLeft,
                  child: Padding(
                    padding: const EdgeInsets.only(top: 10.0, left: 15),
                    child: Text(
                      'Notifications',
                      style: Theme.of(context).textTheme.titleLarge,
                    ),
                  ),
                ),
                const SizedBox(height: 10),

                /// 🧭 Tabs
                Obx(
                  () => CustomWidgets().customTabs(
                    context,
                    tabs: c.tabs,
                    selectedIndex: c.selectedTab.value,
                    onTap: (index) {
                      c.selectedTab.value = index;
                      c.applyFilters();
                    },
                    getCount: c.getCount,
                  ),
                ),

                const SizedBox(height: 10),

                /// 📋 List
                Expanded(
                  child: Obx(() {
                    if (c.isLoading.value) {
                      return const Center(child: CircularProgressIndicator());
                    }
                    if (c.filteredMessages.isEmpty) {
                      return const Center(child: Text("No messages found"));
                    }

                    return LayoutBuilder(builder: (context, constraints) {
                      int crossAxisCount = 1;

                      if (constraints.maxWidth > 1200) {
                        crossAxisCount = 3;
                      } else if (constraints.maxWidth > 700) {
                        crossAxisCount = 2;
                      }
                      return MasonryGridView.count(
                          crossAxisCount: crossAxisCount,
                          padding: const EdgeInsets.symmetric(vertical: 6),
                          itemCount: c.filteredMessages.length,
                          itemBuilder: (context, index) {
                            final msgs = c.filteredMessages[index];

                            return Padding(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 12),
                              child: Align(
                                alignment: Alignment.center,
                                child: ConstrainedBox(
                                  constraints:
                                      const BoxConstraints(maxWidth: 700),
                                  child: NotificationCard(data: msgs),
                                ),
                              ),
                            );
                          });
                    });
                  }),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class NotificationCard extends StatelessWidget {
  final Notifications data;

  const NotificationCard({super.key, required this.data});

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;

    return InkWell(
      borderRadius: BorderRadius.circular(16),
      onTap: () {
        CustomWidgets().showCustomDialog(
          context: context,
          title: Text(data.title ?? "Notification"),
          formKey: GlobalKey(),
          isViewOnly: true,
          onSubmit: () {},
          sections: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                /// IMPORTANT BADGE
                if (data.isImportant)
                  Container(
                    margin: const EdgeInsets.only(bottom: 12),
                    padding: const EdgeInsets.symmetric(
                      horizontal: 8,
                      vertical: 4,
                    ),
                    decoration: BoxDecoration(
                      color: cs.error.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(6),
                    ),
                    child: Text(
                      "IMPORTANT",
                      style: TextStyle(
                        fontSize: 11,
                        color: cs.error,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ),

                /// MESSAGE
                Text(
                  data.message ?? "",
                  style: TextStyle(
                    fontSize: 13,
                    color: cs.onSurface.withOpacity(0.8),
                    height: 1.5,
                  ),
                ),

                const SizedBox(height: 16),

                /// DATE
                Row(
                  children: [
                    Icon(
                      Icons.schedule,
                      size: 16,
                      color: cs.onSurface.withOpacity(0.5),
                    ),
                    const SizedBox(width: 6),
                    Text(
                      data.date != null
                          ? DateFormat(
                              "dd MMM yyyy • hh:mm a",
                            ).format(data.date ?? DateTime.now())
                          : "No Date",
                      style: TextStyle(
                        fontSize: 12,
                        color: cs.onSurface.withOpacity(0.6),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ],
        );
      },
      child: Container(
        margin: const EdgeInsets.symmetric(vertical: 6),
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
          color: cs.onPrimary,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: cs.outline.withOpacity(0.4),
          ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            /// 🔹 TITLE + BADGE
            Row(
              children: [
                Expanded(
                  child: Text(
                    data.title ?? "No Title",
                    style: TextStyle(
                      fontWeight: FontWeight.w700,
                      fontSize: 14,
                      color: cs.onSurface,
                    ),
                  ),
                ),
                if (data.isImportant)
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 6,
                      vertical: 2,
                    ),
                    decoration: BoxDecoration(
                      color: cs.error.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(4),
                    ),
                    child: Text(
                      "Important",
                      style: TextStyle(
                        fontSize: 10,
                        color: cs.error,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
              ],
            ),

            const SizedBox(height: 8),

            /// 🔹 MESSAGE
            Text(
              data.message ?? "",
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
              style: TextStyle(
                fontSize: 12,
                color: cs.onSurface.withOpacity(0.7),
                height: 1.4,
              ),
            ),

            const SizedBox(height: 12),

            /// 🔹 DATE
            Row(
              children: [
                Icon(
                  Icons.schedule,
                  size: 14,
                  color: cs.onSurface.withOpacity(0.5),
                ),
                const SizedBox(width: 6),
                Text(
                  data.date != null
                      ? DateFormat(
                          "dd MMM yyyy • hh:mm a",
                        ).format(data.date ?? DateTime.now())
                      : "No Date",
                  style: TextStyle(
                    fontSize: 11,
                    color: cs.onSurface.withOpacity(0.55),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
