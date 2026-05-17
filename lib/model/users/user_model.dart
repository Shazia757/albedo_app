class Users {
  String? id;

  String? name;
  String? empId;

  String? role;
  String? position;
  String? customPosition;

  String? email;

  String? contact;
  String? whatsappNumber;

  String? profileImage;

  String? dateOfBirth;
  String? qualification;

  String? place;
  String? pincode;
  String? address;

  String? timezone;
  String? preferredLanguage;

  String? resumeFile;
  String? resumeUrl;

  dynamic paymentDetails;

  List<dynamic>? workExperiences;

  bool? isResigned;

  Users({
    this.id,
    this.name,
    this.empId,
    this.role,
    this.position,
    this.customPosition,
    this.email,
    this.contact,
    this.whatsappNumber,
    this.profileImage,
    this.dateOfBirth,
    this.qualification,
    this.place,
    this.pincode,
    this.address,
    this.timezone,
    this.preferredLanguage,
    this.resumeFile,
    this.resumeUrl,
    this.paymentDetails,
    this.workExperiences,
    this.isResigned,
  });

  factory Users.fromJson(Map<String, dynamic> json) {
    return Users(
      id: json['id']?.toString(),
      name: json['name'] ?? json['username'] ?? '',
      empId: json['emp_id'],
      role: json['role'],
      position: json['position'],
      customPosition: json['custom_position'],
      email: json['email'],
      contact: json['phone_number'] ?? json['contact'],
      whatsappNumber: json['whatsapp_number'],
      profileImage: json['photo'] ?? json['profileImage'],
      dateOfBirth: json['date_of_birth'],
      qualification: json['qualification'],
      place: json['place'],
      pincode: json['pincode'],
      address: json['address'],
      timezone: json['timezone'],
      preferredLanguage: json['preferred_language'],
      resumeFile: json['resume_file'],
      resumeUrl: json['resume_url'],
      paymentDetails: json['payment_details'],
      workExperiences: json['work_experiences'] ?? [],
      isResigned: json['is_resigned'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'username': name,
      'emp_id': empId,
      'role': role,
      'position': position,
      'custom_position': customPosition,
      'email': email,
      'phone_number': contact,
      'contact': contact,
      'whatsapp_number': whatsappNumber,
      'photo': profileImage,
      'profileImage': profileImage,
      'date_of_birth': dateOfBirth,
      'qualification': qualification,
      'place': place,
      'pincode': pincode,
      'address': address,
      'timezone': timezone,
      'preferred_language': preferredLanguage,
      'resume_file': resumeFile,
      'resume_url': resumeUrl,
      'payment_details': paymentDetails,
      'work_experiences': workExperiences,
      'is_resigned': isResigned,
    };
  }
}

class DeadlineConfig {
  String role; // Teacher, Mentor, etc
  String type; // "hours" or "dayOfMonth"
  int value;
  bool enabled;

  DeadlineConfig({
    required this.role,
    required this.type,
    required this.value,
    this.enabled = true,
  });
}

class LoginResponse {
  String? accessToken;
  String? refreshToken;
  Users? data;

  LoginResponse({required this.data, this.accessToken, this.refreshToken});

  factory LoginResponse.fromJson(Map<String, dynamic> json) {
    return LoginResponse(
      data: json['user'] != null
          ? Users.fromJson(json['user'] as Map<String, dynamic>)
          : Users(),
      accessToken: json['access'] as String?,
      refreshToken: json['refresh'] as String?,
    );
  }

  Map<String, dynamic> toJson() {
    return {'access': accessToken};
  }
}
