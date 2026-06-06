import 'package:albedo_app/config/root.dart';
import 'package:albedo_app/controller/auth_controller.dart';
import 'package:albedo_app/model/batch_model.dart';
import 'package:albedo_app/model/users/advisor_model.dart';
import 'package:albedo_app/model/users/coordinator_model.dart';
import 'package:albedo_app/model/users/mentor_model.dart';
import 'package:albedo_app/model/users/student_model.dart';
import 'package:albedo_app/model/users/teacher_model.dart';
import 'package:albedo_app/model/users/user_model.dart';
import 'package:albedo_app/widgets/widgets.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

class EditableInfoCard extends StatefulWidget {
  final String type;
  final IconData icon;
  final String title;

  final String date;
  final String time;
  final String duration;

  final Function(String date, String time)? onSave;

  const EditableInfoCard({
    super.key,
    required this.type,
    required this.icon,
    required this.title,
    required this.date,
    required this.time,
    required this.duration,
    this.onSave,
  });

  @override
  State<EditableInfoCard> createState() => _EditableInfoCardState();
}

class _EditableInfoCardState extends State<EditableInfoCard> {
  bool isEditing = false;

  late TextEditingController dateController;
  late TextEditingController timeController;

  @override
  void initState() {
    super.initState();
    dateController = TextEditingController(text: widget.date);
    timeController = TextEditingController(text: widget.time);
  }

  @override
  void dispose() {
    dateController.dispose();
    timeController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final color = _getRoleColor(context, widget.type);

    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: color.withOpacity(0.08),
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: color.withOpacity(0.2)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          /// Header
          Row(
            children: [
              Icon(widget.icon, size: 16, color: color),
              SizedBox(width: 6),
              Text(
                widget.title,
                style: Get.textTheme.titleSmall?.copyWith(color: color),
              ),
              const Spacer(),
              InkWell(
                onTap: () {
                  setState(() => isEditing = !isEditing);
                },
                child: Icon(
                  isEditing ? Icons.close : Icons.edit,
                  size: 16,
                  color: color,
                ),
              ),
            ],
          ),

          SizedBox(height: 10),

          /// Content
          if (!isEditing) ...[
            infoRow(label: "Date", value: widget.date),
            infoRow(label: "Time", value: widget.time),
            infoRow(label: "Duration", value: widget.duration),
          ] else ...[
            CustomWidgets().labelWithAsterisk('Session Date', required: true),
            SizedBox(height: 6),

            CustomWidgets().dropdownStyledTextField(
              controller: dateController,
              hint: 'Date',
              context: context,
            ),
            SizedBox(height: 6),
            CustomWidgets().labelWithAsterisk('Session Time', required: true),
            SizedBox(height: 6),

            CustomWidgets().dropdownStyledTextField(
              controller: timeController,
              hint: 'Time',
              context: context,
            ),
            SizedBox(height: 10),

            /// Actions
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                TextButton(
                  onPressed: () {
                    setState(() {
                      isEditing = false;
                      dateController.text = widget.date;
                      timeController.text = widget.time;
                    });
                  },
                  child: Text(
                    "Cancel",
                    style: Theme.of(context)
                        .textTheme
                        .bodySmall!
                        .copyWith(color: color),
                  ),
                ),
                ElevatedButton(
                  onPressed: () {
                    widget.onSave?.call(
                      dateController.text,
                      timeController.text,
                    );

                    setState(() => isEditing = false);
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: color,
                    elevation: 0,
                    padding: const EdgeInsets.symmetric(vertical: 12),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  child: Text(
                    "Save",
                    style: Theme.of(context)
                        .textTheme
                        .bodySmall!
                        .copyWith(color: Colors.white),
                  ),
                ),
              ],
            ),
          ],
        ],
      ),
    );
  }

  Color _getRoleColor(BuildContext context, String type) {
    switch (type) {
      case "student":
        return Colors.blue;
      case "mentor":
        return Colors.green;
      case "schedule":
        return Colors.orange;
      default:
        return Get.theme.colorScheme.primary;
    }
  }
}

class EditableDetailCard extends StatefulWidget {
  final String type;
  final String title;
  final String name;
  final String id;

  final String field1Label;
  final String field2Label;

  final Function(String field1, String field2)? onSave;
  final VoidCallback? onTap;

  const EditableDetailCard({
    super.key,
    required this.type,
    required this.title,
    required this.name,
    required this.id,
    required this.field1Label,
    required this.field2Label,
    this.onSave,
    this.onTap,
  });

  @override
  State<EditableDetailCard> createState() => _EditableDetailCardState();
}

