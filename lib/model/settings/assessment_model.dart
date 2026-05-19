import 'package:albedo_app/model/settings/syllabus_model.dart';

class Assessment {
  final String? id;
  final String? title;
  final List<TestType>? testTypes;
  final List<AssessmentAttentionQns>? attentionQuestions;
  final DateTime? dateAdded;

  Assessment({
    this.id,
    this.title,
    this.testTypes,
    this.attentionQuestions,
    this.dateAdded,
  });

  factory Assessment.fromJson(Map<String, dynamic> json) {
    return Assessment(
      id: json['id'],
      title: json['title'],
      testTypes: json['test_types'] != null
          ? (json['test_types'] as List)
              .map((e) => TestType.fromJson(e))
              .toList()
          : [],
      attentionQuestions: json['attention_questions'] != null
          ? (json['attention_questions'] as List)
              .map((e) => AssessmentAttentionQns.fromJson(e))
              .toList()
          : [],
      dateAdded: json['date_added'] != null
          ? DateTime.parse(json['date_added'])
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'test_types': testTypes?.map((e) => e.toJson()).toList(),
      'attention_questions':
          attentionQuestions?.map((e) => e.toJson()).toList(),
      'date_added': dateAdded?.toIso8601String(),
    };
  }

  static List<Assessment> fromJsonList(List<dynamic> jsonList) {
    return jsonList
        .map((e) => Assessment.fromJson(e as Map<String, dynamic>))
        .toList();
  }
}

class TestType {
  final String? id;
  final String? name;

  TestType({
    this.id,
    this.name,
  });

  factory TestType.fromJson(Map<String, dynamic> json) {
    return TestType(
      id: json['id'],
      name: json['name'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
    };
  }
}

class LanguageData {
  String name;
  int rating;
  bool reading;
  bool writing;
  bool creativity;
  String mark;

  LanguageData({
    required this.name,
    this.rating = 0,
    this.reading = false,
    this.writing = false,
    this.creativity = false,
    this.mark = "",
  });
}

class Item {
  String? name;
  int? rating;

  Item({
    this.name,
    this.rating,
  });
}

class AcademicData {
  String? name;
  int? current;
  int? expected;

  AcademicData({
    this.name,
    this.current,
    this.expected,
  });
}

class AttentionItem {
  String question;
  int rating;
  String mark;

  AttentionItem({
    required this.question,
    required this.rating,
    required this.mark,
  });
}
