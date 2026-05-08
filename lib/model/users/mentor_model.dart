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
required this.empId,
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
}
