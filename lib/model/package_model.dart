import 'package:albedo_app/model/wallet_model.dart';

class Package {
  final String teacherId;
  final String teacherName;
  final String teacherImage;

  final String subjectId;
  final String subjectName;

  final String standard;
  final String syllabus;

  final String status; // Active / Completed / Pending

  final double packageFee;
  final double takenFee;
  final double balance;

  final String time; // e.g. "10:00 AM"
  final String duration; // e.g. "2 hrs"

  final String note;

  List<Withdrawal> withdrawals;

  Package({
    required this.teacherId,
    required this.teacherName,
    required this.teacherImage,
    required this.subjectId,
    required this.subjectName,
    required this.standard,
    required this.syllabus,
    required this.status,
    required this.packageFee,
    required this.takenFee,
    required this.balance,
    required this.withdrawals,
    required this.time,
    required this.duration,
    required this.note,
  });
}
