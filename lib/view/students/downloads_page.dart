import 'package:albedo_app/controller/downloads_controller.dart';
import 'package:albedo_app/model/settings/assessment_model.dart';
import 'package:albedo_app/widgets/custom_appbar.dart';
import 'package:albedo_app/widgets/drawer_menu.dart';
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
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 12),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Text(
                "Downloads",
                style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                      fontWeight: FontWeight.w700,
                      letterSpacing: -0.5,
                    ),
              ),
            ),
            const SizedBox(height: 12),
            Container(
              margin: const EdgeInsets.symmetric(horizontal: 12),
              padding: const EdgeInsets.all(4),
              decoration: BoxDecoration(
                color: cs.surfaceContainerHighest.withOpacity(0.5),
                borderRadius: BorderRadius.circular(12),
              ),
              child: const TabBar(
                labelColor: Colors.black,
                unselectedLabelColor: Colors.grey,
                tabs: [
                  Tab(text: "Certificates"),
                  Tab(text: "Assessments"),
                ],
              ),
            ),
            const SizedBox(height: 10),
            const Expanded(
              child: TabBarView(
                children: [
                  CertificatesTab(),
                  AssessmentsTab(),
                ],
              ),
            ),
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
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.workspace_premium_outlined,
              size: 64, color: Colors.grey.shade400),
          const SizedBox(height: 10),
          Text(
            "No certificates yet",
            style: TextStyle(
              color: Colors.grey.shade600,
              fontWeight: FontWeight.w500,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            "Your achievements will appear here",
            style: TextStyle(color: Colors.grey.shade400, fontSize: 12),
          ),
        ],
      ),
    );
  }
}

class AssessmentsTab extends StatelessWidget {
  const AssessmentsTab({super.key});

