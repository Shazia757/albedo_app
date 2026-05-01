import 'package:albedo_app/config/root.dart';
import 'package:albedo_app/controller/auth_controller.dart';
import 'package:albedo_app/controller/batch_list_controller.dart';
import 'package:albedo_app/controller/session_controller.dart';
import 'package:albedo_app/model/batch_model.dart';
import 'package:albedo_app/model/users/advisor_model.dart';
import 'package:albedo_app/model/users/coordinator_model.dart';
import 'package:albedo_app/model/users/mentor_model.dart';
import 'package:albedo_app/model/users/other_users_model.dart';
import 'package:albedo_app/model/users/student_model.dart';
import 'package:albedo_app/model/users/teacher_model.dart';
import 'package:albedo_app/model/users/user_model.dart';
import 'package:albedo_app/widgets/custom_card.dart';
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
              const SizedBox(width: 6),
              Text(
                widget.title,
                style: Theme.of(context)
                    .textTheme
                    .titleSmall
                    ?.copyWith(color: color),
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

          const SizedBox(height: 10),

          /// Content
          if (!isEditing) ...[
            infoRow(label: "Date", value: widget.date),
            infoRow(label: "Time", value: widget.time),
            infoRow(label: "Duration", value: widget.duration),
          ] else ...[
            CustomWidgets().labelWithAsterisk('Session Date', required: true),
            const SizedBox(height: 6),

            CustomWidgets().dropdownStyledTextField(
              controller: dateController,
              hint: 'Date',
              context: context,
            ),
            const SizedBox(height: 6),
            CustomWidgets().labelWithAsterisk('Session Time', required: true),
            const SizedBox(height: 6),

            CustomWidgets().dropdownStyledTextField(
              controller: timeController,
              hint: 'Time',
              context: context,
            ),
            const SizedBox(height: 10),

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
                  child: const Text("Cancel"),
                ),
                ElevatedButton(
                  onPressed: () {
                    widget.onSave?.call(
                      dateController.text,
                      timeController.text,
                    );

                    setState(() => isEditing = false);
                  },
                  child: const Text("Save"),
                ),
              ],
            ),
          ],
        ],
      ),
    );
  }

  // Widget infoRow(String label, String value) {
  //   return Padding(
  //     padding: const EdgeInsets.only(bottom: 6),
  //     child: Row(
  //       mainAxisAlignment: MainAxisAlignment.spaceBetween,
  //       children: [
  //         Text(
  //           label,
  //           style: const TextStyle(fontSize: 12),
  //         ),
  //         Text(
  //           value,
  //           style: const TextStyle(
  //             fontWeight: FontWeight.w500,
  //             fontSize: 12,
  //           ),
  //         ),
  //       ],
  //     ),
  //   );
  // }

  Color _getRoleColor(BuildContext context, String type) {
    switch (type) {
      case "student":
        return Colors.blue;
      case "mentor":
        return Colors.green;
      case "schedule":
        return Colors.orange;
      default:
        return Theme.of(context).colorScheme.primary;
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
              const SizedBox(width: 10),

              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      widget.title,
                      style: Theme.of(context)
                          .textTheme
                          .labelSmall
                          ?.copyWith(color: color),
                    ),
                    const SizedBox(height: 2),

                    /// 🔥 SWITCH CONTENT
                    if (!isEditing) ...[
                      Text(widget.name,
                          style: Theme.of(context).textTheme.titleMedium),
                      if (widget.id.isNotEmpty)
                        Text(widget.id,
                            style: Theme.of(context)
                                .textTheme
                                .labelSmall
                                ?.copyWith(color: color)),
                    ] else ...[
                      CustomWidgets().dropdownStyledTextField(
                          context: context,
                          hint: 'Name',
                          controller: field1Controller),
                      const SizedBox(height: 6),
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
                child: const Text("Cancel"),
              ),
            ),
        ],
      ),
    );
  }
}

