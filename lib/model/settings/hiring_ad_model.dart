enum Days { all, monday, tuesday, wednesday, thursday, friday, saturday, sunday }

class HiringAd {
  String? id;
  String package;
  String? time;
  String? startDate;
  String? endDate;
  List<Days>? days;

  HiringAd({
    required this.package,
    this.id,
    this.time,
    this.startDate,
    this.endDate,
    this.days,
  });
}
