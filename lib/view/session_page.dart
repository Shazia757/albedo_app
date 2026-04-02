import 'package:albedo_app/controller/session_controller.dart';
import 'package:albedo_app/model/session_model.dart';
import 'package:albedo_app/view/forgot_password_page.dart';
import 'package:albedo_app/widgets/button.dart';
import 'package:albedo_app/widgets/custom_appbar.dart';
import 'package:albedo_app/widgets/custom_card.dart';
import 'package:albedo_app/widgets/drawer_menu.dart';
import 'package:albedo_app/widgets/search_bar.dart';
import 'package:albedo_app/widgets/sort_sheet.dart';
import 'package:albedo_app/widgets/tabs.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class SessionPage extends StatelessWidget {
  final c = Get.put(SessionController());

  SessionPage({super.key});

  @override
  Widget build(BuildContext context) {
    final isDesktop = Responsive.isDesktop(context);

    return Scaffold(
      appBar: Responsive.isMobile(context) ? const CustomAppBar() : null,
      backgroundColor: const Color(0xFFF8FAFC),
      drawer: isDesktop ? null : const DrawerMenu(),
      body: Row(
        children: [
          if (isDesktop) const DrawerMenu(),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                children: [
                  _topBar(context, c),
                  const SizedBox(height: 12),
                  Obx(
                    () => customTabs(
                        tabs: c.tabs,
                        selectedIndex: c.selectedTab.value,
                        getCount: (index) {
                          if (index == 0) return c.sessions.length;
                          return c.sessions
                              .where((e) => e.status == c.statusMap[index])
                              .length;
                        },
                        onTap: (index) {
                          c.selectedTab.value = index;
                          c.applyFilters();
                        }),
                  ),
                  const SizedBox(height: 12),
                  Expanded(
                    child: Obx(() {
                      final data = c.filteredSessions;

                      if (data.isEmpty) {
                        return const Center(child: Text("No sessions found"));
                      }

                      int crossAxisCount = 1;

                      if (Responsive.isTablet(context)) {
                        crossAxisCount = 2;
                      } else if (Responsive.isDesktop(context)) {
                        crossAxisCount = 3;
                      }

                      return GridView.builder(
                        itemCount: data.length,
                        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: crossAxisCount,
                          crossAxisSpacing: 12,
                          mainAxisSpacing: 12,
                          childAspectRatio: 1.2,
                        ),
                        itemBuilder: (_, i) => InfoCard(
                          id: data[i].id,
                          status: data[i].status,
                          statusColor: getStatusColor(data[i].status),
                          infoRows: [
                            Row(
                              children: [
                                Expanded(
                                    child: _personCompact(
                                        "Student",
                                        data[i].studentName,
                                        data[i].studentId)),
                                const SizedBox(width: 10),
                                Expanded(
                                    child: _personCompact(
                                        "Teacher",
                                        data[i].teacherName,
                                        data[i].teacherId)),
                              ],
                            ),
                            Container(
                              padding: const EdgeInsets.all(10),
                              decoration: BoxDecoration(
                                color: Colors.grey.shade50,
                                borderRadius: BorderRadius.circular(12),
                              ),
                              child: Column(
                                children: [
                                  Row(
                                    children: [
                                      Expanded(
                                          child: _miniInfo(
                                              "Subject", data[i].subject)),
                                      Expanded(
                                          child: _miniInfo(
                                              "Class", data[i].className)),
                                    ],
                                  ),
                                  const SizedBox(height: 6),
                                  Row(
                                    children: [
                                      Expanded(
                                          child: _miniInfo("Date",
                                              "${data[i].dateTime.day}/${data[i].dateTime.month}/${data[i].dateTime.year}")),
                                      Expanded(
                                          child: _miniInfo("Time",
                                              _formatTime(data[i].dateTime))),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                          ],
                          actions: [
                            iconBtn(
                                icon: Icons.edit,
                                color: Colors.blue,
                                onTap: () {}),
                            iconBtn(
                                icon: Icons.delete,
                                color: Colors.red,
                                onTap: () {}),
                          ],
                        ),
                      );
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

  Widget _topBar(BuildContext context, SessionController c) {
    final isMobile = Responsive.isMobile(context);

    if (isMobile) {
      return Column(
        children: [
          premiumSearch(
            hint: "Search sessions...",
            onChanged: (val) => c.searchQuery.value = val,
          ),
          const SizedBox(height: 10),
          Row(
            children: [
              Expanded(child: _filterButton()),
              const SizedBox(width: 10),
              Expanded(child: _sortButton(c)),
            ],
          )
        ],
      );
    }

    return Row(
      children: [
        Expanded(
            flex: 3,
            child: premiumSearch(
              hint: "Search sessions...",
              onChanged: (val) => c.searchQuery.value = val,
            )),
        const SizedBox(width: 12),
        _filterButton(),
        const SizedBox(width: 8),
        _sortButton(c),
      ],
    );
  }

  Widget _actionButton(IconData icon, String label) {
    return Container(
      height: 44,
      padding: const EdgeInsets.symmetric(horizontal: 12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey.shade300),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 18),
          const SizedBox(width: 6),
          Text(
            label,
            style: const TextStyle(fontSize: 13),
          ),
        ],
      ),
    );
  }

  Widget _sortButton(SessionController c) {
    return GestureDetector(
      onTap: () => showSortSheet(
          title: "Sort Sessions",
          options: _sortOptions,
          selectedValue: c.sortType.value,
          onSelected: (val) {
            c.sortType.value = val;
          }),
      child: _actionButton(Icons.swap_vert, "Sort"),
    );
  }

  Widget _filterButton() {
    return Container(
      height: 44,
      padding: const EdgeInsets.symmetric(horizontal: 12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey.shade300),
      ),
      child: InkWell(
        onTap: () {
          // TODO: open filter bottom sheet
        },
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

  // Widget _sessionCard(Session s) {
  //   final color = getStatusColor(s.status);

  //   return Container(
  //     padding: const EdgeInsets.fromLTRB(14, 14, 14, 0),
  //     margin: const EdgeInsets.only(bottom: 20),
  //     decoration: BoxDecoration(
  //       color: Colors.white,
  //       borderRadius: BorderRadius.circular(16),
  //       border: Border.all(color: Colors.grey.shade200),
  //     ),
  //     child: Column(
  //       crossAxisAlignment: CrossAxisAlignment.start,
  //       children: [
  //         // 🔥 TOP ROW
  //         Row(
  //           mainAxisAlignment: MainAxisAlignment.spaceBetween,
  //           children: [
  //             Text(
  //               "ID: ${s.id}",
  //               style: const TextStyle(
  //                 fontSize: 12,
  //                 color: Colors.grey,
  //               ),
  //             ),
  //             Container(
  //               padding:
  //                   const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
  //               decoration: BoxDecoration(
  //                 color: color.withOpacity(0.1),
  //                 borderRadius: BorderRadius.circular(20),
  //               ),
  //               child: Text(
  //                 s.status.replaceAll("_", " "),
  //                 style: TextStyle(
  //                   fontSize: 11,
  //                   fontWeight: FontWeight.w600,
  //                   color: color,
  //                 ),
  //               ),
  //             )
  //           ],
  //         ),

  //         const SizedBox(height: 10),

  //         // 🔥 STUDENT + TEACHER (tight layout)
  //         Row(
  //           children: [
  //             Expanded(
  //               child: _personCompact(
  //                 "Student",
  //                 s.studentName,
  //                 s.studentId,
  //               ),
  //             ),
  //             const SizedBox(width: 10),
  //             Expanded(
  //               child: _personCompact(
  //                 "Teacher",
  //                 s.teacherName,
  //                 s.teacherId,
  //               ),
  //             ),
  //           ],
  //         ),

  //         const SizedBox(height: 10),

  //         // 🔥 SUBJECT + CLASS + TIME (merged)
  //         Container(
  //           padding: const EdgeInsets.all(10),
  //           decoration: BoxDecoration(
  //             color: Colors.grey.shade50,
  //             borderRadius: BorderRadius.circular(12),
  //           ),
  //           child: Column(
  //             children: [
  //               Row(
  //                 children: [
  //                   Expanded(
  //                     child: _miniInfo("Subject", s.subject),
  //                   ),
  //                   Expanded(
  //                     child: _miniInfo("Class", s.className),
  //                   ),
  //                 ],
  //               ),
  //               const SizedBox(height: 6),
  //               Row(
  //                 children: [
  //                   Expanded(
  //                     child: _miniInfo(
  //                       "Date",
  //                       "${s.dateTime.day}/${s.dateTime.month}/${s.dateTime.year}",
  //                     ),
  //                   ),
  //                   Expanded(
  //                     child: _miniInfo(
  //                       "Time",
  //                       _formatTime(s.dateTime),
  //                     ),
  //                   ),
  //                 ],
  //               ),
  //             ],
  //           ),
  //         ),

  //         const SizedBox(height: 4),

  //         // 🔥 ACTIONS
  //         Row(
  //           mainAxisAlignment: MainAxisAlignment.end,
  //           children: [
  //             iconBtn(icon: Icons.edit, color: Colors.blue, onTap: () {}),
  //             const SizedBox(width: 6),
  //             iconBtn(icon: Icons.delete, color: Colors.red, onTap: () {}),
  //           ],
  //         )
  //       ],
  //     ),
  //   );
  // }

  String _formatTime(DateTime dt) {
    final hour = dt.hour > 12 ? dt.hour - 12 : dt.hour;
    final ampm = dt.hour >= 12 ? "PM" : "AM";
    return "$hour:${dt.minute.toString().padLeft(2, '0')} $ampm";
  }

  Widget _miniInfo(String label, String value) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(fontSize: 10, color: Colors.grey),
        ),
        const SizedBox(height: 2),
        Text(
          value,
          style: const TextStyle(
            fontSize: 12,
            fontWeight: FontWeight.w500,
          ),
        ),
      ],
    );
  }

  Widget _personCompact(String label, String name, String id) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label.toUpperCase(),
          style: const TextStyle(fontSize: 10, color: Colors.grey),
        ),
        const SizedBox(height: 2),
        Text(
          name,
          style: const TextStyle(
            fontSize: 13,
            fontWeight: FontWeight.w600,
          ),
          overflow: TextOverflow.ellipsis,
        ),
        Text(
          id,
          style: const TextStyle(fontSize: 11, color: Colors.blueGrey),
        ),
      ],
    );
  }

  Color getStatusColor(String status) {
    switch (status) {
      case "started":
        return Colors.green;
      case "no_balance":
        return Colors.red;
      case "upcoming":
        return Colors.blue;
      case "pending":
        return Colors.orange;
      case "completed":
        return Colors.grey;
      case "meet_done":
        return Colors.purple;
      default:
        return Colors.black;
    }
  }
}

final List<SortOption> _sortOptions = [
  SortOption(
      label: "Latest First", value: SortType.newest, icon: Icons.schedule),
  SortOption(
      label: "Oldest First", value: SortType.oldest, icon: Icons.history),
  SortOption(
      label: "Student Name", value: SortType.student, icon: Icons.person),
  SortOption(
      label: "Teacher Name", value: SortType.teacher, icon: Icons.school),
];