class _EditableDetailCardState extends State<EditableDetailCard> {
  bool isEditing = false;

  late TextEditingController field1Controller;
  late TextEditingController field2Controller;

  @override
  void initState() {
    super.initState();
    field1Controller = TextEditingController(text: widget.name);
    field2Controller = TextEditingController(text: widget.id);
  }

  @override
  void dispose() {
    field1Controller.dispose();
    field2Controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final color = getRoleColor(context, widget.type);

    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: color.withOpacity(0.08),
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: color.withOpacity(0.2)),
      ),
      child: Column(
        children: [
          /// 🔹 HEADER (same as detailCard)
          Row(
            children: [
              CircleAvatar(
                radius: 18,
                child: Image.asset('assets/images/logo.png'),
              ),
              SizedBox(width: 10),

              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      widget.title,
                      style: Get.textTheme.labelSmall?.copyWith(color: color),
                    ),
                    SizedBox(height: 2),

                    /// 🔥 SWITCH CONTENT
                    if (!isEditing) ...[
                      Text(widget.name, style: Get.textTheme.titleMedium),
                      if (widget.id.isNotEmpty)
                        Text(widget.id,
                            style: Get.textTheme.labelSmall
                                ?.copyWith(color: color)),
                    ] else ...[
                      CustomWidgets().dropdownStyledTextField(
                          context: context,
                          hint: 'Name',
                          controller: field1Controller),
                      SizedBox(height: 6),
                      CustomWidgets().dropdownStyledTextField(
                          context: context,
                          hint: 'Mentor Id',
                          controller: field2Controller),
                    ],
                  ],
                ),
              ),

              /// 🔥 ACTION BUTTON
              InkWell(
                onTap: () {
                  if (isEditing) {
                    widget.onSave?.call(
                      field1Controller.text,
                      field2Controller.text,
                    );
                  }
                  setState(() => isEditing = !isEditing);
                },
                child: Icon(
                  isEditing ? Icons.check : Icons.edit,
                  size: 16,
                  color: color,
                ),
              ),
            ],
          ),

          /// 🔥 ACTION ROW (only when editing)
          if (isEditing)
            Align(
              alignment: Alignment.centerRight,
              child: TextButton(
                onPressed: () {
                  setState(() {
                    isEditing = false;
                    field1Controller.text = widget.name;
                    field2Controller.text = widget.id;
                  });
                },
                child: Text("Cancel"),
              ),
            ),
        ],
      ),
    );
  }
}

Widget buildRoleCard<T>({
  required BuildContext context,
  required String title,
  required T? user,
  required Function(String?) onTap,
}) {
  String? name;
  String? id;
  if (user is Mentor) {
    name = user.name;
    id = user.empId;
  } else if (user is Coordinator) {
    name = user.name;
    id = user.empId;
  } else if (user is Advisor) {
    name = user.name;
    id = user.empId;
  }
  final isMissing =
      (name == null || name.isEmpty) && (id == null || id.isEmpty);

  if (isMissing) {
    return detailCard(
      context,
      title: title,
      name: "Not assigned",
      id: "",
      onTap: null,
    );
  }

  return detailCard(
    context,
    title: title,
    name: name ?? "-",
    id: id ?? "-",
    onTap: () => onTap(id),
  );
}

Widget detailCard(
  BuildContext context, {
  required String title,
  required String? name,
  required String? id,
  required VoidCallback? onTap,
  String? Function()? getImageUrl,
}) {
  final color = getRoleColor(context, title.toLowerCase());
  final cs = Get.theme.colorScheme;
  final textTheme = Get.textTheme;

  final imageUrl = getImageUrl?.call() ?? "assets/images/logo.png";
  print("IMAGE URL => $imageUrl");

  final isMissing =
      (name == null || name.isEmpty) && (id == null || id.isEmpty);

  return InkWell(
    onTap: isMissing ? null : onTap,
    borderRadius: BorderRadius.circular(14),
    child: Container(
      margin: const EdgeInsets.only(bottom: 10),
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: color.withOpacity(0.08),
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: color.withOpacity(0.2)),
      ),
      child: Row(
        children: [
          CustomWidgets().squareAvatar(
            imageUrl,
            32,
          ),
          SizedBox(width: 10),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: textTheme.labelSmall?.copyWith(color: color),
                ),
                SizedBox(height: 2),
                Text(
                  isMissing ? "Not assigned" : (name ?? "-"),
                  style: textTheme.titleSmall?.copyWith(
                    color: isMissing
                        ? cs.onSurface.withOpacity(0.5)
                        : cs.onSurface,
                  ),
                ),
                if (!isMissing)
                  Text(
                    id ?? "",
                    style: textTheme.labelSmall?.copyWith(color: color),
                  ),
              ],
            ),
          ),
          Icon(
            Icons.arrow_forward_ios,
            size: 14,
            color: isMissing ? cs.onSurface.withOpacity(0.3) : color,
          ),
        ],
      ),
    ),
  );
}

