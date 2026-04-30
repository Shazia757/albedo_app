import 'package:albedo_app/controller/report_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

Widget hiringsTab(BuildContext context) {
  final ReportsController c = Get.put(ReportsController());

  final data = c.filteredHiring;

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
            DataColumn(label: Text("Hiring Package")),
            DataColumn(label: Text("Date created")),
            DataColumn(label: Text("Status")),
          ],
          rows: data.map((s) {
            return DataRow(
              cells: [
                DataCell(Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(s.teacher.name,
                        style: const TextStyle(fontWeight: FontWeight.w600)),
                    Text(s.teacher.id ?? '',
                        style: TextStyle(
                            color: Theme.of(context)
                                .colorScheme
                                .onSurface
                                .withOpacity(0.6),
                            fontSize: 12)),
                  ],
                )),
                // Package
                DataCell(Text(s.ad.package ?? '-')),

                // Date Created (use startDate for now)
                DataCell(Text(s.ad.startDate ?? '-')),

                // Status (you can customize)
                DataCell(Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                  decoration: BoxDecoration(
                    color: Colors.green.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: const Text(
                    "Interested",
                    style: TextStyle(color: Colors.green, fontSize: 12),
                  ),
                )),
              ],
            );
          }).toList(),
        ),
      ),
    ),
  );
}
