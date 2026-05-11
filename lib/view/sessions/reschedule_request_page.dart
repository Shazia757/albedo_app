import 'package:albedo_app/controller/request_controller.dart';
import 'package:albedo_app/widgets/custom_appbar.dart';
import 'package:albedo_app/widgets/drawer_menu.dart';
import 'package:albedo_app/widgets/widgets.dart';
import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
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
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 12),

                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: Text(
                    "Reschedule Requests",
                    style: Theme.of(context).textTheme.titleLarge,
                  ),
                ),

                const SizedBox(height: 10),

                /// 🔹 TABS
                Align(
                  alignment: Alignment.center,
                  child: Obx(
                    () => CustomWidgets().customTabs(
                      context,
                      tabs: c.tabs,
                      selectedIndex: c.selectedTab.value,
                      onTap: (index) => c.selectedTab.value = index,
                    ),
                  ),
                ),

                const SizedBox(height: 12),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: CustomWidgets().premiumSearch(
                    context,
                    hint: 'Search requests...',
                    onChanged: (v) => c.searchQuery.value = v,
                  ),
                ),
                const SizedBox(height: 10),

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
        ],
      ),
    );
  }
}

class RescheduleCard extends StatelessWidget {
  final Map<String, dynamic> data;

  const RescheduleCard({super.key, required this.data});

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;

    return Stack(
      children: [
        /// MAIN CARD
        Container(
          margin: const EdgeInsets.only(bottom: 12),
          padding: const EdgeInsets.all(14),
          decoration: BoxDecoration(
            color: cs.onPrimary,
            borderRadius: BorderRadius.circular(14),
            border: Border.all(color: cs.outline.withOpacity(0.5)),
          ),
          child: Row(
            children: [
              /// PROFILE
              Container(
                width: 48,
                height: 48,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                  image: const DecorationImage(
                    image: AssetImage('assets/images/logo.png'),
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
                      data["name"],
                      style: const TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    Text(
                      data["id"],
                      style: TextStyle(
                        fontSize: 12,
                        color: cs.onSurfaceVariant,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),

        /// 🔥 STATUS CHIPS (TOP RIGHT ROW)
        Positioned(
          top: 8,
          right: 8,
          child: Row(
            spacing: 5,
            children: [
              if ((data["pending"] ?? 0) > 0)
                _statusChip("Pending", data["pending"], Colors.orange),
              if ((data["approved"] ?? 0) > 0)
                _statusChip("Approved", data["approved"], Colors.green),
              if ((data["rejected"] ?? 0) > 0)
                _statusChip("Rejected", data["rejected"], Colors.red),
              if ((data["rescheduled"] ?? 0) > 0)
                _statusChip("Rescheduled", data["rescheduled"], Colors.blue),
            ],
          ),
        ),
      ],
    );
  }

  /// 🔻 SMALLER CHIP
  Widget _statusChip(String label, int count, Color color) {
    return Container(
      margin: const EdgeInsets.only(bottom: 4),
      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 3),
      decoration: BoxDecoration(
        color: color.withOpacity(0.12),
        borderRadius: BorderRadius.circular(5),
        border: Border.all(color: color.withOpacity(0.4)),
      ),
      child: Text(
        "$label: $count",
        style: TextStyle(
          fontSize: 10, // smaller
          fontWeight: FontWeight.w600,
          color: color,
        ),
      ),
    );
  }
}
