import 'package:albedo_app/model/users/student_model.dart';
import 'package:albedo_app/model/users/teacher_model.dart';


abstract class BaseRequestUser {
  int get pending;
  int get approved;
  int get rejected;
  int get rescheduled;

  List<Requests> get requests;
}

class StudentRequest extends BaseRequestUser {
  final Student student;

  @override
  final int pending;
   @override
  final int approved;
   @override
  final int rejected;
   @override
  final int rescheduled;
 @override
  final List<Requests> requests;

  StudentRequest({
    required this.student,
    required this.pending,
    required this.approved,
    required this.rejected,
    required this.rescheduled,
    required this.requests,
  });
}

class TeacherRequest extends BaseRequestUser{
  final Teacher teacher;
    @override
  final int pending;
    @override
  final int approved;
    @override
  final int rejected;
    @override
  final int rescheduled;
    @override
  final List<Requests> requests;

  TeacherRequest({
    required this.teacher,
    required this.pending,
    required this.approved,
    required this.rejected,
    required this.rescheduled,
    required this.requests,
  });
}

class Requests {
String? requestId;
  final String status;
  final String currentDate;
  final String currentTime;
  final String suggestedDate;
  final String suggestedTime;
  final String subject;
  final String standard;
  final String syllabus;
  final String reason;
  final String createdAt;

  Requests({
    required this.requestId,
    required this.status,
    required this.currentDate,
    required this.currentTime,
    required this.suggestedDate,
    required this.suggestedTime,
    required this.subject,
    required this.standard,
    required this.syllabus,
    required this.reason,
    required this.createdAt,
  });
}

class RefundRequest {
  final String studentName;
  final String studentId;
  final String studentImage;

  final String mentorName;
  final String mentorId;
  final String mentorImage;

  final int refundCount;

  RefundRequest({
    required this.studentName,
    required this.studentId,
    required this.studentImage,
    required this.mentorName,
    required this.mentorId,
    required this.mentorImage,
    required this.refundCount,
  });
}
