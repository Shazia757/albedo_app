import 'package:albedo_app/api.dart';
import 'package:albedo_app/model/settings/assessment_model.dart';
import 'package:get/get.dart';

class DownloadsController extends GetxController {
  var assessments = <Assessment>[].obs;
  var selectedIndex = 0.obs;
  var isLoading = false.obs;

  List<String> tabs = [
    'Certificates',
    'Assessments',
  ];

  @override
  void onInit() {
    super.onInit();
    fetchAssessments();
  }

  Future<void> fetchAssessments() async {
    try {
      isLoading.value = true;

      final data =
          await Api().getAssessmentReportTypes();

      assessments.assignAll(data);
    } catch (e) {
      Get.snackbar(
        'Error',
        e.toString(),
        snackPosition: SnackPosition.BOTTOM,
      );
    } finally {
      isLoading.value = false;
    }
  }
}