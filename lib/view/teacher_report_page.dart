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
          _summaryCard("Total Teachers", "12"),
          _summaryCard("Total Students", "120"),
          _summaryCard("Total Salary", "₹1,20,000"),
          _summaryCard("Paid", "₹80,000"),
          _summaryCard("Balance", "₹40,000"),
        ],
      );
    },
  );
}

Widget _summaryCard(String title, String value) {
  return Container(
    padding:
        const EdgeInsets.symmetric(horizontal: 12, vertical: 10), // reduced
    decoration: BoxDecoration(
      color: Colors.white,
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

Widget _teacherTable(List<TeacherModel> data) {
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
          showCheckboxColumn: false,
          columnSpacing: 20,
          headingRowHeight: 44,
          dataRowHeight: 56,
          headingRowColor: MaterialStateProperty.all(const Color(0xFFF4F6FB)),
          columns: const [
            DataColumn(label: Text("Teacher")),
            DataColumn(label: Text("Students")),
            DataColumn(label: Text("Packages")),
            DataColumn(label: Text("Hours")),
            DataColumn(label: Text("Sessions")),
            DataColumn(label: Text("Salary")),
            DataColumn(label: Text("Paid")),
            DataColumn(label: Text("Balance")),
          ],
          rows: data.map<DataRow>((t) {
            return DataRow(
              cells: [
                DataCell(Text(t.name)),
                DataCell(Text(t.totalStudents.toString())),
                DataCell(Text(t.totalPackages.toString())),
                DataCell(Text(t.totalHours.toString())),
                DataCell(Text(t.totalSessions.toString())),
                DataCell(Text("₹${t.salary}")),
                DataCell(Text("₹${t.paid}")),
                DataCell(_balanceCell(t.balance!)),
              ],
            );
          }).toList(),
        ),
      ),
    ),
  );
}

Widget _balanceCell(double balance) {
  final isPositive = balance > 0;

  return Container(
    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
    decoration: BoxDecoration(
      color: isPositive
          ? const Color(0xFFEF4444).withOpacity(0.1)
          : const Color(0xFF22C55E).withOpacity(0.1),
      borderRadius: BorderRadius.circular(20),
    ),
    child: Text(
      "₹$balance",
      style: TextStyle(
        fontSize: 12,
        fontWeight: FontWeight.w500,
        color: isPositive ? const Color(0xFFDC2626) : const Color(0xFF16A34A),
      ),
    ),
  );
}
