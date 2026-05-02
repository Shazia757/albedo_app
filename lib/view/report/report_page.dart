// PREMIUM + RESPONSIVE REPORTS PAGE (IMPROVED UI)
import 'package:albedo_app/controller/auth_controller.dart';
import 'package:albedo_app/controller/permissions_controller.dart';
import 'package:albedo_app/controller/report_controller.dart';
import 'package:albedo_app/view/report/advisor_report_page.dart';
import 'package:albedo_app/view/report/hiring_report.dart';
import 'package:albedo_app/view/report/recommendation_report.dart';
import 'package:albedo_app/view/report/som_report_page.dart';
import 'package:albedo_app/view/report/student_report_page.dart';
import 'package:albedo_app/view/report/teacher_report_page.dart';

import 'package:albedo_app/widgets/header_with_search.dart';
import 'package:albedo_app/widgets/custom_appbar.dart';
import 'package:albedo_app/widgets/drawer_menu.dart';
import 'package:albedo_app/widgets/responsive.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ReportsPage extends StatelessWidget {
  ReportsPage({super.key});

  final ReportsController c = Get.put(ReportsController());

  List<String> get tabs {
    final role = c.auth.activeUser?.role;

    if (role == "admin") {
      return [
        "Students",
        "Teachers",
        "Advisors",
        "Recommendations",
        "Hirings",
        "Star of Month"
      ];
    }

    if ((role == "coordinator") || (role == "mentor")) {
      return [
        "Students",
        "Teachers",
        "Recommendations",
        "Hirings",
      ];
    }

    if (role == "teacher") {
      return [
        "Students",
        "Hirings",
      ];
    }
    if (role == "teacher") {
      return [
        "Students",
        "Hirings",
      ];
    }
    if (role == "finance") {
      return ["Students", "Teachers"];
    }
    if (role == "sales") {
      return ["Students", "Advisors"];
    }
    if (role == "hr") {
      return ["Teachers", "Hirings", "Star of Month"];
    }
    if (role == "advisor") {
      return [
        "Students",
      ];
    }
    if (c.isCustom) {
      return c.tabPermissions.entries
          .where((e) => PermissionService.can(e.value))
          .map((e) => e.key)
          .toList();
    }

    return [];
  }

  @override
  Widget build(BuildContext context) {
    final isDesktop = Responsive.isDesktop(context);

    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.surface,
      appBar: const CustomAppBar(),
      drawer: isDesktop ? null : const DrawerMenu(),
      body: Row(
        children: [
          if (isDesktop) const DrawerMenu(),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _filters(context),
                  const SizedBox(height: 16),
                  _tabs(context),
                  const SizedBox(height: 16),
                  Expanded(child: Obx(() => _tabView(context))),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  // PREMIUM TABS
  Widget _tabs(BuildContext context) {
    return Obx(() {
      final tabsList = tabs;

      if (tabsList.isNotEmpty && !tabsList.contains(c.selectedTab.value)) {
        c.selectedTab.value = tabsList.first;
      }
      return SingleChildScrollView(
        scrollDirection: Axis.vertical,
        child: SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: Row(
            children: List.generate(tabs.length, (index) {
              final tab = tabs[index];
              final isSelected = c.selectedTab.value == tab;
              return AnimatedContainer(
                duration: const Duration(milliseconds: 250),
                margin: const EdgeInsets.only(right: 10),
                padding:
                    const EdgeInsets.symmetric(horizontal: 18, vertical: 10),
                decoration: BoxDecoration(
                  gradient: isSelected
                      ? LinearGradient(colors: [
                          Theme.of(context).colorScheme.primary,
                          Theme.of(context).colorScheme.secondary,
                        ])
                      : null,
                  color: isSelected
                      ? null
                      : Theme.of(context).colorScheme.onPrimary,
                  borderRadius: BorderRadius.circular(30),
                  boxShadow: [
                    BoxShadow(
                      color: Theme.of(context)
                          .colorScheme
                          .shadow
                          .withOpacity(0.08),
                      blurRadius: 5,
                    )
                  ],
                ),
                child: GestureDetector(
                  onTap: () => c.selectedTab.value = tabs[index],
                  child: Text(
                    tabs[index],
                    style: TextStyle(
                      fontWeight: FontWeight.w500,
                      color: isSelected
                          ? Theme.of(context).colorScheme.onPrimary
                          : Theme.of(context)
                              .colorScheme
                              .onSurface
                              .withOpacity(0.6),
                    ),
                  ),
                ),
              );
            }),
          ),
        ),
      );
    });
  }

  // FILTER BAR
  Widget _filters(BuildContext context) {
    return HeaderWithSearch(
      title: "Reports",
      hint: "Search reports...",
      isSearching: c.isSearching,
      searchQuery: c.searchQuery,
      onSearchChanged: () {},
      actions: [
        Obx(() => PopupMenuButton(
              padding: EdgeInsets.zero,
              offset: const Offset(0, 45),
              color: Theme.of(context).colorScheme.surface,
              elevation: 0,
              itemBuilder: (context) => [
                PopupMenuItem(
                  enabled: false,
                  padding: EdgeInsets.zero,
                  child: _rangeMenu(context),
                ),
              ],
              child: Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
                decoration: BoxDecoration(
                  color: Theme.of(context).colorScheme.onPrimary,
                  borderRadius: BorderRadius.circular(14),
                  boxShadow: [
                    BoxShadow(
                      color: Theme.of(context)
                          .colorScheme
                          .shadow
                          .withOpacity(0.08),
                      blurRadius: 10,
                    )
                  ],
                ),
                child: Row(
                  children: [
                    Text(
                      c.selectedRange.value,
                      style: const TextStyle(fontWeight: FontWeight.w500),
                    ),
                    const SizedBox(width: 6),
                    const Icon(Icons.keyboard_arrow_down_rounded, size: 20),
                  ],
                ),
              ),
            )),
      ],
    );
  }

  Widget _rangeMenu(BuildContext context) {
    final ranges = [
      "All",
      "This Quarter",
      "This Month",
      "Last Month",
      "This Year",
      "Last Year",
      "Custom Range"
    ];

    return Container(
      width: 220,
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surface,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            blurRadius: 20,
            color: Theme.of(context).colorScheme.shadow.withOpacity(0.1),
          )
        ],
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: ranges.map((e) => _rangeItem(context, e)).toList(),
      ),
    );
  }

  Widget _rangeItem(BuildContext context, String text) {
    final isSelected = c.selectedRange.value == text ||
        (text == "Custom Range" && c.selectedRange.value.contains("-"));

    return InkWell(
      onTap: () async {
        if (text == "Custom Range") {
          DateTime? startDate;
          DateTime? endDate;

          final picked = await showDialog<DateTimeRange>(
            context: context,
            builder: (context) {
              return StatefulBuilder(
                builder: (context, setState) {
                  return AlertDialog(
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(16)),
                    title: const Text("Select Date Range"),
                    content: SizedBox(
                      width: 340,
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          // START DATE
                          _dateField(
                            context,
                            label: "Start Date",
                            value: startDate,
                            onTap: () async {
                              final picked = await showDatePicker(
                                context: context,
                                initialDate: DateTime.now(),
                                firstDate: DateTime(2020),
                                lastDate: DateTime.now(),
                              );
                              if (picked != null) {
                                setState(() => startDate = picked);
                              }
                            },
                          ),
                          const SizedBox(height: 12),

                          // END DATE
                          _dateField(
                            context,
                            label: "End Date",
                            value: endDate,
                            onTap: () async {
                              final picked = await showDatePicker(
                                context: context,
                                initialDate: startDate ?? DateTime.now(),
                                firstDate: startDate ?? DateTime(2020),
                                lastDate: DateTime.now(),
                              );
                              if (picked != null) {
                                setState(() => endDate = picked);
                              }
                            },
                          ),
                        ],
                      ),
                    ),
                    actions: [
                      TextButton(
                        onPressed: () => Navigator.pop(context),
                        child: const Text("Cancel"),
                      ),
                      ElevatedButton(
                        onPressed: (startDate != null && endDate != null)
                            ? () => Navigator.pop(
                                  context,
                                  DateTimeRange(
                                      start: startDate!, end: endDate!),
                                )
                            : null,
                        child: const Text("Apply"),
                      ),
                    ],
                  );
                },
              );
            },
          );

          if (picked != null) {
            final start =
                "${picked.start.day}/${picked.start.month}/${picked.start.year}";
            final end =
                "${picked.end.day}/${picked.end.month}/${picked.end.year}";
            c.selectedRange.value = "$start - $end";
          }
        } else {
          c.selectedRange.value = text;
        }

        Navigator.pop(context);
      },
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
        decoration: BoxDecoration(
          color: isSelected
              ? Theme.of(context).colorScheme.secondary.withOpacity(0.1)
              : null,
          borderRadius: BorderRadius.circular(12),
        ),
        child: Text(
          text,
          style: TextStyle(
            fontWeight: FontWeight.w500,
            color: isSelected
                ? Theme.of(context).colorScheme.secondary
                : Theme.of(context).colorScheme.onSurface,
          ),
        ),
      ),
    );
  }

  Widget _dateField(
    BuildContext context, {
    required String label,
    required DateTime? value,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 14),
        decoration: BoxDecoration(
          border: Border.all(color: Theme.of(context).colorScheme.outline),
          borderRadius: BorderRadius.circular(12),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              value == null
                  ? label
                  : "${value.day}/${value.month}/${value.year}",
              style: TextStyle(
                color: value == null
                    ? Theme.of(context).colorScheme.onSurface.withOpacity(0.5)
                    : Theme.of(context).colorScheme.onSurface,
              ),
            ),
            const Icon(Icons.calendar_today, size: 18),
          ],
        ),
      ),
    );
  }

  Widget _tabView(BuildContext context) {
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

    switch (c.selectedTab.value) {
      case "Students":
        if (!isCustom || PermissionService.can("student_reports")) {
          return studentsTab(context);
        }
        break;

      case "Teachers":
        if (!isCustom || PermissionService.can("teacher_reports")) {
          return teachersTab(context);
        }
        break;

      case "Advisors":
        if (!isCustom || PermissionService.can("advisor_reports")) {
          return advisorsTab(context);
        }
        break;

      case "Recommendations":
        if (!isCustom || PermissionService.can("recommendation_reports")) {
          return recommendationsTab(context);
        }
        break;

      case "Hirings":
        if (!isCustom || PermissionService.can("hiring_reports")) {
          return hiringsTab(context);
        }
        break;

      case "Star of Month":
        if (!isCustom || PermissionService.can("star_month_reports")) {
          return starOfMonthTab(context);
        }
        break;
    }

    return _placeholder(context, "No Permission");
  }

  Widget _placeholder(BuildContext context, String title) {
    return Center(
      child: Text(
        title,
        style: TextStyle(
          fontSize: 16,
          color: Theme.of(context).colorScheme.onSurface.withOpacity(0.6),
          fontWeight: FontWeight.w500,
        ),
      ),
    );
  }
}
