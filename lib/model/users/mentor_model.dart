import 'package:albedo_app/model/users/coordinator_model.dart';
import 'package:albedo_app/model/users/student_model.dart';
import 'package:albedo_app/model/users/teacher_model.dart';
import 'package:albedo_app/model/wallet_model.dart';

class Mentor {
  String? id;
  String? empId;
  String name;
  String? email;
  String? imageUrl;
  String? status;
  String? gender;
  double? rating;
  DateTime? joinedAt;
  DateTime? assignedAt;

  String? phone;
  String? whatsapp;
  String? dob;
  String? qualification;
  String? place;
  String? pincode;
  List<Experience>? experience;
  String? address;
  String? timezone;
  final Coordinator? coordinator;
  String? prefLanguage;

  // Payment
  String? accountNumber;
  String? ifscCode;
  String? accountHolder;
  String? upiId;
  String? accountType;
  String? bankName;
  String? bankBranch;

  int? salary;
  double? balance;
  Wallet? wallet;
  List<Student>? student;

  Mentor({
    required this.name,
    this.id,
    this.empId,
    this.joinedAt,
    this.email,
    this.gender,
    this.status,
    this.rating,
    this.ifscCode,
    this.phone,
    this.student,
    this.imageUrl,
    this.coordinator,
    this.whatsapp,
    this.experience,
    this.timezone,
    this.balance,
    this.assignedAt,
    this.wallet,
    this.salary,
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
    this.upiId,
  });

  factory Mentor.fromJson(Map<String, dynamic> json) {
    final payment = json['payment_details'];

    return Mentor(
      id: json['id'],
      empId: json['mentor_emp_id'] ?? json['emp_id'],
      name: json['mentor_name'] ?? json['name'],
      email: json['email'],
      phone: json['phone_number'],
      whatsapp: json['whatsapp_number'],
      dob: json['date_of_birth'],
      qualification: json['qualification'],
      place: json['place'],
      pincode: json['pincode'],
      address: json['address'],
      timezone: json['timezone'],
      prefLanguage: json['preferred_language'],
      imageUrl: json['photo'],
      rating: (json['average_rating'] ?? 0).toDouble(),
      status: (json['is_resigned'] ?? false) ? "Inactive" : "Active",

      joinedAt: json['created_at'] != null
          ? DateTime.tryParse(json['created_at'])
          : null,

      coordinator: json['assistant_admin'] != null
          ? Coordinator(
              id: json['assistant_admin_id'],
              name: json['assistant_admin_name'] ?? '',
            )
          : null,
      assignedAt: json['assignment_date'] != null
          ? DateTime.tryParse(json['assignment_date'])
          : null,
      // Payment Details
      bankName: payment?['bank_name'],
      bankBranch: payment?['branch_name'],
      accountNumber: payment?['account_number'],
      ifscCode: payment?['ifsc_code'],
      accountHolder: payment?['account_holder_name'],
      upiId: payment?['upi_id'],
      accountType: payment?['account_type'],

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
      'emp_id': empId,
      'name': name,
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
    };
  }
}

class PaginatedMentorResponse {
  final int count;
  final String? next;
  final String? previous;
  final List<Mentor> results;

  PaginatedMentorResponse({
    required this.count,
    required this.results,
    this.next,
    this.previous,
  });
}
