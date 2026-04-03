import 'package:albedo_app/model/report_model.dart';
import 'package:albedo_app/model/student_model.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class StudentDetailsPage extends StatelessWidget {
  final PackageReportModel student; // replace with your model

  const StudentDetailsPage({super.key, required this.student});

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 3,
      child: Scaffold(
        backgroundColor: const Color(0xFFF6F8FC),
        appBar: AppBar(
          title: const Text("Student Details"),
        ),
        body: Column(
          children: [
            _header(context),
            _tabs(),
            Expanded(
              child: TabBarView(
                children: [
                  _generalInfo(),
                  _placeholder("Insights"),
                  _placeholder("Refund Insights"),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }

  // HEADER
  Widget _header(BuildContext context) {
    return Container(
      margin: const EdgeInsets.all(16),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.onPrimary,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(blurRadius: 10, color: Colors.black.withOpacity(0.05))
        ],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(student.studentName,
                  style: const TextStyle(
                      fontSize: 18, fontWeight: FontWeight.bold)),
              const SizedBox(height: 4),
              Text("ID: ${student.studentId}",
                  style: const TextStyle(color: Colors.grey)),
            ],
          ),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
            decoration: BoxDecoration(
              color: student.status == "Active"
                  ? Colors.green.withOpacity(0.1)
                  : Colors.red.withOpacity(0.1),
              borderRadius: BorderRadius.circular(20),
            ),
            child: Text(
              student.status ?? '',
              style: TextStyle(
                  color:
                      student.status == "Active" ? Colors.green : Colors.red),
            ),
          )
        ],
      ),
    );
  }

  // TABS
  Widget _tabs() {
    return const TabBar(
      labelColor: Color(0xFF6C5CE7),
      unselectedLabelColor: Colors.grey,
      indicatorColor: Color(0xFF6C5CE7),
      tabs: [
        Tab(text: "General Info"),
        Tab(text: "Insights"),
        Tab(text: "Refund Insights"),
      ],
    );
  }

  // GENERAL INFO
  Widget _generalInfo() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        children: [
          _sectionCard("Academic Info", [
            _infoTile("Mentor", student.advisor ?? ''),
            _infoTile("Coordinator", student.advisor ?? ''),
            _infoTile("Subjects", student.subjects ?? ''),
            _infoTile("Syllabus", student.syllabus ?? ''),
            _infoTile("Category", student.category ?? ''),
            _infoTile("Course", student.course ?? ''),
            _infoTile("Standard", student.standard.toString()),
          ]),
          const SizedBox(height: 16),
          _sectionCard("Package Info", [
            _infoTile("Reg Fee", "₹${student.regFee}"),
            _infoTile("Package Amount", "₹${student.totalAmount ?? '0'}"),
            _infoTile("Amount/Hour", "₹${student.amountPerHour}"),
            _infoTile("Total Hour", "${student.totalHour}"),
            _infoTile("Total Session", "${student.totalSession}"),
            _infoTile("Hour/Session", "${student.totalHour}"),
            _infoTile("Duration", "${student.classHours} days"),
          ]),
          const SizedBox(height: 16),
          _sectionCard("Contact Info", [
            _infoTile("Contact Number", student.contact ?? ''),
            _infoTile("WhatsApp", student.whatsapp ?? ''),
          ]),
        ],
      ),
    );
  }

  // SECTION CARD
  Widget _sectionCard(String title, List<Widget> children) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Theme.of(Get.context!).colorScheme.onPrimary,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(blurRadius: 10, color: Colors.black.withOpacity(0.05))
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(title,
              style:
                  const TextStyle(fontSize: 16, fontWeight: FontWeight.w600)),
          const SizedBox(height: 12),
          Wrap(
            spacing: 12,
            runSpacing: 12,
            children: children,
          )
        ],
      ),
    );
  }

  // INFO TILE
  Widget _infoTile(String title, String value) {
    return Container(
      width: 220,
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: const Color(0xFFF8F9FD),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(title, style: const TextStyle(fontSize: 12, color: Colors.grey)),
          const SizedBox(height: 4),
          Text(value, style: const TextStyle(fontWeight: FontWeight.w600)),
        ],
      ),
    );
  }

  Widget _placeholder(String text) {
    return Center(
      child: Text(
        "$text - Coming Soon",
        style: TextStyle(color: Colors.grey.shade600),
      ),
    );
  }
}
