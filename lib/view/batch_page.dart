import 'package:albedo_app/controller/batch_controller.dart';
import 'package:albedo_app/widgets/button.dart';
import 'package:albedo_app/widgets/custom_appbar.dart';
import 'package:albedo_app/widgets/custom_card.dart';
import 'package:albedo_app/widgets/drawer_menu.dart';
import 'package:albedo_app/widgets/responsive.dart';
import 'package:albedo_app/widgets/search_bar.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class BatchesPage extends StatelessWidget {
  final BatchesController c = Get.put(BatchesController());

  @override
  Widget build(BuildContext context) {
    final isDesktop = Responsive.isDesktop(context);

    return Scaffold(
      appBar: Responsive.isMobile(context) ? const CustomAppBar() : null,
      drawer: isDesktop ? null : const DrawerMenu(),
      body: Row(
        children: [
          if (isDesktop) const DrawerMenu(),
          Expanded(
            child: Center(
              child: ConstrainedBox(
                constraints: const BoxConstraints(maxWidth: 600),
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    children: [
                      premiumSearch(
                        context,
                          hint: "Search batches...",
                          onChanged: (value) {
                            c.searchQuery.value = value;
                          }),
                      const SizedBox(height: 12),
                      _tabs(),
                      const SizedBox(height: 12),
                      Expanded(child: Obx(() {
                        final batches = c.filteredBatches;
                        if (batches.isEmpty) {
                          return Center(child: Text("No batches found"));
                        }
                        int crossAxisCount = 1;

                        if (Responsive.isTablet(context)) {
                          crossAxisCount = 2;
                        } else if (Responsive.isDesktop(context)) {
                          crossAxisCount = 3;
                        }
                        return GridView.builder(
                          shrinkWrap: true,
                          itemCount: batches.length,
                          gridDelegate:
                              SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: crossAxisCount,
                            crossAxisSpacing: 12,
                            mainAxisExtent: 180,
                          ),
                          itemBuilder: (_, i) => InfoCard(
                            id: batches[i].id,
                            status: batches[i].status,
                            statusColor:
                                getStatusColor(context, batches[i].status),
                            infoColumns: [
                              {"label": "Batch Name", "value": batches[i].name},
                              {"label": "Batch Code", "value": batches[i].code},
                            ],
                            actions: [
                              iconBtn(
                                  icon: Icons.edit,
                                  color: Theme.of(context).colorScheme.primary,
                                  onTap: () {}),
                              iconBtn(
                                  icon: Icons.delete,
                                  color:
                                      Theme.of(context).colorScheme.onTertiary,
                                  onTap: () {}),
                            ],
                          ),
                        );
                      })),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _tabs() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Container(
        padding: const EdgeInsets.all(6),
        decoration: BoxDecoration(
          color: Theme.of(Get.context!).colorScheme.onPrimary,
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color:
                  Theme.of(Get.context!).colorScheme.shadow.withOpacity(0.05),
              blurRadius: 12,
              offset: const Offset(0, 4),
            )
          ],
        ),
        child: Row(
          children: [
            _tabItem("Pending", 0),
            _tabItem("Approved", 1),
          ],
        ),
      ),
    );
  }

  Widget _tabItem(String title, int index) {
    return Expanded(
      child: Obx(() {
        final isSelected = c.selectedTab.value == index;

        return GestureDetector(
          onTap: () => c.selectedTab.value = index,
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 250),
            padding: const EdgeInsets.symmetric(vertical: 12),
            decoration: BoxDecoration(
              gradient: isSelected
                  ? const LinearGradient(
                      colors: [Color(0xFF7F00FF), Color(0xFFE100FF)],
                    )
                  : null,
              borderRadius: BorderRadius.circular(12),
            ),
            child: Center(
              child: Text(
                title,
                style: TextStyle(
                  color: isSelected
                      ? Theme.of(Get.context!).colorScheme.onPrimary
                      : Theme.of(Get.context!).colorScheme.outline,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ),
        );
      }),
    );
  }

  Color getStatusColor(BuildContext context, String status) {
    switch (status.toLowerCase()) {
      case "active":
        return Theme.of(context).colorScheme.onInverseSurface;
      case "inactive":
        return Theme.of(context).colorScheme.onTertiary;
      default:
        return Theme.of(context).colorScheme.shadow;
    }
  }
}
