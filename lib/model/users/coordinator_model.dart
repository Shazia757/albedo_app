import 'package:albedo_app/model/users/mentor_model.dart';
import 'package:albedo_app/model/users/teacher_model.dart';
import 'package:albedo_app/model/wallet_model.dart';

class Coordinator {
  final String id;
  final String name;
  String? email;
  String? imageUrl;
  String? status;
  String? gender;
  final DateTime joinedAt;
  String? phone;
  double? balance;

  String? whatsapp;
  String? dob;
  String? qualification;
  String? place;
  String? pincode;
  String? address;
  String? prefLanguage;
  String? accountNumber;
  String? accountHolder;
  String? upiId;
  String? ifscCode;
  String? accountType;
  String? bankName;
  String? bankBranch;
  int? salary;
  List<Mentor>? mentor;
  Wallet? wallet;

    List<Experience>? experience;

  Coordinator(
      {required this.name,
      required this.id,
      required this.joinedAt,
      this.email,
      this.balance,
      this.gender,
      this.ifscCode,
      this.status,
      this.imageUrl,
      this.phone,
      this.whatsapp,
      this.experience,
      this.salary,
      this.accountHolder,
      this.accountNumber,
      this.accountType,
      this.address,
      this.mentor,
      this.bankBranch,
      this.bankName,
      this.wallet,
      this.dob,
      this.pincode,
      this.place,
      this.prefLanguage,
      this.qualification,
      this.upiId});
}
