import 'dart:convert';
import 'dart:developer';

import 'package:albedo_app/config/urls.dart';
import 'package:albedo_app/config/utils.dart';
import 'package:albedo_app/database/local_storage.dart';
import 'package:albedo_app/model/settings/assessment_model.dart';
import 'package:albedo_app/model/settings/rating_value_model.dart';
import 'package:albedo_app/model/settings/syllabus_model.dart';
import 'package:albedo_app/model/users/user_model.dart';
import 'package:http/http.dart' as http;

class Api {
  Future<String?> refreshAccessToken() async {
    final refreshToken = LocalStorage().readRefreshToken();

    if (refreshToken == null || refreshToken.isEmpty) return null;

    try {
      final response = await http.post(
        Uri.parse(Urls.refreshToken),
        headers: {
          "Content-Type": "application/json",
        },
        body: jsonEncode({
          "refresh": refreshToken,
        }),
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);

        final newAccess = data["access"];
        final newRefresh = data["refresh"];

        await LocalStorage().writeToken(newAccess, newRefresh);

        return newAccess;
      }
    } catch (e) {
      log("Refresh error: $e");
    }

    return null;
  }

  Future<http.Response> safeRequest(
    Future<http.Response> Function(Map<String, String> headers) request,
  ) async {
    String? accessToken = LocalStorage().readAccessToken();

    // first request
    http.Response response = await request(getHeader(accessToken));

    // if expired → refresh
    if (response.statusCode == 401) {
      accessToken = await refreshAccessToken();

      if (accessToken != null) {
        response = await request(getHeader(accessToken));
      }
    }

    return response;
  }

  Future<dynamic> commonGetRequest(
    String url, {
    dynamic Function(dynamic json)? fromJson,
  }) async {
    try {
      final response = await safeRequest((headers) {
        return http.get(
          Uri.parse(url),
          headers: headers,
        );
      }).timeout(const Duration(seconds: 60));

      log("STATUS CODE: ${response.statusCode}");
      log("RESPONSE BODY: ${response.body}");

      final responseJson = jsonDecode(response.body);

      // SUCCESS
      if (response.statusCode == 200 || response.statusCode == 201) {
        if (fromJson != null) {
          return fromJson(responseJson);
        }

        return responseJson;
      }

      // ERROR
      return parseError(responseJson);
    } catch (e) {
      checkConnectivity();
      log('Api error during GET request: $e');
    }

    return null;
  }
  //------------------Login---------------------------//

  Future<dynamic> login(Map<String, dynamic> data) async {
    try {
      final response = await http
          .post(
            Uri.parse(Urls.login),
            headers: getHeader(),
            body: jsonEncode(data),
          )
          .timeout(const Duration(seconds: 60));

      log("STATUS CODE: ${response.statusCode}");
      log("RESPONSE BODY: ${response.body}");

      final responseJson = jsonDecode(response.body) as Map<String, dynamic>;

      // SUCCESS
      if (response.statusCode == 200) {
        return LoginResponse.fromJson(responseJson);
      }

      // ERROR
      return parseError(responseJson);
    } catch (e) {
      checkConnectivity();
      log('Api error during login: $e');
    }

    return null;
  }

