class Session {
  final String id;
  final String studentName;
  final String studentId;
  final String subject;
  final String className;
  final String teacherName;
  final String teacherId;
  final DateTime dateTime;
  final String status;

  Session({
    required this.id,
    required this.studentName,
    required this.studentId,
    required this.subject,
    required this.className,
    required this.teacherName,
    required this.teacherId,
    required this.dateTime,
    required this.status,
  });
}