Color getRoleColor(BuildContext context, String role) {
  final cs = Get.theme.colorScheme;

  switch (role) {
    case "student":
      return cs.primary;
    case "teacher":
      return cs.secondary;
    case "mentor":
      return Colors.indigo;
    case "coordinator":
      return Colors.orange;
    case "advisor":
      return Colors.teal;
    case "schedule":
      return Colors.blue;
    case "session":
      return Colors.deepPurple;
    case "status":
      return Colors.green;
    default:
      return cs.primary;
  }
}

Widget infoCard(
  BuildContext context, {
  required String type,
  IconData? icon,
  required String title,
  required List<Widget> children,
  VoidCallback? onEdit,
}) {
  final color = getRoleColor(context, type);

  return Container(
    margin: const EdgeInsets.only(bottom: 10),
    padding: const EdgeInsets.all(14),
    decoration: BoxDecoration(
      color: color.withOpacity(0.08),
      borderRadius: BorderRadius.circular(14),
      border: Border.all(color: color.withOpacity(0.2)),
    ),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Icon(icon, size: 16, color: color),
            SizedBox(width: 6),
            Text(
              title,
              style: Get.textTheme.titleSmall?.copyWith(
                color: color,
              ),
            ),
            const Spacer(),
            if (onEdit != null) // 👈 show only if editable
              InkWell(
                onTap: onEdit,
                borderRadius: BorderRadius.circular(20),
                child: Padding(
                  padding: const EdgeInsets.all(4),
                  child: Icon(Icons.edit, size: 16, color: color),
                ),
              ),
          ],
        ),
        SizedBox(height: 10),
        ...children,
      ],
    ),
  );
}

Widget infoRow({
  required String label,
  String? value,
  IconData? icon,
}) {
  return Padding(
    padding: const EdgeInsets.symmetric(vertical: 6),
    child: Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (icon != null) ...[
          Icon(icon, size: 16, color: Colors.grey),
          SizedBox(width: 8),
        ],

        /// 🔹 Label
        SizedBox(
          width: 80, // keeps alignment clean
          child: Text(
            label,
            style: Get.textTheme.bodySmall!.copyWith(color: Colors.grey),
          ),
        ),

        /// 🔹 Value
        Expanded(
          child: Text(
            value ?? "-",
            style: Get.textTheme.labelMedium,
            overflow: TextOverflow.ellipsis,
            maxLines: 2,
          ),
        ),
      ],
    ),
  );
}

// ── Icon chip (search toggle) ─────────────────────────────────────────
class IconChip extends StatelessWidget {
  final IconData icon;
  final ColorScheme cs;
  final VoidCallback onTap;

  const IconChip(
      {super.key, required this.icon, required this.cs, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 40,
        height: 40,
        decoration: BoxDecoration(
          color: cs.surfaceContainerHighest.withOpacity(0.6),
          borderRadius: BorderRadius.circular(12),
        ),
        child: Icon(icon, size: 19, color: cs.onSurface),
      ),
    );
  }
}

// ── Meta item (label + value inline) ─────────────────────────────────
class MetaItem extends StatelessWidget {
  final String label;
  final String value;
  final Color textSecondary;

  const MetaItem({
    super.key,
    required this.label,
    required this.value,
    required this.textSecondary,
  });

  @override
  Widget build(BuildContext context) {
    final cs = Get.theme.colorScheme;
    return Row(
      crossAxisAlignment: CrossAxisAlignment.baseline,
      textBaseline: TextBaseline.alphabetic,
      children: [
        SizedBox(
          width: 46,
          child: Text(
            label,
            style: Get.textTheme.labelSmall!.copyWith(color: textSecondary),
          ),
        ),
        SizedBox(width: 4),
        Expanded(
          child: Text(
            value,
            style: Get.textTheme.labelMedium!
                .copyWith(color: cs.onSurface.withOpacity(0.8)),
            overflow: TextOverflow.ellipsis,
          ),
        ),
      ],
    );
  }
}

