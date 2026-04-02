class TeacherModel {
  final String id;
  final String name;
  final String email;
  final String status;
  final String type; // Batch / TBA
  final DateTime joinedAt;
  final String phone;
  int? totalStudents;
  int? totalPackages;
  int? salary;
  int? paid;
  double? balance;
  double? totalSessions;
  double? totalHours;

  TeacherModel({
    required this.id,
    required this.name,
    required this.email,
    required this.status,
    required this.type,
    required this.joinedAt,
    required this.phone,
    this.totalStudents,
    this.totalPackages,
    this.totalSessions,
    this.totalHours,
    this.salary,
    this.paid,
    this.balance,
  });
}