Widget buildRoleCard({
  required BuildContext context,
  required String title,
  required dynamic user,
  required Function(String?) onTap,
}) {
  final name = user?.name;
  final id = user?.id;

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
  final cs = Theme.of(context).colorScheme;
  final textTheme = Theme.of(context).textTheme;

  final imageUrl = getImageUrl?.call();

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
          CircleAvatar(
            radius: 18,
            backgroundColor: color.withOpacity(0.15),
            backgroundImage: imageUrl != null ? NetworkImage(imageUrl) : null,
            child: imageUrl == null
                ? Icon(Icons.person, size: 18, color: color)
                : null,
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: textTheme.labelSmall?.copyWith(color: color),
                ),
                const SizedBox(height: 2),
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
  final cs = Theme.of(context).colorScheme;

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
            const SizedBox(width: 6),
            Text(
              title,
              style: Theme.of(context).textTheme.titleSmall?.copyWith(
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
        const SizedBox(height: 10),
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
          const SizedBox(width: 8),
        ],

        /// 🔹 Label
        SizedBox(
          width: 80, // keeps alignment clean
          child: Text(
            label,
            style: const TextStyle(
              fontSize: 12,
              color: Colors.grey,
            ),
          ),
        ),

        /// 🔹 Value
        Expanded(
          child: Text(
            value ?? "-",
            style: const TextStyle(
              fontWeight: FontWeight.w500,
              fontSize: 12,
            ),
            overflow: TextOverflow.ellipsis,
            maxLines: 2,
          ),
        ),
      ],
    ),
  );
}

FloatingActionButton buildAddTicketFAB({
  required BuildContext context,
  required TextEditingController titleController,
  required TextEditingController categoryController,
  required TextEditingController priorityController,
  required TextEditingController descriptionController,
  required RxString selectedType,
  required VoidCallback onSubmit,
}) {
  return FloatingActionButton(
    onPressed: () {},
    mini: true,
    backgroundColor: context.theme.colorScheme.primary,
    child: Icon(
      Icons.add,
      color: context.theme.colorScheme.onPrimary,
    ),
  );
}

// ── Icon chip (search toggle) ─────────────────────────────────────────
class IconChip extends StatelessWidget {
  final IconData icon;
  final ColorScheme cs;
  final VoidCallback onTap;

  const IconChip({required this.icon, required this.cs, required this.onTap});

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
          border:
              Border.all(color: cs.outlineVariant.withOpacity(0.5), width: 1),
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
    required this.label,
    required this.value,
    required this.textSecondary,
  });

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    return Row(
      crossAxisAlignment: CrossAxisAlignment.baseline,
      textBaseline: TextBaseline.alphabetic,
      children: [
        SizedBox(
          width: 46,
          child: Text(
            label,
            style: TextStyle(fontSize: 11, color: textSecondary),
          ),
        ),
        const SizedBox(width: 4),
        Expanded(
          child: Text(
            value,
            style: TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w500,
              color: cs.onSurface.withOpacity(0.8),
            ),
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
        ],
      ),
    ],
  );
}

Users studentToUser(Student s) {
  return Users(
    id: s.studentId!,
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

          const SizedBox(width: 12),

          /// 🔹 TEXT
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: Theme.of(context).textTheme.titleSmall?.copyWith(
                        color: Colors.white,
                      ),
                ),
                const SizedBox(height: 2),
                Text(
                  subtitle,
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
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
    id: t.id,
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

void openBatchProfile(BuildContext context, Batch data) {
  final primary = Theme.of(context).colorScheme.primary;
  openProfileDialog(
      context: context,
      title: 'Batch profile',
      icon: Icons.people,
      color: Theme.of(context).colorScheme.primary,
      content: SingleChildScrollView(
        child: Column(children: [
          profileHeader<Batch>(
            context: context,
            data: data,
            color: primary,
            getName: (b) => b.batchName ?? "-",
            getEmail: (_) => null,
            getId: (b) => b.batchID ?? '',
            getImageUrl: (b) => b.imageUrl ?? '',
            getStatus: (p0) => p0.status ?? '',
          ),
          const SizedBox(height: 10),
          infoCard(
            context,
            type: "schedule",
            icon: Icons.calendar_today,
            title: "Course Details",
            children: [
              infoRow(label: "Course", value: data.course ?? ''),
              infoRow(
                label: "Duration",
                value: "${data.duration ?? 0} days",
              ),
            ],
          ),
          infoCard(
            context,
            type: "batch",
            icon: Icons.bar_chart,
            title: "Batch Statistics",
            children: [
              infoRow(label: "Students", value: data.students.toString()),
              infoRow(
                  label: "Packages",
                  value: data.package?.length.toString() ?? ''),
            ],
          ),
          infoCard(
            context,
            type: "status",
            icon: Icons.account_balance_wallet,
            title: "Payment Summary",
            children: [
              infoRow(label: "Total Fee", value: data.totalFee.toString()),
              infoRow(label: "Total Paid", value: data.totalPaid.toString()),
              infoRow(label: "Balance", value: data.balance.toString()),
              infoRow(
                  label: "Expense Ratio", value: data.expenseRatio.toString()),
            ],
          ),
          profileCard(
            context,
            color: Colors.indigo,
            title: "Assigned Personnel",
            children: [
              if (data.coordinator?.name != null)
                detailCard(
                  context,
                  title: "Coordinator",
                  name: data.coordinator?.name ?? "-",
                  id: data.coordinatorId ?? "-",
                  onTap: () {},
                ),
              if (data.coordinator?.name == null)
                simpleText("No coordinator assigned"),
              const SizedBox(height: 6),
              EditableDetailCard(
                type: "mentor",
                title: "Mentor",
                name: data.mentorName ?? "",
                id: data.mentorId ?? "",
                field1Label: "Name",
                field2Label: "ID",
                onSave: (name, id) {
                  data.mentorName = name;
                  data.mentorId = id;
                },
              ),
            ],
          ),
        ]),
      ));
}

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
    id: m.id,
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
    getName: (m) => m.name,
    getEmail: (m) => m.email,
    getId: (m) => m.id,
    getImageUrl: (m) => m.imageUrl,
    toUser: (p0) => toUser,
    sections: staffSections(context, data, color),
  );
}

