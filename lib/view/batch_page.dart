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
                          hint: "Search batches...",
                          onChanged: (value) {
                            c.searchQuery.value = value;
                          }),
                      const SizedBox(height: 12),
                      Obx(() => _tabs()),
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
                            statusColor: getStatusColor(batches[i].status),
                            infoColumns: [
                              {"label": "Batch Name", "value": batches[i].name},
                              {"label": "Batch Code", "value": batches[i].code},
                            ],
                            actions: [
                              iconBtn(
                                  icon: Icons.edit,
                                  color: Colors.blue,
                                  onTap: () {}),
                              iconBtn(
                                  icon: Icons.delete,
                                  color: Colors.red,
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
    return Container(
      padding: const EdgeInsets.all(4),
      decoration: BoxDecoration(
        color: Colors.grey.shade200,
        borderRadius: BorderRadius.circular(30),
      ),
      child: Row(
        children: List.generate(2, (index) {
          final isSelected = c.selectedTab.value == index;
          final tabName = index == 0 ? "Active" : "Inactive";
          final count =
              c.batches.where((b) => b.status == c.statusMap[index]).length;

          return Expanded(
            child: GestureDetector(
              onTap: () => c.selectedTab.value = index,
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 250),
                padding: const EdgeInsets.symmetric(vertical: 10),
                decoration: BoxDecoration(
                  color:
                      isSelected ? const Color(0xFF7F00FF) : Colors.transparent,
                  borderRadius: BorderRadius.circular(25),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      tabName,
                      style: TextStyle(
                        fontWeight: FontWeight.w600,
                        color: isSelected ? Colors.white : Colors.grey[700],
                      ),
                    ),
                    const SizedBox(width: 6),
                    Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 8, vertical: 2),
                      decoration: BoxDecoration(
                        color: isSelected
                            ? Colors.white.withOpacity(0.2)
                            : Colors.grey.shade300,
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Text(
                        "$count",
                        style: TextStyle(
                          fontSize: 11,
                          fontWeight: FontWeight.bold,
                          color: isSelected ? Colors.white : Colors.grey[700],
                        ),
                      ),
                    )
                  ],
                ),
              ),
            ),
          );
        }),
      ),
    );
  }

  Color getStatusColor(String status) {
    switch (status.toLowerCase()) {
      case "active":
        return Colors.green;
      case "inactive":
        return Colors.red;
      default:
        return Colors.grey;
    }
  }
}
