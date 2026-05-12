import 'package:albedo_app/config/root.dart';
import 'package:albedo_app/controller/auth_controller.dart';
import 'package:albedo_app/controller/mentor_controller.dart';
import 'package:albedo_app/controller/permissions_controller.dart';
import 'package:albedo_app/model/session_model.dart';
import 'package:albedo_app/view/mentor_detailed_page.dart';
import 'package:albedo_app/view/mentor_feedback_page.dart';
import 'package:albedo_app/view/settings/bulk_upload_page.dart';
import 'package:albedo_app/view/users/add_mentor_page.dart';
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

class MentorsPage extends StatelessWidget {
  final c = Get.put(MentorController());

  MentorsPage({super.key});

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

    return Scaffold(
      appBar: const CustomAppBar(),
      backgroundColor: Theme.of(context).colorScheme.surface,
      drawer: isDesktop ? null : const DrawerMenu(),
      floatingActionButton: (!isCustom || PermissionService.can("add_mentors"))
          ? FloatingActionButton(
              onPressed: () {
                Get.to(() => const AddMentorPage());
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
          if (isDesktop) const DrawerMenu(),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(16, 16, 16, 0),
              child: Column(
                children: [
                  _topBar(context),
                  SizedBox(height: 12),
                  Obx(
                    () => CustomWidgets().customTabs(
                      context,
                      tabs: c.tabs,
                      selectedIndex: c.selectedTab.value,
                      onTap: (index) {
                        c.selectedTab.value = index;
                        c.applyFilters();
                      },
                      getCount: (index) => c.getCount(index),
                    ),
                  ),
                  SizedBox(height: 12),
                  Expanded(
                    child: Obx(() {
                      final data = c.filteredMentors;
                      final cs = Theme.of(context).colorScheme;
                      int crossAxisCount = 1;

                      if (c.isLoading.value) {
                        return Center(child: CircularProgressIndicator());
                      }
                      if (data.isEmpty) {
                        return Center(
                            child: Text(
                          "No mentors found",
                          style: Theme.of(context).textTheme.bodyMedium,
                        ));
                      }

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
                            padding: const EdgeInsets.symmetric(vertical: 6),
                            crossAxisCount: crossAxisCount,
                            itemCount: c.filteredMentors.length,
                            itemBuilder: (context, index) {
                              final mentor = c.filteredMentors[index];

                              return ClipRRect(
                                borderRadius: BorderRadius.circular(16),
                                child: Padding(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 12),
                                  child: PremiumInfoCard(
                                    id: mentor.id ?? "-",
                                    title: mentor?.name ?? "-",
                                    subtitle: mentor?.email ?? "-",
                                    status: mentor?.status,
                                    statusColor: getStatusColor(mentor?.status),
                                    footerText:
                                        "Joined • ${mentor?.joinedAt.toString().substring(0, 16)}",
                                    extraInfo: mentor?.phone != null
                                        ? "Contact • ${mentor!.phone}"
                                        : null,
                                    onTap: (!isCustom ||
                                            PermissionService.can(
                                                "view_mentors"))
                                        ? () => Get.to(() => MentorDetailsPage(
                                            mentor: mentor,
                                            initialIndex: index))
                                        : null,
                                    actions: [
                                      InfoAction(
                                        icon: Icons.dashboard,
                                        color: cs.primary,
                                        onTap: () {
                                          final auth =
                                              Get.find<AuthController>();
                                          final user = mentorToUser(mentor);
                                          auth.startImpersonation(user);
                                          Get.offAll(() => const Root());
                                        },
                                      ),
                                      if (!isCustom ||
                                          PermissionService.can("edit_mentors"))
                                        InfoAction(
                                          icon: Icons.edit,
                                          color: cs.secondary,
                                          onTap: () {
                                            if (mentor != null) {
                                              c.loadMentors(mentor);
                                              Get.to(() =>
                                                  AddMentorPage(isEdit: true));
                                            }
                                          },
                                        ),
                                      if (!isCustom ||
                                          PermissionService.can(
                                              "resign_mentors"))
                                        InfoAction(
                                          icon: Icons.block,
                                          color: cs.error,
                                          onTap: () =>
                                              c.handleResign(context, mentor),
                                        ),
                                      if (!isCustom ||
                                          PermissionService.can(
                                              "delete_mentors"))
                                        InfoAction(
                                          icon: Icons.delete,
                                          color: cs.error,
                                          onTap: () =>
                                              c.handleDelete(context, mentor),
                                        ),
                                    ],
                                  ),
                                ),
                              );
                            });
                      });
                    }),
                  )
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _topBar(BuildContext context) {
    final isMobile = Responsive.isMobile(context);
    final auth = Get.find<AuthController>();
    final role = auth.activeUser?.role;
    final cs = Theme.of(context).colorScheme;

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

    if (isMobile) {
      return Column(
        children: [
          /// 🔹 TITLE + SEARCH TOGGLE (same row)
          HeaderWithSearch(
            title: "Mentors",
            hint: "Search mentors...",
            isSearching: c.isSearching,
            searchQuery: c.searchQuery,
            onSearchChanged: () => c.applyFilters(),
            actions: [
              IconButton(
                iconSize: 20,
                icon: Icon(
                  Icons.feedback_outlined,
                  color: cs.primary,
                ),
                tooltip: "Feedbacks",
                onPressed:
                    (!isCustom || PermissionService.can("mentor_feedbacks"))
                        ? () => Get.to(() => MentorFeedbackPage(
                            title: 'Mentor Feedback', role: 'mentor'))
                        : null,
              ),
              IconButton(
                iconSize: 20,
                icon: Icon(
                  Icons.upload_file_outlined,
                  color: cs.primary,
                ),
                tooltip: "Bulk Upload",
                onPressed: () => Get.to(() => BulkUploadPage()),
              ),
            ],
          ),

          Row(
            children: [
              Expanded(child: _filterButton(context)),
              const SizedBox(width: 10),
              Expanded(child: _sortButton(context, c)),
            ],
          )
        ],
      );
    }

    /// DESKTOP (unchanged)
    return Row(
      children: [
        Expanded(
            flex: 3,
            child: CustomWidgets().premiumSearch(
              context,
              hint: "Search Mentors...",
              onChanged: (val) => c.searchQuery.value = val,
            )),
        const SizedBox(width: 12),
        _filterButton(context),
        const SizedBox(width: 8),
        _sortButton(context, c),
      ],
    );
  }

  Widget _sortButton(BuildContext context, MentorController c) {
    return GestureDetector(
      onTap: () => CustomWidgets().showSortSheet<SortType>(
        title: "Sort Mentors",
        options: [
          SortOption(
              label: "Newest", value: SortType.newest, icon: Icons.schedule),
          SortOption(
              label: "Oldest", value: SortType.oldest, icon: Icons.history),
          SortOption(
              label: "Name A-Z",
              value: SortType.name,
              icon: Icons.sort_by_alpha),
        ],
        selectedValue: c.sortType.value,
        onSelected: (val) {
          c.sortType.value = val;
          c.applyFilters();
        },
      ),
      child: Container(
        height: 44,
        padding: const EdgeInsets.symmetric(horizontal: 12),
        decoration: BoxDecoration(
          color: Theme.of(context).colorScheme.onPrimary,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: Theme.of(context).colorScheme.outline.withOpacity(0.5),
          ),
        ),
        child: const Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(Icons.sort, size: 18),
            SizedBox(width: 6),
            Text("Sort"),
          ],
        ),
      ),
    );
  }

  Widget _filterButton(BuildContext context) {
    return Container(
      height: 44,
      padding: const EdgeInsets.symmetric(horizontal: 12),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.onPrimary,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
            color: Theme.of(context).colorScheme.outline.withOpacity(0.5)),
      ),
      child: GestureDetector(
        onTap: () => CustomWidgets().showFilterSheet(
          title: "Filter Sessions",
          options: c.ratingFilters,
          selectedValue: c.selectedRating.value,
          onSelected: (val) {
            c.selectedRating.value = val;
            c.applyFilters();
          },
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: const [
            Icon(Icons.filter_list, size: 18),
            SizedBox(width: 6),
            Text("Filter", style: TextStyle(fontSize: 13)),
          ],
        ),
      ),
    );
  }
}
