import 'package:albedo_app/controller/request_controller.dart';
import 'package:albedo_app/view/sessions/reshedule_detailed_page.dart';
import 'package:albedo_app/widgets/custom_appbar.dart';
import 'package:albedo_app/widgets/drawer_menu.dart';
import 'package:albedo_app/widgets/widgets.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class RescheduleRequestsPage extends StatelessWidget {
  RescheduleRequestsPage({super.key});

  final c = Get.put(RequestController());

  @override
  Widget build(BuildContext context) {
    final isDesktop = MediaQuery.of(context).size.width > 900;

    return Scaffold(
      appBar: const CustomAppBar(),
      body: Row(
        children: [
          if (isDesktop) const DrawerMenu(),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(16, 16, 16, 0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(height: 12),

                  Text(
                    "Reschedule Requests",
                    style: Theme.of(context)
                        .textTheme
                        .titleLarge!
                        .copyWith(color: Theme.of(context).colorScheme.primary),
                  ),

                  SizedBox(height: 12),
                  CustomWidgets().premiumSearch(
                    context,
                    hint: 'Search requests...',
                    onChanged: (v) => c.searchQuery.value = v,
                  ),
                  SizedBox(height: 10),

                  /// 🔹 TABS
                  Align(
                    alignment: Alignment.center,
                    child: Obx(
                      () => CustomWidgets().customTabs(
                        context,
                        tabs: c.tabs,
                        selectedIndex: c.selectedTab.value,
                        getCount: (index) => c.getCount(index),
                        onTap: (index) => c.selectedTab.value = index,
                      ),
                    ),
                  ),

                  SizedBox(height: 12),

                  /// 🔹 LIST
                  Expanded(
                    child: Obx(() {
                      final list =
                          c.selectedTab.value == 0 ? c.students : c.teachers;

                      final filteredList =
                          list.where((item) => c.hasAnyStatus(item)).toList();

                      return ListView.builder(
                        padding: const EdgeInsets.all(12),
                        itemCount: filteredList.length,
                        itemBuilder: (context, index) {
                          return RescheduleCard(data: filteredList[index]);
                        },
                      );
                    }),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class RescheduleCard extends StatelessWidget {
  final Map<String, dynamic> data;

  const RescheduleCard({
    super.key,
    required this.data,
  });

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;

    return InkWell(
      borderRadius: BorderRadius.circular(14),
      onTap: () {
        Get.to(
          () => RescheduleRequestsDetailedPage(
            studentData: data,
          ),
        );
      },
      child: Container(
        margin: const EdgeInsets.only(bottom: 12),
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
          color: cs.onPrimary,
          borderRadius: BorderRadius.circular(14),
          border: Border.all(
            color: cs.outline.withOpacity(0.35),
          ),
        ),
        child: Column(
          children: [
            /// TOP SECTION
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                /// PROFILE IMAGE (SQUARED)
                Container(
                  width: 42,
                  height: 42,
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: cs.surfaceContainerHighest.withOpacity(0.4),
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(
                      color: cs.outline.withOpacity(0.2),
                    ),
                  ),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(8),
                    child: Image.asset(
                      'assets/images/logo.png',
                      fit: BoxFit.contain,
                    ),
                  ),
                ),

                const SizedBox(width: 12),

                /// NAME + ID
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        data["name"] ?? "",
                        style: Theme.of(context).textTheme.titleMedium,
                      ),

                      const SizedBox(height: 3),

                      /// SUBTITLE
                      Text(
                        data["id"] ?? "",
                        style: Theme.of(context).textTheme.bodySmall!.copyWith(
                              color: cs.outline,
                              fontWeight: FontWeight.w500,
                            ),
                      ),
                    ],
                  ),
                ),
              ],
            ),

            const SizedBox(height: 12),

            /// STATUS CHIPS
            Align(
              alignment: Alignment.centerLeft,
              child: Wrap(
                spacing: 6,
                runSpacing: 6,
                children: [
                  if ((data["pending"] ?? 0) > 0)
                    _statusChip(
                      context,
                      "Pending",
                      data["pending"],
                      Colors.orange,
                    ),
                  if ((data["approved"] ?? 0) > 0)
                    _statusChip(
                      context,
                      "Approved",
                      data["approved"],
                      Colors.green,
                    ),
                  if ((data["rejected"] ?? 0) > 0)
                    _statusChip(
                      context,
                      "Rejected",
                      data["rejected"],
                      Colors.red,
                    ),
                  if ((data["rescheduled"] ?? 0) > 0)
                    _statusChip(
                      context,
                      "Rescheduled",
                      data["rescheduled"],
                      Colors.blue,
                    ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  /// SMALL STATUS CHIP
  Widget _statusChip(
    BuildContext context,
    String label,
    int count,
    Color color,
  ) {
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: 8,
        vertical: 4,
      ),
      decoration: BoxDecoration(
        color: color.withOpacity(0.08),
        borderRadius: BorderRadius.circular(30),
        border: Border.all(
          color: color.withOpacity(0.25),
        ),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 5,
            height: 5,
            decoration: BoxDecoration(
              color: color,
              shape: BoxShape.circle,
            ),
          ),
          const SizedBox(width: 5),
          Text(
            "$label • $count",
            style: Theme.of(context).textTheme.labelSmall!.copyWith(
                  color: color,
                  fontWeight: FontWeight.w600,
                  fontSize: 10.5,
                ),
          ),
        ],
      ),
    );
  }
}