void openStudentProfile(BuildContext context, Student data) {
  final color = getRoleColor(context, "student");
  openGenericProfile(
    context: context,
    title: "Student Profile",
    role: "student",
    icon: Icons.person,
    data: data,
    getName: (s) => s.name,
    getStatus: (p0) => p0.status,
    getEmail: (s) => s.email,
    getId: (s) => s.studentId,
    getImageUrl: (s) => s.imageUrl,
    toUser: studentToUser,
    sections: [
      idCardCTA(
        context: context,
        color: color,
        title: "Student ID Card",
        subtitle: "Tap to view or download",
        onTap: () {
          print("Open Student ID");
        },
      ),
      profileCard(
        context,
        color: color,
        title: "Contact",
        children: [
          infoRow(label: "Phone", value: data.phone ?? "-"),
          infoRow(label: "WhatsApp", value: data.whatsapp ?? "-"),
        ],
      ),
      profileCard(
        context,
        color: Colors.orange,
        title: "Parent Details",
        children: [
          simpleText(data.parentName ?? "-"),
          simpleText(data.parentOccupation ?? "-"),
        ],
      ),
      profileCard(
        context,
        color: Colors.deepPurple,
        title: "Academic",
        children: [
          infoRow(label: "Syllabus", value: data.syllabus ?? "-"),
          infoRow(label: "Category", value: data.category ?? "-"),
          infoRow(label: "Standard", value: data.standard?.toString() ?? "-"),
          infoRow(
            label: "Fee",
            value: (data.totalPaid ?? 0) > 0 ? "Paid ₹500" : "Unpaid",
          ),
        ],
      ),
    ],
  );
}

Users studentToUser(Student s) {
  return Users(
    empId: s.studentId!,
    name: s.name,
    role: "student",
  );
}

Widget idCardCTA({
  required BuildContext context,
  required Color color,
  required String title,
  required String subtitle,
  required VoidCallback onTap,
}) {
  return InkWell(
    onTap: onTap,
    borderRadius: BorderRadius.circular(14),
    child: Container(
      width: double.infinity,
      margin: const EdgeInsets.only(bottom: 10),
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(14),
      ),
      child: Row(
        children: [
          /// 🪪 ICON
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.15),
              borderRadius: BorderRadius.circular(10),
            ),
            child: const Icon(
              Icons.badge_outlined,
              color: Colors.white,
              size: 20,
            ),
          ),

          SizedBox(width: 12),

          /// 🔹 TEXT
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: Get.textTheme.titleSmall?.copyWith(
                    color: Colors.white,
                  ),
                ),
                SizedBox(height: 2),
                Text(
                  subtitle,
                  style: Get.textTheme.bodySmall?.copyWith(
                    color: Colors.white70,
                  ),
                ),
              ],
            ),
          ),

          /// 👉 ARROW
          const Icon(
            Icons.arrow_forward_ios,
            color: Colors.white,
            size: 14,
          ),
        ],
      ),
    ),
  );
}

void openTeacherProfile(
  BuildContext context,
  Teacher data, {
  Function(Teacher)? toUser,
}) {
  final color = getRoleColor(context, "teacher");
  // final c = Get.find<BatchListController>();

  openGenericProfile(
    context: context,
    title: "Teacher Profile",
    role: "teacher",
    icon: Icons.school,
    data: data,
    getName: (t) => t.name,
    getEmail: (t) => t.email,
    getId: (t) => t.id,
    getImageUrl: (t) => t.imageUrl,
    toUser: toUser!,
    sections: [
      profileCard(
        context,
        color: color,
        title: "Details",
        children: [
          infoRow(label: "Qualification", value: data.qualification ?? "-"),
          infoRow(label: "Gender", value: data.gender ?? "-"),
        ],
      ),
      profileCard(
        context,
        color: color,
        title: "Contact",
        children: [
          infoRow(label: "Phone", value: data.phone ?? "-"),
          infoRow(label: "WhatsApp", value: data.whatsapp ?? "-"),
        ],
      ),
      profileCard(
        context,
        color: Colors.blueGrey,
        title: "Address",
        children: [
          simpleText(data.address ?? "-"),
          simpleText(data.place ?? "-"),
          simpleText(data.pincode ?? "-"),
        ],
      ),
      profileCard(
        context,
        color: Colors.green,
        title: "Bank Details",
        children: [
          infoRow(label: "UPI ID", value: data.upiId ?? "-"),
          infoRow(label: "Account No", value: data.accountNumber ?? "-"),
          infoRow(label: "IFSC Code", value: data.bankBranch ?? "-"),
          infoRow(label: "Bank", value: data.bankName ?? "-"),
        ],
      ),
    ],
  );
}

Users teacherToUser(Teacher t) {
  return Users(
    empId: t.id,
    name: t.name,
    role: "teacher",
  );
}

