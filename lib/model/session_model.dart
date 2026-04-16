import 'package:albedo_app/controller/session_controller.dart';
import 'package:flutter/material.dart';

class Session {
  final String id;
  final String studentName;
  final String studentId;
  final String subject;
  final String className;
  final String teacherName;
  final String teacherId;
  final DateTime date;
  final DateTime time;
  final String status;
  int? duration;
  double? teacherSalary;

  Session({
    required this.id,
    required this.studentName,
    required this.studentId,
    required this.subject,
    required this.className,
    required this.teacherName,
    required this.teacherId,
    required this.date,
    required this.time,
    required this.status,
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