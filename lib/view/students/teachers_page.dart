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
        backgroundColor: Get.theme.colorScheme.surface,
        appBar: CustomAppBar(),
        drawer: DrawerMenu(),
        body: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(height: 12),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(height: 12),
                  Text(
                    "Teachers",
                    style: Get.textTheme.headlineSmall?.copyWith(
                        fontWeight: FontWeight.w800,
                        letterSpacing: -0.5,
                        color: Theme.of(context).colorScheme.primary),
                  ),
                ],
              ),
            ),
            SizedBox(height: 8),
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
            ClipRRect(
              borderRadius: BorderRadius.circular(10),
              child: Container(
                width: 44,
                height: 44,
                color: Theme.of(context)
                    .colorScheme
                    .primaryContainer
                    .withOpacity(0.4),
                child: Image.asset(
                  "assets/images/logo.png",
                  fit: BoxFit.contain,
                ),
              ),
            ),
            SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    teacher.name,
                    style: Get.textTheme.titleMedium,
                  ),
                  SizedBox(height: 4),
                  Text(
                    "ID: ${teacher.id}",
                    style: Get.textTheme.bodySmall!
                        .copyWith(color: Colors.grey[600]),
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
              child: Row(
                children: [
                  Icon(Icons.star, size: 14, color: Colors.orange),
                  SizedBox(width: 4),
                  Text(
                    "4.5",
                    style: Get.textTheme.titleSmall,
                  ),
                ],
              ),
            ),
          ],
        ),

        SizedBox(height: 18),

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
            SizedBox(width: 10),
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

        SizedBox(height: 18),

        /// ================= SECTION TITLE =================
        Align(
          alignment: Alignment.centerLeft,
          child: Text(
            "Assigned Packages",
            style: Get.textTheme.titleMedium,
          ),
        ),

        SizedBox(height: 10),

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
                p.subjectName ?? '',
                style: Get.textTheme.titleSmall,
              ),
              subtitle: Text("${p.duration} classes"),
              trailing: Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: Colors.blue.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Text(
                  "Active",
                  style: Get.textTheme.labelSmall!.copyWith(color: Colors.blue),
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
              SizedBox(width: 6),
              Text(
                title,
                style: Get.textTheme.titleSmall!.copyWith(color: color),
              ),
            ],
          ),
          SizedBox(height: 8),
          Text(
            value,
            style: Get.textTheme.titleSmall,
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
          SizedBox(width: 10),
          Expanded(
            child: Text(
              value,
              style: Get.textTheme.bodySmall,
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

    return Material(
      color: Colors.transparent,
      borderRadius: BorderRadius.circular(22),
      clipBehavior: Clip.antiAlias,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(22),
        child: Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: cs.onPrimary,
            borderRadius: BorderRadius.circular(22),
            border: Border.all(
              color: cs.outline.withOpacity(.15),
            ),
            boxShadow: [
              BoxShadow(
                color: cs.shadow.withOpacity(.04),
                blurRadius: 16,
                offset: const Offset(0, 6),
              ),
            ],
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              /// ── TOP ─────────────────────────────
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  /// PROFILE
                  ClipRRect(
                    borderRadius: BorderRadius.circular(10),
                    child: Container(
                      width: 44,
                      height: 44,
                      color: cs.primaryContainer.withOpacity(0.4),
                      child: Image.asset(
                        "assets/images/logo.png",
                        fit: BoxFit.contain,
                      ),
                    ),
                  ),

                  const SizedBox(width: 14),

                  /// INFO
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          teacher.name,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style:
                              Theme.of(context).textTheme.titleMedium!.copyWith(
                                    fontWeight: FontWeight.w700,
                                    color: cs.onSurface,
                                  ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          "ID: ${teacher.id}",
                          style:
                              Theme.of(context).textTheme.labelSmall!.copyWith(
                                    color: cs.outline,
                                  ),
                        ),
                        const SizedBox(height: 10),
                        Wrap(
                          spacing: 8,
                          runSpacing: 8,
                          children: [
                            _chip(
                              context,
                              Icons.mail_outline_rounded,
                              teacher.email ?? "-",
                            ),
                            _chip(
                              context,
                              Icons.inventory_2_outlined,
                              "$packageCount Packages",
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),

                  /// ARROW
                  Container(
                    width: 34,
                    height: 34,
                    decoration: BoxDecoration(
                      color: cs.primary.withOpacity(.08),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Icon(
                      Icons.arrow_forward_ios_rounded,
                      size: 15,
                      color: cs.primary,
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 16),

              Divider(
                color: cs.outline.withOpacity(.12),
                height: 1,
              ),

              const SizedBox(height: 14),

              /// ── FOOTER ─────────────────────────
              Row(
                children: [
                  Expanded(
                    child: _footerInfo(
                      context,
                      title: "Tuition Mode",
                      value: teacher.tuitionMode ?? "-",
                    ),
                  ),
                  Container(
                    width: 1,
                    height: 38,
                    color: cs.outline.withOpacity(.1),
                  ),
                  Expanded(
                    child: _footerInfo(
                      context,
                      title: "Mentor",
                      value: teacher.mentor?.phone ?? "-",
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _chip(
    BuildContext context,
    IconData icon,
    String text,
  ) {
    final cs = Theme.of(context).colorScheme;

    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: 10,
        vertical: 6,
      ),
      decoration: BoxDecoration(
        color: cs.surfaceContainerHighest.withOpacity(.4),
        borderRadius: BorderRadius.circular(30),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            icon,
            size: 14,
            color: cs.primary,
          ),
          const SizedBox(width: 6),
          ConstrainedBox(
            constraints: const BoxConstraints(
              maxWidth: 140,
            ),
            child: Text(
              text,
              overflow: TextOverflow.ellipsis,
              style: Theme.of(context).textTheme.labelSmall!.copyWith(
                    color: cs.onSurface,
                  ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _footerInfo(
    BuildContext context, {
    required String title,
    required String value,
  }) {
    final cs = Theme.of(context).colorScheme;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title.toUpperCase(),
            style: Theme.of(context).textTheme.labelSmall!.copyWith(
                  letterSpacing: 1,
                  color: cs.outline,
                ),
          ),
          const SizedBox(height: 6),
          Text(
            value,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: Theme.of(context).textTheme.titleSmall!.copyWith(
                  color: cs.onSurface,
                ),
          ),
        ],
      ),
    );
  }
}
