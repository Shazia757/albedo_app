class TeacherModel {
  final String id;
  final String name;
  final String email;
  final String status;
  final String type; // Batch / TBA
  final DateTime joinedAt;
  final String phone;

  TeacherModel({
    required this.id,
    required this.name,
    required this.email,
    required this.status,
    required this.type,
    required this.joinedAt,
    required this.phone,
  });
}