Users coordinatorToUser(Coordinator c) {
  return Users(
    id: c.id,
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
    getImageUrl: (m) => m.imageUrl,
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
          simpleText(data.convertedStudents?.toString() ?? "-"),
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
    id: a.id,
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
        style: Theme.of(context)
            .textTheme
            .titleMedium
            ?.copyWith(color: Colors.white)),
    icon: icon,
    formKey: GlobalKey<FormState>(),
    submitText: "Close",
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
          style: Theme.of(context).textTheme.titleSmall?.copyWith(color: color),
        ),
        const SizedBox(height: 10),
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
      style: const TextStyle(
        fontSize: 13,
        fontWeight: FontWeight.w500,
      ),
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
      const SizedBox(height: 10),
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

        const SizedBox(width: 12),

        /// 🔹 INFO
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(getName(data),
                  style: Theme.of(context).textTheme.titleMedium),

              const SizedBox(height: 4),

              if (email != null && email.isNotEmpty) ...[
                const SizedBox(height: 4),
                Text(
                  email,
                  style: Theme.of(context).textTheme.bodySmall,
                ),
              ],

              const SizedBox(height: 4),

              /// 🪪 ID CHIP
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                decoration: BoxDecoration(
                  color: color.withOpacity(0.15),
                  borderRadius: BorderRadius.circular(6),
                ),
                child: Text(
                  getId(data) ?? "-",
                  style: Theme.of(context)
                      .textTheme
                      .labelSmall
                      ?.copyWith(color: color),
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
              style: Theme.of(context).textTheme.labelMedium?.copyWith(
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

String formatDate(DateTime date) {
  return DateFormat('dd MMM yyyy').format(date);
}

String formatTime(TimeOfDay time) {
  final now = DateTime.now();
  final dt = DateTime(now.year, now.month, now.day, time.hour, time.minute);
  return DateFormat('hh:mm a').format(dt);
}

// ── Status badge ──────────────────────────────────────────────────────
class StatusBadge extends StatelessWidget {
  final String status;
  final Color color;

  const StatusBadge({required this.status, required this.color});

  String get _label {
    final words =
        status.split('_').map((w) => w[0].toUpperCase() + w.substring(1));
    return words.join(' ');
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
      decoration: BoxDecoration(
        color: color.withOpacity(0.08),
        borderRadius: BorderRadius.circular(4),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 5,
            height: 5,
            decoration: BoxDecoration(color: color, shape: BoxShape.circle),
          ),
          const SizedBox(width: 5),
          Text(
            _label,
            style: TextStyle(
              fontSize: 11,
              fontWeight: FontWeight.w500,
              color: color,
            ),
          ),
        ],
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
          style: TextStyle(
            fontSize: 10,
            fontWeight: FontWeight.w500,
            color: textSecondary,
            letterSpacing: 0.6,
          ),
        ),
        const SizedBox(height: 2),
        Text(
          name,
          style: TextStyle(
            fontSize: 13,
            fontWeight: FontWeight.w500,
            color: textPrimary,
          ),
          overflow: TextOverflow.ellipsis,
        ),
      ],
    );
  }
}

