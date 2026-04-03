import 'package:albedo_app/controller/report_controller.dart';
import 'package:albedo_app/model/teacher_model.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

Widget teachersTab() {
  return Obx(() {
    final ReportsController c = Get.put(ReportsController());

    final data = c.filteredTeachers;

    return Column(
      children: [
        _teacherSummary(),
        const SizedBox(height: 16),
        // Expanded(child: _teacherTable(data)),
      ],
    );
  });
}

Widget _teacherSummary() {
  return LayoutBuilder(
    builder: (context, constraints) {
      int crossAxisCount = 5;

      if (constraints.maxWidth < 1200) crossAxisCount = 3;
      if (constraints.maxWidth < 800) crossAxisCount = 2;

      return GridView.count(
        crossAxisCount: crossAxisCount,
        shrinkWrap: true,
        crossAxisSpacing: 12,
        mainAxisSpacing: 12,
        childAspectRatio: 2.6, // 🔥 controls height
        physics: const NeverScrollableScrollPhysics(),
        children: [
          _summaryCard(context, "Total Teachers", "12"),
          _summaryCard(context, "Total Students", "120"),
          _summaryCard(context, "Total Salary", "₹1,20,000"),
          _summaryCard(context, "Paid", "₹80,000"),
          _summaryCard(context, "Balance", "₹40,000"),
        ],
      );
    },
  );
}

Widget _summaryCard(BuildContext context, String title, String value) {
  return Container(
    padding:
        const EdgeInsets.symmetric(horizontal: 12, vertical: 10), // reduced
    decoration: BoxDecoration(
      color: Theme.of(context).colorScheme.onPrimary,
      borderRadius: BorderRadius.circular(14),
      boxShadow: [
        BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 10)
      ],
    ),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(title, style: const TextStyle(fontSize: 11, color: Colors.grey)),
        const SizedBox(height: 4),
        Text(value,
            style: const TextStyle(fontSize: 15, fontWeight: FontWeight.w600)),
      ],
    ),
  );
}
