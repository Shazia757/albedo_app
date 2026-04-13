import 'package:flutter/material.dart';

class Teacher {
  final String id;
  final String name;
  final String email;
  final String status;
  final String type; // Batch / TBA
  final DateTime joinedAt;
  final String phone;
  int? totalStudents;
  int? totalPackages;
  int? salary;
  int? paid;
  double? balance;
  double? totalSessions;
  double? totalHours;

  Teacher({
    required this.id,
    required this.name,
    required this.email,
    required this.status,
    required this.type,
    required this.joinedAt,
    required this.phone,
    this.totalStudents,
    this.totalPackages,
    this.totalSessions,
    this.totalHours,
    this.salary,
    this.paid,
    this.balance,
  });
}

class ExperienceModel {
  TextEditingController? companyController = TextEditingController();
  TextEditingController? yearController = TextEditingController();
  TextEditingController? monthController = TextEditingController();

  ExperienceModel(
      {this.companyController, this.monthController, this.yearController});
}
