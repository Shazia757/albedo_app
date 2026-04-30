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
  final PaymentController c = Get.put(PaymentController());

  BatchPaymentPage({super.key});

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    final isDesktop = Responsive.isDesktop(context);

    return Scaffold(
      appBar: const CustomAppBar(),
      backgroundColor: cs.surfaceContainerLowest,
      drawer: isDesktop ? null : const DrawerMenu(),
      body: Row(
        children: [
          if (isDesktop) const DrawerMenu(),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
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

                // ── Tabs ──────────────────────────────────────────────
                Padding(
                  padding: const EdgeInsets.fromLTRB(16, 12, 16, 0),
                  child: _Tabs(c: c),
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
          color: cs.surface,
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
            Text(model.batch.mentorName ?? "No mentor",
                style: TextStyle(fontSize: 12)),
          ],
        ),
      ),
    );
  }
}

// ═══════════════════════════════════════════════════════════════════════
// TABS — full width, underline style
// ═══════════════════════════════════════════════════════════════════════
class _Tabs extends StatelessWidget {
  final PaymentController c;
  const _Tabs({required this.c});

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            _TabItem(label: "Pending", index: 0, c: c, cs: cs),
            _TabItem(label: "Approved", index: 1, c: c, cs: cs),
          ],
        ),
        Divider(
            height: 1,
            thickness: 0.5,
            color: cs.outlineVariant.withOpacity(0.4)),
      ],
    );
  }
}

class _TabItem extends StatelessWidget {
  final String label;
  final int index;
  final PaymentController c;
  final ColorScheme cs;

  const _TabItem({
    required this.label,
    required this.index,
    required this.c,
    required this.cs,
  });

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      final isOn = c.selectedTab.value == index;

      return Expanded(
        child: GestureDetector(
          onTap: () => c.selectedTab.value = index,
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 180),
            padding: const EdgeInsets.symmetric(vertical: 10),
            decoration: BoxDecoration(
              border: Border(
                bottom: BorderSide(
                  color: isOn ? cs.primary : Colors.transparent,
                  width: 2,
                ),
              ),
            ),
            child: Text(
              label,
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 13,
                fontWeight: isOn ? FontWeight.w500 : FontWeight.w400,
                color: isOn ? cs.primary : cs.onSurface.withOpacity(0.45),
              ),
            ),
          ),
        ),
      );
    });
  }
}
