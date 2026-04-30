import 'package:albedo_app/controller/tr_student_controller.dart';
import 'package:albedo_app/model/package_model.dart';
import 'package:albedo_app/model/users/student_model.dart';
import 'package:albedo_app/widgets/custom_appbar.dart';
import 'package:albedo_app/widgets/drawer_menu.dart';
import 'package:albedo_app/widgets/session_widgets.dart';
import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:get/get.dart';

class TrStudentsPage extends StatelessWidget {
  TrStudentsPage({super.key});

  final c = Get.put(TrStudentsController());

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;

    return Scaffold(
      appBar: CustomAppBar(),
      drawer: DrawerMenu(),
      body: Obx(() {
        if (c.isLoading.value) {
          return const Center(child: CircularProgressIndicator());
        }

        if (c.students.isEmpty) {
          return EmptyState(
            cs: cs,
            title: "No students found",
            subtitle: '',
            icon: Icons.no_accounts,
          );
        }

        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            /// 🔹 Header (Title + Count)
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
              child: Row(
                children: [
                  Text(
                    "Students",
                    style: Theme.of(context).textTheme.titleLarge?.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                  ),
                  const SizedBox(width: 8),

                  /// 🔸 Count badge
                  Container(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                    decoration: BoxDecoration(
                      color: cs.primary.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Text(
                      "${c.students.length}",
                      style: TextStyle(
                        color: cs.primary,
                        fontWeight: FontWeight.w600,
                        fontSize: 12,
                      ),
                    ),
                  ),
                ],
              ),
            ),

            /// 🔹 Grid
            Expanded(
              child: LayoutBuilder(
                builder: (context, constraints) {
                  int crossAxisCount = 1;

                  if (constraints.maxWidth > 1200) {
                    crossAxisCount = 4;
                  } else if (constraints.maxWidth > 900) {
                    crossAxisCount = 3;
                  } else if (constraints.maxWidth > 600) {
                    crossAxisCount = 2;
                  }

                  return MasonryGridView.count(
                    padding: const EdgeInsets.fromLTRB(16, 8, 16, 16),
                    crossAxisCount: crossAxisCount,
                    mainAxisSpacing: 12,
                    crossAxisSpacing: 12,
                    itemCount: c.students.length,
                    itemBuilder: (context, index) {
                      final student = c.students[index];
                      final studentPackages =
                          c.getPackagesByStudent(student.teacherId);

                      return _StudentCard(
                        student: student,
                        packages: studentPackages,
                        cs: cs,
                      );
                    },
                  );
                },
              ),
            ),
          ],
        );
      }),
    );
  }
}

class _StudentCard extends StatelessWidget {
  final Student student;
  final List<Package> packages;
  final ColorScheme cs;

  const _StudentCard({
    required this.student,
    required this.packages,
    required this.cs,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: cs.surface,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: cs.outline.withOpacity(0.2)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          /// 🔹 Name + ID
          Row(
            children: [
              CircleAvatar(
                backgroundColor: cs.primary.withOpacity(0.1),
                child: Text(student.name[0]),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(student.name,
                        style: const TextStyle(fontWeight: FontWeight.w600)),
                    Text(student.studentId ?? "-",
                        style: TextStyle(
                            fontSize: 12, color: cs.onSurfaceVariant)),
                  ],
                ),
              ),
            ],
          ),

          const SizedBox(height: 10),

          _info(Icons.email_outlined, student.email ?? "-"),

          const SizedBox(height: 12),

          /// 🔹 Packages
          Text("Packages",
              style: TextStyle(fontWeight: FontWeight.w600, color: cs.primary)),

          const SizedBox(height: 6),

          if (packages.isEmpty)
            Text("No packages", style: TextStyle(color: cs.onSurfaceVariant))
          else
            Column(
              children: packages.map((p) {
                return _packageChip(
                  "${p.subjectName} • ${p.syllabus} • Std ${p.standard}",
                );
              }).toList(),
            ),

          const SizedBox(height: 12),

          /// 🔹 Mentor
          Text("Mentor",
              style: TextStyle(fontWeight: FontWeight.w600, color: cs.primary)),

          const SizedBox(height: 6),

          _info(Icons.person_outline,
              "${student.mentorName ?? "-"} (${student.mentorId ?? "-"})"),
        ],
      ),
    );
  }

  Widget _info(IconData icon, String text) {
    return Row(
      children: [
        Icon(icon, size: 18, color: cs.primary),
        const SizedBox(width: 8),
        Expanded(child: Text(text, style: const TextStyle(fontSize: 13))),
      ],
    );
  }

  Widget _packageChip(String text) {
    return Container(
      margin: const EdgeInsets.only(bottom: 6),
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      decoration: BoxDecoration(
        color: cs.primary.withOpacity(0.08),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Text(text, style: TextStyle(fontSize: 12, color: cs.primary)),
    );
  }
}
