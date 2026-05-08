import 'package:albedo_app/model/batch_model.dart';
import 'package:albedo_app/model/package_model.dart';
import 'package:albedo_app/model/settings/assessment_model.dart';
import 'package:albedo_app/model/stu_wallet_model.dart';
import 'package:albedo_app/model/users/advisor_model.dart';
import 'package:albedo_app/model/users/coordinator_model.dart';
import 'package:albedo_app/model/users/mentor_model.dart';

class Student {
  String? studentId;
  String? phone;
  String? imageUrl;
  String? whatsapp;
  String? createdBy;
  String? parentName;
  String? parentOccupation;
  String? gender;
  String? timezone;
  String? address;
  String? place;
  String? referredBy;
  bool isFeePaid;
  List<Package>? packages;
  List<Assessment>? assessment;
  List<Certificate>? certificate;
  List<Batch>? batch;
  



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
  StudentWallet? wallet;

  String? course;
  String? subjects;
  String? syllabus;
  String? syllabusId;

  String? advisorName;
  String? advisorId;
  Coordinator? coordinator;
  Mentor? mentor;
  Advisor? advisor;
  final String? teacherId;

  String? referralName;
  String? referralRole;

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
    this.batch,
    this.admissionDate,
    this.assessment,
    this.certificate,
    this.parentName,
    this.parentOccupation,
    this.status,
    this.packages,
    this.mentor,
    this.wallet,
    this.teacherId,
    this.imageUrl,
    this.type,
    this.createdBy,
    this.address,
    this.gender,
    this.isFeePaid=false,
    this.timezone,
    this.place,
    this.studentId,
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
    this.advisorName,
    this.advisorId,
    this.referralName,
    this.referralRole,
    this.subjects,
    this.syllabusId,
    this.syllabus,
    this.category,
    this.regFee,
    this.amountPerHour,
    this.totalHour,
    this.totalSession,
  });

  /// 🔹 FROM JSON (Backend Ready)
  factory Student.fromJson(Map<String, dynamic> json) {
    return Student(
      name: json['name'] ?? '',
      joinedAt: DateTime.parse(json['joinedAt']),
      studentId: json['studentId'],
      email: json['email'],
      
      phone: json['phone'],
      whatsapp: json['whatsapp'],
      parentName: json['parentName'],
      parentOccupation: json['parentOccupation'],
      gender: json['gender'],
      mentor: json['mentor'],
      timezone: json['timezone'],
      address: json['address'],
      place: json['place'],
      referredBy: json['referredBy'],
      classHours: json['classHours'],
      classesTaken: json['classesTaken'],
      standard: json['standard'],
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
      advisorName: json['advisorName'],
      advisorId: json['advisorId'],
      referralName: json['referralName'],
      referralRole: json['referralRole'],
      status: json['status'],
      category: json['category'],
      admissionDate: json['admissionDate'] != null
          ? DateTime.parse(json['admissionDate'])
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
      'parentName': parentName,
      'parentOccupation': parentOccupation,
      'gender': gender,
      'mentor': mentor,
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
      'referralName': referralName,
      'referralRole': referralRole,
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

class Certificate {
}
