import 'package:albedo_app/model/users/mentor_model.dart';
import 'package:albedo_app/model/users/teacher_model.dart';
import 'package:albedo_app/model/wallet_model.dart';

class Coordinator {
  final String id;
  String name;
  String? empId;

  String? email;
  String? imageUrl;
  String? status;
  String? gender;
  DateTime? joinedAt;
  DateTime? assignedAt;

  String? phone;
  String? whatsapp;
  String? dob;
  String? qualification;
  String? place;
  String? pincode;
  String? address;
  String? timezone;
  String? prefLanguage;

  // Payment
  String? accountNumber;
  String? accountHolder;
  String? upiId;
  String? ifscCode;
  String? accountType;
  String? bankName;
  String? bankBranch;
  bool? isResigned;

  int? salary;
  double? balance;

  // Counts
  int? mentorCount;
  int? studentCount;
  int? teacherCount;

  // Relations
  List<Mentor>? mentor;
  Wallet? wallet;
  List<Experience>? experience;

  Coordinator({
    required this.id,
    required this.name,
    this.email,
    this.empId,
    this.imageUrl,
    this.status,
    this.gender,
    this.isResigned,
    this.joinedAt,
    this.assignedAt,
    this.phone,
    this.whatsapp,
    this.dob,
    this.qualification,
    this.place,
    this.pincode,
    this.address,
    this.timezone,
    this.prefLanguage,
    this.accountNumber,
    this.accountHolder,
    this.upiId,
    this.ifscCode,
    this.accountType,
    this.bankName,
    this.bankBranch,
    this.salary,
    this.balance,
    this.mentorCount,
    this.studentCount,
    this.teacherCount,
    this.mentor,
    this.wallet,
    this.experience,
  });

  factory Coordinator.fromJson(Map<String, dynamic> json) {
    final payment = json['payment_details'];

    return Coordinator(
      id: json['id'],
      name: json['name'] ?? '',
      empId: json['emp_id'],

      email: json['email'],
      phone: json['phone_number'],
      whatsapp: json['whatsapp_number'],
      dob: json['date_of_birth'],
      qualification: json['qualification'],
      place: json['place'],
      pincode: json['pincode'],
      address: json['address'],
      timezone: json['timezone'],
      isResigned: json['is_resigned'] ?? false,
      prefLanguage: json['preferred_language'],

      imageUrl: json['photo'],

      status: (json['is_resigned'] ?? false) ? "Inactive" : "Active",

      joinedAt: json['created_at'] != null
          ? DateTime.tryParse(json['created_at'])
          : null,
      assignedAt: json['assignment_date'] != null
          ? DateTime.tryParse(json['assignment_date'])
          : null,

      // Payment details
      bankName: payment?['bank_name'],
      bankBranch: payment?['branch_name'],
      accountNumber: payment?['account_number'],
      ifscCode: payment?['ifsc_code'],
      accountHolder: payment?['account_holder_name'],
      upiId: payment?['upi_id'],
      accountType: payment?['account_type'],

      // Counts
      mentorCount: json['mentor_count'],
      studentCount: json['student_count'],
      teacherCount: json['teacher_count'],

      // Experience
      experience: json['work_experiences'] != null
          ? (json['work_experiences'] as List)
              .map((e) => Experience.fromJson(e))
              .toList()
          : [],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'emp_id': empId,
      'email': email,
      'phone_number': phone,
      'whatsapp_number': whatsapp,
      'date_of_birth': dob,
      'qualification': qualification,
      'place': place,
      'pincode': pincode,
      'address': address,
      'timezone': timezone,
      'preferred_language': prefLanguage,
      'photo': imageUrl,
      'mentor_count': mentorCount,
      'student_count': studentCount,
      'teacher_count': teacherCount,
    };
  }
}
