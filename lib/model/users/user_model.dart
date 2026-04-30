class Users {
  String? name;
  String? id;
  String? role;
  DateTime? joinedAt;
  String? email;
  String? contact;
  String? profileImage;

  Users({
    this.name,
    this.id,
    this.role,
    this.email,
    this.joinedAt,
    this.contact,
    this.profileImage,
  });

  // Convert object to JSON
  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'id': id,
      'role': role,
      'email': email,
      'contact': contact,
      'profileImage': profileImage,
    };
  }

  // Create object from JSON
  factory Users.fromJson(Map<String, dynamic> json) {
    return Users(
      name: json['name'] ?? '',
      id: json['id'] ?? '',
      role: json['role'] ?? '',
      email: json['email'],
      contact: json['contact'],
      profileImage: json['profileImage'],
    );
  }

  Users copyWith({
  String? name,
  String? id,
  String? role,
  String? email,
  String? contact,
  String? profileImage,
}) {
  return Users(
    name: name ?? this.name,
    id: id ?? this.id,
    role: role ?? this.role,
    email: email ?? this.email,
    contact: contact ?? this.contact,
    profileImage: profileImage ?? this.profileImage,
  );
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