//------------------Google Login---------------------------//

  Future<dynamic> googleLogin(Map<String, dynamic> data) async {
    try {
      final response = await http
          .post(
            Uri.parse(Urls.googleLogin),
            headers: getHeader(),
            body: jsonEncode(data),
          )
          .timeout(const Duration(seconds: 60));

      log("STATUS CODE: ${response.statusCode}");
      log("RESPONSE BODY: ${response.body}");

      final responseJson = jsonDecode(response.body) as Map<String, dynamic>;

      // SUCCESS
      if (response.statusCode == 200) {
        return LoginResponse.fromJson(responseJson);
      }

      // ERROR
      return parseError(responseJson);
    } catch (e) {
      checkConnectivity();

      log('Api error during google login: $e');
    }

    return null;
  }

  //------------------Forgot password---------------------------//

  Future<dynamic> forgotPasswordRequest(Map<String, dynamic> data) async {
    try {
      final response = await http
          .post(
            Uri.parse(Urls.forgotPasswordRequest),
            headers: getHeader(),
            body: jsonEncode(data),
          )
          .timeout(const Duration(seconds: 60));

      log("STATUS CODE: ${response.statusCode}");
      log("RESPONSE BODY: ${response.body}");

      final responseJson = jsonDecode(response.body) as Map<String, dynamic>;

      // SUCCESS
      if (response.statusCode == 200 || response.statusCode == 201) {
        return true;
      }

      // ERROR
      return parseError(responseJson);
    } catch (e) {
      checkConnectivity();
      log('Api error during forgot password request: $e');
    }

    return null;
  }

  Future<dynamic> validateForgotPasswordToken(Map<String, dynamic> data) async {
    try {
      final response = await http
          .post(
            Uri.parse(Urls.forgotPasswordValidate),
            headers: getHeader(),
            body: jsonEncode(data),
          )
          .timeout(const Duration(seconds: 60));

      log("STATUS CODE: ${response.statusCode}");
      log("RESPONSE BODY: ${response.body}");

      final responseJson = jsonDecode(response.body) as Map<String, dynamic>;

      // SUCCESS
      if (response.statusCode == 200 || response.statusCode == 201) {
        return true;
      }

      // ERROR
      return parseError(responseJson);
    } catch (e) {
      checkConnectivity();
      log('Api error during token validation: $e');
    }

    return null;
  }

  Future<dynamic> forgotPasswordConfirm(Map<String, dynamic> data) async {
    try {
      final response = await http
          .post(
            Uri.parse(Urls.forgotPasswordConfirm),
            headers: getHeader(),
            body: jsonEncode(data),
          )
          .timeout(const Duration(seconds: 60));

      log("STATUS CODE: ${response.statusCode}");
      log("RESPONSE BODY: ${response.body}");

      final responseJson = jsonDecode(response.body) as Map<String, dynamic>;

      // SUCCESS
      if (response.statusCode == 200 || response.statusCode == 201) {
        return true;
      }

      // ERROR
      return parseError(responseJson);
    } catch (e) {
      checkConnectivity();
      log('Api error during password reset confirm: $e');
    }

    return null;
  }

//------------------Reset password---------------------------//

  Future<dynamic> passwordResetRequest(Map<String, dynamic> data) async {
    try {
      final response = await http
          .post(
            Uri.parse(Urls.passwordReset),
            headers: getHeader(),
            body: jsonEncode(data),
          )
          .timeout(const Duration(seconds: 60));

      log("STATUS CODE: ${response.statusCode}");
      log("RESPONSE BODY: ${response.body}");

      final responseJson = jsonDecode(response.body) as Map<String, dynamic>;

      // SUCCESS
      if (response.statusCode == 200 || response.statusCode == 201) {
        return responseJson["message"];
      }

      // ERROR
      return parseError(responseJson);
    } catch (e) {
      checkConnectivity();
      log('Api error during password reset request: $e');
    }

    return null;
  }

  Future<dynamic> resetPasswordConfirm(Map<String, dynamic> data) async {
    try {
      final response = await http
          .post(
            Uri.parse(Urls.resetPasswordConfirm),
            headers: getHeader(),
            body: jsonEncode(data),
          )
          .timeout(const Duration(seconds: 60));

      log("STATUS CODE: ${response.statusCode}");
      log("RESPONSE BODY: ${response.body}");

      final responseJson = jsonDecode(response.body) as Map<String, dynamic>;

      // SUCCESS
      if (response.statusCode == 200 || response.statusCode == 201) {
        return true;
      }

      // ERROR
      return parseError(responseJson);
    } catch (e) {
      checkConnectivity();
      log('Api error during reset password confirm: $e');
    }

    return null;
  }
