import 'dart:developer';
import 'dart:io';
import 'dart:typed_data';

import 'package:albedo_app/api.dart';
import 'package:albedo_app/model/batch_model.dart';
import 'package:albedo_app/model/package_model.dart';
import 'package:albedo_app/model/settings/assessment_model.dart';
import 'package:albedo_app/model/settings/banners_model.dart';
import 'package:albedo_app/model/settings/coupons_model.dart';
import 'package:albedo_app/model/settings/hiring_ad_model.dart';
import 'package:albedo_app/model/settings/material_model.dart';
import 'package:albedo_app/model/settings/rating_value_model.dart';
import 'package:albedo_app/model/settings/recommendations_model.dart';
import 'package:albedo_app/model/settings/syllabus_model.dart';
import 'package:albedo_app/model/support_model.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';

class SettingsController extends GetxController {
  RxBool isLoading = true.obs;
  var selectedTab = 0.obs;
  var errorMessage = ''.obs;
  RxString editingId = ''.obs;

  final RxString feeType = "percentage".obs;
  final RxString status = "inactive".obs;
  final bannerMediaPath = ''.obs;
  final isVideo = false.obs;
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
  final assessmentReportTypes = <Assessment>[].obs;
  var hiringAds = [].obs;
  var privacyPolicies = [].obs;
  final salaryInvoiceTaxSettings = Rxn<dynamic>();
  var refundPolicies = [].obs;
  RxList<Macro> supportMacros = <Macro>[].obs;
  var users = [].obs;
  var banners = <Banners>[].obs;
  var batches = <BatchDetail>[].obs;
  var coupons = <Coupons>[].obs;
  RxList<RecommendationItem> recommendations = <RecommendationItem>[].obs;
  var hiringAd = <HiringAd>[].obs;
  RxList<Map<String, dynamic>> ratingValues = <Map<String, dynamic>>[].obs;
  var supports = <Macro>[].obs;
  var materials = <Materials>[].obs;
  var testTypes = <TestType>[].obs;
  RxBool isDeleteButtonLoading = false.obs;

  RxList<VisibleTo> selected = <VisibleTo>[].obs;
  Rx<File?> selectedMedia = Rx<File?>(null);
  RxList selectedSyllabus = [].obs;
  final RxString selectedBulkType = 'student'.obs;
  var selectedStartDate = Rxn<DateTime>();
  var selectedPackage = Rxn<Syllabus>();
  var selectedBatch = Rxn<BatchDetail>();
  var selectedEndDate = Rxn<DateTime>();
  RxList<Days> availableDays = <Days>[].obs;
  RxList<Days> selectedDays = <Days>[].obs;
  RxList<TestType> selectedTestType = <TestType>[].obs;
  RxList<AssessmentAttentionQns> selectedAttentionQns =
      <AssessmentAttentionQns>[].obs;
  Rx<Uint8List?> selectedRecommendationImage = Rx<Uint8List?>(null);
  Rx<Uint8List?> selectedHiringAdImage = Rx<Uint8List?>(null);

  PlatformFile? selectedRecommendationFile;
  PlatformFile? selectedHiringFile;
  File? selectedCsvFile;

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
  final emailCtrl = TextEditingController();

  TextEditingController titleController = TextEditingController();
  TextEditingController messageController = TextEditingController();

  TextEditingController urlController = TextEditingController();
  TextEditingController driveUrlController = TextEditingController();
  TextEditingController youtubeUrlController = TextEditingController();
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
  final RxInt ratingId = 0.obs;
  Rx<String> selectedDiscountType = 'percentage'.obs;
  Rx<String> selectedRecommendationType = 'package'.obs;
  Rx<String> selectedMaterialType = 'drive'.obs;
  Rx<String> selectedUser = 'batch'.obs;

  RxList<BatchDetail> selectedBatches = <BatchDetail>[].obs;