// ═══════════════════════════════════════════════════════════════════════
// ADD SESSION FAB
// ═══════════════════════════════════════════════════════════════════════
class AddSessionFAB extends StatelessWidget {
  final SessionController c;
  const AddSessionFAB({required this.c});

  @override
  Widget build(BuildContext context) {
    return AppFAB(
      label: "Add Session",
      icon: Icons.add_rounded,
      onPressed: () => _showAddDialog(context),
    );
  }

  void _showAddDialog(BuildContext context) {
    AppFormDialog.show(
        context: context,
        title: Obx(() => Text(
              c.selectedType.value == "session"
                  ? "Add Class Session"
                  : "Add Meet Session",
            )),
        onSubmit: () {},
        submitText: 'Add Session',
        children: [
          SizedBox(
            height: MediaQuery.of(context).size.height * 0.75,
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  /// 🔹 TYPE TOGGLE
                  Obx(() => Row(
                        children: [
                          Expanded(
                            child: RadioListTile(
                              dense: true,
                              title: const Text('Class Session'),
                              value: "session",
                              groupValue: c.selectedType.value,
                              onChanged: (value) =>
                                  c.selectedType.value = value!,
                            ),
                          ),
                          Expanded(
                            child: RadioListTile(
                              dense: true,
                              title: const Text('Meet'),
                              value: "meet",
                              groupValue: c.selectedType.value,
                              onChanged: (value) =>
                                  c.selectedType.value = value!,
                            ),
                          ),
                        ],
                      )),

                  const SizedBox(height: 10),

                  /// 🔹 FORM SWITCH
                  Obx(() {
                    if (c.selectedType.value == 'session') {
                      return _ClassSessionForm(c: c);
                    }
                    if (c.selectedType.value == 'meet') {
                      return _MeetSessionForm(c: c);
                    }
                    return const SizedBox();
                  }),
                ],
              ),
            ),
          ),
        ]);
  }
}

// ── Class session form ────────────────────────────────────────────────
class _ClassSessionForm extends StatelessWidget {
  final SessionController c;
  const _ClassSessionForm({required this.c});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        CustomWidgets().labelWithAsterisk('Select Student', required: true),
        const SizedBox(height: 8),
        CustomWidgets().customDropdownField(
          context: context,
          hint: 'Select Student',
          items: c.teacherList,
          onChanged: (p0) => c.selectedTeacher.value = p0.name,
        ),
        const SizedBox(height: 12),
        CustomWidgets()
            .labelWithAsterisk('Search and Select Teacher', required: true),
        const SizedBox(height: 8),
        CustomWidgets().customDropdownField(
          context: context,
          hint: 'Select Teacher',
          items: c.teacherList,
          onChanged: (p0) => c.selectedTeacher.value = p0.name,
        ),
        const SizedBox(height: 12),
        CustomWidgets().labelWithAsterisk('Teacher Salary'),
        const SizedBox(height: 8),
        CustomWidgets().dropdownStyledTextField(
            context: context,
            hint: 'Teacher salary',
            controller: c.salaryController),
        const SizedBox(height: 12),
        CustomWidgets().labelWithAsterisk('Session Date', required: true),
        const SizedBox(height: 8),
        CustomWidgets().customDatePickerField(
            context: context,
            controller: c.dateController,
            selectedDate: c.selectedDate),
        const SizedBox(height: 12),
        CustomWidgets().labelWithAsterisk('Session Time', required: true),
        const SizedBox(height: 8),
        CustomWidgets().timePickerStyledField(
            context: context,
            controller: c.timeController,
            selectedTime: c.selectedTime),
        const SizedBox(height: 12),
        CustomWidgets().labelWithAsterisk('Select Duration', required: true),
        const SizedBox(height: 8),
        CustomWidgets().customDropdownField(
          context: context,
          hint: 'Select Duration',
          items: c.durationOptions.map((e) => "${(e)} minutes").toList(),
          onChanged: (p0) {},
        ),
        const SizedBox(height: 16),
      ],
    );
  }
}

// ── Meet session form ─────────────────────────────────────────────────
class _MeetSessionForm extends StatelessWidget {
  final SessionController c;
  const _MeetSessionForm({required this.c});

