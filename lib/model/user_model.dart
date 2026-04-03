class UserModel {
  String name;
  String employeeId;
  String role;
  String email;
  String contact;
  String? profileImage;

  UserModel({
    required this.name,
    required this.employeeId,
    required this.role,
    required this.email,
    required this.contact,
    this.profileImage,
  });
}
