import 'package:albedo_app/controller/session_controller.dart';
import 'package:albedo_app/model/session_model.dart';
import 'package:albedo_app/view/forgot_password_page.dart';
import 'package:albedo_app/widgets/custom_appbar.dart';
import 'package:albedo_app/widgets/drawer_menu.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class SessionPage extends StatelessWidget {
  final c = Get.put(SessionController());

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
                  _tabs(c),
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
                        itemBuilder: (_, i) => _sessionCard(data[i]),
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
          _premiumSearch(c),
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
        Expanded(flex: 3, child: _premiumSearch(c)),
        const SizedBox(width: 12),
        _filterButton(),
        const SizedBox(width: 8),
        _sortButton(c),
      ],
    );
  }

  Widget _premiumSearch(SessionController c) {
    return Container(
      height: 44,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 8,
          )
        ],
      ),
      child: TextField(
        onChanged: (val) => c.searchQuery.value = val,
        style: const TextStyle(fontSize: 14),
        decoration: InputDecoration(
          hintText: "Search sessions...",
          prefixIcon: const Icon(Icons.search, size: 20),
          border: InputBorder.none,
          contentPadding: const EdgeInsets.symmetric(vertical: 12),
        ),
      ),
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
      onTap: () => _showSortSheet(c),
      child: _actionButton(Icons.swap_vert, "Sort"),
    );
  }

  void _showSortSheet(SessionController c) {
    Get.bottomSheet(
      Container(
        padding: const EdgeInsets.fromLTRB(16, 10, 16, 20),
        decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
        ),
        child: Obx(() => Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                // 🔥 HANDLE BAR
                Container(
                  width: 40,
                  height: 4,
                  margin: const EdgeInsets.only(bottom: 12),
                  decoration: BoxDecoration(
                    color: Colors.grey.shade300,
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),

                const Text(
                  "Sort Sessions",
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                  ),
                ),

                const SizedBox(height: 16),

                // 🔥 OPTIONS
                ..._sortOptions.map((e) {
                  final isSelected = c.sortType.value == e.type;

                  return GestureDetector(
                    onTap: () {
                      c.sortType.value = e.type;
                      Get.back();
                    },
                    child: Container(
                      margin: const EdgeInsets.only(bottom: 8),
                      padding: const EdgeInsets.symmetric(
                          horizontal: 12, vertical: 12),
                      decoration: BoxDecoration(
                        color: isSelected
                            ? const Color(0xFF7F00FF).withOpacity(0.08)
                            : Colors.transparent,
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(
                          color: isSelected
                              ? const Color(0xFF7F00FF)
                              : Colors.grey.shade200,
                        ),
                      ),
                      child: Row(
                        children: [
                          Icon(
                            e.icon,
                            size: 18,
                            color: isSelected
                                ? const Color(0xFF7F00FF)
                                : Colors.grey,
                          ),
                          const SizedBox(width: 10),
                          Expanded(
                            child: Text(
                              e.label,
                              style: TextStyle(
                                fontSize: 14,
                                fontWeight: isSelected
                                    ? FontWeight.w600
                                    : FontWeight.w400,
                                color: isSelected
                                    ? const Color(0xFF7F00FF)
                                    : Colors.black87,
                              ),
                            ),
                          ),
                          if (isSelected)
                            const Icon(
                              Icons.check_circle,
                              color: Color(0xFF7F00FF),
                              size: 18,
                            )
                        ],
                      ),
                    ),
                  );
                }).toList(),
              ],
            )),
      ),
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

  Widget _tabs(SessionController c) {
    return Obx(() => SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: Row(
            children: List.generate(c.tabs.length, (index) {
              final isActive = c.selectedTab.value == index;

              final count = c.sessions
                  .where((e) => e.status == c.statusMap[index])
                  .length;

              return GestureDetector(
                onTap: () => c.selectedTab.value = index,
                child: Container(
                  margin: const EdgeInsets.only(right: 8),
                  padding:
                      const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
                  decoration: BoxDecoration(
                    color: isActive
                        ? const Color(0xFF7F00FF)
                        : Colors.grey.shade200,
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Text(
                    "${c.tabs[index]} ($count)",
                    style: TextStyle(
                      color: isActive ? Colors.white : Colors.black87,
                      fontSize: 12,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
              );
            }),
          ),
        ));
  }

  Widget _sessionCard(Session s) {
    final color = getStatusColor(s.status);

    return Container(
      padding: const EdgeInsets.fromLTRB(14, 14, 14, 0),
      margin: const EdgeInsets.only(bottom: 20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.grey.shade200),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // 🔥 TOP ROW
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                "ID: ${s.id}",
                style: const TextStyle(
                  fontSize: 12,
                  color: Colors.grey,
                ),
              ),
              Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                decoration: BoxDecoration(
                  color: color.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Text(
                  s.status.replaceAll("_", " "),
                  style: TextStyle(
                    fontSize: 11,
                    fontWeight: FontWeight.w600,
                    color: color,
                  ),
                ),
              )
            ],
          ),

          const SizedBox(height: 10),

          // 🔥 STUDENT + TEACHER (tight layout)
          Row(
            children: [
              Expanded(
                child: _personCompact(
                  "Student",
                  s.studentName,
                  s.studentId,
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: _personCompact(
                  "Teacher",
                  s.teacherName,
                  s.teacherId,
                ),
              ),
            ],
          ),

          const SizedBox(height: 10),

          // 🔥 SUBJECT + CLASS + TIME (merged)
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
                      child: _miniInfo("Subject", s.subject),
                    ),
                    Expanded(
                      child: _miniInfo("Class", s.className),
                    ),
                  ],
                ),
                const SizedBox(height: 6),
                Row(
                  children: [
                    Expanded(
                      child: _miniInfo(
                        "Date",
                        "${s.dateTime.day}/${s.dateTime.month}/${s.dateTime.year}",
                      ),
                    ),
                    Expanded(
                      child: _miniInfo(
                        "Time",
                        _formatTime(s.dateTime),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),

          const SizedBox(height: 4),

          // 🔥 ACTIONS
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              _iconBtn(Icons.edit, Colors.blue, () {}),
              const SizedBox(width: 6),
              _iconBtn(Icons.delete, Colors.red, () {}),
            ],
          )
        ],
      ),
    );
  }

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

  Widget _iconBtn(IconData icon, Color color, VoidCallback onTap) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(10),
        child: Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: color.withOpacity(0.1),
            borderRadius: BorderRadius.circular(10),
          ),
          child: Icon(
            icon,
            size: 18,
            color: color,
          ),
        ),
      ),
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
  SortOption("Latest First", SortType.latest, Icons.schedule),
  SortOption("Oldest First", SortType.oldest, Icons.history),
  SortOption("Student Name", SortType.student, Icons.person),
  SortOption("Teacher Name", SortType.teacher, Icons.school),
];

class SortOption {
  final String label;
  final SortType type;
  final IconData icon;

  SortOption(this.label, this.type, this.icon);
}
