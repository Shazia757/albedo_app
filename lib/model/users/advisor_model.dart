class Advisor {
    final String id;
  final String name;
  String? email;
  String? status;
  String? gender;
  final DateTime joinedAt;
  String? phone;
  String? whatsapp;
  int? convertedStudents;
  String? imageUrl;
  String? dob;
  String? qualification;
  String? place;
  String? pincode;
  String? address;
  // String? prefLanguage;
  // String? accountNumber;
  // String? accountHolder;
  // String? upiId;
  // String? accountType;
  // String? bankName;
  // String? bankBranch;
  // int? salary;

  Advisor(
      {required this.name,
      required this.id,
      required this.joinedAt,
      this.email,
      this.gender,
      this.status,
      this.convertedStudents,
      this.imageUrl,
      this.phone,
      this.whatsapp,
      // this.salary,
      // this.accountHolder,
      // this.accountNumber,
      // this.accountType,
      this.address,
      // this.bankBranch,
      // this.bankName,
      this.dob,
      this.pincode,
      this.place,
      // this.prefLanguage,
      this.qualification,
      // this.upiId,
      });
}