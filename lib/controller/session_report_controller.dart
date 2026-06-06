import 'package:albedo_app/model/batch_model.dart';
import 'package:albedo_app/model/package_model.dart';
import 'package:albedo_app/model/session_model.dart';
import 'package:albedo_app/model/users/teacher_model.dart';
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
  BatchSessionReport? batchreport;

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
      package: session.package ?? Package(status: 'false'),
      sessionDate: session.sessionDate.toString(),
      duration: session.duration?.toString() ?? "",
      isCompleted: false,
    );

    isCompleted.value = report!.isCompleted;

    // optional reset
    _clearFields();
  }

  void initFromBatchSession(BatchSession session) {
    batchreport = BatchSessionReport(
      students: session.students ?? [],
      // package: session.package ??
      //     BatchPackage(
      //       teacher: Teacher(
      //         id: '',
      //         name: '',
      //         status: '',
      //         joinedAt: DateTime.now(),
      //         gender: '',
      //       ),
      //       subjectId: '',
      //       subjectName: '',
      //       standard: '',
      //       syllabus: '',
      //       status: '',
      //       // packageFee: 0,
      //       takenFee: 0,
      //       balance: 0,
      //       withdrawals: [],
      //       time: '',
      //       duration: '',
      //       note: '',
      //     ),
      package: Package(),
      sessionDate: session.date.toString(),
      duration: session.duration?.toString() ?? "",
      isCompleted: false,
    );

    isCompleted.value = report!.isCompleted;

    _clearFields();
  }

  void toggleStatus(bool value) {
    isCompleted.value = value;
  }

  saveReport() {
    final current = report;
    if (current == null) return null;

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

    return current;
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
