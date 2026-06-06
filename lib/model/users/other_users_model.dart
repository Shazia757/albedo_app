class OtherUsers {
  final String id;
  final String name;

  String? empId;
  String? position;
  String? customPosition;

  String? email;
  String? phone;
  String? whatsapp;

  String? photo;

  bool? isResigned;

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
    required this.id,
    required this.name,
    this.empId,
    this.position,
    this.customPosition,
    this.email,
    this.phone,
    this.whatsapp,
    this.photo,
    this.isResigned = false,
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
    this.accountType,
    this.bankName,
    this.bankBranch,
    this.salary,
  });

  factory OtherUsers.fromJson(Map<String, dynamic> json) {
    return OtherUsers(
      id: json['id'] ?? '',
      name: json['name'] ?? '',
      empId: json['emp_id'],
      position: json['position'],
      customPosition: json['custom_position'],
      email: json['email'],
      phone: json['phone_number'],
      whatsapp: json['whatsapp_number'],
      photo: json['photo'],
      isResigned: json['is_resigned'] ?? false,
      dob: json['date_of_birth'],
      qualification: json['qualification'],
      place: json['place'],
      pincode: json['pincode'],
      address: json['address'],
      timezone: json['timezone'],
      prefLanguage: json['preferred_language'],
      accountNumber: json['account_number'],
      accountHolder: json['account_holder_name'],
      upiId: json['upi_id'],
      accountType: json['account_type'],
      bankName: json['bank_name'],
      bankBranch: json['branch_name'],
      salary: json['salary'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'emp_id': empId,
      'position': position,
      'custom_position': customPosition,
      'email': email,
      'phone_number': phone,
      'whatsapp_number': whatsapp,
      'photo': photo,
      'is_resigned': isResigned,
    };
  }
}

class PaginatedOtherUserResponse {
  final int count;
  final String? next;
  final String? previous;
  final List<OtherUsers> results;

  PaginatedOtherUserResponse({
    required this.count,
    required this.results,
    this.next,
    this.previous,
  });
}