//------------------User Details---------------------------//

  Future<dynamic> userDetails() async {
    try {
      final response = await http
          .get(
            Uri.parse(Urls.userDetails),
            headers: getHeader(),
          )
          .timeout(const Duration(seconds: 60));

      log("STATUS CODE: ${response.statusCode}");
      log("RESPONSE BODY: ${response.body}");

      final responseJson = jsonDecode(response.body) as Map<String, dynamic>;

      // SUCCESS
      if (response.statusCode == 200) {
        return Users.fromJson(responseJson);
      }

      // ERROR
      return parseError(responseJson);
    } catch (e) {
      checkConnectivity();

      log('Api error during user details: $e');
    }

    return null;
  }

//------------------Update---------------------------//

  Future<dynamic> updateUser(String id, Map<String, dynamic> data) async {
    try {
      final response = await safeRequest((headers) {
        return http.put(
          Uri.parse(Urls.editUserById(id)),
          headers: headers,
          body: jsonEncode(data),
        );
      }).timeout(const Duration(seconds: 60));

      log("STATUS CODE: ${response.statusCode}");
      log("RESPONSE BODY: ${response.body}");

      final responseJson = jsonDecode(response.body) as Map<String, dynamic>;

      // SUCCESS
      if (response.statusCode == 200 || response.statusCode == 201) {
        return Users.fromJson(responseJson);
      }

      // ERROR
      return parseError(responseJson);
    } catch (e) {
      checkConnectivity();
      log('Api error during updateUser: $e');
    }

    return null;
  }

  Future<bool> updateRegistrationFee(int value) async {
    try {
      final response = await safeRequest((headers) {
        return http.post(
          Uri.parse(Urls.registrationFee),
          headers: getHeader(),
          body: jsonEncode({'value': value}),
        );
      }).timeout(const Duration(seconds: 60));

      log("STATUS CODE: ${response.statusCode}");
      log("RESPONSE BODY: ${response.body}");

      return response.statusCode == 200 || response.statusCode == 201;
    } catch (e) {
      checkConnectivity();
      log('Api error during updateRegistrationFee: $e');
      return false;
    }
  }

  Future<bool> updateFactorValue(int value) async {
    try {
      final response = await safeRequest((headers) {
        return http.post(
          Uri.parse(Urls.starFactor),
          headers: getHeader(),
          body: jsonEncode({'factor_value': value}),
        );
      });

      return response.statusCode == 200 || response.statusCode == 201;
    } catch (e) {
      log('API error: $e');
      return false;
    }
  }

  Future<bool> updateTax(bool? isEnabled, String? taxType, int? value) async {
    try {
      final response = await safeRequest((headers) {
        return http.post(
          Uri.parse(Urls.salaryInvoiceTaxSettings),
          headers: getHeader(),
          body: jsonEncode({
            'is_enabled': isEnabled,
            'tax_type': taxType,
            'tax_value': value
          }),
        );
      });

      return response.statusCode == 200 || response.statusCode == 201;
    } catch (e) {
      log('API error: $e');
      return false;
    }
  }

  Future<Syllabus?> addSyllabus(String? name) async {
    try {
      final response = await safeRequest((headers) {
        return http.post(
          Uri.parse(Urls.syllabuses),
          headers: getHeader(),
          body: jsonEncode({'name': name}),
        );
      });

      if (response.statusCode == 200 || response.statusCode == 201) {
        final json = jsonDecode(response.body);
        return Syllabus.fromJson(json);
      }

      return null;
    } catch (e) {
      log('API error: $e');
      return null;
    }
  }

  Future<bool> updateSyllabus(String id, String? name) async {
    try {
      final response = await safeRequest((headers) {
        return http.put(
          Uri.parse(Urls.syllabusById(id)),
          headers: getHeader(),
          body: jsonEncode({'name': name}),
        );
      });

      return response.statusCode == 200 || response.statusCode == 201;
    } catch (e) {
      log('API error: $e');
      return false;
    }
  }

  Future<bool> deleteSyllabus(String id) async {
    try {
      final response = await safeRequest((headers) {
        return http.delete(
          Uri.parse(Urls.syllabusById(id)),
          headers: getHeader(),
        );
      });

      return response.statusCode == 200 ||
          response.statusCode == 201 ||
          response.statusCode == 204;
    } catch (e) {
      log('API error: $e');
      return false;
    }
  }

  Future<Syllabus?> addCourse(String? name) async {
    try {
      final response = await safeRequest((headers) {
        return http.post(
          Uri.parse(Urls.courses),
          headers: getHeader(),
          body: jsonEncode({'name': name}),
        );
      });

      if (response.statusCode == 200 || response.statusCode == 201) {
        final json = jsonDecode(response.body);
        return Syllabus.fromJson(json);
      }

      return null;
    } catch (e) {
      log('API error: $e');
      return null;
    }
  }

  Future<bool> updateCourse(String id, String? name) async {
    try {
      final response = await safeRequest((headers) {
        return http.put(
          Uri.parse(Urls.courseById(id)),
          headers: getHeader(),
          body: jsonEncode({'name': name}),
        );
      });

      return response.statusCode == 200 || response.statusCode == 201;
    } catch (e) {
      log('API error: $e');
      return false;
    }
  }

  Future<bool> deleteCourse(String id) async {
    try {
      final response = await safeRequest((headers) {
        return http.delete(
          Uri.parse(Urls.courseById(id)),
          headers: getHeader(),
        );
      });

      return response.statusCode == 200 ||
          response.statusCode == 201 ||
          response.statusCode == 204;
    } catch (e) {
      log('API error: $e');
      return false;
    }
  }

  Future<Syllabus?> addPackage(String? name) async {
    try {
      final response = await safeRequest((headers) {
        return http.post(
          Uri.parse(Urls.packageNames),
          headers: getHeader(),
          body: jsonEncode({'name': name}),
        );
      });

      if (response.statusCode == 200 || response.statusCode == 201) {
        final json = jsonDecode(response.body);
        return Syllabus.fromJson(json);
      }

      return null;
    } catch (e) {
      log('API error: $e');
      return null;
    }
  }

  Future<bool> updatePackage(String id, String? name) async {
    try {
      final response = await safeRequest((headers) {
        return http.put(
          Uri.parse(Urls.packageNameById(id)),
          headers: getHeader(),
          body: jsonEncode({'name': name}),
        );
      });

      return response.statusCode == 200 || response.statusCode == 201;
    } catch (e) {
      log('API error: $e');
      return false;
    }
  }

  Future<bool> deletePackage(String id) async {
    try {
      final response = await safeRequest((headers) {
        return http.delete(
          Uri.parse(Urls.packageNameById(id)),
          headers: getHeader(),
        );
      });

      return response.statusCode == 200 ||
          response.statusCode == 201 ||
          response.statusCode == 204;
    } catch (e) {
      log('API error: $e');
      return false;
    }
  }

  Future<Syllabus?> addCategory(String? name) async {
    try {
      final response = await safeRequest((headers) {
        return http.post(
          Uri.parse(Urls.categories),
          headers: getHeader(),
          body: jsonEncode({'name': name}),
        );
      });

      if (response.statusCode == 200 || response.statusCode == 201) {
        final json = jsonDecode(response.body);
        return Syllabus.fromJson(json);
      }

      return null;
    } catch (e) {
      log('API error: $e');
      return null;
    }
  }

  Future<bool> updateCategory(String id, String? name) async {
    try {
      final response = await safeRequest((headers) {
        return http.put(
          Uri.parse(Urls.categoryById(id)),
          headers: getHeader(),
          body: jsonEncode({'name': name}),
        );
      });

      return response.statusCode == 200 || response.statusCode == 201;
    } catch (e) {
      log('API error: $e');
      return false;
    }
  }

  Future<bool> deleteCategory(String id) async {
    try {
      final response = await safeRequest((headers) {
        return http.delete(
          Uri.parse(Urls.categoryById(id)),
          headers: getHeader(),
        );
      });

      return response.statusCode == 200 ||
          response.statusCode == 201 ||
          response.statusCode == 204;
    } catch (e) {
      log('API error: $e');
      return false;
    }
  }

  Future<Syllabus?> addStandard(String? name) async {
    try {
      final response = await safeRequest((headers) {
        return http.post(
          Uri.parse(Urls.standards),
          headers: getHeader(),
          body: jsonEncode({'name': name}),
        );
      });

      if (response.statusCode == 200 || response.statusCode == 201) {
        final json = jsonDecode(response.body);
        return Syllabus.fromJson(json);
      }

      return null;
    } catch (e) {
      log('API error: $e');
      return null;
    }
  }

  Future<bool> updateStandard(String id, String? name) async {
    try {
      final response = await safeRequest((headers) {
        return http.put(
          Uri.parse(Urls.standardById(id)),
          headers: getHeader(),
          body: jsonEncode({'name': name}),
        );
      });

      return response.statusCode == 200 || response.statusCode == 201;
    } catch (e) {
      log('API error: $e');
      return false;
    }
  }

  Future<bool> deleteStandard(String id) async {
    try {
      final response = await safeRequest((headers) {
        return http.delete(
          Uri.parse(Urls.standardById(id)),
          headers: getHeader(),
        );
      });

      return response.statusCode == 200 ||
          response.statusCode == 201 ||
          response.statusCode == 204;
    } catch (e) {
      log('API error: $e');
      return false;
    }
  }

  Future<Syllabus?> addSupportCategory(String? name) async {
    try {
      final response = await safeRequest((headers) {
        return http.post(
          Uri.parse(Urls.supportCategories),
          headers: getHeader(),
          body: jsonEncode({'name': name}),
        );
      });

      if (response.statusCode == 200 || response.statusCode == 201) {
        final json = jsonDecode(response.body);
        return Syllabus.fromJson(json);
      }

      return null;
    } catch (e) {
      log('API error: $e');
      return null;
    }
  }

  Future<bool> updateSupportCategory(String id, String? name) async {
    try {
      final response = await safeRequest((headers) {
        return http.put(
          Uri.parse(Urls.supportCategoryById(id)),
          headers: getHeader(),
          body: jsonEncode({'name': name}),
        );
      });

      return response.statusCode == 200 || response.statusCode == 201;
    } catch (e) {
      log('API error: $e');
      return false;
    }
  }

  Future<bool> deleteSupportCategory(String id) async {
    try {
      final response = await safeRequest((headers) {
        return http.delete(
          Uri.parse(Urls.supportCategoryById(id)),
          headers: getHeader(),
        );
      });

      return response.statusCode == 200 ||
          response.statusCode == 201 ||
          response.statusCode == 204;
    } catch (e) {
      log('API error: $e');
      return false;
    }
  }

  Future<Syllabus?> addReferralSource(String? name) async {
    try {
      final response = await safeRequest((headers) {
        return http.post(
          Uri.parse(Urls.referralSources),
          headers: getHeader(),
          body: jsonEncode({'name': name}),
        );
      });

      if (response.statusCode == 200 || response.statusCode == 201) {
        final json = jsonDecode(response.body);
        return Syllabus.fromJson(json);
      }

      return null;
    } catch (e) {
      log('API error: $e');
      return null;
    }
  }

  Future<bool> updateReferralSource(String id, String? name) async {
    try {
      final response = await safeRequest((headers) {
        return http.put(
          Uri.parse(Urls.referralSourceById(id)),
          headers: getHeader(),
          body: jsonEncode({'name': name}),
        );
      });

      return response.statusCode == 200 || response.statusCode == 201;
    } catch (e) {
      log('API error: $e');
      return false;
    }
  }

  Future<bool> deleteReferralSource(String id) async {
    try {
      final response = await safeRequest((headers) {
        return http.delete(
          Uri.parse(Urls.referralSourceById(id)),
          headers: getHeader(),
        );
      });

      return response.statusCode == 200 ||
          response.statusCode == 201 ||
          response.statusCode == 204;
    } catch (e) {
      log('API error: $e');
      return false;
    }
  }
  Future<AssessmentAttentionQns?> addAssessmentAttentionQn(String? name) async {
    try {
      final response = await safeRequest((headers) {
        return http.post(
          Uri.parse(Urls.assessmentQuestions),
          headers: getHeader(),
          body: jsonEncode({'value': name}),
        );
      });

      if (response.statusCode == 200 || response.statusCode == 201) {
        final json = jsonDecode(response.body);
        return AssessmentAttentionQns.fromJson(json);
      }

      return null;
    } catch (e) {
      log('API error: $e');
      return null;
    }
  }

  Future<bool> updateAssessmentAttentionQn(String id, String? name) async {
    try {
      final response = await safeRequest((headers) {
        return http.put(
          Uri.parse(Urls.assessmentQuestionById(id)),
          headers: getHeader(),
          body: jsonEncode({'value': name}),
        );
      });

      return response.statusCode == 200 || response.statusCode == 201;
    } catch (e) {
      log('API error: $e');
      return false;
    }
  }

  Future<bool> deleteAssessmentAttentionQn(String id) async {
    try {
      final response = await safeRequest((headers) {
        return http.delete(
          Uri.parse(Urls.assessmentQuestionById(id)),
          headers: getHeader(),
        );
      });

      return response.statusCode == 200 ||
          response.statusCode == 201;
    } catch (e) {
      log('API error: $e');
      return false;
    }
  }

  Future<bool> updateTerms({
    required String id,
    required String userType,
    required String content,
  }) async {
    try {
      final response = await safeRequest((headers) {
        return http.put(
          Uri.parse(Urls.termById(id)),
          headers: getHeader(),
          body: jsonEncode({
            "content": content,
            "user_type": userType,
          }),
        );
      });

      return response.statusCode == 200 || response.statusCode == 201;
    } catch (e) {
      log('API error: $e');
      return false;
    }
  }
  Future<bool> updateDeadline({
    required String id,
    required String role,
    required String deadlineType,
    required bool isActive,
    required int value,
  }) async {
    try {
      final response = await safeRequest((headers) {
        return http.put(
          Uri.parse(Urls.completionDeadlineSettingById(id)),
          headers: getHeader(),
          body: jsonEncode({
            "role": role,
            "deadline_type": deadlineType,
            "is_active": isActive,
            "value": value,
          }),
        );
      });

      return response.statusCode == 200 || response.statusCode == 201;
    } catch (e) {
      log('API error: $e');
      return false;
    }
  }

