import 'package:albedo_app/controller/report_controller.dart';
import 'package:albedo_app/view/student_details_page.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

Widget studentsTab(BuildContext context) {

    final ReportsController c = Get.put(ReportsController());

    final data = c.filteredStudents;

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
              DataColumn(label: Text("Student")),
              DataColumn(label: Text("Course")),
              DataColumn(label: Text("Standard")),
              DataColumn(label: Text("Advisor")),
              DataColumn(label: Text("Contact")),
              DataColumn(label: Text("Status")),
            ],
            rows: data.map((s) {
              return DataRow(
                onSelectChanged: (_) {
                  Get.to(() => StudentDetailsPage(student: s));
                },
                cells: [
                  DataCell(Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(s.studentName,
                          style: const TextStyle(fontWeight: FontWeight.w600)),
                      Text(s.studentId,
                          style: TextStyle(
                              color: Theme.of(context)
                                  .colorScheme
                                  .onSurface
                                  .withOpacity(0.6),
                              fontSize: 12)),
                    ],
                  )),
                  DataCell(Text(s.course)),
                  DataCell(Text(s.standard.toString())),
                  DataCell(Text(s.advisor)),
                  DataCell(Text(s.contact)),
                  DataCell(
                    Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 10, vertical: 6),
                      decoration: BoxDecoration(
                        color: s.status == "Active"
                            ? const Color(0xFF22C55E).withOpacity(0.1)
                            : const Color(0xFFEF4444).withOpacity(0.1),
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Container(
                            width: 6,
                            height: 6,
                            decoration: BoxDecoration(
                              color: s.status == "Active"
                                  ? const Color(0xFF22C55E)
                                  : const Color(0xFFEF4444),
                              shape: BoxShape.circle,
                            ),
                          ),
                          const SizedBox(width: 6),
                          Text(
                            s.status,
                            style: TextStyle(
                              fontSize: 12,
                              fontWeight: FontWeight.w500,
                              color: s.status == "Active"
                                  ? const Color(0xFF16A34A)
                                  : const Color(0xFFDC2626),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              );
            }).toList(),
          ),
        ),
      ),
    );
 
}
