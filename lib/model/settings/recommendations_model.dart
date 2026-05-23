import 'package:albedo_app/model/users/student_model.dart';

class Recommendations {
  String? image;
  String id;
  String? package;
  String? batch;
  String? startDate;
  String? endDate;

  /// syllabus names
  List<String> visibleTo;

  /// syllabus ids
  List<String> syllabusIds;

  Recommendations({
    required this.id,
    this.batch,
    this.image,
    this.package,
    this.startDate,
    this.endDate,
    required this.visibleTo,
    required this.syllabusIds,
  });

  factory Recommendations.fromJson(
    Map<String, dynamic> json,
  ) {
    final syllabuses = json['show_to_syllabuses'] as List? ?? [];

    return Recommendations(
      id: json['id'] ?? '',
      package: json['recommended_package'],
      startDate: json['from_date'],
      endDate: json['to_date'],
      image: json['image'],
      visibleTo: syllabuses
          .map(
            (e) => e['name'].toString(),
          )
          .toList(),
      syllabusIds: syllabuses
          .map(
            (e) => e['id'].toString(),
          )
          .toList(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      "id": id,
      "recommended_package": package,
      "from_date": startDate,
      "to_date": endDate,
      "image": image,
      "show_to_syllabuses": syllabusIds,
    };
  }

  static List<Recommendations> fromJsonList(
    List<dynamic> jsonList,
  ) {
    return jsonList
        .map(
          (e) => Recommendations.fromJson(
            e as Map<String, dynamic>,
          ),
        )
        .toList();
  }
}

class RecommendationItem {
  final String? id;
  final String? title;
  final String? type;
  final String? recommendedPackage;
  final String? recommendedBatch;
  final String? image;
  final DateTime? fromDate;
  final DateTime? toDate;
  final List<String> syllabuses;

  RecommendationItem({
    this.id,
    this.title,
    this.type,
    this.recommendedPackage,
    this.recommendedBatch,
    this.image,
    this.fromDate,
    this.toDate,
    required this.syllabuses,
  });

  factory RecommendationItem.fromJson(
    Map<String, dynamic> json,
  ) {
    return RecommendationItem(
      id: json['id'],
      type: json['recommended_package'] != null ? 'package' : 'batch',
      recommendedPackage: json['recommended_package'],
      recommendedBatch: json['recommended_batch'],
      image: json['image'],
      fromDate:
          json['from_date'] != null ? DateTime.parse(json['from_date']) : null,
      toDate: json['to_date'] != null ? DateTime.parse(json['to_date']) : null,
      syllabuses: (json['show_to_syllabuses'] as List?)
              ?.map<String>(
                (e) => e['name'].toString(),
              )
              .toList() ??
          [],
    );
  }
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

class PackageRecommendations {
  final String? id;
  final String? recommendedPackage;
  final DateTime? fromDate;
  final DateTime? toDate;
  final List<SyllabusModel>? showToSyllabuses;
  final DateTime? dateAdded;
  final DateTime? dateUpdated;
  final String? image;

  PackageRecommendations({
    this.id,
    this.recommendedPackage,
    this.fromDate,
    this.toDate,
    this.showToSyllabuses,
    this.dateAdded,
    this.dateUpdated,
    this.image,
  });

  factory PackageRecommendations.fromJson(Map<String, dynamic> json) {
    return PackageRecommendations(
      id: json['id'],
      recommendedPackage: json['recommended_package'],
      fromDate:
          json['from_date'] != null ? DateTime.parse(json['from_date']) : null,
      toDate: json['to_date'] != null ? DateTime.parse(json['to_date']) : null,
      showToSyllabuses: json['show_to_syllabuses'] != null
          ? (json['show_to_syllabuses'] as List)
              .map((e) => SyllabusModel.fromJson(e))
              .toList()
          : [],
      dateAdded: json['date_added'] != null
          ? DateTime.parse(json['date_added'])
          : null,
      dateUpdated: json['date_updated'] != null
          ? DateTime.parse(json['date_updated'])
          : null,
      image: json['image'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'recommended_package': recommendedPackage,
      'from_date': fromDate?.toIso8601String(),
      'to_date': toDate?.toIso8601String(),
      'show_to_syllabuses': showToSyllabuses?.map((e) => e.toJson()).toList(),
      'date_added': dateAdded?.toIso8601String(),
      'date_updated': dateUpdated?.toIso8601String(),
      'image': image,
    };
  }

  static List<PackageRecommendations> fromJsonList(List<dynamic> jsonList) {
    return jsonList
        .map((e) => PackageRecommendations.fromJson(e as Map<String, dynamic>))
        .toList();
  }
}

class BatchRecommendations {
  final String? id;
  final String? recommendedBatch;
  final DateTime? fromDate;
  final DateTime? toDate;
  final List<SyllabusModel>? showToSyllabuses;
  final DateTime? dateAdded;
  final DateTime? dateUpdated;
  final String? image;

  BatchRecommendations({
    this.id,
    this.recommendedBatch,
    this.fromDate,
    this.toDate,
    this.showToSyllabuses,
    this.dateAdded,
    this.dateUpdated,
    this.image,
  });

  factory BatchRecommendations.fromJson(Map<String, dynamic> json) {
    return BatchRecommendations(
      id: json['id'],
      recommendedBatch: json['recommended_batch'],
      fromDate:
          json['from_date'] != null ? DateTime.parse(json['from_date']) : null,
      toDate: json['to_date'] != null ? DateTime.parse(json['to_date']) : null,
      showToSyllabuses: json['show_to_syllabuses'] != null
          ? (json['show_to_syllabuses'] as List)
              .map((e) => SyllabusModel.fromJson(e))
              .toList()
          : [],
      dateAdded: json['date_added'] != null
          ? DateTime.parse(json['date_added'])
          : null,
      dateUpdated: json['date_updated'] != null
          ? DateTime.parse(json['date_updated'])
          : null,
      image: json['image'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'recommended_batch': recommendedBatch,
      'from_date': fromDate?.toIso8601String(),
      'to_date': toDate?.toIso8601String(),
      'show_to_syllabuses': showToSyllabuses?.map((e) => e.toJson()).toList(),
      'date_added': dateAdded?.toIso8601String(),
      'date_updated': dateUpdated?.toIso8601String(),
      'image': image,
    };
  }

  static List<PackageRecommendations> fromJsonList(List<dynamic> jsonList) {
    return jsonList
        .map((e) => PackageRecommendations.fromJson(e as Map<String, dynamic>))
        .toList();
  }
}

class SyllabusModel {
  final String? id;
  final String? name;
  final DateTime? dateAdded;
  final DateTime? dateUpdated;

  SyllabusModel({
    this.id,
    this.name,
    this.dateAdded,
    this.dateUpdated,
  });

  factory SyllabusModel.fromJson(Map<String, dynamic> json) {
    return SyllabusModel(
      id: json['id'],
      name: json['name'],
      dateAdded: json['date_added'] != null
          ? DateTime.parse(json['date_added'])
          : null,
      dateUpdated: json['date_updated'] != null
          ? DateTime.parse(json['date_updated'])
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'date_added': dateAdded?.toIso8601String(),
      'date_updated': dateUpdated?.toIso8601String(),
    };
  }
}
