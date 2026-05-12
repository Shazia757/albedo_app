import 'package:albedo_app/model/settings/assessment_model.dart';
import 'package:get/get.dart';

class DownloadsController extends GetxController {
  var assessments = <Assessment>[].obs;
  var selectedIndex = 0.obs;

  List<String> tabs = ['Certificates', 'Assessments'];

  @override
  void onInit() {
    super.onInit();

    // Dummy data
    assessments.addAll([
      Assessment(
        id: "A-101",
        type: "Mid Term Exam",
        testType: ["Written", "Objective"],
        date: "2026-04-10",
        attentionQuestions: [
          "Why was question 3 left unanswered?",
          "Explain low score in section B",
        ],
      ),
      Assessment(
        id: "A-102",
        type: "Unit Test",
        testType: ["MCQ"],
        date: "2026-04-15",
        attentionQuestions: [
          "Time management issue noted",
        ],
      ),
    ]);
  }
}
