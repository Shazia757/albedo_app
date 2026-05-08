import 'package:albedo_app/model/session_model.dart';
import 'package:albedo_app/model/settings/hiring_ad_model.dart';
import 'package:albedo_app/model/users/teacher_model.dart';
import 'package:albedo_app/model/wallet_model.dart';

class Package {
  List<Session>? sessions;
  String? name;
  String? course;
  DateTime? enrolledAt;
  Teacher? teacher;
  int? expenseRatio;
    DateTime? date;

  ///TODO
  Days? days;
  String? mode;
  int? numberOfClasses;
  int? sessionsTotal;
  int? sessionsCompleted;

  String? couponCode;

  String? subjectId;
  String? subjectName;
  String? standard;
  String? syllabus;

  final String status; // Active / Completed / Pending

  double? studentFeePerHour;
  double? packageFee;
  double? takenFee;
  double? balance;

  double? hourlyRate;

  String? time;
  String? duration;
  String? durationDays;

  String? note;

  List<Withdrawal>? withdrawals;

  Package({
    this.name,
    this.sessions,
    this.course,
    this.days,
    this.date,
    this.duration,
    this.couponCode,
    this.expenseRatio,
    this.durationDays,
    this.studentFeePerHour,
    this.numberOfClasses,
    this.teacher,
    this.subjectId,
    this.subjectName,
    this.standard,
    this.syllabus,
    required this.status,
    this.packageFee,
    this.takenFee,
    this.balance,
    this.withdrawals,
    this.time,
    this.note,
    this.enrolledAt,
  });
}
