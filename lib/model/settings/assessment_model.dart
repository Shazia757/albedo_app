class Assessment {
  String? id;
  String? type;
  List<String>? testType;
  String? date;
  String? time;

  String? parentOpinion;
  String? summary;

  List<String>? attentionQuestions;
  List<AttentionItem>? attentionData;

  List<AcademicData>? academicData;

  List<LanguageData>? languages;

  List<Item>? mathsData;

  List<Item>? subjectsData;

  List<Item>? keypoints;

  String? createdBy;
  String? approvedBy;

  Assessment({
    this.id,
    this.type,
    required this.testType,
    this.date,
    this.time,
    this.parentOpinion,
    this.summary,
    this.attentionQuestions,
    this.attentionData,
    this.academicData,
    this.languages,
    this.mathsData,
    this.subjectsData,
    this.keypoints,
    this.createdBy,
    this.approvedBy,
  });
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
