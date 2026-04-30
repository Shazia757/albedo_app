import 'package:albedo_app/controller/tr_student_controller.dart';
import 'package:albedo_app/model/package_model.dart';
import 'package:albedo_app/model/users/student_model.dart';
import 'package:albedo_app/widgets/custom_appbar.dart';
import 'package:albedo_app/widgets/drawer_menu.dart';
import 'package:albedo_app/widgets/header_with_search.dart';
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
      backgroundColor: cs.outline.withOpacity(0.1),
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
            HeaderWithSearch(
              title: 'Students',
              hint: 'Search students...',
              isSearching: c.isSearching,
              searchQuery: c.searchQuery,
              onSearchChanged: () {},
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
                    crossAxisCount: crossAxisCount,
                    padding: const EdgeInsets.all(16),
                    mainAxisSpacing: 16,
                    crossAxisSpacing: 16,
                    itemCount: c.students.length,
                    itemBuilder: (context, index) {
                      final student = c.students[index];
                      final studentPackages =
                          c.getPackagesByStudent(student.teacherId);

                      if (c.students.isEmpty) {
                        return EmptyState(
                          cs: cs,
                          icon: Icons.group_off,
                          title: "No students yet",
                          subtitle: "Students will appear here once added",
                        );
                      }

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
    final textTheme = Theme.of(context).textTheme;

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: cs.onPrimary,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(
          color: cs.outline.withOpacity(0.08),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          /// 🔹 HEADER
          Row(
            children: [
              _Avatar(name: student.name, cs: cs),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      student.name,
                      style: textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      student.studentId ?? "-",
                      style: textTheme.bodySmall?.copyWith(
                        color: cs.onSurface.withOpacity(0.6),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),

          const SizedBox(height: 14),

          /// 🔹 EMAIL
          Row(
            children: [
              Icon(Icons.mail_outline,
                  size: 16, color: cs.onSurface.withOpacity(0.5)),
              const SizedBox(width: 8),
              Expanded(
                child: Text(
                  student.email ?? "-",
                  style: textTheme.bodySmall,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ],
          ),

          const SizedBox(height: 16),

          /// 🔹 PACKAGES
          if (packages.isNotEmpty) ...[
            Text(
              "Packages",
              style: textTheme.labelMedium?.copyWith(
                fontWeight: FontWeight.w600,
                color: cs.onSurface.withOpacity(0.7),
              ),
            ),
            const SizedBox(height: 10),
            Wrap(
              spacing: 6,
              runSpacing: 6,
              children: _buildPackageChips(packages, cs),
            ),
          ] else
            Text(
              "No packages",
              style: textTheme.bodySmall?.copyWith(
                color: cs.onSurface.withOpacity(0.5),
              ),
            ),

          const SizedBox(height: 18),

          Text(
            "Assigned Mentor",
            style: textTheme.labelMedium?.copyWith(
              fontWeight: FontWeight.w600,
              color: cs.onSurface.withOpacity(0.7),
            ),
          ),

          const SizedBox(height: 10),

          /// 🔥 MENTOR SUB-CARD
          _MentorCard(
            name: student.mentorName ?? "-",
            id: student.mentorId ?? "-",
            cs: cs,
          ),
        ],
      ),
    );
  }

  List<Widget> _buildPackageChips(List<Package> packages, ColorScheme cs) {
    final visible = packages.take(3).toList();
    final remaining = packages.length - visible.length;

    final chips = visible.map((p) {
      return Container(
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
        decoration: BoxDecoration(
          color: cs.primary.withOpacity(0.08),
          borderRadius: BorderRadius.circular(10),
        ),
        child: Text(
          "${p.subjectName} • ${p.standard}",
          style: TextStyle(
            fontSize: 12,
            color: cs.primary,
            fontWeight: FontWeight.w500,
          ),
        ),
      );
    }).toList();

    if (remaining > 0) {
      chips.add(
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
          decoration: BoxDecoration(
            color: cs.surfaceVariant,
            borderRadius: BorderRadius.circular(10),
          ),
          child: Text(
            "+$remaining",
            style: TextStyle(
              fontSize: 12,
              color: cs.onSurfaceVariant,
              fontWeight: FontWeight.w500,
            ),
          ),
        ),
      );
    }

    return chips;
  }
}

class _MentorCard extends StatelessWidget {
  final String name;
  final String id;
  final ColorScheme cs;

  const _MentorCard({
    required this.name,
    required this.id,
    required this.cs,
  });

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;

    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: cs.surfaceVariant.withOpacity(0.4),
        borderRadius: BorderRadius.circular(14),
        border: Border.all(
          color: cs.outline.withOpacity(0.08),
        ),
      ),
      child: Row(
        children: [
          /// 🔥 AVATAR (new)
          _MentorAvatar(name: name, cs: cs),

          const SizedBox(width: 10),

          /// 🔹 TEXT
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  name,
                  style: textTheme.bodyMedium?.copyWith(
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  "ID: $id",
                  style: textTheme.bodySmall?.copyWith(
                    color: cs.onSurface.withOpacity(0.6),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _MentorAvatar extends StatelessWidget {
  final String name;
  final ColorScheme cs;

  const _MentorAvatar({
    required this.name,
    required this.cs,
  });

  @override
  Widget build(BuildContext context) {
    final initials = _getInitials(name);

    return Container(
      width: 36,
      height: 36,
      decoration: BoxDecoration(
        color: cs.primary.withOpacity(0.12),
        shape: BoxShape.circle,
      ),
      alignment: Alignment.center,
      child: Text(
        initials,
        style: TextStyle(
          fontSize: 13,
          fontWeight: FontWeight.w700,
          color: cs.primary,
        ),
      ),
    );
  }

  String _getInitials(String name) {
    if (name.trim().isEmpty) return "?";

    final parts = name.trim().split(" ");
    if (parts.length == 1) {
      return parts.first[0].toUpperCase();
    }

    return (parts.first[0] + parts.last[0]).toUpperCase();
  }
}

class _SoftDivider extends StatelessWidget {
  final ColorScheme cs;

  const _SoftDivider({required this.cs});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 1,
      color: cs.outline.withOpacity(0.08),
    );
  }
}

class _Avatar extends StatelessWidget {
  final String name;
  final ColorScheme cs;

  const _Avatar({required this.name, required this.cs});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 42,
      height: 42,
      decoration: BoxDecoration(
        color: cs.primary.withOpacity(0.12),
        shape: BoxShape.circle,
      ),
      alignment: Alignment.center,
      child: Text(
        name.isNotEmpty ? name[0].toUpperCase() : "?",
        style: TextStyle(
          fontWeight: FontWeight.w700,
          color: cs.primary,
        ),
      ),
    );
  }
}

class _InfoRow extends StatelessWidget {
  final IconData icon;
  final String text;
  final ColorScheme cs;

  const _InfoRow({
    required this.icon,
    required this.text,
    required this.cs,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Icon(icon, size: 18, color: cs.onSurface.withOpacity(0.6)),
        const SizedBox(width: 8),
        Expanded(
          child: Text(
            text,
            style: Theme.of(context).textTheme.bodySmall,
            overflow: TextOverflow.ellipsis,
          ),
        ),
      ],
    );
  }
}

class _PackagesView extends StatelessWidget {
  final List<Package> packages;
  final ColorScheme cs;

  const _PackagesView({
    required this.packages,
    required this.cs,
  });

  @override
  Widget build(BuildContext context) {
    if (packages.isEmpty) {
      return Text(
        "No packages",
        style: TextStyle(color: cs.onSurface.withOpacity(0.6)),
      );
    }

    final visible = packages.take(2).toList();
    final remaining = packages.length - visible.length;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        ...visible.map((p) => _packageChip(
              "${p.subjectName} • Std ${p.standard}",
            )),
        if (remaining > 0)
          Padding(
            padding: const EdgeInsets.only(top: 4),
            child: Text(
              "+$remaining more",
              style: TextStyle(
                fontSize: 12,
                color: cs.primary,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
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
      child: Text(
        text,
        style: TextStyle(fontSize: 12, color: cs.primary),
      ),
    );
  }
}
