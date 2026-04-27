import 'package:albedo_app/model/users/student_model.dart';

class Recommendations {
  String id;
  String? package;
  String? batch;
  String? startDate;
  String? endDate;
  List<String> visibleTo;
  String? syllabusId;

  Recommendations({
    required this.id,
    this.batch,
    this.package,
    this.startDate,
    this.endDate,
    this.syllabusId,
    required this.visibleTo,
  });
}

class RecommendationResponse {
  final String adId;
  final String studentId;
  final String status; // "interested" / "not_interested"
  final DateTime respondedAt;

  RecommendationResponse({
    required this.adId,
    required this.studentId,
    required this.status,
    required this.respondedAt,
  });
}

class RecommendationView {
  final Student student;
  final RecommendationResponse response;
  final Recommendations recommendation;

  RecommendationView({
    required this.student,
    required this.recommendation,
    required this.response,
  });
}
