import 'package:albedo_app/controller/payment_controller.dart';
import 'package:albedo_app/model/payment_model.dart';
import 'package:albedo_app/view/batch_payment_detailed.dart';
import 'package:albedo_app/widgets/session_widgets.dart';
import 'package:albedo_app/widgets/widgets.dart';
import 'package:albedo_app/widgets/custom_appbar.dart';
import 'package:albedo_app/widgets/drawer_menu.dart';
import 'package:albedo_app/widgets/responsive.dart';
import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:get/get.dart';

class BatchPaymentPage extends StatelessWidget {
  final PaymentController c = Get.put(PaymentController(isStudent: false));

  BatchPaymentPage({super.key});

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    final isDesktop = Responsive.isDesktop(context);

    return Scaffold(
      appBar: const CustomAppBar(),
      backgroundColor: Theme.of(context).colorScheme.surface,
      drawer: isDesktop ? null : const DrawerMenu(),
      body: Row(
        children: [
          if (isDesktop) const DrawerMenu(),
          Expanded(
            child: Column(
              children: [
                // ── Search ────────────────────────────────────────────
                Padding(
                  padding: const EdgeInsets.fromLTRB(16, 16, 16, 0),
                  child: CustomWidgets().premiumSearch(
                    context,
                    hint: "Search batches...",
                    onChanged: (v) => c.searchQuery.value = v,
                  ),
                ),
                const SizedBox(height: 10),

                // ── Tabs ──────────────────────────────────────────────
                Obx(
                  () => CustomWidgets().customTabs(
                    context,
                    tabs: c.tabs,
                    selectedIndex: c.selectedTab.value,
                    onTap: (index) {
                      c.selectedTab.value = index;
                    },
                    getCount: (index) => c.tabData[index]['count'],
                  ),
                ),

                const SizedBox(height: 12),

                // ── List ──────────────────────────────────────────────
                Expanded(
                  child: Obx(() {
                    final batches = c.filteredBatchPayments;
                    final count = batches.length;

                    if (count == 0) {
                      return EmptyState(
                        cs: cs,
                        title: 'No payments found',
                        subtitle: 'Try adjusting your search or filter',
                        icon: Icons.payment,
                      );
                    }

                    return LayoutBuilder(builder: (context, constraints) {
                      int crossAxisCount = 1;

                      if (constraints.maxWidth > 1200) {
                        crossAxisCount = 3;
                      } else if (constraints.maxWidth > 700) {
                        crossAxisCount = 2;
                      }
                      return SizedBox.expand(
                        child: MasonryGridView.count(
                          crossAxisCount: crossAxisCount,
                          padding: const EdgeInsets.fromLTRB(16, 0, 16, 24),
                          itemCount: count,
                          mainAxisSpacing: 12,
                          crossAxisSpacing: 12,
                          physics: const BouncingScrollPhysics(),
                          itemBuilder: (_, i) {
                            final batch = batches[i];
                            return BatchPaymentCard(
                                model: batch,
                                onTap: () {
                                  final tab = c.selectedTab.value == 0
                                      ? "pending"
                                      : "approved";
                                  final filteredPayments = batch.payments
                                      .where((p) => p.status == tab)
                                      .toList();

                                  final filteredModel = BatchPaymentModel(
                                    batch: batch.batch,
                                    status: batch.status,
                                    payments: filteredPayments,
                                  );

                                  Get.to(() => BatchPaymentDetailPage(
                                        batchModel: filteredModel,
                                        activeTab: tab,
                                      ));
                                });
                          },
                        ),
                      );
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

class BatchPaymentCard extends StatelessWidget {
  final BatchPaymentModel model;
  final VoidCallback onTap;

  const BatchPaymentCard({
    super.key,
    required this.model,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;

    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(12),
      child: Container(
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
          color: cs.onPrimary,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: cs.outlineVariant.withOpacity(0.4)),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(model.batch.batchName ?? "-",
                style: const TextStyle(fontWeight: FontWeight.w600)),
            const SizedBox(height: 4),
            Text(model.batch.batchID ?? "",
                style: TextStyle(fontSize: 12, color: cs.onSurfaceVariant)),
            const SizedBox(height: 8),
            Text(model.batch.mentor?.name ?? "No mentor",
                style: TextStyle(fontSize: 12)),
          ],
        ),
      ),
    );
  }
}
