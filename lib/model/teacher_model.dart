import 'package:flutter/material.dart';

class Teacher {
  final String id;
  final String name;
  final String email;
  final String status;
  final String gender;
  final String type; // Batch / TBA
  final DateTime joinedAt;
  final String phone;
  String? whatsapp;
  String? dob;
  String? qualification;
  String? place;
  String? pincode;
  String? address;
  String? timezone;
  String? prefLanguage;
  String? tuitionMode;
  String? accountNumber;
  String? accountHolder;
  String? upiId;
  String? accountType;
  String? bankName;
  String? bankBranch;
  int? totalStudents;
  int? totalPackages;
  int? salary;
  int? paid;
  double? balance;
  double? totalSessions;
  double? totalHours;

  Teacher(
      {required this.id,
      required this.name,
      required this.email,
      required this.status,
      required this.type,
      required this.joinedAt,
      required this.phone,
      required this.gender,
      this.whatsapp,
      this.totalStudents,
      this.totalPackages,
      this.totalSessions,
      this.totalHours,
      this.salary,
      this.paid,
      this.balance,
      this.accountHolder,
      this.accountNumber,
      this.accountType,
      this.address,
      this.bankBranch,
      this.bankName,
      this.dob,
      this.pincode,
      this.place,
      this.prefLanguage,
      this.qualification,
      this.timezone,
      this.tuitionMode,
      this.upiId});
}

class ExperienceModel {
  TextEditingController? companyController = TextEditingController();
  TextEditingController? yearController = TextEditingController();
  TextEditingController? monthController = TextEditingController();

  ExperienceModel(
      {this.companyController, this.monthController, this.yearController});
}
