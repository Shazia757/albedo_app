import 'package:albedo_app/model/settings/assessment_model.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class AssessmentController extends GetxController {
  RxString selectedAssessment = "Academic".obs;
  RxList<String> assessmentList = <String>[].obs;
  RxBool isAddingLanguage = false.obs;
  RxBool isAddingMath = false.obs;
  RxBool isAddingSubject = false.obs;
  RxBool isAddingKeypoints = false.obs;

  RxList<LanguageData> languages = <LanguageData>[].obs;
  RxList<Item> mathTopics = <Item>[].obs;
  RxList<Item> subjects = <Item>[].obs;
  RxList<Item> keypoints = <Item>[].obs;

  final attentionRatings = <String, int>{}.obs;

final academicSubjects = <AcademicData>[].obs;

  TextEditingController subjectController = TextEditingController();
  TextEditingController languageController = TextEditingController();
  TextEditingController mathController = TextEditingController();
  TextEditingController keypointController = TextEditingController();
  TextEditingController languageMarkController = TextEditingController();

  TextEditingController parentOpinionController = TextEditingController();
  TextEditingController assessmentSummaryController = TextEditingController();
  final Map<String, TextEditingController> attentionMarkControllers = {};

  void initAttentionQuestions(List<String> questions) {
    for (final q in questions) {
      attentionMarkControllers[q] = TextEditingController();
    }
  }

  void initAcademicDefaults() {
  academicSubjects.assignAll([
     AcademicData(name: "", current: 0, expected: 0),
    AcademicData(name: "", current: 0, expected: 0),
  ]);
}

  void disposeAttention() {
    for (final c in attentionMarkControllers.values) {
      c.dispose();
    }
  }

  List<AttentionItem> getAttentionData() {
    final questions = [
      "Focus",
      "Listening",
      "Participation",
    ];

    return questions.map((q) {
      return AttentionItem(
        question: q,
        rating: attentionRatings[q] ?? 0,
        mark: attentionMarkControllers[q]?.text ?? "",
      );
    }).toList();
  }

  bool validate(BuildContext context) {
    String error = "";

    if (parentOpinionController.text.trim().isEmpty) {
    error = "Parent Opinion is required";
  } else if (assessmentSummaryController.text.trim().isEmpty) {
    error = "Assessment summary is required";
  }
    if (error.isNotEmpty) {
      Get.snackbar(
        "Error",
        error,
        snackPosition: SnackPosition.TOP,
      );
      return false;
    }

    return true;
  }

  void addAssessment() {}

//   void initForEdit(Assessment? assessment) {
//   if (assessment == null) return;

//   selectedAssessment.value = assessment.type??'';

//   parentOpinionController.text = assessment.parentOpinion ?? "";
//   assessmentSummaryController.text = assessment.summary ?? "";

//   // Load dynamic lists safely
//   academicSubjects.assignAll(assessment.academicData ?? []);
//   languages.assignAll(assessment.languages ?? []);
//   mathTopics.assignAll(assessment.mathsData ?? []);
//   subjects.assignAll(assessment.subjectsData ?? []);
//   keypoints.assignAll(assessment.keypoints ?? []);

//   // attention
//   // attentionRatings.addAll(assessment.attentionRatings ?? {});
// }

  updateAssessment() {}
}