  Widget _selectAllRow(
      String label, RxBool allToggle, RxList selected, List all) {
    return Row(
      children: [
        Obx(() => Checkbox(
              value: allToggle.value,
              onChanged: (val) {
                if (val == null) return;
                allToggle.value = val;
                val ? selected.assignAll(all) : selected.clear();
              },
            )),
        Text(label, style: const TextStyle(fontSize: 13)),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        CustomWidgets().labelWithAsterisk('Meet Title', required: true),
        const SizedBox(height: 8),
        CustomWidgets().dropdownStyledTextField(
            context: context,
            hint: 'Meet title',
            controller: c.meetTitleController),
        const SizedBox(height: 14),
        const Text("Participants",
            style: TextStyle(fontWeight: FontWeight.w600, fontSize: 13)),
        const SizedBox(height: 10),
        _selectAllRow('Select All Mentors', c.selectAllMentors,
            c.selectedMentors, c.mentorsList),
        CustomWidgets().customMultiDropdownField(
            context: context,
            hint: 'Select Mentors (${c.mentorsList.length} available)',
            items: c.mentorsList,
            selectedItems: c.selectedMentors),
        const SizedBox(height: 10),
        _selectAllRow('Select All Teachers', c.selectAllTeachers,
            c.selectedTeachers, c.teacherList),
        CustomWidgets().customMultiDropdownField(
            context: context,
            hint: 'Select Teachers (${c.teacherList.length} available)',
            items: c.teacherList,
            selectedItems: c.selectedTeachers),
        const SizedBox(height: 10),
        _selectAllRow('Select All Students', c.selectAllStudents,
            c.selectedStudents, c.studentsList),
        CustomWidgets().customMultiDropdownField(
            context: context,
            hint: 'Select Students (${c.studentsList.length} available)',
            items: c.studentsList,
            selectedItems: c.selectedStudents),
        const SizedBox(height: 10),
        _selectAllRow('Select All Coordinators', c.selectAllCoordinators,
            c.selectedCoordinators, c.coordinatorsList),
        CustomWidgets().customMultiDropdownField(
            context: context,
            hint:
                'Select Coordinators (${c.coordinatorsList.length} available)',
            items: c.coordinatorsList,
            selectedItems: c.selectedCoordinators),
        const SizedBox(height: 10),
        _selectAllRow('Select All Advisors', c.selectAllAdvisors,
            c.selectedAdvisors, c.advisorsList),
        CustomWidgets().customMultiDropdownField(
            context: context,
            hint: 'Select Advisors (${c.advisorsList.length} available)',
            items: c.advisorsList,
            selectedItems: c.selectedAdvisors),
        const SizedBox(height: 10),
        _selectAllRow('Select All Other Users', c.selectAllOtherUsers,
            c.selectedOtherUsers, c.otherUsersList),
        CustomWidgets().customMultiDropdownField(
            context: context,
            hint: 'Select Other Users (${c.otherUsersList.length} available)',
            items: c.otherUsersList,
            selectedItems: c.selectedOtherUsers),
        const SizedBox(height: 14),
        const Text("Session Details",
            style: TextStyle(fontWeight: FontWeight.w600, fontSize: 13)),
        const SizedBox(height: 10),
        CustomWidgets().labelWithAsterisk('Session Date', required: true),
        const SizedBox(height: 8),
        CustomWidgets().customDatePickerField(
            context: context,
            controller: c.dateController,
            selectedDate: c.selectedDate),
        const SizedBox(height: 12),
        CustomWidgets().labelWithAsterisk('Start Time', required: true),
        const SizedBox(height: 8),
        CustomWidgets().customDropdownField(
          context: context,
          items: c.durationOptions.map((e) => "${(e)} minutes").toList(),
          hint: 'Select Duration',
          onChanged: (p0) {},
        ),
        const SizedBox(height: 12),
        CustomWidgets().labelWithAsterisk('Description', required: true),
        const SizedBox(height: 8),
        CustomWidgets().dropdownStyledTextField(
            context: context,
            hint: 'Description',
            controller: c.descriptionController),
        const SizedBox(height: 16),
      ],
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
    required this.cs,
    required this.title,
    required this.subtitle,
    required this.icon,
  });

  @override
  Widget build(BuildContext context) {
    return Center(
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
          const SizedBox(height: 16),
          Text(
            title,
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w600,
              color: cs.onSurface.withOpacity(0.7),
            ),
          ),
          const SizedBox(height: 6),
          Text(
            subtitle,
            style:
                TextStyle(fontSize: 13, color: cs.onSurface.withOpacity(0.4)),
          ),
        ],
      ),
    );
  }
}
