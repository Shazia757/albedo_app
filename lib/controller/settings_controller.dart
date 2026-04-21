import 'package:albedo_app/model/banners_model.dart';
import 'package:albedo_app/model/coupons_model.dart';
import 'package:albedo_app/model/hiring_ad_model.dart';
import 'package:albedo_app/model/notification_model.dart';
import 'package:albedo_app/model/rating_value_model.dart';
import 'package:albedo_app/model/recommendations_model.dart';
import 'package:albedo_app/model/support_model.dart';
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

  var syllabusList = <String>[].obs;
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
  var coupons = <Coupons>[].obs;
  var recommendations = <Recommendations>[].obs;
  var hiringAd = <HiringAd>[].obs;
  var ratingValues = <RatingValue>[].obs;
  var supports = <Macro>[].obs;

  RxBool isDeleteButtonLoading = false.obs;

  RxList<VisibleTo> selected = <VisibleTo>[].obs;
  RxList selectedSyllabus = [].obs;
  RxList<Days> selectedDays = <Days>[].obs;

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

  TextEditingController nameController = TextEditingController();
  TextEditingController codeController = TextEditingController();
  TextEditingController discountController = TextEditingController();

  Rx<BannerType> selectedType = BannerType.defaultBanner.obs;
  Rx<String> selectedDiscountType = 'percentage'.obs;
  Rx<String> selectedRecommendationType = 'package'.obs;

  TextEditingController timeController = TextEditingController();

  var textControllers = <TextEditingController>[].obs;

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
    fetchCoupons();
    fetchRecommendations();
    fetchHiringAds();
    fetchRatingValues();
    fetchSupports();
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

  void fetchCoupons() async {
    try {
      isLoading.value = true;

      await Future.delayed(const Duration(seconds: 2));

      coupons
          .assignAll([Coupons(code: 'AW375X', name: 'Wallet Offer', id: '1')]);
    } finally {
      isLoading.value = false;
    }
  }

  void loadCoupons(Coupons cpn) {
    nameController.text = cpn.name.toString();
    codeController.text = cpn.code.toString();
  }

  void fetchRecommendations() async {
    try {
      isLoading.value = true;

      await Future.delayed(const Duration(seconds: 2));

      recommendations.assignAll([
        Recommendations(
            id: '#001',
            batch: 'B001',
            startDate: '01 Aug 2025',
            endDate: '31 Dec 2025',
            visibleTo: ['Albedo School', 'British'])
      ]);
      if (recommendations.isNotEmpty) {
        selectedSyllabus.assignAll(recommendations.first.visibleTo);
      }
    } finally {
      isLoading.value = false;
    }
  }

  void loadRecommendations(Recommendations rec) {
    nameController.text = (selectedRecommendationType == 'batch')
        ? (rec.batch ?? '')
        : (rec.package ?? '');
    startDateController.text = rec.startDate.toString();
    endDateController.text = rec.endDate.toString();
  }

  void fetchHiringAds() async {
    try {
      isLoading.value = true;

      await Future.delayed(const Duration(seconds: 2));

      hiringAd.assignAll([
        HiringAd(
            package: 'Biology',
            time: '12:00 PM',
            startDate: '18 Sep 2025',
            endDate: '03 Oct 2025',
            days: [Days.monday, Days.tuesday])
      ]);
      // if (hiringAd.isNotEmpty) {
      //   selectedSyllabus.assignAll(recommendations.first.visibleTo);
      // }
    } finally {
      isLoading.value = false;
    }
  }

  void loadHiringAds(HiringAd ad) {
    nameController.text = ad.package ?? '';
    timeController.text = ad.time ?? '';
    startDateController.text = ad.startDate.toString();
    endDateController.text = ad.endDate.toString();
    selectedDays.assignAll(ad.days ?? []);
  }

  void fetchRatingValues() async {
    try {
      isLoading.value = true;

      await Future.delayed(const Duration(seconds: 2));

      final data = [
        RatingValue(label: 'MV1', value: 0.5),
        RatingValue(label: 'MV2', value: 0.6),
        RatingValue(label: 'MV3', value: 1),
      ];

      ratingValues.assignAll(data);

      // 🔥 IMPORTANT: Sync controllers
      textControllers.clear();

      for (var item in data) {
        textControllers.add(
          TextEditingController(text: item.value.toString()),
        );
      }
    } finally {
      isLoading.value = false;
    }
  }

  void addField({String defaultValue = "0"}) {
    textControllers.add(TextEditingController(text: defaultValue));
    ratingValues.add(RatingValue(
        label: "MV${ratingValues.length + 1}",
        value: double.tryParse(defaultValue) ?? 0));
  }

  void loadRatingValues(HiringAd ad) {}

  void removeField(int index) {
    if (ratingValues.length > 5) {
      textControllers.removeAt(index);
      ratingValues.removeAt(index);
    } else {
      Get.snackbar("Error", "Minimum 5 values required",
          snackPosition: SnackPosition.BOTTOM);
    }
  }

  void saveSettings() {
    // Collect data from controllers
    for (int i = 0; i < textControllers.length; i++) {
      print("Saving MV${i + 1}: ${textControllers[i].text}");
    }
    Get.snackbar("Success", "Settings saved successfully",
        backgroundColor: Colors.green, colorText: Colors.white);
  }

  void fetchSupports() async {
    try {
      isLoading.value = true;

      await Future.delayed(const Duration(seconds: 2));

      final data = [
        Macro(
            id: '1',
            title: 'App issue',
            description: 'Thank you for reporting'),
        Macro(
            id: '1',
            title: 'Network Issue',
            description:
                'We are sorry to hear you experienced network issues.'),
      ];

      supports.assignAll(data);
    } finally {
      isLoading.value = false;
    }
  }

  void loadSupports(Macro macro) {
    titleController.text = macro.title ?? '';
    messageController.text = macro.description ?? '';
  }
}
