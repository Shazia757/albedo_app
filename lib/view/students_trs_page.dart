import 'package:albedo_app/controller/session_controller.dart';
import 'package:albedo_app/controller/user_controller.dart';
import 'package:albedo_app/model/session_model.dart';
import 'package:albedo_app/model/student_model.dart';
import 'package:albedo_app/model/teacher_model.dart';
import 'package:albedo_app/view/forgot_password_page.dart';
import 'package:albedo_app/widgets/button.dart';
import 'package:albedo_app/widgets/custom_appbar.dart';
import 'package:albedo_app/widgets/drawer_menu.dart';
import 'package:albedo_app/widgets/search_bar.dart';
import 'package:albedo_app/widgets/sort_sheet.dart';
import 'package:albedo_app/widgets/tabs.dart';
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
      backgroundColor: const Color(0xFFF5F7FB),
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
                      ? premiumSearch(
                          hint: "Search students...",
                          onChanged: (value) =>
                              studentController.searchQuery.value = value)
                      : premiumSearch(
                          hint: "Search teachers...",
                          onChanged: (value) =>
                              teacherController.searchQuery.value = value),
                ),

                const SizedBox(width: 10),

                /// Sort
                InkWell(
                  borderRadius: BorderRadius.circular(8),
                  onTap: () => showSortSheet(
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
            () => customTabs(
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
                        child: _studentCard(student, teacher),
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
  Widget _studentCard(Student? s, TeacherModel? t) {
    final isActive = (type == UserPageType.student)
        ? s?.status == "Active"
        : t?.status == "Active";
    final statusColor = isActive ? Colors.green : Colors.red;

    return Container(
      margin: const EdgeInsets.symmetric(vertical: 6),
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16),
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.06),
            blurRadius: 12,
            offset: const Offset(0, 6),
          ),
        ],
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          /// 🔥 Left Accent Bar (Premium feel)
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
                          ? s?.id ?? 'NULL'
                          : t?.id ?? 'NULL',
                      style: const TextStyle(
                        fontSize: 11,
                        fontWeight: FontWeight.w600,
                        color: Colors.grey,
                      ),
                    ),
                    const Spacer(),

                    /// Status Badge
                    Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 10, vertical: 4),
                      decoration: BoxDecoration(
                        color: statusColor.withOpacity(0.1),
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
                  style: const TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.w600,
                  ),
                ),

                const SizedBox(height: 2),

                /// Email
                Text(
                  (type == UserPageType.student)
                      ? s?.email ?? 'NULL'
                      : t?.email ?? 'NULL',
                  style: const TextStyle(
                    fontSize: 12,
                    color: Colors.grey,
                  ),
                ),

                const SizedBox(height: 6),

                type == UserPageType.student
                    ? Text(
                        "Joined • ${s?.joinedAt.toString().substring(0, 16) ?? 'NULL'}",
                        style: const TextStyle(
                          fontSize: 11,
                          color: Colors.grey,
                        ),
                      )
                    : Text(
                        "Contact • ${t?.phone ?? "N/A"}",
                        style: const TextStyle(
                          fontSize: 11,
                          color: Colors.grey,
                        ),
                      ),

                const SizedBox(height: 10),

                /// 🔘 Actions (pill style)
                Row(
                  spacing: 8,
                  children: [
                    iconBtn(
                        title: "Dashboard",
                        icon: Icons.dashboard,
                        color: Colors.blue),
                    iconBtn(icon: Icons.edit, color: Colors.orange),
                    iconBtn(icon: Icons.block, color: Colors.red),
                    iconBtn(icon: Icons.delete, color: Colors.grey),
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
