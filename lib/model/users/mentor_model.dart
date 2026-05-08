import 'package:albedo_app/model/users/coordinator_model.dart';

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
  String? address;
  String? timezone;
final Coordinator? coordinator;
  String? prefLanguage;
  String? accountNumber;
  String? accountHolder;
  String? upiId;
  String? accountType;
  String? bankName;
  String? bankBranch;
  int? salary;

  Mentor({
    required this.name,
this.id,
required this.empId,
    this.joinedAt,
    this.email,
    this.gender,
    this.status,
    this.rating,
    this.phone,
    this.imageUrl,
    this.coordinator,
    this.whatsapp,
    this.timezone,
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