  @override
  Widget build(BuildContext context) {
    final c = Get.find<DownloadsController>();

    return Obx(() {
      return ListView.separated(
        padding: const EdgeInsets.all(16),
        itemCount: c.assessments.length,
        separatorBuilder: (_, __) => const SizedBox(height: 10),
        itemBuilder: (context, index) {
          final a = c.assessments[index];

          return InkWell(
            borderRadius: BorderRadius.circular(16),
            onTap: () => _showAssessmentDialog(context, a),
            child: Container(
              padding: const EdgeInsets.all(14),
              decoration: BoxDecoration(
                color: Theme.of(context).colorScheme.surface,
                borderRadius: BorderRadius.circular(16),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.04),
                    blurRadius: 10,
                    offset: const Offset(0, 4),
                  )
                ],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    a.title ?? "Assessment",
                    style: const TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const SizedBox(height: 6),
                  Row(
                    children: [
                      Text(
                        "ID: ${a.id ?? '-'}",
                        style: TextStyle(color: Colors.grey.shade600),
                      ),
                      const SizedBox(width: 12),
                      Text(
                        a.date ?? "-",
                        style: TextStyle(color: Colors.grey.shade600),
                      ),
                    ],
                  ),
                  const SizedBox(height: 10),
                  Wrap(
                    spacing: 6,
                    children: a.testType
                        .map(
                          (e) => Container(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 10, vertical: 4),
                            decoration: BoxDecoration(
                              color: Colors.blue.withOpacity(0.08),
                              borderRadius: BorderRadius.circular(20),
                            ),
                            child: Text(
                              e,
                              style: const TextStyle(fontSize: 12),
                            ),
                          ),
                        )
                        .toList(),
                  ),
                ],
              ),
            ),
          );
        },
      );
    });
  }

  void _showAssessmentDialog(BuildContext context, Assessment a) {
    CustomWidgets().showCustomDialog(
      context: context,
      formKey: GlobalKey(),
      onSubmit: () {},
      isViewOnly: true,
      title: const Text("Assessment Report"),
      sections: [
        SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _reportCard(
                child: _header(a),
              ),
              const SizedBox(height: 12),
              _sectionHeader("Attention", Icons.warning_amber_rounded),
              _reportCard(
                child: Column(
                  children: a.attentionQuestions?.map((q) {
                        return Padding(
                          padding: const EdgeInsets.symmetric(vertical: 4),
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Icon(Icons.circle, size: 6),
                              const SizedBox(width: 8),
                              Expanded(child: Text(q)),
                            ],
                          ),
                        );
                      }).toList() ??
                      [
                        Text(
                          "No attention remarks",
                          style: TextStyle(color: Colors.grey.shade600),
                        )
                      ],
                ),
              ),
              const SizedBox(height: 12),
              _sectionHeader("Academic", Icons.school_outlined),
              _reportCard(
                child: Column(
                  children: [
                    _academicCard("Mathematics", 4, 5),
                    _academicCard("Science", 3, 4),
                  ],
                ),
              ),
              const SizedBox(height: 12),
              _sectionHeader("Parent Feedback", Icons.people_outline),
              _reportCard(
                child: const Text(
                  "Needs improvement in time management and consistency.",
                ),
              ),
              const SizedBox(height: 12),
              _reportCard(
                child: SizedBox(
                  width: double.infinity,
                  child: ElevatedButton.icon(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Theme.of(context).colorScheme.primary,
                    ),
                    onPressed: () {
                      _downloadAssessmentReport(a);
                    },
                    icon: const Icon(Icons.download),
                    label: const Text(
                      "Download Report",
                      style: TextStyle(color: Colors.white),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  void _downloadAssessmentReport(Assessment a) {
    Get.snackbar(
      "Downloading",
      "Assessment report is being prepared...",
      snackPosition: SnackPosition.BOTTOM,
    );

    // TODO: implement PDF generation or API download
  }

  Widget _header(Assessment a) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          a.title ?? "Assessment",
          style: const TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.w700,
          ),
        ),
        const SizedBox(height: 8),
        Row(
          children: [
            Icon(Icons.confirmation_number_outlined,
                size: 14, color: Colors.grey.shade600),
            const SizedBox(width: 4),
            Text(
              a.id ?? "-",
              style: TextStyle(color: Colors.grey.shade700),
            ),
            const SizedBox(width: 12),
            Icon(Icons.calendar_today_outlined,
                size: 14, color: Colors.grey.shade600),
            const SizedBox(width: 4),
            Text(
              a.date ?? "-",
              style: TextStyle(color: Colors.grey.shade700),
            ),
          ],
        ),
        const SizedBox(height: 10),
        Wrap(
          spacing: 6,
          children: a.testType.map((e) {
            return Container(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
              decoration: BoxDecoration(
                color: Colors.blue.withOpacity(0.08),
                borderRadius: BorderRadius.circular(20),
              ),
              child: Text(
                e,
                style: const TextStyle(fontSize: 12),
              ),
            );
          }).toList(),
        ),
      ],
    );
  }

  Widget _academicCard(String subject, int current, int expected) {
    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.grey.shade50,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        children: [
          Expanded(
            child: Text(
              subject,
              style: const TextStyle(
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Row(
                children: [
                  const Text("Now "),
                  _stars(current),
                ],
              ),
              const SizedBox(height: 4),
              Row(
                children: [
                  const Text("Goal "),
                  _stars(expected),
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _stars(int count) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: List.generate(
        5,
        (i) => Icon(
          i < count ? Icons.star : Icons.star_border,
          size: 14,
          color: Colors.amber,
        ),
      ),
    );
  }

  Widget _reportCard({required Widget child}) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(14),
      margin: const EdgeInsets.only(bottom: 10),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 14,
            offset: const Offset(0, 6),
          ),
        ],
      ),
      child: child,
    );
  }

  Widget _sectionHeader(String title, IconData icon) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 6),
      child: Row(
        children: [
          Icon(icon, size: 18),
          const SizedBox(width: 6),
          Text(
            title,
            style: const TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }
}