void openMentorProfile(
  BuildContext context,
  Mentor data,
  Function(Mentor)? toUser,
) {
  final color = getRoleColor(context, "mentor");

  openGenericProfile(
    context: context,
    title: "Mentor Profile",
    role: "mentor",
    icon: Icons.school,
    data: data,
    getName: (m) => m.name,
    getEmail: (m) => m.email,
    getId: (m) => m.id,
    getImageUrl: (m) => m.imageUrl,
    toUser: toUser!,
    sections: staffSections(context, data, color),
  );
}

// void openBatchProfile(BuildContext context, Batch data) {
//   final primary = Get.theme.colorScheme.primary;
//   openProfileDialog(
//       context: context,
//       title: 'Batch profile',
//       icon: Icons.people,
//       color: Get.theme.colorScheme.primary,
//       content: SingleChildScrollView(
//         child: Column(children: [
//           profileHeader<Batch>(
//             context: context,
//             data: data,
//             color: primary,
//             getName: (b) => b.name ?? "-",
//             getEmail: (_) => null,
//             getId: (b) => b.code ?? '',
//             getImageUrl: (b) => b.imageUrl ?? '',
//           ),
//           SizedBox(height: 10),
//           infoCard(
//             context,
//             type: "schedule",
//             icon: Icons.calendar_today,
//             title: "Course Details",
//             children: [
//               // infoRow(label: "Course", value: data.course ?? ''),
//               infoRow(
//                 label: "Duration",
//                 value: "${data.duration ?? 0} days",
//               ),
//             ],
//           ),
//           infoCard(
//             context,
//             type: "batch",
//             icon: Icons.bar_chart,
//             title: "Batch Statistics",
//             children: [
//               Row(
//                 children: [
//                   Expanded(
//                       child: infoRow(
//                           label: "Students", value: data.students.toString())),
//                   Expanded(
//                     child: infoRow(
//                         label: "Packages",
//                         value: data.packages?.first.subjectName?.length
//                                 .toString() ??
//                             ''), //TODO
//                   ),
//                 ],
//               ),
//             ],
//           ),
//           infoCard(
//             context,
//             type: "status",
//             icon: Icons.account_balance_wallet,
//             title: "Payment Summary",
//             children: [
//               Row(
//                 children: [
//                   Expanded(
//                     child: infoRow(
//                       label: "Total Fee",
//                       value: data.totalFee.toString(),
//                     ),
//                   ),
//                   Expanded(
//                     child: infoRow(
//                       label: "Total Paid",
//                       value: data.totalPaid.toString(),
//                     ),
//                   ),
//                 ],
//               ),
//               SizedBox(height: 8),
//               Row(
//                 children: [
//                   Expanded(
//                     child: infoRow(
//                       label: "Balance",
//                       value: data.balance.toString(),
//                     ),
//                   ),
//                   Expanded(
//                     child: infoRow(
//                       label: "Expense Ratio",
//                       value: data.expenseRatio.toString(),
//                     ),
//                   ),
//                 ],
//               ),
//             ],
//           ),
//           profileCard(
//             context,
//             color: Colors.indigo,
//             title: "Assigned Personnel",
//             children: [
//               if (data.coordinator?.name != null)
//                 detailCard(
//                   context,
//                   title: "Coordinator",
//                   name: data.coordinator?.name ?? "-",
//                   id: data.coordinatorId ?? "-",
//                   onTap: () {},
//                 ),
//               if (data.coordinator?.name == null)
//                 simpleText("No coordinator assigned"),
//               SizedBox(height: 6),
//               EditableDetailCard(
//                 type: "mentor",
//                 title: "Mentor",
//                 name: data.mentor?.name ?? "",
//                 id: data.mentor?.empId ?? "",
//                 field1Label: "Name",
//                 field2Label: "ID",
//                 onSave: (name, id) {
//                   data.mentor?.name = name;
//                   data.mentor?.empId = id;
//                 },
//               ),
//             ],
//           ),
//         ]),
//       ));
// }

List<Widget> staffSections(BuildContext context, dynamic data, Color color) {
  return [
    profileCard(
      context,
      color: color,
      title: "Contact",
      children: [
        infoRow(label: "Phone", value: data.phone ?? "-"),
        infoRow(label: "WhatsApp", value: data.whatsapp ?? "-"),
      ],
    ),
    profileCard(
      context,
      color: Colors.blueGrey,
      title: "Address",
      children: [
        simpleText(data.address ?? "-"),
        simpleText(data.place ?? "-"),
        simpleText(data.pincode ?? "-"),
      ],
    ),
    profileCard(
      context,
      color: Colors.green,
      title: "Bank Details",
      children: [
        infoRow(label: "UPI ID", value: data.upiId ?? "-"),
        infoRow(label: "Account No", value: data.accountNumber ?? "-"),
        infoRow(label: "IFSC Code", value: data.bankBranch ?? "-"),
        infoRow(label: "Bank", value: data.bankName ?? "-"),
      ],
    ),
  ];
}

