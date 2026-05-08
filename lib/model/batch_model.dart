import 'package:albedo_app/model/package_model.dart';
import 'package:albedo_app/model/users/coordinator_model.dart';
import 'package:albedo_app/model/users/mentor_model.dart';
import 'package:albedo_app/model/users/student_model.dart';
import 'package:albedo_app/model/users/teacher_model.dart';

class Batch {
  String? id;
  String? batchID;
  String? batchName;
  String? mode;
  Student? student;
  String? course;
  String? imageUrl;
  Teacher? teacher;
  int? students;
  int? totalFee;
  int? totalPaid;
  int? balance;
  int? expenseRatio;
  final int? duration;
  Mentor? mentor;
  Coordinator? coordinator;
  final String? coordinatorId;
 List<Package>? packages;
  final String? syllabus;
  final DateTime? date;
  final String? startTime;
  final String? endTime;
  final String? status;
  String? amountPaid;
  DateTime? paidDate;

  Batch({
    this.id,
    this.batchID,
    this.batchName,
    this.paidDate,
    this.teacher,
    this.mode,
    this.amountPaid,
    this.balance,
    this.student,
    this.totalFee,
    this.totalPaid,
    this.expenseRatio,
    this.students,
    this.coordinatorId,
    this.coordinator,
    this.imageUrl,
    this.mentor,
    this.course,
    this.duration,
    this.packages,
    this.syllabus,
    this.date,
    this.startTime,
    this.endTime,
    this.status,
  });

  // ✅ From JSON
  factory Batch.fromJson(Map<String, dynamic> json) {
    return Batch(
      id: json['id'],
      batchID: json['batchID'],
      batchName: json['batchName'],
      duration: json['duration'],
      packages: json['package'],
      syllabus: json['syllabus'],
      date: json['date'] != null ? DateTime.tryParse(json['date']) : null,
      startTime: json['startTime'],
      endTime: json['endTime'],
      status: json['status'],
    );
  }

  // ✅ To JSON
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'batchID': batchID,
      'batchName': batchName,
      'duration': duration,
      'package': packages,
      'syllabus': syllabus,
      'date': date?.toIso8601String(),
      'startTime': startTime,
      'endTime': endTime,
      'status': status,
    };
  }
}
