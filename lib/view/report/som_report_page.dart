import 'package:albedo_app/controller/report_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

Widget starOfMonthTab(BuildContext context) {
  final ReportsController c = Get.put(ReportsController());

  final data = c.filteredMentors;

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
            DataColumn(label: Text("Mentor")),
            DataColumn(label: Text("M1")),
            DataColumn(label: Text("M2")),
            DataColumn(label: Text("M3")),
            DataColumn(label: Text("M4")),
            DataColumn(label: Text("M5")),
            DataColumn(label: Text("Composite Score")),
            DataColumn(label: Text("Rank")),
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

                ///TODO : Mentor Values to be understood
              ],
            );
          }).toList(),
        ),
      ),
    ),
  );
}
