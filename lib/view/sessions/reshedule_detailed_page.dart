import 'package:albedo_app/model/request_model.dart';
import 'package:albedo_app/view/students/student_detail_page.dart';
import 'package:albedo_app/view/teacher/tr_detailed_page.dart';
import 'package:albedo_app/widgets/custom_appbar.dart';
import 'package:albedo_app/widgets/drawer_menu.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class RescheduleRequestsDetailedPage extends StatelessWidget {
  final StudentRequest? student;
  final TeacherRequest? teacher;

  const RescheduleRequestsDetailedPage({
    super.key,
    this.student,
    this.teacher,
  });

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    final isDesktop = MediaQuery.of(context).size.width > 900;

    final bool isStudent = student != null;

    final requests = isStudent ? student!.requests : teacher!.requests;

    final name = isStudent ? student!.student.name : teacher!.teacher.name;

    final id = isStudent ? student!.student.studentId : teacher!.teacher.id;

    final image =
        isStudent ? student!.student.imageUrl : teacher!.teacher.imageUrl;

    final showRemarkField = <int, RxBool>{};
    final remarkControllers = <int, TextEditingController>{};

    return Scaffold(
      appBar: const CustomAppBar(),
      body: Row(
        children: [
          if (isDesktop) const DrawerMenu(),
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  /// HEADER CARD
                  InkWell(
                    onTap: () {
                      if (isStudent) {
                        Get.to(
                          () => StudentDetailsPage(
                            student: student!.student,
                            initialIndex: 0,
                          ),
                        );
                      } else {
                        Get.to(
                          () => TeacherDetailsPage(
                            teacher: teacher!.teacher,
                            initialIndex: 0,
                          ),
                        );
                      }
                    },
                    child: Container(
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: cs.onPrimary,
                        borderRadius: BorderRadius.circular(16),
                        border: Border.all(
                          color: cs.outline.withOpacity(0.5),
                        ),
                      ),
                      child: Row(
                        children: [
                          Container(
                            width: 58,
                            height: 58,
                            clipBehavior: Clip.antiAlias,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(14),
                            ),
                            child: Image.asset(
                              "assets/images/logo.png",
                              fit: BoxFit.cover,
                            ),
                          ),
                          const SizedBox(width: 14),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  name,
                                  style:
                                      Theme.of(context).textTheme.titleMedium,
                                ),
                                const SizedBox(height: 4),
                                Text(
                                  id ?? "-",
                                  style: Theme.of(context)
                                      .textTheme
                                      .bodyMedium!
                                      .copyWith(
                                        color: cs.outline,
                                      ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),

                  const SizedBox(height: 18),

                  Text(
                    "Requests",
                    style: Theme.of(context).textTheme.titleSmall,
                  ),

                  const SizedBox(height: 12),

                  /// REQUESTS
                  ListView.builder(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    itemCount: requests.length,
                    itemBuilder: (context, index) {
                      final req = requests[index];

                      showRemarkField.putIfAbsent(
                        index,
                        () => false.obs,
                      );

                      remarkControllers.putIfAbsent(
                        index,
                        () => TextEditingController(),
                      );

                      return Container(
                        margin: const EdgeInsets.only(
                          bottom: 14,
                        ),
                        padding: const EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          color: cs.onPrimary,
                          borderRadius: BorderRadius.circular(16),
                          border: Border.all(
                            color: cs.outline.withOpacity(
                              0.5,
                            ),
                          ),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Expanded(
                                  child: Text(
                                    "Requested on ${req.createdAt}",
                                    style: Theme.of(context)
                                        .textTheme
                                        .labelMedium!
                                        .copyWith(
                                          color: cs.outline,
                                        ),
                                  ),
                                ),
                                _statusChip(
                                  context,
                                  req.status,
                                ),
                              ],
                            ),

                            const SizedBox(height: 16),

                            _detailTile(
                              context,
                              "Current Session",
                              "${req.currentDate} • ${req.currentTime}",
                              Icons.schedule,
                            ),

                            const SizedBox(height: 12),

                            _detailTile(
                              context,
                              "Suggested Session",
                              "${req.suggestedDate} • ${req.suggestedTime}",
                              Icons.update,
                            ),

                            const SizedBox(height: 12),

                            _detailTile(
                              context,
                              "Package",
                              "${req.subject} • ${req.standard} • ${req.syllabus}",
                              Icons.menu_book_rounded,
                            ),

                            const SizedBox(height: 12),

                            _detailTile(
                              context,
                              "Reason",
                              req.reason,
                              Icons.notes_rounded,
                            ),

                            const SizedBox(height: 16),

                            Divider(
                              color: cs.outline.withOpacity(
                                0.12,
                              ),
                              thickness: 1,
                            ),

                            const SizedBox(height: 14),

                            Wrap(
                              spacing: 10,
                              runSpacing: 10,
                              children: [
                                /// REMARK
                                _actionButton(
                                  context,
                                  label: "Remark",
                                  icon: Icons.edit_note_rounded,
                                  color: Colors.blueGrey,
                                  onTap: () {
                                    showRemarkField[index]!.toggle();
                                  },
                                ),

                                /// APPROVED
                                if (req.status == "Approved") ...[
                                  _actionButton(
                                    context,
                                    label: "Approved",
                                    icon: Icons.check_circle_outline,
                                    color: Colors.green,
                                    onTap: () {},
                                  ),
                                  _actionButton(
                                    context,
                                    label: "Cancel Approval",
                                    icon: Icons.undo_rounded,
                                    color: Colors.orange,
                                    onTap: () {},
                                  ),
                                  _actionButton(
                                    context,
                                    label: "Delete",
                                    icon: Icons.delete_outline,
                                    color: Colors.red,
                                    onTap: () {},
                                  ),
                                ],

                                /// PENDING
                                if (req.status == "Pending") ...[
                                  _actionButton(
                                    context,
                                    label: "Approve",
                                    icon: Icons.check_circle_outline,
                                    color: Colors.green,
                                    onTap: () {},
                                  ),
                                  _actionButton(
                                    context,
                                    label: "Reject",
                                    icon: Icons.close_rounded,
                                    color: Colors.red,
                                    onTap: () {},
                                  ),
                                  _actionButton(
                                    context,
                                    label: "Reschedule",
                                    icon: Icons.update_rounded,
                                    color: Colors.blue,
                                    onTap: () {},
                                  ),
                                ],

                                /// REJECTED
                                if (req.status == "Rejected") ...[
                                  _actionButton(
                                    context,
                                    label: "Rejected",
                                    icon: Icons.block_rounded,
                                    color: Colors.red,
                                    onTap: () {},
                                  ),
                                  _actionButton(
                                    context,
                                    label: "Delete",
                                    icon: Icons.delete_outline,
                                    color: Colors.red,
                                    onTap: () {},
                                  ),
                                ],

                                /// RESCHEDULED
                                if (req.status == "Rescheduled") ...[
                                  _actionButton(
                                    context,
                                    label: "Approve",
                                    icon: Icons.check_circle_outline,
                                    color: Colors.green,
                                    onTap: () {},
                                  ),
                                  _actionButton(
                                    context,
                                    label: "Reject",
                                    icon: Icons.close_rounded,
                                    color: Colors.red,
                                    onTap: () {},
                                  ),
                                  _actionButton(
                                    context,
                                    label: "Delete",
                                    icon: Icons.delete_outline,
                                    color: Colors.red,
                                    onTap: () {},
                                  ),
                                ],
                              ],
                            ),

                            /// REMARK FIELD
                            Obx(() {
                              if (!showRemarkField[index]!.value) {
                                return const SizedBox();
                              }

                              return Column(
                                children: [
                                  const SizedBox(height: 14),
                                  TextField(
                                    controller: remarkControllers[index],
                                    maxLines: 3,
                                    decoration: InputDecoration(
                                      hintText: "Type your remark...",
                                      filled: true,
                                      fillColor: cs.surfaceContainerHighest
                                          .withOpacity(0.25),
                                      border: OutlineInputBorder(
                                        borderRadius: BorderRadius.circular(14),
                                        borderSide: BorderSide(
                                          color: cs.outline.withOpacity(0.15),
                                        ),
                                      ),
                                      enabledBorder: OutlineInputBorder(
                                        borderRadius: BorderRadius.circular(14),
                                        borderSide: BorderSide(
                                          color: cs.outline.withOpacity(0.15),
                                        ),
                                      ),
                                      focusedBorder: OutlineInputBorder(
                                        borderRadius: BorderRadius.circular(14),
                                        borderSide: BorderSide(
                                          color: cs.primary,
                                        ),
                                      ),
                                    ),
                                  ),
                                  const SizedBox(height: 12),
                                  Row(
                                    children: [
                                      Expanded(
                                        child: ElevatedButton.icon(
                                          onPressed: () {
                                            final remark =
                                                remarkControllers[index]!
                                                    .text
                                                    .trim();

                                            if (remark.isEmpty) {
                                              return;
                                            }

                                            /// submit remark

                                            showRemarkField[index]!.value =
                                                false;
                                          },
                                          icon: const Icon(
                                            Icons.check,
                                            size: 15,
                                            color: Colors.white,
                                          ),
                                          label: Text(
                                            "Submit",
                                            style: Theme.of(context)
                                                .textTheme
                                                .bodySmall!
                                                .copyWith(
                                                  color: Colors.white,
                                                ),
                                          ),
                                          style: ElevatedButton.styleFrom(
                                            backgroundColor: cs.primary,
                                            elevation: 0,
                                            padding: const EdgeInsets.symmetric(
                                              vertical: 12,
                                            ),
                                            shape: RoundedRectangleBorder(
                                              borderRadius:
                                                  BorderRadius.circular(12),
                                            ),
                                          ),
                                        ),
                                      ),
                                      const SizedBox(width: 10),
                                      Expanded(
                                        child: OutlinedButton.icon(
                                          onPressed: () {
                                            showRemarkField[index]!.value =
                                                false;
                                          },
                                          icon: Icon(
                                            Icons.close,
                                            size: 15,
                                            color: cs.outline,
                                          ),
                                          label: Text(
                                            "Cancel",
                                            style: Theme.of(context)
                                                .textTheme
                                                .bodySmall!
                                                .copyWith(
                                                  color: cs.outline,
                                                ),
                                          ),
                                          style: OutlinedButton.styleFrom(
                                            padding: const EdgeInsets.symmetric(
                                              vertical: 12,
                                            ),
                                            shape: RoundedRectangleBorder(
                                              borderRadius:
                                                  BorderRadius.circular(12),
                                            ),
                                            side: BorderSide(
                                              color:
                                                  cs.outline.withOpacity(0.25),
                                            ),
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ],
                              );
                            }),
                          ],
                        ),
                      );
                    },
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _detailTile(
    BuildContext context,
    String title,
    String value,
    IconData icon,
  ) {
    final cs = Theme.of(context).colorScheme;

    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Icon(
          icon,
          size: 18,
          color: cs.primary,
        ),
        const SizedBox(width: 10),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: Theme.of(context).textTheme.labelMedium!.copyWith(
                      color: cs.outline,
                    ),
              ),
              const SizedBox(height: 2),
              Text(
                value,
                style: Theme.of(context).textTheme.bodyMedium,
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _statusChip(
    BuildContext context,
    String status,
  ) {
    Color color = Colors.orange;

    switch (status) {
      case "Approved":
        color = Colors.green;
        break;

      case "Rejected":
        color = Colors.red;
        break;

      case "Rescheduled":
        color = Colors.blue;
        break;

      case "Pending":
      default:
        color = Colors.orange;
    }

    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: 10,
        vertical: 5,
      ),
      decoration: BoxDecoration(
        color: color.withOpacity(0.08),
        borderRadius: BorderRadius.circular(30),
        border: Border.all(
          color: color.withOpacity(0.25),
        ),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 5,
            height: 5,
            decoration: BoxDecoration(
              color: color,
              shape: BoxShape.circle,
            ),
          ),
          const SizedBox(width: 6),
          Text(
            status,
            style: Theme.of(context).textTheme.labelSmall!.copyWith(
                  color: color,
                  fontWeight: FontWeight.w600,
                  fontSize: 10.5,
                ),
          ),
        ],
      ),
    );
  }

  Widget _actionButton(
    BuildContext context, {
    required String label,
    required IconData icon,
    required Color color,
    required VoidCallback onTap,
  }) {
    return ElevatedButton.icon(
      onPressed: onTap,
      icon: Icon(
        icon,
        size: 15,
        color: Colors.white,
      ),
      label: Text(
        label,
        style: Theme.of(context).textTheme.bodySmall!.copyWith(
              color: Colors.white,
            ),
      ),
      style: ElevatedButton.styleFrom(
        backgroundColor: color,
        elevation: 0,
        padding: const EdgeInsets.symmetric(
          horizontal: 14,
          vertical: 12,
        ),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
      ),
    );
  }
}
