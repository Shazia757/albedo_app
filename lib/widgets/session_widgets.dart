import 'package:albedo_app/config/root.dart';
import 'package:albedo_app/controller/auth_controller.dart';
import 'package:albedo_app/controller/batch_list_controller.dart';
import 'package:albedo_app/controller/session_controller.dart';
import 'package:albedo_app/model/users/advisor_model.dart';
import 'package:albedo_app/model/users/coordinator_model.dart';
import 'package:albedo_app/model/users/mentor_model.dart';
import 'package:albedo_app/model/users/other_users_model.dart';
import 'package:albedo_app/model/users/student_model.dart';
import 'package:albedo_app/model/users/teacher_model.dart';
import 'package:albedo_app/model/users/user_model.dart';
import 'package:albedo_app/widgets/widgets.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

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
            infoRow("Date", widget.date),
            infoRow("Time", widget.time),
            infoRow("Duration", widget.duration),
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

  Widget infoRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 6),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: const TextStyle(fontSize: 12),
          ),
          Text(
            value,
            style: const TextStyle(
              fontWeight: FontWeight.w500,
              fontSize: 12,
            ),
          ),
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

Widget detailCard(
  BuildContext context, {
  required String title,
  required String name,
  required String id,
  required VoidCallback onTap,
  String? Function()? getImageUrl,
}) {
  final color = getRoleColor(context, title.toLowerCase());
  final imageUrl = getImageUrl?.call();

  return InkWell(
    onTap: onTap,
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
              // backgroundColor: color.withOpacity(0.15),
              child: imageUrl == null
                  ? Image.asset('assets/images/logo.png')
                  : null),
          const SizedBox(width: 10),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: Theme.of(context)
                      .textTheme
                      .labelSmall
                      ?.copyWith(color: color),
                ),
                const SizedBox(height: 2),
                Text(
                  name,
                  style: Theme.of(context).textTheme.titleMedium,
                ),
                Text(
                  id,
                  style: Theme.of(context)
                      .textTheme
                      .labelSmall
                      ?.copyWith(color: color),
                ),
              ],
            ),
          ),
          Icon(Icons.arrow_forward_ios, size: 14, color: color),
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
  required IconData icon,
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

Widget infoRow(String label, String value) {
  return Padding(
    padding: const EdgeInsets.only(bottom: 6),
    child: Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(label, style: const TextStyle(fontSize: 12)),
        Text(value,
            style: const TextStyle(fontWeight: FontWeight.w500, fontSize: 12)),
      ],
    ),
  );
}

String formatDate(DateTime dateTime) {
  return "${dateTime.day.toString().padLeft(2, '0')}/"
      "${dateTime.month.toString().padLeft(2, '0')}/"
      "${dateTime.year}";
}

String formatTime(DateTime dt) {
  final hour = dt.hour > 12 ? dt.hour - 12 : dt.hour;
  final ampm = dt.hour >= 12 ? "PM" : "AM";
  return "$hour:${dt.minute.toString().padLeft(2, '0')} $ampm";
}

void openStudentProfile(BuildContext context, Student data) {
  final color = getRoleColor(context, "student");
  final c = Get.put(SessionController());
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
    toUser: c.studentToUser,
    sections: [
      _idCardCTA(context, data, color),
      profileCard(
        context,
        color: color,
        title: "Contact",
        children: [
          infoRow("Phone", data.phone ?? "-"),
          infoRow("WhatsApp", data.whatsapp ?? "-"),
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
          infoRow("Syllabus", data.syllabus ?? "-"),
          infoRow("Category", data.category ?? "-"),
          infoRow("Standard", data.standard?.toString() ?? "-"),
        ],
      ),
    ],
  );
}

Widget _idCardCTA(BuildContext context, Student data, Color color) {
  return InkWell(
    onTap: () {
      print("Open ID Card");
      // 👉 Navigate / open ID card
    },
    borderRadius: BorderRadius.circular(14),
    child: Container(
      width: double.infinity,
      margin: const EdgeInsets.only(bottom: 10),
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: color, // 🔥 SOLID COLOR
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
                  "Student ID Card",
                  style: Theme.of(context).textTheme.titleSmall?.copyWith(
                        color: Colors.white,
                      ),
                ),
                const SizedBox(height: 2),
                Text(
                  "Tap to view or download",
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
          infoRow("Qualification", data.qualification ?? "-"),
          infoRow("Gender", data.gender ?? "-"),
        ],
      ),
      profileCard(
        context,
        color: color,
        title: "Contact",
        children: [
          infoRow("Phone", data.phone ?? "-"),
          infoRow("WhatsApp", data.whatsapp ?? "-"),
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
          infoRow("UPI ID", data.upiId ?? "-"),
          infoRow("Account No", data.accountNumber ?? "-"),
          infoRow("IFSC Code", data.bankBranch ?? "-"),
          infoRow("Bank", data.bankName ?? "-"),
        ],
      ),
    ],
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

List<Widget> staffSections(BuildContext context, dynamic data, Color color) {
  return [
    profileCard(
      context,
      color: color,
      title: "Contact",
      children: [
        infoRow("Phone", data.phone ?? "-"),
        infoRow("WhatsApp", data.whatsapp ?? "-"),
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
        infoRow("UPI ID", data.upiId ?? "-"),
        infoRow("Account No", data.accountNumber ?? "-"),
        infoRow("IFSC Code", data.bankBranch ?? "-"),
        infoRow("Bank", data.bankName ?? "-"),
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

void openOtherUserProfile(BuildContext context, OtherUsers data,
    {Function(OtherUsers)? toUser, String? role}) {
  final color = getRoleColor(context, "");

  openGenericProfile(
    context: context,
    title: "User Profile",
    role: role ?? '',
    icon: Icons.school,
    data: data,
    getName: (m) => m.name,
    getEmail: (m) => m.email,
    getId: (m) => m.id,
    getImageUrl: (m) => m.imageUrl,
    toUser: (p0) => toUser,
    sections: [],
  );
}

Users otherUserToUser(OtherUsers a) {
  return Users(
    id: a.id,
    name: a.name,
    role: a.role,
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
