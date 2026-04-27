class Ticket {
  final String id;
  final String title;
  final String description;
  String? category;
  String? priority;
  String? userType;
  String? studentName;
  String? teacherName;
  String? createdAt;
  String? attachmentUrl;
  List<Reply> replies;
  final String status; // open / closed
  final String? studentId;
  final String? teacherId;
  final String? coordinatorId;

  Ticket({
    required this.id,
    required this.title,
    required this.description,
    this.category,
    this.createdAt,
    this.priority,
    this.studentName,
    this.attachmentUrl,
    this.teacherName,
    this.studentId,
    this.teacherId,
    this.coordinatorId,
    this.replies = const [],
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

class Reply {
  final String id;
  final String message;
  final String sender; // "admin" / "user"
  final DateTime createdAt;
  final String? attachmentUrl;

  Reply({
    required this.id,
    required this.message,
    required this.sender,
    required this.createdAt,
    this.attachmentUrl,
  });
}
