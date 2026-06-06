import 'package:albedo_app/model/batch_model.dart';
import 'package:albedo_app/model/users/coordinator_model.dart';
import 'package:albedo_app/model/users/mentor_model.dart';
import 'package:albedo_app/model/users/student_model.dart';
import 'package:albedo_app/model/wallet_model.dart';

class Teacher {
  final String id;
  String? teacherId;
  final String name;
  String? email;
  String? imageUrl;
  List<Student>? student;

  String? status;
  String? gender;
  String? type;
  DateTime? joinedAt;
  String? phone;
  String? whatsapp;
  String? dob;
  String? mode;
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
      this.status,
      this.teacherId,
      this.imageUrl,
      this.student,
      this.mode,
      this.type,
      this.wallet,
      this.batch,
      this.experience,
      this.joinedAt,
      this.phone,
      this.gender,
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

  factory Teacher.fromJson(Map<String, dynamic> json) {
    return Teacher(
      name: json['name'] ?? '',
      joinedAt: json['joinedAt'] != null
          ? DateTime.parse(json['joinedAt'])
          : json['date_added'] != null
              ? DateTime.parse(json['date_added'])
              : null,
      id: json['id'] ?? '',
      teacherId: json['teacher_id'],
      imageUrl: json['photo'],
      email: json['email'],
      phone: json['phone_number'],
      whatsapp: json['whatsapp_number'],
      gender: json['gender'],
      mode: json['mode'],
      mentor: json['mentor'],
      timezone: json['timezone'],
      address: json['address'],
      place: json['place'],
      balance: (json['balance'] as num?)?.toDouble(),
      status: json['status'],
      type: json['type'],
    );
  }
}

class PaginatedTeacherResponse {
  final int count;
  final String? next;
  final String? previous;
  final List<Teacher> results;

  PaginatedTeacherResponse({
    required this.count,
    required this.results,
    this.next,
    this.previous,
  });
}

class Experience {
  String? id;
  String? companyName;
  int? years;
  int? months;

  Experience({
    this.id,
    this.companyName,
    this.years,
    this.months,
  });

  factory Experience.fromJson(Map<String, dynamic> json) {
    return Experience(
      id: json['id'],
      companyName: json['company_name'],
      years: json['years'],
      months: json['months'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'company_name': companyName,
      'years': years,
      'months': months,
    };
  }
}