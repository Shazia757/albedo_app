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

  RxList<Map<String, dynamic>> languages = <Map<String, dynamic>>[].obs;
  RxList<Map<String, dynamic>> mathTopics = <Map<String, dynamic>>[].obs;
  RxList<Map<String, dynamic>> subjects = <Map<String, dynamic>>[].obs;
  RxList<Map<String, dynamic>> keypoints = <Map<String, dynamic>>[].obs;

  final attentionRatings = <String, int>{}.obs;

  final academicSubjects = <Map<String, dynamic>>[
    {"name": "", "current": 0, "expected": 0},
    {"name": "", "current": 0, "expected": 0},
  ].obs;

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
}
