import 'dart:convert';
import 'dart:developer';
import 'dart:io';

import 'package:albedo_app/config/urls.dart';
import 'package:albedo_app/config/utils.dart';
import 'package:albedo_app/database/local_storage.dart';
import 'package:albedo_app/model/batch_model.dart';
import 'package:albedo_app/model/meet_model.dart';
import 'package:albedo_app/model/package_model.dart';
import 'package:albedo_app/model/payment_model.dart';
import 'package:albedo_app/model/session_model.dart';
import 'package:albedo_app/model/settings/assessment_model.dart';
import 'package:albedo_app/model/settings/banners_model.dart';
import 'package:albedo_app/model/settings/coupons_model.dart';
import 'package:albedo_app/model/settings/hiring_ad_model.dart';
import 'package:albedo_app/model/settings/material_model.dart';
import 'package:albedo_app/model/settings/notification_model.dart';
import 'package:albedo_app/model/settings/rating_value_model.dart';
import 'package:albedo_app/model/settings/recommendations_model.dart';
import 'package:albedo_app/model/settings/syllabus_model.dart';
import 'package:albedo_app/model/stu_wallet_model.dart';
import 'package:albedo_app/model/support_model.dart';
import 'package:albedo_app/model/users/advisor_model.dart';
import 'package:albedo_app/model/users/coordinator_model.dart';
import 'package:albedo_app/model/users/mentor_model.dart';
import 'package:albedo_app/model/users/other_users_model.dart';
import 'package:albedo_app/model/users/student_model.dart';
import 'package:albedo_app/model/users/teacher_model.dart';
import 'package:albedo_app/model/users/user_model.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
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

  Future<Notifications?> addNotification({
    required String title,
    required String message,
    required List<String> dashboardTarget,
    required bool isImportant,
  }) async {
    try {
      final response = await safeRequest((headers) {
        return http.post(
          Uri.parse(Urls.notifications),
          headers: getHeader(),
          body: jsonEncode({
            "title": title,
            "message": message,
            "dashboard_target": dashboardTarget,
            "is_important": isImportant,
          }),
        );
      });

      if (response.statusCode == 200 || response.statusCode == 201) {
        final json = jsonDecode(response.body);

        return Notifications.fromJson(json);
      }

      log(response.body);

      return null;
    } catch (e) {
      log('API error: $e');
      return null;
    }
  }

  Future<bool> updateNotification({
    required String id,
    required String title,
    required String message,
    required List<String> dashboardTarget,
    required bool isImportant,
  }) async {
    try {
      final response = await safeRequest((headers) {
        return http.put(
          Uri.parse(Urls.notificationById(id)),
          headers: getHeader(),
          body: jsonEncode({
            "title": title,
            "message": message,
            "dashboard_target": dashboardTarget,
            "is_important": isImportant,
          }),
        );
      });

      return response.statusCode == 200 || response.statusCode == 201;
    } catch (e) {
      log('API error: $e');
      return false;
    }
  }

  Future<bool> deleteNotification(String id) async {
    try {
      final response = await safeRequest((headers) {
        return http.delete(
          Uri.parse(Urls.notificationById(id)),
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

  Future<Ticket?> addTicket(String? name) async {
    try {
      final response = await safeRequest((headers) {
        return http.post(
          Uri.parse(Urls.supportTickets),
          headers: getHeader(),
          body: jsonEncode({'name': name}),
        );
      });

      if (response.statusCode == 200 || response.statusCode == 201) {
        final json = jsonDecode(response.body);
        return Ticket.fromJson(json);
      }

      return null;
    } catch (e) {
      log('API error: $e');
      return null;
    }
  }

  Future<bool> updateTicket(String id, String? name) async {
    try {
      final response = await safeRequest((headers) {
        return http.patch(
          Uri.parse(Urls.supportTicketById(id)),
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

  Future<bool> deleteTicket(String id) async {
    try {
      final response = await safeRequest((headers) {
        return http.delete(
          Uri.parse(Urls.supportTicketById(id)),
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

      return response.statusCode == 200 || response.statusCode == 201;
    } catch (e) {
      log('API error: $e');
      return false;
    }
  }

  Future<Assessment?> addAssessment({required Map<String, Object> body}) async {
    try {
      final response = await safeRequest((headers) {
        return http.post(
          Uri.parse(Urls.assessmentReportType),
          headers: getHeader(),
          body: jsonEncode(body),
        );
      });

      if (response.statusCode == 200 || response.statusCode == 201) {
        final json = jsonDecode(response.body);
        return Assessment.fromJson(json);
      }

      return null;
    } catch (e) {
      log('API error: $e');
      return null;
    }
  }

  Future<bool> updateAssessment(String id, Map<String, Object> body) async {
    try {
      final response = await safeRequest((headers) {
        return http.put(
          Uri.parse(Urls.assessmentReportTypeById(id)),
          headers: getHeader(),
          body: jsonEncode(body),
        );
      });

      return response.statusCode == 200 || response.statusCode == 201;
    } catch (e) {
      log('API error: $e');
      return false;
    }
  }

  Future<bool> deleteAssessment(String id) async {
    try {
      final response = await safeRequest((headers) {
        return http.delete(
          Uri.parse(Urls.assessmentReportTypeById(id)),
          headers: getHeader(),
        );
      });

      return response.statusCode == 200 || response.statusCode == 201;
    } catch (e) {
      log('API error: $e');
      return false;
    }
  }

  Future<Materials?> addMaterial({required Map<String, Object?> body}) async {
    try {
      final response = await safeRequest((headers) {
        log(jsonEncode(body));
        return http.post(
          Uri.parse(Urls.materials),
          headers: getHeader(),
          body: jsonEncode(body),
        );
      });
      log('STATUS CODE: ${response.statusCode}');
      log('RESPONSE BODY: ${response.body}');

      if (response.statusCode == 200 || response.statusCode == 201) {
        final json = jsonDecode(response.body);
        return Materials.fromJson(json);
      }

      return null;
    } catch (e) {
      log('API error: $e');
      return null;
    }
  }

  Future<bool> updateMaterial(String id, Map<String, Object?> body) async {
    try {
      final response = await safeRequest((headers) {
        return http.put(
          Uri.parse(Urls.materialById(id)),
          headers: getHeader(),
          body: jsonEncode(body),
        );
      });

      return response.statusCode == 200 || response.statusCode == 201;
    } catch (e) {
      log('API error: $e');
      return false;
    }
  }

  Future<bool> deleteMaterial(String id) async {
    try {
      final response = await safeRequest((headers) {
        return http.delete(
          Uri.parse(Urls.materialById(id)),
          headers: getHeader(),
        );
      });

      return response.statusCode == 200 || response.statusCode == 201;
    } catch (e) {
      log('API error: $e');
      return false;
    }
  }

  Future<RecommendationItem?> addPackageRecommendation(
      {required Map<String, Object?> body}) async {
    try {
      final response = await safeRequest((headers) {
        log(jsonEncode(body));
        return http.post(
          Uri.parse(Urls.packageRecommendations),
          headers: getHeader(),
          body: jsonEncode(body),
        );
      });
      log('STATUS CODE: ${response.statusCode}');
      log('RESPONSE BODY: ${response.body}');

      if (response.statusCode == 200 || response.statusCode == 201) {
        final json = jsonDecode(response.body);
        return RecommendationItem.fromJson(json);
      }

      return null;
    } catch (e) {
      log('API error: $e');
      return null;
    }
  }

  Future<bool> updateRecommendation(
      String id, Map<String, Object?> body) async {
    try {
      final response = await safeRequest((headers) {
        return http.put(
          Uri.parse(Urls.packageRecommendationById(id)),
          headers: getHeader(),
          body: jsonEncode(body),
        );
      });

      return response.statusCode == 200 || response.statusCode == 201;
    } catch (e) {
      log('API error: $e');
      return false;
    }
  }

  Future<bool> deleteRecommendation(String id) async {
    try {
      final response = await safeRequest((headers) {
        return http.delete(
          Uri.parse(Urls.packageRecommendationById(id)),
          headers: getHeader(),
        );
      });

      return response.statusCode == 200 || response.statusCode == 201;
    } catch (e) {
      log('API error: $e');
      return false;
    }
  }

  Future<RecommendationItem?> addBatchRecommendation(
      {required Map<String, Object?> body}) async {
    try {
      final response = await safeRequest((headers) {
        log(jsonEncode(body));
        return http.post(
          Uri.parse(Urls.batchRecommendations),
          headers: getHeader(),
          body: jsonEncode(body),
        );
      });
      log('STATUS CODE: ${response.statusCode}');
      log('RESPONSE BODY: ${response.body}');

      if (response.statusCode == 200 || response.statusCode == 201) {
        final json = jsonDecode(response.body);
        return RecommendationItem.fromJson(json);
      }

      return null;
    } catch (e) {
      log('API error: $e');
      return null;
    }
  }

  Future<bool> updateBatchRecommendation(
      String id, Map<String, Object?> body) async {
    try {
      final response = await safeRequest((headers) {
        return http.put(
          Uri.parse(Urls.batchPackageById(id)),
          headers: getHeader(),
          body: jsonEncode(body),
        );
      });

      return response.statusCode == 200 || response.statusCode == 201;
    } catch (e) {
      log('API error: $e');
      return false;
    }
  }

  Future<bool> deleteBatchRecommendation(String id) async {
    try {
      final response = await safeRequest((headers) {
        return http.delete(
          Uri.parse(Urls.batchPackageById(id)),
          headers: getHeader(),
        );
      });

      return response.statusCode == 200 || response.statusCode == 201;
    } catch (e) {
      log('API error: $e');
      return false;
    }
  }

  Future<HiringAd?> addHiringAd({required Map<String, Object?> body}) async {
    try {
      final response = await safeRequest((headers) {
        log(jsonEncode(body));
        return http.post(
          Uri.parse(Urls.hiringAds),
          headers: getHeader(),
          body: jsonEncode(body),
        );
      });
      log('STATUS CODE: ${response.statusCode}');
      log('RESPONSE BODY: ${response.body}');

      if (response.statusCode == 200 || response.statusCode == 201) {
        final json = jsonDecode(response.body);
        return HiringAd.fromJson(json);
      }

      return null;
    } catch (e) {
      log('API error: $e');
      return null;
    }
  }

  Future<bool> updateHiringAd(String id, Map<String, Object?> body) async {
    try {
      final response = await safeRequest((headers) {
        return http.put(
          Uri.parse(Urls.hiringAdById(id)),
          headers: getHeader(),
          body: jsonEncode(body),
        );
      });

      return response.statusCode == 200 || response.statusCode == 201;
    } catch (e) {
      log('API error: $e');
      return false;
    }
  }

  Future<bool> deleteHiringAd(String id) async {
    try {
      final response = await safeRequest((headers) {
        return http.delete(
          Uri.parse(Urls.hiringAdById(id)),
          headers: getHeader(),
        );
      });

      return response.statusCode == 200 || response.statusCode == 201;
    } catch (e) {
      log('API error: $e');
      return false;
    }
  }

  Future<Macro?> addMacro({required Map<String, Object?> body}) async {
    try {
      final response = await safeRequest((headers) {
        log(jsonEncode(body));
        return http.post(
          Uri.parse(Urls.supportMacros),
          headers: getHeader(),
          body: jsonEncode(body),
        );
      });
      log('STATUS CODE: ${response.statusCode}');
      log('RESPONSE BODY: ${response.body}');

      if (response.statusCode == 200 || response.statusCode == 201) {
        final json = jsonDecode(response.body);
        return Macro.fromJson(json);
      }

      return null;
    } catch (e) {
      log('API error: $e');
      return null;
    }
  }

  Future<bool> updateMacro(String id, Map<String, Object?> body) async {
    try {
      final response = await safeRequest((headers) {
        return http.put(
          Uri.parse(Urls.supportMacroById(id)),
          headers: getHeader(),
          body: jsonEncode(body),
        );
      });

      return response.statusCode == 200 || response.statusCode == 201;
    } catch (e) {
      log('API error: $e');
      return false;
    }
  }

  Future<bool> deleteMacro(String id) async {
    try {
      final response = await safeRequest((headers) {
        return http.delete(
          Uri.parse(Urls.supportMacroById(id)),
          headers: getHeader(),
        );
      });

      return response.statusCode == 200 || response.statusCode == 201;
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

  Future<Banners?> addBanner({required Map<String, Object> body}) async {
    try {
      final response = await safeRequest((headers) {
        return http.post(
          Uri.parse(Urls.banners),
          headers: getHeader(),
          body: jsonEncode(body),
        );
      });

      if (response.statusCode == 200 || response.statusCode == 201) {
        final json = jsonDecode(response.body);

        return Banners.fromJson(json);
      }

      log(response.body);

      return null;
    } catch (e) {
      log('API error: $e');
      return null;
    }
  }

  Future<bool> updateBannerAd(String bannerId, Map<String, Object> body) async {
    try {
      final response = await safeRequest((headers) {
        return http.put(
          Uri.parse(Urls.bannerById(bannerId)),
          headers: getHeader(),
          body: jsonEncode(body),
        );
      }).timeout(const Duration(seconds: 60));

      log("STATUS CODE: ${response.statusCode}");
      log("RESPONSE BODY: ${response.body}");

      return response.statusCode == 200 || response.statusCode == 201;
    } catch (e) {
      checkConnectivity();
      log('Api error during update banner ad: $e');
      return false;
    }
  }

  Future<bool> deleteBannerAd(String id) async {
    try {
      final response = await safeRequest((headers) {
        return http.delete(
          Uri.parse(Urls.bannerById(id)),
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

  Future<Coupons?> addCouponCode({required Map<String, Object?> body}) async {
    try {
      final response = await safeRequest((headers) {
        return http.post(
          Uri.parse(Urls.coupons),
          headers: getHeader(),
          body: jsonEncode(body),
        );
      });

      if (response.statusCode == 200 || response.statusCode == 201) {
        final json = jsonDecode(response.body);

        return Coupons.fromJson(json);
      }

      log(response.body);

      return null;
    } catch (e) {
      log('API error: $e');
      return null;
    }
  }

  Future<Coupons?> updateCouponCode(
    String codeId,
    Map<String, Object?> body,
  ) async {
    try {
      final response = await safeRequest((headers) {
        return http.put(
          Uri.parse(Urls.couponById(codeId)),
          headers: getHeader(),
          body: jsonEncode(body),
        );
      }).timeout(const Duration(seconds: 60));

      log("STATUS CODE: ${response.statusCode}");
      log("RESPONSE BODY: ${response.body}");

      final decoded = jsonDecode(response.body);

      return Coupons.fromJson(decoded);
    } catch (e) {
      checkConnectivity();

      log(
        'Api error during update coupon code: $e',
      );

      rethrow;
    }
  }

  Future<bool> deleteCouponCode(String id) async {
    try {
      final response = await safeRequest((headers) {
        return http.delete(
          Uri.parse(Urls.couponById(id)),
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

//------------------Students---------------------------//
  Future<List<Student>> getStudentList() async {
    final response = await commonGetRequest(Urls.studentsList);

    final List data = response['results'];

    return data.map((e) => Student.fromJson(e)).toList();
  }

  Future<Student> getStudentById(String id) async {
    final response = await commonGetRequest(
      Urls.studentById(id),
    );

    return Student.fromJson(response);
  }

  Future<List<Package>> getStudentPackagesById(String id) async {
    final response = await commonGetRequest(
      Urls.studentPackages(id),
    );

    return (response as List).map((e) => Package.fromJson(e)).toList();
  }

  Future<List<Batch>> getStudentBatchesById(String studentId) async {
    final response = await commonGetRequest(
      '${Urls.batchesList}?student=$studentId',
    );

    final results = response['results'] as List;

    return results
        .map((e) => Batch.fromJson(e as Map<String, dynamic>))
        .toList();
  }

  Future<StudentWallet> getStudentWalletById(String studentId) async {
    final url = '${Urls.userWallet}?profile_id=$studentId&profile_type=student';

    debugPrint('Wallet URL: $url');

    final response = await commonGetRequest(url);

    debugPrint('Wallet Response: $response');

    return StudentWallet.fromJson(response);
  }

//------------------Teachers---------------------------//
  Future<List<Teacher>> getTeacherList() async {
    final response = await commonGetRequest(Urls.teachersList);

    final List data = response['teachers'];

    return data.map((e) => Teacher.fromJson(e)).toList();
  }

  //------------------Students---------------------------//
  Future<List<Coordinator>> getCoordinatorList() async {
    try {
      final response = await commonGetRequest(Urls.assistants);

      return (response as List)
          .map(
            (e) => Coordinator.fromJson(e),
          )
          .toList();
    } catch (e) {
      log(e.toString());
      return [];
    }
  }

//------------------Settings---------------------------//

  Future<List<Ticket>> getSupportTickets() async {
    final response = await commonGetRequest(Urls.supportTickets);

    final List data = response as List;

    return data.map((e) => Ticket.fromJson(e)).toList();
  }

  Future<dynamic> getRegistrationFee() async {
    return await commonGetRequest(Urls.registrationFee);
  }

  Future<dynamic> getStarFactor() async {
    return await commonGetRequest(Urls.starFactor);
  }

  Future<List<Syllabus>> getSupportCategories() async {
    final List<dynamic> data = await commonGetRequest(Urls.supportCategories);

    return data.map<Syllabus>((e) => Syllabus.fromJson(e)).toList();
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

  Future<dynamic> getBatches() async {
    return await commonGetRequest(Urls.batches);
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

  Future<dynamic> getTestType() async {
    return await commonGetRequest(Urls.testType);
  }

  Future<dynamic> getTerms(String userType) async {
    return await commonGetRequest(Urls.termsByUserType(userType));
  }

  Future<String?> backup(String email) async {
    try {
      final response = await safeRequest((headers) {
        return http.post(
          Uri.parse(Urls.dbBackup),
          headers: getHeader(),
          body: jsonEncode({
            "recipient_email": email,
          }),
        );
      });

      if (response.statusCode == 200 || response.statusCode == 201) {
        final json = jsonDecode(response.body);

        return json["message"];
      }

      log(response.body);

      return null;
    } catch (e) {
      log('API error: $e');
      return null;
    }
  }

  Future<PaginatedStudentPaymentResponse> getWalletStudentTransactions({
    required int page,
    required int pageSize,
    required String status,
  }) async {
    try {
      final response = await commonGetRequest(
        "${Urls.walletStudentTransactions}"
        "?paginate=true"
        "&page=$page"
        "&page_size=$pageSize"
        "&status=$status",
      );

      return PaginatedStudentPaymentResponse(
        count: response['count'] ?? 0,
        results: (response['results'] as List)
            .map(
              (e) => StudentPaymentModel.fromJson(e),
            )
            .toList(),
      );
    } catch (e) {
      log(e.toString());

      return PaginatedStudentPaymentResponse(
        count: 0,
        results: [],
      );
    }
  }

  Future<PaginatedStudentResponse> getStudentDetails({
    required String url,
    required int page,
    required int pageSize,
  }) async {
    try {
      final separator = url.contains('?') ? '&' : '?';
      final response = await commonGetRequest(
        "$url"
        "${separator}paginate=true"
        "&page=$page"
        "&page_size=$pageSize",
      );

      return PaginatedStudentResponse(
        count: response['count'] ?? 0,
        results: (response['results'] as List)
            .map(
              (e) => Student.fromJson(e),
            )
            .toList(),
      );
    } catch (e) {
      log(e.toString());

      return PaginatedStudentResponse(
        count: 0,
        results: [],
      );
    }
  }

  Future<PaginatedTeacherResponse> getTeacherDetails({
    required String url,
    required int page,
    required int pageSize,
  }) async {
    try {
      final separator = url.contains('?') ? '&' : '?';

      final response = await commonGetRequest(
        "$url"
        "${separator}paginate=true"
        "&page=$page"
        "&page_size=$pageSize",
      );

      return PaginatedTeacherResponse(
        count: response['count'] ?? 0,
        results: (response['results'] as List)
            .map(
              (e) => Teacher.fromJson(e),
            )
            .toList(),
      );
    } catch (e) {
      log(e.toString());

      return PaginatedTeacherResponse(
        count: 0,
        results: [],
      );
    }
  }

  Future<PaginatedMentorResponse> getMentorDetails({
    required String url,
    required int page,
    required int pageSize,
  }) async {
    try {
      final separator = url.contains('?') ? '&' : '?';

      final response = await commonGetRequest(
        "$url"
        "${separator}paginate=true"
        "&page=$page"
        "&page_size=$pageSize",
      );

      return PaginatedMentorResponse(
        count: response['count'] ?? 0,
        results: (response['results'] as List)
            .map(
              (e) => Mentor.fromJson(e),
            )
            .toList(),
      );
    } catch (e) {
      log(e.toString());

      return PaginatedMentorResponse(
        count: 0,
        results: [],
      );
    }
  }

  Future<PaginatedAdvisorResponse> getAdvisorDetails({
    required int page,
    required int pageSize,
  }) async {
    try {
      final response = await commonGetRequest(
        "${Urls.advisorsList}"
        "?paginate=true"
        "&page=$page"
        "&page_size=$pageSize",
      );

      return PaginatedAdvisorResponse(
        count: response['count'] ?? 0,
        results: (response['results'] as List)
            .map((e) => Advisor.fromJson(e))
            .toList(),
      );
    } catch (e) {
      log(e.toString());
      return PaginatedAdvisorResponse(count: 0, results: []);
    }
  }

  Future<PaginatedOtherUserResponse> getOtherUserDetails({
    required int page,
    required int pageSize,
  }) async {
    try {
      final response = await commonGetRequest(
        "${Urls.otherUsers}"
        "?paginate=true"
        "&page=$page"
        "&page_size=$pageSize",
      );

      return PaginatedOtherUserResponse(
        count: response['count'] ?? 0,
        results: (response['results'] as List)
            .map((e) => OtherUsers.fromJson(e))
            .toList(),
      );
    } catch (e) {
      log(e.toString());
      return PaginatedOtherUserResponse(count: 0, results: []);
    }
  }

  Future<PaginatedSessionResponse> getSessionDetails({
    required String category,
    String search = '',
    required int page,
    required int pageSize,
  }) async {
    try {
      final response = await commonGetRequest(
        "${Urls.classSchedulesStatus}"
        "?category=$category"
        "&search=$search"
        "&page=$page"
        "&page_size=$pageSize",
      );

      return PaginatedSessionResponse(
        count: response['count'] ?? 0,
        results: (response['results'] as List<dynamic>? ?? [])
            .map((e) => Session.fromJson(e))
            .toList(),
      );
    } catch (e) {
      log(e.toString());

      return PaginatedSessionResponse(
        count: 0,
        results: [],
      );
    }
  }

  Future<PaginatedBatchSessionResponse> getBatchSessionDetails({
    required String category,
    String search = '',
    required int page,
    required int pageSize,
  }) async {
    try {
      final response = await commonGetRequest(
        "${Urls.batchSchedulesStatus}"
        "?category=$category"
        "&search=$search"
        "&page=$page"
        "&page_size=$pageSize",
      );

      return PaginatedBatchSessionResponse(
        count: response['count'] ?? 0,
        results: (response['results'] as List<dynamic>? ?? [])
            .map((e) => BatchSession.fromJson(e))
            .toList(),
      );
    } catch (e) {
      log(e.toString());

      return PaginatedBatchSessionResponse(
        count: 0,
        results: [],
      );
    }
  }

  Future<List<Meet>> getMeetSessions() async {
    try {
      final response = await commonGetRequest(Urls.meetSessions);
      log("Response:$response");
      final List data = response;

      return data.map<Meet>((e) => Meet.fromJson(e)).toList();
    } catch (e) {
      log(e.toString());
      return [];
    }
  }

  Future<SessionDetail?> getSessionDetail(String id) async {
    try {
      final response = await commonGetRequest(
        Urls.classScheduleById(id),
      );

      log("Response: $response");

      return SessionDetail.fromJson(response);
    } catch (e, s) {
      log("SESSION DETAIL ERROR: $e");
      log(s.toString());
      return null;
    }
  }

  Future<BatchSessionDetail?> getBatchSessionDetail(String id) async {
    try {
      final response = await commonGetRequest(
        Urls.batchScheduleById(id),
      );

      log("Response: $response");

      return BatchSessionDetail.fromJson(response);
    } catch (e, s) {
      log("SESSION DETAIL ERROR: $e");
      log(s.toString());
      return null;
    }
  }

  Future<PaginatedTeacherPaymentResponse> getWalletTeacherTransactions({
    required int page,
    required int pageSize,
    required String status,
  }) async {
    final response = await commonGetRequest(
      "${Urls.teacherTransactions}"
      "?paginate=true"
      "&page=$page"
      "&page_size=$pageSize"
      "&status=$status",
    );

    return PaginatedTeacherPaymentResponse(
      count: response['count'] ?? 0,
      results: (response['results'] as List)
          .map((e) => TeacherPaymentModel.fromJson(e))
          .toList(),
    );
  }

  Future<List<BatchPaymentModel>> getBatchTransactions() async {
    try {
      final response = await commonGetRequest(Urls.batches);
      log("Response:$response");
      final List data = response;

      return data
          .map<BatchPaymentModel>((e) => BatchPaymentModel.fromJson(e))
          .toList();
    } catch (e) {
      log(e.toString());
      return [];
    }
  }

  Future<BatchListResponse> getStudentBatches({
    int page = 1,
    int pageSize = 10,
    required bool isLive,
  }) async {
    try {
      final response = await commonGetRequest(
        "${Urls.batchesList}"
        "?is_live=$isLive"
        "&page=$page"
        "&page_size=$pageSize"
        "&include_details=true",
      );

      log("Student Batches Response: $response");

      final List data = response['results'] ?? [];

      return BatchListResponse(
        count: response['count'] ?? 0,
        results: data.map<Batch>((e) => Batch.fromJson(e)).toList(),
      );
    } catch (e) {
      log(e.toString());

      return BatchListResponse(
        count: 0,
        results: [],
      );
    }
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

  Future<bool> bulkUploadFile({
    required File file,
    required String type,
  }) async {
    final request = http.MultipartRequest(
      "POST",
      Uri.parse(getBulkUrl(type)),
    );

    request.files.add(
      await http.MultipartFile.fromPath('file', file.path),
    );

    final response = await request.send();

    return response.statusCode == 200 || response.statusCode == 201;
  }

  String getBulkUrl(String type) {
    switch (type) {
      case 'student':
        return Urls.studentsBulkCreate;
      case 'mentor':
        return Urls.mentorsBulkCreate;
      default:
        return Urls.studentsBulkCreate;
    }
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

  Future<void> saveRatingValues(
    Map<String, dynamic> body,
  ) async {
    try {
      final response = await safeRequest((headers) {
        return http.post(
          Uri.parse(Urls.globalRatingValues),
          headers: getHeader(),
          body: jsonEncode(body),
        );
      });

      log("STATUS CODE: ${response.statusCode}");
      log("RESPONSE: ${response.body}");

      if (response.statusCode == 200 || response.statusCode == 201) {
        return;
      }
    } catch (e) {
      log(
        "Save rating values error: $e",
      );
    }
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