Users mentorToUser(Mentor m) {
  return Users(
    empId: m.id,
    name: m.name,
    role: "mentor",
  );
}

void openCoordinatorProfile(
  BuildContext context,
  Coordinator data,
  Function(Mentor)? toUser,
) {
  final color = getRoleColor(context, "coordinator");

  openGenericProfile(
    context: context,
    title: "Coordinator Profile",
    role: "coordinator",
    icon: Icons.school,
    data: data,
    getName: (m) => m.name ?? '',
    getEmail: (m) => m.email,
    getId: (m) => m.id,
    getImageUrl: (m) => m.imageUrl,
    toUser: (p0) => toUser,
    sections: staffSections(context, data, color),
  );
}

Users coordinatorToUser(Coordinator c) {
  return Users(
    empId: c.id,
    name: c.name,
    role: "coordinator",
  );
}

void openAdvisorProfile(
  BuildContext context,
  Advisor data,
  Function(Advisor)? toUser,
) {
  final color = getRoleColor(context, "advisor");

  openGenericProfile(
    context: context,
    title: "Advisor Profile",
    role: "advisor",
    icon: Icons.school,
    data: data,
    getName: (m) => m.name,
    getEmail: (m) => m.email,
    getId: (m) => m.id,
    getImageUrl: (m) => m.photo,
    toUser: (p0) => toUser,
    sections: [
      profileCard(
        context,
        color: Colors.blueGrey,
        title: "Phone Number",
        children: [
          simpleText(data.phone ?? "-"),
        ],
      ),
      profileCard(
        context,
        color: Colors.teal,
        title: "Converted Students",
        children: [
          // simpleText(data.convertedStudents?.toString() ?? "-"),
        ],
      ),
      idCardCTA(
        context: context,
        color: color,
        title: "Advisor ID Card",
        subtitle: "Tap to view or download",
        onTap: () {
          print("Open Advisor ID");
        },
      )
    ],
  );
}

Users advisorToUser(Advisor a) {
  return Users(
    empId: a.id,
    name: a.name,
    role: "advisor",
  );
}

void openGenericProfile<T>({
  required BuildContext context,
  required String title,
  required String role,
  required IconData icon,
  required T data,
  String? Function(T)? getStatus,
  required String Function(T) getName,
  required String? Function(T) getEmail,
  required String? Function(T) getId,
  String? Function(T)? getImageUrl,
  required dynamic Function(T) toUser,
  required List<Widget> sections,
}) {
  final color = getRoleColor(context, role);

  openProfileDialog(
    context: context,
    title: title,
    icon: icon,
    color: color,
    content: buildProfileContent<T>(
      context: context,
      data: data,
      color: color,
      role: role,
      getName: getName,
      getEmail: getEmail,
      getId: getId,
      getImageUrl: getImageUrl,
      onDashboardTap: () {
        final auth = Get.find<AuthController>();
        final user = toUser(data);

        auth.startImpersonation(user);
        Get.offAll(() => const Root());
      },
      sections: sections,
    ),
  );
}

void openProfileDialog({
  required BuildContext context,
  required String title,
  required IconData icon,
  required Color color,
  required Widget content,
}) {
  CustomWidgets().showCustomDialog(
    isViewOnly: true,
    context: context,
    title: Text(title,
        style: Get.textTheme.titleMedium?.copyWith(color: Colors.white)),
    icon: icon,
    formKey: GlobalKey<FormState>(),
    submitWidget: Text(
      "Close",
      style:
          Theme.of(context).textTheme.bodyMedium!.copyWith(color: Colors.white),
    ),
    onSubmit: () {},
    sections: [
      SizedBox(
        height: MediaQuery.of(context).size.height * 0.6,
        child: SingleChildScrollView(child: content),
      )
    ],
  );
}

Widget profileCard(
  BuildContext context, {
  required Color color,
  required String title,
  required List<Widget> children,
}) {
  return Container(
    width: double.infinity,
    margin: const EdgeInsets.only(bottom: 10),
    padding: const EdgeInsets.all(14),
    constraints: const BoxConstraints(minHeight: 100), // 🔥 ADD THIS
    decoration: BoxDecoration(
      color: color.withOpacity(0.08),
      borderRadius: BorderRadius.circular(14),
      border: Border.all(color: color.withOpacity(0.2)),
    ),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: Get.textTheme.titleSmall?.copyWith(color: color),
        ),
        SizedBox(height: 10),
        ...children,
      ],
    ),
  );
}

