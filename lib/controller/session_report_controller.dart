import 'package:albedo_app/model/session_model.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class SessionReportController extends GetxController {
  RxBool isCompleted = false.obs;

  final reasonCtrl = TextEditingController();
  final topicCtrl = TextEditingController();
  final notesCtrl = TextEditingController();
  final startTimeCtrl = TextEditingController();
  final durationCtrl = TextEditingController();
  var selectedTime = Rxn<TimeOfDay>();

  final durationOptions = [30, 45, 60, 75, 90, 105, 120];


  SessionReport? report;

  Function(SessionReport)? onSave;

  void init({
    Session? session,
    SessionReport? existingReport,
  }) {
    if (existingReport != null) {
      report = existingReport;

      isCompleted.value = existingReport.isCompleted;

      reasonCtrl.text = existingReport.reason ?? "";
      topicCtrl.text = existingReport.topicsCovered ?? "";
      notesCtrl.text = existingReport.teacherNotes ?? "";
      startTimeCtrl.text = existingReport.startTime ?? "";
      durationCtrl.text = existingReport.duration ?? "";
    } else {
      initFromSession(session!);
    }
  }

  void initFromSession(Session session) {
    report = SessionReport(
      studentName: session.student?.name ?? "",
      studentId: session.student?.studentId ?? "",
      package: session.package ?? "",
      sessionDate: session.date.toString(),
      duration: session.duration?.toString() ?? "",
      isCompleted: false,
    );

    isCompleted.value = report!.isCompleted;

    // optional reset
    _clearFields();
  }

  void toggleStatus(bool value) {
    isCompleted.value = value;
  }

  void saveReport() {
    final current = report;
    if (current == null) return;

    current.isCompleted = isCompleted.value;

    if (isCompleted.value) {
      current.topicsCovered = topicCtrl.text;
      current.teacherNotes = notesCtrl.text;
      current.startTime = startTimeCtrl.text;
      current.duration = durationCtrl.text;
    } else {
      current.reason = reasonCtrl.text;
    }

    onSave?.call(current);

    Get.back();
  }

  void _clearFields() {
    reasonCtrl.clear();
    topicCtrl.clear();
    notesCtrl.clear();
    startTimeCtrl.clear();
    durationCtrl.clear();
  }

  @override
  void onClose() {
    reasonCtrl.dispose();
    topicCtrl.dispose();
    notesCtrl.dispose();
    startTimeCtrl.dispose();
    durationCtrl.dispose();
    super.onClose();
  }
}
