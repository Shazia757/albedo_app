import 'package:flutter/material.dart';
import 'package:get/get.dart';

class SettingsController extends GetxController {
  RxBool isLoading = true.obs;
  var selectedTab = 0.obs;

  var syllabus = [].obs;
  var course = [].obs;
  var package = [].obs;
  var category = [].obs;
  var supportCategory = [].obs;
  var standard = [].obs;
  var referralSource = [].obs;
  var assessmentAttentionQn = [].obs;
  var users = [].obs;

  TextEditingController regFeeController = TextEditingController();
  TextEditingController factorValueController = TextEditingController();
  TextEditingController studentTermsController = TextEditingController();
  TextEditingController teacherTermsController = TextEditingController();
  TextEditingController mentorTermsController = TextEditingController();
  TextEditingController coordinatorTermsController = TextEditingController();
  TextEditingController otherTermsController = TextEditingController();
  TextEditingController studentRefundController = TextEditingController();
  TextEditingController teacherRefundController = TextEditingController();
  TextEditingController mentorRefundController = TextEditingController();
  TextEditingController coordinatorRefundController = TextEditingController();
  TextEditingController otherRefundController = TextEditingController();
  TextEditingController studentPrivacyController = TextEditingController();
  TextEditingController teacherPrivacyController = TextEditingController();
  TextEditingController mentorPrivacyController = TextEditingController();
  TextEditingController coordinatorPrivacyController = TextEditingController();
  TextEditingController otherPrivacyController = TextEditingController();

  List<String> tabs = [
    "General",
    "Notifications",
    "Banner Ads",
    "Coupon Code",
    "Wallet Coupon",
    "Recommendation",
    "Hiring",
    "Star of Month",
    "Macro",
    "Assessments",
    "Materials",
    "Bulk Upload",
    "Back up"
  ];

  @override
  void onInit() {
    super.onInit();
    fetchData();
  }

  Future<void> fetchData() async {
    try {
      isLoading.value = true;

      await Future.delayed(const Duration(seconds: 2));

      syllabus.assignAll(['ATTC', 'Albedo School', 'British', 'CBSE']);
      course.assignAll(['Abacus', 'Academic', 'Albedo Junior']);
      package.assignAll(['Accountancy', 'Arabic', 'Banking', 'Biology']);
      supportCategory.assignAll(['Doubt Not resolved', 'Misbehaviour']);
      category.assignAll(['High School', 'Higher secondary school']);
      standard.assignAll(['1', '2', '3', '4']);
      referralSource.assignAll(['Marketing Team']);
      assessmentAttentionQn
          .assignAll(['Consistency', 'Participation in Discussions']);
          users.assignAll(['Student','Teacher','Mentor','Coordinator','Other']);
    } catch (e) {
      print("Error: $e");
    } finally {
      isLoading.value = false;
    }
  }

  void addSyllabus(String name) {
    // syllabus.add(Syllabus(id: generateId(), name: name));
  }

  void updateSyllabus(int id, String name) {
    final index = syllabus.indexWhere((e) => e.id == id);
    if (index != -1) {
      syllabus[index].name = name;
      syllabus.refresh();
    }
  }

  void deleteSyllabus(int id) {
    syllabus.removeWhere((e) => e.id == id);
  }
}
