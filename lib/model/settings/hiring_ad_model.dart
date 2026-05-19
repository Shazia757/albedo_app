import 'package:albedo_app/model/users/teacher_model.dart';

enum Days {
  all,
  monday,
  tuesday,
  wednesday,
  thursday,
  friday,
  saturday,
  sunday
}

class HiringAd {
  final String? id;
  final String? package;
  final String? image;
  final String? time;
  final DateTime? fromDate;
  final DateTime? toDate;
  final List<String>? regularDays;
  final DateTime? dateAdded;

  HiringAd({
    this.id,
    this.package,
    this.image,
    this.time,
    this.fromDate,
    this.toDate,
    this.regularDays,
    this.dateAdded,
  });

  factory HiringAd.fromJson(Map<String, dynamic> json) {
    return HiringAd(
      id: json['id'],
      package: json['package'],
      image: json['image'],
      time: json['time'],
      fromDate:
          json['from_date'] != null ? DateTime.parse(json['from_date']) : null,
      toDate: json['to_date'] != null ? DateTime.parse(json['to_date']) : null,
      regularDays: json['regular_days'] != null
          ? List<String>.from(json['regular_days'])
          : [],
      dateAdded: json['date_added'] != null
          ? DateTime.parse(json['date_added'])
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'package': package,
      'image': image,
      'time': time,
      'from_date': fromDate?.toIso8601String(),
      'to_date': toDate?.toIso8601String(),
      'regular_days': regularDays,
      'date_added': dateAdded?.toIso8601String(),
    };
  }

  static List<HiringAd> fromJsonList(List<dynamic> jsonList) {
    return jsonList
        .map((e) => HiringAd.fromJson(e as Map<String, dynamic>))
        .toList();
  }
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
