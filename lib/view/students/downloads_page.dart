import 'package:albedo_app/controller/downloads_controller.dart';
import 'package:albedo_app/model/settings/assessment_model.dart';
import 'package:albedo_app/widgets/custom_appbar.dart';
import 'package:albedo_app/widgets/dialog.dart';
import 'package:albedo_app/widgets/drawer_menu.dart';
import 'package:albedo_app/widgets/session_widgets.dart';
import 'package:albedo_app/widgets/widgets.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class DownloadsPage extends StatelessWidget {
  DownloadsPage({super.key});

  final c = Get.put(DownloadsController());

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;

    return DefaultTabController(
      length: 2,
      child: Scaffold(
        backgroundColor: Theme.of(context).colorScheme.surface,
        drawer: DrawerMenu(),
        appBar: CustomAppBar(),
        body: Column(
          children: [
            SizedBox(height: 12),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  "Downloads",
                  style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                        fontWeight: FontWeight.w700,
                        letterSpacing: -0.5,
                        color: cs.primary,
                      ),
                ),
              ),
            ),
            SizedBox(height: 12),
            Obx(
              () => CustomWidgets().customTabs(
                context,
                tabs: c.tabs,
                selectedIndex: c.selectedIndex.value,
                onTap: (index) => c.selectedIndex.value = index,
              ),
            ),
            SizedBox(height: 16),
            Obx(() {
              final index = c.selectedIndex.value;
              if (c.tabs[index] == 'Certificates') {
                return CertificatesTab();
              }
              if (c.tabs[index] == 'Assessments') {
                return AssessmentsTab();
              }
              return SizedBox();
            })
          ],
        ),
      ),
    );
  }
}

class CertificatesTab extends StatelessWidget {
  const CertificatesTab({super.key});

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: EmptyState(
          cs: Theme.of(context).colorScheme,
          title: 'No certificates yet',
          subtitle: 'Your achievements will appear here',
          icon: Icons.workspace_premium_outlined),
    );
  }
}

class AssessmentsTab extends StatelessWidget {
  const AssessmentsTab({super.key});

  @override
  Widget build(BuildContext context) {
    final c = Get.find<DownloadsController>();
    if (c.assessments.isEmpty) {
      return Expanded(
        child: EmptyState(
          cs: Theme.of(context).colorScheme,
          icon: Icons.quiz_outlined,
          title: 'No assessments available0',
          subtitle: '',
        ),
      );
    }
    return ListView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: c.assessments.length,
      itemBuilder: (context, i) =>
          studentAssessmentCard(context, c.assessments[i]),
    );
  }

  Widget studentAssessmentCard(BuildContext context, Assessment assessment) {
    final cs = Theme.of(context).colorScheme;

    return InkWell(
      onTap: () => DialogUtils().showAssessmentDialog(context, assessment),
      borderRadius: BorderRadius.circular(16),
      child: Container(
        margin: const EdgeInsets.only(
          left: 12,
          right: 12,
          bottom: 14,
        ),
        decoration: BoxDecoration(
          color: cs.onPrimary,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: cs.outline.withOpacity(0.5)),
          boxShadow: [
            BoxShadow(
              color: cs.shadow.withOpacity(0.04),
              blurRadius: 12,
              offset: const Offset(0, 4),
            )
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              height: 4,
              decoration: const BoxDecoration(
                borderRadius: BorderRadius.vertical(
                  top: Radius.circular(16),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 14, 8, 14),
              child: Row(
                children: [
                  Container(
                    width: 40,
                    height: 40,
                    decoration: BoxDecoration(
                      color: cs.primary.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child:
                        Icon(Icons.quiz_outlined, color: cs.primary, size: 20),
                  ),
                  SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          assessment.type ?? 'Assessment',
                          style: Theme.of(context).textTheme.titleMedium,
                        ),
                        SizedBox(height: 4),
                        Row(
                          children: [
                            Icon(Icons.calendar_today_outlined,
                                size: 12, color: cs.outline),
                            SizedBox(width: 4),
                            Text(
                              assessment.date ?? '-',
                              style: Theme.of(context)
                                  .textTheme
                                  .bodySmall!
                                  .copyWith(color: cs.outline),
                            ),
                            SizedBox(width: 12),
                            Icon(Icons.schedule_outlined,
                                size: 12, color: cs.outline),
                            SizedBox(width: 4),
                            Text(
                              '10:30 AM',
                              style: Theme.of(context)
                                  .textTheme
                                  .bodySmall!
                                  .copyWith(color: cs.outline),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  IconButton(
                    icon: const Icon(Icons.edit_outlined, size: 18),
                    onPressed: () {},
                  ),
                  IconButton(
                    icon: Icon(Icons.delete_outline, size: 18, color: cs.error),
                    onPressed: () {},
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
