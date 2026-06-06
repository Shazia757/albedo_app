import 'package:albedo_app/model/batch_model.dart';
import 'package:albedo_app/model/package_model.dart';
import 'package:albedo_app/model/settings/assessment_model.dart';
import 'package:albedo_app/model/stu_wallet_model.dart';
import 'package:albedo_app/model/users/advisor_model.dart';
import 'package:albedo_app/model/users/coordinator_model.dart';
import 'package:albedo_app/model/users/mentor_model.dart';
import 'package:albedo_app/model/users/user_model.dart';
import 'package:flutter/material.dart';

class Student {
  String? id;
  String? studentId;
  String? phone;
  String? imageUrl;
  String? whatsapp;
  String? parentName;
  String? parentOccupation;
  String? gender;
  String? timezone;
  String? address;
  String? place;
  int? spotFee;
  String? referredBy;
  bool isFeePaid;
  List<Package>? packages;
  List<Assessment>? assessment;
  List<Certificate>? certificate;
  List<Batch>? batches;

  int? classHours;
  int? pincode;
  int? classesTaken;
  int? standard;
  int? totalHour;
  int? totalSession;

  double? amount;
  double? amountPerHour;
  double? totalAmount;
  double? regFee;
  double? totalPaid;
  double? balance;

  String? course;
  String? subjects;
  String? syllabus;
  String? syllabusId;
  String? createdById;
  DateTime? createdAt;
  String? createdByName;

  String? advisorName;
  String? advisorId;
  Coordinator? coordinator;
  Mentor? mentor;
  Advisor? advisor;
  final String? teacherId;

  Users? referral;

  String? status;
  String name;
  String? category;
  String? email;
  DateTime? admissionDate;
  String? type;

  DateTime? joinedAt;

  Student({
    required this.name,
    this.joinedAt,
    this.email,
    this.id,
    this.studentId,
    this.batches,
    this.admissionDate,
    this.assessment,
    this.referral,
    this.certificate,
    this.parentName,
    this.parentOccupation,
    this.status,
    this.spotFee,
    this.packages,
    this.mentor,
    this.teacherId,
    this.imageUrl,
    this.createdAt,
    this.type,
    this.address,
    this.gender,
    this.isFeePaid = false,
    this.timezone,
    this.place,
    this.phone,
    this.whatsapp,
    this.classHours,
    this.classesTaken,
    this.standard,
    this.advisor,
    this.coordinator,
    this.amount,
    this.totalAmount,
    this.referredBy,
    this.totalPaid,
    this.balance,
    this.course,
    this.createdById,
    this.createdByName,
    this.advisorName,
    this.advisorId,
    this.subjects,
    this.syllabusId,
    this.syllabus,
    this.category,
    this.regFee,
    this.amountPerHour,
    this.totalHour,
    this.totalSession,
  });

  factory Student.fromJson(Map<String, dynamic> json) {
    return Student(
      name: json['name'] ?? '',
      joinedAt: json['joinedAt'] != null
          ? DateTime.parse(json['joinedAt'])
          : json['date_added'] != null
              ? DateTime.parse(json['date_added'])
              : null,
      id: json['id'],
      studentId: json['registration_id'],
      imageUrl: json['photo'],
      email: json['email'],
      phone: json['phone_number'],
      whatsapp: json['whatsapp_number'],
      parentName: json['parent_name'],
      parentOccupation: json['parent_occupation'],
      gender: json['gender'],
      createdById: json['creator_profile']?['emp_id'],
      createdByName: json['creator_profile']?['name'],
      mentor: json['mentor_assignment'] is Map<String, dynamic>
          ? Mentor.fromJson(json['mentor_assignment'])
          : json['mentor_assignment'] is List &&
                  (json['mentor_assignment'] as List).isNotEmpty
              ? Mentor.fromJson((json['mentor_assignment'] as List).first)
              : null,
      packages: json['packages'] != null
          ? (json['packages'] as List).map((e) => Package.fromJson(e)).toList()
          : [],
      batches: json['batch_assignment'] != null
          ? (json['batch_assignment'] as List)
              .map((e) => Batch.fromJson(e))
              .toList()
          : [],
      coordinator: json['assistant_admin'] != null
          ? Coordinator.fromJson(json['assistant_admin'])
          : null,
      advisor:
          json['advisor'] != null ? Advisor.fromJson(json['advisor']) : null,
      timezone: json['timezone'],
      address: json['address'],
      place: json['place'],
      referredBy: json['referredBy'],
      classHours: json['classHours'],
      classesTaken: json['classesTaken'],
      category: json['course_profile'] != null
          ? json['course_profile']['category']
          : json['category'],
      standard: int.tryParse(
        (json['course_profile']?['standard'] ?? json['standard'])?.toString() ??
            '',
      ),
      totalHour: json['totalHour'],
      amount: (json['amount'] as num?)?.toDouble(),
      amountPerHour: (json['amountPerHour'] as num?)?.toDouble(),
      totalAmount: (json['totalAmount'] as num?)?.toDouble(),
      regFee: (json['regFee'] as num?)?.toDouble(),
      totalPaid: (json['totalPaid'] as num?)?.toDouble(),
      balance: (json['balance'] as num?)?.toDouble(),
      course: json['course'],
      subjects: json['subjects'],
      syllabus: json['syllabus'],
      status: json['status'],
      admissionDate: json['admissionDate'] != null
          ? DateTime.parse(json['admissionDate'])
          : null,
      createdAt: json['date_added'] != null
          ? DateTime.parse(json['date_added'])
          : null,
      type: json['type'],
      totalSession: json['totalSession'],
    );
  }

  /// 🔹 TO JSON
  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'joinedAt': joinedAt?.toIso8601String(),
      'studentId': studentId,
      'email': email,
      'phone': phone,
      'whatsapp': whatsapp,
      'photo': imageUrl,
      'parentName': parentName,
      'parentOccupation': parentOccupation,
      'gender': gender,
      'mentor_assignment': mentor,
      'timezone': timezone,
      'address': address,
      'place': place,
      'referredBy': referredBy,
      'classHours': classHours,
      'classesTaken': classesTaken,
      'standard': standard,
      'totalHour': totalHour,
      'amount': amount,
      'amountPerHour': amountPerHour,
      'totalAmount': totalAmount,
      'regFee': regFee,
      'totalPaid': totalPaid,
      'balance': balance,
      'course': course,
      'subjects': subjects,
      'syllabus': syllabus,
      'advisorName': advisorName,
      'advisorId': advisorId,
      'status': status,
      'category': category,
      'admissionDate': admissionDate?.toIso8601String(),
      'type': type,
      'totalSession': totalSession,
    };
  }

  /// 🔹 COPY WITH (for edit screens)
  Student copyWith({
    String? name,
    String? email,
    String? phone,
    String? status,
  }) {
    return Student(
      name: name ?? this.name,
      joinedAt: joinedAt,
      email: email ?? this.email,
      phone: phone ?? this.phone,
      status: status ?? this.status,
      studentId: studentId,
    );
  }
}

class PaginatedStudentResponse {
  final int count;
  final String? next;
  final String? previous;
  final List<Student> results;

  PaginatedStudentResponse({
    required this.count,
    required this.results,
    this.next,
    this.previous,
  });
}

class Certificate {}
