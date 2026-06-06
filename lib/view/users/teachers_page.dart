import 'package:albedo_app/config/root.dart';
import 'package:albedo_app/controller/auth_controller.dart';
import 'package:albedo_app/controller/permissions_controller.dart';
import 'package:albedo_app/controller/teacher_controller.dart';
import 'package:albedo_app/model/session_model.dart';
import 'package:albedo_app/view/mentor_feedback_page.dart';
import 'package:albedo_app/view/teacher/tr_detailed_page.dart';
import 'package:albedo_app/view/users/add_teacher_page.dart';
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

class TeachersPage extends StatelessWidget {
  TeachersPage({super.key});

  final c = Get.put(TeacherController(), permanent: true);

  @override
  Widget build(BuildContext context) {
    final isDesktop = Responsive.isDesktop(context);
    final auth = Get.find<AuthController>();
    final role = auth.activeUser?.role;
    final normalizedRole = role?.trim().toLowerCase();

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
    ].contains(normalizedRole);
    final canSeeTeacherFeedbacks =
        !isCustom || PermissionService.can("teacher_feedbacks");

    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.surface,
      appBar: const CustomAppBar(),
      drawer: isDesktop ? null : const DrawerMenu(),
      floatingActionButton: (!isCustom || PermissionService.can("add_teachers"))
          ? FloatingActionButton(
              onPressed: () {
                Get.to(() => const AddTeacherPage(
                      isEdit: false,
                    ));
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
            child: Padding(
              padding: const EdgeInsets.fromLTRB(16, 16, 16, 0),
              child: Column(
                children: [
                  /// 🔍 Search + Sort
                  HeaderWithSearch(
                    title: "Teachers",
                    hint: "Search teachers...",
                    isSearching: c.isSearching,
                    searchQuery: c.searchQuery,
                    onSearchChanged: () => c.applyFilters(),
                    onSortTap: () => CustomWidgets().showSortSheet<SortType>(
                      title: "Sort Teachers",
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
                    actions: [
                      PopupMenuButton<String>(
                        padding: EdgeInsets.zero,
                        offset: const Offset(0, 45),
                        color: Theme.of(context).colorScheme.surface,
                        elevation: 6,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(14),
                        ),
                        onSelected: (value) {
                          switch (value) {
                            case "feedbacks":
                              if (canSeeTeacherFeedbacks) {
                                Get.to(() => MentorFeedbackPage(
                                      role: 'teacher',
                                      title: 'Teacher Feedback',
                                    ));
                              }
                              break;

                            case "bulk_upload":
                              // Get.to(() => const BulkUploadPage());
                              break;
                          }
                        },
                        itemBuilder: (context) => [
                          if (canSeeTeacherFeedbacks)
                            PopupMenuItem(
                              value: "feedbacks",
                              child: MenuItem(
                                icon: Icons.feedback_outlined,
                                title: "Feedbacks",
                              ),
                            ),
                          PopupMenuItem(
                            value: "bulk_upload",
                            child: MenuItem(
                              icon: Icons.upload_file,
                              title: "Bulk Upload",
                            ),
                          ),
                        ],
                        child: Padding(
                          padding: EdgeInsets.symmetric(horizontal: 8),
                          child: Icon(
                            Icons.more_vert,
                            color: Theme.of(context).colorScheme.primary,
                          ),
                        ),
                      )
                    ],
                  ),
                  SizedBox(height: 5),

                  /// 🧭 Tabs
                  Obx(
                    () => CustomWidgets().customTabs(
                      context,
                      tabs: c.tabs,
                      selectedIndex: c.selectedTab.value,
                      onTap: (index) async {
                        c.selectedTab.value = index;
                        c.currentPage.value = 0;

                        await c.fetchTeachers();
                      },
                      getCount: (index) {
                        return c.tabData[index]['count'];
                      },
                    ),
                  ),

                  SizedBox(height: 10),

                  /// 📋 List
                  Expanded(
                    child: Obx(() {
                      if (c.isLoading.value) {
                        return Center(child: CircularProgressIndicator());
                      }
                      if (c.filteredTeachers.isEmpty) {
                        return Center(child: Text("No teachers found"));
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
                            itemCount: c.filteredTeachers.length,
                            itemBuilder: (context, index) {
                              final teacher = c.filteredTeachers[index];
                              final cs = Theme.of(context).colorScheme;

                              return Padding(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 4, vertical: 4),
                                child: ConstrainedBox(
                                    constraints:
                                        const BoxConstraints(maxWidth: 700),
                                    child: PremiumInfoCard(
                                      id: teacher.teacherId ?? "",
                                      title: teacher.name ?? "",
                                      subtitle: teacher.email ?? "",
                                      status: teacher.status,
                                      statusColor:
                                          getStatusColor(teacher.status),
                                      footerText: teacher.phone != null
                                          ? "Contact • ${teacher.phone}"
                                          : "",
                                      onTap: () {
                                        (!isCustom ||
                                                PermissionService.can(
                                                    "view_teachers"))
                                            ? Get.to(() => TeacherDetailsPage(
                                                teacher: teacher,
                                                initialIndex: index))
                                            : null;
                                      },
                                      actions: [
                                        InfoAction(
                                          icon: Icons.dashboard,
                                          color: cs.primary,
                                          onTap: () {
                                            final auth =
                                                Get.find<AuthController>();
                                            final user = teacherToUser(teacher);

                                            auth.startImpersonation(user);
                                            Get.offAll(() => const Root());
                                          },
                                        ),
                                        if ((!isCustom ||
                                                PermissionService.can(
                                                    "edit_teachers")) &&
                                            teacher.status != 'Inactive')
                                          InfoAction(
                                            icon: Icons.edit,
                                            color: cs.secondary,
                                            onTap: () {
                                              c.loadTeachers(teacher);
                                              Get.to(() => AddTeacherPage(
                                                    isEdit: true,
                                                  ));
                                            },
                                          ),
                                        if (!isCustom ||
                                            PermissionService.can(
                                                "deactivate_teachers"))
                                          InfoAction(
                                              icon: Icons.block,
                                              color: cs.error,
                                              onTap: () => c.handleDeactivate(
                                                  context, teacher)),
                                        if (!isCustom ||
                                            (PermissionService.can(
                                                "delete_teachers")))
                                          InfoAction(
                                              icon: Icons.delete,
                                              color: cs.error,
                                              onTap: () => c.handleDelete(
                                                  context, teacher)),
                                      ],
                                    )),
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
