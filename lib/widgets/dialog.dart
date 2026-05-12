import 'package:albedo_app/controller/assessment_controller.dart';
import 'package:albedo_app/controller/auth_controller.dart';
import 'package:albedo_app/model/settings/assessment_model.dart';
import 'package:albedo_app/model/wallet_model.dart';
import 'package:albedo_app/widgets/widgets.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class DialogUtils {
  static void showDepositDialog(
    BuildContext context, {
    required Function(TransactionModel) onSubmit,
  }) {
    final formKey = GlobalKey<FormState>();

    final amountController = TextEditingController();
    final descController = TextEditingController();
    final dateController = TextEditingController();

    CustomWidgets().showCustomDialog(
      context: context,
      formKey: formKey,
      icon: Icons.account_balance_wallet,
      submitText: 'Deposit',
      title: Text("Deposit Funds"),
      sections: [
        CustomWidgets().labelWithAsterisk('Amount(₹)', required: true),
        SizedBox(height: 10),
        CustomWidgets().dropdownStyledTextField(
          context: context,
          hint: 'Enter deposit amount',
          controller: amountController,
        ),
        SizedBox(height: 10),
        CustomWidgets().labelWithAsterisk('Description (Optional)'),
        SizedBox(height: 10),
        CustomWidgets().dropdownStyledTextField(
          context: context,
          hint: 'Bank transfer, cash deposit, etc.',
          controller: descController,
        ),
        SizedBox(height: 10),
        CustomWidgets().labelWithAsterisk('Deposit Date', required: true),
        SizedBox(height: 10),
        CustomWidgets().dropdownStyledTextField(
          context: context,
          hint: 'Select date',
          controller: dateController,
        ),
        SizedBox(height: 10),
        CustomWidgets().labelWithAsterisk('Attachment'),
        SizedBox(height: 10),
        CustomWidgets().attachmentStyledField(
          context: context,
          hint: 'Select Screenshot',
        ),
      ],
      onSubmit: () {
        final amount = double.tryParse(amountController.text) ?? 0;

        onSubmit(
          TransactionModel(
            status: "Success",
            type: "Credit",
            title: "Wallet Deposit",
            description: descController.text,
            amount: amount,
            dateTime: DateTime.now(),
          ),
        );
      },
    );
  }

  void showAssessmentDialog(BuildContext context, Assessment a) {
    final auth = Get.find<AuthController>();
    final isAdmin = auth.activeUser?.role == "admin";
    CustomWidgets().showCustomDialog(
      context: context,
      formKey: GlobalKey(),
      onSubmit: () {},
      isViewOnly: true,
      title: Text("Assessment Report"),
      sections: [
        SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              /// ✅ Always show header
              _reportCard(child: _header(a)),
              SizedBox(height: 12),

              /// ✅ Attention (only if data exists)
              if ((a.attentionData ?? []).isNotEmpty) ...[
                attentionReportCard(context, a),
                SizedBox(height: 12),
              ],

              /// ✅ Academics
              if ((a.academicData ?? []).isNotEmpty) ...[
                academicReportCard(context, a.academicData!),
                SizedBox(height: 12),
              ],

              /// ✅ Maths
              if ((a.mathsData ?? []).isNotEmpty) ...[
                mathReportCard(context, a.mathsData!),
                SizedBox(height: 12),
              ],

              /// ✅ Subjects
              if ((a.subjectsData ?? []).isNotEmpty) ...[
                subjectsReportCard(context, a.subjectsData!),
                SizedBox(height: 12),
              ],

              /// ✅ Key Points
              if ((a.keypoints ?? []).isNotEmpty) ...[
                keyPointsReportCard(context, a.keypoints!),
                SizedBox(height: 12),
              ],

              /// ✅ ALWAYS SHOW
              parentOpinionReportCard(context, a.parentOpinion),
              SizedBox(height: 12),

              assessmentSummaryReportCard(context, a.summary),
              SizedBox(height: 12),

              _reportCard(
                child: isAdmin
                    ? Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          IconButton(
                            icon: Icon(Icons.visibility_off_outlined),
                            onPressed: () => CustomWidgets().showHideDialog(
                                context: context,
                                title: 'Hide Assessment',
                                onConfirm: () {},
                                text:
                                    'Are you sure you want to hide this assessment from the list?'),
                          ),
                          IconButton(
                            icon: Icon(Icons.edit_outlined),
                            onPressed: () {
                              // edit logic
                            },
                          ),
                          IconButton(
                            icon: Icon(Icons.delete_outline,
                                color: Get.theme.colorScheme.error),
                            onPressed: () => CustomWidgets().showDeleteDialog(
                              title: 'Are you sure?',
                              context: context,
                              text:
                                  'Are you sure you want to delete this assessment? This action cannot be undone. ',
                              onConfirm: () {},
                            ),
                          ),
                          IconButton(
                            icon: Icon(Icons.download_outlined),
                            onPressed: () {
                              _downloadAssessmentReport(a);
                            },
                          ),
                        ],
                      )
                    : SizedBox(
                        width: double.infinity,
                        child: ElevatedButton.icon(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Get.theme.colorScheme.primary,
                          ),
                          onPressed: () {
                            _downloadAssessmentReport(a);
                          },
                          icon: const Icon(Icons.download),
                          label: Text(
                            "Download Report",
                            style: Get.textTheme.bodyMedium!
                                .copyWith(color: Colors.white),
                          ),
                        ),
                      ),
              ),
            ],
          ),
        )
      ],
    );
  }

  Widget parentOpinionReportCard(BuildContext context, String? opinion) {
    return _card(
      title: "Parent Opinion",
      child: Text(
        (opinion == null || opinion.trim().isEmpty)
            ? "No parent opinion recorded"
            : opinion,
        style: Get.textTheme.bodySmall!.copyWith(
            color: opinion == null || opinion.trim().isEmpty
                ? Colors.grey
                : Get.theme.colorScheme.onSurface),
      ),
    );
  }

  Widget assessmentSummaryReportCard(BuildContext context, String? summary) {
    return _card(
      title: "Assessment Summary",
      child: Text(
        (summary == null || summary.trim().isEmpty)
            ? "No assessment summary available"
            : summary,
        style: Get.textTheme.bodySmall!.copyWith(
            color: summary == null || summary.trim().isEmpty
                ? Colors.grey
                : Get.theme.colorScheme.onSurface),
      ),
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
          a.type ?? "Assessment",
          style: Get.textTheme.titleLarge,
        ),
        SizedBox(height: 8),
        Row(
          children: [
            Row(
              children: [
                Icon(Icons.calendar_month_outlined),
                Text(a.date ?? ''),
              ],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Icon(Icons.timer_outlined),
                Text(a.time ?? ''),
              ],
            )
          ],
        ),
      ],
    );
  }

  Widget languageReportCard(BuildContext context, List languages) {
    return _card(
      title: "Language",
      child: Column(
        children: languages.map<Widget>((item) {
          return Container(
            margin: const EdgeInsets.only(bottom: 10),
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10),
              border: Border.all(
                color: Get.theme.colorScheme.outline.withOpacity(0.2),
              ),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(item["name"], style: Get.textTheme.titleSmall),
                SizedBox(height: 8),
                Wrap(
                  spacing: 10,
                  children: [
                    if (item["reading"] == true) _tag("Reading"),
                    if (item["writing"] == true) _tag("Writing"),
                    if (item["creativity"] == true) _tag("Creativity"),
                  ],
                ),
                SizedBox(height: 8),
                Row(
                  children: [
                    Text("Mark: "),
                    Text(item["mark"] ?? "-"),
                  ],
                ),
                SizedBox(height: 8),
                _displayStars(item["rating"]),
              ],
            ),
          );
        }).toList(),
      ),
    );
  }

  Widget _tag(String text) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(6),
        color: Colors.grey.shade200,
      ),
      child: Text(text, style: Get.textTheme.labelSmall),
    );
  }

  /// helper checkbox widget

  Widget academicReportCard(BuildContext context, List<AcademicData> subjects) {
    /// 🔷 filter valid subjects
    final validSubjects = subjects.where((item) {
      final name = (item.name ?? "").toString().trim();
      final current = item.current;
      final expected = item.expected;

      return name.isNotEmpty || current != null || expected != null;
    }).toList();

    return _card(
      title: "Academics",
      child: validSubjects.isEmpty

          /// ❌ EMPTY STATE
          ? Padding(
              padding: EdgeInsets.symmetric(vertical: 10),
              child: Text(
                "No academic subjects recorded",
                style: Get.textTheme.bodyMedium!.copyWith(color: Colors.grey),
              ),
            )

          /// ✅ DATA STATE
          : Column(
              children: validSubjects.map<Widget>((item) {
                return Container(
                  margin: const EdgeInsets.only(bottom: 10),
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                    border: Border.all(
                      color: Get.theme.colorScheme.outline.withOpacity(0.2),
                    ),
                  ),
                  child: Column(
                    children: [
                      /// 🔷 Subject Name
                      Text(
                        (item.name ?? "-").toString().isEmpty
                            ? "-"
                            : item.name ?? '-',
                        style: Get.textTheme.titleSmall,
                      ),

                      SizedBox(height: 10),

                      /// ⭐ Current (only if exists)
                      if (item.current != null)
                        _displayRating("Current Grade", item.current ?? 0),

                      if (item.current != null && item.expected != null)
                        SizedBox(height: 6),

                      /// ⭐ Expected (only if exists)
                      if (item.expected != null)
                        _displayRating("Expected Grade", item.expected),
                    ],
                  ),
                );
              }).toList(),
            ),
    );
  }

  Widget mathReportCard(BuildContext context, List topics) {
    return _card(
      title: "Maths",
      child: Column(
        children: topics.map<Widget>((item) {
          return Container(
            margin: const EdgeInsets.only(bottom: 10),
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10),
              border: Border.all(
                color: Get.theme.colorScheme.outline.withOpacity(0.2),
              ),
            ),
            child: Column(
              children: [
                Text(
                  item["name"],
                  style: Get.textTheme.titleSmall,
                ),
                SizedBox(height: 8),
                _displayStars(item["rating"]),
              ],
            ),
          );
        }).toList(),
      ),
    );
  }

  Widget subjectsReportCard(BuildContext context, List subjects) {
    return _card(
      title: "Subjects",
      child: Column(
        children: subjects.map<Widget>((item) {
          return Container(
            margin: const EdgeInsets.only(bottom: 10),
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10),
              border: Border.all(
                color: Get.theme.colorScheme.outline.withOpacity(0.2),
              ),
            ),
            child: Column(
              children: [
                Text(
                  item["name"],
                  style: Get.textTheme.titleSmall,
                ),
                SizedBox(height: 8),
                _displayStars(item["rating"]),
              ],
            ),
          );
        }).toList(),
      ),
    );
  }

  Widget keyPointsReportCard(BuildContext context, List points) {
    return _card(
      title: "Key Points",
      child: Column(
        children: points.map<Widget>((item) {
          return Container(
            margin: const EdgeInsets.only(bottom: 10),
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10),
              border: Border.all(
                color: Get.theme.colorScheme.outline.withOpacity(0.2),
              ),
            ),
            child: Column(
              children: [
                Text(
                  item["name"],
                  style: Get.textTheme.titleSmall,
                ),
                SizedBox(height: 8),
                _displayStars(item["rating"]),
              ],
            ),
          );
        }).toList(),
      ),
    );
  }

  Widget voiceNotesReportCard(List notes) {
    return _card(
      title: "Voice Notes",
      child: notes.isEmpty
          ? Text(
              "No voice notes added",
              style: Get.textTheme.bodyMedium!.copyWith(color: Colors.grey),
            )
          : Column(
              children: notes.map<Widget>((n) {
                return ListTile(
                  leading: const Icon(Icons.mic),
                  title: Text(n["fileName"] ?? "Voice Note"),
                  subtitle: Text(n["duration"] ?? ""),
                  trailing: const Icon(Icons.play_arrow),
                );
              }).toList(),
            ),
    );
  }

  Widget _displayStars(int? rating) {
    return Row(
      children: List.generate(5, (index) {
        return Icon(
          index < (rating ?? 0) ? Icons.star : Icons.star_border,
          size: 18,
          color: Colors.amber,
        );
      }),
    );
  }

  Widget _displayRating(String label, int? rating) {
    return Column(
      children: [
        Text(label, style: Get.textTheme.titleSmall),
        SizedBox(height: 4),
        _displayStars(rating),
      ],
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

  Widget attentionReportCard(
    BuildContext context,
    Assessment assessment,
  ) {
    final cs = Get.theme.colorScheme;

    final items = assessment.attentionData ?? [];

    return _card(
      title: "Attention in Online Classes",
      child: Column(
        children: items.map((q) {
          return Container(
            margin: const EdgeInsets.only(bottom: 10),
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10),
              border: Border.all(
                color: cs.outline.withOpacity(0.2),
              ),
            ),
            child: Row(
              children: [
                /// 🔷 Question
                Expanded(
                  child: Text(
                    q.question,
                    style: Get.textTheme.titleSmall,
                  ),
                ),

                /// ⭐ Rating (read-only stars)
                Row(
                  children: List.generate(5, (i) {
                    return Icon(
                      i < q.rating ? Icons.star : Icons.star_border,
                      size: 16,
                      color: Colors.amber,
                    );
                  }),
                ),

                SizedBox(width: 12),

                /// 📝 Mark
                Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(8),
                    color: cs.surfaceContainerHighest,
                  ),
                  child: Text(
                    q.mark.isEmpty ? '-' : q.mark,
                    style: Get.textTheme.titleSmall,
                  ),
                ),
              ],
            ),
          );
        }).toList(),
      ),
    );
  }

  Widget _card(
      {required String title, String? subtitle, required Widget child}) {
    return SizedBox(
      width: double.infinity,
      child: Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: Theme.of(Get.context!).colorScheme.onPrimary,
          borderRadius: BorderRadius.circular(10),
          border: Border.all(color: Colors.grey.withOpacity(0.3)),
        ),
        child: Column(
          children: [
            Text(title.toUpperCase(), style: Get.textTheme.titleSmall),
            SizedBox(height: 10),
            if (subtitle != null) ...[
              Text(subtitle, style: Get.textTheme.bodySmall),
              SizedBox(height: 20),
            ],
            child
          ],
        ),
      ),
    );
  }
}
