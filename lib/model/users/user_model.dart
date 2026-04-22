class Users {
  String? name;
  String? id;
  String? role;
  String? email;
  String? contact;
  String? profileImage;

  Users({
    this.name,
    this.id,
    this.role,
    this.email,
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
}
