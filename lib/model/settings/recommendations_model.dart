class Recommendations {
  String id;
  String? package;
  String? batch;
  String? startDate;
  String? endDate;
  List<String> visibleTo;


  Recommendations({
    required this.id,
    this.batch,
    this.package,
    this.startDate,
    this.endDate,
    required this.visibleTo,
  });
}
