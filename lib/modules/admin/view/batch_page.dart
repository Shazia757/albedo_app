import 'package:albedo_app/controller/batch_controller.dart';
import 'package:albedo_app/widgets/widgets.dart';
import 'package:albedo_app/widgets/custom_appbar.dart';
import 'package:albedo_app/widgets/custom_card.dart';
import 'package:albedo_app/widgets/drawer_menu.dart';
import 'package:albedo_app/widgets/responsive.dart';
import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
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
                      CustomWidgets().premiumSearch(context,
                          hint: "Search batches...", onChanged: (value) {
                        c.searchQuery.value = value;
                      }),
                      const SizedBox(height: 12),
                      _tabs(),
                      const SizedBox(height: 12),
                      Expanded(child: Obx(() {
                        final batches = c.filteredBatches;
                        if (c.isLoading.value) {
                          return Center(child: CircularProgressIndicator());
                        }
                        if (batches.isEmpty) {
                          return Center(child: Text("No batches found"));
                        }
                        int crossAxisCount = 1;

                        if (Responsive.isTablet(context)) {
                          crossAxisCount = 2;
                        } else if (Responsive.isDesktop(context)) {
                          crossAxisCount = 3;
                        }
                        return Expanded(
                          child: Obx(() {
                            final batches = c.filteredBatches;

                            if (c.isLoading.value) {
                              return const Center(
                                  child: CircularProgressIndicator());
                            }

                            if (batches.isEmpty) {
                              return const Center(
                                  child: Text("No batches found"));
                            }

                            return LayoutBuilder(
                              builder: (context, constraints) {
                                int crossAxisCount = 1;

                                if (constraints.maxWidth > 1200) {
                                  crossAxisCount = 3;
                                } else if (constraints.maxWidth > 700) {
                                  crossAxisCount = 2;
                                }

                                return MasonryGridView.count(
                                  padding:
                                      const EdgeInsets.symmetric(vertical: 6),
                                  crossAxisCount: crossAxisCount,
                                  mainAxisSpacing: 12,
                                  crossAxisSpacing: 12,
                                  itemCount: batches.length,
                                  itemBuilder: (_, i) {
                                    final batch = batches[i];

                                    return InfoCard(
                                      id: batch.id ?? '',
                                      status: batch.status ?? '',
                                      statusColor: getStatusColor(
                                          context, batch.status ?? ''),

                                      /// 🔥 Use rows instead of fixed columns
                                      infoRows: [
                                        _buildBatchSimpleInfo(context, batch),
                                      ],

                                      actions: [
                                        CustomWidgets().iconBtn(
                                          icon: Icons.edit,
                                          color: Theme.of(context)
                                              .colorScheme
                                              .primary,
                                          onTap: () {},
                                        ),
                                        CustomWidgets().iconBtn(
                                          icon: Icons.delete,
                                          color: Theme.of(context)
                                              .colorScheme
                                              .error,
                                          onTap: () {},
                                        ),
                                      ],
                                    );
                                  },
                                );
                              },
                            );
                          }),
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

  Widget _buildBatchSimpleInfo(BuildContext context, batch) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final isSmall = constraints.maxWidth < 300;

        return isSmall

            /// 🔥 MOBILE → STACK
            ? Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _miniInfo(
                    context: context,
                    label: "Batch Name",
                    value: batch.batchName ?? '',
                  ),
                  const SizedBox(height: 6),
                  _miniInfo(
                    context: context,
                    label: "Batch Code",
                    value: batch.batchID ?? '',
                  ),
                ],
              )

            /// 🔥 TABLET/DESKTOP → ROW
            : Row(
                children: [
                  Expanded(
                    child: _miniInfo(
                      context: context,
                      label: "Batch Name",
                      value: batch.batchName ?? '',
                    ),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: _miniInfo(
                      context: context,
                      label: "Batch Code",
                      value: batch.batchID ?? '',
                    ),
                  ),
                ],
              );
      },
    );
  }

  Widget _miniInfo({
    required BuildContext context,
    String? label,
    required String value,
  }) {
    final cs = Theme.of(context).colorScheme;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (label != null)
          Text(
            label,
            style: TextStyle(
              fontSize: 11,
              color: cs.onSurface.withOpacity(0.6),
              fontWeight: FontWeight.w500,
            ),
          ),
        if (label != null) const SizedBox(height: 2),
        Text(
          value.isEmpty ? "-" : value,
          style: TextStyle(
            fontSize: 13,
            fontWeight: FontWeight.w600,
            color: cs.onSurface,
          ),
          overflow: TextOverflow.ellipsis,
        ),
      ],
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
