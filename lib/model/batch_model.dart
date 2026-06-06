import 'package:albedo_app/config/utils.dart';
import 'package:albedo_app/model/package_model.dart';
import 'package:albedo_app/model/payment_model.dart';
import 'package:albedo_app/model/session_model.dart';
import 'package:albedo_app/model/users/coordinator_model.dart';
import 'package:albedo_app/model/users/mentor_model.dart';
import 'package:albedo_app/model/users/student_model.dart';
import 'package:albedo_app/model/users/teacher_model.dart';
import 'package:flutter/material.dart';

class BatchSession {
  String? id;
  String? batchID;
  String? batchName;

  /// From session response
  String? packageName;
  String? syllabus;

  bool? isLive;
  bool? isCompleted;
  String? mode;
  double? salaryPerHour;

  List<Student>? students;
  Teacher? teachers;

  /// Session fields
  String? googleMeetLink;

  List<PaymentItem>? payment;
  List? materials;

  String? imageUrl;

  int? totalFee;
  int? totalPaid;
  int? balance;
  int? expenseRatio;
  Duration? duration;

  Mentor? mentor;
  Coordinator? coordinator;

  final String? coordinatorId;

  Package? package;

  final DateTime? date;
  TimeOfDay? startTime;
  TimeOfDay? endTime;

  String? amountPaid;
  DateTime? paidDate;

  BatchSession({
    this.id,
    this.batchID,
    this.batchName,
    this.packageName,
    this.syllabus,
    this.googleMeetLink,
    this.materials,
    this.paidDate,
    this.mode,
    this.isLive,
    this.isCompleted,
    this.amountPaid,
    this.balance,
    this.students,
    this.teachers,
    this.totalFee,
    this.totalPaid,
    this.expenseRatio,
    this.payment,
    this.coordinatorId,
    this.coordinator,
    this.imageUrl,
    this.mentor,
    this.duration,
    this.package,
    this.salaryPerHour,
    this.date,
    this.startTime,
    this.endTime,
  });

  factory BatchSession.fromJson(Map<String, dynamic> json) {
    /// Handles both:
    /// 1. Direct batch response
    /// 2. batch_session -> batch_package response

    final batchData = json['batch_session']['batch_package']['batch'] ?? json;

    return BatchSession(
      id: json['id'] ?? '',
      batchID: batchData['code'],
      batchName: batchData['name'],

      isLive: batchData['is_live'],
      isCompleted: json['is_completed'],
      duration: parseDuration(json['duration']),

      /// Package info
      packageName: json['batch_session']['batch_package']['package_name'],
      syllabus: json['batch_session']['batch_package']['syllabus'],

      /// Meet link
      googleMeetLink: json['google_meet_link'],
      salaryPerHour: double.tryParse(
        json['teacher_assignment_details']?['salary_per_hour']?.toString() ??
            '',
      ),

      /// Mentor
      mentor: batchData['mentor_details'] != null
          ? Mentor.fromJson(batchData['mentor_details'])
          : null,
      teachers: json['teacher'] != null
          ? Teacher.fromJson(json['teacher'])
          : batchData['teacher'] != null
              ? Teacher.fromJson(batchData['teacher'])
              : null,

      /// Students from student_assignments
      students: batchData['student_assignments'] != null
          ? List<Student>.from(
              batchData['student_assignments'].map(
                (x) => Student.fromJson(x['student']),
              ),
            )
          : batchData['students'] != null
              ? List<Student>.from(
                  batchData['students'].map(
                    (x) => Student.fromJson(x),
                  ),
                )
              : [],

      /// Packages
      package: json['batch_session_details']?['batch_package'] != null
          ? Package.fromJson(
              json['batch_session_details']['batch_package'],
            )
          : null,

      date: json['date'] != null ? DateTime.tryParse(json['date']) : null,

      startTime: parseTimeOfDay(json['start_time']),
      endTime: parseTimeOfDay(json['end_time']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'code': batchID,
      'name': batchName,
      'package_name': packageName,
      'syllabus': syllabus,
      'google_meet_link': googleMeetLink,
      'duration': duration == null
          ? null
          : '${duration!.inHours}:${(duration!.inMinutes % 60).toString().padLeft(2, '0')}:${(duration!.inSeconds % 60).toString().padLeft(2, '0')}',
      'is_live': isLive,
      'is_completed': isCompleted,
      'mentor_details': mentor?.toJson(),
      'students': students?.map((e) => e.toJson()).toList(),
      // 'packages': packages?.map((e) => e.toJson()).toList(),
      'date': date?.toIso8601String(),
      'start_time': startTime,
      'end_time': endTime,
    };
  }
}

class BatchSessionDetail {
  final String id;

