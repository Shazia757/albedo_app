import 'package:albedo_app/model/users/advisor_model.dart';
import 'package:albedo_app/model/users/coordinator_model.dart';
import 'package:albedo_app/model/users/mentor_model.dart';
import 'package:albedo_app/model/users/student_model.dart';
import 'package:albedo_app/model/users/teacher_model.dart';
import 'package:flutter/material.dart';

class Session {
  final String id;
  Student? student;
  final String package;
  final String syllabus;
  final String className;
  Teacher? teacher;
  Mentor? mentor;
  Coordinator? coordinator;
  Advisor? advisor;

  final DateTime date;
  final TimeOfDay time;
  final String status;
  int? duration;
  double? teacherSalary;

  Session({
    required this.id,
    this.student,
    required this.package,
    required this.syllabus,
    required this.className,
    this.teacher,
    required this.date,
    required this.time,
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
  final String package;
  final String sessionDate;
   String? duration;

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
    this.teacherNotes,
    this.startTime,
    this.reason,
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
