import 'package:albedo_app/controller/feedback_controller.dart';
import 'package:albedo_app/widgets/custom_appbar.dart';
import 'package:albedo_app/widgets/drawer_menu.dart';
import 'package:albedo_app/widgets/responsive.dart';
import 'package:albedo_app/widgets/session_widgets.dart';
import 'package:albedo_app/widgets/widgets.dart';
import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:get/get.dart';

extension TextThemeExt on BuildContext {
  TextTheme get tt => Theme.of(this).textTheme;
}

class FeedbackPage extends StatelessWidget {
  final c = Get.put(FeedbackController());

  FeedbackPage({super.key});

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
            child: Padding(
              padding: const EdgeInsets.fromLTRB(16, 16, 16, 0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _TopBar(c: c),
                  const SizedBox(height: 14),

                  // ── STATUS TABS ─────────────────────────────────────
                  Obx(
                    () => CustomWidgets().customTabs(
                      context,
                      tabs: c.tabs,
                      selectedIndex: c.selectedTab.value,
                      getCount: (index) {
                        return 0;
                      },
                      onTap: (index) {
                        c.selectedTab.value = index;
                        // c.applyFilters();
                      },
                    ),
                  ),

                  const SizedBox(height: 14),

                  // ── SESSION GRID ────────────────────────────────────
                  Expanded(
                    child: Obx(() {
                      final data = c.filteredSessions;

                      if (c.isLoading.value) {
                        return Center(
                          child: CircularProgressIndicator(
                            color: cs.primary,
                            strokeWidth: 2.5,
                          ),
                        );
                      }

                      if (data.isEmpty) {
                        return EmptyState(
                          cs: cs,
                          icon: Icons.event_busy_outlined,
                          title: 'No feedbacks found',
                          subtitle: 'Try adjusting filters',
                        );
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
                            padding: const EdgeInsets.only(bottom: 80),
                            crossAxisCount: crossAxisCount,
                            mainAxisSpacing: 8,
                            crossAxisSpacing: 8,
                            itemCount: data.length,
                            itemBuilder: (_, i) {
                              return SizedBox();
                            },
                          );
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

class _TopBar extends StatelessWidget {
  final FeedbackController c;
  const _TopBar({required this.c});

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    final isMobile = Responsive.isMobile(context);

    return Obx(() {
      final searching = c.isSearching.value;

      Widget searchField = CustomWidgets().premiumSearch(
        context,
        hint: "Search feedbacks...",
        onChanged: (val) => c.searchQuery.value = val,
      );

      Widget pageTitle = Text(
        "Feedbacks",
        style: Theme.of(context).textTheme.titleLarge?.copyWith(
              fontWeight: FontWeight.w700,
              letterSpacing: -0.3,
            ),
      );

      Widget searchToggle = IconChip(
        icon: searching ? Icons.close : Icons.search_rounded,
        cs: cs,
        onTap: () {
          c.isSearching.value = !searching;
          if (!searching == false) c.searchQuery.value = "";
        },
      );

      // Widget filterBtn = _ChipButton(
      //   icon: Icons.tune_rounded,
      //   label: "Filter",
      //   cs: cs,
      //   onTap: () => CustomWidgets().showFilterSheet(
      //     title: "Filter Sessions",
      //     options: _filterOptions,
      //     selectedValue: c.filterType.value,
      //     onSelected: (val) => c.filterType.value = val,
      //   ),
      // );

      // Widget sortBtn = _ChipButton(
      //   icon: Icons.swap_vert_rounded,
      //   label: "Sort",
      //   cs: cs,
      //   onTap: () => CustomWidgets().showSortSheet(
      //     title: "Sort Sessions",
      //     options: _sortOptions,
      //     selectedValue: c.sortType.value,
      //     onSelected: (val) => c.sortType.value = val,
      //   ),
      // );

      if (isMobile) {
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                if (!searching) ...[
                  Expanded(child: pageTitle),
                ] else ...[
                  Expanded(child: searchField),
                ],
                const SizedBox(width: 8),
                searchToggle,
              ],
            ),
            if (!searching) ...[
              const SizedBox(height: 10),
              // Row(
              //   children: [
              //     Expanded(child: filterBtn),
              //     const SizedBox(width: 8),
              //     Expanded(child: sortBtn),
              //   ],
              // ),
            ],
          ],
        );
      }

      return Row(
        children: [
          if (!searching) ...[
            pageTitle,
            const Spacer(),
          ] else ...[
            Expanded(flex: 3, child: searchField),
          ],
          const SizedBox(width: 10),
          searchToggle,
          // if (!searching) ...[
          //   const SizedBox(width: 8),
          //   filterBtn,
          //   const SizedBox(width: 8),
          //   sortBtn,
          // ],
        ],
      );
    });
  }
}
