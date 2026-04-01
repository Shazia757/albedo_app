class Student {
  final String id;
  final String name;
  final String email;
   DateTime admissionDate;
  final String status;
   final String type;   // Batch / TBA
  final DateTime joinedAt;

  Student({
    required this.id,
    required this.name,
    required this.email,
     required this.admissionDate,
    required this.status,
    required this.type,
    required this.joinedAt,
  });
}