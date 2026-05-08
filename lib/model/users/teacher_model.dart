import 'package:albedo_app/model/batch_model.dart';
import 'package:albedo_app/model/users/coordinator_model.dart';
import 'package:albedo_app/model/users/mentor_model.dart';
import 'package:albedo_app/model/users/student_model.dart';
import 'package:albedo_app/model/wallet_model.dart';
import 'package:flutter/material.dart';

class Teacher {
  final String id;
  final String name;
  String? email;
  String? imageUrl;
  List<Student>? student;

  final String status;
  final String gender;
  String? type;
  final DateTime joinedAt;
  String? phone;
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
  String? ifscCode;
  String? accountType;
  String? bankName;
  String? bankBranch;
  int? totalStudents;
  int? totalPackages;
  int? salary;
    Wallet? wallet;
  int? paid;
  double? balance;
  double? totalSessions;
  double? totalHours;
  Coordinator? coordinator;
  Mentor? mentor;
  List<Batch>? batch;
  List<Experience>? experience;

  Teacher(
      {required this.id,
      required this.name,
      this.email,
      this.ifscCode,
      required this.status,
      this.imageUrl,
      this.student,
      this.type,
      this.wallet,
      this.batch,
      this.experience,
      required this.joinedAt,
      this.phone,
      required this.gender,
      this.whatsapp,
      this.totalStudents,
      this.totalPackages,
      this.coordinator,
      this.mentor,
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

class Experience {
  String? companyName;
  int? months;
  int? years;

  Experience({
    this.companyName,
    this.months,
    this.years,
  });
}
