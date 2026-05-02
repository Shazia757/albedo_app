import 'package:albedo_app/controller/stu_tr_controller.dart';
import 'package:albedo_app/model/users/teacher_model.dart';
import 'package:albedo_app/widgets/custom_appbar.dart';
import 'package:albedo_app/widgets/drawer_menu.dart';
import 'package:albedo_app/widgets/widgets.dart';
import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:get/get.dart';

class StuTeachersPage extends StatelessWidget {
  StuTeachersPage({super.key});

  final c = Get.put(StudentTeachersController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.surface,

        appBar: CustomAppBar(),
        drawer: DrawerMenu(),
        body: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 12),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 12),
                  Text(
                    "Teachers",
                    style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                          fontWeight: FontWeight.w800,
                          letterSpacing: -0.5,
                        ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    "Manage and view assigned teachers",
                    style: TextStyle(
                      color: Colors.grey[600],
                      fontSize: 13,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 8),
            Expanded(
              child: LayoutBuilder(
                builder: (context, constraints) {
                  int crossAxisCount = 2;

                  if (constraints.maxWidth > 1200) {
                    crossAxisCount = 4;
                  } else if (constraints.maxWidth > 900) {
                    crossAxisCount = 3;
                  } else if (constraints.maxWidth > 600) {
                    crossAxisCount = 2;
                  } else {
                    crossAxisCount = 1;
                  }

                  return MasonryGridView.count(
                    padding: const EdgeInsets.fromLTRB(16, 12, 16, 16),
                    crossAxisCount: crossAxisCount,
                    mainAxisSpacing: 14,
                    crossAxisSpacing: 14,
                    itemCount: c.teachers.length,
                    itemBuilder: (context, index) {
                      final teacher = c.teachers[index];
                      final packages = c.getPackagesByTeacher(teacher.id);

                      return TeacherCard(
                        teacher: teacher,
                        onTap: () => _showTeacherDialog(context, teacher),
                        packageCount: packages.length,
                      );
                    },
                  );
                },
              ),
            ),
          ],
        ));
  }

  void _showTeacherDialog(BuildContext context, Teacher teacher) {
    final formKey = GlobalKey<FormState>();
    final packages = c.getPackagesByTeacher(teacher.id);

    CustomWidgets().showCustomDialog(
      context: context,
      formKey: formKey,
      icon: Icons.person,
      title: Text("Teacher Details"),
      isViewOnly: true,
      onSubmit: () {},
      sections: [
        /// ================= HEADER =================
        Row(
          children: [
            CircleAvatar(
              radius: 30,
              backgroundImage: teacher.imageUrl != null
                  ? NetworkImage(teacher.imageUrl!)
                  : const AssetImage('assets/images/logo.png') as ImageProvider,
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    teacher.name,
                    style: const TextStyle(
                      fontSize: 17,
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    "ID: ${teacher.id}",
                    style: TextStyle(color: Colors.grey[600], fontSize: 12),
                  ),
                ],
              ),
            ),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
              decoration: BoxDecoration(
                color: Colors.orange.withOpacity(0.12),
                borderRadius: BorderRadius.circular(20),
              ),
              child: const Row(
                children: [
                  Icon(Icons.star, size: 14, color: Colors.orange),
                  SizedBox(width: 4),
                  Text(
                    "4.5",
                    style: TextStyle(fontWeight: FontWeight.w600),
                  ),
                ],
              ),
            ),
          ],
        ),

        const SizedBox(height: 18),

        /// ================= INFO CARDS =================
        _infoTile(Icons.email, teacher.email ?? "-"),
        _infoTile(Icons.school, teacher.tuitionMode ?? "-"),

        Row(
          children: [
            Expanded(
              child: _contactCard(
                title: "Mentor",
                value: teacher.mentor?.phone ?? "-",
                icon: Icons.school,
                color: Colors.blue,
              ),
            ),
            const SizedBox(width: 10),
            Expanded(
              child: _contactCard(
                title: "Coordinator",
                value: teacher.coordinator?.phone ?? "-",
                icon: Icons.support_agent,
                color: Colors.green,
              ),
            ),
          ],
        ),

        const SizedBox(height: 18),

        /// ================= SECTION TITLE =================
        const Align(
          alignment: Alignment.centerLeft,
          child: Text(
            "Assigned Packages",
            style: TextStyle(
              fontSize: 15,
              fontWeight: FontWeight.w800,
            ),
          ),
        ),

        const SizedBox(height: 10),

        /// ================= PACKAGES =================
        ...packages.map(
          (p) => Container(
            margin: const EdgeInsets.only(bottom: 10),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: Colors.grey.withOpacity(0.2)),
            ),
            child: ListTile(
              contentPadding:
                  const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
              title: Text(
                p.subjectName,
                style: const TextStyle(fontWeight: FontWeight.w600),
              ),
              subtitle: Text("${p.duration} classes"),
              trailing: Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: Colors.blue.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: const Text(
                  "Active",
                  style: TextStyle(fontSize: 11, color: Colors.blue),
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _contactCard({
    required String title,
    required String value,
    required IconData icon,
    required Color color,
  }) {
    return Container(
      padding: const EdgeInsets.all(12),
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
                style: TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w600,
                  color: color,
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Text(
            value,
            style: const TextStyle(
              fontSize: 13,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }

  Widget _infoTile(IconData icon, String value) {
    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
      decoration: BoxDecoration(
        color: Colors.grey.withOpacity(0.06),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        children: [
          Icon(icon, size: 18, color: Colors.grey[700]),
          const SizedBox(width: 10),
          Expanded(
            child: Text(
              value,
              style: const TextStyle(fontSize: 13),
            ),
          ),
        ],
      ),
    );
  }
}

class TeacherCard extends StatelessWidget {
  final Teacher teacher;
  final VoidCallback onTap;
  final int packageCount;

  const TeacherCard({
    super.key,
    required this.teacher,
    required this.onTap,
    required this.packageCount,
  });

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;

    return InkWell(
      borderRadius: BorderRadius.circular(18),
      onTap: onTap,
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(18),
          border: Border.all(color: cs.outline.withOpacity(0.1)),
          color: cs.surface,
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.04),
              blurRadius: 10,
              offset: const Offset(0, 4),
            )
          ],
        ),
        padding: const EdgeInsets.all(14),
        child: Row(
          children: [
            /// 🔵 Avatar with gradient ring
            Container(
              padding: const EdgeInsets.all(2),
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                gradient: LinearGradient(
                  colors: [
                    cs.primary,
                    cs.secondary,
                  ],
                ),
              ),
              child: CircleAvatar(
                radius: 28,
                backgroundImage: teacher.imageUrl != null
                    ? NetworkImage(teacher.imageUrl!)
                    : const AssetImage('assets/images/logo.png')
                        as ImageProvider,
              ),
            ),

            const SizedBox(width: 12),

            /// 📄 Info
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    teacher.name,
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    "ID: ${teacher.id}",
                    style: TextStyle(
                      fontSize: 12,
                      color: Colors.grey[600],
                    ),
                  ),
                  const SizedBox(height: 6),
                  Wrap(
                    spacing: 6,
                    runSpacing: 6,
                    children: [
                      _chip("${teacher.email ?? '-'}"),
                      _chip("$packageCount packages"),
                    ],
                  ),
                ],
              ),
            ),

            const Icon(Icons.arrow_forward_ios_rounded, size: 16),
          ],
        ),
      ),
    );
  }

  Widget _chip(String text) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: Colors.grey.withOpacity(0.08),
        borderRadius: BorderRadius.circular(10),
      ),
      child: Text(
        text,
        style: const TextStyle(fontSize: 11),
      ),
    );
  }
}
