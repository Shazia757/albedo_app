import 'package:albedo_app/model/users/student_model.dart';
import 'package:albedo_app/model/users/teacher_model.dart';

class Feedbacks {
  final String id;
  final String package;
  final String className;
  final DateTime date;
  final double rating;
  final String status;

  final Student? student;
  final Teacher? teacher;

  Feedbacks({
    required this.id,
    required this.package,
    required this.className,
    required this.date,
    required this.rating,
    required this.status,
    this.student,
    this.teacher,
  });
}