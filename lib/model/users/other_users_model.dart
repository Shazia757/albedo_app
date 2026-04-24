class OtherUsers {
  final String id;
  final String name;
  String? email;
  String? status;
  String? imageUrl;
  String? role;
  String? gender;
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
  String? accountNumber;
  String? accountHolder;
  String? upiId;
  String? accountType;
  String? bankName;
  String? bankBranch;
  int? salary;

  OtherUsers({
    required this.name,
    required this.id,
    required this.joinedAt,
    this.email,
    this.imageUrl,
    this.gender,
    this.role,
    this.status,
    this.phone,
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