//------------------Settings---------------------------//

  Future<dynamic> getSupportTickets() async {
    return await commonGetRequest(Urls.supportTickets);
  }

  Future<dynamic> getRegistrationFee() async {
    return await commonGetRequest(Urls.registrationFee);
  }

  Future<dynamic> getStarFactor() async {
    return await commonGetRequest(Urls.starFactor);
  }

  Future<dynamic> getSupportCategories() async {
    return await commonGetRequest(Urls.supportCategories);
  }

  Future<dynamic> getSyllabuses() async {
    return await commonGetRequest(Urls.syllabuses);
  }

  Future<dynamic> getPackageNames() async {
    return await commonGetRequest(Urls.packageNames);
  }

  Future<dynamic> getPackageRecommendations() async {
    return await commonGetRequest(Urls.packageRecommendations);
  }

  Future<dynamic> getBatchRecommendations() async {
    return await commonGetRequest(Urls.batchRecommendations);
  }

  Future<dynamic> getAssessmentQuestions() async {
    return await commonGetRequest(Urls.assessmentQuestions);
  }

  Future<List<Assessment>> getAssessmentReportTypes() async {
    final response = await commonGetRequest(
      Urls.assessmentReportType,
    );

    return (response as List)
        .map(
          (e) => Assessment.fromJson(e),
        )
        .toList();
  }

  Future<dynamic> getBanners() async {
    return await commonGetRequest(Urls.banners);
  }

  Future<dynamic> getCategories() async {
    return await commonGetRequest(Urls.categories);
  }

  Future<dynamic> getCompletionDeadlineSettings() async {
    return await commonGetRequest(
      Urls.completionDeadlineSettings,
    );
  }

  Future<dynamic> getCoupons() async {
    return await commonGetRequest(Urls.coupons);
  }

  Future<dynamic> getCourses() async {
    return await commonGetRequest(Urls.courses);
  }

  Future<dynamic> getHiringAds() async {
    return await commonGetRequest(Urls.hiringAds);
  }

  Future<dynamic> getMaterials() async {
    return await commonGetRequest(Urls.materials);
  }

  Future<dynamic> getSalaryInvoiceTaxSettings() async {
    return await commonGetRequest(
      Urls.salaryInvoiceTaxSettings,
    );
  }

  Future<dynamic> getReferralSources() async {
    return await commonGetRequest(Urls.referralSources);
  }

  Future<dynamic> getStandards() async {
    return await commonGetRequest(Urls.standards);
  }

  Future<dynamic> getSupportMacros() async {
    return await commonGetRequest(Urls.supportMacros);
  }

  Future<dynamic> getTerms(String userType) async {
    return await commonGetRequest(Urls.termsByUserType(userType));
  }

  Future<dynamic> getPrivacyPolicies(String userType) async {
    return await commonGetRequest(Urls.privacyPolicyByUserType(userType));
  }

  Future<bool> updatePrivacyPolicies({
    required String id,
    required String userType,
    required String content,
  }) async {
    try {
      final response = await safeRequest((headers) {
        return http.put(
          Uri.parse(Urls.privacyPolicyById(id)),
          headers: getHeader(),
          body: jsonEncode({
            "content": content,
            "user_type": userType,
          }),
        );
      });

      return response.statusCode == 200 || response.statusCode == 201;
    } catch (e) {
      log('API error: $e');
      return false;
    }
  }

  Future<dynamic> getRefundPolicies(String userType) async {
    return await commonGetRequest(Urls.refundPolicyByUserType(userType));
  }

  Future<bool> updateRefundPolicies({
    required String id,
    required String userType,
    required String content,
  }) async {
    try {
      final response = await safeRequest((headers) {
        return http.put(
          Uri.parse(Urls.refundPolicyById(id)),
          headers: getHeader(),
          body: jsonEncode({
            "content": content,
            "user_type": userType,
          }),
        );
      });

      return response.statusCode == 200 || response.statusCode == 201;
    } catch (e) {
      log('API error: $e');
      return false;
    }
  }

  Future<dynamic> getNotifications() async {
    return await commonGetRequest(Urls.notifications);
  }

  Future<dynamic> globalRatingValues() async {
    try {
      final response = await http
          .get(
            Uri.parse(Urls.globalRatingValues),
            headers: getHeader(),
          )
          .timeout(const Duration(seconds: 60));

      log("STATUS CODE: ${response.statusCode}");
      log("RESPONSE BODY: ${response.body}");

      final responseJson = jsonDecode(response.body) as Map<String, dynamic>;

      // SUCCESS
      if (response.statusCode == 200) {
        return RatingValue.fromJson(responseJson);
      }

      // ERROR
      return parseError(responseJson);
    } catch (e) {
      checkConnectivity();

      log('Api error during global rating values: $e');
    }

    return null;
  }

  //------------------Logout---------------------------//

  Future<bool> logout() async {
    try {
      final response = await safeRequest((headers) {
        return http.post(
          Uri.parse(Urls.logout),
          headers: headers,
          body: jsonEncode({}),
        );
      }).timeout(const Duration(seconds: 60));

      log("STATUS CODE: ${response.statusCode}");
      log("RESPONSE BODY: ${response.body}");

      final responseJson = jsonDecode(response.body) as Map<String, dynamic>;

      // SUCCESS
      if (response.statusCode == 200 || response.statusCode == 201) {
        return true;
      }

      // ERROR
      log(parseError(responseJson).toString());
    } catch (e) {
      checkConnectivity();
      log('Api error during logout: $e');
    }

    return false;
  }
  //------------------Change Password---------------------------//

  // Future<GeneralResponse?> changePassword(Map<String, dynamic> data) async {
  //   try {
  //     final response = await http
  //         .post(Uri.parse(Urls.changePassword),
  //             body: jsonEncode(data), headers: await getHeader())
  //         .timeout(Duration(seconds: 60));

  //     if (checkValidations(response.body)) {
  //       final responseJson = jsonDecode(response.body) as Map<String, dynamic>;
  //       return GeneralResponse.fromJson(responseJson);
  //     }
  //   } catch (e) {
  //     checkConnectivity();
  //     log('Api error:$e');
  //   }
  //   return null;
  // }
}
