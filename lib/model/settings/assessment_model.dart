class Assessment {
  String? id;
  String? title;
  List<String> testType;
  String? date;
  List<String>? attentionQuestions;

  Assessment({
    this.id,
    this.title,
   required this.testType,
    this.date,
    this.attentionQuestions,
  });
}
