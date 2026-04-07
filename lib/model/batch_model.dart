class Batch {
  final String? id;
  final String? batchID;
  final String? batchName;
  final String? teacherId;
  String teacherName;
  int? teacherSalary;
  final int? duration;
  String? mentorName;
  final String? mentorId;
  final String? subject;
  final String? syllabus;
  final DateTime? date;
  final String? startTime;
  final String? endTime;
  final String? status;

  Batch({
    this.id,
    this.batchID,
    this.batchName,
    this.teacherId,
    required this.teacherName,
    this.teacherSalary,
    this.mentorId,
    this.mentorName,
    this.duration,
    this.subject,
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
      teacherId: json['teacherID'],
      teacherName: json['teacherName'],
      teacherSalary: json['teacherSalary'],
      duration: json['duration'],
      subject: json['subject'],
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
      'teacherID': teacherId,
      'teacherName': teacherName,
      'duration': duration,
      'subject': subject,
      'syllabus': syllabus,
      'date': date?.toIso8601String(),
      'startTime': startTime,
      'endTime': endTime,
      'status': status,
    };
  }
}
