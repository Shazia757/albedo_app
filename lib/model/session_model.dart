import 'package:flutter/material.dart';

class Session {
  final String id;
  final String studentName;
  final String studentId;
  final String package;
  final String syllabus;
  final String className;
  final String teacherName;
  final String teacherId;
  final String mentorName;
  final String mentorId;
  final String? coordinatorName;
  final String? coordinatorId;
  final String? advisorName;
  final String? advisorId;

  final DateTime date;
  final DateTime time;
  final String status;
  int? duration;
  double? teacherSalary;

  Session({
    required this.id,
    required this.studentName,
    required this.studentId,
    required this.package,
    required this.syllabus,
    required this.className,
    required this.teacherName,
    required this.teacherId,
    required this.date,
    required this.time,
    required this.status,
    this.advisorId,
    this.advisorName,
    this.coordinatorId,
    this.coordinatorName,
    required this.mentorId,
    required this.mentorName,
    this.duration,
    this.teacherSalary,
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
