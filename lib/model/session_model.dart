import 'package:albedo_app/config/utils.dart';
import 'package:albedo_app/model/batch_model.dart';
import 'package:albedo_app/model/package_model.dart';
import 'package:albedo_app/model/users/advisor_model.dart';
import 'package:albedo_app/model/users/coordinator_model.dart';
import 'package:albedo_app/model/users/mentor_model.dart';
import 'package:albedo_app/model/users/student_model.dart';
import 'package:albedo_app/model/users/teacher_model.dart';
import 'package:flutter/material.dart';

class Session {
  final String id;

  Student? student;
  Batch? batch;
  Package? package;
  Teacher? teacher;
  Mentor? mentor;
  Coordinator? coordinator;
  Advisor? advisor;

  DateTime? sessionDate;
  TimeOfDay? startTime;
  TimeOfDay? endTime;
  Duration? duration;

  bool? isCompleted;
  bool? needsAction;

  String? teacherNote;
  String? topic;
  String? scheduleType;

  String? googleMeetLink;

  String? remainingTime;
  String? remainingTimeToEnd;

  String? studentTimezoneStartTime;
  String? studentTimezoneEndTime;

  String? teacherTimezoneStartTime;
  String? teacherTimezoneEndTime;

  String? istStartTime;
  String? istEndTime;

  String? reason;

  DateTime? completedAt;
  CompletedBy? completedBy;

  List<String>? actionReasons;

  List<Teacher>? teacherAssignments;

  List<dynamic>? fileAttachments;
  List<dynamic>? voiceNotes;

  String status;

  double? teacherSalary;

  Session({
    required this.id,
    this.student,
    this.batch,
    this.package,
    this.teacher,
    this.mentor,
    this.coordinator,
    this.advisor,
    this.sessionDate,
    this.startTime,
    this.endTime,
    this.duration,
    this.isCompleted,
    this.needsAction,
    this.teacherNote,
    this.topic,
    this.scheduleType,
    this.googleMeetLink,
    this.remainingTime,
    this.remainingTimeToEnd,
    this.studentTimezoneStartTime,
    this.studentTimezoneEndTime,
    this.teacherTimezoneStartTime,
    this.teacherTimezoneEndTime,
    this.istStartTime,
    this.istEndTime,
    this.reason,
    this.completedAt,
    this.completedBy,
    this.actionReasons,
    this.teacherAssignments,
    this.fileAttachments,
    this.voiceNotes,
    required this.status,
    this.teacherSalary,
  });

  factory Session.fromJson(Map<String, dynamic> json) {
    return Session(
      id: json['id'] ?? '',
      sessionDate: json['session_date'] != null
          ? DateTime.tryParse(json['session_date'])
          : null,
      startTime: parseTimeOfDay(json['start_time']),
      endTime: parseTimeOfDay(json['end_time']),
      duration: parseDuration(json['duration']),
      isCompleted: json['is_completed'],
      needsAction: json['needs_action'],
      teacherNote: json['teacher_note'],
      topic: json['topic'],
      scheduleType: json['schedule_type'],
      remainingTime: json['remaining_time'],
      remainingTimeToEnd: json['remaining_time_to_end'],
      studentTimezoneStartTime: json['student_timezone_start_time'],
      studentTimezoneEndTime: json['student_timezone_end_time'],
      teacherTimezoneStartTime: json['teacher_timezone_start_time'],
      teacherTimezoneEndTime: json['teacher_timezone_end_time'],
      istStartTime: json['ist_start_time'],
      istEndTime: json['ist_end_time'],
      reason: json['reason'],
      completedAt: json['completed_at'] != null
          ? DateTime.parse(json['completed_at'])
          : null,
      completedBy: json['completed_by'] != null
          ? CompletedBy.fromJson(json['completed_by'])
          : null,
      actionReasons: json['action_reasons'] != null
          ? List<String>.from(json['action_reasons'])
          : [],
      student: json['class_session']?['student'] != null
          ? Student.fromJson(json['class_session']['student'])
          : null,
      package: json['class_session']?['package'] != null
          ? Package.fromJson(json['class_session']['package'])
          : null,
      googleMeetLink: json['class_session']?['google_meet_link'],
      teacher:
          json['teacher'] != null ? Teacher.fromJson(json['teacher']) : null,
      teacherAssignments: json['teacher_assignments'] != null
          ? (json['teacher_assignments'] as List)
              .map((e) => Teacher.fromJson(e))
              .toList()
          : [],
      fileAttachments: json['file_attachments'] ?? [],
      voiceNotes: json['voice_notes'] ?? [],
      status: json['reason'] ?? '',
    );
  }
}

class SessionDetail {
  final String id;

  final Student? student;
  final Package? package;
  final Teacher? teacher;

  final String? googleMeetLink;

  final DateTime? sessionDate;
  final TimeOfDay? startTime;
  final TimeOfDay? endTime;
  final Duration? duration;

  final bool isCompleted;
  final bool isPaid;
  final bool studentPaidForSession;

  final String? remainingTime;
  final String? remainingTimeToEnd;

  final String? studentTimezoneStartTime;
  final String? studentTimezoneEndTime;

  final String? teacherTimezoneStartTime;
  final String? teacherTimezoneEndTime;

  final String? istStartTime;
  final String? istEndTime;

  final String? teacherNote;
  final String? topic;

  final double? teacherSalary;

  final DateTime? completedAt;
  final CompletedBy? completedBy;

  final List<dynamic> fileAttachments;
  final List<dynamic> voiceNotes;

  final List<ReportAuditLog> reportAuditLogs;

  final int meetParticipantsCount;
  final List<dynamic> meetParticipants;

