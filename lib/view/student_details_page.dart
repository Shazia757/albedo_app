import 'package:albedo_app/model/report_model.dart';
import 'package:albedo_app/model/student_model.dart';
import 'package:albedo_app/widgets/custom_appbar.dart';
import 'package:albedo_app/widgets/drawer_menu.dart';
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
        backgroundColor: Theme.of(context).colorScheme.surface,
        appBar: CustomAppBar(),
        drawer: DrawerMenu(),
        body: Column(
          children: [
            _header(context),
            _tabs(context),
            Expanded(
              child: TabBarView(
                children: [
                  _generalInfo(context),
                  _placeholder(context, "Insights"),
                  _placeholder(context, "Refund Insights"),
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
    final isActive = student.status == "Active";
    final color = isActive
        ? Theme.of(context).colorScheme.primary
        : Theme.of(context).colorScheme.error;
    return Container(
      margin: const EdgeInsets.all(16),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surface,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            blurRadius: 10,
            color: Theme.of(context).colorScheme.shadow.withOpacity(0.08),
          )
        ],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                student.studentName,
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Theme.of(context).colorScheme.onSurface,
                ),
              ),
              Text(
                "ID: ${student.studentId}",
                style: TextStyle(
                  color:
                      Theme.of(context).colorScheme.onSurface.withOpacity(0.6),
                ),
              ),
            ],
          ),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
            decoration: BoxDecoration(
              color: color.withOpacity(0.12),
              borderRadius: BorderRadius.circular(20),
            ),
            child: Text(
              student.status ?? '',
              style: TextStyle(color: color, fontWeight: FontWeight.w500),
            ),
          )
        ],
      ),
    );
  }

  // TABS
  Widget _tabs(BuildContext context) {
    final cs = Theme.of(context).colorScheme;

    return TabBar(
      labelColor: cs.primary,
      unselectedLabelColor: cs.onSurface.withOpacity(0.6),
      indicatorColor: cs.primary,
      tabs: const [
        Tab(text: "General Info"),
        Tab(text: "Insights"),
        Tab(text: "Refund Insights"),
      ],
    );
  }

  // GENERAL INFO
  Widget _generalInfo(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        children: [
          _sectionCard(context, "Academic Info", [
            _infoTile(context, "Mentor", student.advisor ?? ''),
            _infoTile(context, "Coordinator", student.advisor ?? ''),
            _infoTile(context, "Subjects", student.subjects ?? ''),
            _infoTile(context, "Syllabus", student.syllabus ?? ''),
            _infoTile(context, "Category", student.category ?? ''),
            _infoTile(context, "Course", student.course ?? ''),
            _infoTile(context, "Standard", student.standard.toString()),
          ]),
          const SizedBox(height: 16),
          _sectionCard(context, "Package Info", [
            _infoTile(context, "Reg Fee", "₹${student.regFee}"),
            _infoTile(
                context, "Package Amount", "₹${student.totalAmount ?? '0'}"),
            _infoTile(context, "Amount/Hour", "₹${student.amountPerHour}"),
            _infoTile(context, "Total Hour", "${student.totalHour}"),
            _infoTile(context, "Total Session", "${student.totalSession}"),
            _infoTile(context, "Hour/Session", "${student.totalHour}"),
            _infoTile(context, "Duration", "${student.classHours} days"),
          ]),
          const SizedBox(height: 16),
          _sectionCard(context, "Contact Info", [
            _infoTile(context, "Contact Number", student.contact ?? ''),
            _infoTile(context, "WhatsApp", student.whatsapp ?? ''),
          ]),
        ],
      ),
    );
  }

  // SECTION CARD
  Widget _sectionCard(
      BuildContext context, String title, List<Widget> children) {
    final cs = Theme.of(context).colorScheme;

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: cs.surface,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            blurRadius: 10,
            color: cs.shadow.withOpacity(0.08),
          )
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(title,
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w600,
                color: cs.onSurface,
              )),
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
  Widget _infoTile(BuildContext context, String title, String value) {
    final cs = Theme.of(context).colorScheme;

    return Container(
      width: 220,
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: cs.primaryContainer.withOpacity(0.4),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: TextStyle(
              fontSize: 12,
              color: cs.onSurface.withOpacity(0.6),
            ),
          ),
          const SizedBox(height: 4),
          Text(
            value,
            style: TextStyle(
              fontWeight: FontWeight.w600,
              color: cs.onSurface,
            ),
          ),
        ],
      ),
    );
  }

  Widget _placeholder(BuildContext context, String text) {
    return Center(
      child: Text(
        "$text - Coming Soon",
        style: TextStyle(
          color: Theme.of(context).colorScheme.onSurface.withOpacity(0.6),
        ),
      ),
    );
  }
}
