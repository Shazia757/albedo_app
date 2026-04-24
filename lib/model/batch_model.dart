import 'package:albedo_app/model/users/teacher_model.dart';

class Batch {
  String? id;
  String? batchID;
  String? batchName;
  String? mode;
  String? course;
  String? imageUrl;
  Teacher? teacher;
  int? students;
  int? totalFee;
  int? totalPaid;
  int? balance;
  int? expenseRatio;
  final int? duration;
  String? mentorName;
 String? mentorId;
  String? coordinatorName;
  final String? coordinatorId;
  final List<String>? package;
  final String? syllabus;
  final DateTime? date;
  final String? startTime;
  final String? endTime;
  final String? status;

  Batch({
    this.id,
    this.batchID,
    this.batchName,
    this.teacher,
    this.mode,
    this.totalFee,
    this.totalPaid,
    this.balance,
    this.expenseRatio,
    this.students,
    this.coordinatorId,
    this.coordinatorName,
    this.imageUrl,
    this.mentorId,
    this.mentorName,
    this.course,
    this.duration,
    this.package,
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
      package: json['package'],
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
      'package': package,
      'syllabus': syllabus,
      'date': date?.toIso8601String(),
      'startTime': startTime,
      'endTime': endTime,
      'status': status,
    };
  }
}
