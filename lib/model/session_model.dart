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
  String? syllabus;
 String? className;
  Teacher? teacher;
  Mentor? mentor;
  Coordinator? coordinator;
  Advisor? advisor;
  String? startTime;
  String? endTime;
  bool? isCompleted;
  bool? needsAction;
  String? remainingTime;
  String? remainingTimeToEnd;
  String? scheduleType;
  String? topic;
  String? googleMeetLink;

   DateTime? date;
   String status;
  int? duration;
  double? teacherSalary;

  Session({
    required this.id,
    this.student,
     this.package,
     this.batch,
     this.startTime,
     this.endTime,
     this.syllabus,
     this.className,
    this.teacher,
     this.date,
    required this.status,
    this.advisor,
    this.coordinator,
    this.mentor,
    this.duration,
    this.teacherSalary,
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
