import 'dart:developer';

import 'package:albedo_app/api.dart';
import 'package:albedo_app/model/settings/assessment_model.dart';
import 'package:albedo_app/model/settings/banners_model.dart';
import 'package:albedo_app/model/settings/coupons_model.dart';
import 'package:albedo_app/model/settings/hiring_ad_model.dart';
import 'package:albedo_app/model/settings/material_model.dart';
import 'package:albedo_app/model/settings/notification_model.dart';
import 'package:albedo_app/model/settings/rating_value_model.dart';
import 'package:albedo_app/model/settings/recommendations_model.dart';
import 'package:albedo_app/model/settings/syllabus_model.dart';
import 'package:albedo_app/model/support_model.dart';
import 'package:albedo_app/model/users/user_model.dart';
import 'package:albedo_app/view/settings/general/assessment_attention_question_page.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

enum VisibleTo {
  all,
  admin,
  student,
  teacher,
  mentor,
  coordinator,
  other,
}

class SettingsController extends GetxController {
  RxBool isLoading = true.obs;
  var selectedTab = 0.obs;
  var errorMessage = ''.obs;
  RxString editingId = ''.obs;

  final RxString feeType = "percentage".obs;
  final RxString status = "inactive".obs;
  var syllabusList = <String>[].obs;
  RxList<Syllabus> syllabus = <Syllabus>[].obs;
  RxList<Syllabus> supportCategories = <Syllabus>[].obs;
  RxList<Syllabus> referralSources = <Syllabus>[].obs;
  var supportTickets = [].obs;
  final registrationFee = Rxn<dynamic>();
  final starFactor = Rxn<dynamic>();
  RxList<Syllabus> packageNames = <Syllabus>[].obs;
  RxList<Syllabus> course = <Syllabus>[].obs;
  RxList<Syllabus> categories = <Syllabus>[].obs;
  RxList<Syllabus> standards = <Syllabus>[].obs;
  RxList<CompletionDeadline> completionDeadlineSettings =
      <CompletionDeadline>[].obs;
  RxList<AssessmentAttentionQns> assessmentAttentionQns =
      <AssessmentAttentionQns>[].obs;

  var packageRecommendations = <PackageRecommendations>[].obs;
  var batchRecommendations = [].obs;
  var assessmentQuestions = [].obs;
  final assessmentReportTypes = <Assessment>[].obs;
  var hiringAds = [].obs;
  var privacyPolicies = [].obs;
  final salaryInvoiceTaxSettings = Rxn<dynamic>();
  var refundPolicies = [].obs;
  RxList<Macro> supportMacros = <Macro>[].obs;
  var terms = [].obs;
  var assessmentAttentionQn = <String>[].obs;
  var users = [].obs;
  var banners = <Banners>[].obs;
  var coupons = <Coupons>[].obs;
  RxList<Object> recommendations = <Object>[].obs;
  var hiringAd = <HiringAd>[].obs;
  RxList<Map<String, dynamic>> ratingValues = <Map<String, dynamic>>[].obs;
  var supports = <Macro>[].obs;
  var materials = <Materials>[].obs;
  var testTypes = <String>[].obs;

  RxBool isDeleteButtonLoading = false.obs;

  RxList<VisibleTo> selected = <VisibleTo>[].obs;
  RxList selectedSyllabus = [].obs;
  var selectedStartDate = Rxn<DateTime>();
  var selectedEndDate = Rxn<DateTime>();
  RxList<Days> selectedDays = <Days>[].obs;
  RxList<String> selectedTestType = <String>[].obs;
  RxList selectedAttentionQns = [].obs;

  TextEditingController monthController = TextEditingController();
  TextEditingController hourController = TextEditingController();
  TextEditingController regFeeController = TextEditingController();
  TextEditingController taxController = TextEditingController();
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

  TextEditingController batchController = TextEditingController();
  TextEditingController packageController = TextEditingController();
  TextEditingController categoryController = TextEditingController();
  TextEditingController courseController = TextEditingController();
  TextEditingController syllabusController = TextEditingController();
  TextEditingController standardController = TextEditingController();

