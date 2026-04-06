import 'package:albedo_app/controller/session_controller.dart';
import 'package:albedo_app/controller/user_controller.dart';
import 'package:albedo_app/model/session_model.dart';
import 'package:albedo_app/model/student_model.dart';
import 'package:albedo_app/model/teacher_model.dart';
import 'package:albedo_app/view/forgot_password_page.dart';
import 'package:albedo_app/widgets/widgets.dart';
import 'package:albedo_app/widgets/custom_appbar.dart';
import 'package:albedo_app/widgets/drawer_menu.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class UsersPage extends StatelessWidget {
  final UserPageType type;
  UsersPage({super.key, required this.type});

  final studentController = Get.put(UserController(UserPageType.student));
  final teacherController =
      Get.put(UserController(UserPageType.teacher), tag: "teacher");

  @override
  Widget build(BuildContext context) {
    final isDesktop = Responsive.isDesktop(context);
    List<String> getTabs() {
      if (type == UserPageType.teacher) {
        return ["All", "Active", "Batch", "Inactive"];
      }
      return ["All", "Active", "Batch", "TBA", "Inactive"];
    }

    final tabs = getTabs();

    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.onPrimary,
      appBar: Responsive.isMobile(context) ? const CustomAppBar() : null,
      drawer: isDesktop ? null : const DrawerMenu(),
      body: Column(
        children: [
          /// 🔍 Search + Sort
          Padding(
            padding: const EdgeInsets.all(12),
            child: Row(
              children: [
                Expanded(
                  child: (type == UserPageType.student)
                      ? CustomWidgets().premiumSearch(context,
                          hint: "Search students...",
                          onChanged: (value) =>
                              studentController.searchQuery.value = value)
                      : CustomWidgets().premiumSearch(context,
                          hint: "Search teachers...",
                          onChanged: (value) =>
                              teacherController.searchQuery.value = value),
                ),

                const SizedBox(width: 10),

                /// Sort
                InkWell(
                  borderRadius: BorderRadius.circular(8),
                  onTap: () => CustomWidgets().showSortSheet(
                    title: "Sort Students",
                    options: [
                      SortOption(
                          label: "Newest",
                          value: SortType.newest,
                          icon: Icons.schedule),
                      SortOption(
                          label: "Oldest",
                          value: SortType.oldest,
                          icon: Icons.history),
                      SortOption(
                          label: "Name A-Z",
                          value: SortType.student,
                          icon: Icons.sort_by_alpha),
                    ],
                    selectedValue: (type == UserPageType.student)
                        ? studentController.sortType.value
                        : teacherController.sortType.value,
                    onSelected: (val) {
                      if (type == UserPageType.student) {
                        studentController.sortType.value = val;
                        studentController.applyFilters();
                      } else {
                        teacherController.sortType.value = val;
                        teacherController.applyFilters();
                      }
                    },
                  ),
                  child: const Padding(
                    padding: EdgeInsets.all(8),
                    child: Icon(Icons.sort, size: 20),
                  ),
                )
              ],
            ),
          ),

          /// 🧭 Tabs
          Obx(
            () => CustomWidgets().customTabs(
              context,
              tabs: tabs,
              selectedIndex: (type == UserPageType.student)
                  ? studentController.selectedTab.value
                  : teacherController.selectedTab.value,
              onTap: (index) {
                if (type == UserPageType.student) {
                  studentController.selectedTab.value = index;
                  studentController.applyFilters();
                } else {
                  teacherController.selectedTab.value = index;
                  teacherController.applyFilters();
                }
              },
              getCount: (index) {
                if (type == UserPageType.teacher) {
                  switch (index) {
                    case 0:
                      return teacherController.allCount;
                    case 1:
                      return teacherController.activeCount;
                    case 2:
                      return teacherController.batchCount;
                    case 3:
                      return teacherController.inactiveCount;
                    default:
                      return 0;
                  }
                } else {
                  switch (index) {
                    case 0:
                      return studentController.allCount;
                    case 1:
                      return studentController.activeCount;
                    case 2:
                      return studentController.batchCount;
                    case 3:
                      return studentController.tbaCount;
                    case 4:
                      return studentController.inactiveCount;
                    default:
                      return 0;
                  }
                }
              },
            ),
          ),

          const SizedBox(height: 10),

          /// 📋 List
          Expanded(
            child: Obx(() {
              if (type == UserPageType.student) {
                if (studentController.filteredStudents.isEmpty) {
                  return const Center(child: Text("No students found"));
                }
              } else {
                if (teacherController.filteredTeachers.isEmpty) {
                  return const Center(child: Text("No teachers found"));
                }
              }

              return ListView.builder(
                padding: const EdgeInsets.symmetric(vertical: 6),
                itemCount: (type == UserPageType.student)
                    ? studentController.filteredStudents.length
                    : teacherController.filteredTeachers.length,
                itemBuilder: (context, index) {
                  final student = studentController.filteredStudents[index];
                  final teacher = teacherController.filteredTeachers[index];

                  return Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 12),
                    child: Align(
                      alignment: Alignment.center,
                      child: ConstrainedBox(
                        constraints: const BoxConstraints(maxWidth: 700),
                        child: _studentCard(context, student, teacher),
                      ),
                    ),
                  );
                },
              );
            }),
          ),
        ],
      ),
    );
  }

  /// 💎 Premium Card
  Widget _studentCard(BuildContext context, Student? s, TeacherModel? t) {
    final cs = Theme.of(context).colorScheme;

    final isActive = (type == UserPageType.student)
        ? s?.status == "Active"
        : t?.status == "Active";

    final statusColor = isActive ? cs.primary : cs.error;

    return Container(
      margin: const EdgeInsets.symmetric(vertical: 6),
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16),
        color: cs.surface,
        boxShadow: [
          BoxShadow(
            color: cs.shadow.withOpacity(0.08),
            blurRadius: 12,
            offset: const Offset(0, 6),
          ),
        ],
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          /// 🔥 Left Accent Bar
          Container(
            width: 4,
            height: 70,
            decoration: BoxDecoration(
              color: statusColor,
              borderRadius: BorderRadius.circular(10),
            ),
          ),

          const SizedBox(width: 10),

          /// Content
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                /// Top Row
                Row(
                  children: [
                    Text(
                      (type == UserPageType.student)
                          ? s?.studentId ?? 'NULL'
                          : t?.id ?? 'NULL',
                      style: TextStyle(
                        fontSize: 11,
                        fontWeight: FontWeight.w600,
                        color: cs.onSurface.withOpacity(0.6),
                      ),
                    ),
                    const Spacer(),

                    /// Status Badge
                    Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 10, vertical: 4),
                      decoration: BoxDecoration(
                        color: statusColor.withOpacity(0.12),
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Text(
                        (type == UserPageType.student)
                            ? s?.status ?? 'NULL'
                            : t?.status ?? 'NULL',
                        style: TextStyle(
                          color: statusColor,
                          fontSize: 11,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: 6),

                /// Name
                Text(
                  (type == UserPageType.student)
                      ? s?.name ?? 'NULL'
                      : t?.name ?? 'NULL',
                  style: TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.w600,
                    color: cs.onSurface,
                  ),
                ),

                const SizedBox(height: 2),

                /// Email
                Text(
                  (type == UserPageType.student)
                      ? s?.email ?? 'NULL'
                      : t?.email ?? 'NULL',
                  style: TextStyle(
                    fontSize: 12,
                    color: cs.onSurface.withOpacity(0.6),
                  ),
                ),

                const SizedBox(height: 6),

                /// Extra Info
                Text(
                  type == UserPageType.student
                      ? "Joined • ${s?.joinedAt.toString().substring(0, 16) ?? 'NULL'}"
                      : "Contact • ${t?.phone ?? "N/A"}",
                  style: TextStyle(
                    fontSize: 11,
                    color: cs.onSurface.withOpacity(0.5),
                  ),
                ),

                const SizedBox(height: 10),

                /// 🔘 Actions
                Row(
                  children: [
                    CustomWidgets().iconBtn(
                      title: "Dashboard",
                      icon: Icons.dashboard,
                      color: cs.primary,
                    ),
                    const SizedBox(width: 8),
                    CustomWidgets().iconBtn(
                      icon: Icons.edit,
                      color: cs.secondary,
                    ),
                    const SizedBox(width: 8),
                    CustomWidgets().iconBtn(
                      icon: Icons.block,
                      color: cs.error,
                    ),
                    const SizedBox(width: 8),
                    CustomWidgets().iconBtn(
                      icon: Icons.delete,
                      color: cs.onSurface.withOpacity(0.4),
                    ),
                  ],
                )
              ],
            ),
          ),
        ],
      ),
    );
  }
}
