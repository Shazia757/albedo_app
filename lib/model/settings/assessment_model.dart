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
  List<Item>? mathsData;
  List<Item>? subjectsData;
  List? keypoints;
  String? createdBy;
  String? approvedBy;

  Assessment({
    this.id,
    this.type,
    required this.testType,
    this.date,
    this.time,
    this.createdBy,
    this.approvedBy,
    this.summary,
    this.keypoints,
    this.mathsData,
    this.subjectsData,
    this.attentionQuestions,
    this.attentionData,
    this.parentOpinion,
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
