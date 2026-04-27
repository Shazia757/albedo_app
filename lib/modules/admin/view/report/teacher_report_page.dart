import 'package:albedo_app/controller/report_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

Widget teachersTab(BuildContext context) {
  final ReportsController c = Get.put(ReportsController());

  final data = c.filteredTeachers;

  return Container(
    padding: const EdgeInsets.all(12),
    decoration: BoxDecoration(
      color: Theme.of(context).colorScheme.onPrimary,
      borderRadius: BorderRadius.circular(18),
      boxShadow: [
        BoxShadow(
            color: Theme.of(context).colorScheme.shadow.withOpacity(0.08),
            blurRadius: 14)
      ],
    ),
    child: ClipRRect(
      borderRadius: BorderRadius.circular(12),
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: DataTable(
          showCheckboxColumn: false,
          columnSpacing: 26,
          headingRowHeight: 50,
          dataRowHeight: 68,
          headingRowColor: MaterialStateProperty.all(const Color(0xFFF4F6FB)),
          columns: const [
            DataColumn(label: Text("Teacher")),
            DataColumn(label: Text("Contact")),
            DataColumn(label: Text("Total class taken hours")),
            DataColumn(label: Text("Teacher Salary")),
            DataColumn(label: Text("Paid")),
            DataColumn(label: Text("Total Balance")),
          ],
          rows: data.map((s) {
            return DataRow(
              cells: [
                DataCell(Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(s.name,
                        style: const TextStyle(fontWeight: FontWeight.w600)),
                    Text(s.id ?? '',
                        style: TextStyle(
                            color: Theme.of(context)
                                .colorScheme
                                .onSurface
                                .withOpacity(0.6),
                            fontSize: 12)),
                  ],
                )),
                DataCell(Text(s.phone ?? '')),
                DataCell(Text(s.totalHours.toString())),
                DataCell(Text(s.salary?.toString() ?? '')),
                DataCell(Text('paid salary')),
                DataCell(Text(s.balance?.toString() ?? '')),
              ],
            );
          }).toList(),
        ),
      ),
    ),
  );
}