  final Batch? batch;
  final BatchPackage? package;
  final Teacher? teacher;

  final String? googleMeetLink;

  final DateTime? sessionDate;
  final TimeOfDay? startTime;
  final Duration? duration;

  final bool isCompleted;

  final String? teacherNote;
  final String? topic;

  final double? teacherSalary;

  final DateTime? completedAt;
  final CompletedBy? completedBy;

  final List<ReportAuditLog> reportAuditLogs;

  BatchSessionDetail({
    required this.id,
    this.batch,
    this.package,
    this.teacher,
    this.googleMeetLink,
    this.sessionDate,
    this.startTime,
    this.duration,
    required this.isCompleted,
    this.teacherNote,
    this.topic,
    this.teacherSalary,
    this.completedAt,
    this.completedBy,
    required this.reportAuditLogs,
  });

  factory BatchSessionDetail.fromJson(Map<String, dynamic> json) {
    final batchSessionDetails = json['batch_session_details'];
    final batchPackage = batchSessionDetails?['batch_package'];

    return BatchSessionDetail(
      id: json['id'] ?? '',
      batch: batchPackage?['batch_details'] != null
          ? Batch.fromJson(batchPackage['batch_details'])
          : null,
      package:
          batchPackage != null ? BatchPackage.fromJson(batchPackage) : null,
      teacher: batchPackage?['teacher_details'] != null
          ? Teacher.fromJson(batchPackage['teacher_details'])
          : null,
      googleMeetLink: batchSessionDetails?['google_meet_link'] ??
          batchPackage?['google_meet_link'],
      sessionDate: json['session_date'] != null
          ? DateTime.tryParse(json['session_date'])
          : null,
      startTime: parseTimeOfDay(json['start_time']),
      duration: parseDuration(json['duration']),
      isCompleted: json['is_completed'] ?? false,
      teacherNote: json['teacher_notes'],
      topic: json['topic'],
      teacherSalary: json['teacher_assignment_details']?['salary_per_hour'] !=
              null
          ? double.tryParse(
              json['teacher_assignment_details']['salary_per_hour'].toString(),
            )
          : null,
      completedAt: json['completed_at'] != null
          ? DateTime.tryParse(json['completed_at'])
          : null,
      completedBy: json['completed_by_details'] != null
          ? CompletedBy.fromJson(
              json['completed_by_details'],
            )
          : null,
      reportAuditLogs: (json['report_audit_logs'] as List?)
              ?.map(
                (e) => ReportAuditLog.fromJson(
                  e as Map<String, dynamic>,
                ),
              )
              .toList() ??
          [],
    );
  }
}

class BatchListResponse {
  final int count;
  final List<Batch> results;

  BatchListResponse({
    required this.count,
    required this.results,
  });
}

class PaginatedBatchSessionResponse {
  final int count;
  final String? next;
  final String? previous;
  final List<BatchSession> results;

  PaginatedBatchSessionResponse({
    required this.count,
    required this.results,
    this.next,
    this.previous,
  });
}

class Batch {
  final String? id;
  final String? name;
  final String? code;
  final bool? isLive;

  final Mentor? mentor;

  final String? courseId;
  final String? courseName;

  final DateTime? assignmentDate;
  final double? totalFee;

  final List<Student>? students;
  final List<Package>? packages;

