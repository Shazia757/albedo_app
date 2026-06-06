import 'package:albedo_app/config/root.dart';
import 'package:albedo_app/controller/advisor_controller.dart';
import 'package:albedo_app/controller/auth_controller.dart';
import 'package:albedo_app/model/session_model.dart';
import 'package:albedo_app/view/advisor_detailed_page.dart';
import 'package:albedo_app/view/users/add_advisor_page.dart';
import 'package:albedo_app/widgets/custom_appbar.dart';
import 'package:albedo_app/widgets/custom_card.dart';
import 'package:albedo_app/widgets/drawer_menu.dart';
import 'package:albedo_app/widgets/header_with_search.dart';
import 'package:albedo_app/widgets/responsive.dart';
import 'package:albedo_app/widgets/session_widgets.dart';
import 'package:albedo_app/widgets/widgets.dart';
import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:get/get.dart';

class AdvisorsPage extends StatelessWidget {
  AdvisorsPage({super.key});

  final c = Get.put(AdvisorController(), permanent: true);

  @override
  Widget build(BuildContext context) {
    final isDesktop = Responsive.isDesktop(context);

    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.surface,
      appBar: const CustomAppBar(),
      drawer: isDesktop ? null : const DrawerMenu(),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Get.to(() => const AddAdvisorPage());
        },
        mini: true,
        backgroundColor: context.theme.colorScheme.primary,
        child: Icon(
          Icons.add,
          color: context.theme.colorScheme.onPrimary,
        ),
      ),
      body: Row(
        children: [
          if (isDesktop) DrawerMenu(),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(16, 16, 16, 0),
              child: Column(
                children: [
                  /// 🔍 Search + Sort
                  HeaderWithSearch(
                    title: "Advisors",
                    hint: "Search advisors...",
                    isSearching: c.isSearching,
                    searchQuery: c.searchQuery,
                    onSearchChanged: () => c.applyFilters(),
                    onSortTap: () => CustomWidgets().showSortSheet<SortType>(
                      title: "Sort Advisors",
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

                  SizedBox(height: 10),

                  /// 📋 List
                  Expanded(
                    child: Obx(() {
                      if (c.isLoading.value) {
                        return Center(child: CircularProgressIndicator());
                      }
                      if (c.filteredAdvisors.isEmpty) {
                        return Center(child: Text("No advisors found"));
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
                            itemCount: c.filteredAdvisors.length,
                            itemBuilder: (context, index) {
                              final advisor = c.filteredAdvisors[index];
                              final cs = Theme.of(context).colorScheme;

                              return Padding(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 4, vertical: 4),
                                child: Align(
                                  alignment: Alignment.center,
                                  child: ConstrainedBox(
                                    constraints:
                                        const BoxConstraints(maxWidth: 700),
                                    child: PremiumInfoCard(
                                      id: advisor.empId ?? "",
                                      title: advisor.name ?? "",
                                      subtitle: advisor.email ?? "",
                                      status: (advisor.isResigned == true)
                                          ? 'Inactive'
                                          : 'Active',
                                      statusColor: getStatusColor(
                                          (advisor.isResigned == true)
                                              ? 'Inactive'
                                              : 'Active'),
                                      footerText: advisor.phone != null
                                          ? "Contact • ${advisor.phone}"
                                          : "",
                                      onTap: () {
                                        {
                                          Get.to(() => AdvisorDetailedPage(
                                              advisor: advisor,
                                              initialIndex: index));
                                        }
                                      },
                                      actions: [
                                        InfoAction(
                                          icon: Icons.dashboard,
                                          color: cs.primary,
                                          onTap: () {
                                            final auth =
                                                Get.find<AuthController>();
                                            final user = advisorToUser(advisor);

                                            auth.startImpersonation(user);
                                            Get.offAll(() => const Root());
                                          },
                                        ),
                                        InfoAction(
                                          icon: Icons.edit,
                                          color: cs.secondary,
                                          onTap: () {
                                            // c.loadAdvisors(advisor);
                                            Get.to(() =>
                                                AddAdvisorPage(isEdit: true));
                                          },
                                        ),
                                        InfoAction(
                                            icon: Icons.block,
                                            color: cs.error,
                                            onTap: () => CustomWidgets()
                                                    .showDeactivateDialog(
                                                  text:
                                                      'Are you sure you want to deactivate this advisor permanently?',
                                                  context: context,
                                                  onConfirm: () =>
                                                      c.deactivate(advisor.id),
                                                )),
                                        InfoAction(
                                          icon: Icons.delete,
                                          color: cs.error,
                                          onTap: () =>
                                              CustomWidgets().showDeleteDialog(
                                            dltText: Obx(
                                              () => c.isLoading.value
                                                  ? const SizedBox(
                                                      width: 18,
                                                      height: 18,
                                                      child:
                                                          CircularProgressIndicator(
                                                        strokeWidth: 2,
                                                        color: Colors.white,
                                                      ),
                                                    )
                                                  : Text(
                                                      "Yes",
                                                      style: Theme.of(context)
                                                          .textTheme
                                                          .titleSmall!
                                                          .copyWith(
                                                              color:
                                                                  Colors.white),
                                                    ),
                                            ),
                                            title: 'Are you sure?',
                                            text:
                                                'Are you sure you want to delete this advisor permanently?',
                                            context: context,
                                            onConfirm: () =>
                                                c.delete(advisor.id),
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
          ),
        ],
      ),
    );
  }
}