  var selectedType = "HOURS_AFTER_SESSION".obs;
  var hours = "".obs;
  var dayOfMonth = "".obs;
  var isActive = true.obs;
  Rx<String> selectedDiscountType = 'percentage'.obs;
  Rx<String> selectedRecommendationType = 'package'.obs;
  Rx<String> selectedMaterialType = 'drive'.obs;
  Rx<String> selectedUser = 'batch'.obs;

  TextEditingController timeController = TextEditingController();

  var textControllers = <TextEditingController>[].obs;

  TextEditingController dateController = TextEditingController();

  Map<String, String> settingsPermissions = {
    "General": "general_settings",
    "Notifications": "notification_settings",
    "Banner Ads": "banner_ads",
    "Coupons": "coupon_settings",
    "Recommendation": "recommendation_settings",
    "Hiring": "hiring_settings",
    "Star of Month": "star_settings",
    "Automation": "automation_settings",
    "Assessments": "assessment_settings",
    "Materials": "material_settings",
    "Bulk Upload": "bulk_upload",
    "Backup": "backup_settings",
  };
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
    fetchCoupons();
    fetchAssessments();
    fetchRecommendations();
    fetchHiringAds();
    fetchBanners();
    fetchSupports();
    fetchMaterials();
  }

  Future<dynamic> commonFetch({
    required Future<dynamic> Function() apiCall,
    Function(dynamic data)? onSuccess,
  }) async {
    errorMessage.value = '';

    try {
      isLoading.value = true;

      final result = await apiCall();

      if (result is String) {
        final cs = Theme.of(Get.context!).colorScheme;
        Get.snackbar(
          'Error',
          result,
          colorText: cs.shadow,
        );

        return null;
      }

      if (onSuccess != null) {
        onSuccess(result);
      }

      return result;
    } catch (e) {
      final cs = Theme.of(Get.context!).colorScheme;
      Get.snackbar(
        'Error',
        e.toString(),
        colorText: cs.shadow,
      );
    } finally {
      isLoading.value = false;
    }

    return null;
  }

  Future<void> getSupportTickets() async {
    supportTickets.value = await commonFetch(
      apiCall: () => Api().getSupportTickets(),
    );
  }

  Future<void> getRegistrationFee() async {
    final result = await commonFetch(
      apiCall: () => Api().getRegistrationFee(),
    );

    if (result != null) {
      registrationFee.value = result;

      regFeeController.text = result['value'] ?? '';
    }
  }

  Future<void> getStarFactor() async {
    final result = await commonFetch(
      apiCall: () => Api().getStarFactor(),
    );

    if (result != null) {
      starFactor.value = result;

      factorValueController.text = result['factor_value'].toString();
    }
  }

  Future<void> getSalaryInvoiceTaxSettings() async {
    salaryInvoiceTaxSettings.value = await commonFetch(
      apiCall: () => Api().getSalaryInvoiceTaxSettings(),
    );
  }

  Future<void> getSupportCategories() async {
    final data = await commonFetch(
      apiCall: () => Api().getSupportCategories(),
    );
    supportCategories.assignAll(
      data.map<Syllabus>((e) => Syllabus.fromJson(e)).toList(),
    );
  }

  Future<void> getReferralSources() async {
    final data = await commonFetch(
      apiCall: () => Api().getReferralSources(),
    );
    referralSources.assignAll(
      data.map<Syllabus>((e) => Syllabus.fromJson(e)).toList(),
    );
  }

  Future<void> getAssessmentQuestions() async {
    final data = await commonFetch(
      apiCall: () => Api().getAssessmentQuestions(),
    );
    assessmentAttentionQns.assignAll(
      data
          .map<AssessmentAttentionQns>(
              (e) => AssessmentAttentionQns.fromJson(e))
          .toList(),
    );
  }

  Future<void> getSyllabuses() async {
    final data = await commonFetch(
      apiCall: () => Api().getSyllabuses(),
    );

    syllabus.assignAll(
      data.map<Syllabus>((e) => Syllabus.fromJson(e)).toList(),
    );
  }

  Future<void> getCourses() async {
    final data = await commonFetch(
      apiCall: () => Api().getCourses(),
    );

    course.assignAll(
      data.map<Syllabus>((e) => Syllabus.fromJson(e)).toList(),
    );
  }

  Future<void> getPackageNames() async {
    final data = await commonFetch(
      apiCall: () => Api().getPackageNames(),
    );
    packageNames.assignAll(
      data.map<Syllabus>((e) => Syllabus.fromJson(e)).toList(),
    );
  }

  Future<void> getCategories() async {
    final data = await commonFetch(
      apiCall: () => Api().getCategories(),
    );
    categories.assignAll(
      data.map<Syllabus>((e) => Syllabus.fromJson(e)).toList(),
    );
  }

  Future<void> getStandards() async {
    final data = await commonFetch(
      apiCall: () => Api().getStandards(),
    );

    final list = data.map<Syllabus>((e) => Syllabus.fromJson(e)).toList();

    list.sort((a, b) => _compareStandard(a.name, b.name));

    standards.assignAll(list);
  }

  Future<void> getCompletionDeadlineSettings() async {
    final data = await commonFetch(
      apiCall: () => Api().getCompletionDeadlineSettings(),
    );
    completionDeadlineSettings.assignAll(
      data
          .map<CompletionDeadline>((e) => CompletionDeadline.fromJson(e))
          .toList(),
    );
  }

  Future<void> getCoupons() async {
    coupons.value = await commonFetch(
      apiCall: () => Api().getCoupons(),
    );
  }

  Future<void> getMaterials() async {
    materials.value = await commonFetch(
      apiCall: () => Api().getMaterials(),
    );
  }

  Future<void> getSupportMacros() async {
    supportMacros.value = await commonFetch(
      apiCall: () => Api().getSupportMacros(),
    );
  }

  Future<void> getTerms(
    String userType,
    RxString id,
    TextEditingController controller,
  ) async {
    final response = await commonFetch(
      apiCall: () => Api().getTerms(userType),
    );

    if (response != null && response is Map) {
      controller.text = response["content"]?.toString() ?? "";
      id.value = response["id"]?.toString() ?? "";
    } else {
      controller.clear();
      id.value = "";
    }
  }

  Future<void> getPrivacyPolicies(
    String userType,
    RxString id,
    TextEditingController controller,
  ) async {
    final response = await commonFetch(
      apiCall: () => Api().getPrivacyPolicies(userType),
    );

    if (response != null && response is Map) {
      controller.text = response["content"]?.toString() ?? "";
      id.value = response["id"]?.toString() ?? "";
    } else {
      controller.clear();
      id.value = "";
    }
  }

  Future<void> getRefundPolicies(
    String userType,
    RxString id,
    TextEditingController controller,
  ) async {
    final response = await commonFetch(
      apiCall: () => Api().getRefundPolicies(userType),
    );

    if (response != null && response is Map) {
      controller.text = response["content"]?.toString() ?? "";
      id.value = response["id"]?.toString() ?? "";
    } else {
      controller.clear();
      id.value = "";
    }
  }

  Future<void> updateRegistrationFee({
    required int value,
  }) async {
    isLoading.value = true;

    try {
      final success = await Api().updateRegistrationFee(value);

      if (success) {
        Get.back();
        Get.snackbar("Success", "Registration fee updated");
      } else {
        Get.snackbar("Error", "Update failed");
      }
    } catch (e) {
      Get.snackbar(
        "Error",
        e.toString(),
      );
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> updateFactorValue({
    required int value,
  }) async {
    isLoading.value = true;

    try {
      final success = await Api().updateFactorValue(value);

      if (success) {
        Get.back();
        Get.snackbar("Success", "Updated successfully");
      } else {
        Get.snackbar("Error", "Update failed");
      }
    } catch (e) {
      Get.snackbar(
        "Error",
        e.toString(),
      );
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> updateSalaryInvoiceTax({
    bool? isEnabled,
    String? taxType,
    int? value,
  }) async {
    isLoading.value = true;

    try {
      final success = await Api().updateTax(isEnabled, taxType, value);

      if (success) {
        Get.back();
        Get.snackbar("Success", "Updated successfully");
      } else {
        Get.snackbar("Error", "Update failed");
      }
    } catch (e) {
      Get.snackbar(
        "Error",
        e.toString(),
      );
    } finally {
      isLoading.value = false;
    }
  }

  Future<Syllabus?> addSyllabus(String name) async {
    isLoading.value = true;

    try {
      final result = await Api().addSyllabus(name);

      return result;
    } catch (e) {
      Get.snackbar(
        "Error",
        e.toString(),
      );
      return null;
    } finally {
      isLoading.value = false;
    }
  }

  Future<bool> updateSyllabus({
    required String id,
    required String syllabus,
  }) async {
    isLoading.value = true;

    try {
      final success = await Api().updateSyllabus(id, syllabus);

      if (success) {
        if (Get.isDialogOpen ?? false) Get.back();
        Get.snackbar("Success", "Updated successfully");
        return true;
      } else {
        Get.snackbar("Error", "Update failed");
        return false;
      }
    } catch (e) {
      Get.snackbar("Error", e.toString());
      return false;
    } finally {
      isLoading.value = false;
    }
  }

  Future<bool> deleteSyllabus({
    required String id,
  }) async {
    isLoading.value = true;

    try {
      final success = await Api().deleteSyllabus(id);

      if (success) {
        syllabus.removeWhere((e) => e.id == id);

        Get.snackbar("Success", "Deleted successfully");
        return true;
      } else {
        Get.snackbar("Error", "Delete failed");
        return false;
      }
    } catch (e) {
      Get.snackbar("Error", e.toString());
      return false;
    } finally {
      isLoading.value = false;
    }
  }

  Future<Syllabus?> addCourse(String name) async {
    isLoading.value = true;

    try {
      final result = await Api().addCourse(name);

      return result;
    } catch (e) {
      Get.snackbar(
        "Error",
        e.toString(),
      );
      return null;
    } finally {
      isLoading.value = false;
    }
  }

  Future<bool> updateCourse({
    required String id,
    required String course,
  }) async {
    isLoading.value = true;

    try {
      final success = await Api().updateCourse(id, course);

      if (success) {
        Get.snackbar("Success", "Updated successfully");
        return true;
      } else {
        Get.snackbar("Error", "Update failed");
        return false;
      }
    } catch (e) {
      Get.snackbar("Error", e.toString());
      return false;
    } finally {
      isLoading.value = false;
    }
  }

  Future<bool> deleteCourse({
    required String id,
  }) async {
    isLoading.value = true;

    try {
      final success = await Api().deleteCourse(id);

      if (success) {
        course.removeWhere((e) => e.id == id);

        Get.snackbar("Success", "Deleted successfully");
        return true;
      } else {
        Get.snackbar("Error", "Delete failed");
        return false;
      }
    } catch (e) {
      Get.snackbar("Error", e.toString());
      return false;
    } finally {
      isLoading.value = false;
    }
  }

  Future<Syllabus?> addPackage(String name) async {
    isLoading.value = true;

    try {
      final result = await Api().addPackage(name);

      return result;
    } catch (e) {
      Get.snackbar(
        "Error",
        e.toString(),
      );
      return null;
    } finally {
      isLoading.value = false;
    }
  }

  Future<bool> updatePackage({
    required String id,
    required String package,
  }) async {
    isLoading.value = true;

    try {
      final success = await Api().updatePackage(id, package);

      if (success) {
        Get.snackbar("Success", "Updated successfully");
        return true;
      } else {
        Get.snackbar("Error", "Update failed");
        return false;
      }
    } catch (e) {
      Get.snackbar("Error", e.toString());
      return false;
    } finally {
      isLoading.value = false;
    }
  }

  Future<bool> deletePackage({
    required String id,
  }) async {
    isLoading.value = true;

    try {
      final success = await Api().deletePackage(id);

      if (success) {
        course.removeWhere((e) => e.id == id);

        Get.snackbar("Success", "Deleted successfully");
        return true;
      } else {
        Get.snackbar("Error", "Delete failed");
        return false;
      }
    } catch (e) {
      Get.snackbar("Error", e.toString());
      return false;
    } finally {
      isLoading.value = false;
    }
  }

  Future<Syllabus?> addCategory(String name) async {
    isLoading.value = true;

    try {
      final result = await Api().addCategory(name);

      return result;
    } catch (e) {
      Get.snackbar(
        "Error",
        e.toString(),
      );
      return null;
    } finally {
      isLoading.value = false;
    }
  }

  Future<bool> updateCategory({
    required String id,
    required String category,
  }) async {
    isLoading.value = true;

    try {
      final success = await Api().updateCategory(id, category);

      if (success) {
        Get.snackbar("Success", "Updated successfully");
        return true;
      } else {
        Get.snackbar("Error", "Update failed");
        return false;
      }
    } catch (e) {
      Get.snackbar("Error", e.toString());
      return false;
    } finally {
      isLoading.value = false;
    }
  }

  Future<bool> deleteCategory({
    required String id,
  }) async {
    isLoading.value = true;

    try {
      final success = await Api().deleteCategory(id);

      if (success) {
        course.removeWhere((e) => e.id == id);

        Get.snackbar("Success", "Deleted successfully");
        return true;
      } else {
        Get.snackbar("Error", "Delete failed");
        return false;
      }
    } catch (e) {
      Get.snackbar("Error", e.toString());
      return false;
    } finally {
      isLoading.value = false;
    }
  }

  Future<Syllabus?> addStandard(String name) async {
    isLoading.value = true;

    try {
      final result = await Api().addStandard(name);

      return result;
    } catch (e) {
      Get.snackbar(
        "Error",
        e.toString(),
      );
      return null;
    } finally {
      isLoading.value = false;
    }
  }

  Future<bool> updateStandard({
    required String id,
    required String standard,
  }) async {
    isLoading.value = true;

    try {
      final success = await Api().updateCourse(id, standard);

      if (success) {
        Get.snackbar("Success", "Updated successfully");
        return true;
      } else {
        Get.snackbar("Error", "Update failed");
        return false;
      }
    } catch (e) {
      Get.snackbar("Error", e.toString());
      return false;
    } finally {
      isLoading.value = false;
    }
  }

  Future<bool> deleteStandard({
    required String id,
  }) async {
    isLoading.value = true;

    try {
      final success = await Api().deleteStandard(id);

      if (success) {
        course.removeWhere((e) => e.id == id);

        Get.snackbar("Success", "Deleted successfully");
        return true;
      } else {
        Get.snackbar("Error", "Delete failed");
        return false;
      }
    } catch (e) {
      Get.snackbar("Error", e.toString());
      return false;
    } finally {
      isLoading.value = false;
    }
  }

  Future<Syllabus?> addSupportCategory(String name) async {
    isLoading.value = true;

    try {
      final result = await Api().addStandard(name);

      return result;
    } catch (e) {
      Get.snackbar(
        "Error",
        e.toString(),
      );
      return null;
    } finally {
      isLoading.value = false;
    }
  }

  Future<bool> updateSupportCategory({
    required String id,
    required String category,
  }) async {
    isLoading.value = true;

    try {
      final success = await Api().updateCourse(id, category);

      if (success) {
        Get.snackbar("Success", "Updated successfully");
        return true;
      } else {
        Get.snackbar("Error", "Update failed");
        return false;
      }
    } catch (e) {
      Get.snackbar("Error", e.toString());
      return false;
    } finally {
      isLoading.value = false;
    }
  }

  Future<bool> deleteSupportCategory({
    required String id,
  }) async {
    isLoading.value = true;

    try {
      final success = await Api().deleteStandard(id);

      if (success) {
        course.removeWhere((e) => e.id == id);

        Get.snackbar("Success", "Deleted successfully");
        return true;
      } else {
        Get.snackbar("Error", "Delete failed");
        return false;
      }
    } catch (e) {
      Get.snackbar("Error", e.toString());
      return false;
    } finally {
      isLoading.value = false;
    }
  }

  Future<Syllabus?> addReferralSource(String name) async {
    isLoading.value = true;

    try {
      final result = await Api().addStandard(name);

      return result;
    } catch (e) {
      Get.snackbar(
        "Error",
        e.toString(),
      );
      return null;
    } finally {
      isLoading.value = false;
    }
  }

  Future<bool> updateReferralSource({
    required String id,
    required String referral,
  }) async {
    isLoading.value = true;

    try {
      final success = await Api().updateCourse(id, referral);

      if (success) {
        Get.snackbar("Success", "Updated successfully");
        return true;
      } else {
        Get.snackbar("Error", "Update failed");
        return false;
      }
    } catch (e) {
      Get.snackbar("Error", e.toString());
      return false;
    } finally {
      isLoading.value = false;
    }
  }

  Future<bool> deleteReferralSource({
    required String id,
  }) async {
    isLoading.value = true;

    try {
      final success = await Api().deleteStandard(id);

      if (success) {
        course.removeWhere((e) => e.id == id);

        Get.snackbar("Success", "Deleted successfully");
        return true;
      } else {
        Get.snackbar("Error", "Delete failed");
        return false;
      }
    } catch (e) {
      Get.snackbar("Error", e.toString());
      return false;
    } finally {
      isLoading.value = false;
    }
  }
  Future<AssessmentAttentionQns?> addAssessmentAttentionQn(String name) async {
    isLoading.value = true;

    try {
      final result = await Api().addAssessmentAttentionQn(name);

      return result;
    } catch (e) {
      Get.snackbar(
        "Error",
        e.toString(),
      );
      return null;
    } finally {
      isLoading.value = false;
    }
  }

  Future<bool> updateAssessmentAttentionQn({
    required String id,
    required String question,
  }) async {
    isLoading.value = true;

    try {
      final success = await Api().updateCourse(id, question);

      if (success) {
        Get.snackbar("Success", "Updated successfully");
        return true;
      } else {
        Get.snackbar("Error", "Update failed");
        return false;
      }
    } catch (e) {
      Get.snackbar("Error", e.toString());
      return false;
    } finally {
      isLoading.value = false;
    }
  }

  Future<bool> deleteAssessmentAttentionQn({
    required String id,
  }) async {
    isLoading.value = true;

    try {
      final success = await Api().deleteStandard(id);

      if (success) {
        course.removeWhere((e) => e.id == id);

        Get.snackbar("Success", "Deleted successfully");
        return true;
      } else {
        Get.snackbar("Error", "Delete failed");
        return false;
      }
    } catch (e) {
      Get.snackbar("Error", e.toString());
      return false;
    } finally {
      isLoading.value = false;
    }
  }

  Future<bool> updateTerms(
      {required String id,
      required String content,
      required String userType}) async{
    isLoading.value = true;

    try {
      final success = await Api().updateTerms(
        id: id,
        userType: userType ?? '',
        content: content ?? '',
      );

      if (success) {
        if (Get.isDialogOpen ?? false) Get.back();
        Get.snackbar("Success", "Updated successfully");
        return true;
      } else {
        Get.snackbar("Error", "Update failed");
        return false;
      }
    } catch (e) {
      Get.snackbar("Error", e.toString());
      return false;
    } finally {
      isLoading.value = false;
    }
  }

  Future<bool> updatePrivacyPolicies({
    required String id,
    required String content,
    required String userType,
  }) async {
    isLoading.value = true;

    try {
      final success = await Api().updatePrivacyPolicies(
        id: id,
        userType: userType,
        content: content,
      );

      if (success) {
        if (Get.isDialogOpen ?? false) Get.back();
        Get.snackbar("Success", "Updated successfully");
        return true;
      } else {
        Get.snackbar("Error", "Update failed");
        return false;
      }
    } catch (e) {
      Get.snackbar("Error", e.toString());
      return false;
    } finally {
      isLoading.value = false;
    }
  }

  Future<bool> updateRefundPolicies({
    required String id,
    required String content,
    required String userType,
  }) async {
    isLoading.value = true;

    try {
      final success = await Api().updateRefundPolicies(
        id: id,
        userType: userType,
        content: content,
      );

      if (success) {
        if (Get.isDialogOpen ?? false) Get.back();
        Get.snackbar("Success", "Updated successfully");
        return true;
      } else {
        Get.snackbar("Error", "Update failed");
        return false;
      }
    } catch (e) {
      Get.snackbar("Error", e.toString());
      return false;
    } finally {
      isLoading.value = false;
    }
  }

  Future<bool> updateDeadline(
      {required String id,
      String? type,
      String? role,
      bool? isActive,
      int? value}) async {
    isLoading.value = true;

    try {
      final success = await Api().updateDeadline(
          id: id,
          role: role ?? '',
          deadlineType: type ?? '',
          isActive: isActive ?? false,
          value: value ?? 0);

      if (success) {
        Get.snackbar("Success", "Updated successfully");
        return true;
      } else {
        Get.snackbar("Error", "Update failed");
        return false;
      }
    } catch (e) {
      Get.snackbar("Error", e.toString());
      return false;
    } finally {
      isLoading.value = false;
    }
  }

  String getLabel(VisibleTo v) {
    switch (v) {
      case VisibleTo.all:
        return "All";
      case VisibleTo.admin:
        return "Admin";
      case VisibleTo.student:
        return "Student";
      case VisibleTo.teacher:
        return "Teacher";
      case VisibleTo.mentor:
        return "Mentor";
      case VisibleTo.coordinator:
        return "Coordinator";
      case VisibleTo.other:
        return "Other";
    }
  }

  Future<void> fetchBanners() async {
    errorMessage.value = '';

    try {
      isLoading.value = true;

      final result = await Api().getBanners();

      if (result is String) {
        Get.snackbar(
          'Error',
          result,
          colorText: Theme.of(Get.context!).colorScheme.onPrimary,
        );

        return;
      }

      banners.assignAll(
        result
            .map<Banners>(
              (e) => Banners.fromJson(e),
            )
            .toList(),
      );
    } catch (e) {
      Get.snackbar(
        'Error',
        e.toString(),
        colorText: Theme.of(Get.context!).colorScheme.onPrimary,
      );
    } finally {
      isLoading.value = false;
    }
  }

  VisibleTo visibleToFromString(String value) {
    switch (value.toUpperCase()) {
      case 'ADMIN':
        return VisibleTo.admin;

      case 'TEACHER':
        return VisibleTo.teacher;

      case 'STUDENT':
        return VisibleTo.student;

      case 'MENTOR':
        return VisibleTo.mentor;

      case 'COORDINATOR':
        return VisibleTo.coordinator;

      default:
        return VisibleTo.other;
    }
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

  Future<void> fetchRecommendations() async {
    try {
      isLoading.value = true;

      final responses = await Future.wait([
        Api().getPackageRecommendations(),
        Api().getBatchRecommendations(),
      ]);

      final packageResponse = responses[0];
      final batchResponse = responses[1];

      List<Object> allRecommendations = [];

      /// PACKAGE RECOMMENDATIONS
      if (packageResponse != null) {
        final List data = packageResponse as List;

        final packageList =
            data.map((e) => PackageRecommendations.fromJson(e)).toList();

        allRecommendations.addAll(packageList);

        if (packageList.isNotEmpty) {
          selectedSyllabus.assignAll(
            packageList.first.showToSyllabuses
                    ?.map((e) => e.name ?? '')
                    .toList() ??
                [],
          );
        }
      }

      /// BATCH RECOMMENDATIONS
      if (batchResponse != null) {
        final List data = batchResponse as List;

        final batchList =
            data.map((e) => BatchRecommendations.fromJson(e)).toList();

        allRecommendations.addAll(batchList);
      }

      recommendations.assignAll(allRecommendations);
    } catch (e) {
      debugPrint('fetchRecommendations error: $e');
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

      final response = await Api().getHiringAds();

      hiringAd.assignAll(
        (response as List).map((e) => HiringAd.fromJson(e)).toList(),
      );
      // if (hiringAd.isNotEmpty) {
      //   selectedSyllabus.assignAll(recommendations.first.visibleTo);
      // }
    } catch (e) {
      print('Error fetching hiring ads: $e');
    } finally {
      isLoading.value = false;
    }
  }

  // void loadHiringAds(HiringAd ad) {
  //   nameController.text = ad.package ?? '';
  //   timeController.text = ad.time ?? '';
  //   startDateController.text = ad.startDate.toString();
  //   endDateController.text = ad.endDate.toString();
  //   selectedDays.assignAll(ad.days ?? []);
  // }

  Future<void> fetchRatingValues() async {
    try {
      isLoading.value = true;

      final response = await Api().globalRatingValues();

      if (response is RatingValue) {
        final data = [
          {"label": "MV1", "value": response.values.mv1},
          {"label": "MV2", "value": response.values.mv2},
          {"label": "MV3", "value": response.values.mv3},
          {"label": "MV4", "value": response.values.mv4},
          {"label": "MV5", "value": response.values.mv5},
        ];

        ratingValues.assignAll(data);

        textControllers.clear();

        for (var item in data) {
          textControllers.add(
            TextEditingController(
              text: item["value"].toString(),
            ),
          );
        }
      }
    } catch (e) {
      log("Error fetching rating values: $e");
    } finally {
      isLoading.value = false;
    }
  }
  // void addField({String defaultValue = "0"}) {
  //   textControllers.add(TextEditingController(text: defaultValue));
  //   ratingValues.add(RatingValue(
  //       label: "MV${ratingValues.length + 1}",
  //       value: double.tryParse(defaultValue) ?? 0));
  // }

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

      final response = await Api().getSupportMacros();

      supportMacros.assignAll(
        (response as List).map((e) => Macro.fromJson(e)).toList(),
      );
    } catch (e) {
      log('Error fetching macros: $e');
    } finally {
      isLoading.value = false;
    }
  }

  void loadSupports(Macro macro) {
    titleController.text = macro.title ?? '';
    messageController.text = macro.description ?? '';
  }

  void fetchAssessments() async {
    try {
      isLoading.value = true;

      final data = await Api().getAssessmentReportTypes();

      assessmentReportTypes.assignAll(data);
    } catch (e) {
      Get.snackbar(
        'Error',
        e.toString(),
      );
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> fetchMaterials() async {
    try {
      isLoading.value = true;

      final response = await Api().getMaterials();

      if (response != null) {
        final List data = response as List;

        materials.assignAll(
          data.map((e) => Materials.fromJson(e)).toList(),
        );
      }
    } catch (e) {
      debugPrint('fetchMaterials error: $e');
    } finally {
      isLoading.value = false;
    }
  }
  // void loadMaterials(Materials material) {
  //   selectedUser.value = material.type!.toLowerCase();
  //   titleController.text = material.title ?? '';
  //   packageController.text = material.package ?? '';
  //   categoryController.text = material.category ?? '';
  //   courseController.text = material.course ?? '';
  //   batchController.text = material.batch ?? '';
  //   messageController.text = material.description ?? '';
  //   urlController.text = material.link ?? '';
  // }

  void clearController() {
    titleController.clear();
    packageController.clear();
    categoryController.clear();
    courseController.clear();
    batchController.clear();
    messageController.clear();
    urlController.clear();
  }

  int _compareStandard(String a, String b) {
    int? aNum = int.tryParse(a);
    int? bNum = int.tryParse(b);

    if (aNum != null && bNum != null) {
      return aNum.compareTo(bNum);
    }

    if (aNum != null) return -1;
    if (bNum != null) return 1;

    const order = [
      "Pre KG",
      "Nursery",
      "LKG",
      "UKG",
      "Other",
    ];

    int aIndex = order.indexOf(a);
    int bIndex = order.indexOf(b);

    if (aIndex != -1 && bIndex != -1) {
      return aIndex.compareTo(bIndex);
    }

    if (aIndex != -1) return -1;
    if (bIndex != -1) return 1;

    return a.compareTo(b);
  }
}
