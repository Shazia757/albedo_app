import 'package:albedo_app/model/users/teacher_model.dart';

enum Days { all, monday, tuesday, wednesday, thursday, friday, saturday, sunday }

class HiringAd {
  String? adId;
  String package;
  String? time;
  String? startDate;
  String? endDate;
  List<Days>? days;

  HiringAd({
    required this.package,
    this.adId,
    this.time,
    this.startDate,
    this.endDate,
    this.days,
  });
}

class HiringResponse {
  final String adId;
  final String teacherId;
  final String status; // "interested" / "not_interested"
  final DateTime respondedAt;

  HiringResponse({
    required this.adId,
    required this.teacherId,
    required this.status,
    required this.respondedAt,
  });
}

class HiringView {
  final Teacher teacher;
  final HiringAd ad;
  final HiringResponse response;

  HiringView({
    required this.teacher,
    required this.ad,
    required this.response,
  });
}