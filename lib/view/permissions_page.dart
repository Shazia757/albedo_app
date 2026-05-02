import 'package:albedo_app/controller/permissions_controller.dart';
import 'package:albedo_app/model/permission_model.dart';
import 'package:albedo_app/widgets/custom_appbar.dart';
import 'package:albedo_app/widgets/drawer_menu.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class PermissionsPage extends StatelessWidget {
  PermissionsPage({super.key});

  final PermissionsController c = Get.put(PermissionsController());

  final Map<String, List<PermissionItem>> sections = {
    "Students": [
      PermissionItem(key: "show_students", title: "Show All Students"),
      PermissionItem(key: "add_students", title: "Add Students"),
      PermissionItem(key: "edit_students", title: "Edit Students"),
      PermissionItem(key: "assign_mentor", title: "Assign Mentor"),
      PermissionItem(key: "delete_students", title: "Delete Students"),
      PermissionItem(key: "deactivate_students", title: "Deactivate Students"),
      PermissionItem(key: "view_students", title: "View Students"),
      PermissionItem(key: "manage_packages", title: "Manage Packages"),
      PermissionItem(key: "student_payments", title: "Manage Student Payments"),
      PermissionItem(key: "refunds", title: "Manage Refunds"),
      PermissionItem(key: "assessments", title: "Manage Assessments"),
      PermissionItem(key: "certificates", title: "Manage Certificates"),
    ],
    "Mentors": [
      PermissionItem(key: "show_mentors", title: "Show All Mentors"),
      PermissionItem(key: "add_mentors", title: "Add Mentors"),
      PermissionItem(key: "edit_mentors", title: "Edit Mentors"),
      PermissionItem(key: "delete_mentors", title: "Delete Mentors"),
      PermissionItem(key: "resign_mentors", title: "Resign Mentors"),
      PermissionItem(key: "view_mentors", title: "View Mentors"),
      PermissionItem(
          key: "assigned_students", title: "Manage Assigned Students"),
      PermissionItem(key: "star_of_month", title: "Manage Star Of Month"),
      PermissionItem(key: "mentor_feedbacks", title: "Manage Mentor Feedbacks"),
    ],
    "Reports": [
      PermissionItem(key: "show_reports", title: "Show Reports"),
      PermissionItem(
          key: "coordinator_reports", title: "Show Coordinator Reports"),
      PermissionItem(
          key: "advisor_reports", title: "Show Advisor Reports"),
      PermissionItem(
          key: "recommendation_reports", title: "Show Recommendation Reports"),
      PermissionItem(key: "batch_reports", title: "Show Batch Reports"),
      PermissionItem(
          key: "star_month_reports", title: "Show Star of Month Reports"),
      PermissionItem(key: "hiring_reports", title: "Show Hiring Reports"),
      PermissionItem(key: "package_reports", title: "Show Package Reports"),
      PermissionItem(key: "student_reports", title: "Show Student Reports"),
      PermissionItem(key: "teacher_reports", title: "Show Teacher Reports"),
    ],
    "Coordinators": [
      PermissionItem(key: "show_coordinators", title: "Show All Coordinators"),
      PermissionItem(key: "add_coordinators", title: "Add Coordinators"),
      PermissionItem(key: "edit_coordinators", title: "Edit Coordinators"),
      PermissionItem(key: "delete_coordinators", title: "Delete Coordinators"),
      PermissionItem(key: "resign_coordinators", title: "Resign Coordinators"),
      PermissionItem(key: "view_coordinators", title: "View Coordinators"),
      PermissionItem(
          key: "verification_requests", title: "Manage Verification Requests"),
    ],
    "Teachers": [
      PermissionItem(key: "add_teachers", title: "Add Teachers"),
      PermissionItem(key: "edit_teachers", title: "Edit Teachers"),
      PermissionItem(key: "delete_teachers", title: "Delete Teachers"),
      PermissionItem(key: "deactivate_teachers", title: "Deactivate Teachers"),
      PermissionItem(key: "view_teachers", title: "View Teachers"),
      PermissionItem(key: "teacher_payments", title: "Manage Teacher Payments"),
      PermissionItem(
          key: "teacher_feedbacks", title: "Manage Teacher Feedbacks"),
      PermissionItem(key: "show_all_teachers", title: "Show All Teachers"),
    ],
    "Supports": [
      PermissionItem(key: "show_tickets", title: "Show All Tickets"),
      PermissionItem(key: "view_tickets", title: "View Tickets"),
      PermissionItem(key: "add_tickets", title: "Add Tickets"),
      PermissionItem(key: "edit_tickets", title: "Edit Tickets"),
      PermissionItem(key: "delete_tickets", title: "Delete Tickets"),
    ],
    "Settings": [
      PermissionItem(key: "general_settings", title: "General Settings"),
      PermissionItem(
          key: "notification_settings", title: "Notification Settings"),
      PermissionItem(key: "banner_ads", title: "Banner Ad Settings"),
      PermissionItem(key: "coupon_settings", title: "Coupon Settings"),
      PermissionItem(
          key: "recommendation_settings", title: "Recommendation Settings"),
      PermissionItem(key: "support_settings", title: "Support Settings"),
      PermissionItem(key: "hiring_settings", title: "Hiring Settings"),
      PermissionItem(key: "star_settings", title: "Star Of Month Settings"),
      PermissionItem(key: "assessment_settings", title: "Assessment Settings"),
      PermissionItem(key: "material_settings", title: "Material Settings"),
      PermissionItem(key: "bulk_upload", title: "Bulk Upload Settings"),
    ],
    "Sessions": [
      PermissionItem(key: "show_sessions", title: "Show All Sessions"),
      PermissionItem(key: "add_sessions", title: "Add Sessions"),
      PermissionItem(key: "edit_sessions", title: "Edit Sessions"),
      PermissionItem(
          key: "reschedule_requests", title: "Manage Reschedule Requests"),
    ],
    "Batches": [
      PermissionItem(key: "show_batches", title: "Show All Batches"),
      PermissionItem(key: "view_batch", title: "View Batch"),
      PermissionItem(key: "add_batch", title: "Add Batch"),
      PermissionItem(key: "edit_batch", title: "Edit Batch"),
      PermissionItem(key: "delete_batch", title: "Delete Batch"),
    ],
  };

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(),
      backgroundColor: Theme.of(context).colorScheme.surface,
      body: ListView(padding: const EdgeInsets.all(12), children: [
        const SizedBox(height: 8),
        const Text(
          "Permissions Management",
          style: TextStyle(
            fontSize: 22,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 4),
        const Text(
          "Control access for different modules and roles",
          style: TextStyle(
            fontSize: 13,
            color: Colors.grey,
          ),
        ),
        const SizedBox(height: 16),
        ...sections.entries.map((entry) {
          return _buildSection(entry.key, entry.value);
        }).toList(),
      ]),
    );
  }

  Widget _buildSection(String title, List<PermissionItem> items) {
    return Obx(() {
      final enabledCount = items.where((e) => c.get(e.key)).length;

      return Container(
        margin: const EdgeInsets.symmetric(vertical: 8),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(14),
          border: Border.all(
            color: Colors.grey.withOpacity(0.15),
          ),
          color: Theme.of(Get.context!).colorScheme.surface,
        ),
        child: ExpansionTile(
          shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.zero,
            side: BorderSide.none,
          ),
          collapsedShape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.zero,
            side: BorderSide.none,
          ),
          tilePadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
          childrenPadding: const EdgeInsets.only(bottom: 10),

          // 📌 Header
          title: Row(
            children: [
              Expanded(
                child: Text(
                  title,
                  style: const TextStyle(
                    fontWeight: FontWeight.w700,
                    fontSize: 15,
                  ),
                ),
              ),

              // 🔵 small badge
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 10,
                  vertical: 4,
                ),
                decoration: BoxDecoration(
                  color: Colors.blue.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Text(
                  "$enabledCount / ${items.length}",
                  style: const TextStyle(
                    fontSize: 11,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ],
          ),

          // 📦 Children
          children: [
            ...items.map((item) {
              return Container(
                margin: const EdgeInsets.symmetric(
                  horizontal: 12,
                  vertical: 4,
                ),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                  color: Colors.grey.withOpacity(0.05),
                ),
                child: Obx(() {
                  return SwitchListTile.adaptive(
                    dense: true,
                    contentPadding: const EdgeInsets.symmetric(
                      horizontal: 12,
                    ),
                    title: Text(
                      item.title,
                      style: const TextStyle(fontSize: 13),
                    ),
                    value: c.get(item.key),
                    activeColor: Colors.green,
                    onChanged: (val) => c.toggle(item.key, val),
                  );
                }),
              );
            }).toList(),
          ],
        ),
      );
    });
  }
}
