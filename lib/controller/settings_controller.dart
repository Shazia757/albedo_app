import 'package:albedo_app/model/banners_model.dart';
import 'package:albedo_app/model/notification_model.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

enum VisibleTo {
  all,
  student,
  teacher,
  mentor,
  assistantAdmin,
  other,
}

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
  var notifications = <Notifications>[].obs;
  var banners = <Banners>[].obs;

  RxBool isDeleteButtonLoading = false.obs;

  RxList<VisibleTo> selected = <VisibleTo>[].obs;

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

  TextEditingController titleController = TextEditingController();
  TextEditingController messageController = TextEditingController();

  TextEditingController urlController = TextEditingController();
  TextEditingController startDateController = TextEditingController();
  TextEditingController endDateController = TextEditingController();

Rx<BannerType> selectedType = BannerType.defaultBanner.obs;


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
    fetchNotifications();
    fetchBanners();
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
      users.assignAll(['Student', 'Teacher', 'Mentor', 'Coordinator', 'Other']);
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

  void fetchNotifications() async {
    try {
      isLoading.value = true;

      await Future.delayed(const Duration(seconds: 2));

      notifications.assignAll([
        Notifications(
            id: '#001',
            title: 'Attendance policy update',
            message: 'Please make sure to ....',
            isImportant: true,
            visibleTo: [VisibleTo.teacher, VisibleTo.mentor]),
        Notifications(
            id: '#002',
            title: 'Teachers Doc',
            message: 'Dear trs, Please make sure to ....',
            isImportant: true,
            visibleTo: [VisibleTo.teacher]),
      ]);
    } finally {
      isLoading.value = false;
    }
  }

  void loadNotifications(Notifications msg) {
    titleController.text = msg.title.toString();
    messageController.text = msg.message.toString();
    selected.assignAll(msg.visibleTo);
  }

  delete(id) {
    isDeleteButtonLoading.value = true;
    // Api().deleteProgram(id).then(
    //   (value) {
    //     if (value?.status == true) {
    //       isDeleteButtonLoading.value = false;
    //       Get.back();
    //       Get.back();
    //       Get.snackbar(
    //           "Success", value?.message ?? "Program deleted successfully.");
    //     } else {
    //       // CustomWidgets.showSnackBar(
    //       //     "Error", value?.message ?? 'Failed to delete program.');
    //     }
    //   },
    // );
  }

  String getLabel(VisibleTo v) {
    switch (v) {
      case VisibleTo.all:
        return "All";
      case VisibleTo.student:
        return "Student";
      case VisibleTo.teacher:
        return "Teacher";
      case VisibleTo.mentor:
        return "Mentor";
      case VisibleTo.assistantAdmin:
        return "Assistant Admin";
      case VisibleTo.other:
        return "Other";
    }
  }

  void fetchBanners() async {
    try {
      isLoading.value = true;

      await Future.delayed(const Duration(seconds: 2));

      banners.assignAll([
        Banners(id: '1', visibleTo: [VisibleTo.assistantAdmin])
      ]);
    } finally {
      isLoading.value = false;
    }
  }

  void loadBanners(Banners banner) {
    urlController.text = banner.url.toString();
    startDateController.text = banner.startDate.toString();
    endDateController.text = banner.endDate.toString();

    selected.assignAll(banner.visibleTo);
  }
}
