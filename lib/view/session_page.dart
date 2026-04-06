import 'package:albedo_app/controller/session_controller.dart';
import 'package:albedo_app/model/session_model.dart';
import 'package:albedo_app/view/forgot_password_page.dart';
import 'package:albedo_app/widgets/widgets.dart';
import 'package:albedo_app/widgets/custom_appbar.dart';
import 'package:albedo_app/widgets/custom_card.dart';
import 'package:albedo_app/widgets/drawer_menu.dart';
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
      backgroundColor: Theme.of(context).colorScheme.onPrimary,
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
                    () => CustomWidgets(). customTabs(context,
                        tabs: c.tabs,
                        selectedIndex: c.selectedTab.value, getCount: (index) {
                      if (index == 0) return c.sessions.length;
                      return c.sessions
                          .where((e) => e.status == c.statusMap[index])
                          .length;
                    }, onTap: (index) {
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
                          statusColor: getStatusColor(context, data[i].status),
                          infoRows: [
                            Row(
                              children: [
                                Expanded(
                                    child: _personCompact(
                                        context,
                                        "Student",
                                        data[i].studentName,
                                        data[i].studentId)),
                                const SizedBox(width: 10),
                                Expanded(
                                    child: _personCompact(
                                        context,
                                        "Teacher",
                                        data[i].teacherName,
                                        data[i].teacherId)),
                              ],
                            ),
                            Container(
                              padding: const EdgeInsets.all(10),
                              decoration: BoxDecoration(
                                color: Theme.of(context)
                                    .colorScheme
                                    .outlineVariant
                                    .withOpacity(0.03),
                                borderRadius: BorderRadius.circular(12),
                              ),
                              child: Column(
                                children: [
                                  Row(
                                    children: [
                                      Expanded(
                                          child: _miniInfo(context, "Subject",
                                              data[i].subject)),
                                      Expanded(
                                          child: _miniInfo(context, "Class",
                                              data[i].className)),
                                    ],
                                  ),
                                  const SizedBox(height: 6),
                                  Row(
                                    children: [
                                      Expanded(
                                          child: _miniInfo(context, "Date",
                                              "${data[i].dateTime.day}/${data[i].dateTime.month}/${data[i].dateTime.year}")),
                                      Expanded(
                                          child: _miniInfo(context, "Time",
                                              _formatTime(data[i].dateTime))),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                          ],
                          actions: [
                            CustomWidgets(). iconBtn(
                                icon: Icons.edit,
                                color: Theme.of(context).colorScheme.primary,
                                onTap: () {}),
                            CustomWidgets(). iconBtn(
                                icon: Icons.delete,
                                color: Theme.of(context).colorScheme.onTertiary,
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
          CustomWidgets(). premiumSearch(
            context,
            hint: "Search sessions...",
            onChanged: (val) => c.searchQuery.value = val,
          ),
          const SizedBox(height: 10),
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

    return Row(
      children: [
        Expanded(
            flex: 3,
            child: CustomWidgets(). premiumSearch(
              context,
              hint: "Search sessions...",
              onChanged: (val) => c.searchQuery.value = val,
            )),
        const SizedBox(width: 12),
        _filterButton(context),
        const SizedBox(width: 8),
        _sortButton(context, c),
      ],
    );
  }

  Widget _actionButton(BuildContext context, IconData icon, String label) {
    return Container(
      height: 44,
      padding: const EdgeInsets.symmetric(horizontal: 12),
      decoration: BoxDecoration(
        color: context.theme.colorScheme.onPrimary,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
            color: context.theme.colorScheme.outline.withOpacity(0.5)),
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

  Widget _sortButton(BuildContext context, SessionController c) {
    return GestureDetector(
      onTap: () => CustomWidgets(). showSortSheet(
          title: "Sort Sessions",
          options: _sortOptions,
          selectedValue: c.sortType.value,
          onSelected: (val) {
            c.sortType.value = val;
          }),
      child: _actionButton(context, Icons.swap_vert, "Sort"),
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

  String _formatTime(DateTime dt) {
    final hour = dt.hour > 12 ? dt.hour - 12 : dt.hour;
    final ampm = dt.hour >= 12 ? "PM" : "AM";
    return "$hour:${dt.minute.toString().padLeft(2, '0')} $ampm";
  }

  Widget _miniInfo(BuildContext context, String label, String value) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: TextStyle(
              fontSize: 10, color: Theme.of(context).colorScheme.outline),
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

  Widget _personCompact(
      BuildContext context, String label, String name, String id) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label.toUpperCase(),
          style: TextStyle(
              fontSize: 10, color: Theme.of(context).colorScheme.outline),
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
          style: TextStyle(
              fontSize: 11, color: Theme.of(context).colorScheme.outline),
        ),
      ],
    );
  }

  Color getStatusColor(BuildContext context, String status) {
    switch (status) {
      case "started":
        return Theme.of(context).colorScheme.onInverseSurface;
      case "no_balance":
        return Theme.of(context).colorScheme.onTertiary;
      case "upcoming":
        return Theme.of(context).colorScheme.primary;
      case "pending":
        return Theme.of(context).colorScheme.tertiary;
      case "completed":
        return Theme.of(context).colorScheme.outline;
      case "meet_done":
        return Theme.of(context).colorScheme.secondary;
      default:
        return Theme.of(context).colorScheme.shadow;
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
