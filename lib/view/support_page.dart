import 'package:albedo_app/controller/support_controller.dart';
import 'package:albedo_app/widgets/button.dart';
import 'package:albedo_app/widgets/custom_appbar.dart';
import 'package:albedo_app/widgets/custom_card.dart';
import 'package:albedo_app/widgets/drawer_menu.dart';
import 'package:albedo_app/widgets/responsive.dart';
import 'package:albedo_app/widgets/search_bar.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class SupportsPage extends StatelessWidget {
  SupportsPage({super.key});

  final c = Get.put(SupportController());

  @override
  Widget build(BuildContext context) {
    final isDesktop = Responsive.isDesktop(context);

    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.surface,
      appBar: Responsive.isMobile(context) ? const CustomAppBar() : null,
      drawer: isDesktop ? null : const DrawerMenu(),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child:
                premiumSearch(context, hint: 'Search...', onChanged: (value) {
              c.searchQuery.value = value;
            }),
          ),
          const SizedBox(height: 10),
          _tabs(context),
          const SizedBox(height: 10),
          Expanded(child: _list(context)),
        ],
      ),
    );
  }

  // 🔍 Custom Search Bar

  // 📊 Tabs
  Widget _tabs(BuildContext context) {
    final cs = Theme.of(context).colorScheme;

    return Obx(() => Padding(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
          child: Row(
            children: List.generate(2, (index) {
              final isSelected = c.selectedTab.value == index;
              final title = index == 0 ? "Open" : "Closed";

              return Expanded(
                child: GestureDetector(
                  onTap: () {
                    c.selectedTab.value = index;
                    c.applyFilters();
                  },
                  child: Container(
                    margin: const EdgeInsets.only(right: 8),
                    padding: const EdgeInsets.symmetric(vertical: 10),
                    decoration: BoxDecoration(
                      color: isSelected
                          ? cs.primary
                          : cs.primaryContainer.withOpacity(0.4),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Center(
                      child: Text(
                        "$title (${c.getCount(index)})",
                        style: TextStyle(
                          color: isSelected
                              ? cs.onPrimary
                              : cs.onSurface.withOpacity(0.7),
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ),
                ),
              );
            }),
          ),
        ));
  }

  // 📋 List
  Widget _list(BuildContext context) {
    return Obx(() => ListView.builder(
          padding: const EdgeInsets.symmetric(horizontal: 12),
          itemCount: c.supports.length,
          itemBuilder: (_, i) {
            final s = c.supports[i];
            final isOpen = s.status == "open";
            return Padding(
              padding: const EdgeInsets.all(8.0),
              child: InfoCard(
                id: s.id,
                status: isOpen ? "Open" : "Closed",
                statusColor: isOpen
                    ? Theme.of(context).colorScheme.primary
                    : Theme.of(context).colorScheme.onTertiaryContainer,

                /// ✅ Use infoColumns for structured data
                infoColumns: [
                  {"label": "Title", "value": s.title},
                  {"label": "By", "value": s.by},
                ],

                /// ✅ Use infoRows for full-width content (description)
                infoRows: [
                  Text(
                    s.description,
                    style: TextStyle(
                      fontSize: 12,
                      color: Theme.of(context)
                          .colorScheme
                          .onSurface
                          .withOpacity(0.7),
                    ),
                  ),
                ],

                /// ✅ Actions
                actions: [
                  iconBtn(
                    icon: Icons.edit,
                    onTap: () {
                      // TODO: Edit logic
                    },
                    color: Theme.of(context).colorScheme.primary,
                  ),
                  iconBtn(
                    icon: Icons.delete,
                    onTap: () {
                      // TODO: Delete logic
                    },
                    color: Theme.of(context).colorScheme.onTertiaryContainer,
                  ),
                ],
              ),
            );
          },
        ));
  }
}