  Batch({
    this.id,
    this.name,
    this.code,
    this.isLive,
    this.mentor,
    this.courseId,
    this.courseName,
    this.assignmentDate,
    this.totalFee,
    this.students,
    this.packages,
  });

  factory Batch.fromJson(Map<String, dynamic> json) {
    return Batch(
      id: json['id'] ?? json['batch_id'],
      name: json['name'] ?? json['batch_name'],
      code: json['code'] ?? json['batch_code'],
      isLive: json['is_live'] ?? json['batch_is_live'],
      mentor: json['mentor_details'] != null
          ? Mentor.fromJson(json['mentor_details'])
          : json['mentor'] != null
              ? Mentor.fromJson(json['mentor'])
              : null,
      courseId: json['course']?['id'],
      courseName: json['course']?['name'],
      assignmentDate: json['assignment_date'] != null
          ? DateTime.tryParse(json['assignment_date'])
          : null,
      totalFee: json['total_fee'] != null
          ? double.tryParse(json['total_fee'].toString())
          : null,
      students: (json['students'] as List?)
              ?.map((e) => Student.fromJson(e))
              .toList() ??
          [],
      packages: (json['packages'] as List?)
              ?.map((e) => Package.fromJson(e))
              .toList() ??
          [],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'code': code,
      'is_live': isLive,
      'course_id': courseId,
      'course_name': courseName,
      'assignment_date': assignmentDate?.toIso8601String(),
      'total_fee': totalFee,
      'mentor': mentor?.toJson(),
      'students': students?.map((e) => e.toJson()).toList(),
      'packages': packages?.map((e) => e.toJson()).toList(),
    };
  }
}

class BatchDetail {
  final String? id;
  final String? name;
  final String? code;
  final Mentor? mentor;
  final FinancialSummary? financialSummary;

  BatchDetail({
    this.id,
    this.name,
    this.code,
    this.mentor,
    this.financialSummary,
  });

  factory BatchDetail.fromJson(Map<String, dynamic> json) {
    return BatchDetail(
      id: json['id'],
      name: json['name'],
      code: json['code'],
      mentor: json['mentor'] != null ? Mentor.fromJson(json['mentor']) : null,
      financialSummary: json['financial_summary'] != null
          ? FinancialSummary.fromJson(json['financial_summary'])
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'code': code,
      'mentor': mentor?.toJson(),
      'financial_summary': financialSummary?.toJson(),
    };
  }

  static List<Batch> fromJsonList(List<dynamic> jsonList) {
    return jsonList
        .map((e) => Batch.fromJson(e as Map<String, dynamic>))
        .toList();
  }
}

class FinancialSummary {
  final double? totalFee;
  final double? totalPaid;
  final double? totalPending;
  final double? totalDeclined;
  final double? balance;
  final int? studentCount;
  final int? pendingCount;
  final int? approvedCount;
  final int? declinedCount;

  FinancialSummary({
    this.totalFee,
    this.totalPaid,
    this.totalPending,
    this.totalDeclined,
    this.balance,
    this.studentCount,
    this.pendingCount,
    this.approvedCount,
    this.declinedCount,
  });

  factory FinancialSummary.fromJson(Map<String, dynamic> json) {
    return FinancialSummary(
      totalFee: (json['total_fee'] ?? 0).toDouble(),
      totalPaid: (json['total_paid'] ?? 0).toDouble(),
      totalPending: (json['total_pending'] ?? 0).toDouble(),
      totalDeclined: (json['total_declined'] ?? 0).toDouble(),
      balance: (json['balance'] ?? 0).toDouble(),
      studentCount: json['student_count'],
      pendingCount: json['pending_count'],
      approvedCount: json['approved_count'],
      declinedCount: json['declined_count'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'total_fee': totalFee,
      'total_paid': totalPaid,
      'total_pending': totalPending,
      'total_declined': totalDeclined,
      'balance': balance,
      'student_count': studentCount,
      'pending_count': pendingCount,
      'approved_count': approvedCount,
      'declined_count': declinedCount,
    };
  }
}
