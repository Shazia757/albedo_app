class Ticket {
  final String id;
  final String title;
  final String description;
  String? category;
  String? priority;
  String? userType;
  String? studentName;
  String? teacherName;
  final String status; // open / closed

  Ticket({
    required this.id,
    required this.title,
    required this.description,
    this.category,
    this.priority,
    this.studentName,
    this.teacherName,
    this.userType,
    required this.status,
  });
}

class Macro {
  final String id;
  final String title;
  final String description;

  Macro({
    required this.id,
    required this.title,
    required this.description,
  });
}
