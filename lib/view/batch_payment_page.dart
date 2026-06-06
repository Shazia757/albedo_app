import 'package:albedo_app/controller/payment_controller.dart';
import 'package:albedo_app/model/payment_model.dart';
import 'package:albedo_app/widgets/header_with_search.dart';
import 'package:albedo_app/widgets/session_widgets.dart';
import 'package:albedo_app/widgets/widgets.dart';
import 'package:albedo_app/widgets/custom_appbar.dart';
import 'package:albedo_app/widgets/drawer_menu.dart';
import 'package:albedo_app/widgets/responsive.dart';
import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:get/get.dart';

class BatchPaymentPage extends StatelessWidget {
  final PaymentController c = Get.put(PaymentController(isStudent: null));

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
                  padding: const EdgeInsets.all(8.0),
                  child: HeaderWithSearch(
                    title: "Batch Payments",
                    hint: "Search batches...",
                    isSearching: c.isSearching,
                    searchQuery: c.searchQuery,
                    onSearchChanged: () => c.applyFilters(),
                  ),
                ),
                // ── Tabs ──────────────────────────────────────────────
                Obx(
                  () => CustomWidgets().customTabs(
                    context,
                    tabs: c.tabs,
                    selectedIndex: c.selectedTab.value,
                    onTap: (index) {
                      c.selectedTab.value = index;
                      c.applyFilters();
                    },
                    getCount: (index) => c.batchTabData[index]['count'],
                  ),
                ),

                SizedBox(height: 12),

                // ── List ──────────────────────────────────────────────
                Expanded(
                  child: Obx(() {
                    final batches = c.filteredBatchPayments;
                    final count = batches.length;

                    if (c.isLoadingPayments.value && count == 0) {
                      return const Center(
                        child: CircularProgressIndicator(),
                      );
                    }

                    if (count == 0) {
                      return EmptyState(
                        cs: cs,
                        icon: Icons.not_interested_rounded,
                        title: 'No payments found',
                        subtitle: '',
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
                            return BatchPaymentCard(model: batch);
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

  const BatchPaymentCard({
    super.key,
    required this.model,
  });

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: cs.onPrimary,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: cs.outline.withOpacity(.5),
        ),
        boxShadow: [
          BoxShadow(
            color: cs.shadow.withOpacity(.04),
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          /// ── TOP SECTION ─────────────────────
          Row(
            children: [
              /// Profile Pic
              Container(
                width: 40,
                height: 40,
                decoration: BoxDecoration(
                  color: cs.primary.withOpacity(.08),
                  borderRadius: BorderRadius.circular(14),
                ),
                child: Icon(
                  Icons.groups_rounded,
                  color: cs.primary,
                  size: 28,
                ),
              ),

              SizedBox(width: 14),

              /// Batch Info
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      model.name ?? "-",
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: Theme.of(context)
                          .textTheme
                          .labelLarge!
                          .copyWith(color: cs.onSurface),
                    ),
                    SizedBox(height: 5),
                    Text(
                      model.code ?? "",
                      style: Theme.of(context)
                          .textTheme
                          .bodySmall!
                          .copyWith(color: cs.outline),
                    ),
                  ],
                ),
              ),
            ],
          ),

          SizedBox(height: 10),

          Divider(
            height: 1,
            color: cs.outline.withOpacity(.15),
          ),

          SizedBox(height: 10),

          /// ── MENTOR SECTION ──────────────────
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: cs.surfaceContainerHighest.withOpacity(.25),
              borderRadius: BorderRadius.circular(16),
            ),
            child: Row(
              children: [
                Container(
                  width: 38,
                  height: 38,
                  decoration: BoxDecoration(
                    color: cs.primary.withOpacity(.10),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Icon(
                    Icons.person_outline_rounded,
                    color: cs.primary,
                  ),
                ),
                SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "MENTOR",
                        style: Theme.of(context)
                            .textTheme
                            .labelMedium!
                            .copyWith(letterSpacing: 1, color: cs.primary),
                      ),
                      SizedBox(height: 4),
                      Text(
                        model.mentor?.name ?? "No mentor assigned",
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: Theme.of(context)
                            .textTheme
                            .titleSmall!
                            .copyWith(color: cs.onSurface),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),

          SizedBox(height: 10),

          /// ── FOOTER ──────────────────────────
          Container(
            padding: const EdgeInsets.symmetric(
              horizontal: 14,
              vertical: 12,
            ),
            decoration: BoxDecoration(
              color: cs.surfaceContainerHighest.withOpacity(.18),
              borderRadius: BorderRadius.circular(16),
              border: Border.all(
                color: cs.outline.withOpacity(.08),
              ),
            ),
            child: Row(
              children: [
                /// Batch Fee
                Expanded(
                  child: _FooterAmountTile(
                    context: context,
                    title: "Batch Fee",
                    amount: model.totalFee ?? 0,
                    color: cs.primary,
                  ),
                ),

                /// Divider
                Container(
                  width: 1,
                  height: 42,
                  color: cs.outline.withOpacity(.12),
                ),

                /// Paid
                Expanded(
                  child: _FooterAmountTile(
                    context: context,
                    title: "Paid",
                    amount: model.totalPaid ?? 0,
                    color: Colors.green,
                  ),
                ),

                /// Divider
                Container(
                  width: 1,
                  height: 42,
                  color: cs.outline.withOpacity(.12),
                ),

                /// Pending
                Expanded(
                  child: _FooterAmountTile(
                    context: context,
                    title: "Pending",
                    amount: model.totalPending ?? 0,
                    color: Colors.orange,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _FooterAmountTile extends StatelessWidget {
  final BuildContext context;
  final String title;
  final num amount;
  final Color color;

  const _FooterAmountTile({
    required this.context,
    required this.title,
    required this.amount,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(
          title.toUpperCase(),
          style: Theme.of(context).textTheme.labelSmall!.copyWith(
                color: cs.outline,
                letterSpacing: .8,
                fontWeight: FontWeight.w600,
              ),
        ),
        const SizedBox(height: 6),
        Text(
          "₹ ${amount.toStringAsFixed(0)}",
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
          style: Theme.of(context).textTheme.titleSmall!.copyWith(
                color: color,
                fontWeight: FontWeight.w700,
              ),
        ),
      ],
    );
  }
}
