import 'package:albedo_app/controller/session_report_controller.dart';
import 'package:albedo_app/model/session_model.dart';
import 'package:albedo_app/widgets/widgets.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class SessionReportDialogBody extends StatelessWidget {
  final SessionReportController controller;

  const SessionReportDialogBody({
    super.key,
    required this.controller,
  });

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;

    return Obx(() {
      final isCompleted = controller.isCompleted.value;
      final r = controller.report;

      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // ───────── STUDENT CARD ─────────
          _StudentInfoCard(report: r!),

          const SizedBox(height: 16),

          // ───────── STATUS SECTION ─────────
          _SectionTitle(icon: Icons.flag_outlined, title: "Session Status"),

          const SizedBox(height: 8),

          _StatusToggle(
            isCompleted: isCompleted,
            onChanged: controller.toggleStatus,
          ),

          const SizedBox(height: 16),

          // ───────── CONDITIONAL FIELDS ─────────
          if (!isCompleted) _NotCompletedSection(controller: controller),

          if (isCompleted) _CompletedSection(controller: controller),

          const SizedBox(height: 16),

          // ───────── ATTACHMENTS ─────────
          _SectionTitle(icon: Icons.attach_file, title: "Attachments"),

          const SizedBox(height: 10),

          CustomWidgets().attachmentStyledField(
            context: context,
            hint: 'Upload files (optional)',
          ),
        ],
      );
    });
  }
}

class _SectionTitle extends StatelessWidget {
  final IconData icon;
  final String title;

  const _SectionTitle({
    required this.icon,
    required this.title,
  });

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;

    return Row(
      children: [
        Icon(icon, size: 18, color: cs.primary),
        const SizedBox(width: 6),
        Text(
          title,
          style: TextStyle(
            fontWeight: FontWeight.w600,
            color: cs.primary,
          ),
        ),
      ],
    );
  }
}

class _StatusToggle extends StatelessWidget {
  final bool isCompleted;
  final Function(bool) onChanged;

  const _StatusToggle({
    required this.isCompleted,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;

    return Container(
      padding: const EdgeInsets.all(6),
      decoration: BoxDecoration(
        color: cs.surface,
        borderRadius: BorderRadius.circular(30),
        border: Border.all(color: cs.outlineVariant.withOpacity(0.3)),
      ),
      child: Row(
        children: [
          Expanded(
            child: GestureDetector(
              onTap: () => onChanged(true),
              child: Container(
                padding: const EdgeInsets.symmetric(vertical: 10),
                decoration: BoxDecoration(
                  color: isCompleted ? cs.primary : Colors.transparent,
                  borderRadius: BorderRadius.circular(20),
                ),
                alignment: Alignment.center,
                child: Text(
                  "Completed",
                  style: TextStyle(
                    color: isCompleted ? Colors.white : cs.onSurface,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
            ),
          ),
          Expanded(
            child: GestureDetector(
              onTap: () => onChanged(false),
              child: Container(
                padding: const EdgeInsets.symmetric(vertical: 10),
                decoration: BoxDecoration(
                  color: !isCompleted ? cs.error : Colors.transparent,
                  borderRadius: BorderRadius.circular(20),
                ),
                alignment: Alignment.center,
                child: Text(
                  "Not Completed",
                  style: TextStyle(
                    color: !isCompleted ? Colors.white : cs.onSurface,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _CompletedSection extends StatelessWidget {
  final SessionReportController controller;

  const _CompletedSection({required this.controller});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        _input("Topics Covered", controller.topicCtrl, context),
        _input("Teacher Notes", controller.notesCtrl, context, multiline: true),
        CustomWidgets().labelWithAsterisk('Start Time'),
        const SizedBox(height: 8),
        CustomWidgets().timePickerStyledField(
            hint: "Start Time",
            controller: controller.startTimeCtrl,
            context: context,
            selectedTime: controller.selectedTime),
        const SizedBox(height: 8),
        CustomWidgets().labelWithAsterisk('Duration'),
        const SizedBox(height: 8),
        CustomWidgets().customDropdownField(
          hint: "Duration",
          context: context,
          items: controller.durationOptions,
          onChanged: (p0) {},
        ),
      ],
    );
  }

  Widget _input(String label, TextEditingController c, BuildContext context,
      {bool multiline = false}) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          CustomWidgets().labelWithAsterisk(label),
          const SizedBox(height: 8),
          CustomWidgets().dropdownStyledTextField(
            context: context,
            hint: label,
            controller: c,
            isMultiline: multiline,
          ),
        ],
      ),
    );
  }
}

class _NotCompletedSection extends StatelessWidget {
  final SessionReportController controller;

  const _NotCompletedSection({required this.controller});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        CustomWidgets().labelWithAsterisk('Reason for not completing'),
        const SizedBox(height: 8),
        CustomWidgets().dropdownStyledTextField(
          context: context,
          hint: "Enter reason",
          controller: controller.reasonCtrl,
        ),
      ],
    );
  }
}

class _StudentInfoCard extends StatelessWidget {
  final SessionReport report;

  const _StudentInfoCard({required this.report});

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;

    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: cs.surface,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: cs.outlineVariant.withOpacity(0.3)),
      ),
      child: Row(
        children: [
          CircleAvatar(
            radius: 24,
            backgroundColor: cs.primary.withOpacity(0.1),
            child: Icon(Icons.person, color: cs.primary),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  report.studentName,
                  style: const TextStyle(
                    fontWeight: FontWeight.w600,
                    fontSize: 15,
                  ),
                ),
                const SizedBox(height: 4),
                Text("ID: ${report.studentId}"),
                Text("Package: ${report.package}"),
                Text("Duration: ${report.duration}"),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