  SessionDetail({
    required this.id,
    this.student,
    this.package,
    this.teacher,
    this.googleMeetLink,
    this.sessionDate,
    this.startTime,
    this.endTime,
    this.duration,
    required this.isCompleted,
    required this.isPaid,
    required this.studentPaidForSession,
    this.remainingTime,
    this.remainingTimeToEnd,
    this.studentTimezoneStartTime,
    this.studentTimezoneEndTime,
    this.teacherTimezoneStartTime,
    this.teacherTimezoneEndTime,
    this.istStartTime,
    this.istEndTime,
    this.teacherNote,
    this.topic,
    this.teacherSalary,
    this.completedAt,
    this.completedBy,
    required this.fileAttachments,
    required this.voiceNotes,
    required this.reportAuditLogs,
    required this.meetParticipants,
    required this.meetParticipantsCount,
  });

  factory SessionDetail.fromJson(Map<String, dynamic> json) {
    return SessionDetail(
      id: json['id'] ?? '',
      student: json['class_session']?['student'] != null
          ? Student.fromJson(json['class_session']['student'])
          : null,
      package: json['class_session']?['package'] != null
          ? Package.fromJson(json['class_session']['package'])
          : null,
      teacher:
          json['teacher'] != null ? Teacher.fromJson(json['teacher']) : null,
      googleMeetLink: json['class_session']?['google_meet_link'] ??
          json['google_meet_link'],
      sessionDate: json['session_date'] != null
          ? DateTime.tryParse(json['session_date'])
          : null,
      startTime: parseTimeOfDay(json['start_time']),
      endTime: parseTimeOfDay(json['end_time']),
      duration: parseDuration(json['duration']),
      isCompleted: json['is_completed'] ?? false,
      isPaid: json['is_paid'] ?? false,
      studentPaidForSession: json['student_paid_for_session'] ?? false,
      remainingTime: json['remaining_time'],
      remainingTimeToEnd: json['remaining_time_to_end'],
      studentTimezoneStartTime: json['student_timezone_start_time'],
      studentTimezoneEndTime: json['student_timezone_end_time'],
      teacherTimezoneStartTime: json['teacher_timezone_start_time'],
      teacherTimezoneEndTime: json['teacher_timezone_end_time'],
      istStartTime: json['ist_start_time'],
      istEndTime: json['ist_end_time'],
      teacherNote: json['teacher_note'],
      topic: json['topic'],
      teacherSalary: json['teacher_salary'] != null
          ? double.tryParse(json['teacher_salary'].toString())
          : null,
      completedAt: json['completed_at'] != null
          ? DateTime.tryParse(json['completed_at'])
          : null,
      completedBy: json['completed_by_details'] != null
          ? CompletedBy.fromJson(
              json['completed_by_details'],
            )
          : null,
      fileAttachments: json['file_attachments'] ?? [],
      voiceNotes: json['voice_notes'] ?? [],
      reportAuditLogs: (json['report_audit_logs'] as List?)
              ?.map(
                (e) => ReportAuditLog.fromJson(e),
              )
              .toList() ??
          [],
      meetParticipants: json['meet_participants'] ?? [],
      meetParticipantsCount: json['meet_participants_count'] ?? 0,
    );
  }
}

class ReportAuditLog {
  final String id;
  final String action;
  final String actorRole;
  final String actorName;
  final List<String> changedFields;
  final DateTime? changedAt;

  ReportAuditLog({
    required this.id,
    required this.action,
    required this.actorRole,
    required this.actorName,
    required this.changedFields,
    this.changedAt,
  });

  factory ReportAuditLog.fromJson(
    Map<String, dynamic> json,
  ) {
    return ReportAuditLog(
      id: json['id'] ?? '',
      action: json['action'] ?? '',
      actorRole: json['actor_role'] ?? '',
      actorName: json['actor_name'] ?? '',
      changedFields: List<String>.from(json['changed_fields'] ?? []),
      changedAt: json['changed_at'] != null
          ? DateTime.tryParse(json['changed_at'])
          : null,
    );
  }
}

class CompletedBy {
  final int? id;
  final String? email;

  CompletedBy({
    this.id,
    this.email,
  });

  factory CompletedBy.fromJson(Map<String, dynamic> json) {
    return CompletedBy(
      id: json['id'],
      email: json['email'],
    );
  }
}

class PaginatedSessionResponse {
  final int count;
  final String? next;
  final String? previous;
  final List<Session> results;

  PaginatedSessionResponse({
    required this.count,
    required this.results,
    this.next,
    this.previous,
  });
}

class SessionReport {
  final String studentName;
  final String studentId;
  final Package package;
  final String sessionDate;
  String? duration;
  String? batchId;

  bool isCompleted;

  // Completed fields
  String? topicsCovered;
  String? teacherNotes;
  String? startTime;

  // Not completed
  String? reason;

  SessionReport({
    required this.studentName,
    required this.studentId,
    required this.package,
    required this.sessionDate,
    required this.duration,
    this.isCompleted = false,
    this.topicsCovered,
    this.batchId,
    this.teacherNotes,
    this.startTime,
    this.reason,
  });
}

class BatchSessionReport {
  final List<Student> students;
  final Package package;
  final String sessionDate;
  final String duration;
  final bool isCompleted;

  BatchSessionReport({
    required this.students,
    required this.package,
    required this.sessionDate,
    required this.duration,
    required this.isCompleted,
  });
}

class SortOption<T> {
  final String label;
  final T value;
  final IconData icon;

  SortOption({
    required this.label,
    required this.value,
    required this.icon,
  });
}

class FilterOption<T> {
  final String label;
  final T value;
  final IconData icon;

  FilterOption({
    required this.label,
    required this.value,
    required this.icon,
  });
}
