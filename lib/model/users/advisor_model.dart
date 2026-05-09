import 'package:albedo_app/model/users/student_model.dart';
import 'package:albedo_app/model/users/teacher_model.dart';

class Advisor {
  final String id;
  final String name;
  String? email;
  String? status;
  String? gender;
  final DateTime joinedAt;
  String? phone;
  String? whatsapp;
  int? convertedStudents;
  int? convertedTotalAmount;
  String? imageUrl;
  String? dob;
  String? qualification;
  String? place;
  String? pincode;
  String? address;
  String? coordinatorId;
  String? mentorId;
  List<Student>? student;

  List<Experience>? experience;

  Advisor({
    required this.name,
    required this.id,
    required this.joinedAt,
    this.email,
    this.gender,
    this.status,
    this.coordinatorId,
    this.mentorId,
    this.convertedStudents,
    this.convertedTotalAmount,
    this.imageUrl,
    this.experience,
    this.phone,
    this.whatsapp,
    this.address,
    this.dob,
    this.pincode,
    this.place,
    this.student,
    this.qualification,
  });
}
