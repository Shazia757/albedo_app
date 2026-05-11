import 'package:albedo_app/config/root.dart';
import 'package:albedo_app/controller/auth_controller.dart';
import 'package:albedo_app/controller/coordinator_controller.dart';
import 'package:albedo_app/controller/permissions_controller.dart';
import 'package:albedo_app/model/session_model.dart';
import 'package:albedo_app/view/coordinator_detailed_page.dart';
import 'package:albedo_app/view/users/add_coordinator_page.dart';
import 'package:albedo_app/widgets/custom_appbar.dart';
import 'package:albedo_app/widgets/custom_card.dart';
import 'package:albedo_app/widgets/custom_tab.dart';
import 'package:albedo_app/widgets/drawer_menu.dart';
import 'package:albedo_app/widgets/header_with_search.dart';
import 'package:albedo_app/widgets/responsive.dart';
import 'package:albedo_app/widgets/session_widgets.dart';
import 'package:albedo_app/widgets/widgets.dart';
import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:get/get.dart';

class CoordinatorPage extends StatelessWidget {
  CoordinatorPage({super.key});

  final c = Get.put(CoordinatorController(), permanent: true);

  @override
  Widget build(BuildContext context) {
    final isDesktop = Responsive.isDesktop(context);
    final auth = Get.find<AuthController>();
    final role = auth.activeUser?.role;

    final isCustom = ![
      "admin",
      "mentor",
      "advisor",
      "teacher",
      "student",
      "coordinator",
      "finance",
      "sales",
      "hr"
    ].contains(role);

    return SafeArea(
      child: Scaffold(
        backgroundColor: Theme.of(context).colorScheme.surface,
        appBar: const CustomAppBar(),
        drawer: isDesktop ? null : const DrawerMenu(),
        floatingActionButton:
            (!isCustom || PermissionService.can("add_coordinators"))
                ? FloatingActionButton(
                    onPressed: () {
                      Get.to(() => const AddCoordinatorPage());
                    },
                    mini: true,
                    backgroundColor: context.theme.colorScheme.primary,
                    child: Icon(
                      Icons.add,
                      color: context.theme.colorScheme.onPrimary,
                    ),
                  )
                : null,
        body: Row(
          children: [
            if (isDesktop) DrawerMenu(),
            Expanded(
              child: Column(
                children: [
                  /// 🔍 Search + Sort
                  HeaderWithSearch(
                    title: "Coordinators",
                    hint: "Search coordinators...",
                    isSearching: c.isSearching,
                    searchQuery: c.searchQuery,
                    onSearchChanged: () => c.applyFilters(),
                    onSortTap: () => CustomWidgets().showSortSheet<SortType>(
                      title: "Sort Coordinators",
                      options: [
                        SortOption(
                          label: "Newest",
                          value: SortType.newest,
                          icon: Icons.schedule,
                        ),
                        SortOption(
                          label: "Oldest",
                          value: SortType.oldest,
                          icon: Icons.history,
                        ),
                        SortOption(
                          label: "Name A-Z",
                          value: SortType.name,
                          icon: Icons.sort_by_alpha,
                        ),
                      ],
                      selectedValue: c.sortType.value,
                      onSelected: (val) {
                        c.sortType.value = val;
                        c.applyFilters();
                      },
                    ),
                    onRequestTap: (!isCustom ||
                            PermissionService.can("verification_requests"))
                        ? () {}
                        : null,
                  ),

                  /// 🧭 Tabs
                  Obx(
                    () => CustomWidgets().customTabs(
                      context,
                      tabs: c.tabs,
                      selectedIndex: c.selectedTab.value,
                      onTap: (index) {
                        c.selectedTab.value = index;
                        c.applyFilters();
                      },
                      getCount: (index) => c.tabData[index]['count'],
                    ),
                  ),

                  const SizedBox(height: 10),

                  /// 📋 List
                  Expanded(
                    child: Obx(() {
                      if (c.isLoading.value) {
                        return const Center(child: CircularProgressIndicator());
                      }
                      if (c.filteredCoordinators.isEmpty) {
                        return const Center(
                            child: Text("No coordinators found"));
                      }
                      int crossAxisCount = 1;

                      if (Responsive.isTablet(context)) {
                        crossAxisCount = 2;
                      } else if (Responsive.isDesktop(context)) {
                        crossAxisCount = 3;
                      }

                      return LayoutBuilder(builder: (context, constraints) {
                        int crossAxisCount = 1;

                        if (constraints.maxWidth > 1200) {
                          crossAxisCount = 3;
                        } else if (constraints.maxWidth > 700) {
                          crossAxisCount = 2;
                        }

                        return MasonryGridView.count(
                            crossAxisCount: crossAxisCount,
                            padding: const EdgeInsets.symmetric(vertical: 6),
                            itemCount: c.filteredCoordinators.length,
                            itemBuilder: (context, index) {
                              final coordinator = c.filteredCoordinators[index];
                              final cs = Theme.of(context).colorScheme;

                              return Padding(
                                padding:
                                    const EdgeInsets.symmetric(horizontal: 12),
                                child: Align(
                                  alignment: Alignment.center,
                                  child: ConstrainedBox(
                                    constraints:
                                        const BoxConstraints(maxWidth: 700),
                                    child: PremiumInfoCard(
                                      id: coordinator.id ?? "",
                                      title: coordinator?.name ?? "",
                                      subtitle: coordinator?.email ?? "",
                                      status: coordinator?.status,
                                      statusColor:
                                          getStatusColor(coordinator?.status),
                                      footerText:
                                          "Joined • ${coordinator?.joinedAt.toString().substring(0, 16)}",
                                      extraInfo: coordinator?.phone != null
                                          ? "Contact • ${coordinator!.phone}"
                                          : null,
                                      onTap: () {
                                        if (coordinator != null) {
                                          (!isCustom ||
                                                  PermissionService.can(
                                                      "view_coordinators"))
                                              ? Get.to(() =>
                                                  CoordinatorDetailedPage(
                                                      coordinator: coordinator,
                                                      initialIndex: index))
                                              : null;
                                        }
                                      },
                                      actions: [
                                        InfoAction(
                                          icon: Icons.dashboard,
                                          color: cs.primary,
                                          onTap: () {
                                            final auth =
                                                Get.find<AuthController>();
                                            final user =
                                                coordinatorToUser(coordinator);

                                            auth.startImpersonation(user);

                                            Get.offAll(() => const Root());
                                          },
                                        ),
                                        if ((!isCustom ||
                                            PermissionService.can(
                                                "edit_coordinators")))
                                          InfoAction(
                                            icon: Icons.edit,
                                            color: cs.secondary,
                                            onTap: () {
                                              if (coordinator != null) {
                                                c.loadCoordinators(coordinator);
                                                Get.to(() => AddCoordinatorPage(
                                                    isEdit: true));
                                              }
                                            },
                                          ),
                                        if ((!isCustom ||
                                            PermissionService.can(
                                                "resign_coordinators")))
                                          InfoAction(
                                              icon: Icons.block,
                                              color: cs.error,
                                              onTap: () => CustomWidgets()
                                                      .showDeactivateDialog(
                                                    text:
                                                        'Are you sure you want to resign this coordinator permanently?',
                                                    context: context,
                                                    onConfirm: () => c.resign(
                                                        coordinator.id!),
                                                  )),
                                        if ((!isCustom ||
                                            PermissionService.can(
                                                "delete_coordinators")))
                                          InfoAction(
                                            icon: Icons.delete,
                                            color: cs.error,
                                            onTap: () => CustomWidgets()
                                                .showDeleteDialog(
                                              title: 'Are you sure?',
                                              text:
                                                  'Are you sure you want to delete this coordinator permanently?',
                                              context: context,
                                              onConfirm: () =>
                                                  c.delete(coordinator!.id),
                                            ),
                                          ),
                                      ],
                                    ),
                                  ),
                                ),
                              );
                            });
                      });
                    }),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
