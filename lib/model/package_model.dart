import 'package:albedo_app/config/utils.dart';
import 'package:albedo_app/model/session_model.dart';
import 'package:albedo_app/model/settings/hiring_ad_model.dart';
import 'package:albedo_app/model/users/teacher_model.dart';
import 'package:albedo_app/model/wallet_model.dart';
import 'package:flutter/material.dart';

class Package {
  String? id;

  /// API fields
  String? packageName;
  String? syllabus;

  /// Existing fields
  List<Session>? sessions;
  String? name;
  String? course;
  DateTime? enrolledAt;
  Teacher? teacher;
  double? expenseRatio;
  DateTime? date;

  Days? days;

  String? mode;
  int? numberOfClasses;
  int? sessionsTotal;
  int? sessionsCompleted;

  double? timeCompleted;
  double? timeTotal;

  String? couponCode;

  String? subjectId;
  String? subjectName;
  String? standard;
  String? category;

  String? status;

  double? teacherSalaryPerHour;
  double? studentFeePerHour;
  double? packageFee;
  double? balance;

  double? hourlyRate;

  String? time;
  String? duration;
  int? durationDays;

  String? note;

  List<Withdrawal>? withdrawals;
  String? packageCode;
  String? scheduleType;
  TimeOfDay? classTime;
  Map<String, dynamic>? classTimes;

  List<String>? daysIncluded;
  List<dynamic>? customDates;

  bool? isRepackage;
  bool? actionDue;
  bool? isRefunded;
  bool? hasIncompleteClasses;
  bool? isActive;

  String? completedSessions;
  String? totalMinutes;

  double? totalFee;
  double? totalPaidFee;
  double? refundableAmount;
  double? packageRefundAmount;
  double? completedTeacherSalary;
  double? classTakenAmount;

  int? totalSessions;
  int? daysRemaining;

  String? googleMeetLink;
  String? googleEventId;

  DateTime? dateAdded;
  DateTime? dateUpdated;

  Map<String, dynamic>? calendarEventsStatus;

  Package({
    this.id,
    this.packageName,
    this.syllabus,
    this.name,
    this.mode,
    this.sessions,
    this.course,
    this.days,
    this.category,
    this.date,
    this.duration,
    this.couponCode,
    this.expenseRatio,
    this.durationDays,
    this.studentFeePerHour,
    this.teacherSalaryPerHour,
    this.numberOfClasses,
    this.teacher,
    this.hourlyRate,
    this.sessionsCompleted,
    this.sessionsTotal,
    this.subjectId,
    this.timeCompleted,
    this.timeTotal,
    this.subjectName,
    this.standard,
    this.status,
    this.packageFee,
    this.balance,
    this.withdrawals,
    this.time,
    this.note,
    this.enrolledAt,
    this.packageCode,
    this.scheduleType,
    this.classTime,
    this.classTimes,
    this.daysIncluded,
    this.customDates,
    this.isRepackage,
    this.actionDue,
    this.isRefunded,
    this.hasIncompleteClasses,
    this.isActive,
    this.completedSessions,
    this.totalMinutes,
    this.totalFee,
    this.totalPaidFee,
    this.refundableAmount,
    this.packageRefundAmount,
    this.completedTeacherSalary,
    this.classTakenAmount,
    this.totalSessions,
    this.daysRemaining,
    this.googleMeetLink,
    this.googleEventId,
    this.dateAdded,
    this.dateUpdated,
    this.calendarEventsStatus,
  });