Widget simpleText(String text) {
  return Padding(
    padding: const EdgeInsets.only(bottom: 6),
    child: Text(
      text,
      style: Get.textTheme.titleSmall,
    ),
  );
}

Widget buildProfileContent<T>({
  required BuildContext context,
  required T data,
  required Color color,
  required String role,
  String? Function(T)? getStatus,
  required String Function(T) getName,
  required String? Function(T) getEmail,
  required String? Function(T) getId,
  String? Function(T)? getImageUrl,
  required VoidCallback onDashboardTap,
  required List<Widget> sections,
}) {
  return Column(
    children: [
      profileHeader(
        context: context,
        data: data,
        color: color,
        getStatus: getStatus,
        getName: getName,
        getEmail: getEmail,
        getId: getId,
        getImageUrl: getImageUrl,
        onDashboardTap: onDashboardTap,
      ),
      SizedBox(height: 10),
      ...sections,
    ],
  );
}

Widget profileHeader<T>({
  required BuildContext context,
  required T data,
  required Color color,

  /// 🔹 field resolvers (make it dynamic safely)
  required String Function(T) getName,
  String? Function(T)? getStatus,
  required String? Function(T) getEmail,
  required String? Function(T) getId,
  String? Function(T)? getImageUrl,

  /// 🔹 optional action
  VoidCallback? onDashboardTap,
}) {
  final imageUrl = getImageUrl?.call(data);
  final email = getEmail(data);
  final status = getStatus?.call(data);
  final statusColor = getStatusColor(status);

  return Container(
    width: double.infinity,
    padding: const EdgeInsets.all(14),
    decoration: BoxDecoration(
      color: color.withOpacity(0.08),
      borderRadius: BorderRadius.circular(14),
      border: Border.all(color: color.withOpacity(0.2)),
    ),
    child: Row(
      children: [
        /// 🔥 PROFILE IMAGE
        Stack(
          children: [
            CircleAvatar(
              radius: 28,
              child: imageUrl == null
                  ? Image.asset("assets/images/logo.png")
                  : null,
            ),

            /// 🔴 STATUS DOT
            if (status != null)
              Positioned(
                bottom: 0,
                right: 0,
                child: Container(
                  height: 12,
                  width: 12,
                  decoration: BoxDecoration(
                    color: statusColor,
                    shape: BoxShape.circle,
                    border: Border.all(color: Colors.white, width: 2),
                  ),
                ),
              ),
          ],
        ),

        SizedBox(width: 12),

        /// 🔹 INFO
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(getName(data), style: Get.textTheme.titleMedium),

              SizedBox(height: 4),

              if (email != null && email.isNotEmpty) ...[
                SizedBox(height: 4),
                Text(
                  email,
                  style: Get.textTheme.bodySmall,
                ),
              ],

              SizedBox(height: 4),

              /// 🪪 ID CHIP
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                decoration: BoxDecoration(
                  color: color.withOpacity(0.15),
                  borderRadius: BorderRadius.circular(6),
                ),
                child: Text(
                  getId(data) ?? "-",
                  style: Get.textTheme.labelSmall?.copyWith(color: color),
                ),
              ),
            ],
          ),
        ),

        /// 🔥 ACTION BUTTON
        if (onDashboardTap != null)
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: color,
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
            ),
            onPressed: onDashboardTap,
            child: Text(
              "Dashboard",
              style: Get.textTheme.labelMedium?.copyWith(
                color: Colors.white,
              ),
            ),
          ),
      ],
    ),
  );
}

Color getStatusColor(String? status) {
  switch (status?.toLowerCase()) {
    case "active":
    case "started":
      return Colors.green;
    case "pending":
      return Colors.orange;
    case "inactive":
    case "completed":
      return Colors.grey;
    case "upcoming":
      return Colors.blue;
    case "no_balance":
      return Colors.red;
    default:
      return Colors.grey;
  }
}

String formatDate(DateTime? date) =>
    date == null ? '-' : DateFormat('dd MMM yyyy').format(date);
String formatTime(TimeOfDay? time) {
  if (time == null) return "-";

  final dt = DateTime(
    2000,
    1,
    1,
    time.hour,
    time.minute,
  );

  return DateFormat('hh:mm a').format(dt);
}

String getMonthName(int month) {
  return DateFormat.MMM().format(DateTime(0, month));
}

// ── Status badge ──────────────────────────────────────────────────────
class StatusBadge extends StatelessWidget {
  final String status;
  final Color color;

