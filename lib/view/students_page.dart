import 'package:albedo_app/controller/session_controller.dart';
import 'package:albedo_app/controller/user_controller.dart';
import 'package:albedo_app/model/session_model.dart';
import 'package:albedo_app/model/student_model.dart';
import 'package:albedo_app/view/forgot_password_page.dart';
import 'package:albedo_app/widgets/button.dart';
import 'package:albedo_app/widgets/custom_appbar.dart';
import 'package:albedo_app/widgets/drawer_menu.dart';
import 'package:albedo_app/widgets/search_bar.dart';
import 'package:albedo_app/widgets/sort_sheet.dart';
import 'package:albedo_app/widgets/tabs.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class StudentsPage extends StatelessWidget {
  StudentsPage({super.key});

  final c = Get.put(UserController());

  @override
  Widget build(BuildContext context) {
    final isDesktop = Responsive.isDesktop(context);
    final tabs = [
      "All",
      "Active",
      "Batch",
      "TBA",
      "Inactive",
    ];
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
                  child: premiumSearch(
                      hint: "Search students...",
                      onChanged: (value) => c.searchQuery.value = value),
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
                    selectedValue: c.sortType.value,
                    onSelected: (val) {
                      c.sortType.value = val;
                      c.applyFilters();
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
              selectedIndex: c.selectedTab.value,
              onTap: (index) {
                c.selectedTab.value = index;
                c.applyFilters();
              },
              getCount: (index) {
                switch (index) {
                  case 0:
                    return c.allCount;
                  case 1:
                    return c.activeCount;
                  case 2:
                    return c.batchCount;
                  case 3:
                    return c.tbaCount;
                  case 4:
                    return c.inactiveCount;
                  default:
                    return 0;
                }
              },
            ),
          ),

          const SizedBox(height: 10),

          /// 📋 List
          Expanded(
            child: Obx(() {
              if (c.filteredStudents.isEmpty) {
                return const Center(child: Text("No students found"));
              }

              return ListView.builder(
                padding: const EdgeInsets.symmetric(vertical: 6),
                itemCount: c.filteredStudents.length,
                itemBuilder: (context, index) {
                  final student = c.filteredStudents[index];

                  return Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 12),
                    child: Align(
                      alignment: Alignment.center,
                      child: ConstrainedBox(
                        constraints: const BoxConstraints(maxWidth: 700),
                        child: _studentCard(student),
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
  Widget _studentCard(Student s) {
    final isActive = s.status == "Active";
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
                      s.id,
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
                        s.status,
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
                  s.name,
                  style: const TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.w600,
                  ),
                ),

                const SizedBox(height: 2),

                /// Email
                Text(
                  s.email,
                  style: const TextStyle(
                    fontSize: 12,
                    color: Colors.grey,
                  ),
                ),

                const SizedBox(height: 6),

                /// Date
                Text(
                  "Joined • ${s.joinedAt.toString().substring(0, 16)}",
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

  Widget _pillBtn(String title, IconData icon, Color color) {
    return InkWell(
      onTap: () {},
      borderRadius: BorderRadius.circular(20),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
        decoration: BoxDecoration(
          color: color.withOpacity(0.08),
          borderRadius: BorderRadius.circular(20),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icon, size: 14, color: color),
            const SizedBox(width: 4),
            Text(
              title,
              style: TextStyle(
                fontSize: 11,
                color: color,
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
