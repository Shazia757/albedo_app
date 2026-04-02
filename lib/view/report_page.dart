// PREMIUM + RESPONSIVE REPORTS PAGE (IMPROVED UI)
import 'dart:developer';

import 'package:albedo_app/controller/report_controller.dart';
import 'package:albedo_app/view/student_details_page.dart';
import 'package:albedo_app/view/student_report_page.dart';
import 'package:albedo_app/view/teacher_report_page.dart';
import 'package:albedo_app/widgets/custom_appbar.dart';
import 'package:albedo_app/widgets/drawer_menu.dart';
import 'package:albedo_app/widgets/responsive.dart';
import 'package:albedo_app/widgets/search_bar.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ReportsPage extends StatelessWidget {
  ReportsPage({super.key});

  final ReportsController c = Get.put(ReportsController());

  final tabs = const [
    "Packages",
    "Students",
    "Teachers",
    "Advisors",
    "Recommendations",
    "Star of the Month"
  ];

  @override
  Widget build(BuildContext context) {
    final isDesktop = Responsive.isDesktop(context);

    return Scaffold(
      backgroundColor: const Color(0xFFF6F8FC),
      appBar: Responsive.isMobile(context) ? const CustomAppBar() : null,
      drawer: isDesktop ? null : const DrawerMenu(),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _tabs(),
            const SizedBox(height: 16),
            _filters(),
            const SizedBox(height: 16),
            Expanded(child: Obx(() => _tabView())),
          ],
        ),
      ),
    );
  }

  // PREMIUM TABS
  Widget _tabs() {
    return Obx(() => SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: Row(
            children: List.generate(tabs.length, (index) {
              final isSelected = c.selectedTab.value == index;
              return AnimatedContainer(
                duration: const Duration(milliseconds: 250),
                margin: const EdgeInsets.only(right: 10),
                padding:
                    const EdgeInsets.symmetric(horizontal: 18, vertical: 10),
                decoration: BoxDecoration(
                  gradient: isSelected
                      ? const LinearGradient(
                          colors: [Color(0xFF6C5CE7), Color(0xFF8E7CFF)])
                      : null,
                  color: isSelected ? null : Colors.white,
                  borderRadius: BorderRadius.circular(30),
                  boxShadow: [
                    BoxShadow(
                        color: Colors.black.withOpacity(0.05), blurRadius: 8)
                  ],
                ),
                child: GestureDetector(
                  onTap: () => c.selectedTab.value = index,
                  child: Text(
                    tabs[index],
                    style: TextStyle(
                      fontWeight: FontWeight.w500,
                      color: isSelected ? Colors.white : Colors.grey.shade700,
                    ),
                  ),
                ),
              );
            }),
          ),
        ));
  }

  // FILTER BAR
  Widget _filters() {
    return Row(
      children: [
        Expanded(
          child: premiumSearch(
              hint: 'Search reports...',
              onChanged: (val) => c.searchQuery.value = val),
        ),
        const SizedBox(width: 12),
        Obx(() => PopupMenuButton(
              padding: EdgeInsets.zero,
              offset: const Offset(0, 45),
              color: Colors.transparent,
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
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(14),
                  boxShadow: [
                    BoxShadow(
                        color: Colors.black.withOpacity(0.06), blurRadius: 10)
                  ],
                ),
                child: Row(
                  children: [
                    Text(c.selectedRange.value,
                        style: const TextStyle(fontWeight: FontWeight.w500)),
                    const SizedBox(width: 6),
                    const Icon(Icons.keyboard_arrow_down_rounded, size: 20)
                  ],
                ),
              ),
            ))
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
        color: Theme.of(context).cardColor,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            blurRadius: 20,
            color: Colors.black.withOpacity(0.1),
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
          color: isSelected ? const Color(0xFF6C5CE7).withOpacity(0.08) : null,
          borderRadius: BorderRadius.circular(12),
        ),
        child: Text(
          text,
          style: TextStyle(
            fontWeight: FontWeight.w500,
            color: isSelected ? const Color(0xFF6C5CE7) : Colors.black,
          ),
        ),
      ),
    );
  }

  Widget _dateField({
    required String label,
    required DateTime? value,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 14),
        decoration: BoxDecoration(
          border: Border.all(color: Colors.grey.shade300),
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
                color: value == null ? Colors.grey : Colors.black,
              ),
            ),
            const Icon(Icons.calendar_today, size: 18),
          ],
        ),
      ),
    );
  }

  Widget _tabView() {
    return IndexedStack(
      index: c.selectedTab.value,
      children: [
        _packagesTable(),
        studentsTab(),
        teachersTab(),
        _placeholder("Advisors"),
        _placeholder("Recommendations"),
        _placeholder("Star of the Month"),
      ],
    );
  }

  Widget _placeholder(String title) {
    return Center(
      child: Text(
        "$title - Coming Soon",
        style: TextStyle(
          fontSize: 16,
          color: Colors.grey.shade600,
          fontWeight: FontWeight.w500,
        ),
      ),
    );
  }

  // PREMIUM TABLE
  Widget _packagesTable() {
    return Obx(() {
      final data = c.filteredPackages;

      return Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(18),
          boxShadow: [
            BoxShadow(color: Colors.black.withOpacity(0.06), blurRadius: 14)
          ],
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(12),
          child: SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: DataTable(
              columnSpacing: 28,
              headingRowHeight: 50,
              dataRowHeight: 68,
              headingRowColor:
                  MaterialStateProperty.all(const Color(0xFFF4F6FB)),
              columns: const [
                DataColumn(label: Text("Student Info")),
                DataColumn(label: Text("Contact")),
                DataColumn(label: Text("WhatsApp")),
                DataColumn(label: Text("Hours")),
                DataColumn(label: Text("Classes")),
                DataColumn(label: Text("Amount")),
                DataColumn(label: Text("Total")),
                DataColumn(label: Text("Paid")),
                DataColumn(label: Text("Balance")),
              ],
              rows: data.map((e) {
                return DataRow(cells: [
                  DataCell(_studentCell(e)),
                  DataCell(Text(e.contact)),
                  DataCell(Text(e.whatsapp)),
                  DataCell(_badge(e.classHours.toString(), Colors.blue)),
                  DataCell(
                      _badge(e.classesTaken.toString(), Colors.deepPurple)),
                  DataCell(Text("₹${e.amount}")),
                  DataCell(Text("₹${e.totalAmount}")),
                  DataCell(Text("₹${e.totalPaid}")),
                  DataCell(Text(
                    "₹${e.balance}",
                    style: TextStyle(
                        fontWeight: FontWeight.w600,
                        color: e.balance > 0 ? Colors.red : Colors.green),
                  )),
                ]);
              }).toList(),
            ),
          ),
        ),
      );
    });
  }

  Widget _studentCell(e) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(e.studentName,
            style: const TextStyle(fontWeight: FontWeight.w600)),
        const SizedBox(height: 4),
        Text(e.studentId,
            style: TextStyle(color: Colors.grey.shade600, fontSize: 12)),
      ],
    );
  }

  Widget _badge(String text, Color color) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Text(text, style: TextStyle(color: color)),
    );
  }
}