  const StatusBadge({super.key, required this.status, required this.color});

  String get _label {
    if (status.trim().isEmpty) return "-";

    final words = status
        .split('_')
        .where((w) => w.isNotEmpty)
        .map((w) => w[0].toUpperCase() + w.substring(1));

    return words.join(' ');
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
      decoration: BoxDecoration(
        color: color.withOpacity(0.15),
        borderRadius: BorderRadius.circular(4),
      ),
      child: Text(
        _label,
        style: Get.textTheme.labelSmall!.copyWith(color: color),
      ),
    );
  }
}

// ── Name cell (Student / Teacher) ─────────────────────────────────────
class NameCell extends StatelessWidget {
  final String label;
  final String name;
  final Color textPrimary;
  final Color textSecondary;

  const NameCell({
    super.key,
    required this.label,
    required this.name,
    required this.textPrimary,
    required this.textSecondary,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label.toUpperCase(),
          style: Get.textTheme.labelSmall!
              .copyWith(color: textSecondary, letterSpacing: 0.6),
        ),
        SizedBox(height: 2),
        Text(
          name,
          style: Get.textTheme.titleSmall!.copyWith(color: textPrimary),
          overflow: TextOverflow.ellipsis,
        ),
      ],
    );
  }
}

/// Section label used inside the detail dialog scroll
class DetailSectionLabel extends StatelessWidget {
  final String label;
  final IconData icon;

  const DetailSectionLabel(
      {super.key, required this.label, required this.icon});

  @override
  Widget build(BuildContext context) {
    final cs = Get.theme.colorScheme;

    return Row(
      children: [
        Icon(icon, size: 14, color: cs.primary.withOpacity(0.7)),
        SizedBox(width: 6),
        Text(
          label.toUpperCase(),
          style: Get.textTheme.titleSmall!.copyWith(
              color: cs.onSurface.withOpacity(0.45), letterSpacing: 0.8),
        ),
      ],
    );
  }
}

// ═══════════════════════════════════════════════════════════════════════
// DIALOG HELPERS
// ═══════════════════════════════════════════════════════════════════════

/// Styled section card used inside dialogs
class DialogSectionCard extends StatelessWidget {
  final IconData icon;
  final String title;
  final Widget child;

  const DialogSectionCard({
    super.key,
    required this.icon,
    required this.title,
    required this.child,
  });

  @override
  Widget build(BuildContext context) {
    final cs = Get.theme.colorScheme;

    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: cs.surfaceContainerHighest.withOpacity(0.3),
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: cs.outlineVariant.withOpacity(0.4), width: 1),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(icon, size: 16, color: cs.primary),
              SizedBox(width: 6),
              Text(
                title,
                style: Get.textTheme.titleSmall!.copyWith(color: cs.onSurface),
              ),
            ],
          ),
          SizedBox(height: 12),
          child,
        ],
      ),
    );
  }
}

/// Action button row inside the detail dialog
class DetailActionButton extends StatelessWidget {
  final String label;
  final IconData icon;
  final Color color;
  final VoidCallback onTap;

  const DetailActionButton({
    super.key,
    required this.label,
    required this.icon,
    required this.color,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return ElevatedButton.icon(
      onPressed: onTap,
      icon: Icon(icon, size: 15, color: Colors.white),
      label: Text(label,
          style: Get.textTheme.bodySmall!.copyWith(color: Colors.white)),
      style: ElevatedButton.styleFrom(
        backgroundColor: color,
        elevation: 0,
        padding: const EdgeInsets.symmetric(vertical: 12),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      ),
    );
  }
}

// ═══════════════════════════════════════════════════════════════════════
// EMPTY STATE
// ═══════════════════════════════════════════════════════════════════════
class EmptyState extends StatelessWidget {
  final ColorScheme cs;
  final String title;
  final String subtitle;
  final IconData icon;

  const EmptyState({
    super.key,
    required this.cs,
    required this.title,
    required this.subtitle,
    required this.icon,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox.expand(
      child: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: cs.primaryContainer.withOpacity(0.35),
                shape: BoxShape.circle,
              ),
              child: Icon(
                icon,
                size: 38,
                color: cs.primary.withOpacity(0.6),
              ),
            ),
            SizedBox(height: 16),
            Text(
              title,
              style: Get.textTheme.titleMedium!
                  .copyWith(color: cs.onSurface.withOpacity(0.7)),
            ),
            SizedBox(height: 6),
            Text(
              subtitle,
              style: Get.textTheme.bodySmall!
                  .copyWith(color: cs.onSurface.withOpacity(0.4)),
            ),
          ],
        ),
      ),
    );
  }
}