  RxList<Syllabus> selectedPackages = <Syllabus>[].obs;
  RxList<Syllabus> selectedCategories = <Syllabus>[].obs;
  RxList<Syllabus> selectedCourses = <Syllabus>[].obs;
  RxList<Syllabus> selectedSyllabi = <Syllabus>[].obs;
  RxList<Syllabus> selectedStandards = <Syllabus>[].obs;

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
    final data = await commonFetch(
      apiCall: () => Api().getCoupons(),
    );
    coupons.assignAll(
      data.map<Coupons>((e) => Coupons.fromJson(e)).toList(),
    );
  }

  Future<void> getMaterials() async {
    final data = await commonFetch(
      apiCall: () => Api().getMaterials(),
    );
    materials.assignAll(
      data.map<Materials>((e) => Materials.fromJson(e)).toList(),
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
      final success = await Api().updateAssessmentAttentionQn(id, question);

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
      final success = await Api().deleteAssessmentAttentionQn(id);

      if (success) {
        assessmentAttentionQns.removeWhere((e) => e.id == id);

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

  Future<Assessment?> addAssessment({required Map<String, Object> body}) async {
    isLoading.value = true;

    try {
      final result = await Api().addAssessment(body: body);

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

  Future<bool> updateAssessment(
      {required String id, required Map<String, Object> body}) async {
    isLoading.value = true;

    try {
      final success = await Api().updateAssessment(id, body);

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

  Future<bool> deleteAssessment({
    required String id,
  }) async {
    isLoading.value = true;

    try {
      final success = await Api().deleteAssessment(id);

      if (success) {
        assessmentReportTypes.removeWhere((e) => e.id == id);

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

  Future<Materials?> addMaterial({required Map<String, Object?> body}) async {
    isLoading.value = true;

    try {
      final result = await Api().addMaterial(body: body);

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

  Future<bool> updateMaterial(
      {required String id, required Map<String, Object?> body}) async {
    isLoading.value = true;

    try {
      final success = await Api().updateMaterial(id, body);

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

  Future<bool> deleteMaterial(
    String id,
  ) async {
    isLoading.value = true;

    try {
      final success = await Api().deleteMaterial(id);

      if (success) {
        materials.removeWhere((e) => e.id == id);

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

  Future<RecommendationItem?> addRecommendation(
      {required Map<String, Object?> body}) async {
    isLoading.value = true;

    try {
      final type = body['type'];

      final result = type == 'package'
          ? await Api().addPackageRecommendation(body: body)
          : await Api().addBatchRecommendation(body: body);

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

  Future<bool> updateRecommendation(
      {required String id, required Map<String, Object?> body}) async {
    isLoading.value = true;

    try {
      final success = await Api().updateRecommendation(id, body);

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

  Future<bool> deleteRecommendation(
    String id,
  ) async {
    isLoading.value = true;

    try {
      final success = await Api().deleteRecommendation(id);

      if (success) {
        hiringAd.removeWhere((e) => e.id == id);

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

  Future<HiringAd?> addHiringAd({required Map<String, Object?> body}) async {
    isLoading.value = true;

    try {
      final result = await Api().addHiringAd(body: body);

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

  Future<bool> updateHiringAd(
      {required String id, required Map<String, Object?> body}) async {
    isLoading.value = true;

    try {
      final success = await Api().updateHiringAd(id, body);

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

  Future<bool> deleteHiringAd(
    String id,
  ) async {
    isLoading.value = true;

    try {
      final success = await Api().deleteHiringAd(id);

      if (success) {
        hiringAd.removeWhere((e) => e.id == id);

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

  Future<Macro?> addMacro({required Map<String, Object?> body}) async {
    isLoading.value = true;

    try {
      final result = await Api().addMacro(body: body);

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

  Future<bool> updateMacro(
      {required String id, required Map<String, Object?> body}) async {
    isLoading.value = true;

    try {
      final success = await Api().updateMacro(id, body);

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

  Future<bool> deleteMacro(
    String id,
  ) async {
    isLoading.value = true;

    try {
      final success = await Api().deleteHiringAd(id);

      if (success) {
        supportMacros.removeWhere((e) => e.id == id);

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
      required String userType}) async {
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

  Future<void> fetchBatches() async {
    errorMessage.value = '';

    try {
      isLoading.value = true;

      final result = await Api().getBatches();

      if (result is String) {
        Get.snackbar(
          'Error',
          result,
          colorText: Theme.of(Get.context!).colorScheme.onPrimary,
        );

        return;
      }

      batches.assignAll(
        result
            .map<BatchDetail>(
              (e) => BatchDetail.fromJson(e),
            )
            .toList(),
      );
      log(batches.length.toString());
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
      case 'ALL':
        return VisibleTo.all;
      case 'ADMIN':
        return VisibleTo.admin;

      case 'TEACHER':
        return VisibleTo.teacher;

      case 'STUDENT':
        return VisibleTo.student;

      case 'MENTOR':
        return VisibleTo.mentor;

      case 'ASSISTANT_ADMIN':
        return VisibleTo.coordinator;

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

      List<RecommendationItem> allRecommendations = [];

      /// PACKAGE
      if (packageResponse != null) {
        final List data = packageResponse as List;

        final packageList = data.map((e) {
          final item = PackageRecommendations.fromJson(e);

          return RecommendationItem(
            id: item.id,
            title: item.recommendedPackage,
            recommendedPackage: item.recommendedPackage,
            type: "package",
            image: item.image,
            fromDate: item.fromDate,
            toDate: item.toDate,
            syllabuses:
                item.showToSyllabuses?.map((e) => e.name ?? '').toList() ?? [],
          );
        }).toList();
        allRecommendations.addAll(packageList);
      }

      /// BATCH
      if (batchResponse != null) {
        final List data = batchResponse as List;

        final batchList = data.map((e) {
          final item = BatchRecommendations.fromJson(e);

          return RecommendationItem(
            id: item.id,
            title: item.recommendedBatch,
            recommendedBatch: item.recommendedBatch,
            type: "batch",
            image: item.image,
            fromDate: item.fromDate,
            toDate: item.toDate,
            syllabuses:
                item.showToSyllabuses?.map((e) => e.name ?? '').toList() ?? [],
          );
        }).toList();

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

  Future<String?> backup(String email) async {
    isLoading.value = true;

    try {
      final result = await Api().backup(emailCtrl.text);
      if (result != null) {
        Get.snackbar(
          "Success",
          result,
        );
      } else {
        Get.snackbar(
          "Error",
          "Backup failed",
        );
      }
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

  Future<void> fetchRatingValues() async {
    try {
      isLoading.value = true;

      final response = await Api().globalRatingValues();

      if (response is RatingValue) {
        ratingId.value = response.id ?? 0;

        /// STORE DATE
        startDateController.text = response.validFrom ?? '';
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

  void addField() {
    final nextIndex = ratingValues.length + 1;

    ratingValues.add({
      "label": "MV$nextIndex",
      "value": "",
    });

    textControllers.add(
      TextEditingController(),
    );

    ratingValues.refresh();
  }

  void removeField(int index) {
    if (ratingValues.length > 5) {
      textControllers.removeAt(index);
      ratingValues.removeAt(index);
    } else {
      Get.snackbar("Error", "Minimum 5 values required",
          snackPosition: SnackPosition.BOTTOM);
    }
  }

  Future<void> saveSettings() async {
    try {
      isLoading.value = true;

      /// CREATE VALUES MAP
      final Map<String, dynamic> values = {};

      for (int i = 0; i < ratingValues.length; i++) {
        final label = ratingValues[i]["label"];
        final text = textControllers[i].text.trim();

        /// VALIDATE EMPTY FIELD
        if (text.isEmpty) {
          Get.snackbar(
            "Error",
            "$label value cannot be empty",
            backgroundColor: Colors.red,
            colorText: Colors.white,
          );

          isLoading.value = false;
          return;
        }

        /// VALIDATE NUMBER
        final parsedValue = double.tryParse(text);

        if (parsedValue == null) {
          Get.snackbar(
            "Error",
            "$label must be a valid number",
            backgroundColor: Colors.red,
            colorText: Colors.white,
          );

          isLoading.value = false;
          return;
        }

        values[label] = parsedValue;
      }

      final body = {
        "id": ratingId.value,
        "valid_from": startDateController.text,
        "values": values,
      };

      log(body.toString());

      /// API CALL
      await Api().saveRatingValues(body);

      Get.snackbar(
        "Success",
        "Settings saved successfully",
      );
    } catch (e) {
      Get.snackbar(
        "Error",
        e.toString().replaceAll("Exception:", "").trim(),
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
    } finally {
      isLoading.value = false;
    }
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

  Future<void> fetchTestTypes() async {
    try {
      isLoading.value = true;

      final response = await Api().getTestType();

      if (response != null) {
        final List data = response as List;

        testTypes.assignAll(
          data.map((e) => TestType.fromJson(e)).toList(),
        );
      }
    } catch (e) {
      debugPrint('fetch test types error: $e');
    } finally {
      isLoading.value = false;
    }
  }

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

  void delete(String? id) {}

  Future<void> updateBanner(
      {required String bannerId, required Map<String, Object> body}) async {
    isLoading.value = true;

    try {
      final success = await Api().updateBannerAd(bannerId, body);

      if (success) {
        Get.back();
        Get.snackbar("Success", "Banner Ad updated");
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

  Future<Banners?> addBanner({required Map<String, Object> body}) async {
    isLoading.value = true;

    try {
      final result = await Api().addBanner(body: body);

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

  Future<bool> deleteBanner({
    required String id,
  }) async {
    isLoading.value = true;

    try {
      final success = await Api().deleteBannerAd(id);

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

  Future<Coupons?> updateCouponCode({
    required String couponId,
    required Map<String, String?> body,
  }) async {
    isLoading.value = true;

    try {
      final result = await Api().updateCouponCode(
        couponId,
        body,
      );

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

  Future<Coupons?> addCouponCode({required Map<String, String?> body}) async {
    isLoading.value = true;

    try {
      log(body.toString());
      final result = await Api().addCouponCode(body: body);

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

  Future<bool> deleteCouponCode({
    required String id,
  }) async {
    isLoading.value = true;

    try {
      final success = await Api().deleteCouponCode(id);

      if (success) {
        coupons.removeWhere((e) => e.id == id);

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

  bool isVideoFile(String path) {
    final lower = path.toLowerCase();

    return lower.endsWith('.mp4') ||
        lower.endsWith('.mov') ||
        lower.endsWith('.webm') ||
        lower.endsWith('.mkv');
  }

  Future<void> pickMedia() async {
    final picker = ImagePicker();

    final picked = await picker.pickMedia();

    if (picked != null) {
      selectedMedia.value = File(picked.path);
    }
  }

  Future<void> pickRecommendationImage() async {
    final result = await FilePicker.pickFiles(
      type: FileType.image,
      withData: true,
    );

    if (result != null && result.files.isNotEmpty) {
      selectedRecommendationFile = result.files.first;

      selectedRecommendationImage.value = result.files.first.bytes;
    }
  }

  Future<void> pickHiringAdImage() async {
    final result = await FilePicker.pickFiles(
      type: FileType.image,
      withData: true,
    );

    if (result != null && result.files.isNotEmpty) {
      selectedHiringFile = result.files.first;

      selectedHiringAdImage.value = result.files.first.bytes;
    }
  }

  Future<File?> pickCsvFile() async {
    try {
      final result = await FilePicker.pickFiles(
        type: FileType.custom,
        allowedExtensions: ['csv'],
      );

      if (result != null && result.files.single.path != null) {
        return File(result.files.single.path!);
      }
    } catch (e) {
      Get.snackbar("Error", e.toString());
    }

    return null;
  }

  Future<void> bulkUpload() async {
    isLoading.value = true;

    try {
      final success = await Api().bulkUploadFile(
        file: selectedCsvFile!,
        type: selectedBulkType.value,
      );

      if (success) {
        Get.snackbar("Success", "Uploaded successfully");
      } else {
        Get.snackbar("Error", "Upload failed");
      }
    } catch (e) {
      Get.snackbar("Error", e.toString());
    } finally {
      isLoading.value = false;
    }
  }

  void clearMaterialForm() {
    titleController.clear();
    messageController.clear();

    driveUrlController.clear();
    youtubeUrlController.clear();

    batchController.clear();
    packageController.clear();
    categoryController.clear();
    courseController.clear();
    syllabusController.clear();
    standardController.clear();

    selectedBatches.clear();
    selectedPackages.clear();
    selectedCategories.clear();
    selectedCourses.clear();
    selectedSyllabi.clear();
    selectedStandards.clear();

    selectedUser.value = 'batch';
    selectedMaterialType.value = 'drive';

    selectedMedia.value = null;
  }
}

enum VisibleTo {
  all,
  admin,
  student,
  teacher,
  mentor,
  coordinator,
  other,
}

extension VisibleToExtension on VisibleTo {
  String get apiValue {
    switch (this) {
      case VisibleTo.all:
        return 'ALL';
      case VisibleTo.admin:
        return 'ADMIN';
      case VisibleTo.student:
        return 'STUDENT';
      case VisibleTo.teacher:
        return 'TEACHER';
      case VisibleTo.mentor:
        return 'MENTOR';
      case VisibleTo.coordinator:
        return 'ASSISTANT_ADMIN';
      case VisibleTo.other:
        return 'OTHERS';
    }
  }

  static VisibleTo fromString(String value) {
    switch (_normalize(value)) {
      case 'ALL':
        return VisibleTo.all;
      case 'ADMIN':
        return VisibleTo.admin;
      case 'STUDENT':
        return VisibleTo.student;
      case 'TEACHER':
        return VisibleTo.teacher;
      case 'MENTOR':
        return VisibleTo.mentor;
      case 'ASSISTANT_ADMIN':
        return VisibleTo.coordinator;
      case 'OTHERS':
        return VisibleTo.other;
      default:
        return VisibleTo.other;
    }
  }
}

String _normalize(String value) {
  return value.trim().toUpperCase();
}