  factory Package.fromJson(Map<String, dynamic> json) {
    return Package(
      id: json['id'],
      packageName: json['package_name'] ?? json['name'],
      syllabus: json['syllabus'],
      category: json['category'],
      course: json['course'],
      standard: json['standard'],
      mode: json['mode'],
      status: json['status'],
      packageCode: json['package_code'],
      scheduleType: json['schedule_type'],
      classTime: json['class_time'] != null
          ? parse24TimeOfDay(json['class_time'])
          : null,
      classTimes: json['class_times'],
      duration: json['duration'],
      durationDays: json['duration_days'],
      numberOfClasses: json['number_of_classes'],
      packageFee: parseDouble(json['package_fee']),
      totalFee: parseDouble(json['total_fee']),
      totalPaidFee: parseDouble(json['total_paid_fee']),
      refundableAmount: parseDouble(json['refundable_amount']),
      packageRefundAmount: parseDouble(json['package_refund_amount']),
      completedTeacherSalary: parseDouble(json['completed_teacher_salary']),
      classTakenAmount: parseDouble(json['class_taken_amount']),
      expenseRatio: parseDouble(json['expense_ratio']),
      teacherSalaryPerHour: parseDouble(json['teacher_salary']),
      studentFeePerHour: parseDouble(json['student_fee_per_hour']),
      balance: parseDouble(json['balance']),
      hourlyRate: parseDouble(json['hourly_rate']),
      completedSessions: json['completedSessions'],
      totalMinutes: json['totalMinutes'],
      totalSessions: json['totalSessions'],
      daysRemaining: json['days_remaining'],
      daysIncluded: json['days_included'] != null
          ? List<String>.from(json['days_included'])
          : [],
      customDates: json['custom_dates'] != null
          ? List<dynamic>.from(json['custom_dates'])
          : [],
      isRepackage: json['is_repackage'],
      actionDue: json['action_due'],
      isRefunded: json['is_refunded'],
      hasIncompleteClasses: json['has_incomplete_classes'],
      isActive: json['is_active'],
      googleMeetLink: json['google_meet_link'],
      googleEventId: json['google_event_id'],
      calendarEventsStatus: json['calendar_events_status'],
      dateAdded: json['date_added'] != null
          ? DateTime.tryParse(json['date_added'])
          : null,
      dateUpdated: json['date_updated'] != null
          ? DateTime.tryParse(json['date_updated'])
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'package_name': packageName,
      'syllabus': syllabus,

      'name': name,
      'course': course,
      'mode': mode,
      'category': category,
      'status': status,

      'duration': duration,
      'duration_days': durationDays,
      'coupon_code': couponCode,
      'note': note,
      'time': time,

      'subject_id': subjectId,
      'subject_name': subjectName,
      'standard': standard,

      'expense_ratio': expenseRatio,

      'number_of_classes': numberOfClasses,
      'sessions_total': sessionsTotal,
      'sessions_completed': sessionsCompleted,

      'time_completed': timeCompleted,
      'time_total': timeTotal,

      'teacher_salary_per_hour': teacherSalaryPerHour,
      'student_fee_per_hour': studentFeePerHour,

      'package_fee': packageFee,
      'balance': balance,

      'hourly_rate': hourlyRate,

      'enrolled_at': enrolledAt?.toIso8601String(),
      'date': date?.toIso8601String(),

      // 'sessions': sessions
      //     ?.map((e) => e.toJson())
      //     .toList(),

      // 'withdrawals': withdrawals
      //     ?.map((e) => e.toJson())
      //     .toList(),
    };
  }
}

class PackageShort {
  String? id;

  /// API fields
  String? category;
  String? syllabus;

  PackageShort({
    this.id,
    this.syllabus,
    this.category,
  });

  factory PackageShort.fromJson(Map<String, dynamic> json) {
    return PackageShort(
      /// API response mapping
      id: json['id'],
      syllabus: json['syllabus'],

      category: json['category'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'syllabus': syllabus,
      'category': category,
    };
  }
}

class BatchPackage {
  final String? id;
  final String? batchId;

  final String? packageName;
  final String? packageCode;

  final String? syllabus;
  final String? category;
  final String? standard;

  final int? numberOfClasses;
  final int? durationDays;

  final String? classTime;
  final String? duration;
  final String? scheduleType;

  final List<String> daysIncluded;

  final Teacher? teacher;

  final double? teacherSalary;

  final String? completedSessions;
  final String? completedSessionsHours;

  final int? totalMinutes;
  final int? daysRemaining;

  final String? lastScheduleDate;

  final double? totalEarned;
  final double? totalPaid;
  final double? pendingPayment;

  final String? googleMeetLink;
  final String? googleEventId;

  BatchPackage({
    this.id,
    this.batchId,
    this.packageName,
    this.packageCode,
    this.syllabus,
    this.category,
    this.standard,
    this.numberOfClasses,
    this.durationDays,
    this.classTime,
    this.duration,
    this.scheduleType,
    this.daysIncluded = const [],
    this.teacher,
    this.teacherSalary,
    this.completedSessions,
    this.completedSessionsHours,
    this.totalMinutes,
    this.daysRemaining,
    this.lastScheduleDate,
    this.totalEarned,
    this.totalPaid,
    this.pendingPayment,
    this.googleMeetLink,
    this.googleEventId,
  });

  factory BatchPackage.fromJson(Map<String, dynamic> json) {
    return BatchPackage(
      id: json['id'],
      batchId: json['batch'],
      packageName: json['package_name'],
      packageCode: json['package_code'],
      syllabus: json['syllabus'],
      category: json['category'],
      standard: json['standard'],
      numberOfClasses: json['number_of_classes'],
      durationDays: json['duration_days'],
      classTime: json['class_time'],
      duration: json['duration'],
      scheduleType: json['schedule_type'],
      daysIncluded:
          (json['days_included'] as List?)?.map((e) => e.toString()).toList() ??
              [],
      teacher: json['teacher_details'] != null
          ? Teacher.fromJson(json['teacher_details'])
          : null,
      teacherSalary: double.tryParse(
        json['teacher_salary']?.toString() ?? '',
      ),
      completedSessions: json['completed_sessions'],
      completedSessionsHours: json['completed_sessions_hours'],
      totalMinutes: json['total_minutes'],
      daysRemaining: json['days_remaining'],
      lastScheduleDate: json['last_schedule_date'],
      totalEarned: (json['total_earned'] as num?)?.toDouble(),
      totalPaid: (json['total_paid'] as num?)?.toDouble(),
      pendingPayment: (json['pending_payment'] as num?)?.toDouble(),
      googleMeetLink: json['google_meet_link'],
      googleEventId: json['google_event_id'],
    );
  }
}
