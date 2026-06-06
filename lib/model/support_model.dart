import 'package:albedo_app/model/users/student_model.dart';
import 'package:albedo_app/model/users/teacher_model.dart';

class Ticket {
  final String id;
  final String ticketId;
  final String title;
  final String description;

  final String? category;
  final String? priority;
  final String? userType;

  final Student? student;
  final Teacher? teacher;

  final DateTime? createdAt;
  final DateTime? updatedAt;

  final String? attachmentUrl;

  final List<Reply> replies;

  final String status;

  final String? coordinatorId;

  Ticket({
    required this.id,
    required this.ticketId,
    required this.title,
    required this.description,
    required this.status,
    this.category,
    this.priority,
    this.userType,
    this.student,
    this.teacher,
    this.createdAt,
    this.updatedAt,
    this.attachmentUrl,
    this.coordinatorId,
    this.replies = const [],
  });

  factory Ticket.fromJson(Map<String, dynamic> json) {
    return Ticket(
      id: json['id'] ?? '',
      ticketId: json['ticket_id'] ?? '',
      title: json['title'] ?? '',
      description: json['description'] ?? '',
      status: json['status'] ?? '',
      priority: json['priority'],
      attachmentUrl: json['file'],
      category: json['category']?['name'],
      student:
          json['student'] != null ? Student.fromJson(json['student']) : null,

      /// TEACHER
      teacher:
          json['teacher'] != null ? Teacher.fromJson(json['teacher']) : null,
      createdAt: json['date_added'] != null
          ? DateTime.parse(json['date_added'])
          : null,
      updatedAt: json['date_updated'] != null
          ? DateTime.parse(json['date_updated'])
          : null,
    );
  }
}

class Macro {
  final String id;
  final String title;
  final String description;
  final DateTime? dateAdded;

  Macro({
    required this.id,
    required this.title,
    required this.description,
    this.dateAdded,
  });

  factory Macro.fromJson(Map<String, dynamic> json) {
    return Macro(
      id: json['id'] ?? '',
      title: json['title'] ?? '',
      description: json['description'] ?? '',
      dateAdded: json['date_added'] != null
          ? DateTime.tryParse(json['date_added'])
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'description': description,
      'date_added': dateAdded?.toIso8601String(),
    };
  }
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
